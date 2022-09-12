import xarray as xr
import matplotlib.pyplot as plt
from matplotlib import ticker, cm
from utility import analysis_parameters as ap, util
import numpy as np
import dask
from dask.diagnostics import ProgressBar
pbar = ProgressBar()
pbar.register()

region="TWP"
n=40 # n=40 for 0.25 deg or n=10 for 1 deg or anything for native grid

chunk_dict = {"time":500, "lat":400, "lon":1440} # "grid_size":500000}
chunk_dictn = {"time":100, "ncells":100} 
chunk_dicts = {"time":500, "ncol":1000, "grid_size":1000} 

sa_olr = xr.open_dataset(ap.get_file("SAM", "TWP", "rlt"), chunks=chunk_dict).rlt
sa_swn = xr.open_dataset(ap.get_file("SAM", "TWP", "rst"), chunks=chunk_dict).rstacc
ds = xr.open_dataset(ap.get_file("DATA", "TWP", "rad"), chunks=chunk_dict)
da_olr = ds.adj_atmos_lw_up_all_toa_1h
da_swu = ds.adj_atmos_sw_up_all_toa_1h
da_swd = ds.adj_atmos_sw_down_all_toa_1h
ni_olr = xr.open_dataset(ap.get_file("NICAM", "TWP", "rlut"), chunks=chunk_dict).rlut
ni_swu = xr.open_dataset(ap.get_file("NICAM", "TWP", "rsut"), chunks=chunk_dict).rsut
ni_swd = xr.open_dataset(ap.get_file("NICAM", "TWP", "rsdt"), chunks=chunk_dict).rsdt
um_olr = xr.open_dataset(ap.get_file("UM", "TWP", "rlut"), chunks=chunk_dict).rlut
um_swu = xr.open_dataset(ap.get_file("UM", "TWP", "rsut"), chunks=chunk_dict).rsut
um_swd = xr.open_dataset(ap.get_file("UM", "TWP", "rsdt"), chunks=chunk_dict).rsdt

if n==10 or n==40:
    ge_olr = xr.open_dataset(ap.get_file("GEOSr0.25deg", "TWP", "rlut"), chunks=chunk_dict).rlut
    ge_swu = xr.open_dataset(ap.get_file("GEOSr0.25deg", "TWP", "rsut"), chunks=chunk_dict).rsut
    ge_swn = xr.open_dataset(ap.get_file("GEOSr0.25deg", "TWP", "rst"), chunks=chunk_dict).rst
    ge_swd = ge_swu+ge_swn
    sc_olr = xr.open_dataset(ap.get_file("SCREAMr0.25deg", "TWP", "rlt"), chunks=chunk_dict).rlt
    sc_swn = xr.open_dataset(ap.get_file("SCREAMr0.25deg", "TWP", "rst"), chunks=chunk_dict).rst
    sc_swd = xr.open_dataset(ap.get_file("SCREAMr0.25deg", "TWP", "rsdt"), chunks=chunk_dict).SOLIN
else:
    ge_olr = xr.open_dataset(ap.get_file("GEOS", "TWP", "rlut"), chunks=chunk_dict).rlut
    ge_swu = xr.open_dataset(ap.get_file("GEOS", "TWP", "rsut"), chunks=chunk_dict).rsut
    ge_swd = xr.open_dataset(ap.get_file("GEOS", "TWP", "rsdt"), chunks=chunk_dict).rsdt
    sc_olr = xr.open_dataset(ap.get_file("SCREAM", "TWP", "rlt"), chunks=chunk_dicts).rlt
    sc_swn = xr.open_dataset(ap.get_file("SCREAM", "TWP", "rst"), chunks=chunk_dicts).rst
    sc_swd = xr.open_dataset(ap.get_file("SCREAM", "TWP", "rsdt"), chunks=chunk_dicts).SOLIN.rename({"ncol":"grid_size"})

sc_swu = sc_swd-sc_swn


# Coarsen
if n==10:
    ge_olr = ge_olr.coarsen(lat=4, lon=4, boundary='trim').mean()
    ge_swu = ge_swu.coarsen(lat=4, lon=4, boundary='trim').mean()
    ge_swd = ge_swd.coarsen(lat=4, lon=4, boundary='trim').mean()
    sc_olr = sc_olr.coarsen(lat=4, lon=4, boundary='trim').mean()
    sc_swu = sc_swu.coarsen(lat=4, lon=4, boundary='trim').mean()
    sc_swd = sc_swd.coarsen(lat=4, lon=4, boundary='trim').mean()
    print("n=10")
