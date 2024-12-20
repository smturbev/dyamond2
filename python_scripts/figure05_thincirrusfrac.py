""" figure05_thincirrusfrac.py

    plots thin cirrus cloud fraction side-by-side
    with mean precip rate (deep convective proxy)

    Methods:
        plot_thincifrac(): main function does plotting
"""

import cartopy.crs as ccrs
import xarray as xr
from matplotlib import pyplot as plt
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
from utility import analysis_parameters as ap
import numpy as np
import dask


chunk_dict = {"lat":100, "lon":100, "latitude":100, "longitude":100}
models=["ARP","GEOS","ICON","SAM","SCREAM","SHiELD","UM"]
pr_coef=[3600/900,3600,3600,3600,3600*1000,3600,3600]

def plot_thincifrac():
    fig = plt.figure(figsize=(16,len(models)*2))
    gs = fig.add_gridspec(len(models), 2, wspace=0.05, hspace=0, width_ratios=[1,1])
    
    for i,m in enumerate(models):
        print(i,m)
        
        ci = xr.open_dataset(ap.TIMMEAN_GT+"GT_{}r1degfromnative_cicldfrac_20200130-20200228.nc".format(m)).isel(time=0).cicldfrac
        dc = xr.open_dataset(ap.get_timmean_file(m+"r1deg","GT","pr")).pr.isel(time=0)*pr_coef[i]    
        print(ci.shape, dc.shape)
        
        # plot thin ci cld fraction with deep convective contour at 5% (red)
        if i==0:
            ax0 = fig.add_subplot(gs[i,0], projection=ccrs.PlateCarree(central_longitude=180))
            ax1 = fig.add_subplot(gs[i,1], projection=ccrs.PlateCarree(central_longitude=180))
        else:
            ax0 = fig.add_subplot(gs[i,0], projection=ccrs.PlateCarree(central_longitude=180), sharex=ax0)
            ax1 = fig.add_subplot(gs[i,1], projection=ccrs.PlateCarree(central_longitude=180), sharex=ax1)
        cf_ci = ci.plot.contourf(ax=ax0, add_colorbar=False, vmin=0, vmax=1, levels=6,
                                 transform=ccrs.PlateCarree())
        cf_dc = dc.plot.contourf(ax=ax1, #levels=np.arange(180,311,20), 
                                 vmin=0.05, vmax=1,
                                 cmap='YlGn', 
                                 add_colorbar=False,
                                 transform=ccrs.PlateCarree())
        ax0.coastlines() 
        ax0.set(ylabel="", xlabel="", 
                xticks=np.arange(-180,181,60), 
                yticks=np.arange(-30,31,10),
                ylim=[-30,30])
        ax1.coastlines() 
        ax1.set(ylabel="", xlabel="", 
                xticks=np.arange(-180,181,60), 
                yticks=np.arange(-30,31,10),
                ylim=[-30,30])
        ax1.yaxis.tick_right()
        if i==0:
            ax0.set(title="Thin cirrus fraction ($0.1<$iwp$<100$ g/m$^2$)")
            ax1.set(title="PR (mm/hr)")
        else:
            ax0.set(title="")
            ax1.set(title="")
        if i==(len(models)-1):
            axins0 = inset_axes(ax0, # here using axis of the lowest plot
                                   width="80%",  # width = 5% of parent_bbox width
                                   height="20%",  # height : 340% good for a (4x4) Grid
                                   loc='upper left',
                                   bbox_to_anchor=(0.1, -1.3, 1, 1),
                                   bbox_transform=ax0.transAxes,
                                   borderpad=0,
                                   )
            axins0.xaxis.set_ticks_position("bottom")
            axins1 = inset_axes(ax1, # here using axis of the lowest plot
                                   width="80%",  # width = 5% of parent_bbox width
                                   height="20%",  # height : 340% good for a (4x4) Grid
                                   loc='upper left',
                                   bbox_to_anchor=(0.1, -1.3, 1, 1),
                                   bbox_transform=ax1.transAxes,
                                   borderpad=0,
                                   )
            axins1.xaxis.set_ticks_position("bottom")
            cb = fig.colorbar(cf_ci, orientation="horizontal", cax=axins0,  label="cloud fraction", extend="both")
            cb = fig.colorbar(cf_dc, orientation="horizontal", cax=axins1,  label="precipitation rate (mm/hr)", extend="both")
        ax0.annotate(m.split('r')[0], xy=(0.01,0.8), xycoords="axes fraction", fontsize=12, color='w', backgroundcolor=(0,0,0,0.5))
        ax1.annotate(m.split('r')[0], xy=(0.01,0.8), xycoords="axes fraction", fontsize=12, color='k', backgroundcolor=(1,1,1,0.7))
    print("saving as ../plots/figure05_thincifrac_pr.pdf")
    plt.savefig("../plots/figure05_thincifrac_pr.pdf", bbox_inches="tight", pad_inches=0.25)
    plt.show()

if __name__=="__main__":
    plot_thincifrac()
        
        