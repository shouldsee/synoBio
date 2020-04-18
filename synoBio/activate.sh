#!/bin/bash

called=$_
[[ $called != $0 ]] && echo "Script is being sourced" || echo "Script is being run"
echo "\$BASH_SOURCE ${BASH_SOURCE[0]}"
# echo "\$BASH_SOURCE ${BASH_SOURCE[*]}"
source /etc/profile  



DIR=${BASH_SOURCE[0]%/*}

echo $DIR


DIR=$(readlink -f $DIR)
export ENVDIR=${DIR%/*}          ### this should be a "*/bin" directory
export JARLIB=$ENVDIR/jar        ### "*/bin/jar"
echo   Adding $ENVDIR to PATH

source ${DIR}/util.sh            ### adding utilities like checkVars() and logRun() to environment.
source /home/feng/.bash_profile  ### modify $PATH to add hisat2, bowtie2 and other binaries to path
export PATH="$PATH:$DIR:$ENVDIR"
##### add more lines to specify paths for binaries

{
  which hisat2 || echo hisat2 not found
  which bowtie2 || echo bowtie2 not found
  #which trimmomatic  || echo trimmomatic not found
}
