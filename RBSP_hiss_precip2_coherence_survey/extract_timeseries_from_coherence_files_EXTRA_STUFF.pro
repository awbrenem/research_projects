;Take the coherence files (e.g. AB.tplot, created from py_create_coh_tplot.pro) and extract
;timeseries data that will be inputted into timeseries_reduce_to_pk_and_npk.pro)


function extract_timeseries_from_coherence_files,combos,path


;**********************
;THINGS TO ADD
;--In BARREL movies, color code the square for each balloon payload according to whether
;  there is significant precipitation or not. 
;--Movie showing timebar moving across coherence plot along with 
;   dial plot of payload positions, indicated by * symbols. During times of 
;   coherence, connect the two payload positions, change their color to RED, and
;   increase the symbol size based total coherence. This will help to tag 
;   increase in coherence to solar wind structures. 
;--Overplot Goldstein plasmapause onto the movie
;--There are some coherence combinations where the Lshell of
;   one of the payloads is zero.
;--CALCULATE TOTAL SPAN OF CERTAIN COHERENCE EVENTS USING ALL THE PAYLOAD COMBINATIONS THAT SEE THEM
;--Limit the coherence vs delta-MLT plot by including only values where the Lshell of the
;   two payloads is within a certain range. This may clean up the plot?
;--TEST CONSISTENCY OF FINAL RESULTS B/T DIFFERENT "RUNS" (e.g. "run1", "run2", "run3")
;--CONSIDER COMBINING RESULTS FROM BOTH BALLOONS. I.E. PLOT THE %OCC VALUES FOR BALLOON 1 ON
;   THE DIAL PLOT, THEN OVERPLOT THE RESULTS FROM BALLOON 2. THIS AUTOMATICALLY ACCOUNTS FOR THE
;   SPREAD IN L AND MLT THAT OCCURS. MAYBE BETTER THAN USING THE AVERAGE VALUE.
;--ADD AVERAGE MLT TO THE MLT DIFFERENCE PROGRAM.
;--CALCULATE MLT AVERAGE IN A NON STUPID WAY
;--Plot coherence vs delta-MLT and delta-Lshell. One possible problem with the dial plots is that
;  high coherence will naturally show up for two payloads that are extremely close together.
;**********************


;.compile /Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/dial_plot_peak_and_percentoccurrence/return_L_MLT_grid.pro
;.compile /Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/dial_plot_peak_and_percentoccurrence/dial_plot.pro
;.compile /Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/dial_plot_peak_and_percentoccurrence/percentoccurrence_L_MLT_calculate.pro
;****Temporary
run = 'tplot_vars_2014_run2'

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path = path + run

;path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/tplot_vars_2014_120min_top/'
combos = ['IT','IW','IK','IL','IX','TW','TK','TL','TX','WK','WL','WX','KL','KX','LX','LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']
store_data,tnames(),/delete


mincoh = 0.7
periodmin = 10.
periodmax = 60.
;periodmin = 2.
;periodmax = 20.
max_mltdiff = 12.
max_ldiff=10.

ratiomax = 2.  ;for 2-20 min periods 
;ratiomax = 1.05 ;for >20 min periods
dt = 1*3600./2.  ;time chunk size for dial plot. 
threshold = 0.0001   ;set low. These have already been filtered.



pp_relative_distance = 0   ;use distance w/r to plasmapause (=1) or usual Lshell (=0)


dlshell = 1                   ;delta-Lshell for grid
lmin = 2
lmax = 12
dtheta = 2                     ;delta-theta (hours) for grid
tmin = 0.
tmax = 24.
grid = return_L_MLT_grid(dtheta,dlshell,lmin,lmax,tmin,tmax)


Earthx = grid.Earthx
Earthy = grid.Earthy
Earthy2 = grid.Earthy_shade

ncombos = n_elements(combos)
nmlts = grid.nthetas
nlshells = grid.nshells

values = fltarr(ncombos,nlshells,nmlts)
perocc = fltarr(ncombos,nlshells,nmlts)
counts = fltarr(ncombos,nlshells,nmlts)


rbsp_efw_init

window,3,xsize=600,ysize=800

