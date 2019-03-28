#!/usr/bin/env bash
main()
{
    local SELF
    SELF=`readlink -f ${BASH_SOURCE[0]}`
    SELFALI=$(bname $SELF)

    set -e
    #source /home/feng/envs/pipeline_Bd/bin/activate

    ###############
    #### ==== Parsing argument

    # Default variables:
    output_file=""
    PAIR=0
    NCORE=4
    local DOWNLOADED=0
    
    show_help(){
        echo "
    Usage:
        pipeline_mapper.sh [OPTIONS -p/-t] <INPUT_DIR> <pipeline_script> [OUTPUT_DIR] [THREADS]
    Arguments:
        <INPUT_DIR>    A directory containing the NGS data .fastq(.gz) to be processed
        <pipeline_script>    A script that aligns RNA-Seq or ChIP-seq.
        [OUTPUT_DIR] (default:$HOME/pipeline_output) Directory to ttore the output .bam .sam .time 
    Options:
        -p Process input-directory as containing paired-end reads
        -t INT   (default:4) Number of threads to run in parallel
    Examples:
        pipeline_mapper.sh /media/pw_synology3/PW_HiSeq_data/RNA-seq/Raw_data/testONLY/133R/BdPIFs-32747730/133E_23_DN-40235206 pipeline_chipseq.sh
        pipeline_mapper.sh -p /media/pw_synology3/PW_HiSeq_data/RNA-seq/Raw_data/testONLY/133R/BdPIFs-32747730/133E_23_DN-40235206 pipeline_rnaseq.sh $HOME/pipeline_output/test
        pipeline_mapper.sh -p -t 4 /media/pw_synology3/PW_HiSeq_data/RNA-seq/Raw_data/testONLY/133R/BdPIFs-32747730/133E_23_DN-40235206 pipeline_rnaseq.sh $HOME/pipeline_output/test
    To-Do:
        Try accepting .fastq(.gz) directly in the future
        "
    }

    if [[ $# -eq 0 ]] ; then
        show_help
        exit 0
    fi
    

    OPTIND=1         # Reset in case getopts has been used previously in the shell.
    while getopts "h?pt:d" opt; do
        case "$opt" in
        h|\?)
            show_help
            exit 0
            ;;
        p)  PAIR=1
            ;;
        t)  NCORE=$OPTARG
        d)  DOWNLOADED=1
        esac
    done
    shift $((OPTIND-1))
    [ "${1:-}" = "--" ] && shift
    #### ---- Parsing argument
    ###############

    ID=${1}
    PROG=${2:-pipeline_rnaseq.sh}
    OUTDIR=${3:-$HOME/pipeline_output}
    OUTDIR=${OUTDIR%/}
    # echo ID=$ID; echo PROG=$PROG; echo OUTDIR=$OUTDIR; exit 0;



    mkdir -p $OUTDIR
    {
        #### echo ==== Parsing arugments
        # e.g.: ID=./150R/Doro_150R_Doro_1-43239982
        ID=`readlink -f $ID`
        echo $ID; echo [PROGRAM]:$PROG;

    }

    {
        #### echo ==== Downloading fastq files
        mkdir -p $OUTDIR
        ARR=(`logRun preprocessor.py --autoNewDir 1 --moveRaw 1 $ID | tee -a bulk.log`)
    #     echo ${ARR[@]}
        TEMPDIR=${ARR[-1]}
        echo "[TEMPDIR]=$TEMPDIR"
    }

    {
        #### echo ==== Running pipeline    
        cd $TEMPDIR
        ls -lh .
        read OLDDIR < OLDDIR
        read FILEARG < FILEARG
        local CMD="$PROG -t $NCORE $FILEARG"
        echo [CMD]$CMD
        echo [FILE] $FILEARG
        eval "$CMD"
    }
#     return 0
    

    {
        #### echo ==== Uploading outputs
        OUTALI=${PROG%.*}/$OLDDIR

        INDIR=$PWD
        uploadOutput.sh $INDIR $OUTDIR/${PROG%.*}
#         read OUTALI< $INDIR/DATAACC
#         mkdir -p $OUTDIR/$OUTALI
# #         cp output/* $OUTDIR/$OUTALI
#         cpLink output/* $OUTDIR/$OUTALI
    }  
    cd ..
    echo "[FINISH]: Outputed to $OUTDIR/$OUTALI"
    
    #### Cache the scripts
    if [[ -n "$ORIGIN" ]]; then
        mkdir -p src
        find $ORIGIN/ -type f -not -name "*.ipynb" | xargs cp -t src
    else
        echo "[WARN] unable to find envVar \"ORIGIN\" and not caching the scripts"
    fi
    return 0
}
main "$@"
