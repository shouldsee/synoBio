#!/bin/bash
main() {
    set +e
    local ALI=${1%.bam}
    CMD="mkdir -p output ;\
    touch output/DESCRIPTION ;\
    ln -f -t output/ \
    *.log *.time  \
    *.count *.gtf \
    *.bw *.bdg \
    $ALI.orig.sorted.bam $ALI.bam $ALI.bai \
    fastqc/*.html
    "
    echo $CMD
    [[ $DRY -eq 1 ]] || eval $CMD
    set -e
}
main "$@"