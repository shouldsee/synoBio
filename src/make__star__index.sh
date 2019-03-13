mkdir -p $REF/STAR_INDEX
NCORE=10
STAR \
--runThreadN $NCORE \
--runMode genomeGenerate \
--genomeDir $REF/STAR_INDEX \
--genomeFastaFiles $FA_GENOME \
--sjdbGTFfile $GTF \
--sjdbOverhang 100
