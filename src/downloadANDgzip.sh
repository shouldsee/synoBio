#!/bin/bash
main(){
	local INDIR=$1
	local ODIR=`preprocessor.py $INDIR | tail -1`
	cd $ODIR 
	local F=`echo *.fastq`
	CMD="gzip -c <$F >${F}.gz"
	echo $CMD
	[[ $DRY -eq 1 ]] || eval $CMD

	echo $PWD/${F}.gz
}
main "$@"
