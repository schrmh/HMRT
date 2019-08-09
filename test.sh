 dp0=$(dirname "$(readlink -fn "$0")")
 echo $dp0

if [ -n "$1" ]
then
      echo "\$var is empty"
else
            echo "\$var is NOT empty"
fi


cia=$(basename $1 .cia)
echo BASE $cia
ciaName=$dp0/$(basename $1 .cia)
expName="$ciaName"_edited
echo EXP $expName


echo "dirname    : `dirname $0`"

echo $1 |awk -F . '{print $NF}'
ext=$(echo  $1  | sed 's/.*\././')

if [ $ext == ".cia" ]
then
	echo "ext is cia"
else
	echo "ext is not cia"
fi


defIP=192.168.178.16
echo $defIP
