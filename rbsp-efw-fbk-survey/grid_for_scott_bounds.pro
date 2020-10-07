

dlshell = 0.5                   ;delta-Lshell for grid	
lmin = 2
lmax = 7
dtheta = 1.                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.

rbsp_survey_fbk_return_grid,info,dtheta,dlshell,lmin,lmax,tmin,tmax


help,info.grid,/st
;; RBSP_EFW> help,info.grid,/st
;; ** Structure <29c9208>, 14 tags, length=4720, data length=4720, refs=2:
;;    NTHETAS         LONG                24
;;    NSHELLS         LONG                10
;;    DTHETA          FLOAT           1.00000
;;    LMIN            INT              2
;;    LMAX            INT              7
;;    DLSHELL         FLOAT          0.500000
;;    EARTHX          FLOAT     Array[360]
;;    EARTHY          FLOAT     Array[360]
;;    EARTHY_SHADE    FLOAT     Array[360]
;;    GRID_LSHELL     FLOAT     Array[11]
;;    GRID_THETA      FLOAT     Array[25]
;;    GRID_THETA_RAD  FLOAT     Array[25]
;;    GRID_THETA_CENTER
;;                    FLOAT     Array[24]
;;    GRID_LSHELL_CENTER
;;                    FLOAT     Array[10]




;;Take timeseries data and divide it up into an [Lshell, MLT] array as
;;defined by the grid structure

;;In case you don't know tplot, the timeseries data in the
;;following routine are grabbed (line 55) out of tplot variables as:
;;     get_data,rbspx+'_nfbk_pk'+optstr,data=npk
;;This translates to:   get_data,'timeseries',data=npk
;;where npk.x are the time values and npk.y are the data

fstr = '0105'
rbsp_survey_fbk_percenttime_bin,info,fstr ;,/combinesc

;;gridded data
;; VALUES          FLOAT     = Array[10, 24]
;; COUNTS          FLOAT     = Array[10, 24]

;;create fake test data
values = fltarr(10, 24)
counts = values

values[4, *] = 0.5
counts[4, *] = 100.
text = 'text'
title = 'title'
cbtitle = 'cbtitle'

rbsp_efw_init

;;Send it into the contour plot routine
rbsp_survey_fbk_plot,info,values,counts,$
                     minc_vals=0.1,$
                     maxc_vals=1.,$
                     minc_cnt=1.,$
                     maxc_cnt=5000.,$
                     text=text,title=title,cbtitle=cbtitle,$
                     ps=0,$
                     formatleft='(F6.1)',$
                     formatright='(G8.1)',$
                     nvformatleft=5,$
                     nvformatright=5