;x and y differences (cartesian from polar L and MLT) of ALL the coherence values 
;from all the payloads. Used for final big plot of balloon separations 
xv1 = 0.
xv2 = 0.
yv1 = 0.
yv2 = 0.
lshellF1 = 0. 
lshellF2 = 0. 
mltF1 = 0.
mltF2 = 0. 


for i=0,ncombos-1 do begin
  print,combos[i]


  p1 = strmid(combos[i],0,1)
  p2 = strmid(combos[i],1,1)

;if combos[i] eq 'WK' then stop

  tplot_restore,filenames=path + '/' + combos[i] + '.tplot'
  copy_data,'coh_'+combos[i]+'_meanfilter','coh_'+combos[i]+'_meanfilter_original'

  filter_coherence_spectra,'coh_'+combos[i]+'_meanfilter','lshell_2'+p1,'lshell_2'+p2,'mlt_2'+p1,'mlt_2'+p2,$
    mincoh,$
    periodmin,periodmax,$
    max_mltdiff,$
    max_ldiff,$
    /remove_lshell_undefined,$
    /remove_mincoh,$
    /remove_slidingwindow,$
    /remove_max_mltdiff,$
    /remove_max_ldiff,$
    ratiomax=ratiomax


;;-------------------------------------------
;;Extract timeseries from coherence spectra
;;-------------------------------------------

  get_data,'coh_'+combos[i]+'_meanfilter',data=d,dlim=dlim,lim=lim
  periods = d.v
  t0 = min(d.x,/nan)
  t1 = max(d.x,/nan)



goodperiods = where((d.v ge periodmin) and (d.v le periodmax))

;-------------------------------------------------------------------
;Find peak coherence for each time over the considered wave periods
;-------------------------------------------------------------------

peak_value = fltarr(n_elements(d.x))
for j=0,n_elements(d.x)-1 do peak_value[j] = max(d.y[j,goodperiods],/nan)
store_data,combos[i]+'_peak_value',d.x,peak_value



;----------------------------------------------------------------------
;Now find peak and %occurrence values for each time chunk "dt"
;----------------------------------------------------------------------

timeseries_reduce_to_pk_and_npk,combos[i]+'_peak_value',dt,threshold
copy_data,'peakv',combos[i]+'_values'
copy_data,'totalcounts',combos[i]+'_totalcounts'
copy_data,'totalcounts_above_threshold',combos[i]+'_totalcounts_above_threshold'
options,combos[i]+'_'+['values','totalcounts','totalcounts_above_threshold'],'psym',-2
;tplot,combos[i]+'_'+['values','totalcounts','totalcounts_above_threshold']



  load_barrel_plasmapause_distance,'2'+p1
  load_barrel_plasmapause_distance,'2'+p2


;;Interpolate to times on timebase "dt"
tinterpol_mxn,'dist_pp_2'+p1,combos[i]+'_values',newname='dist_pp_2'+p1+'_interp'
tinterpol_mxn,'dist_pp_2'+p2,combos[i]+'_values',newname='dist_pp_2'+p2+'_interp'
tinterpol_mxn,'lshell_2'+p1,combos[i]+'_values',newname='lshell_2'+p1+'_interp'
tinterpol_mxn,'lshell_2'+p2,combos[i]+'_values',newname='lshell_2'+p2+'_interp'
tinterpol_mxn,'mlt_2'+p1,combos[i]+'_values',newname='mlt_2'+p1+'_interp'
tinterpol_mxn,'mlt_2'+p2,combos[i]+'_values',newname='mlt_2'+p2+'_interp'


;Find average L and MLT values
get_data,'dist_pp_2'+p1+'_interp',t1,d1
get_data,'dist_pp_2'+p2+'_interp',t1,d2
store_data,combos[i]+'_distppavg',t1,(d1+d2)/2.

get_data,'mlt_2'+p1+'_interp',t1,d1
get_data,'mlt_2'+p2+'_interp',t1,d2
;store_data,combos[i]+'_mltavg',t1,(d1+d2)/2.
get_data,'lshell_2'+p1+'_interp',t1,d1
get_data,'lshell_2'+p2+'_interp',t1,d2
store_data,combos[i]+'_lshellavg',t1,(d1+d2)/2.
options,[combos[i]+'_lshellavg',$
'lshell_2'+p1+'_interp','lshell_2'+p2+'_interp'],'psym',-2
options,['mlt_2'+p1+'_interp','mlt_2'+p2+'_interp','mltdiff1'],'psym',-2

