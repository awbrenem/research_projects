;Use READ_MYCDF to easily read multiple CDF files and specific or all variables
;within them.
;See https://spdf.gsfc.nasa.gov/CDAWlib.html for documentation of the CDAWlib
;package

;This version's set up to load multiple EFW L3 files

;**Crib sheet designed to be run by copy/paste


rbsp_efw_init

;Must include this to use the CDFWlib data package
@compile_cdaweb

;fileoutput = '~/Desktop/rbspb_l3_may29_june04_2013_jasmine'
fileoutput = '~/Desktop/rbspa_rhys'


;Load L3 files
path = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/TDAS_trunk_svn/general/missions/rbsp/efw/cdf_file_production/'
cdfnames = dialog_pickfile(/multiple_files,path=path)

;**Read in all variables...can take a while
r = read_mycdf('',/all,cdfnames)
;**Read in only select variables
;r = read_mycdf(['np_fit','vp_fit_RTN','sc_pos_HCI','sc_vel_HCI'],cdfnames)


;See contents of structure you've just read in
;help,r,/st


;Get the names of all the variables within the structure
varnames = tag_names(r)
varnames = varnames[where(varnames ne 'EPOCH')]


;get the times
t = r.epoch.dat


;**************************************************************
;;Use this if  CDF epoch times are milliseconds since 1-Jan-0000
;;(like the EFW CDFs)
t = real_part(t)
cdf_epoch,1000d*t,yr, mo, dy, hr, mn, sc, milli, /BREAK
tunix = strarr(n_elements(yr))
for i=0L,n_elements(tunix)-1 do tunix[i] = strtrim(yr[i],2)+'-'+strtrim(mo[i],2)+'-'+$
strtrim(dy[i],2)+'/'+strtrim(hr[i],2)+':'+strtrim(mn[i],2)+':'+$
strtrim(sc[i],2)+'.'+strtrim(milli[i],2)
tunix = time_double(tunix)

;**************************************************************
;;Use this if CDF times are in TT2000 times
;;(like Justin Kasper's PSP CDFs)
;t = long64(t)
;CDF_TT2000, t, yr, mo, dy, hr, mn, sc, milli, /BREAK
;tunix = strarr(n_elements(yr))
;yr = strtrim(floor(yr),2) & mo = strtrim(floor(mo),2) & dy = strtrim(floor(dy),2) & hr = strtrim(floor(hr),2) & mn = strtrim(floor(mn),2) & sc = strtrim(floor(sc),2) & milli = strtrim(floor(milli),2)
;
;;Pad with zeros
;goo = where(mo lt 10) & if goo[0] ne -1 then mo[goo] = '0'+mo[goo]
;goo = where(dy lt 10) & if goo[0] ne -1 then dy[goo] = '0'+dy[goo]
;goo = where(hr lt 10) & if goo[0] ne -1 then hr[goo] = '0'+hr[goo]
;goo = where(mn lt 10) & if goo[0] ne -1 then mn[goo] = '0'+mn[goo]
;goo = where(sc lt 10) & if goo[0] ne -1 then sc[goo] = '0'+sc[goo]
;goo = where(milli lt 10) & if goo[0] ne -1 then milli[goo] = '00'+milli[goo]
;goo = where((milli ge 10) and (milli lt 100)) & if goo[0] ne -1 then milli[goo] = '0'+milli[goo]
;
;tunix = yr+'-'+mo+'-'+$
;dy+'/'+hr+':'+mn+':'+$
;sc+'.'+milli
;tunix = time_double(tunix)
;;***************************************************


;now grab each quantity and store as tplot variable.
;This loop checks to see if the "data" is actually timeseries data
;by comparing the size of the data array to the time array
for j=0,n_elements(varnames)-1 do begin $
  strtmp = 'dat = r.'+varnames[j] + '.dat' & $
  void = execute(strtmp) & $
  sizetmp = size(dat) & $
  if sizetmp[0] eq 1 then sz = sizetmp[1] else sz = sizetmp[2] & $
  sizetst = n_elements(tunix) eq sz & $
  if sizetst then store_data,varnames[j],tunix,reform(transpose(dat))
endfor



vars = tnames()


;remove  -1.00000e+31 values
for i=0,n_elements(vars)-1 do begin $
  get_data,vars[i],data=dd,dlim=dlim,lim=lim  & $
  goo = where(dd.y lt -1.00000e+30)  & $
  if goo[0] ne -1 then dd.y[goo] = !values.f_nan & $
  store_data,vars[i],data=dd,dlim=dlim,lim=lim
endfor


;tplot,vars
tplot_save,vars,filename=fileoutput



;------------------------------------------------
;Make plots


tplot_restore,filename='~/Desktop/rbspb_l3_june27_july03_2013_jasmine.tplot'

rbsp_efw_init

charsz_plot = 0.8             ;character size for plots
charsz_win = 1.2
!p.charsize = charsz_win
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1


names = ['global_flag',$
         'eclipse',$
         'maneuver',$
         'efw_sweep',$
         'efw_deploy',$
         'v1_saturation',$
         'v2_saturation',$
         'v3_saturation',$
         'v4_saturation',$
         'v5_saturation',$
         'v6_saturation',$
         'Espb_magnitude',$
         'Eparallel_magnitude',$
         'wake',$
         'autobias',$
         'charging',$
         'charging_extreme',$
         'density',$
         'undefined',$
         'undefined']



split_vec,'FLAGS_ALL',suffix='_'+names


ylim,'FLAGS*',0,2
ylim,'EFIELD_IN_INERTIAL_FRAME_SPINFIT_EDOTB_MGSE',-20,20
ylim,'SPACECRAFT_POTENTIAL',-30,10

tplot_options,'title','L3 data for RBSPb'
tplot,['EFIELD_IN_INERTIAL_FRAME_SPINFIT_EDOTB_MGSE',$
'SPACECRAFT_POTENTIAL',$
'MLT',$
'LSHELL',$
'FLAGS_ALL_global_flag',$
'FLAGS_ALL_eclipse',$
'FLAGS_ALL_v1_saturation',$
'FLAGS_ALL_v2_saturation',$
'FLAGS_ALL_wake',$
'FLAGS_ALL_charging',$
'FLAGS_CHARGING_BIAS_ECLIPSE']



end
