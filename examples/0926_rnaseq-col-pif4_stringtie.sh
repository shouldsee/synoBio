PROJ=rnaseq-col-pif4
find $PROJ/ -name "*_picard.bam" | tee $PROJ.index
export NCORE=3
parallel --gnu -j8 func_inplace.sh pipeline_stringtie.sh {} <rnaseq-col-pif4.index
