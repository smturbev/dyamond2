#!/usr/bin/env python

import xarray as xr
import matplotlib.pyplot as plt
import analysis_parameters as ap



nclivi = xr.open_dataset("/scratch/b/b380887/global_tropics/NICAM/NICAM_int_froz_winter_ITCZ.nc")["clivi"]
print(nclivi)
nclivi.mean(dim="time").plot.contourf()
plt.savefig("../plots/n_clivi.png")
print("SAVED")
plt.close()

