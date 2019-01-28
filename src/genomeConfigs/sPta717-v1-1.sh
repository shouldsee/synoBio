# %load /home/feng/repos/BrachyPhoton/pipeline_rnaseq/config_Bd21-3.sh
######################################
#### Hand-coded environment variables

####### Adapter FASTA
ADADIR="/home/feng/ref/adapters"
export FA_ADAPTER_SE="$ADADIR/TruSeq3-SE.fa"
export FA_ADAPTER_PE="$ADADIR/TruSeq3-PE-all.fa"

export REF=/home/feng/ref/sPta717-v1-1
###### Genome annotation .gtf and .gff3 (optional)
export GTF=$(echo $REF/annotation/*.gtf)
export GFF=$(echo $REF/annotation/*scaffold.genes.gff3)
export FA_GENOME="$REF/genome.fa"
export GSIZE="$REF/genome.sizes"

A=$(ls -1 $REF/sequence/Bowtie2Index/* | head -1)
export IDX_BOWTIE2=${A%%.*}

###### HISAT2 index
A=$(ls -1 $REF/sequence/HISAT2Index/* | head -1)
export IDX_HISAT2=${A%%.*}

#export DB_MOTIF=" \
#/home/feng/ref/motif/CIS-BP/Brachypodium_distachyon.meme \
#/home/feng/ref/motif/ARABD/ArabidopsisDAPv1.meme \
#/home/feng/ref/motif/ARABD/ArabidopsisPBM_20140210.meme"

# checkVars GTF GFF GSIZE FA_ADAPTER REF IDX_BOWTIE2
checkVars FA_GENOME GTF GSIZE FA_ADAPTER_SE FA_ADAPTER_PE REF IDX_BOWTIE2 \
#IDX_HISAT2 \

    
#### Hand-coded environment variables
######################################


export GLEN=`size2sum $GSIZE`
