#!/usr/bin/env python3.6m

import numpy as np
import xarray as xr
from matplotlib import pyplot as plt
import matplotlib.colors as mcolors
from utility import analysis_parameters as ap
import dask

region='TWP'
chunk_dict = {"lat":100, "lon":100, "latitude":100, "longitude":100, "Xdim":2400}
plt.rcParams["font.size"]=14
colors = ap.COLORS

models2=["ARP", "ICON", "GEOS", "SCREAM", "UM"]
models1=["FV3", "SAM"]
var="cl_iwc_5e-7kgm-3"
var2 = "iwc" # or 'totalwater'
var1 = "iwc"
varz = "cldfrac_z"

# add in the models from DY2
def get_dy2_profile(m):
    """ given the model, m returns the iwc, cld frac, a z profiles"""
    print(m,"DY2", end="...")
    if (m=="SAM") or (m=="UM"):  # latlon models
        axtup = (0,2,3)
    else:
        axtup = (0,2)
    ## get total frozen hydrometeors & cloud fraction
    iwc = xr.open_dataset(ap.get_fldmean_file(m, region, var2))[var2].mean(axis=axtup)
    cl = xr.open_dataset(ap.get_fldmean_file(m, region, var)).cl.mean(axis=axtup)
    if (m=="SCREAM") or (m=="ICON") or (m=="ARP") or (m=="UM"):
        iwc = iwc[1:]
        cl = cl[1:]
    ## get height variables
    if m=="SAM":
        z = cl.z.rename({"z":"zg"})
    else:
        z = xr.open_dataset(ap.get_xytmean_file(m,"TWP","zg")).zg
    print("shapes of iwc, cldfrac, and z:", iwc.shape, cl.shape, z.shape)
    return iwc, cl, z

def get_dy1_profile(m):
    print(m, "DY1", end="...")
    var1 = "iwc"
    axtup = (0,2)
    ## get total frozen hydrometeors & cloud fraction
    if m[:3]=="NIC":
        var1="twc"
    if m[:3]=="ICO":
        iwc = xr.open_dataset(ap.DY1+"TWP/ICON_xyt_mean_twc_TWP.nc").iwc[0,:,0]
        cl = xr.open_dataset(ap.DY1+"TWP/ICON_cldfrac_TWP.nc").iwc[0,:,0]
    else:
        iwc = xr.open_dataset(ap.DY1+"TWP/TWP_{}_twc_profile_20160810-20160910.nc".format(m))[var1][0,:,0,0]
        cl = xr.open_dataset(ap.DY1+"TWP/TWP_{}_cldfrac_profile_20160810-20160910.nc".format(m)).cldfrac[0,:,0,0]
    ## get height variables
    if m[:3]=="FV3":
        z = xr.open_dataset(ap.get_xytmean_file("SHiELD","TWP","zg")).zg
    elif m[:3]=="ICO":
        z = xr.open_dataset(ap.DY1+"TWP/TWP_ICON_z_profile_20160810-20160910.nc")["height_2"][0,14:,0].values
    else:
        z = iwc.lev
    print("shapes of iwc, cldfrac, and z:", iwc.shape, cl.shape, z.shape)
    var1="iwc"
    return iwc, cl, z

def get_cccm_dy1():
    # CCCM JAS 2007-2010
    ds = xr.open_dataset("/work/bb1153/b380883/TWP/CCCM_dTWP_2007-2010.nc")
    cl = ds["Cloud fraction (CALIPSO-CloudSat)"].mean(axis=0)
    iwc = (ds["iwc used in CERES radiation, avg over cloudy part of CERES footprint"]+\
           ds["lwc used in CERES radiation, avg over cloudy part of CERES footprint"]).mean(axis=0)/1000
    z = ds.alt*1000
    print("CCCM_DY1 - JAS 2007-2010... shapes of iwc, cldfrac, and z:", 
          iwc.shape, cl.shape, z.shape)
    return iwc, cl, z

def get_cccm_dy2():
    # CCCM JFM 2008-2011
    ds = xr.open_dataset(ap.CCCM_JFM)['Mean_CALIPSO_5_km_cloud_layer_top_height'].mean(dim='Cloud_5K_Layers')
    z = np.arange(0,20,0.5)
    hist, _ = np.histogram(ds, bins=z)
    hist = hist/len(ds)*10
    print(len(ds))
    cl = hist
    print("CCCM_DY2 from CTH", cl.shape, z.shape)
    return cl, z

def get_dardar_dy1():
    # DARDAR - JAS 2009
    ds = xr.open_dataset("/work/bb1153/b380883/TWP/twp.nc")
    iwc = ds.iwc.mean(axis=0)/1000
    cl = np.where(ds.iwc>5e-4,1,0).mean(axis=0)
    z = ds.height
    print("DARDAR_DY1 - JAS 2009... shapes of iwc, cl, and z:", 
          iwc.shape, cl.shape, z.shape)
    return iwc, cl, z


def get_dardar_dy2_span():
    # DARDAR 9 years of Febs
    ds = xr.open_dataset(ap.TWP+"DARDAR-CLOUD_v2.1.1_ALL_FEB_DATA.nc")
    z = ds.z
    dardar = ds.iwc.groupby(ds.time.dt.year).mean()
    iwc_low = dardar.min(axis=0)
    iwc_hgh = dardar.max(axis=0)
    cl = ds.iwc.where(ds.iwc==0,other=1).groupby(ds.time.dt.year).mean()
    cl_min = cl.min(axis=0)
    cl_max = cl.max(axis=0)
    print("DARDAR_DY2 - Feb 2007-2017... shapes of iwc_low, iwc_hgh, cldfrac, and z:", 
          iwc_low.shape, iwc_hgh.shape, cl.shape, z.shape)
    return iwc_low, iwc_hgh, cl_min, cl_max, z

