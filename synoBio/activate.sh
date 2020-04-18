#!/bin/bash

called=$_
[[ $called != $0 ]] && echo "Script is being sourced" || echo "Script is being run"
echo "\$BASH_SOURCE ${BASH_SOURCE[0]}"
# echo "\$BASH_SOURCE ${BASH_SOURCE[*]}"
source /etc/profile
source /home/feng/.bash_profile
DIR=${BASH_SOURCE[0]%/*}

echo $DIR


DIR=$(readlink -f $DIR)

source ${DIR}/util.sh  ### this will add checkVars() and logRun() to environment.


export ENVDIR=${DIR%/*}
export JARLIB=$ENVDIR/jar
mkdir -p $JARLIB
echo Adding $ENVDIR to PATH
export PATH="$PATH:$DIR:$ENVDIR"

