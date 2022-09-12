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

cdo -cat $scr/r0.1deg_TWP_rst_15min_ARPEGE* $TWP/TWP_ARPr0.1deg_rst_20200130-20200228.nc
cdo -cat $scr/r0.1deg_TWP_rlt_15min_ARPEGE* $TWP/TWP_ARPr0.1deg_rlt_20200130-20200228.nc

# cdo -cat $scr/TWP_clt_15min_SHiELD*.nc $TWP/TWP_SHiELD_clt_20200130-20200228.nc
# cdo -cat $scr/TWP_clh_15min_SHiELD*.nc $TWP/TWP_SHiELD_clh_20200130-20200228.nc

# cdo -cat $scr/ne30pg2_ne1024pg2/*.nc /work/bb1153/b380883/gn_SCREAM_SOLIN_20200130-20200228.nc

echo "done"
