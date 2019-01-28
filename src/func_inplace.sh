#!/bin/bash
## Usage:
## find /home/feng/syno3/PW_HiSeq_data/Download/Mapped/190RQ_flat -name "*counts.txt" \
##   | parallel --gnu func_inplaceRename.sh normalise_CPM.py {} tsv
main(){

    local FUNC=$1
    local INFILE=$2
    local DIR=`dirname $INFILE`
    local CDIR=$PWD
    local CMD="\
    cd $DIR; \
    $FUNC `basename $INFILE` ;\
    cd $CDIR; \
    "
    echo $CMD
    [[ $DRY -eq 1 ]] || eval $CMD
}
main "$@"