#!/usr/bin/env bash
main(){
    local SELF
    SELF=`readlink -f ${BASH_SOURCE[0]}`
    SELFALI=`basename ${SELF%.*}`
    local BASE=$PWD

    # set -e
    ### Kind of weird here...
    source $(dirname $SELF)/activate

    
    ######################################
    echo ==== Parse Input arguments
    {
    
        local read1 read2 reads PAIRED NCORE
        NCORE=6
        PAIR=0
        source bb__argparse.sh "$@"
        shift "$((OPTIND-1))"
        
        
        re='^[0-9]+$'
        if ! [[ $NCORE =~ $re ]] ; then
           echo "[WARN]: Argument 2 is not a number, default to $DFT. :$NCORE" >&2; NCORE=$DFT
        fi

        DIR=$PWD
        ALI1=`basename ${read1%.*}`
    #     ALI2=$(bname $read2)
        local fqALI=${ALI1%_R1_*}
        local ALI=${fqALI}_${GNAME}
#         local ALI=${ALI}_${GNAME}
        
        LOGFILE=${ALI}.${SELFALI}.log
        echo []Proposed alias ${ALI} ==
        echo []Logfile $LOGFILE
        rm -f $LOGFILE; touch $LOGFILE
    }
    
    {
    echo "===== IMPORTANT VARS ====="
    checkVars read1 SELF LOGFILE 
    echo "===== Genome Vars ====="
    checkVars GSIZE FA_ADAPTER_SE REF IDX_BOWTIE2 GNAME
    #checkVars GTF  GFF 
    } | tee -a $LOGFILE

    ######################################
    echo ==== main program
    {
        T00=`datefloat`

        echo 'command,time(s)'>$ALI.time
        #######################

        ########### Starting pipeline
        mkdir -p fastqc; cd fastqc; headqc ../$read1 100k; cd ..

        pipeline_trim_se.sh $read1 $NCORE 
        assert "$? -eq 0" $LINENO "Trimmomatic/fastqc failed"

        local ALI=${fqALI}_${GNAME}
    #     pipeline_hisat.sh  $ALI1.fastq  $ALI2.fastq $IDX_HISAT $NCORE
        pipeline_bowtie2_se.sh  $ALI1.fastq $IDX_BOWTIE2 $ALI $NCORE
        assert "$? -eq 0" $LINENO "BOWTIE2 failed"
        
#         local ALI=${fqALI}_${GNAME}
        mkdir -p removeMultiMap;  
        mv ${ALI}.sam removeMultiMap/${ALI}.orig.sam; 
        cd removeMultiMap; removeMultiMap_se.sh ${ALI}.orig.sam >${ALI}.sam
        
#         local ALI=${fqALI}_${GNAME}
        pipeline_samtools.sh ${ALI}.orig.sam $NCORE
        assert "$? -eq 0" $LINENO "SAM2BAM/SORT failed"
        
#         local ALI=${fqALI}_${GNAME}
        pipeline_samtools.sh ${ALI}.sam $NCORE
        assert "$? -eq 0" $LINENO "SAM2BAM/SORT failed"
        
        ln ${ALI}{.orig,}.sorted.bam -t $BASE ; cd $BASE

#         pipeline_samtools.sh ${ALI}.sam $NCORE
#         assert "$? -eq 0" $LINENO "SAM2BAM/SORT failed"

#         local ALI=${fqALI}_${GNAME}
        pipeline_picard.sh ${ALI}.sorted.bam $NCORE
        assert "$? -eq 0" $LINENO "Picard Deduplication failed"

#         local ALI=${fqALI}_${GNAME}
        pipeline_bamqc.sh ${ALI}.bam $GSIZE $NCORE
        assert "$? -eq 0" $LINENO "BAMQC/conversion failed"



        pipeline_cleanup.sh ${ALI} &>${ALI}.cleanup.log
        assert "$? -eq 0" $LINENO "Output/cleanup failed"

        DUR=$(echo $(datefloat) - $T00 | bc)
        echo $SELF,$DUR >>$ALI.time 

        echo "[$SELFALI]:OUTPUT has been deposited into $PWD/output"
        echo "[$SELFALI]: ...Ending..."
        echo ---- Main program
    }  &> $LOGFILE
}
echo [MAIN]main "$@"
main "$@"