### rename by sampleID for BlueBee downloads
ls -1d */ | parallel --gnu func_mover.sh getSampleID.py | tee move.sh

### normalise read counts into CPM
find /home/feng/syno3/PW_HiSeq_data/Download/Mapped/190RQ_flat -name "*counts.txt" | parallel --gnu func_inplaceRename.sh normalise_CPM.py {} tsv 

### CPM table for DIR
find `readlink -f "$DIR"` -name "*.tsv"  | xargs combineTPM.py --extract CPM >"$DIR/CPM_table.csv"
