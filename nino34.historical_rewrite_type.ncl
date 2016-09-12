;=======================================================
; @Author:      Sun Chao
; @Email:       sunchao14@mails.tsinghua.edu.cn
; @DateTime:    2016-01-18 16:47:51
; @Description: To calculate the nino34 index of different initial
;=======================================================

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/home/sunchao/cmip5_data/ts_historical/"
    outdir  = "/home/sunchao/cmip5_data/ts_historical/"
    
    ;type ="r1i1p1"
    
    ;40 models
    models = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
               "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FIO-ESM","GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3",\
               "HadGEM2-AO","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\
               "NorESM1-ME","NorESM1-M"/) 
    n = dimsizes(models)
    nnumber = 0
    print(n)
    print(models(n-1))
    do i = 0, n-1
        print("============================================================")
        print(models(i)+ " is processing " )
        ;ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc
        files = "/ts_Amon_"+models(i)+"_historical_"+type+"_*.nc"
        print(datadir+type+files)
        
        fils = systemfunc ("ls "+datadir+type+files) ; file paths
        print(isfilepresent(fils(0)))
        if(isfilepresent(fils(0))) then ; file paths  
            f    = addfiles (fils, "r")
            ListSetType (f, "cat")        ; concatenate (=default)
            if (models(i).eq."HadCM3") then
                sst   = f[:]->ts(1:,:,:)
            else
                sst   = f[:]->ts                ; read T from all files
            end if
            
            ;printVarSummary (sst)
        
        
            sst = where(sst.le.-1.8,-1.8,sst)
            d = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")   
            basemap = d->LSMASK
            lsm = landsea_mask(basemap,sst&lat,sst&lon)
            sst = mask(sst,conform(sst,lsm,(/1,2/)).ge.1,False)
            ;printStatInfo(sst)
            delete([/lsm,basemap/])
            delete(d)
        
            sst = rmMonAnnCycTLL(sst)
            iym = cd_calendar(sst&time, -1)
            ;printVarSummary(iym)
            n = dimsizes(iym)
        
            
            pi=4.*atan(1.0)
            rad=(pi/180.)
        
            coswgt=cos(rad*sst&lat)
            coswgt!0 = "lat" 
            coswgt&lat= sst&lat        
            llats = -5.     ; nino3.4
            llatn = 5.
            llonw = 190.
            llone = 240.
            nino34 = wgt_areaave_Wrap(sst(:,{llats:llatn},{llonw:llone}),coswgt({llats:llatn}),1.0,0)  
            nino34@area = llats+":"+llatn+"N, "+llonw+":"+llone+"E"
            nino34@units = sst@units
            nino34@long_name = "nino3.4 timeseries"
            ;printVarSummary(nino34)
            ;-------------------------------------------------------------------------------------------------
            filename = "nino34_Amon_"+models(i)+"_historical_"+type+"_"+tostring(iym(0))+"-"+tostring(iym(n-1))+".nc"
            print(outdir+"ts_"+type+"/"+filename)
            system("if ! test -d " + outdir+"ts_"+type +" ; then mkdir " + outdir+"ts_"+type + " ; fi")
            system("rm -f "+outdir+"ts_"+type+"/"+filename)
            out = addfile(outdir+"ts_"+type+"/"+filename,"c")
            out->nino34=nino34
            delete([/fils,f,sst,iym,coswgt,nino34/])
            nnumber = nnumber+1
        else
            print("No "+type+" of "+models(i))
            delete([/fils/])
            continue
        end if
 
        print("end")
        print(nnumber)
    end do
    
 end