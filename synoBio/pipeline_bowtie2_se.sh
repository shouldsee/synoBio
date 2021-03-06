#!/usr/bin/env bash
main(){
    local SELF
    SELF=`readlink -f ${BASH_SOURCE[0]}`
    SELFALI=$(bname $SELF)
    

    set -e ###exit on error

    #ADADIR="/home/Program_NGS_sl-pw-srv01/Trimmomatic-0.32/adapters"

    PROG=bowtie2


    T0=$(datefloat)
    MSG="single-end genomic alignment with bowtie2"
    echo "===== Starting $MSG ====="
    # echo "===== Ending $MSG  ====="

    read1=$1
    # read2=$2
    GIDX=$2
    local ALI=${3:-test}
    local NCORE=${4:-4}
#     local ALI=$ALI ####get global alias $ALI
    

    ##### Checking input format
    echo $read1
    read ALI1 ALI1 PHRED <<< $(check_PE $read1 $read1)
    #### Shared alias
#     ALI=${ALI1%_R1_*}
    echo Using $NCORE threads; echo $ALI; echo Phred quality version: $PHRED


    OPT="--threads $NCORE --no-mixed --no-discordant --no-unal -k2"
    CMD="$PROG -x $GIDX -U $read1 -S ${ALI}.sam $OPT" 

    echo $CMD
    time `$CMD &> ${ALI}.$PROG.log`

    #ln -f $PWD/${ali}.sam ../${ali}.sam
    #cd ..

    echo "===== Ending $MSG  ====="
    DUR=$(echo $(datefloat) - $T0 | bc)
    echo ${BASH_SOURCE[0]},$DUR >>$ALI.time

}
main "$@"
#$CMD test.out
