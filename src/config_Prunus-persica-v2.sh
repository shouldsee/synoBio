# %load /home/feng/repos/BrachyPhoton/pipeline_rnaseq/config_Bd21-3.sh
######################################
#### Hand-coded environment variables

####### Adapter FASTA
ADADIR="/home/feng/ref/adapters"
export FA_ADAPTER_SE="$ADADIR/TruSeq3-SE.fa"
export FA_ADAPTER_PE="$ADADIR/TruSeq3-PE-all.fa"

export GNAME="Prunus-persica-v2"
export REF=/home/feng/ref/Prunus_persica_v2

###### Genome annotation .gtf and .gff3 (optional)

# export GTF=$(echo $REF/annotation/*.gtf)
export GFF=$(echo $REF/annotation/*.gff3)

# export FA_GENOME="$REF/genome.fa"
export FA_GENOME=$(echo $REF/*.fasta)
export GSIZE=$(echo $REF/*.sizes)
# export GSIZE="$REF/genome.sizes"

A=$(ls -1 $REF/sequence/Bowtie2Index/* | grep .1.bt2 | grep -v rev)
export IDX_BOWTIE2=${A%.1.bt2}

###### HISAT2 index
# A=$(ls -1 $REF/sequence/HISAT2Index/* | head -1)
# export IDX_HISAT2=${A%.*.ht2}

#export DB_MOTIF=" \
#/home/feng/ref/motif/CIS-BP/Brachypodium_distachyon.meme \
#/home/feng/ref/motif/ARABD/ArabidopsisDAPv1.meme \
#/home/feng/ref/motif/ARABD/ArabidopsisPBM_20140210.meme"

# checkVars GTF GFF GSIZE FA_ADAPTER REF IDX_BOWTIE2
checkVars GSIZE FA_ADAPTER_SE FA_ADAPTER_PE REF IDX_BOWTIE2 \
    FA_GENOME GNAME \
#     IDX_HISAT2 GTF
    
#### Hand-coded environment variables
######################################
export GLEN=`size2sum $GSIZE`
