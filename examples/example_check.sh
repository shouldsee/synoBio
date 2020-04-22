
use_local(){
echo -e "\n[use_local]"
local foo=bar
checkVars foo
}

use_normal(){
echo -e "\n[use_normal]"
foo=bar
checkVars foo
}

use_export(){
echo -e "\n[use_export]"
foo=bar
export foo
checkVars foo
}



use_local
use_normal
use_export
