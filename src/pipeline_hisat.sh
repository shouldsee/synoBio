#!/usr/bin/env bash
main(){

    local SELF=`readlink -f ${BASH_SOURCE[0]}`
    local SELFALI=$(bname $SELF)

    set -e ###exit on error

    #ADADIR="/home/Program_NGS_sl-pw-srv01/Trimmomatic-0.32/adapters"

    PROG=hisat2


    T0=$(datefloat)
    MSG="spliced alignment with HISAT2"
    echo "===== Starting $MSG ====="
    # echo "===== Ending $MSG  ====="
    
    #### kwargs
    local ALI=test
    local read1=""
    local read2=""
    local reads=""
    local NCORE
    source bb__argparse.sh "$@"
    shift "$((OPTIND-1))"
    
    #### positional
    local GIDX=$1

    echo Using $NCORE threads

    OPT="--threads $NCORE --no-mixed --rna-strandness RF --dta --fr"
    if [[ -n "$read2" ]]; then
        local CMD="$PROG -x $GIDX -S ${ALI}.sam $OPT -1 $read1 -2 $read2" 
    else
        local CMD="$PROG -x $GIDX -S ${ALI}.sam $OPT -U $read1"
    fi

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
