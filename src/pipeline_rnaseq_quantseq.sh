#!/usr/bin/env bash
# logRun(){
#     local CMD="$@"
#     echo "[CMD]$CMD" ; [[ $DRY -eq 1 ]] || eval "$CMD"
# }

### helpful reference
### https://github.com/tskalicky/pipelines/blob/3be1cd8d0401ce3b1e1e2499f1586911b48746ec/RNA-seq_TS/04v19_dedupl_align_Scerevisiae_kontam_PE_Dis3L2_SpikeIn.sh
set +x
FA_ADAPTERS="
/home/feng/repos/synotil/src/resources/polyA.fa
/home/feng/repos/synotil/src/resources/truseq_rna.fa.gz
"
STAR_INDEX_DIR="$REF/STAR_INDEX"
# ALIGNER="STAR"

main(){
    mkdir -p output/
    local MAIN_LOG=`readlink -f output/main.log`
#     LOGFILE
#     touch output/main.log
    local T00=`datefloat`
    {
        local SELF=`readlink -f ${BASH_SOURCE[0]}`
        local SELFALI=$(bname $SELF)

        local read1 read2 reads PAIRED NCORE
        NCORE=6
        PAIR=0
        source bb__argparse.sh "$@"
        shift "$((OPTIND-1))"

        #### declaring fileJson
        local FILEjson=$PWD/FILE-${GNAME}.json
        rm -f $FILEjson
        touch $FILEjson


        ######################################
        echo ==== Parse Input arguments
        {
            local DIR=$PWD
            local ALI1=`basename ${read1%.*}`
            local fqALI=${ALI1%_R1_*}
            local ALI=${fqALI}_${GNAME}
            local LOGFILE=${ALI}.${SELFALI}.log
            local CMD

        #         echo $ALI1; echo $ALI2; echo $ALI
            echo []Proposed alias ${ALI} ==
            echo []Logfile $LOGFILE
        }


        {
            #### adapter trimming
            local INFILE=`readlink -f $read1`
            local DIR=trimmed
            mkdir -p $DIR;
            cd $DIR

            local OUTFILE=trimmed/`basename ${INFILE%.*}_pass.fastq`
        #     local OUTFILE=
            source checkVars FA_ADAPTERS read1 \
                JARLIB ### for java libraries
            logRun bbduk.sh in=$INFILE out=$OUTFILE \
                threads=$NCORE \
                ref=`echo $FA_ADAPTERS | tr ' ' ','` \
                k=13 ktrim=r useshortkmers=t mink=5 qtrim=r trimq=10 minlength=20; 

            cp -lf $OUTFILE ..
            read1=`readlink -f $OUTFILE`
            cd ..

        }


        {
            mkdir -p fastqc; cd fastqc
            headqc ../trimmed/$INFILE 100k
            headqc ../trimmed/$OUTFILE 100k
            cd ..    
            util__fileDict.py --ofname=$FILEjson \
                --fastqc=fastqc/
        }

    #     [[ "$ALIGNER" -eq "STAR" ]] && 
        {

            ##### STAR alignment
            DIR=STAR
            mkdir -p $DIR;
            
            local OPTS=""
            if [[ -z "$GTF" ]]; then
                OPTS="$OPTS --quantMode GeneCounts \
--outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1"
            else
                :
            fi
            

            local FILEOPT="--readFilesIn $read1"
            logRun STAR $FILEOPT  --outFileNamePrefix $DIR/$ALI. --runThreadN $NCORE --genomeDir $STAR_INDEX_DIR \
             "$OPTS" \
            --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.1 --alignIntronMin 20 \
            --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMattributes NH HI NM MD \
            --outSAMtype BAM SortedByCoordinate ;\

            local bamFile=$DIR/$ALI.Aligned.sortedByCoord.out.bam


            cp -lfr $bamFile $ALI.bam
            cp -lf $DIR/$ALI.ReadsPerGene.out.tab .
            cp -lf $DIR/*.out .
            util__fileDict.py --ofname=$FILEjson \
                --bamFileFinal=$bamFile \
                --geneCoverage=$ALI.ReadsPerGene.out.tab
        }

        false && [[ "$ALIGNER" -eq "hisat2" ]]  && {
            ###### HISAT alignment
            logRun pipeline_hisat.sh $reads -a $ALI -t $NCORE $IDX_HISAT2
            assert "$? -eq 0" $LINENO "HISAT2 failed"    

            OPT="--threads $NCORE -m 4G"
            CMD="samtools view ${ALI}.sam $OPT -b -o ${ALI}.bam"
            logRun $CMD

        }

        ln -f $ALI.bam $ALI.orig.bam     

        OPT="--threads $NCORE -m 4G"
        logRun samtools sort $bamFile $OPT -o $ALI.sorted.bam
        util__fileDict.py --ofname=$FILEjson \
            --bamFileSorted=$ALI.sorted.bam \
            --bamFileFinal=$ALI.sorted.bam

        cat $FILEjson


        false && {
            CMD="java -XX:ParallelGCThreads=$NCORE -jar"
            CMD="$CMD $JARLIB/MarkDuplicates.jar"
            CMD="$CMD I=${ALI}.sorted.bam O=${ALI}.sorted.dedup.bam M=${ALI}.dupstat.log"
            CMD="$CMD REMOVE_DUPLICATES=true "
            logRun $CMD
            assert "$? -eq 0" $LINENO "Picard Deduplication failed"        

            ln -f ${ALI}.sorted.dedup.bam
            util__fileDict.py --ofname=$FILEjson \
                --bamFileDedup=${ALI}.sorted.dedup.bam
                --bamFileFinal=${ALI}.sorted.dedup.bam        
    #         ln -f ${ALI}.final.bam $ALI.bam

        }

        #### Re-alias 
        ln -f $ALI.sorted.bam $ALI.bam
        util__fileDict.py --ofname=$FILEjson \
            --bamFileFinal=$ALI.sorted.bam        


        source pipeline_bamqc.sh ${ALI}.bam $GSIZE $NCORE
        assert "$? -eq 0" $LINENO "BAMQC/conversion failed"    

    #     set -e
        {
            mkdir -p output/
            util__fileDict.py --ofname $FILEjson \
                --lines --show \
                | xargs cp -lrfv --parents -t output/
            cp -lfv STAR/*.out .
            cp -lfv *log *.out -t output/
            cp -afv $FILEjson -t output/
       }
    } | tee $MAIN_LOG

    grep output/main.log -e "[CMD]" > output/main.cmd
    
    #### time
    DUR=$(echo $(datefloat) - $T00 | bc)
    echo $SELF,$DUR >>$ALI.time     
    
    cat $FILEjson
    return 0
    
    {
    
        local FEAT
        GTF_keys=( $( head $GTF -n1000 | cut -f3 | sort | uniq ) )
        FEAT=""
        [[ -z "$FEAT" ]] &&  containsElement "gene" "${GTF_keys[@]}" && FEAT=gene
        [[ -z "$FEAT" ]] &&  containsElement "exon" "${GTF_keys[@]}" && FEAT=exon
        echo $FEAT
     }
    
    {
        logRun featureCounts -T $NCORE -t $FEAT -a $GTF -o $ALI.$FEAT.fctab $ALI.bam
        cat $ALI.$FEAT.fctab | cut -f1,7-8 > $ALI.$FEAT.count
        util__fileDict.py --ofname=$FILEjson \
            --rawCount=$ALI.$FEAT.tab        
    }
    
    cat $FILEjson

}



### run star

#From this point any further analysis can be applied.


main "$@"