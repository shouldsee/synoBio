main()
{
local PROG=${1:-pipeline_chipseq_se.sh}
PROG=`readlink -f $PROG`
local BNAME=`basename $PROG`
rm -rf ./$BNAME
mkdir -p ./$BNAME/orig;

cd ./$BNAME/
	cp $PROG orig/
	bash $PROG
cd ..
}

main "$@"