ylim,['mlt_2'+p1+'_interp','mlt_2'+p2+'_interp'],0,24
ylim,['lshell_2'+p1+'_interp','lshell_2'+p2+'_interp',combos[i]+'_lshellavg'],0,30
ylim,['dist_pp_2'+p1+'_interp','dist_pp_2'+p1+'_interp',combos[i]+'_distppavg'],-10,10


;-----------------------------------------------------------------
;Make plot of payload separations during times of high correlation
;-----------------------------------------------------------------

ylim,['coh_'+combos[i],'coh_'+combos[i]+'_meanfilter','coh_'+combos[i]+'_meanfilter_original'],2,20,1

tplot,['coh_'+combos[i]+'_meanfilter_original','coh_'+combos[i]+'_meanfilter',combos[i]+'_totalcounts_above_threshold',$
    combos[i]+'_values',$
    'mlt_2'+p1+'_interp','mlt_2'+p2+'_interp','lshell_2'+p1+'_interp','lshell_2'+p2+'_interp','*flag*']


get_data,combos[i]+'_totalcounts_above_threshold',data=tc
yoo = where(tc.y ne 0.)
if yoo[0] ne -1 then begin
  get_data,'mlt_2'+p1+'_interp',data=mlt1
  get_data,'mlt_2'+p2+'_interp',data=mlt2
  get_data,'lshell_2'+p1+'_interp',data=lshell1
  get_data,'lshell_2'+p2+'_interp',data=lshell2

  timestmp = lshell1.x[yoo]
  mlt1 = mlt1.y[yoo]
  mlt2 = mlt2.y[yoo]
  lshell1 = lshell1.y[yoo]
  lshell2 = lshell2.y[yoo]

  mlt1_rad = (mlt1/24.)*2*3.14
  mlt2_rad = (mlt2/24.)*2*3.14


!p.multi = [0,0,1]
  plot,[0,0],xrange=[-20,20],yrange=[-20,20],/nodata,/isotropic
  oplot,Earthx,Earthy
  polyfill,Earthx,Earthy2

for b=0,n_elements(mlt1)-1 do begin

  lshellF1 = [lshellF1,lshell1[b]]
  lshellF2 = [lshellF2,lshell2[b]]
  mltF1 = [mltF1,mlt1_rad[b]]
  mltF2 = [mltF2,mlt2_rad[b]]

  xv1 = [xv1,lshell1[b]*sin(mlt1_rad[b])]
  yv1 = [yv1,-1*lshell1[b]*cos(mlt1_rad[b])]
  xv2 = [xv2,lshell2[b]*sin(mlt2_rad[b])]
  yv2 = [yv2,-1*lshell2[b]*cos(mlt2_rad[b])]



;Plot for each payload combination
  timebar,timestmp[b]
  xv1tmp = lshell1[b]*sin(mlt1_rad[b])
  yv1tmp = -1*lshell1[b]*cos(mlt1_rad[b])
  xv2tmp = lshell2[b]*sin(mlt2_rad[b])
  yv2tmp = -1*lshell2[b]*cos(mlt2_rad[b])
  oplot,[xv1tmp,xv1tmp],[yv1tmp,yv1tmp],psym=-2
  oplot,[xv2tmp,xv2tmp],[yv2tmp,yv2tmp],psym=-2,color=250
  oplot,[xv1tmp,xv2tmp],[yv1tmp,yv2tmp]


endfor


endif



;-----------------------------------------------------------------------
;;ADJUST THE DISTANCE TO PLASMAPAUSE SO THAT WE ONLY HAVE POSITIVE VALUES.
;The data are shifted so that the plasmapause location is at L=5.
;-----------------------------------------------------------------------

