main()
{

    show_help(){
    echo "
        Usage:
        Input:
        Example:
    "
    }
    if [[ $# -eq 0 ]] ; then
        show_help
        exit 0
    fi
    local CMD
    local ODIR
    OPTIND=1
    while getopts "hc:o:t:" opt; do
        case "$opt" in
        h|\?)
            show_help
            exit 0
            ;;
	c) CMD="$OPTARG" ;;
	o) ODIR="$OPTARG" ;;
    l) LOG="$OPTARG" ;;
    t) NCORE=$OPTARG ;;
        esac
    done
    shift "$((OPTIND-1))"
    [ "${1:-}" = "--" ] && shift

local INDIR=$@
local CMD=${CMD:-"cp -vlrun -t $ODIR"}
local ODIR=${ODIR:-"backup"}
echo [CMD]=$CMD

echo [ODIR] saving to $ODIR
[[ -d "$ODIR" ]] || mkdir -p "$ODIR"
touch $ODIR/CHANGELOG
inotifywait -mr -e moved_to -e create -e modify -e delete $@ |
    while read LINE; do
	echo [ACTION] $LINE
	local ACT="$CMD $INDIR"
	echo $ACT
	eval $ACT
    done \
# | tee /dev/stdout 
}
# | (ts "[%d-%m-%y %H_%M_%S]" >>$ODIR/CHANGELOG)
# exit 0

# #https://stackoverflow.com/questions/39239379/add-timestamp-to-teed-output-but-not-original-output
# }
main "$@"
