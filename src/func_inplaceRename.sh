#!/bin/bash
## Usage:
## find /home/feng/syno3/PW_HiSeq_data/Download/Mapped/190RQ_flat -name "*counts.txt" \
##   | parallel --gnu func_inplaceRename.sh normalise_CPM.py {} tsv
main(){

    local FUNC=$1
    local INFILE=$2
    local EXT=${3:-tsv}
    local OFILE=${INFILE%.*}.${EXT}
    local CMD="$FUNC $INFILE >$OFILE"
    [[ $DRY -eq 1 ]] || eval $CMD
}
main "$@"