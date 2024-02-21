#!/bin/bash
#SBATCH --job-name=cl_binned
#SBATCH --partition=shared
#SBATCH --mem=20GB
#SBATCH --time=01:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out.eo
#SBATCH --error=err_cl_binned%j.eo

# change this
MODEL="SHiELD"

# dont change anything below this line
# -----------------------------------------------------
set -evx # verbose messages and crash message
twp="/work/bb1153/b380883/TWP"
scr="/scratch/b/b380883"
iwp=$twp/TWP_${MODEL}_clivi_20200130-20200228.nc
echo $iwp

if [ $MODEL = 'ICON' ] ; then
    echo "ICON"
    declare -a BinEdges=(3.0517578125e-05 6.103515625e-05 6.103515625e-05 0.0001220703125 0.00018310546875 0.00030517578125 0.00048828125 0.00079345703125 0.00128173828125 0.00177001953125 0.002197265625 0.0030517578125 0.00390625 0.005126953125 0.00665283203125 0.0086669921875 0.01129150390625 0.01483154296875 0.01971435546875 0.0264892578125 0.0361328125 0.05047607421875 0.0728759765625 0.1107177734375 0.188720703125 2.25579833984375)
elif [ $MODEL = 'UM' ] ; then
    echo "UM"
    declare -a BinEdges=(1.4138934467666786e-08 0.00047114770510233936 0.0011914339242503048 0.002169070038944482 0.0033843941148370502 0.0048519173637032505 0.006592912226915359 0.008620168119668961 0.01098393477499485 0.013717881441116334 0.016879140958189966 0.020564541518688202 0.024877171292901037 0.02998618319630623 0.03608754083514216 0.04350134134292603 0.05265546917915344 0.06409082233905793 0.07877392381429675 0.09802137017250061 0.12466006129980091 0.16472432255744923 0.23343879282474517 0.3951457643508913 1.060990095138548 44.414222717285156)
elif [ $MODEL = 'SHiELD' ] ; then
    echo "SHiELD"
    declare -a BinEdges=(9.133515772083732e-36 3.63508647751587e-06 1.6773786046542228e-05 5.503428183146752e-05 0.00013853459095116712 0.0002958772238343954 0.0005767197115346789 0.001005992153659463 0.001585556147620083 0.0023232833482325077 0.003202049992978573 0.004288396239280703 0.005720360577106475 0.0077533755451440825 0.010714340023696423 0.015014373697340488 0.021311843395233156 0.03072958774864676 0.045166420936584434 0.06762612015008926 0.10266529023647308 0.15731839835643768 0.24376089274883272 0.38869197368621833 0.68717827796936  15.082117080688477)
fi
echo $BinEdges

for i in $(seq 0 24); do
    echo $i $((i+1)) ${BinEdges[$i]} ${BinEdges[$((i+1))]}
    iwp_mask=$scr/TWP_${MODEL}_iwp-mask_${i}.nc
    cdo -gec,${BinEdges[$i]} -lec,${BinEdges[$((i+1))]} $iwp $iwp_mask
done