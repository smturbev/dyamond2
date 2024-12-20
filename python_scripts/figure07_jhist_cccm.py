import xarray as xr
import matplotlib.pyplot as plt
import matplotlib.patches as mpat
import matplotlib.transforms as trans
from matplotlib import ticker, cm
from utility import analysis_parameters as ap, util
import numpy as np
import dask


region="TWP"

def plot_jhist_cccm():

    ds_dict = {"JAS":xr.open_dataset(ap.CCCM_JAS), "JFM":xr.open_dataset(ap.CCCM_JFM)}
    fig = plt.figure(figsize=(16,6))
    axes = [fig.add_subplot(1,3,i) for i in range(1,4)]
    cb_on=False
    olr_szn = {}
    alb_szn = {}
    
    for i, season in enumerate(["JFM","JAS","diff"]):
        if season=="diff":
            _, cbd = util.dennisplot("difference", (olr_szn["JFM"],olr_szn["JAS"]),
                            (alb_szn["JFM"],alb_szn["JAS"]), ax=axes[i], 
                            model="CCCM", region=region, cmap="bwr_r",
                            colorbar_on=cb_on, levels=np.array([-1., -0.3, -0.1, -0.03, -0.01, 0.01, 0.03, 0.1, 0.3,  1.]))
            axes[i].set_title("CCCM {}\nDifference (JFM$-$JAS)".format(region), fontsize=20)
            axes[i].set(ylim=[0,0.8])
        else:
            print(i, season)
            olr = ds_dict[season].CERES_LW_TOA_flux___upwards
            swu = ds_dict[season].CERES_SW_TOA_flux___upwards
            swd = ds_dict[season].TOA_Incoming_Solar_Radiation
            alb = swu/swd
            
            olr_szn[season] = olr.values
            alb_szn[season] = alb.values
    
            olr = olr[~np.isnan(alb)]
            alb = alb[~np.isnan(alb)]
            alb = alb[~np.isnan(olr)]
            olr = olr[~np.isnan(olr)]
            
            _, cb = util.dennisplot("density",olr.values, alb.values, 
                            ax=axes[i], model="CCCM", region=region, 
                            cmap="gist_earth_r", levels=np.arange(-3.4,-1.2,0.2), colorbar_on=cb_on)
            if season=="JAS":
                axes[i].set_title("CCCM {}\nJAS 2007-10".format(region), fontsize=20)
            else:
                axes[i].set_title("CCCM {}\nJFM 2008-11".format(region), fontsize=20)
            axes[i].scatter(np.nanmean(olr), np.nanmean(alb), color='r', s=50)
            axes[i].set(ylim=[0,0.8])
    axes[1].set(ylabel="")
    axes[2].set(ylabel="")
    cbar_lax = fig.add_axes([-0.04,0.1,0.025,0.8])
    cbar_rax = fig.add_axes([1.02,0.1,0.025,0.8])
    cbl = fig.colorbar(cb, cax=cbar_lax, ticklocation="left")
    cbl.set_label("log10(pdf)", fontsize=18)
    cbl.ax.tick_params(labelsize=18)
    cbr = fig.colorbar(cbd, cax=cbar_rax)
    cbr.set_label("% diff in pdfs", fontsize=18)
    cbr.ax.tick_params(labelsize=18)
    plt.subplots_adjust(wspace=0.05, hspace=0.05)
    plt.tight_layout()
    print("saving as ../plots/figure07_jhist_cccm.pdf")
    plt.savefig("../plots/figure07_jhist_cccm.pdf".format(region), bbox_inches="tight", pad_inches=0.5)
    plt.show()

def plot_jhist_schematic():
    fig, ax = plt.subplots(1,1, figsize=(8,8))
    util.schematic(ax=ax)
    # ax.set(xlim=[0,1])
    plt.savefig("../plots/extra_figure_jhist_schematic.pdf")
    plt.show()
