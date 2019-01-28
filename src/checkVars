#!/bin/bash
main()
{
    for F in "$@";
    do
        FILE=${!F};
#         echo [FILE]=$FILE
#         [[ ! -z "$FILE" ]] || { echo $F variable not set ; exit 255 ; } 
        if [[ -z "$FILE" ]]; then echo $F variable not set; exit 255 ; fi
        echo [Test] $F=$FILE;
#         [[ -f "$FILE" ]] || [[ -d "$FILE" ]] || ls -l ${FILE}* || { echo "$F=$FILE does not exists!" ;  exit 255 ; }
        if [[ -f "$FILE" ]]; then 
            : 
        else
            if [[ -d "$FILE" ]]; then
                :
            else 
                ### try
                ls -l ${FILE}* &>/dev/null
                
                if [ $? -eq 0 ];then 
                    ls -l ${FILE}* | head -1
                    :
                else
                    echo "[INSPECT]$F=$FILE must NOT be a directory";
#                     echo "$F=$FILE does not exists!" ;  exit 255 ; 
                fi
            fi 
        fi
    done
}

main "$@"
# export -f checkVars