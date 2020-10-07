;Find an appropriate "min power" level that corresponds to BARREL activity. 
;This will help me to filter out inactive times so that my coherence statistics
;don't just reflect times when the balloons map the the radiation belts. 


pro create_active_time_list

;--------------------
;Define these variables
pmin = 5.
pmax = 10.
blk = 5.*3600.  ;Size of each block to find peak RMS power in (sec)
folder = 'periods_of_5.00-10.00_min/'
;--------------------


payload = ['i','t','w','k','l','x','a','b','e','o','p']
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/barrel_filtered_data/'+folder
rbsp_efw_init


for b=0,n_elements(payload)-1 do begin 


fn = 'barrel_2'+payload[b]+'_power.tplot'
store_data,tnames(),/delete
tplot_restore,file=path+fn

get_data,'fspc_2'+payload[b]+'_power',t,d
nelem = n_elements(t)


;yline
store_data,'yline',t,replicate(4d4,nelem)
store_data,'yline2',t,replicate(1d4,nelem)

pft = 'fspc_'




;--------------------------------------------------------
;Find peak RMS power in a block of time. This will help to define whether or not 
;there is sufficient activity during this time to be used in the statistics. 


get_data,pft +'2'+payload[b]+'_power',tt,dd
srt = sample_rate(tt,out_med_avg=ma)
srt = ma[0]

nelem = n_elements(tt)
nblk = nelem/blk/srt
blksizesec = nelem/nblk/srt
blksize = nelem/nblk

maxrms = fltarr(nblk)
tcenter = dblarr(nblk)
tmin = dblarr(nblk)
tmax = dblarr(nblk)
binvals = fltarr(nblk)
newtimes = tt[0] + dindgen(nblk)*blksizesec

for i=0d,nblk-2 do begin ;$
    t0 = tt[0] + i*blksizesec  ;& $
    t1 = t0 + blksizesec  ;& $
    goo = where((tt ge t0) and (tt le t1))  ;& $
    if goo[0] ne -1 then maxrms[i] = max(dd[goo],/nan) ;& $
    tcenter[i] = (t0 + t1)/2d ;& $
    tmin[i] = t0   ;& $
    tmax[i] = t1   ;& $  
    t0index = i*blksize   ;& $
    t1index = t0index + blksize   ;& $
    binvals[i:i+1] = maxrms[i]
endfor



openw,lun,path+'barrel_2'+payload[b]+'_block_power.txt',/get_lun
printf,lun,'Block start time       Block end time     Peak RMS power in block'
for i=0,n_elements(tmin)-1 do printf,lun,time_string(tmin[i]) + '   ' + time_string(tmax[i]) + '  '+string(binvals[i])
close,lun
free_lun,lun 



store_data,'blockvals',newtimes,binvals
store_data,'maxblk',tcenter,maxrms
store_data,'powercomb',data=['fspc_2'+payload+'_power','yline','maxblk']
store_data,'powermaxcomb',data=['fspc_2'+payload+'_powermax','yline2']
ylim,['powercomb','powermaxcomb'],1d3,1d7,1
options,'powercomb','colors',[0,0,250]


tplotvars = [pft+'2'+payload[b]+'_orig',$                     ;Original data w/o high freq noise
      pft+'2'+payload[b],$                              ;high pass filtered data
      pft+'2'+payload[b]+'_detrend',$                              ;high pass filtered data
      pft+'2'+payload[b]+'_detrend_SPECP',$
      'powercomb','powermaxcomb']
tplot,tplotvars

stop
endfor


end


;get_data,pft +'2'+payload+'_power',t,d
;nelem = n_elements(t)
;meanv = mean(d,/nan)
;medv = median(d)
;maxv = max(d,/nan)
;print,meanv,medv,maxv


;;1-30 min results
;;meanv, medv, maxv
;      21814.7      18268.4      160017. ;a
;
;;-----------------------------------------
;;5-10 min results
;;meanv, medv, maxv
;      2408.10      1963.10      18109.5 ;a
;      2364.56      2088.52      9306.44 ;b
;      2276.16      1912.96      7844.74 ;e
;      15932.4      2614.17      817392. ;i
;      2853.39      2208.01      16568.4 ;k
;      2881.84      2148.19      99632.7 ;l
;      1246.58      1137.58      4957.45 ;o
;      1800.87      1190.53      45409.9 ;p
;      2959.16      2091.60      44241.6 ;t
;      4008.73      2042.30      136206. ;w
;      2713.59      1986.89      98816.1 ;x
;;-----------------------------------------




