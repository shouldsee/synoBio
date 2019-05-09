#!/bin/bash
main()
{
	[[ -z "$GSIZE" ]] && { echo GSIZE not set; } && return 0
    local PROG=macs2
    local SELF=${BASH_SOURCE}
    local SELF_ALI=`basename ${SELF%.*}`
    
    local BAM=$1  ### input bam file
#    GCOUNT=${2:-`size2sum $GSIZE`} ### lenght of your genome
    GCOUNT=`size2sum $GSIZE` ### lenght of your genome
    OPT="${@:2}"
    ALI=`basename ${BAM%.*}`
    CMD="macs2 callpeak $OPT --keep-dup 1 -p 0.1 -t $BAM  -n $ALI -g $GCOUNT "    
    runWithTimeLog "$CMD" | tail -1 >> ${ALI}.time
}
main "$@"
