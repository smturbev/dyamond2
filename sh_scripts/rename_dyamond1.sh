#!/bin/bash
#SBATCH --job-name=dy1
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_dy1%j.eo
#SBATCH --error=err_dy1%j.eo

set -evx # verbose messages and crash message

dy1=/work/bb1153/b380883/TWP/dyamond1

# cdo -setname,rst -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_ARPNH-2.5km_nswrf_deacc_0.10deg.nc $dy1/TWP_ARP_rst_20160810-20160910.nc
# cdo -setname,rlt -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_ARPNH-2.5km_ttr_deacc_0.10deg.nc $dy1/TWP_ARP_rlt_20160810-20160910.nc
# cdo -setname,rlut -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_NICAM-3.5km_lwu_toa_0.10deg.nc $dy1/TWP_NICAM_rlut_20160810-20160910.nc
# cdo -setname,rsut -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_NICAM-3.5km_swu_toa_0.10deg.nc $dy1/TWP_NICAM_rsut_20160810-20160910.nc
# cdo -setname,rsdt -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_NICAM-3.5km_swd_toa_0.10deg.nc $dy1/TWP_NICAM_rsdt_20160810-20160910.nc
# cdo -setname,rst -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_SAM-4km_SWNTA_0.10deg.nc $dy1/TWP_SAM_rst_20160810-20160910.nc
# cdo -setname,rlt -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_SAM_LWNTA_0.10deg.nc $dy1/TWP_SAM_rlt_20160810-20160910.nc
# cdo -setname,rlut -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_UM-5km_rlut_0.10deg.nc $dy1/TWP_UM_rlut_20160810-20160910.nc
cdo -setname,rsdt -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_UM-5km_rsdt_0.10deg.nc $dy1/TWP_UM_rsdt_20160810-20160910.nc
cdo -setname,rsut -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $dy1/TWP_UM-5km_rsut_0.10deg.nc $dy1/TWP_UM_rsut_20160810-20160910.nc

# rm TWP_ARPNH-2.5km_nswrf_deacc_0.10deg.nc TWP_ARPNH-2.5km_ttr_deacc_0.10deg.nc TWP_NICAM-3.5km_lwu_toa_0.10deg.nc TWP_NICAM-3.5km_swd_toa_0.10deg.nc TWP_NICAM-3.5km_swu_toa_0.10deg.nc TWP_SAM-4km_SWNTA_0.10deg.nc TWP_SAM_LWNTA_0.10deg.nc TWP_UM-5km_rlut_0.10deg.nc 

echo "done"