;=======================================================
; @Author:      Sun Chao
; @Email:       sunchao14@mails.tsinghua.edu.cn
; @DateTime:    2016-01-19 12:44:02
; @Description: To convert the .nc data to .txt data  
;=======================================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/home/sunchao/cmip5_data/ts_historical/"
    outdir  = "/home/sunchao/cmip5_data/ts_historical/"

    ; historical 40 MODESLS
    models = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CESM1-FASTCHEM","CMCC-CESM","CMCC-CM","CMCC-CMS",\
    	       "CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-g2","FIO-ESM","GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3",\
    	       "HadGEM2-AO","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3",\
    	       "NorESM1-ME","NorESM1-M"/)
    type = (/"r1i1p1","r2i1p1","r3i1p1","r4i1p1","r5i1p1","r6i1p1","r7i1p1","r8i1p1","r9i1p1","r10i1p1"/) 
    m = dimsizes(type)
    n = dimsizes(models)
    print(n)
    do j = 0, m-1
    do i = 0, n-1
        print("============================================================")
        print(models(i)+ " is processing " )
        filename = systemfunc ("ls "+outdir+"ts_"+type(j)+"/"+"nino34_Amon_"+models(i)+"_historical_"+type(j)+"_*.nc")
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
        else
            print("No "+type(j)+" of "+models(i))
            continue 
        end if
        print("end")
        nyr = dimsizes(nino34)/12
        lines = sprintf("%5.2f",nino34) 
        asciiwrite (outdir+"txt.data/"+models(i)+"_"+type(j)+"_historical_nino34_timeseries.187001-200512.txt",lines)
        delete(nino34)
    end do
    end do
end 
    
