load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/nfs3/Models/CESM-LE/atm/NEW/cmip5/nino34/"
    outdir  = "/nfs3/Models/CESM-LE/atm/NEW/cmip5/plot/"

    ; historical 40 MODESLS
    models = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
    	       "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FIO-ESM","GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3",\
    	       "HadGEM2-AO","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\
    	       "NorESM1-ME","NorESM1-M"/) 
    n = dimsizes(models)
    print(n)
    print("======1870-2005 regCoef =======")
    data = addfile(datadir+"obs/"+"nino34.obs-HadISST.187001-201412.nc","r")
    nino34_HadI = data->nino34(0:136*12-1)
    data = addfile(datadir+"obs/"+"nino34.obs-NOAA_ERSST-v4.185401-201412.nc","r")
    nino34_ERSST = data->nino34(16*12:152*12-1)
    nyr = dimsizes(nino34_ERSST)/12
    ;reg = regCoef(nino34_HadI,nino34_ERSST)
    ;print("obsreg= "+ reg)
    ccr = escorc(nino34_HadI,nino34_ERSST)
    print("obsccr= "+ ccr)
    
    do i =0, n-1

    	if (models(i).eq."GFDL-CM3".or.models(i).eq."HadGEM2-AO".or.models(i).eq."HadCM3") then
    		data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.186001-200512.nc","r")
    		nino34 = data->nino34(10*12:)
    	else 
            if (models(i).eq."GFDL-ESM2M".or.models(i).eq."GFDL-ESM2G") then
                data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.186101-200512.nc","r")
                nino34 = data->nino34(9*12:)
            else
        	    if (models(i).eq."MIROC5".or.models(i).eq."bcc-csm1-1".or.models(i).eq."bcc-csm1-1-m") then
                    data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.185001-201212.nc","r")
                    nino34 = data->nino34(20*12:156*12-1)
                else
                	if (models(i).eq."GISS-E2-R-CC".or.models(i).eq."GISS-E2-H-CC") then
                    	data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.185001-201012.nc","r")
                    	nino34 = data->nino34(20*12:156*12-1)
                	else
                    	data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.185001-200512.nc","r")
    		        	nino34 = data->nino34(240:1872-1)
    		        end if
                end if
            end if
    	end if
        nyr = dimsizes(nino34)/12
        ;reg = regCoef(nino34_HadI,nino34)
        ;print(models(i)+"_reg= "+reg)
        ccr = escorc(nino34_HadI,nino34)
        print(models(i)+"_ccr= "+ ccr)
        delete(nino34)
    end do

    print("======1950-2005 regCoef =======")
    reg = regCoef(nino34_HadI(80*12:),nino34_ERSST(80*12:))
    print("obsreg= "+ reg)
    nino34_all = new((/n,dimsizes(nino34_HadI(80*12:))/),typeof(nino34_HadI))
    ccr_all = new((/n/),typeof(nino34_HadI))
    do i =0, n-1
        if (models(i).eq."GFDL-CM3".or.models(i).eq."HadGEM2-AO".or.models(i).eq."HadCM3") then
            data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.186001-200512.nc","r")
            nino34 = data->nino34(90*12:)
        else 
            if (models(i).eq."GFDL-ESM2M".or.models(i).eq."GFDL-ESM2G") then
                data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.186101-200512.nc","r")
                nino34 = data->nino34(89*12:)
            else
                if (models(i).eq."MIROC5".or.models(i).eq."bcc-csm1-1".or.models(i).eq."bcc-csm1-1-m") then
                    data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.185001-201212.nc","r")
                    nino34 = data->nino34(100*12:156*12-1)
                else
                    if (models(i).eq."GISS-E2-R-CC".or.models(i).eq."GISS-E2-H-CC") then
                        data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.185001-201012.nc","r")
                        nino34 = data->nino34(100*12:156*12-1)
                    else
                        data = addfile(datadir+"20C/"+"nino34_Amon_"+models(i)+"_historical_r1i1p1.185001-200512.nc","r")
                        nino34 = data->nino34(100*12:1872-1)
                    end if
                end if
            end if
        end if
        nyr = dimsizes(nino34)/12
        ;reg = regCoef(nino34_HadI(80*12:),nino34)
        ;print(models(i)+"_reg= "+reg)
        ccr = escorc(nino34_HadI(80*12:),nino34)
        nino34_all(i,:) = nino34
        ccr_all(i)  = ccr
        print(models(i)+"_ccr= "+ ccr)
    end do
    nino34_all_ensmean_new  = new((/dimsizes(nino34)/),typeof(nino34))
    nino34_all_ensmean = new((/dimsizes(nino34)/),typeof(nino34))
    do i=0, dimsizes(nino34)-1
       nino34_all_ensmean_new(i) = sum(nino34_all(:,i)*ccr_all(:)/sum(ccr_all))
       nino34_all_ensmean(i) = sum(nino34_all(:,i))      
    end do
    ccr_new = escorc(nino34_HadI(80*12:),nino34_all_ensmean_new)
    ccr = escorc(nino34_HadI(80*12:),nino34_all_ensmean)
    print("ensmean_ccr= "+ ccr)
    print("ensmean_new_ccr= "+ ccr_new)
end