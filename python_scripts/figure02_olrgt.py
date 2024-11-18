import cartopy.crs as ccrs
import matplotlib.animation as animation
import xarray as xr
from matplotlib import pyplot as plt
import os
from PIL import Image
import matplotlib.colors as mcolors
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
from utility import analysis_parameters as ap
import numpy as np
import netCDF4 as nc
import dask


def get_gt_means(var="rlt", diff=False, obs_file="CERES"):
    """ gets the temporal mean over the global tropics for each model in dyamond
        to plot in plot_gt_means()

    inputs:
        - var  (str)    : what variable to plot (default: 'rlt')
        - diff (boolean): plot difference from obs if true
    """
    
    # set dask properties
    chunk_dict = {"lat":100, "lon":100, "latitude":100, "longitude":100}
    
    # load variables into an array
    mod_means = {}
    if var=="rlt":
        # separate models by how they named the olr variable (rlt vs rlut)
        models = ["ARPr1deg", "ICONr1deg", "MPASr1deg", "SCREAMr1deg", "SAMr1deg", "IFSr1deg"]
        models1= ["UMr1deg", "GEOSr1deg", "SHiELDr1deg"]
        var1="rlut"
        if obs_file=="CERES 2020": # plot only 2020 CERES data
            da = xr.open_dataset(ap.TIMMEAN_GT + "timmean_GT_CERES_SYN1deg-Day_20200101-20200331.nc").adj_atmos_lw_up_all_toa_daily.isel(time=0)
        else: # plot CERES climatology from 2001-2013
            da = xr.open_dataset(ap.get_timmean_file("CERES","GT","rad_toa_1hm_JFM")).adj_atmos_lw_up_all_toa_1hm.mean(dim="time")
        mod = {obs_file:da}
        mod_means = {obs_file: da.mean().values}
        print("Progress for getting mean OLR from files...")   
        for m in models:
            print(m)
            dmod = xr.open_dataset(ap.get_timmean_file(m, "GT", var), chunks=chunk_dict)[var][0]
            if m=="ARPr0.25deg":
                dmod=-dmod/900
            mod_means[m] = dmod.mean().values
            if diff:
                dam = da.interp({"lon":dmod.lon, "lat":dmod.lat})
                das = dmod - dam.values
                mod[m] = das
            else:
                mod[m] = dmod
        for m in models1:
            print(m)
            if (m=="NICAMr1deg") or (m=="UMr1deg"):
                dmod = xr.open_dataset(ap.get_timmean_file(m, "GT", var1), chunks=chunk_dict)[var1]
            else:
                dmod = xr.open_dataset(ap.get_timmean_file(m, "GT", var1), chunks=chunk_dict)[var1][0]
            if m[:2]=="UM":
                dam = da.interp({"lon":dmod.longitude.values, "lat":dmod.latitude.values})
            else:
                dam = da.interp({"lon":dmod.lon, "lat":dmod.lat})
            mod_means[m] = dmod.mean().values
            if diff:
                das = dmod - dam.values
                mod[m] = das
            else:
                mod[m] = dmod
            
    elif var=="pracc":
        print("getting accumulated precipitation over the 40 day period")
        all_models = [None, "SCREAM", "SAM", "ARP", "ICON", "UM", "GEOS", "SHiELD"]
        mod = {}
        mod_means = {}
        for m in all_models:
            if m is not None:
                mod[m] = xr.open_dataset(ap.get_timcumsum_file(m)).isel(time=0).pracc
                mod_means[m] = mod[m].sum()
                print(m, mod[m].shape)
            else:
                mod[""] = None
                
    elif var=="pr":
        print("getting precipitation rates over the 40 day period")
        all_models = [None, "SCREAM", "SAM", "ARP", "ICON", "UM", "GEOS", "SHiELD"]
        mod = {}
        mod_means = {}
        for m in all_models:
            if m is not None:
                # mod[m] = xr.open_dataset(ap.get_timmean_file(m+'r1deg','GT','pr')).isel(time=0).pr*3600*24 # mm/s --> mm/day (*3600*24)
                mod[m] = xr.open_dataset(ap.get_daymean_file(m,'GT','pr')).mean(dim=['time']).pr*3600*24 # mm/s --> mm/day (*3600*24)
                
                if m=="ARP":
                    mod[m] = mod[m]/1000
                elif m=="SCREAM":
                    mod[m] = mod[m]*1000
                mod_means[m] = np.nanmean(mod[m])
                print(m, mod[m].shape)
            else:
                mod[""] = None
    return mod, mod_means