if keyword_set(pp_relative_distance) then begin
  get_data,'dist_pp_2'+p1+'_interp',data=ii
  if is_struct(ii) then ii.y += 5.
  if is_struct(ii) then store_data,'dist_pp_2'+p1+'_interp',data=ii
  get_data,'dist_pp_2'+p2+'_interp',data=ii
  if is_struct(ii) then ii.y += 5.
  if is_struct(ii) then store_data,'dist_pp_2'+p2+'_interp',data=ii

  pertime = percentoccurrence_L_MLT_calculate($
  dt,$
  combos[i]+'_totalcounts_above_threshold',$
  combos[i]+'_values',$
  'mlt_2'+p1+'_interp','dist_pp_2'+p1+'_interp',grid=grid)
endif

;Normal Lshell
if ~keyword_set(pp_relative_distance) then begin
  pertime = percentoccurrence_L_MLT_calculate($
    dt,$
    combos[i]+'_totalcounts_above_threshold',$
    combos[i]+'_values',$
    'mlt_2'+p1+'_interp','lshell_2'+p1+'_interp',grid=grid)
endif



;----------------------------------------------------------------------


;values = pertime.percent_peaks
perocc[i,*,*] = pertime.percent_peaks
values[i,*,*] = pertime.peaks
counts[i,*,*] = pertime.counts


;tplot,['coh_'+combos[i]+'_meanfilter',combos[i]+'_values',combos[i]+'_totalcounts',combos[i]+'_totalcounts_above_threshold',$
;combos[i]+'_lshellavg','lshell_2'+p1+'_interp','lshell_2'+p2+'_interp','mlt_2'+p1+'_interp','mlt_2'+p2+'_interp']
;print,total(values[i,*,*]),total(counts[i,*,*]),total(perocc[i,*,*])


;TEST dial plot for each combo.
;dial_plot,reform(values[i,*,*]),reform(counts[i,*,*]),grid
;stop



;*********************
;TEST DIAL PLOT FOR EACH PAYLOAD
;*********************

;Average the perocc and peak values.
peroccavg = fltarr(nlshells,nmlts)  ;%occurrence of coherence values above minimum coherence averaged across all payload combinations
peakavg = fltarr(nlshells,nmlts)    ;Peak coherence value averaged across all payload combinations
peakmax = fltarr(nlshells,nmlts)    ;Maximum coherence value in each bin (all payload combinations considered)
peaktotal = fltarr(nlshells,nmlts)  ;Total coherence summed over all payload combinations (not normalized)
totalcounts = fltarr(nlshells,nmlts) ;Total number of counts in each bin summed over all payload combinations
totalhits = fltarr(nlshells,nmlts)  ;Number of instances in each bin (for all payloads) with > 0 counts.

for l=0,nlshells-1 do for m=0,nmlts-1 do peroccavg[l,m] = reform(total(perocc[i,l,m],/nan));/n_elements(combos)
for l=0,nlshells-1 do for m=0,nmlts-1 do peakavg[l,m] = reform(total(values[i,l,m],/nan));/n_elements(combos)
for l=0,nlshells-1 do for m=0,nmlts-1 do peakmax[l,m] = reform(max(values[i,l,m],/nan))
for l=0,nlshells-1 do for m=0,nmlts-1 do peaktotal[l,m] = reform(total(values[i,l,m],/nan))
for l=0,nlshells-1 do for m=0,nmlts-1 do totalcounts[l,m] = reform(total(counts[i,l,m],/nan))
for l=0,nlshells-1 do for m=0,nmlts-1 do totalhits[l,m] = reform(n_elements(where(counts[i,l,m] ne 0.)))

;Eliminate low count sectors
;goob = where(totalcounts le 10.)
;if goob[0] ne -1 then totalcounts[goob] = 0.
;if goob[0] ne -1 then peroccavg[goob] = 0.
;if goob[0] ne -1 then peakavg[goob] = 0.
;if goob[0] ne -1 then peakmax[goob] = 0.
;if goob[0] ne -1 then peaktotal[goob] = 0.
;if goob[0] ne -1 then totalhits[goob] = 0.



store_data,'fspc_20-40min_'+combos[i],data=['fspc_2'+p1+'_smoothed_detrend_20-40min','fspc_2'+p2+'_smoothed_detrend_20-40min']
options,'fspc_20-40min_'+combos[i],'colors',[0,250]

