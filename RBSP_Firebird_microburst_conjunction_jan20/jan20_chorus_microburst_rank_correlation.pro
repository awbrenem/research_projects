
pro jan20_chorus_microburst_rank_correlation

  sc = 'a'
  date = '2016-01-20'
  timespan,date
  fb = '4'

  rbsp_load_efw_fbk,probe=sc,type='calibrated',/pt
;  rbsp_load_efw_spec,probe=sc,type='calibrated'
  rbsp_split_fbk,'a'

  ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk'],0,3000,0
  tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk','rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5']



  path = '/Users/aaronbreneman/Desktop/Research/OTHER/meetings/2016-Aerospace/'
  fn = 'FU_4_Hires_2016-01-20_L1_v02.txt'


  openr,lun,path+fn,/get_lun

  jnk = ''
  for i=0,107 do readf,lun,jnk

  data = strarr(90000,27)
  i=0L

  while not eof(lun) do begin           ;$
     readf,lun,jnk                      ;& $
     data[i,*] = strsplit(jnk,/extract) ;& $
     i++
  endwhile

  close,lun
  free_lun,lun
  times = data[*,0]
  goo = where(times eq '')
  vtt = goo[0]-1
  timestt = time_double(times[0:vtt])

  ;add artificial time shift
  timestt += 4.1
  store_data,'hr0_0',data={x:timestt,y:float(data[0:vtt,11])}


stop

  ;; t0 = time_double('2016-01-20/19:42:15')
  ;; t1 = time_double('2016-01-20/19:45:10')
  ;; tz = time_double('2016-01-20/19:44:00.615')


  ;; ;;Reduce data only to times of overlap
  ;; v1 = 'hr0_0'
  ;; v2 = 'rbspa_fbk2_7pk_5'
  ;; v = tsample(v1,[t0,t1],times=t)
  ;; store_data,v1,t,v
  ;; v = tsample(v2,[t0,t1],times=t)
  ;; store_data,v2,t,v


rbsp_detrend,'hr0_0',60.*0.1


  ;;Sample limited set of FB data out of entire set. 
  v1 = 'hr0_0_detrend'
  v2 = 'rbspa_fbk2_7pk_5'
  t0l = time_double('2016-01-20/19:44:00')
  t1l = time_double('2016-01-20/19:44:10')
  v = tsample(v1,[t0l,t1l],times=t)
  store_data,v1,t,v
  v = tsample(v2,[t0l,t1l],times=t)
  store_data,v2,t,v


  tinterpol_mxn,'hr0_0','rbspa_fbk2_7pk_5',newname='hr0_0'
  get_data,'hr0_0',times,vtt


  ylim,v1,0,400
  tlimit,t0l,t1l
  tplot,[v1,'rbspa_fbk2_7pk_5']
stop

xvals = tsample('rbspa_fbk2_7pk_5',[t0l,t1l],times=t)
yvals = tsample('hr0_0',[t0l,t1l],times=t2)

plot,xvals,yvals,psym=2

result = r_correlate(xvals,yvals)
PRINT, "Spearman's (rho) rank correlation: ", result


result = r_correlate(xvals,yvals,/kendall)
PRINT, "Kendalls's (tau) rank correlation: ", result




end
