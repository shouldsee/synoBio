source /home/feng/envs/pipe/bin/activate
export NCORE=4
source config_Ath_TAIR10.sh

INDIR=/home/feng/data/syno3_PW/RNA-seq/Raw_data/testONLY/133R/S23/;

# ODIR=$PWD
ODIR=/home/feng/data/syno3_PW/RNA-seq/Raw_data/testONLY/output
mkdir -p $ODIR
# preprocessor.py $INDIR
for SCRIPT in pipeline_chipseq_se.sh pipeline_chipseq_pe.sh pipeline_rnaseq.sh 
do 
CMD="pipeline_mapper.sh -t$NCORE $INDIR $SCRIPT $ODIR"
echo [CMD]$CMD
eval "$CMD"
break
done
