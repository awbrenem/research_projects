;Take the coherence files (e.g. AB.tplot, created from py_create_coh_tplot.pro) and extract
;timeseries data that will be inputted into timeseries_reduce_to_pk_and_npk.pro)

function extract_timeseries_from_coherence_files,combos,path,grid=grid,$
    mincoh=mincoh,$
    periodrange=periodrange,$
    max_mltdiff=max_mltdiff,max_ldiff=max_ldiff,$
    ratiomax=ratiomax,$
    dt=dt,$
    threshold=threshold,$
    folderfilter=folderfilter


;store_data,tnames(),/delete


pp_relative_distance = 0   ;use distance w/r to plasmapause (=1) or usual Lshell (=0)

if ~keyword_set(grid) then begin
  dlshell = 1 & lmin = 2 & lmax = 12 & dtheta = 2 & tmin = 0. & tmax = 24.
  grid = return_l_mlt_grid(dtheta,dlshell,lmin,lmax,tmin,tmax)
endif

ncombos = n_elements(combos)
nmlts = grid.nthetas
nlshells = grid.nshells

values = fltarr(ncombos,nlshells,nmlts)
perocc = fltarr(ncombos,nlshells,nmlts)
counts = fltarr(ncombos,nlshells,nmlts)


;x and y differences (cartesian from polar L and MLT) of ALL the coherence values
;from all the payloads. Used for final big plot of balloon separations
xv1 = 0. & xv2 = 0. & yv1 = 0. & yv2 = 0. & lshellF1 = 0. & lshellF2 = 0. & mltF1 = 0. & mltF2 = 0.


for i=0,ncombos-1 do begin
  print,combos[i]

  p1 = strmid(combos[i],0,1)
  p2 = strmid(combos[i],1,1)

  tplot_restore,filenames=path + combos[i] + '.tplot'
  copy_data,'coh_'+combos[i]+'_meanfilter','coh_'+combos[i]+'_meanfilter_original'

  filter_coherence_spectra,'coh_'+combos[i]+'_meanfilter','lshell_2'+p1,'lshell_2'+p2,'mlt_2'+p1,'mlt_2'+p2,$
    mincoh,$
    periodrange[0],periodrange[1],$
    max_mltdiff,$
    max_ldiff,$
    phase_tplotvar='phase_'+combos[i]+'_meanfilter',$
    /remove_lshell_undefined,$
    /remove_mincoh,$
    /remove_slidingwindow,$
    /remove_max_mltdiff,$
    /remove_max_ldiff,$
    /remove_anglemax,$
    ratiomax=ratiomax



;----------------------------------------------------------------------
;Filter results by activity using list from create_active_time_list.pro
;----------------------------------------------------------------------