options,[combos[i]+'_values',combos[i]+'_totalcounts',combos[i]+'_totalcounts_above_threshold'],'colors',250
options,['lshell_2'+p1+'_interp','lshell_2'+p2+'_interp',combos[i]+'_lshellavg'],'colors',140
options,['mlt_2'+p1+'_interp','mlt_2'+p2+'_interp','mltdiff1',combos[i]+'_mltavg'],'colors',50


ylim,'coh_'+combos[i]+'_meanfilter',periodmin,periodmax



;timespan,t0,(t1-t0),/seconds
;tplot,['ratiocomb','coh_'+combos[i],'coh_'+combos[i]+'_meanfilter',$
;;'fspc_20-40min_'+combos[i],$
;'fspc_2'+p1+'_smoothed_detrend_20-40min','fspc_2'+p2+'_smoothed_detrend_20-40min',$
;combos[i]+'_values',combos[i]+'_totalcounts',combos[i]+'_totalcounts_above_threshold',$
;'lshell_2'+p1+'_interp','lshell_2'+p2+'_interp','ldiff1',$
;'mlt_2'+p1+'_interp','mlt_2'+p2+'_interp','mlt_2'+p1+'_interp-mlt_2'+p2+'_interp'],window=3

;print,'***PRINT STATEMENT TO BRING TERMINAL BACK TO FOREFRONT***'
;stop

;dial_plot,peakavg,totalcounts,grid,minc_vals=0.6,maxc_vals=0.9
;print,combos[i]
;stop
;****************************
;Plot coherence vs delta-MLT
;****************************


;tplot,[combos[i]+'_totalcounts_above_threshold','coh_'+combos[i]+'_meanfilter',combos[i]+'_values','mlt_2'+p1+'_interp1-mlt_2'+p2+'_interp1']

;get_data,combos[i]+'_totalcounts_above_threshold',data=d1
get_data,'mlt_2'+p1+'_interp-mlt_2'+p2+'_interp',data=dmlt
get_data,combos[i]+'_avg_sliding',data=avgslid
get_data,combos[i]+'_avg_nosliding',data=avgnoslid
get_data,combos[i]+'_peak_value',data=pkv

;;plot,dmlt.y,d1.y,xrange=[0,6]
;!p.multi = [0,0,1]
;if i eq 0 then plot,dmlt.y,avgslid.y,xrange=[0,12],yrange=[0.7,1],psym=2,xtitle='dMLT',ytitle='Sliding average coherence'
;;if i ge 0 then oplot,dmlt.y,avgslid.y,psym=2
;;if i ge 0 then oplot,dmlt.y,avgnoslid.y,psym=2
;if i ge 0 then oplot,dmlt.y,pkv.y,psym=2




;Remove tplot variables of current combo. Otherwise you end up with too many variables and the
;code runs very slowly.
;store_data,[combos[i]+'*','coh_'+combos[i]+'*','mlt_2'+p1+'*','mlt_2'+p2+'*','lshell_2'+p1+'*','lshell_2'+p2+'*'],/delete
store_data,['mlt_2'+p1+'*','mlt_2'+p2+'*','lshell_2'+p1+'*','lshell_2'+p2+'*'],/delete
store_data,['*2'+p1+'*','*2'+p2+'*'],/delete
store_data,'*fspc*',/delete
store_data,combos[i]+'_'+['peak_value','values','totalcounts','totalcounts_above_threshold','distppavg','lshellavg'],/delete

endfor  ;for all combos



;-------------------------------------------
;Make dial plot of the payload separations during
;times of coherence
;-------------------------------------------

!p.multi = [0,0,1]
  plot,[0,0],xrange=[-10,10],yrange=[-10,10],/nodata,/isotropic
  oplot,Earthx,Earthy
  polyfill,Earthx,Earthy2


for b=0,n_elements(xv1)-1 do oplot,[xv1[b],xv1[b]],[yv1[b],yv1[b]],psym=-2
for b=0,n_elements(xv1)-1 do oplot,[xv2[b],xv2[b]],[yv2[b],yv2[b]],psym=-2,color=250
for b=0,n_elements(xv1)-1 do oplot,[xv1[b],xv2[b]],[yv1[b],yv2[b]]


