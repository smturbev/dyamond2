#!/bin/bash
#SBATCH --job-name=cat
#SBATCH --partition=prepost
#SBATCH --mem=20GB
#SBATCH --ntasks=1
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cat%j.eo
#SBATCH --error=err_cat%j.eo

set -evx # verbose messages and crash message

# cdo -cat /scratch/b/b380883/dyamond2/ICON/GT/clivi*.nc /scratch/b/b380883/dyamond2/ICON/GT/GT_ICON_clivi_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/ICON/GT/clt*.nc /scratch/b/b380883/dyamond2/ICON/GT/GT_ICON_clt_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/ICON/GT/rlt*.nc /scratch/b/b380883/dyamond2/ICON/GT/GT_ICON_rltacc_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/NICAM/TWP/clivi*.nc /scratch/b/b380883/dyamond2/NICAM/TWP/TWP_clivi_NICAM_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/NICAM/TWP/rlut*.nc /scratch/b/b380883/dyamond2/NICAM/TWP/TWP_rlut_NICAM_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/NICAM/TWP/rsdt*.nc /scratch/b/b380883/dyamond2/NICAM/TWP/TWP_rsdt_NICAM_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/NICAM/TWP/rsut*.nc /scratch/b/b380883/dyamond2/NICAM/TWP/TWP_rsut_NICAM_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/GT/rsdt*.nc /scratch/b/b380883/dyamond2/GEOS/GT/GT_GEOS_rsdt_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/GT/rsut*.nc /scratch/b/b380883/dyamond2/GEOS/GT/GT_GEOS_rsut_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/GT/clt*.nc /scratch/b/b380883/dyamond2/GEOS/GT/GT_GEOS_clt_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/clt*.nc /scratch/b/b380883/dyamond2/UM/GT/GT_UM_clt_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/rlut*.nc /scratch/b/b380883/dyamond2/UM/GT/GT_UM_rlut_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/rsut*.nc /scratch/b/b380883/dyamond2/UM/GT/GT_UM_rsut_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/rsdt*.nc /scratch/b/b380883/dyamond2/UM/GT/GT_UM_rsdt_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/SCREAM/TWP/TWP_rst*.nc /scratch/b/b380883/dyamond2/SCREAM/TWP/TWP_SCREAM_rst_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/SCREAM/TWP/TWP_rlt*.nc /scratch/b/b380883/dyamond2/SCREAM/TWP/TWP_SCREAM_rlt_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/TWP/TWP_rlut*.nc /scratch/b/b380883/dyamond2/UM/TWP/TWP_UM_rlut_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/TWP/TWP_rsut*.nc /scratch/b/b380883/dyamond2/UM/TWP/TWP_UM_rsut_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/TWP/TWP_rsdt*.nc /scratch/b/b380883/dyamond2/UM/TWP/TWP_UM_rsdt_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/TWP/TWP_clivi*.nc /scratch/b/b380883/dyamond2/UM/TWP/TWP_UM_clivi_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_rlut*.nc /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_GEOS_rlut_20200130-20200303.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_rsut*.nc /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_GEOS_rsut_20200130-20200303.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_rsdt*.nc /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_GEOS_rsdt_20200130-20200303.nc
# cdo -cat /scratch/b/b380883/dyamond2/UM/TWP/TWP_clivi*.nc /scratch/b/b380883/dyamond2/UM/TWP/TWP_UM_clivi_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/ICON/TWP/clivi*.nc /scratch/b/b380883/dyamond2/ICON/TWP/TWP_ICON_clivi_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/ICON/TWP/clt*.nc /scratch/b/b380883/dyamond2/ICON/TWP/TWP_ICON_clt_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/ICON/TWP/rltacc*.nc /scratch/b/b380883/dyamond2/ICON/TWP/TWP_ICON_rltacc_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/ICON/TWP/rstacc*.nc /scratch/b/b380883/dyamond2/ICON/TWP/TWP_ICON_rstacc_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/ICON/TWP/rsutacc*.nc /scratch/b/b380883/dyamond2/ICON/TWP/TWP_ICON_rsutacc_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/GT/clivi*.nc /scratch/b/b380883/dyamond2/UM/GT/GT_UM_clivi_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_clivi*.nc /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_GEOS_clivi_20200130-20200303.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_clt*.nc /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_GEOS_clt_20200130-20200303.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_rlut*.nc /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_GEOS_rlut_20200130-20200303.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_clt*.nc /scratch/b/b380883/dyamond2/GEOS/TWP/TWP_GEOS_clt_20200130-20200303.nc
# cdo -cat /scratch/b/b380883/dyamond2/SCREAM/GT_clt*.nc /work/bb1153/b380883/GT/GT_SCREAM_clt_20200130-20200301.nc
# cdo -cat /sratch/b/b380883/dyamond2/clt_15min_NICAM*.nc /work/bb1153/b380883/GT/GT_NICAM_clt_20200130-20200301.nc
# cdo -cat /sratch/b/b380883/dyamond2/GT_clt_15min_SAM2*.nc /work/bb1153/b380883/GT/GT_SAM_clt_20200130-20200229.nc

echo "done"
