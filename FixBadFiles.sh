#!/bin/bash
# 'FixBadFiles.sh'
#
# Use this to fix output files with no keys.
# Run 'CheckEntries.C' first (in root), which
# will generate a list of bad files.  Pass that
# list as an argument to this script.


# input / output
list=$1
lPath="./logs"
input="/projecta/projectdirs/starprod/embedding/JetEmbedding2012/pp200_EmbeddingOutput_COMPLETE/pp200_production_2012/pt2_3_100_20153801/P12id.SL12d/2012/"
output="$PWD/output/pt2_3/"
  
# various parameters
dStart=${#output}
rStart=$(expr $dStart + 4)
fStart=$(expr $rStart + 9)
oldEnd="matchWithEmc.root"
badEnd="badWithEmc.root"
dstEnd="MuDst.root"
gntEnd="geant.root"
newEnd="matchWithEmc.root"
logEnd="fix.log"


printf "\nReading in '$list'...\n"

for file in $(cat $list); do

  # determine day, run, and old filename
  day=$(echo ${file:$dStart:3})
  run=$(echo ${file:$rStart:8})
  old=$(echo ${file:$fStart})
  bad=$(echo ${old/$oldEnd/$badEnd})
  dst=$(echo ${old/$oldEnd/$dstEnd})
  gnt=$(echo ${old/$oldEnd/$gntEnd})
  new=$(echo ${old/$oldEnd/$newEnd})
  log=$(echo ${old/$oldEnd/$logEnd})

  # create new filenames and arguments
  iPath=$input$day"/"$run
  oPath=$output$day"/"$run
  oldPath=$oPath"/"$old
  badPath=$oPath"/"$bad
  dstPath=$iPath"/"$dst
  gntPath=$iPath"/"$gnt
  newPath=$oPath"/"$new
  logPath=$lPath"/"$log

  # generate new file
  if [ -a $oldPath ]; then
    mv $oldPath $badPath
    root4star -b -q bemcCalibMacro.C\(1000,\"$dstPath\",\"$newPath\",1,\"$gntPath\"\) > $logPath;
  fi

  printf "  Regenerated file '$file'\n"

done  # file loop


printf "Finished!\n\n"
