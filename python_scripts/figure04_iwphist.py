""" figure04_iwphist.py

    iwp hist computed in sh_scripts/simple_iwp_hist.sh
    this fille provides a plotting function for iwp histograms
    given the processed file
"""

import xarray as xr
import matplotlib.pyplot as plt
from utility import analysis_parameters as ap
import numpy as np
import dask
from dask.diagnostics import ProgressBar
pbar = ProgressBar()
pbar.register()

colors = ap.COLORS

def plot_iwphist():
    # Simple iwp hist (1x1deg)
    models = ["GEOS","ICON","IFS","SAM", "SCREAM","SHiELD","UM"]
    plt.figure(figsize=(6,3.4))
    for i, m in enumerate(models):
        file="/work/bb1153/b380883/GT/GT_{}r1deg_iwp_hist_20200130-20200228.nc".format(m)
        print(i, m)
        iwp_hist_ds = xr.open_dataset(file)
        iwp_hist = iwp_hist_ds.iwp.isel(time=0).sum(dim=["lat","lon"])
        # print(iwp_hist.shape)
        bins = iwp_hist_ds.bin_bnds
        # print(bins.shape)
        bin_mids = (bins[:,1].values+bins[:,0].values)/2
        bin_widths = bins[:,1].values-bins[:,0].values
        # print(iwp_hist.shape, bin_mids.shape, bin_widths.shape)
        # normalize
        if m[:2]=="GE" or m[:2]=="SA" or m[:2]=="SH" or m[:2]=="UM":
            iwp_hist = iwp_hist/(21600*2880)
        elif m[:2]=="SC":
            iwp_hist = iwp_hist/(21600*2688)
        elif m[:2]=="IC":
            iwp_hist = iwp_hist/(21600*2850)
        elif m[:2]=="IF":
            iwp_hist= iwp_hist/(21600*720)
        # plot it
        if m=="SHiELD":
            plt.plot(bin_mids[13:], iwp_hist[13:].values, #where="mid", 
                 label=m, color=colors[m], lw=2)
        else:
            plt.plot(bin_mids, iwp_hist.values, #where="mid", 
                 label=m, color=colors[m], lw=2)
    print("models done, do obs")
    iwp_hist = xr.open_dataset(ap.DARDAR_GT_IWPHIST).isel(time=0).iwp
    iwp_hist = iwp_hist/37873307
    print(iwp_hist.shape)
    plt.plot(bin_mids[8:], iwp_hist[8:].values, label="DARDAR", 
             color=colors["OBS"], linestyle="dashed", lw=3, alpha=0.7)
    print("obs done")
    plt.grid()
    plt.legend(ncol=2)
    plt.title("Tropics (30$^\circ$N$-30^\circ$S)\ncoarsened to $1^\circ$ sq.")
    plt.xlabel("IWP (kg/m$^2$)")
    plt.xscale("log")
    # plt.ylim([0,0.5e7])
    plt.ylim([0,0.07])
    plt.savefig("../plots/figure04_iwphist_gt_norm.pdf",dpi=140, bbox_inches="tight", pad_inches=0.2)
    print("saved as ../plots/figure04_iwphist_gt_norm.pdf")
    plt.show()


if __name__=="__main__":
    plot_iwphist()