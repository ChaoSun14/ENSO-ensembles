;=======================================================
; @Author:      Sun Chao
; @Email:       sunchao14@mails.tsinghua.edu.cn
; @DateTime:    2016-01-25 15:32:22
; @Description: To convert the .nc data to .txt data
;=======================================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
    datadir = "/home/sunchao/cmip5_data/rcp45/nino34/"
    outdir  = "/home/sunchao/cmip5_data/rcp45/nino34/txt.data/"

    ; RCP45 37 MODESLS
    models = (/"ACCESS1-0","ACCESS1-3","bcc-csm1-1","bcc-csm1-1-m","BNU-ESM","CanESM2","CCSM4","CESM1-BGC","CESM1-CAM5","CMCC-CM","CMCC-CMS",\
    	       "CNRM-CM5","CSIRO-Mk3-6-0","FGOALS-g2","FIO-ESM","GFDL-CM3","GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC",\
    	       "HadGEM2-CC","HadGEM2-ES","HadGEM2-AO","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR","IPSL-CM5B-LR","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3",\
    	       "NorESM1-ME","NorESM1-M"/) 
    type = (/"r2i1p1","r3i1p1","r4i1p1","r5i1p1","r6i1p1","r7i1p1","r8i1p1","r9i1p1","r10i1p1"/) ;"r1i1p1",
    n = dimsizes(models)
    m = dimsizes(type)
    do j = 0, m-1
        do i =0, n-1
            print("============================================================")
            print(models(i)+ " is processing " )
            filename = systemfunc ("ls "+datadir+type(j)+"/"+"nino34_Amon_"+models(i)+"_rcp45_"+type(j)+"_*.nc")
            if(isfilepresent(filename)) then 
                data = addfile(filename,"r")
    	        nino34 = data->nino34(0:95*12-1)
            else
                print("No "+type(j)+" of "+models(i))
                continue
            end if
    	   lines = sprintf("%5.2f",nino34)
           filename = models(i)+"_"+type(j)+"_rcp45_nino34_timeseries.200601-210012.txt"
           system("if ! test -d " + outdir+type(j) +" ; then mkdir " + outdir+type(j)+ " ; fi")
           system("rm -f "+outdir+type(j)+"/"+filename) 
    	   asciiwrite (outdir+type(j)+"/"+filename,lines)
           delete(nino34)
        end do
    end do
end




