main(){	
	### [depend]s on deOrphan.py
	### Inplace
	local PROG=removeMultiMap
	local IN=$1
	#local INPLACE={2:-1}
	local ALI=`basename ${IN%.*}`
	local CMD="samtools view -hf 0x2 -S $IN | grep -v \"XS:i:\"  | deOrphan.py > $ALI.filtered.sam"
	echo $CMD
	[[ $DRY -eq 1 ]] ||  runWithTimeLog "$CMD" 
}
main "$@"
