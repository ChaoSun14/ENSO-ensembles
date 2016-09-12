;=======================================================
; @Author:      Sun Chao
; @Email:       sunchao14@mails.tsinghua.edu.cn
; @DateTime:    2016-01-20 10:20:07
; @Description: To draw the power spectra of multi-models  
;=======================================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/home/sunchao/cmip5_data/ts_historical/"
    obsdir  = "/home/sunchao/obs_data/nino34/"
    outdir  = "/home/sunchao/ensmble/20c/plot/"

    ; historical 40 MODESLS
    models = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
    	       "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FIO-ESM","GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3",\
    	       "HadGEM2-AO","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\
    	       "NorESM1-ME","NorESM1-M"/) 
    type = (/"r1i1p1","r2i1p1","r3i1p1","r4i1p1","r5i1p1","r6i1p1","r7i1p1","r8i1p1","r9i1p1","r10i1p1"/)
    m    = dimsizes(type)
    n    = dimsizes(models)
    print(n)

    wks_type     = "png"
    wks_spec     = gsn_open_wks(wks_type,outdir+"nino34.powspec")
    ;wks_spec1   = gsn_open_wks(wks_type,outdir+"nino34.powspec_2")
    ;wks_spec2   = gsn_open_wks(wks_type,outdir+"nino34.powspec_3")
    
    data         = addfile(obsdir+"nino34.obs-HadISST.187001-201412.nc","r")
    nino34_HadI  = data->nino34(0:136*12-1)
    data         = addfile(obsdir+"nino34.obs-NOAA_ERSST-v4.185401-201412.nc","r")
    nino34_ERSST = data->nino34(16*12:152*12-1)
    nyr          = dimsizes(nino34_ERSST)/12
    ;----------------------  nino34 power spectra------------------------------------------------------------------------
        iopt        = 0                ; nino34 power spectra
        jave        = (7*nyr)/100
        val1        = .95
        val2        = .99
        pct         = 0.1 
        spectra_mvf = False        ; missing value flag for nino34
    
        if (any(ismissing(nino34_HadI))) then
            print("Missing data exists, power spectra function does not allow missing data")
            spectra_mvf = True
        else
            nino34_HadI_dt = dtrend_msg(ispan(0,dimsizes(nino34_HadI)-1,1),nino34_HadI,True,False)     
            sdof_HadI      = specx_anal(nino34_HadI_dt,iopt,jave,pct)
            splt1_HadI     = specx_ci(sdof_HadI,val1,val2)
        end if
        
        if (any(ismissing(nino34_ERSST))) then
            print("Missing data exists, power spectra function does not allow missing data")
            spectra_mvf = True
        else
            nino34_ERSST_dt = dtrend_msg(ispan(0,dimsizes(nino34_ERSST)-1,1),nino34_ERSST,True,False)     
            sdof_ERSST      = specx_anal(nino34_ERSST_dt,iopt,jave,pct)
            splt1_ERSST     = specx_ci(sdof_ERSST,val1,val2)
        end if

   
    ntime = nyr*12
    nnum  = 130
    name  = new((/nnum/),typeof(models))
    sdof  = new((/nnum/),"float")
    splt1 = new((/nnum,4,ntime/2/),"float")    
    nino34_all  = new((/nnum,ntime/),typeof(nino34_ERSST))
    nn  = 0
    
    do i =0, n-1
    do j =0, m-1
        print("============================================================")
        print(models(i)+ " is processing " )
        filename = systemfunc ("ls "+datadir+"ts_"+type(j)+"/"+"nino34_Amon_"+models(i)+"_historical_"+type(j)+"_*.nc")
        if(isfilepresent(filename)) then
            if (models(i).eq."GFDL-CM3".or.models(i).eq."HadGEM2-AO".or.models(i).eq."HadCM3") then
               data = addfile(filename,"r")
               nino34 = data->nino34(10*12:)
            else 
                if (models(i).eq."GFDL-ESM2M".or.models(i).eq."GFDL-ESM2G") then
                    data = addfile(filename,"r")
                    nino34 = data->nino34(9*12:)
                else
                    if (models(i).eq."MIROC5".or.models(i).eq."bcc-csm1-1".or.models(i).eq."bcc-csm1-1-m") then
                        data = addfile(filename,"r")
                        nino34 = data->nino34(20*12:156*12-1)
                    else
                        if (models(i).eq."GISS-E2-R-CC".or.models(i).eq."GISS-E2-H-CC") then
                           data = addfile(filename,"r")
                           nino34 = data->nino34(20*12:156*12-1)
                        else
                           data = addfile(filename,"r")
                           nino34 = data->nino34(240:1872-1)
                        end if
                    end if
                end if
            end if
            
            name(nn) = tostring(models(i))+"_"+tostring(type(j))
            print("end")
            nyr = dimsizes(nino34)/12
            
            nino34_all(nn,:) = nino34
        
            if (any(ismissing(nino34))) then
                print("Missing data exists, power spectra function does not allow missing data")
                spectra_mvf = True
            else
                nino34_dt    = dtrend_msg(ispan(0,dimsizes(nino34)-1,1),nino34,True,False)     
                sdof(nn)      = specx_anal(nino34_dt,iopt,jave,pct)
                splt1(nn,:,:) = specx_ci(sdof(nn),val1,val2)
            end if
            nn  = nn+1
        else
            print("No "+type(j)+" of "+models(i))
            continue
        end if
    end do
    end do
        splt1!2       = "time"
        splt1&time    = fspan(1,ntime/2,ntime/2)
        printVarSummary(sdof)
        printVarSummary(splt1)
    ;--先功率谱分析再做集合平均------------------------------------------------------------    
        sdof_ensmean  = dim_avg_n_Wrap(sdof, 0)
        splt1_ensmean = dim_avg_n_Wrap(splt1, 0)

    ;----筛选Power>100
    splt1_select = splt1
    sdof_select  = sdof
    do i = 0, nnum-1
        if (any(ismissing(max(splt1_select(i,0,:))))) then
            continue
        else
            if (max(splt1_select(i,0,:)).gt.100.) then
            splt1_select(i,:,:) = splt1@_FillValue 
            sdof_select(i)      = sdof@_FillValue
            end if
        end if   
    end do
    ;printVarSummary(splt1_select)
    ;printVarSummary(sdof_select)
    sdof_select_ensmean  = dim_avg_n_Wrap(sdof_select, 0)
    splt1_select_ensmean = dim_avg_n_Wrap(splt1_select, 0)     
    ;----先集合平均再做功率谱分析
    nino34_all_ensmean  = dim_avg_n_Wrap(nino34_all, 0)
    if (any(ismissing(nino34_all_ensmean))) then
        print("Missing data exists, power spectra function does not allow missing data")
        spectra_mvf = True
    else
        nino34_all_ensmean_dt = dtrend_msg(ispan(0,dimsizes(nino34_all_ensmean)-1,1),nino34_all_ensmean,True,False)     
        sdof_all              = specx_anal(nino34_all_ensmean_dt,iopt,jave,pct)
        splt1_all             = specx_ci(sdof_all,val1,val2)
    end if
    print(name)
    print("==========================")
    ;-----------------------------------------------------------------------------------------------------------------
    pspec         =  new(nnum,graphic)
    pepec_obs_ens =  new(4,graphic)
    pres                        = True
    pres@vpXF                   = 0.25
    pres@trXMinF                = 0.0
    pres@trXMaxF                = 0.0832
    pres@tiYAxisString          = "Power"              ; yaxis
    pres@xyLineColor            = "black"         
    pres@gsnFrame               = False
    pres@gsnDraw                = False     
    pres@tmXBLabelDeltaF        = -.8
    pres@tmXTLabelDeltaF        = -.8
    pres@pmLegendDisplayMode    = "Never"
    pres@xyLineThicknesses      = (/3.5,2.,1.,1./) 
    pres@xyDashPatterns         = (/0,0,0,0/)
    pres@xyLineColors           = (/"foreground","red","blue","green"/)      
    pres@xyLabelMode            = "custom"
    pres@xyLineLabelFontColors  = pres@xyLineColors 
    pres@xyExplicitLabels       = (/"","",val1*100+"%",val2*100+"%"/)
    pres@tmXTOn                 = True
    pres@tmYROn                 = False
    pres@tmXTLabelsOn           = True
    pres@tmXUseBottom           = False
    pres@tmXTMode               = "Explicit"  
    pres@tmXBMode               = "Explicit"            
    pres@tmXTValues             = (/".00167",".00833",".01667",".02778",".0416",".0556",".0832"/)
    pres@tmXTLabels             = (/"50","10","5","3","2","1.5","1"/)           
    pres@tmXBValues             = (/".0",".01",".02",".03",".042",".056",".083"/)
    pres@tmXBLabels             = pres@tmXBValues
    pres@tmXTLabelFontHeightF   = 0.024
    pres@tmXBLabelFontHeightF   = 0.024
    pres@tmYLLabelFontHeightF   = 0.024
    pres@tiYAxisString          = "Power (~S~o~N~C~S~2~N~ / cycles mo~S~-1~N~)"              ; yaxis
    pres@tiXAxisString          = "Frequency (cycles mo~S~-1~N~)"
    pres@tiMainString           = ""
    pres@txFontHeightF          = 0.030
    pres@xyLineLabelFontHeightF = 0.017
    pres@tiXAxisFontHeightF     = 0.032
    pres@tiYAxisFontHeightF     = 0.032
    pres@tiMainFontHeightF      = 0.032          
    ;pres@trYMaxF = max(splt1(0,:))+15
       

    ; +++++++++++++++
    pres@tmYLMode                   = "Manual"
    pres@trYMinF                    = 0.
    pres@trYMaxF                    = 120.
    pres@tmYLTickStartF             = 0.
    pres@tmYLTickEndF               = 120.
    pres@tmYLTickSpacingF           = 20.
    ; +++++++++++++++         
    pres@tiMainOn                   = False
    pres@gsnCenterString            = "Period (years)"
    pres@gsnCenterStringFontHeightF =    pres@tiYAxisFontHeightF                  
    pres@xyLineThicknessF           = 0.018                           
    pres@gsnCenterString            = ""
    do i = 0, nnum-1
        pres@gsnLeftString  = name(i) 
        pres@gsnRightString = ""   
        a                   = sdof(i)
        pspec(i)            = gsn_csm_xy(wks_spec,a@frq,splt1(i,:,:),pres)
    end do  
   pres@gsnLeftString = "obs-HadISST"
   pepec_obs_ens(0)   = gsn_csm_xy(wks_spec,sdof_HadI@frq,splt1_HadI,pres)
   pres@gsnLeftString = "Timeseries_ensmean"
   pepec_obs_ens(1)   = gsn_csm_xy(wks_spec,sdof_all@frq,splt1_all,pres)
   pres@gsnLeftString = "Powspec_ensmean"
   pepec_obs_ens(2)   = gsn_csm_xy(wks_spec,sdof_ensmean@frq,splt1_ensmean,pres)
   pres@gsnLeftString = "Select_Powspec_ensmean"
   pepec_obs_ens(3)   = gsn_csm_xy(wks_spec,sdof_select_ensmean@frq,splt1_select_ensmean,pres)

   res                            = True
   res@gsnPanelXWhiteSpacePercent = 2
   res@gsnPanelYWhiteSpacePercent = 1
   res@gsnPanelDebug              = True
   plotnew        = new(25*6, graphic)
   plotnew(4:nnum+3) = pspec
   plotnew(0:3)   = pepec_obs_ens
   do i=0,5
    gsn_panel(wks_spec, plotnew(i*25:i*25+24), (/5,5/), res)
   end do 
end 
     