pathfilter = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/barrel_filtered_data/'+folderfilter + '/'
fnfilter1 = 'barrel_2'+strlowcase(strmid(combos[i],0,1))+'_block_power.txt'
fnfilter2 = 'barrel_2'+strlowcase(strmid(combos[i],1,1))+'_block_power.txt'


  openr,lun,pathfilter+fnfilter1,/get_lun
  jnk = ''
  vals = ''
  t0 = ''
  t1 = ''
  rmsval = ''

  readf,lun,jnk
  while not eof(lun) do begin
    readf,lun,jnk
    vals = strsplit(jnk,' ',/extract)
    t0 = [t0,vals[0]]
    t1 = [t1,vals[1]]
    rmsval = [rmsval,vals[2]]
  endwhile

  close,lun
  free_lun,lun

  nelem = n_elements(t0)
  t0_p1 = time_double(t0[1:nelem-2])
  t1_p1 = time_double(t1[1:nelem-2])
  rmsval_p1 = rmsval[1:nelem-2]


  openr,lun,pathfilter+fnfilter2,/get_lun
  jnk = ''
  vals = ''
  t0 = ''
  t1 = ''
  rmsval = ''

  readf,lun,jnk
  while not eof(lun) do begin
    readf,lun,jnk
    vals = strsplit(jnk,' ',/extract)
    t0 = [t0,vals[0]]
    t1 = [t1,vals[1]]
    rmsval = [rmsval,vals[2]]
  endwhile

  close,lun
  free_lun,lun

  nelem = n_elements(t0)
  t0_p2 = time_double(t0[1:nelem-2])
  t1_p2 = time_double(t1[1:nelem-2])
  rmsval_p2 = rmsval[1:nelem-2]


  ;remove peak RMS values that are below a defined minimum threshold
  minval = 0.
  goo = where(rmsval_p1 le minval)
  if goo[0] ne -1 then rmsval_p1[goo] = 0.
  goo = where(rmsval_p2 le minval)
  if goo[0] ne -1 then rmsval_p2[goo] = 0.

  goo = where(rmsval_p1 gt minval)
  if goo[0] ne -1 then rmsval_p1[goo] = 1.
  goo = where(rmsval_p2 gt minval)
  if goo[0] ne -1 then rmsval_p2[goo] = 1.


  store_data,'peakbinRMS_'+p1,(t0_p1+t1_p1)/2.,rmsval_p1
  store_data,'peakbinRMS_'+p2,(t0_p2+t1_p2)/2.,rmsval_p2


  get_data,'coh_'+combos[i]+'_meanfilter',data=d


  ;Zero out coherence values if the activity level is below defined threshold.
  for q=0,n_elements(t0_p1)-1 do begin
    goo = where((d.x ge t0_p1[q]) and (d.x le t1_p1[q]))
    if goo[0] ne -1 then d.y[goo,*] *= rmsval_p1[q]
  endfor
  for q=0,n_elements(t0_p2)-1 do begin
    goo = where((d.x ge t0_p2[q]) and (d.x le t1_p2[q]))
    if goo[0] ne -1 then d.y[goo,*] *= rmsval_p2[q]
  endfor

  goo = where(d.y eq 0.)
  if goo[0] ne -1 then d.y[goo] = !values.f_nan

  store_data,'coh_'+combos[i]+'_meanfilter',data=d
  ylim,['peakbinRMS_'+p1,'peakbinRMS_'+p2],0,2
  options,['peakbinRMS_'+p1,'peakbinRMS_'+p2],'psym',-4

  tplot,['peakbinRMS_'+p1,'peakbinRMS_'+p2,'coh_'+combos[i]+'_meanfilter','coh_'+combos[i]+'_meanfilter_test']
  timebar,[t0_p1,t1_p1]
  timebar,[t0_p2,t1_p2],color=250


  ;;-------------------------------------------
  ;;Extract timeseries from coherence spectra
  ;;-------------------------------------------

  get_data,'coh_'+combos[i]+'_meanfilter',data=d,dlim=dlim,lim=lim
  periods = d.v
  t0 = min(d.x,/nan)
  t1 = max(d.x,/nan)

  goodperiods = where((d.v ge periodrange[0]) and (d.v le periodrange[1]))

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
  copy_data,'avg_nosliding',combos[i]+'_avg_nosliding'
  copy_data,'avg_sliding',combos[i]+'_avg_sliding'

stop

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

    pertime = percentoccurrence_l_mlt_calculate($
    dt,$
    combos[i]+'_totalcounts_above_threshold',$
    combos[i]+'_values',$
    'mlt_2'+p1+'_interp','dist_pp_2'+p1+'_interp',grid=grid)
  endif

  ;Normal Lshell
  if ~keyword_set(pp_relative_distance) then begin
    pertime = percentoccurrence_l_mlt_calculate($
      dt,$
      combos[i]+'_totalcounts_above_threshold',$
      combos[i]+'_values',$
      'mlt_2'+p1+'_interp','lshell_2'+p1+'_interp',grid=grid)
  endif



  tplot,[combos[i]+'_totalcounts_above_threshold',$
      combos[i]+'_values',$
      'mlt_2'+p1+'_interp','lshell_2'+p1+'_interp']


  ;values = pertime.percent_peaks
  perocc[i,*,*] = pertime.percent_peaks
  values[i,*,*] = pertime.peaks
  counts[i,*,*] = pertime.counts



  ;tplot,[combos[i]+'_totalcounts_above_threshold','coh_'+combos[i]+'_meanfilter',combos[i]+'_values','mlt_2'+p1+'_interp1-mlt_2'+p2+'_interp1']

  ;get_data,combos[i]+'_totalcounts_above_threshold',data=d1
;  get_data,'mlt_2'+p1+'_interp-mlt_2'+p2+'_interp',data=dmlt
;  get_data,combos[i]+'_avg_sliding',data=avgslid
;  get_data,combos[i]+'_avg_nosliding',data=avgnoslid
;  get_data,combos[i]+'_peak_value',data=pkv

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



vals = {totalcounts:totalcounts,$
        peroccavg:peroccavg,$
        peakavg:peakavg,$
        peakmax:peakmax,$
        peaktotal:peaktotal,$
        totalhits:totalhits}


return,vals
end
