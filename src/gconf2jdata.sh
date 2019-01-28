main()
{
#	$CONFFILE
    set -e
    local GFF=$GTF.gff
    checkVars GTF GFF FA_GENOME GNAME
    mkdir -p $GNAME
    
	prepare-refseqs.pl --indexed_fasta $FA_GENOME --out $GNAME
    flatfile-to-json.pl --gff $GFF --out $GNAME --trackLabel GTF-annotation \
--trackType JBrowse/View/Track/CanvasFeatures    \
--config '
{"category" : "annotation", 
    }'
## "trackType": "JBrowse/View/Track/CanvasFeatures" get overwritten by --trackType 
    generate-names.pl --out $GNAME --incremental --workdir .tmp
    echo '
#### Adding pointer to shared.conf which is manually edited####
include += ../shared.conf
formatVersion = 1
' >> $GNAME/tracks.conf

#     json2conf.pl $GNAME/trackList.json >> $GNAME/tracks.conf

#     ln -sf `readlink -f $GTF` seq/transcripts.gtf
}
main "$@"

#ln -sf /home/feng/ref/Arabidopsis_thaliana_TAIR10/jb/data/ /home/feng/repos/jbrowse/Ath-TAIR10
#BAM=/home/feng/temp/192C/192C-S10-2018_10_29_17:16:59/PIF7-PIF7-MYC-LD-27C-ZT8_S10_Ath-TAIR10.bam