if n==10 or n==40:
    ni_olr = ni_olr.coarsen(lat=len(ni_olr.lat)//n, lon=len(ni_olr.lon)//n, boundary='trim').mean()
    ni_swu = ni_swu.coarsen(lat=len(ni_swu.lat)//n, lon=len(ni_swu.lon)//n, boundary='trim').mean()
    ni_swd = ni_swd.coarsen(lat=len(ni_swd.lat)//n, lon=len(ni_swd.lon)//n, boundary='trim').mean()
    sa_olr = sa_olr.coarsen(lat=len(sa_olr.lat)//n, lon=len(sa_olr.lon)//n, boundary='trim').mean()
    sa_swn = sa_swn.coarsen(lat=len(sa_swn.lat)//n, lon=len(sa_swn.lon)//n, boundary='trim').mean()
    um_olr = um_olr.coarsen(latitude=len(um_olr.latitude)//n, longitude=len(um_olr.longitude)//n, boundary='trim').mean()
    um_swu = um_swu.coarsen(latitude=len(um_swu.latitude)//n, longitude=len(um_swu.longitude)//n, boundary='trim').mean()
    um_swd = um_swd.coarsen(latitude=len(um_swd.latitude)//n, longitude=len(um_swd.longitude)//n, boundary='trim').mean()

# Calculate albedo
if n==10 or n==40:
    sa_swd = ge_swd.interp(time=sa_swn.time,
                           lat=sa_swn.lat, 
                           lon=sa_swn.lon, 
                           method="nearest",
                           kwargs={"fill_value": np.nan})    
else:
    sa_swn = sa_swn.interp(time=um_swd.time, method="nearest",
                       kwargs={"fill_value": np.nan})
    sa_olr = sa_olr.interp(time=um_swd.time, method="nearest",
                           kwargs={"fill_value": np.nan})
    sa_swd = um_swd.interp(latitude=sa_swn.lat, 
                           longitude=sa_swn.lon, 
                           method="nearest",
                           kwargs={"fill_value": np.nan})
sa_swu = sa_swd - sa_swn

ni_alb = ni_swu/ni_swd
sa_alb = sa_swu/sa_swd.where(sa_swd>100)
um_alb = um_swu/um_swd
da_alb = da_swu/da_swd
ge_alb = ge_swu/ge_swd
sc_alb = sc_swu/sc_swd.values

# plot jhist
if n==10:
    models=["CERES SYN1deg 1 hrly", "NICAM 1x1", "SAM 1x1 - using GEOS SWD", 
            "UM 1x1", "GEOS 1x1", "SCREAM 1x1"]
elif n==40:
    models=["CERES SYN1deg 1 hrly", "NICAM 0.25deg", "SAM 0.25deg - using GEOS SWD", 
            "UM 0.25deg", "GEOS 0.25deg", "SCREAM 0.25 deg"]
else:
    models=["CERES SYN1deg 1 hrly", "NICAM native", "SAM native - using UM SWD", 
            "UM native", "GEOS native", "SCREAM native"]
fig = plt.figure(figsize=(28,18))
axes = [fig.add_subplot(2,3,i,box_aspect=1.1) for i in range(1,len(models)+1)]

olrs=[da_olr, ni_olr, sa_olr, um_olr, ge_olr, sc_olr]
albs=[da_alb, ni_alb, sa_alb, um_alb, ge_alb, sc_alb]
for i in range(len(olrs)):
    olr = olrs[i]
    alb = albs[i]
    olr = olr.where((olr.time.dt.hour>=0)&(olr.time.dt.hour<=4))
    alb = alb.where((alb.time.dt.hour>=0)&(alb.time.dt.hour<=4))
    util.dennisplot("density",olr.values.flatten(), alb.values.flatten(), 
                    ax=axes[i], model=models[i], region=region, 
                    cmap="gist_earth_r", levels=np.arange(-3.4,-1.2,0.2))
    axes[i].set_xlabel("OLR (W/m$^2$)")
    axes[i].set_ylabel("Albedo")
    axes[i].grid(True)
    axes[i].set_ylim([0,0.8])
    axes[i].set_title("{} {}\n01 Jan-1 Mar 2020 (10am-2pm LT)".format(models[i], region), fontsize=20)
    axes[i].scatter(np.nanmean(olr), np.nanmean(alb), color='r', s=25)
                      
if n==40:
    plt.savefig("../plots/TWP/jhist0.25deg_{}.png".format(region))
elif n==10:
    plt.savefig("../plots/TWP/jhist1deg_{}.png".format(region))
else:
    plt.savefig("../plots/TWP/jhistnative_{}.png".format(region))
plt.close()

# print mean olr alb values
print("DATA:   " + str(int(da_olr.mean().values)) + "   " + str(da_alb.where(da_alb.time.dt.hour<4).mean().values)+\
      "\nNICAM:  " + str(int(ni_olr.mean().values)) + "   " + str(ni_alb.where(ni_alb.time.dt.hour<4).mean().values)+\
      "\nSAM:    " + str(int(sa_olr.mean().values)) + "   " + str( sa_alb.where(sa_alb.time.dt.hour<4).mean().values)+\
      "\nUM:     " + str(int(um_olr.mean().values)) + "   " + str(um_alb.where(um_alb.time.dt.hour<4).mean().values)+\
      "\nGEOS:   " + str(int(ge_olr.mean().values)) + "   " + str(ge_alb.where(ge_alb.time.dt.hour<4).mean().values)+\
      "\nSCREAM  " + str(int(sc_olr.mean().values)) + "   " + str(sc_alb.where(sc_alb.time.dt.hour<4).mean().values)
     )