def plot_olr_means_gt(mod, mod_means, obs_file, var="rlt", diff=False):
    """ plot the means from get_gt_means
    
    """
    fig = plt.figure(figsize=(12,16))
    gs = fig.add_gridspec(len(mod),1, wspace=0.1, hspace=0) # , width_ratios=[1,1]
    cmap = "YlGnBu_r"
    if var=="rlt":
        omin, omax = 200, 300
        dmin, dmax = -100, 100
        lab = "OLR (W/m2)"
        ax0 = fig.add_subplot(gs[0,0], projection=ccrs.PlateCarree(central_longitude=180))
        im = mod[obs_file].plot.contourf(
                                    ax=ax0,
                                    transform=ccrs.PlateCarree(),  
                                    cmap=cmap,
                                    vmin=omin, vmax=omax, add_colorbar=False
                                    )
        units="W/m$^2$"
        ax0.coastlines()
        ax0.set_title("")
        ax0.annotate("{} ({:.01f} {})".format(obs_file, mod_means[obs_file], units), 
                     xy=(0.01,0.8), xycoords="axes fraction", fontsize=12, backgroundcolor=(1,1,1,0.75))
        ax0.set_yticks(np.arange(-30,31,10))
        ax0.set_ylabel("Lat ($^\circ$N)")
        ax0.set_ylim([-30,30])
    
    elif var[:3]=="cli":
        omin, omax = 0, 0.6
        lab = "cld frac"
        units="1"
    elif var=="pracc":
        omin, omax = 0, 1200
        units="mm"
        lab = "cumulative precip after 40 days"
    elif var=="pr":
        omin, omax = 0, 30
        units="mm/day"
        lab = "precip rate over last 30 days"
    else:
        print("what is your variable: var=",var)
    
    print("the units are", units)
    i=0
    # list models in order you want to plot 
    models = [obs_file, "ARPr1deg", "GEOSr1deg", "ICONr1deg", "IFSr1deg", "MPASr1deg", "SAMr1deg", "SCREAMr1deg", "SHiELDr1deg", "UMr1deg"] # add IFS
    for m in list(models):
        print(i,m)
        if var=="cli":
            if m=="UM":
                lev="model_level_number"
            else:
                lev="lev"
        if mod[m] is not None:
            da = mod[m]
        else:
            ax0 = fig.add_subplot(gs[0,0], projection=ccrs.PlateCarree(central_longitude=180))
            ax0.axis('off')
            i+=1
            continue
        print("... defined da...")
        if diff:
            if m[:5]=="CERES":
                vmin=omin
                vmax=omax
                cmap = "YlGnBu_r"
            else:
                vmin, vmax = dmin, dmax
                cmap = "coolwarm"
        else:
            if var=="pr":
                cmap="gnuplot"
            else:
                cmap="YlGnBu_r"
            vmin=omin
            vmax=omax
        print("colorbar min/max",vmin,vmax)
        if m[:5]=="CERES":
            i+=1
            continue
        print("... plotting...")
        ax = fig.add_subplot(gs[i%(len(mod))], projection=ccrs.PlateCarree(central_longitude=180), sharex=ax0)
    
        pc = da.plot.contourf(
            ax=ax,
            transform=ccrs.PlateCarree(),  
            cmap=cmap,
            vmin=vmin, vmax=vmax,
            add_colorbar=False,
            # norm="log",
            # norm=mcolors.LogNorm(vmin=0, vmax=40),
            # cbar_kwargs={"orientation": "vertical", "shrink": 0.6, "extend":"both", "label":"OLR"},
            # robust=True
        )
        print("... plotted. Adding axis stuff...")
        ax.coastlines() 
        if var=="rlt":
            ax.annotate("{} ({:.01f} {})".format(m.split("r")[0], mod_means[m], units), 
                        xy=(0.01,0.8), xycoords="axes fraction", fontsize=12, backgroundcolor=(1,1,1,0.75))
            ax.set_title("")
        elif var=="pracc":
            ax.set_title("{} ({:.2E} {})".format(m.split("r")[0], mod_means[m], units))
        elif var=="pr":
            ax.set_title("{} ({:.2f} {})".format(m.split("r")[0], mod_means[m], units))
        ax.set_yticks(np.arange(-30,31,10))
        # ax.set_xticks(np.arange(-180,181,30))
        ax.set_ylabel("Lat ($^\circ$N)")
        ax.set_ylim([-30,30])
    
        if var=="rlt":
            if (i==5 and not(diff)) or (i==2 and diff):
                axins2 = inset_axes(ax, # here using axis of the lowest plot
                           width="5%",  # width = 5% of parent_bbox width
                           height="340%",  # height : 340% good for a (4x4) Grid
                           loc='lower left',
                           bbox_to_anchor=(1.05, -0.5, 1, 1),
                           bbox_transform=ax.transAxes,
                           borderpad=0
                           )
        if i==7 and diff:
            axins6 = inset_axes(ax, # here using axis of the lowest plot
                       width="5%",  # width = 5% of parent_bbox width
                       height="340%",  # height : 340% good for a (4x4) Grid
                       loc='lower left',
                       bbox_to_anchor=(1.05, -0.5, 1, 1),
                       bbox_transform=ax.transAxes,
                       borderpad=0,
                       )
        # if i%(len(mod)//2)==(len(mod)//2)-1:
        if i==(len(mod)-1):
            ax.set_xticks(np.arange(-180,181,30))
            ax.set_xticklabels([0,30,60,90,120,150,180,-150,-120,-90,-60,-30,0],color='k')
            ax.set_xlabel("Lon ($^\circ$E)")
        i+=1
        print("...done with {} of {}".format(i,len(mod)))
    
    if var=="rlt":
        cb = fig.colorbar(im, cax=axins2,  label=units, ticklocation="right", extend="both")
    if diff:
        cb = fig.colorbar(pc, cax=axins6, label=units, extend="min") #extend="both", 
    
    if diff:
        var=var+"_diff"
    print("figure saved as ../plots/figure02_olrgt.png")
    plt.savefig("../plots/figure02_olrgt.png", dpi=250)
    plt.show()

    if diff:
        var=var.split("_")[0]
    return fig

def plot_olrgt(diff=True,ceres_file="CERES"):
    mod, mod_means = get_gt_means(var="rlt", diff=diff, obs_file=ceres_file)
    print("plotting...")
    plot_olr_means_gt(mod, mod_means, ceres_file, var="rlt", diff=diff)
    print("done")

if __name__=="__main__":
    main()
