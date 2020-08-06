#!/bin/bash
# makebin-auto.sh - creates a self-extracting installer

# workspace is typically "target" and must contain the files to package in the installer including the setup script
workspace=$(cd `dirname $0`; pwd)
#exec=`$workspace/`
# installer name
#projectNameVersion=`basename "${workspace}"`
# where to save the installer (parent of directory containing files)
targetDir=`dirname "${workspace}"`
execDir=$workspace/exec
sourceDir=${1:-$workspace/import}
buildDir=$workspace/build
logDir=$workspace/logs
dateTag=`date "+%Y%m%d"`

makeself=`which makeself`
if [ -z "$makeself" ]; then
    echo "Missing makeself tool"
    exit 1
fi

if [ ! -d $logDir ];then 
    echo "mkdir logs directory "
    mkdir -p $workspace/logs
fi 

if [ ! -d "$sourceDir" ]; then
  echo "please put your script to $sourceDir "
  echo "Usage: $0 [path/to/file]"
  echo "Example: $0 $sourceDir"
  echo "The self-extracting installer a-$dateTag.bin would be created in $execDir"
  mkdir -p $workspace/import
  exit 1
fi

#if [ ! -d "$workspace" ]; then echo "Cannot find workspace '$workspace'"; exit 1; fi

if [ ! -d "$buildDir" ]; then 
    echo "[INFO] Create directory build" >> $logDir/build-$dateTag.log 
    mkdir $workspace/build 
fi

if [ ! -d "$execDir/$dateTag" ]; then
    echo "[INFO] Create directory exec$dateTag"  >> $logDir/build-$dateTag.log
    mkdir -p  $execDir/$dateTag
fi
# ensure all executable files in the target folder have the x bit set

#chmod +x $sourceDir/*.sh 

# check for the makeself tool
script=`ls $sourceDir/`
for i in $script;
do 
    echo "It's going to copy $sourceDir/$i to  $buildDir" >> $logDir/build-$dateTag.log
    mv -f  $sourceDir/$i $buildDir
    if [ -d $buildDir/$i ];then 
        projectName=`basename "$i"`
	if [ -f  $buildDir/$i/$i.sh ]; then  
	echo "[WARNING]The a directory  $i  will be packaged into a installer, when the binary is executed, the $i.sh script is executed" >> $logDir/build-$dateTag.log
	cd $buildDir/$i
        #CFLAGs=-static	shc -e 28/01/2023 -r -f ./$projectName.sh -o ./main
        shc -e 28/01/2023 -r -f ./$projectName.sh -o ./main
	chmod +x main
        $makeself --follow --nocomp "./" "$buildDir/${projectName}-$dateTag.bin" "buildup $projectName" ./main
	cd -
        if [ -d $execDir/$dateTag/$i ];then
            rm -rf $execDir/$dateTag/$i
        fi     
        mv -f $buildDir/* $execDir/$dateTag
        echo "find your binary in $execDir"
        echo "`date +%Y-%m-%d` `date +%R` build $i " >> $logDir/build-$dateTag.log        
        fi
    else		  
        projectNameVersion=`basename -s .sh "$i"`
	shc -e 28/01/2023 -r -f $buildDir/$projectNameVersion.sh -o $buildDir/$projectNameVersion-$dateTag.bin
	chmod +x $buildDir/$projectNameVersion-$dateTag.bin
        #$makeself --follow --nocomp "$buildDir" "$buildDir/${projectNameVersion}-$dateTag.bin" "buildup $projectNameVersion" ./$projectNameVersion
        mv -f $buildDir/* $execDir/$dateTag
        echo "find your binary in $execDir"
        echo "`date +%Y-%m-%d` `date +%R` build $i " >> $logDir/build-$dateTag.log
    fi
done
