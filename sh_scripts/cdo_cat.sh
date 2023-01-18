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

# cdo -cat $scr/TWP_pr_15min_GEOS-3km*.nc /work/bb1153/b380883/TWP/TWP_GEOS_pr_20200120-20200228.nc
# cdo -cat $scr/TWP_pr_15min_SCREAM-3km*.nc /work/bb1153/b380883/TWP/TWP_SCREAM_pr_20200120-20200228.nc
# cdo -cat $scr/TWP_pr_15min_SHiELD-3km*.nc /work/bb1153/b380883/TWP/TWP_SHiELD_pr_20200120-20200228.nc
# cdo -cat $scr/TWP_pracc_15min_ICON*.nc /work/bb1153/b380883/TWP/TWP_ICON_pracc_20200120-20200228.nc
cdo -cat $scr/TWP_pr_15min_gSAM*.nc /work/bb1153/b380883/TWP/TWP_SAM_pr_20200120-20200228.nc


echo "done"
