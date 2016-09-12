load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/home/sunchao/obs_data/SST/"
    outdir  = "/home/sunchao/obs_data/SST/"

	llats = -5.     ; nino3.4
	llatn = 5.
	llonw = 190.
	llone = 240.

	pi=4.*atan(1.0)
    rad=(pi/180.)

    
    data = addfile(datadir+"HadISST_sst.187001-201601.nc","r")
    sst  = data->sst(:-2,:,:) 
    time = data->time(:-2)
    n     = dimsizes(time)
    lat   = data->latitude
    lon   = data->longitude
    
    sst  = lonFlip(sst)
    sst  = rmMonAnnCycTLL(sst)    
    coswgt=cos(rad*sst2&latitude)
    coswgt!0 = "lat" 
    coswgt&lat= sst2&latitude  
    nino34 = wgt_areaave_Wrap(sst(:,{llats:llatn},{llonw:llone}),coswgt({llats:llatn}),1.0,0)
    lines = sprintf("%5.2f",nino34) 
    print(dimsizes(nino34))
    asciiwrite (outdir+"HadISST_nino34_timeseries.187001-201512.txt",lines)
end 