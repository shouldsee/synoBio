#!/bin/bash
## Usage: pipeline_motif.sh <query fasta/bed>
main()
{
    local SELF=${BASH_SOURCE}
    local SELF_ALI=`basename ${SELF%.*}`
    
    local IN=$1
    IN=`readlink -f $IN`
    local ALI=`basename ${IN%.*}`
    
    local FA
    
    case "$IN" in
    *.bed | *.tsv ) 
            # it's bed
            quickFasta $IN                
#             FA=${ALI}.fa 
            ;;
    *.fa | *.fasta)
#             FA=${ALI}.fa 
            ;;
    * )
            ;;
    esac    
    
    FA=${ALI}.fa 
    source checkVars FA
    
#     export DRY=1

    {    
        ODIR="PROG=${SELF_ALI//_/-}_IN=${ALI//_/-}"
        echo [ODIR]=$ODIR
        mkdir -p $ODIR; 
        cpLink $FA $ODIR;    
        cpLink $FA $ODIR/INPUT_FASTA;    
        cd $ODIR 
    }    
    
    {
        pipeline_ame.sh $FA
    }
    
#     export DRY=0
  
    
    {
        PROG=dreme
        OPT="-p $FA"
        ODIR=`cmd2dir $PROG $OPT`; mkdir -p $ODIR
        CMD="$PROG -oc $ODIR $OPT"
        echo $CMD
        [[ $DRY -eq 1 ]] || $CMD 2>&1 | tee $ODIR/${PROG}.log

        cd $ODIR
        cpLink dreme.html MAST-INPUT        
        routine_mast MAST-INPUT ../$FA
        tomtom MAST-INPUT $DB_MOTIF
        cd ..
    }    
    
    {
        PROG=meme
        OPT="-mod anr -dna -nmotifs 3 $FA"   #### default to use DNA alphabet
        ODIR=`cmd2dir $PROG $OPT`; mkdir -p $ODIR
        CMD="$PROG -oc $ODIR $OPT"
        echo $CMD
        [[ $DRY -eq 1 ]] || $CMD 2>&1 | tee $ODIR/${PROG}.log
        
        cd $ODIR
        cpLink meme.html MAST-INPUT        
        routine_mast MAST-INPUT ../$FA
        tomtom MAST-INPUT $DB_MOTIF
        cd ..
    }

     {
        PROG=glam2
        OPT="n $FA"
        ODIR=`cmd2dir $PROG $OPT`; mkdir -p $ODIR
        CMD="$PROG -O $ODIR $OPT"
        echo $CMD
        [[ $DRY -eq 1 ]] || $CMD 2>&1 | tee $ODIR/${PROG}.log

        cd $ODIR
        cpLink glam2.meme MAST-INPUT        
        routine_mast MAST-INPUT ../$FA
        tomtom MAST-INPUT $DB_MOTIF
        cd ..
    }      
    quickTargz . 
    cd ..    
}
main "$@"