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

# cdo -cat $scr/r0.1deg_TWP_rsutacc_15min_ICON*.nc /work/bb1153/b380883/TWP_ICONr0.1deg_rsutacc_20200130-20200228.nc
# cdo -cat $scr/r0.1deg_TWP_rsdt_15min_GEOS*.nc /work/bb1153/b380883/TWP_GEOSr0.1deg_rsdt_20200130-20200228.nc
# cdo -cat $scr/TWP_cli_3hr_UM-5km*.nc /work/bb1153/b380883/TWP_3D_UM_cli_20200130-20200228.nc


echo "done"
