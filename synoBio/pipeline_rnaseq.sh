#!/usr/bin/env bash
logRun(){
    local CMD="$@"
    echo "[CMD]$CMD" ; [[ $DRY -eq 1 ]] || eval "$CMD"
}


main(){

    #   local SELF=`readlink -f ${BASH_SOURCE[0]}`
    SELF=`readlink -f ${BASH_SOURCE[0]}
    local SELFALI=$(bname $SELF)
    
    # local read1 read2 reads PAIRED NCORE
    NCORE=6
    PAIR=0
    source bb__argparse.sh "$@"
    shift "$((OPTIND-1))"
    export read1
    export read2
    export reads
    export PAIRED
    export NCORE
    export SELF
    export LOGFILE
    
    ### Kind of weird here...
#     source $(dirname $SELF)/activate

    ######################################
    echo ==== Parse Input arguments
    {
        local DIR=$PWD
        local ALI1=`basename ${read1%.*}`
        local fqALI=${ALI1%_R1_*}
        local ALI=${fqALI}_${GNAME}
    #    local LOGFILE=${ALI}.${SELFALI}.log
        LOGFILE=${ALI}.${SELFALI}.log
        
    #         echo $ALI1; echo $ALI2; echo $ALI
        echo []Proposed alias ${ALI} ==
        echo []Logfile $LOGFILE
    }
    
    {
        echo "===== IMPORTANT VARS ====="
        checkVars GNAME read1 read2 SELF LOGFILE 
        echo "===== Genome Vars ====="
        checkVars GSIZE FA_ADAPTER_PE REF IDX_HISAT2 
        #checkVars GTF  GFF 
    } | tee -a $LOGFILE    

    ######################################
    echo ==== main program
    {
        T00=`datefloat`


        echo 'command,time(s)'>$ALI.time
        #######################



        ########### Starting pipeline
        if [[ -n "$read2" ]]; then
            logRun pipeline_trim_pe.sh $read1 $read2 $NCORE 
        else
            logRun pipeline_trim_se.sh $read1 $NCORE 
        fi
        assert "$? -eq 0" $LINENO "Trimmomatic/fastqc failed"
        
        logRun pipeline_hisat.sh $reads -a $ALI -t $NCORE $IDX_HISAT2
        assert "$? -eq 0" $LINENO "HISAT2 failed"

        logRun pipeline_samtools.sh ${ALI}.sam $NCORE
        assert "$? -eq 0" $LINENO "SAM2BAM/SORT failed"

        logRun pipeline_picard.sh ${ALI}.sorted.bam $NCORE
        assert "$? -eq 0" $LINENO "Picard Deduplication failed"

        logRun pipeline_bamqc.sh ${ALI}.bam $GSIZE $NCORE
        assert "$? -eq 0" $LINENO "BAMQC/conversion failed"

#         CMD="stringtie -p $NCORE --rf ${ALI}.bam -G $GTF -o ${ALI}.stringtie.gtf -A ${ALI}.stringtie.count &> ${ALI}.stringtie.log"
#         {   
#             T0=`datefloat`
#             echo $CMD
#             time `eval $CMD`
#             DUR=$(echo $(datefloat) - $T0 | bc)
#             ARR=($CMD); echo $(which ${ARR[0]}),$DUR >>$ALI.time 
#         }
        
        pipeline_stringtie.sh ${ALI}.bam $NCORE        
        assert "$? -eq 0" $LINENO "Stringtie failed"

        pipeline_cleanup.sh ${ALI} &>${ALI}.cleanup.log
        assert "$? -eq 0" $LINENO "Output/cleanup failed"
        

        DUR=$(echo $(datefloat) - $T00 | bc)
        echo $SELF,$DUR >>$ALI.time 

        echo "[$SELFALI]:OUTPUT has been deposited into $PWD/output"
        echo "[$SELFALI]: ...Ending..."
        echo ---- Main program
    }  &>> $LOGFILE
}
main "$@"
