######################################
#### Hand-coded environment variables
#### $GFF,$GTF,$IDX_HISAT,$GSIZE should have been defined before proceeds

####### Adapter FASTA

# ADADIR="/home/Program_NGS_sl-pw-srv01/Trimmomatic-0.32/adapters"
# export FA_ADAPTER_SE="$ADADIR/TruSeq3-SE.fa"
# export FA_ADAPTER_PE="$ADADIR/TruSeq3-PE-2.fa"

export GNAME="VACV-AY243312"
export REF=/home/feng/ref/VACV-AY243312

###### Genome annotation .gtf and .gff3 (optional)
export GTF=$(echo $REF/annotation/*.gtf)
export GFF=$(echo $REF/annotation/*.gff*)
export GSIZE="$REF/genome.sizes"
export FA_GENOME="$REF/genome.fa"

A=$(ls -1 $REF/sequence/bowtie2-build/* | grep .1.bt2 | grep -v rev)
export IDX_BOWTIE2=${A%.1.bt2}

###### HISAT2 index
A=$(ls -1 $REF/sequence/hisat2-build/* | grep .1.ht2 | grep -v rev)
export IDX_HISAT2=${A%.*.ht2}

export DB_MOTIF=" \
/home/feng/ref/motif/ARABD/ArabidopsisPBM_20140210.meme\
"
#/home/feng/ref/motif/CIS-BP/Brachypodium_distachyon.meme \

checkVars GNAME REF GSIZE FA_GENOME
#IDX_BOWTIE2 IDX_HISAT2 FA_GENOME #GFF 
export GLEN=`size2sum $GSIZE`

#### Hand-coded environment variables
######################################
