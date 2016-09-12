load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/nfs2/Models/CESM-LE/atm/NEW/cmip5/nino34/"
    outdir  = "/nfs2/Models/CESM-LE/atm/NEW/cmip5/plot/"

    ; historical 40 MODESLS
    models = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
               "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FIO-ESM","GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3",\
               "HadGEM2-AO","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\
               "NorESM1-ME","NorESM1-M"/)  
    n = dimsizes(models)
    plot = new(n, graphic)
    plot_obs = new(2, graphic)
    wks_type = "png"
    wks  = gsn_open_wks(wks_type,outdir+"nino34.timeseries_1")
    wks1 = gsn_open_wks(wks_type,outdir+"nino34.timeseries_2")
    wks2 = gsn_open_wks(wks_type,outdir+"nino34.timeseries_3")
    
     xyres = True
     xyres@gsnDraw = False
     xyres@gsnFrame = False
     xyres@gsnRightString = ""
     xyres@gsnLeftString = ""
     xyres@gsnYRefLine = 0.0
     xyres@gsnYRefLineColor = "gray42"
     xyres@xyLineColor = "gray62"
     xyres@xyLineThicknessF = .75  	     
     xyres@tiYAxisString = ""
     xyres@tmXBLabelFontHeightF = 0.017
     xyres@tmYLLabelFontHeightF = 0.017
     xyres@gsnLeftStringFontHeightF = 0.024
     xyres@gsnCenterStringFontHeightF = 0.024
     xyres@gsnRightStringFontHeightF = 0.024               
     xyres@vpHeightF = 0.2
     xyres@vpWidthF = 0.9	    
     xyres@gsnCenterString = ""	     
     xyres@tiMainOn = False	
     ; +++++++++++++++
     xyres@tmYLMode = "Manual"
     xyres@trYMinF = -4.0
     xyres@trYMaxF = 4.0
     xyres@tmYLTickStartF = -4.0
     xyres@tmYLTickEndF = 4.0
     xyres@tmYLTickSpacingF = 2.0
     ; +++++++++++++++
     xyres@gsnXYAboveFillColors = "red"
     xyres@gsnXYBelowFillColors = "blue"

     data = addfile(datadir+"obs/"+"nino34.obs-HadISST.187001-201412.nc","r")
     nino34_HadI = data->nino34(0:136*12-1)
     data = addfile(datadir+"obs/"+"nino34.obs-NOAA_ERSST-v4.185401-201412.nc","r")
     nino34_ERSST = data->nino34(16*12:152*12-1)
     nyr = dimsizes(nino34_ERSST)/12
    reg = regCoef(nino34_HadI,nino34_ERSST)
    print("reg= "+ reg)

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

        
     	tttt = dtrend_msg(ispan(0,dimsizes(nino34)-1,1),nino34,False,True)
     	arr = new((/2,dimsizes(nino34)/),typeof(nino34))
        xyres@gsnLeftString ="("+tostring(i+1)+")"+ models(i)
        arr(0,:) = (/nino34/)
        arr(1,:) = (/ (ispan(0,dimsizes(nino34)-1,1)*tttt@slope)+tttt@y_intercept /)
        xyres@gsnRightString = "stddev: "+decimalPlaces(stddev(nino34), 2, True)+",  trend: "+\
        decimalPlaces(tttt@slope*dimsizes(nino34),2,True)+"~S~o~N~C"+" "+nyr+"yr~S~-1~N~"
        if (i.le.11) then
            plot(i) = gsn_csm_xy(wks,fspan(0,nyr+.91667,nyr*12),arr,xyres)
        else
            if (i.le.25) then
                plot(i) = gsn_csm_xy(wks1,fspan(0,nyr+.91667,nyr*12),arr,xyres)
            else 
                plot(i) = gsn_csm_xy(wks2,fspan(0,nyr+.91667,nyr*12),arr,xyres)
            end if
        end if
        
        delete([/nino34,arr,tttt/])
    end do 

    
    nyr = dimsizes(nino34_HadI)/12
    xyres@gsnLeftString = "obs-HadISST"
    tttt = dtrend_msg(ispan(0,dimsizes(nino34_HadI)-1,1),nino34_HadI,False,True)
    arr = new((/2,dimsizes(nino34_HadI)/),typeof(nino34_HadI))
    arr(0,:) = (/nino34_HadI/)
    arr(1,:) = (/ (ispan(0,dimsizes(nino34_HadI)-1,1)*tttt@slope)+tttt@y_intercept /)
    xyres@gsnRightString = "stddev: "+decimalPlaces(stddev(nino34_HadI), 2, True)+",  trend: "+\
    decimalPlaces(tttt@slope*dimsizes(nino34_HadI),2,True)+"~S~o~N~C"+" "+nyr+"yr~S~-1~N~"
    plot_obs(0) = gsn_csm_xy(wks,fspan(0,nyr+.91667,nyr*12),arr,xyres)
    delete([/arr,tttt/])

    
    nyr = dimsizes(nino34_ERSST)/12
    xyres@gsnLeftString = "obs-NOAA_ERSST-v4"
    tttt = dtrend_msg(ispan(0,dimsizes(nino34_ERSST)-1,1),nino34_ERSST,False,True)
    arr = new((/2,dimsizes(nino34_ERSST)/),typeof(nino34_ERSST))
    arr(0,:) = (/nino34_ERSST/)
    arr(1,:) = (/ (ispan(0,dimsizes(nino34_ERSST)-1,1)*tttt@slope)+tttt@y_intercept /)
    xyres@gsnRightString = "stddev: "+decimalPlaces(stddev(nino34_ERSST), 2, True)+",  trend: "+\
    decimalPlaces(tttt@slope*dimsizes(nino34_ERSST),2,True)+"~S~o~N~C"+" "+nyr+"yr~S~-1~N~"
    plot_obs(1) = gsn_csm_xy(wks,fspan(0,nyr+.91667,nyr*12),arr,xyres)
    delete([/arr,tttt/])



     res = True
     res@gsnPanelXWhiteSpacePercent = 2
     res@gsnPanelYWhiteSpacePercent = 1
     res@gsnPanelDebug = True
     plotnew = new(n+2, graphic)
     plotnew(2:n+1)= plot
     plotnew(0:1) = plot_obs
     gsn_panel(wks, plotnew(0:13), (/7,2/), res) 
     gsn_panel(wks1, plotnew(14:27), (/7,2/), res)
     gsn_panel(wks2, plotnew(28:n+1), (/7,2/), res)
     

end 

