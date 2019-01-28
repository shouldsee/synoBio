

main(){
DEBUG=1
#OPTIND=`bb__argparse.sh "$@"`
local read1
local read2
local reads=""
. bb__argparse.sh "$@"
[[ $? -eq 0 ]] || echo failed
echo "read1=$read1"
echo "reads=$reads"
echo optind $OPTIND
echo test: "$@"
shift $((OPTIND-1))
}

main -1 test.fq -2 test.fq pos1 pos2
main -1 test.fq pos1 pos2
echo $?
