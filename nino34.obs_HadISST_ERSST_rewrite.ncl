load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/nfs2/Models/CESM-LE/atm/NEW/obs_data/SST/"
    outdir  = "/nfs2/Models/CESM-LE/atm/NEW/cmip5/nino34/obs/"
    firname1 = "nino34.obs-HadISST.187001-201412.nc"
    firname2 = "nino34.obs-NOAA_ERSST-v4.185401-201412.nc"


    llats = -5.     ; nino3.4
	llatn = 5.
	llonw = 190.
	llone = 240.

	pi=4.*atan(1.0)
    rad=(pi/180.)

    
    data = addfile(datadir+"HadISST_sst.ts.187001-201503.nc","r")
    sst  = data->sst(0:145*12-1,:,:)
    time = data->time(:)
    sst  = lonFlip(sst)
    sst  = rmMonAnnCycTLL(sst)    
    coswgt=cos(rad*sst&latitude)
    coswgt!0 = "lat" 
    coswgt&lat= sst&latitude  
    nino34 = wgt_areaave(sst(:,{llats:llatn},{llonw:llone}),coswgt({llats:llatn}),1.0,0) 
   
    
    printVarSummary(nino34)
    ;-------------------------------------------------------------------------------------------------
    system("rm -f "+outdir+firname1)
    out = addfile(outdir+firname1,"c")
    out->nino34=nino34
    delete([/nino34,coswgt,sst,time/])
;-------------------------------------------------------------------------------------------------------
    data = addfile(datadir+"NOAA_ERSST-v4_sst.185401-201506.nc","r")
    sst  = short2flt(data->sst(0:161*12-1,0,{llats:llatn},{llonw:llone})) 
    time = data->T(:)
    sst = rmMonAnnCycTLL(sst)    
    coswgt=cos(rad*sst&Y)
    coswgt!0 = "lat" 
    coswgt&lat= sst&Y  
    nino34 = wgt_areaave(sst(:,{llats:llatn},{llonw:llone}),coswgt({llats:llatn}),1.0,0) 
   
    
    printVarSummary(nino34)
    ;-------------------------------------------------------------------------------------------------
    system("rm -f "+outdir+firname2)
    out = addfile(outdir+firname2,"c")
    out->nino34=nino34
    delete([/nino34,coswgt,sst,time/])

end