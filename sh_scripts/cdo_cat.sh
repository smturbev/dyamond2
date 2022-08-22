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

TWP="/work/bb1153/b380883/TWP"
GT="/work/bb1153/b380883/GT"
scr="/scratch/b/b380883"

cdo -cat $scr/TWP_cli_3hr_ICON*.nc $TWP/TWP_3D_ICON_cli_20200130-20200228.nc
cdo -cat $scr/TWP_clw_3hr_ICON*.nc $TWP/TWP_3D_ICON_clw_20200130-20200228.nc
cdo -cat $scr/TWP_hus_3hr_ICON*.nc $TWP/TWP_3D_ICON_hus_20200130-20200228.nc
cdo -cat $scr/TWP_ta_3hr_ICON*.nc $TWP/TWP_3D_ICON_ta_20200130-20200228.nc
cdo -cat $scr/TWP_pa_3hr_ICON*.nc $TWP/TWP_3D_ICON_pa_20200130-20200228.nc

echo "done"
