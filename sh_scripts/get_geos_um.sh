#!/bin/bash
#SBATCH --job-name=sub_gui
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_gui%j.eo
#SBATCH --error=err_gui%j.eo

set -evx # verbose messages and crash message

LON0=143
LON1=153
LAT0=-5
LAT1=5
LOC="TWP_3D"

IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/NASA/GEOS-3km/DW-ATM/atmos
# IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/MetOffice/UM-5km/DW-ATM/atmos
# IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/METEOFR/ARPEGE-NH-2km/DW-ATM/atmos
OUT_PATH=/scratch/b/b380883

# IFS: clt clh clivi clwvi prw ta qgvi qsvi qrvi rlt rst pr
# declare -a VarArray15min=(clt clh clivi clwvi prw ta qgvi qsvi qrvi rlt rst pr)

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/15min/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/${LOC}_$fname
        # cdo sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file 
    done
done

declare -a VarArray3D=(hus) 
#GEOS: reffcli zg cl snowmxrat rainmxrat grplmxrat cl phalf pfull cl cli clw ta hus)
declare -a DateArray=(219 220 221 222 223 224 225 226 227 228)

for v in "${VarArray3D[@]}"; do
    for d in "${DateArray[@]}"; do
        for f in $IN_PATH/1hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do # change 1hr to 3hr and vice versa for UM and GEOS
            fname=$(basename $f)
            out_file=$OUT_PATH/${LOC}_$fname
            cdo -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
        done
    done
done

echo "done"
