#!/bin/bash
#SBATCH --job-name=deltat
#SBATCH --partition=compute
#SBATCH --time=03:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_dt.eo
#SBATCH --error=err_dt.eo

set -evx # verbose messages and crash message
# module load nco

LOC="TWP"
FILE_PATH=/work/bb1153/b380883
SCR=/scratch/b/b380883/
MODEL="ICON" #"SAM"
v="rlt" # e.g., rlt, rst

# olr (J/m2 --> W/m2)
f=${FILE_PATH}/$LOC/${LOC}_${MODEL}_${v}acc_20200130-20200228.nc
fname=$(basename $f)
out_file=${FILE_PATH}/${LOC}/${LOC}_${MODEL}_${v}_20200130-20200228.nc
# out_file=${f/acc}
cdo -setname,$v -setunit,"W/m2" -divc,-900 -deltat $f $out_file
# cdo -setname,$v -setunit,"kg m-2 s-1" -divc,900 -deltat $f $out_file

# #DYAMOND1
# cdo -setname,rlt -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 -divc,-900 /scratch/b/b380883/TWP/TWP_ARPNH-2.5km_ttr_deacc_0.10deg.nc /scratch/b/b380883/TWP/TWP_ARP_rlt_20160801-20160910.nc
# cdo -setname,rlt -setunit,"W/m2" -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 -divc,-3600 /scratch/b/b380883/TWP/TWP_ECMWF-4km_ttr_deacc_0.10deg.nc /scratch/b/b380883/TWP/TWP_IFS_rlt_20160801-20160910.nc
# cdo -setname,rst -setunit,"W/m2" -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 -divc,3600 /work/bb1153/b380883/dyamond1/TWP/TWP_ECMWF-4km_tsr_deacc_0.10deg.nc /scratch/b/b380883/TWP/TWP_IFS_rst_20160810-20160910.nc
# cdo -setname,rst -setunit,"W/m2" -seldate,2016-08-10T00:00:00,2016-09-10T00:00:00 -divc,900 -deltat /scratch/b/b380883/TWP_MPAS-3.75kmNew_acswnett_0.10deg.nc /work/bb1153/b380883/TWP/TWP_MPAS_rst_20160810-20160910.nc


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

echo "done"