stop


;-------------------------------------------
;Plot histograms of delta-L and delta-MLT 
;-------------------------------------------

mltF1 = 24.*mltF1/(2.*!pi) 
mltF2 = 24.*mltF2/(2.*!pi) 

;dummy times so I can use calculate_angle_difference
tt0 = time_double('1970-01-01/00:00')
timetmps = tt0 + indgen(n_elements(mltF1))
store_data,'tvar1_mlt',data={x:timetmps,y:mltF1}
store_data,'tvar2_mlt',data={x:timetmps,y:mltF2}
calculate_angle_difference,'tvar1_mlt','tvar2_mlt'
get_data,'tvar1_mlt-tvar2_mlt',data=mltdiff_tmp

;;Print test values
;for i=0,1000 do print,mltF1[i],mltF2[i],mltdiff_tmp.y[i]

dlshell_hist = abs(lshellF1 - lshellF2)
dmlt_hist = mltdiff_tmp.y

;for i=0,1000 do print,lshellF1[i],lshellF2[i],dlshell_hist[i]


dl_histV = histogram(dlshell_hist,binsize=0.5,locations=dlloc,min=0.)
dmlt_histV = histogram(dmlt_hist,binsize=0.75,locations=dmltloc,min=0.)

;log
;!p.multi = [0,0,2]
;plot,dlloc,dl_histV,xtitle='delta-Lshell',ytitle='# occurrences',/ylog,yrange=[1,200],ystyle=1,xrange=[0,5],psym=-2
;plot,dmltloc,dmlt_histV,xtitle='delta-MLT',ytitle='# occurrences',/ylog,yrange=[1,500],ystyle=1,psym=-2

;linear
!p.multi = [0,0,2]
plot,dlloc,dl_histV,xtitle='delta-Lshell',ytitle='# occurrences',yrange=[0,300],ystyle=1,xrange=[0,5],psym=-2
plot,dmltloc,dmlt_histV,xtitle='delta-MLT',ytitle='# occurrences',yrange=[0,400],ystyle=1,psym=-2

stop












;Average the perocc and peak values.
peroccavg = fltarr(nlshells,nmlts)  ;%occurrence of coherence values above minimum coherence averaged across all payload combinations
peakavg = fltarr(nlshells,nmlts)    ;Peak coherence value averaged across all payload combinations
peakmax = fltarr(nlshells,nmlts)    ;Maximum coherence value in each bin (all payload combinations considered)
peaktotal = fltarr(nlshells,nmlts)  ;Total coherence summed over all payload combinations (not normalized)
totalcounts = fltarr(nlshells,nmlts) ;Total number of counts in each bin summed over all payload combinations
totalhits = fltarr(nlshells,nmlts)  ;Number of instances in each bin (for all payloads) with > 0 counts.


for l=0,nlshells-1 do for m=0,nmlts-1 do peroccavg[l,m] = total(perocc[*,l,m],/nan)/n_elements(combos)
for l=0,nlshells-1 do for m=0,nmlts-1 do peakavg[l,m] = total(values[*,l,m],/nan)/n_elements(combos)
for l=0,nlshells-1 do for m=0,nmlts-1 do peakmax[l,m] = max(values[*,l,m],/nan)
for l=0,nlshells-1 do for m=0,nmlts-1 do peaktotal[l,m] = total(values[*,l,m],/nan)
for l=0,nlshells-1 do for m=0,nmlts-1 do totalcounts[l,m] = total(counts[*,l,m],/nan)
for l=0,nlshells-1 do for m=0,nmlts-1 do totalhits[l,m] = n_elements(where(counts[*,l,m] ne 0.))


;Eliminate low count sectors
goob = where(totalcounts le 10.)
if goob[0] ne -1 then totalcounts[goob] = 0.
if goob[0] ne -1 then peroccavg[goob] = 0.
if goob[0] ne -1 then peakavg[goob] = 0.
if goob[0] ne -1 then peakmax[goob] = 0.
if goob[0] ne -1 then peaktotal[goob] = 0.
if goob[0] ne -1 then totalhits[goob] = 0.



