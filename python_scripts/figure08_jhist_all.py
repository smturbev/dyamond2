import xarray as xr
import matplotlib.pyplot as plt
import matplotlib.patches as mpat
import matplotlib.transforms as trans
from matplotlib import ticker, cm
from utility import analysis_parameters as ap, util
import numpy as np
import dask

region="TWP"
r=0.1  # 0=native grid, 0.1=0.1deg regridded
# plot_type = "diff"  # density', 'mean', 'median', 'diff'
var_type=None
dask_chunks={"ncol":1000, "Xdim":500}

models = ["CCCM","ARP","ICON","IFS","MPAS","SAM","SHiELD","UM"]


def plot_jhist_all(plot_type):
    """ the plot_type can be 'density', 'mean', 'median', 'diff', or 'summer' """
    fig = plt.figure(figsize=(30,16))
    for i, m in enumerate(models):
        print(m, region, end="...")
        ax = fig.add_subplot(2,int(len(models)/2), i+1, box_aspect=1.1)
        if m=="schematic":
            schematic(ax=ax, arrow=False)
        elif m is None:
            ax.axis("off")
            continue
        else:
            # load olr and albedo
            # to do - change hours (10-14) for non-TWP region
            if plot_type!="summer":
                olr = ap.load_olr(m,region,r)
                olr = olr.where((olr.time.dt.hour<=4))
                alb = ap.load_alb(m,region,r)
                alb = alb.where(alb.time.dt.hour<=4)
                print("\tolr {}, alb {}".format(olr.shape, alb.shape))
            else:
                olr=None
            if plot_type=="diff":
                if m[:2]=="SH":
                    m1 = "FV3"
                else:
                    m1=m
                olr1, alb1 = ap.load_olr_alb_dy1(m1, region)
                print('diff', end="...")
            elif plot_type=="summer":
                if m[:2]=="SH":
                    m1 = "FV3"
                else:
                    m1=m
                olr1, alb1 = ap.load_olr_alb_dy1(m1, region)
                print('summer', end="...")
            else:
                olr1=0 # anything but None
            # plotting variable values on olr-alb plane
            if (plot_type!="density") and (plot_type!="diff") and (plot_type!="summer"):
                if m=="UM":
                    olr=olr[:680]
                    alb=alb[:680]
                    if var_type=="ts":
                        var = xr.open_dataset(ap.get_file(m, region, "ts")).ts[:,0]
                    elif var_type=="cpt":
                        var = ap.load_3dvar(m,region,"ta",chunks=dask_chunks)
                        zg = ap.load_height_full(m, chunks=dask_chunks)
                        print("3d var, ta & zg:", var.shape, zg.shape)
                        # cold point tropopause temperature
                        var = var.where((zg<=18000)).min(dim='lev')
                    var = var.where(var<1e10)
                else:
                    if var_type=="ts":
                        var = xr.open_dataset(ap.get_file(m+"r"+str(r)+"deg", region, "ts")).ts
                    elif var_type=="cpt":
                        var = ap.load_3dvar(m,region,"ta",chunks=dask_chunks)
                        zg = ap.load_height_full(m, chunks=dask_chunks)
                        print("3d var, ta & zg:", var.shape, zg.shape)
                        # cold point tropopause temperature
                        var = var.where((zg<=18000)).min(dim='lev')
                if var.time[0] != olr.time[0]:
                    var = var[1:len(olr.time)+1]
                else:
                    var = var[:len(olr.time)]
                print("\t", olr.shape, alb.shape, var.shape)
                olr = olr.sel(time=var.time)
                alb = alb.sel(time=olr.time)
                # var = var.sel(time=olr.time)
                print("\t", olr.shape, alb.shape)
                print("\t means", np.nanmean(olr), np.nanmean(alb))
                # print(var)
    
            # coarsen step to 0.3 deg (or n * r)
            if r>0:
                n=3 #0.1*n = coarsened resolution
                if m=="CERES" or m=="CCCM":
                    pass
                elif m=="UM" and plot_type!="summer":
                    olr = olr.coarsen(latitude=n, longitude=n, boundary='trim').mean() 
                    alb = alb.coarsen(latitude=n, longitude=n, boundary='trim').mean()
                    if (plot_type!="density") and (plot_type!="diff"):
                        var = var.coarsen(latitude=int(214/100)*n, longitude=int(142/100)*n, boundary='trim').mean() 
                        print("\tvar",var.shape, np.nanmean(var), np.nanstd(var))
                else:
                    if plot_type!="summer":
                        olr = olr.coarsen(lat=n, lon=n, boundary='trim').mean() 
                        alb = alb.coarsen(lat=n, lon=n, boundary='trim').mean()
                    if plot_type =="diff" or plot_type=="summer":
                        if olr1 is not None:
                            olr1 = olr1.coarsen(lat=n, lon=n, boundary='trim').mean()
                            alb1 = alb1.coarsen(lat=n, lon=n, boundary='trim').mean()
                            print("coarsened to ", olr1.shape, alb1.shape, end="...")
                    elif (plot_type!="density"):
                        var = var.coarsen(lat=n, lon=n, boundary='trim').mean()
                        print("\tvar",var.shape, np.nanmean(var), np.nanstd(var), end="...")
            else:
                n=0
            
            # plot
            print("\n...starting to plot...", end="\t")
            # to do - add "diff" option
            if olr is None and plot_type!="summer":
                ax.axis("off")
                print('DY2 is NONE')
            elif olr1 is None:
                ax.axis("off")
                print('DY1 is NONE')
            else:
                if plot_type!="summer":
                    olr = olr.values.flatten()
                    alb = alb.values.flatten()
                    alb = alb[~np.isnan(olr)]
                    olr = olr[~np.isnan(olr)]
                    print(olr.shape)
                if plot_type=="diff" or plot_type=="summer":
                    olr1 = olr1.values.flatten()
                    alb1 = alb1.values.flatten()
                    alb1 = alb1[~np.isnan(olr1)]
                    olr1 = olr1[~np.isnan(olr1)]
                elif (plot_type!="density"):
                    var = var.values.flatten()
                    var = var[~np.isnan(olr)]
                
                if plot_type=="density":
                    _, im = util.dennisplot("density",olr, alb, 
                                    ax=ax, model=m, region=region,
                                    cmap="gist_earth_r", 
                                    levels=np.arange(-3.4,-1.2,0.2), colorbar_on=False)
                elif plot_type=="diff":
                    print("... plotting difference")
                    _, im, cs = util.dennisplot("difference",(olr,olr1), (alb,alb1), 
                                    ax=ax, model=m, region=region, levels=np.array([-1., -0.3, -0.1, -0.03, -0.01, 0.01, 0.03, 0.1, 0.3,  1.]),
                                    cmap="bwr_r", colorbar_on=False, contour_one=True)
                elif plot_type=="summer":
                    _, im = util.dennisplot("density",olr1, alb1, 
                                    ax=ax, model=m, region=region,
                                    cmap="gist_earth_r", 
                                    levels=np.arange(-3.4,-1.2,0.2), colorbar_on=False)
                else:
                    print("plot_type", plot_type, end="...")
                    if var_type=="ts":
                        print("ts")
                        if plot_type=="std":
                            # print("test")
                            util.dennisplot(plot_type, olr, alb, var,
                                    ax=ax, model=m, region=region,
                                    cmap="rainbow", 
                                    levels=np.arange(0,2,0.1),
                                    colorbar_on=True)
                        else:
                            util.dennisplot(plot_type, olr, alb, var,
                                    ax=ax, model=m, region=region,
                                    cmap="rainbow", 
                                    levels=np.arange(300,304,0.1),
                                    colorbar_on=True)
                    elif var_type=="cpt":
                        util.dennisplot(plot_type, olr, alb, var,
                                    ax=ax, model=m, region=region,
                                    cmap="rainbow", 
                                    levels=np.arange(189,194,0.2),
                                    colorbar_on=True)
        
                ax.set_xlabel("OLR (W/m$^2$)")
                ax.set_ylabel("Albedo")
                ax.grid(True)
                ax.set_ylim([0,0.8]) # [0.04,0.8]
                ax.set_xlim([80,310])
                if i==0 and plot_type=="diff":
                    ax.set_title("{} {}\nJFM $-$ JAS 2007-11".format(m, region), 
                                  fontsize=24)  
                elif i==0 and plot_type=="summer":
                    ax.set_title("{} {}\nJAS 2007-10".format(m, region), 
                                  fontsize=24)
                elif i==0: # winter
                    ax.set_title("{} {}\nJFM 2007-10".format(m, region), 
                                  fontsize=24)
                elif plot_type=="diff":
                    ax.set_title("{} Winter $-$ Summer, {}\nDays 11-40 (10am-2pm LT)".format(m, region), 
                                  fontsize=24)
                else:
                    ax.set_title("{} {}\nDays 11-40 (10am-2pm LT)".format(m, region), 
                                  fontsize=24)
                # ax.scatter(np.nanmean(olr), np.nanmean(alb), color='r', s=50)
            print('... done plotting',m, '.')
    
    plt.subplots_adjust(wspace=0.05, hspace=0.05)
    plt.tight_layout()
    fig.subplots_adjust(right=0.9)
    cbar_ax = fig.add_axes([0.95, 0.15, 0.02, 0.7])
    cb = fig.colorbar(im, cax=cbar_ax)
    cb.set_label(label="log10(pdf)", size=20)
    cb.ax.tick_params(axis='both', labelsize=20)
    
    save_name = "../plots/figure08_jhist_{}_all.pdf".format(plot_type)
    print("... saved as "+save_name)
    plt.savefig(save_name, bbox_inches="tight", pad_inches=0.5)
    plt.show()

