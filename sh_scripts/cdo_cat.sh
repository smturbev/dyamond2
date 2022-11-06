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

# cdo -cat $scr/TWP_rltcs_15min_SCREAM*.nc $TWP/TWP_SCREAM_rltcs_20200130-20200228.nc
# cdo -cat $scr/TWP_rstcs_15min_SCREAM*.nc $TWP/TWP_SCREAM_rstcs_20200130-20200228.nc
# cdo -cat $scr/TWP_rlutcs_15min_GEOS*.nc $TWP/TWP_GEOS_rlutcs_20200130-20200228.nc
# cdo -cat $scr/TWP_rsutcs_15min_GEOS*.nc $TWP/TWP_GEOS_rsutcs_20200130-20200228.nc
# cdo -cat $scr/TWP_rltacc_1hr_IFS*.nc $scr/TWP_IFS_rltacc_20200120-20200228.nc
cdo -cat $scr/TWP_rltcsacc_1hr_IFS*.nc $scr/TWP_IFS_rltcsacc_20200120-20200228.nc
cdo -cat $scr/TWP_rstacc_1hr_IFS*.nc $scr/TWP_IFS_rstacc_20200120-20200228.nc
cdo -cat $scr/TWP_rstcsacc_1hr_IFS*.nc $scr/TWP_IFS_rstcsacc_20200120-20200228.nc
cdo -cat $scr/TWP_rsdtacc_1hr_IFS*.nc $scr/TWP_IFS_rsdtacc_20200120-20200228.nc

echo "done"
