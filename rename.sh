#!/bin/sh
# @Author:       Sun Chao
# @Email:        sunchao14@mails.tsinghua.edu.cn
# @DateTime:     2016-01-25 17:03:07
# @Description:  To rename the .txt data 
for var in *.txt; do mv "$var" "${var%_rcp45_nino34_timeseries.200601-210012.txt}_r1i1p1_rcp45_nino34_timeseries.200601-210012.txt"; done