#!/bin/bash

file_name_start="/home/disk/eos12/hillmanb/scream/dyamond2/256x512/SCREAMv0.SCREAM-DY2.ne1024pg2.20201127.eam.h"
for i in {0..9}; do
	echo $file_name_start$i"*.nc"
    cdo cat $file_name_start$i"*.nc" "scream_h"$i".nc"
done

echo "Done."