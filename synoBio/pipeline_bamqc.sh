#!/usr/bin/env bash
bamqc(){
  ### QC a sorted, dedup bam
#   exit 0
#   type bamqc
#   set -x
  set -e
  local FILEjson=${FILEjson:-FILEDefault.json}
  BAM=$1
  ALI=${BAM%.bam}
  echo $ALI
  
  samtools sort $BAM -o $BAM.temp
  ln -f $BAM.temp $BAM
  
  samtools index $BAM $ALI.bai 
  pids[0]=$!
  samtools flagstat $BAM >$ALI.flagstat.log 
  pids[1]=$!
  for pid in ${pids[*]}; do
    wait $pid
  done  
  
  #### blacklist un-aligned scaffolds
  samtools idxstats $BAM \
  | awk -F$'\t' 'BEGIN {OFS = FS} $3!="0" {print $1,"0",$2}' \
  > ${ALI}_blacklist.bed
  
#     util__fileDict.py --ofname=$FILEjson \
#         --bamIndex=${ALI}_${NORM}.bw  
}

bam2bigwig() {
    local BAM=$1
    local NORM=${2:-RPKM}
    local GLEN=${3:-$GLEN}
    local ARGS=${4:-}
#     local NORM=${4:-RPKM}
#     ALI=$(bname $BAM)
    local ALI=${BAM%.bam}
    local FILEjson=${FILEjson:-FILEDefault.json}
    
    local CMD="bamCoverage $ARGS --normalizeUsing $NORM \
      --smoothLength 10 --binSize 10 -p ${NCORE:-1}  \
      -b $BAM -o ${ALI}_${NORM}.bw"
#     CMD="$CMD --skipNAs"
    [[ -z "$GLEN" ]] || CMD="$CMD --effectiveGenomeSize $GLEN" 
    echo $CMD 
    [[ $DRY -eq 1 ]] || {
        eval $CMD
        
        util__fileDict.py --ofname=$FILEjson \
            --bwFile=${ALI}_${NORM}.bw
    }
    
    
    #### -split argument is essential !!!
#     genomeCoverageBed -ibam $BAM -bg -split > $ALI.bdg 
#     bedGraphToBigWig $ALI.bdg $GSIZE $ALI.bw 
}

main(){
    local SELF
    SELF=`readlink -f ${BASH_SOURCE[0]}`
    SELFALI=$(bname $SELF)
    local FILEjson=${FILEjson:-FILEDefault.json}

    set -e ###exit on error
#     set -x
    #### Take a bam file, index and flagstat, followed by conversion to .bdg and .bw
    #### check util.sh::bamqc()  util.sh::bam2bigwig()
    INPUT=$1
    GSIZE=$2
    NCORE=${3:-1}

    T0=`datefloat`
    MSG="QC .dedup.bam and convert to .bdg .bw"
    echo "===== Starting $MSG ====="

#     type bamqc
    #ALI=$(bname $INPUT)
    local ALI=${INPUT%.bam}
    logRun bamqc $INPUT
    
    
#     time `eval $CMD` &  pid[0]=$!

    CMD="bam2bigwig $INPUT RPKM $GLEN"
    eval $CMD

    for p in ${pid[*]}
    do
        wait $p
    done

    echo "===== Ending $MSG  ====="
    DUR=$(echo $(datefloat) - $T0 | bc)
    echo ${BASH_SOURCE[0]},$DUR >>$ALI.time 
    
}
main "$@"