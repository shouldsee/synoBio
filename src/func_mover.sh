main(){
	local command=$1
	local INFILE=$2
	local OFILE=`eval $command $INFILE`
	local CMD="mv $INFILE $OFILE"
	echo $CMD
}
main "$@"
