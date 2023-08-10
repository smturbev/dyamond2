#!/bin/bash
#SBATCH --job-name=cat
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cat%j.eo
#SBATCH --error=err_cat%j.eo

set -evx # verbose messages and crash message

twp="/work/bb1153/b380883/TWP"
gt="/work/bb1153/b380883/GT"
scr="/scratch/b/b380883"

# cdo -cat $scr/TWP_wap_3hr_SCREAM-3km*.nc $twp/TWP_3D_SCREAM_wap_20200130-20200228.nc
cdo -cat $scr/TWP_wa_3hr_gSAM*.nc $twp/TWP_3D_SAM_wa_20200130-20200228.nc


echo "done" 
