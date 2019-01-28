#!/usr/bin/env bash
main(){
    local SELF
    SELF=`readlink -f ${BASH_SOURCE[0]}`
    SELFALI=$(bname $SELF)

    set -e ###exit on error

    #### Take a bam file, index and flagstat, followed by conversion to .bdg and .bw
    #### check util.sh::bamqc()  util.sh::bam2bigwig()

    local INPUT=$1
#     local NCORE=${2:-6}
    [[ -z "$NCORE" ]] && {         
        local DFT=3
        echo [DEFAULT] NCORE not set, default to $DFT
        NCORE=$DFT
        } #         && return 0    
    
    local ALI=$(bname $INPUT)

    local CMD="stringtie -p $NCORE --rf ${ALI}.bam -G $GTF -o ${ALI}.stringtie.gtf -A ${ALI}.stringtie.count &> ${ALI}.stringtie.log"   
    local MSG="Transcript assembly with $PROG"
    
    echo "===== Starting $MSG ====="
    {   
        T0=`datefloat`
        echo [CMD] $CMD
        [[ $DRY -eq 1 ]] || time `eval $CMD`
        DUR=$(echo $(datefloat) - $T0 | bc)
        echo ${BASH_SOURCE[0]},$DUR >>$ALI.time 
    }
    
    echo "===== Ending $MSG  ====="
}
main "$@"