def get_dardar_dy2():
    ds = xr.open_dataset(ap.TWP+"DARDAR-CLOUD_v2.1.1_ALL_FEB_DATA.nc")
    z = ds.z
    cl = ds.iwc.where(ds.iwc==0,other=1).groupby(ds.time.dt.year).mean()
    cl_mean = cl.mean(axis=0)
    iwc = ds.iwc.mean(axis=0)
    print("DARDAR_DY2 - Feb mean 2007-2017... shapes of iwc, cl, and z", iwc.shape, cl.shape, z.shape)
    return iwc, cl_mean, z

def plot_cldprofiles():
    """ plot all the models profiles of iwc + lwc and cld frac (5e-7 kg/m3)"""
    fig, [[ax, axt],[axb, axbt]] = plt.subplots(2,2, figsize=(8,9), constrained_layout=True, sharey=True)
    xlims = [[-0.05,0.8],[5e-7,2e-4],[-0.05,0.8],[5e-7,2e-4]]
    for i,axis in enumerate([ax, axt, axb, axbt]):
        axis.fill_between([-0.1,1],14,18,color="b",alpha=0.2, label="TTL")
        axis.set(xlim=xlims[i], ylim=[0,20])
        axis.grid(True)
        axis.tick_params(labelsize=12)
    # plot DY1 on the top row
    for i,m in enumerate(models1):
        ls="dashed"
        lw=2
        iwc1, cl1, z1 = get_dy1_profile(m)
        ax.plot(cl1, z1/1000, color=colors[m], linestyle=ls, lw=lw)
        axt.plot(iwc1, z1/1000, color=colors[m], linestyle=ls, lw=lw)
        if m=="FV3":
            m="SHiELD"
            lab="FV3/SHiELD"
        else:
            lab=m
        del iwc1, cl1, z1
        ls="solid"
        iwc2, cl2, z2 = get_dy2_profile(m)
        ax.plot(cl2, z2/1000, color=colors[m], linestyle=ls, lw=lw)
        axt.plot(iwc2, z2/1000, color=colors[m], label=lab, linestyle=ls, lw=lw)
        del iwc2, cl2, z2
    for i,m in enumerate(models2):
        print(m, end="...")
        mc = m
        ls="solid"
        lw=2
        iwc, cl, z = get_dy2_profile(m)
        axb.plot(cl, z/1000, color=colors[mc], linestyle=ls, lw=lw)
        axbt.plot(iwc, z/1000, color=colors[mc], label=m, linestyle=ls, lw=lw)
    # plot CCCM DY1
    iwc, cl, z = get_cccm_dy1()
    ax.plot(cl, z/1000, color=colors["OBS"], linestyle="dashed", lw=2)
    axt.plot(iwc, z/1000, color=colors["OBS"], linestyle="dashed", lw=2, label="CCCM (JAS)")
    # plot DARDAR DY1
    n=80
    iwc, cl, z = get_dardar_dy1()
    ax.plot(cl[n:-101], (z/1000)[n:-101], color=colors["OBS2"], linestyle="dashed", lw=2)
    axt.plot(iwc[n:-101], (z/1000)[n:-101], color=colors["OBS2"], linestyle="dashed", lw=2, label="DARDAR (JAS)")
    # plot DARDAR DY2 shading
    iwclow, iwchgh, cllow, clhgh, z = get_dardar_dy2_span()
    axt.fill_betweenx((z/1000)[n:], iwclow[n:]/1000,iwchgh[n:]/1000, 
                      color=colors["OBS"], alpha=0.2, label="DARDAR span (Feb)")
    axbt.fill_betweenx((z/1000)[n:], iwclow[n:]/1000,iwchgh[n:]/1000,
                       color=colors["OBS"], alpha=0.2, label="DARDAR span (Feb)")
    ax.fill_betweenx((z/1000)[n:], cllow[n:],clhgh[n:], 
                      color=colors["OBS"], alpha=0.2)
    axb.fill_betweenx((z/1000)[n:], cllow[n:],clhgh[n:],
                       color=colors["OBS"], alpha=0.2)
    iwc, cl, z = get_dardar_dy2()
    axt.plot(iwc[n:]/1000, z[n:]/1000, color=colors["OBS"], alpha=0.4, label="DARDAR Feb mean")
    axbt.plot(iwc[n:]/1000, z[n:]/1000, color=colors["OBS"], alpha=0.4, label="DARDAR Feb mean")
    ax.plot(cl[n:], z[n:]/1000, color=colors["OBS"], alpha=0.4)
    axb.plot(cl[n:], z[n:]/1000, color=colors["OBS"], alpha=0.4)

    units = "g/kg" if var2=="cltotal" else "kg m$^{-3}$"

    ax.set_title("total cloud fraction", fontsize=14)
    axt.set_title("cloud condensate", fontsize=14)
    axbt.set_xlabel(units, fontsize=12)
    axb.set_xlabel("fraction", fontsize=12)

    # set axis properties
    ax.set(ylabel="km")
    axt.set(xscale="log")
    axb.set(ylabel="km")
    axbt.set(xscale="log")

    # legend
    axt.legend(loc="center left", bbox_to_anchor=(1., 0.5))
    axbt.legend(loc="center left", bbox_to_anchor=(1.,0.5))

    # save figure
    print("../plots/figure09_cldprofiles_{}_dy1v2.pdf".format(var2))
    plt.savefig("../plots/figure09_cldprofiles_{}_dy1v2.pdf".format(var2),
               )# rasterized=True)
    # plt.show()


if __name__=="__main__":
    plot_cldprofiles()
    

