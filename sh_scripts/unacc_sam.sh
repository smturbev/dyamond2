#!/bin/bash
#SBATCH --job-name=deltatsam
#SBATCH --partition=compute
#SBATCH --time=03:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_dtsam.eo
#SBATCH --error=err_dtsam1.eo

set -evx # verbose messages and crash message
module load nco

LOC="TWP"
FILE_PATH=/work/bb1153/b380883/GT
MODEL="ICONr0.25deg" #"SAM"
# declare -a RadFileArray=(rlt) # done: rlt rst
v="rsut"
# olr (J/m2 --> W/m2)
# for v in "${RadFileArray[@]}"; do
for f in /scratch/b/b380883/r0.25deg_TWP_${v}acc_15min_ICON-NWP*.nc; do
    fname=$(basename $f)
    out_file=/scratch/b/b380883/$LOC"_"$MODEL"_"$fname
    cdo -setname,$v -setunit,"W/m2" -divc,-900 -deltat $f $out_file
done

## ARP 
# cdo -divc,-900 $FILE_PATH/TWP_ARPr0.25deg_rlt900_20200130-20200228.nc $FILE_PATH/TWP_ARPr0.25deg_rlt_20200130-20200228.nc 
# cdo -divc,900 $FILE_PATH/TWP_ARPr0.25deg_rst900_20200130-20200228.nc $FILE_PATH/TWP_ARPr0.25deg_rst_20200130-20200228.nc 

## PR
# pr_in=$FILE_PATH/${LOC}_SAM_pracc_20200130-20200301.nc
# pr_out=$FILE_PATH/${LOC}_SAM_pr_20200130-20200301.nc

# # pr (mm --> mm/hr)
# cdo -mulc,4 -deltat $pr_in $pr_out
# ncatted -O -a standard_name,pracc,o,c,"precipitation_flux" -a long_name,pracc,o,c,"Surface Precip." -a units,pracc,o,c,"mm/hr" $pr_out
# ncrename -O -v pracc,pr $pr_out

# undo running mean in ICON dyamond1
