#!/usr/bin/bash

# xxzh: 
# Commands that are complicated to edit on the CLI 
# are executed using this shell script.

echo "RUNNING ----------------------------"

mkdir 0x0021_Mul32U
touch 0x0021_Mul32U/README.md
mv 0x0021_MulBT32S 0x0022_MulBT32S 
rm 0x0022_MulWL32U

git add .
git commit -m 'Changing the file folder organization'
git push

echo "------------------------------- DONE"