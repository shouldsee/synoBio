#!/bin/bash
main(){
    local INDIR=${1%/}
    local OUTDIR=${2%/}
    read OUTALI< $INDIR/DATAACC
    mkdir -p $OUTDIR/$OUTALI
#         cp output/* $OUTDIR/$OUTALI
    cpLink -v $INDIR/output/* $OUTDIR/$OUTALI
}
main "$@"