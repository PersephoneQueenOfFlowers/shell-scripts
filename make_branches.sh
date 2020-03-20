#!/bin/bash
#generates random branches for testing git automation scripts
cd ../ddins

for i in {1..100}
do
   git checkout -b 'branch_'$RANDOM
done

cd ../shell-scripts