dial_plot,peroccavg,totalcounts,grid,minc_vals=0,maxc_vals=0.5,minc_cnt=0,maxc_cnt=100
stop
dial_plot,peakavg,totalcounts,grid
dial_plot,peakmax,totalcounts,grid,minc_vals=0.7,maxc_vals=0.9,minc_cnt=0,maxc_cnt=100
dial_plot,totalhits,totalcounts,grid


stop



;------------------------------------------
;Plot all coherence plots over entire mission
;-------------------------------------------

t0f = time_double('2013-12-31')
t1f = time_double('2014-02-11')
timespan,t0f,t1f-t0f,/seconds
omni_hro_load


tplot,['kyoto_dst','kyoto_ae','coh_??_meanfilter']
;tplot,['kyoto_dst','kyoto_ae','coh_??']
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;---------------------------------
;First blob of coherence (20-60 min periods)
;---------------------------------
stop
t0f = time_double('2014-01-04')
t1f = time_double('2014-01-13')
timespan,t0f,t1f-t0f,/seconds
vars1 = 'coh_'+['IW','WK','WL','KL','KX','LX']+'_meanfilter'
;tplot,'coh_'+['IW','WK','WL','KL','KX','LX']
vars2 = ['kyoto_dst','kyoto_ae']
vars3 = ['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure']
tplot,[vars3,vars2,vars1]

toplot0 = time_double('2014-01-04/22:40:00')
toplot1 = time_double('2014-01-07/16:40:00')

toplots0 = toplot0 + dindgen(10)*86400.
toplots1 = toplot1 + dindgen(10)*86400.
timebar,toplots0
timebar,toplots1,color=250

;times to overplot 
t0p = time_double('2014-01-04/22:40:00')
toplot = t0p + 86400.*indgen(10)
timebar,toplot

t1p = time_double('2014-01-07/17:00:00')
toplot2 = t1p + 86400.*indgen(10)
timebar,toplot2,linestyle=2

;---------------------------------
;Second blob of coherence (20-60 min periods)
;---------------------------------

t0f = time_double('2014-01-17')
t1f = time_double('2014-01-26')
timespan,t0f,t1f-t0f,/seconds
tplot,'coh_'+['LA','LB','LE','LO','LP','XA','XB','AB']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;---------------------------------
;Third blob of coherence (20-60 min periods)
;---------------------------------

;t0f = time_double('2014-01-29')
;t1f = time_double('2014-02-11')
t0f = time_double('2014-02-08')
t1f = time_double('2014-02-12')
timespan,t0f,t1f-t0f,/seconds
;tplot,'coh_'+['LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']+'_meanfilter'
tplot,'coh_'+['EO','EP']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add





;---------------------------------
;First blob of coherence (2-20 min periods)
;---------------------------------


t0f = time_double('2014-01-02')
t1f = time_double('2014-01-15')
timespan,t0f,t1f-t0f,/seconds
tplot,'coh_'+['TX','WK','WL','WX','KL','KX','LX']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;---------------------------------
;Second blob of coherence (2-20 min periods)
;---------------------------------

t0f = time_double('2014-01-17')
t1f = time_double('2014-01-26')
timespan,t0f,t1f-t0f,/seconds
tplot,'coh_'+['LA','LB','LE','LO','LP','XA','XB','AB']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add


;---------------------------------
;Third blob of coherence (2-20 min periods)
;---------------------------------

t0f = time_double('2014-01-29')
t1f = time_double('2014-02-11')
timespan,t0f,t1f-t0f,/seconds
tplot,'coh_'+['LA','LB','LE','LO','LP','XA','XB','AB','AE','AO','AP','BE','BO','BP','EO','EP','OP']+'_meanfilter'
tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_BZ_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure'],/add




;---------------------------------------
;Compare with Solar Wind data 
;---------------------------------------

