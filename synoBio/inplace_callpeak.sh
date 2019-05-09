
main(){
	IN=`readlink -f $1`
	DIR=`dirname $IN`;
	[[ -z "$CHIPREF" ]] && { echo CHIPREF not set; } && return 0
	{
		echo $DIR;
		cd $DIR;
		pipeline_macs2.sh $IN -c $CHIPREF ;
		cd $OLDPWD;
	}
}

echo CHIPREF=$CHIPREF
[[ $DRY -eq 1 ]] && exit 0
main "$@"
