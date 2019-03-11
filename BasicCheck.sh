#!/bin/bash
folderName=$1
executble=$2
currentLocation=`pwd`
shift 2
cd $folderName
make >> /dev/null 2>&1
executMake=$?
if [ $executMake -ne 0 ]; then
echo Makefile did not found
echo 7
exit 7
fi

valgrind --leak-check=full --error-exitcode=1 >> /dev/null 2>&1 ./$executble $@ 
val=$?
erval=PASS
if [ $val -eq 1 ]; then
erval=FAIL
fi


valgrind --tool=helgrind --error-exitcode=1 >> /dev/null 2>&1 ./$executble
hel=$?
erhel=PASS
if [ $hel -eq 1 ]; then
erhel=FAIL
fi


echo "compilation," "Memory leaks," "Thread race"
echo  "   "PASS"       " $erval "        " $erhel

ans=0
if [ $val -eq 1 ] && [ $hel -eq 1 ]; then
ans=3
fi
if [ $val -ne 1 ] && [ $hel -eq 1 ]; then
ans=1
fi
if [ $val -eq 1 ] && [ $hel -ne 1 ]; then
ans=2
fi

echo $ans
exit $ans
