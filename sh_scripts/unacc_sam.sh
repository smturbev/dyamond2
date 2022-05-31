#!/bin/bash
#SBATCH --job-name=deltatsam
#SBATCH --partition=prepost
#SBATCH --ntasks=1
#SBATCH --time=03:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_dtsam.eo
#SBATCH --error=err_dtsam.eo

set -evx # verbose messages and crash message
module load nco

LOC="TWP"

FILE_PATH=/scratch/b/b380883/dyamond2/SAM/$LOC

declare -a RadFileArray=(rlt rst)
# olr (J/m2 --> W/m2)
for v in "${RadFileArray[@]}"; do
    cdo -divc,900 -deltat $FILE_PATH/${LOC}_${v}acc_SAM_20200120-20200229.nc $FILE_PATH/${LOC}_SAM_${v}_20200120-20200229.nc
#     cdo -chname,rltacc,rlt -chunit,"J/m2","W/m2" $FILE_PATH/GT_SAM_${v}_20200120-20200229.nc $FILE_PATH/GT_SAM_${v}_20200120-20200229.nc
    ncatted -O -a standard_name,rltacc,o,c,"toa_net_downward_longwave_flux" -a long_name,rltacc,o,c,"Net LW at TOA" -a units,rltacc,o,c,"W/m2" $FILE_PATH/${LOC}_SAM_${v}_20200120-20200229.nc
    ncrename -O -v rltacc,rlt $FILE_PATH/${LOC}_SAM_${v}_20200120-20200229.nc
done

# pr_in=$FILE_PATH/SAM_pr_acc_winter_ITCZ.nc
# pr_out=$FILE_PATH/SAM_pr_winter_ITCZ.nc

# pr (mm --> mm/hr)
# cdo -mulc,4 -deltat $pr_in $pr_out
# ncatted -O -a standard_name,pracc,o,c,"precipitation_flux" -a long_name,pracc,o,c,"Surface Precip." -a units,pracc,o,c,"mm/hr" $pr_out
# ncrename -O -v pracc,pr $pr_out