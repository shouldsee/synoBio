#!/bin/bash
bb__argparse(){
   local NAME=bb__argparse
   [[ -z "$DEBUG" ]] || echo "$NAME: $@"
    show_help(){
    echo "
        Usage:
        Input:
        Example:
    "
    }
    if [[ $# -eq 0 ]] ; then
        show_help
        exit 0
    fi
    OPTIND=1
    while getopts "h?pt:1:2:a:" opt; do
        case "$opt" in
        h|\?)
            show_help
            exit 0
            ;;
        1) read1=$OPTARG ;;
        2) read2=$OPTARG; [[ -z "$read2" ]] || PAIR=1;;
        a) ALIAS=$OPTARG; ALI=$ALIAS ;;
        p)
            PAIR=1
            ;;
        t) NCORE=$OPTARG ;;
        esac
    done
    shift "$((OPTIND-1))"
    [ "${1:-}" = "--" ] && shift
    [[ -z "$DEBUG" ]] ||  echo barg "$@" >&2
    
    if [[ ! -z "$read2" ]]; then
        reads="-1 $read1 -2 $read2"
        PAIRED=1
    else
        reads="-1 $read1"
        PAIRED=0
    fi


    return 0
}
bb__argparse "$@"
