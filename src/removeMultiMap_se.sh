main(){	
	### [depend]s on deOrphan.py
	### Inplace
	local PROG=removeMultiMap
	local IN=$1
	#local INPLACE={2:-1}
	local ALI=`basename ${IN%.*}`
	local CMD="samtools view -hF 4 -S $IN | grep -v \"XS:i:\"  "
# 	local CMD="samtools view -hf 0x2 -S $IN | grep -v \"XS:i:\" "
	echo $CMD 1>&2
	[[ $DRY -eq 1 ]] ||  eval "$CMD" 
# 	[[ $DRY -eq 1 ]] ||  runWithTimeLog "$CMD" 
}
main "$@"
