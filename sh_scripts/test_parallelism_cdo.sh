#!/bin/bash
#SBATCH --job-name=test_parallelism
#SBATCH --partition=shared
#SBATCH --time=00:30:00
#SBATCH --mem=20GB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --error=err_twp%j.eo
#SBATCH --output=out_twp%j.eo

set -evx # verbose messages and crash message
f=/work/ka1081/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/15min/clivi/r1i1p1f1/2d/gn/clivi_15min_ICON-NWP-2km_DW-ATM_r1i1p1f1_2d_gn_20200120000000-20200120234500.nc
out=/scratch/b/b380883/
out_file0=$out/test0.nc
out_file1=$out/test1.nc
grid_file=/work/ka1081/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/icon_grid_0017_R02B10_G.nc

START=$(date +%s)
cdo -f nc -P 8 -sellonlatbox,143,153,-5,5 -setgrid,$grid_file $f $out_file0
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "parallelized $DIFF"
START=$(date +%s)
cdo -f nc -sellonlatbox,143,153,-5,5 -setgrid,$grid_file $f $out_file1
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "regular $DIFF"

