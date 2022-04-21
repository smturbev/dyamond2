#!/bin/bash
#SBATCH --job-name=itcz_nicam
#SBATCH --partition=prepost
#SBATCH --ntasks=1
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_n%j.eo
#SBATCH --error=err_n%j.eo

set -evx # verbose messages and crash message
module rm cdo
module load cdo/2.0.2-magicsxx-gcc64
cdo -V

PATH="/scratch/b/b380883/dyamond2/NICAM"

LON0=0
LON1=360
LAT0=-30
LAT1=10
LOC="ITCZ"

declare -a VarArray15min=(clivi rlut rsut rsdt) #clivi rlut

# 15 min vars
for v in "${VarArray15min[@]}"; do
    echo "var "$v
    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $PATH/$v"_GT_NICAM-3km_20200120-20200228.nc" $PATH/$v"_"$LOC"_NICAM-3km_20200120-20200228.nc" 
done