pathsw = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/solar_wind_data/'
fn = 'omni_hros_1min_20140101000000_20140215000000.cdf'
cdf2tplot,pathsw+fn,prefix='omni_'
fn = 'wi_k0s_swe_20140101000113_20140214235829.cdf'
cdf2tplot,pathsw+fn,prefix='wind_'
fn = 'wi_plsps_3dp_20140101000009_20140214235941.cdf'
cdf2tplot,pathsw+fn,prefix='wind_'
fn = 'wi_pms_3dp_20140101000000_20140215000000.cdf'
cdf2tplot,pathsw+fn,prefix='wind_'



tplot,'coh_'+['WK','WL','KL','KX','LX']+'_meanfilter'
;tplot,['kyoto_dst','kyoto_ae'],/add
tplot,['OMNI_HRO_1min_B?_GSE','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure',$
'OMNI_HRO_1min_T','OMNI_HRO_1min_AE_INDEX','OMNI_HRO_1min_AL_INDEX','OMNI_HRO_1min_AU_INDEX','OMNI_HRO_1min_SYM_D',$
'OMNI_HRO_1min_SYM_H','OMNI_HRO_1min_ASY_D','OMNI_HRO_1min_ASY_H','OMNI_HRO_1min_PC_N_INDEX'],/add

;times to overplot 
t0p = time_double('2014-01-04/22:40:00')
toplot = t0p + 86400.*indgen(10)
timebar,toplot

t1p = time_double('2014-01-07/17:00:00')
toplot2 = t1p + 86400.*indgen(10)
timebar,toplot2,linestyle=2

stop






;--------------------------------------------
;Make rectangular plots instead of dial plots
;--------------------------------------------




nvformatleft = 5
nvformatright = 5

mincolor_vals = min(peroccavg)
maxcolor_vals = (max(peroccavg)+1)/2.
mincolor_cnt = min(totalcounts)
maxcolor_cnt = (max(totalcounts)+1)/2.


  ;Define levels for the colors (from dfanning website:
  ;page 144: http://www.idlcoyote.com/books/tg/samples/tg_chap5.pdf
  ;Letting IDL manually define the colors based on the nlevels keyword
  ;often leads to bad color scales.
  nlevels = 12
  LoadCT, 33, NColors=nlevels, Bottom=1
  step = (maxcolor_vals-mincolor_vals) / nlevels
  levels = IndGen(nlevels) * step + mincolor_vals

  stepc = (maxcolor_cnt-mincolor_cnt)/nlevels
  levelsc = IndGen(nlevels) * stepc + mincolor_cnt

  SetDecomposedState, 0, CurrentState=currentState


  !p.multi = [0,0,2]

    SetDecomposedState, currentState
    contour,peroccavg,grid.grid_lshell[1:grid.nshells],grid.grid_theta[1:grid.nthetas],$
    xtitle='Distance from PP (RE)',ytitle='MLT',$
    /fill,$
    C_Colors=IndGen(nlevels)+1,$
    levels=levels,$
    title='titletmp',$
    ymargin=[4,8],xmargin=[10,20],$
    xrange=[0,12],$
    yrange=[0,24],$
    xstyle=1,ystyle=1

    SetDecomposedState, currentState
    contour,totalcounts,grid.grid_lshell[1:grid.nshells],grid.grid_theta[1:grid.nthetas],$
    xtitle='Distance from PP (RE)',ytitle='MLT',$
    /fill,$
    C_Colors=IndGen(nlevels)+1,$
    levels=levelsc,$
    title='titletmp',$
    ymargin=[4,8],xmargin=[10,20],$
    xrange=[0,12],$
    yrange=[0,24],$
    xstyle=1,ystyle=1



  tn = (maxcolor_vals-mincolor_vals)*indgen(nvformatleft)/(nvformatleft-1)+mincolor_vals
  tn = string(tn,format='(f4.1)')
colorbar,position=[0.92,0.65,0.95,0.95],ticknames=tn,divisions=nvformatleft-1,/vertical,format='(f4.1)'
  tn = (maxcolor_cnt-mincolor_cnt)*indgen(nvformatleft)/(nvformatleft-1)+mincolor_cnt
  tn = string(tn,format='(f6.0)')
colorbar,position=[0.92,0.15,0.95,0.45],ticknames=tn,divisions=nvformatleft-1,/vertical,format='(f4.1)'


stop

end
