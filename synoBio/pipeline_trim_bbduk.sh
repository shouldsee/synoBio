
#### check the result with a browser
######## preparation for mapping
###go to fastq directory
cd fastq
### remove the adapter contamination, polyA read through, and low quality tails
for sample in runID*R1_001.fastq; 
do 
SAMPLE
main(){
local INFILE
local ARG_ADAPTER=`echo $FA_ADAPTER | tr ' ' ','`
bbduk.sh in=$INFILE out=$OUTFILE \
    ref=${ARG_ADAPTER} k=13 ktrim=r useshortkmers=t mink=5 qtrim=r trimq=10 minlength=20; 
/data/resources/polyA.fa.gz,/data/resources/truseq_rna.fa.gz
}

#!/usr/bin/env bash
main()
{
    local SELF
    SELF=`readlink -f ${BASH_SOURCE[0]}`
    SELFALI=$(bname $SELF)
    set -e ###exit on error



    read1=`readlink -f $1`
    NCORE=${2:-4}

    read ALI1 ALI1 PHRED <<< $(check_PE $read1 $read1)
    if [ "$PHRED"="solexa64" ]; then PHRED=phred64; fi
    ALI=${ALI1%_R1_*}

    echo Using $NCORE threads
    echo Phred quality version: $PHRED
    echo $FA_ADAPTER


    #### Paired-end routine
    OUTDIR=$PWD/trimmed
    mkdir -p $OUTDIR
    cd $OUTDIR


    SETTING="ILLUMINACLIP:${FA_ADAPTER_SE}:6:30:10"
    SETTING="$SETTING LEADING:3 TRAILING:3 MINLEN:36 SLIDINGWINDOW:4:15"
    CMD="trimmomatic SE -threads $NCORE -$PHRED $read1 ${ALI1}_pass.fastq $SETTING" 

    echo $CMD
    time `$CMD &> ${ALI}.runlog`

    ##### Link files for later
    ln -f $PWD/${ALI1}_pass.fastq ../${ALI1}.fastq
    # ln -f $PWD/${ALI2}_pass.fastq ../${ALI2}.fastq
    cd ..

    mkdir -p fastqc 
    cd fastqc
    routine_fastqc ../trimmed/${ALI1}_pass.fastq &
    routine_fastqc ../trimmed/${ALI1}_fail.fastq &
    # routine_fastqc ../trimmed/${ALI2}_pass.fastq &
    # routine_fastqc ../trimmed/${ALI2}_fail.fastq &
    cd ..

}
main "$@"