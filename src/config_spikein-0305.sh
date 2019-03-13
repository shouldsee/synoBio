######################################
#### Hand-coded environment variables
#### $GFF,$GTF,$IDX_HISAT,$GSIZE should have been defined before proceeds

####### Adapter FASTA

# ADADIR="/home/Program_NGS_sl-pw-srv01/Trimmomatic-0.32/adapters"
# export FA_ADAPTER_SE="$ADADIR/TruSeq3-SE.fa"
# export FA_ADAPTER_PE="$ADADIR/TruSeq3-PE-2.fa"

export REF=/home/feng/ref/spikein-0305
export GNAME=`basename $REF`

###### Genome annotation .gtf and .gff3 (optional)
export GSIZE="$REF/genome.sizes"
export FA_GENOME="$REF/genome.fa"


checkVars GNAME REF GSIZE FA_GENOME
#IDX_BOWTIE2 IDX_HISAT2 FA_GENOME #GFF 
export GLEN=`size2sum $GSIZE`

#### Hand-coded environment variables
######################################
