;;Find more accurate amp/freqs for the chorus elements that occur
;;simultaneously with the microbursts on Jan 20th, 2016 during the
;;EFW/Firebird campaign



  rbsp_load_efw_fbk,probe=sc,type='calibrated',/pt
  rbsp_load_efw_spec,probe=sc,type='calibrated'
;  rbsp_load_efw_waveform,probe='a',datatype='vb2'

  rbsp_split_fbk,'a'

  ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk'],0,3000,0
  tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk','rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5']

  .compile /Users/aaronbreneman/Desktop/code/Aaron/RBSP/rbsp_efw_fbk_freq_interpolate.pro

  info = {probe:'a',fbk_mode:'7',fbk_type:'Bw'}

  t0 = time_double('2016-01-20/19:43:50')
  t1 = time_double('2016-01-20/19:44:20')
  tz = time_double('2016-01-20/19:44:00.615') ;selects the spectral bin that contains the triple peaked chorus/MB match

  v = tsample('rbspa_efw_fbk_7_fb2_pk',[t0,t1],times=tms)


;;--------------------------------------------------
;;Adjust the filterbank amplitudes
;;--------------------------------------------------


  store_data,'fbk_red',data={x:tms,y:v}
  rbsp_efw_fbk_freq_interpolate,'fbk_red',info,/testing


  store_data,'amp_comb',data=['rbspa_fbk_maxamp_orig','rbspa_fbk_maxamp_adj']
  options,'amp_comb','colors',[0,250]

  ylim,'amp_comb',0,200
  ylim,['rbspa_fbk_freq_of_max_orig',$
        'rbspa_fbk_freq_of_max_adj'],1200,2200
  options,'amp_comb','ytitle','Bw [pT]!Coriginal(black)!Cadjusted(red)'

;0.8-1.6 kHz channel is peak
  tplot_options,'title','from jan20_microburst_chorus_comparison.pro'
  tplot,['rbspa_flag_freq_amp_adjusted',$
         'rbspa_fbk_freq_of_max_adj',$
         'amp_comb']

  ylim,['rbspa_flag_freq_amp_adjusted',$
        'rbspa_flag_nointerp_smallamp',$
        'rbspa_flag_nointerp_edgebins',$
        'rbspa_flag_nointerp_scalefactor_toolarge',$
        'rbspa_flag_nointerp_neighbor_toosmall',$
        'rbspa_flag_amp_interp_limited_to_maxamp_lim'],0,2

  tplot,['rbspa_flag_freq_amp_adjusted',$
         'rbspa_flag_nointerp_smallamp',$
         'rbspa_flag_nointerp_edgebins',$
         'rbspa_flag_nointerp_scalefactor_toolarge',$
         'rbspa_flag_nointerp_neighbor_toosmall',$
         'rbspa_flag_amp_interp_limited_to_maxamp_lim',$
         'amp_comb']


;; freqlow
;;      0.800000      3.00000      12.0000      50.0000      200.000      800.000      3200.00
;; freqcenter
;;       1.15000      4.50000      18.5000      75.0000      300.000      1200.00      4850.00
;; freqhigh
;;       1.50000      6.00000      25.0000      100.000      400.000      1600.00      6500.00


  ;;Grab the gain curves
  restore,'~/Desktop/code/Aaron/datafiles/rbsp/FBK_gain_curves/RBSP_FilterBank_Theoretical_Rsponse_wE12ACmeasuredResponse_DMM_20130305.sav'
  freqs_for_gaincurves = freq


  gaincurve = FB_THEORETICAL_GAINRESPONSE_UNITYGAIN10KHZ
  gaincurve = [[gaincurve[*,12]],[gaincurve[*,10]],[gaincurve[*,8]],[gaincurve[*,6]],$
               [gaincurve[*,4]],[gaincurve[*,2]],[gaincurve[*,0]]]


  gaincurve_norm = gaincurve

  ;;normalization factor (ranges
  ;;from 1 to 2.1)
  gaincurve_maxv = fltarr(7)
  for i=0,n_elements(gaincurve_maxv)-1 do gaincurve_maxv[i] = max(gaincurve[*,i])
  gaincurve_normfactor = gaincurve_maxv/min(gaincurve_maxv)

  ;;normalize each curve to unity
  for i=0,n_elements(gaincurve[0,*])-1 do gaincurve_norm[*,i] = gaincurve[*,i]/max(gaincurve[*,i])
  
  ;;Only modify the last bin
  gaincurve_norm[*,6] = gaincurve[*,6]*gaincurve_normfactor[6]

  ;;Get the filterbank freq bin definitions
  fcals = rbsp_efw_get_gain_results()

  ;;Find the freq corresponding to the peak of each gain curve
  freq_peak_for_each_gaincurve = replicate(0.,n_elements(fcals.cal_fbk.FREQ_FBK7H))


;--------------------------------------------------
;increase the resolution of the gain curves
;--------------------------------------------------

  range1 = [0,50,100,150,200]
  range2 = [50,100,150,200,249]

  nelem = 500.
  freq2 = 0.
  gc2 = 0.
  for bb=0,n_elements(range1)-1 do begin                         $ 
     freqsub = freq[range1[bb]:range2[bb]]                       & $
     slope = (freqsub[n_elements(freqsub)-1]-freqsub[0])         & $
     freqsub2 = slope*indgen(nelem)/(nelem-1) + freq[range1[bb]] & $
     freq2 = [freq2,freqsub2]
;  endfor


  freq2 = freq2[1:n_elements(freq2)-1]
  ;; plot,freq2,psym=4,/xstyle

  
  ;; Now interpolate the gain curves to the new frequencies
  gc2 = fltarr(nelem*n_elements(range1),n_elements(gaincurve_norm[0,*]))
  for bb=0,n_elements(gaincurve_norm[0,*])-1 do gc2[*,bb] = interpol(gaincurve_norm[*,bb],freq,freq2,/spline)


  gaincurve_norm = gc2
  gaincurve_dB = 20d*alog10(gaincurve_norm)
  freqs_for_gaincurves = freq2

  for i=0,n_elements(gaincurve_dB[0,*])-1 do begin  $
     goo = max(gaincurve_dB[*,i],wh)  & $
     freq_peak_for_each_gaincurve[i] = freqs_for_gaincurves[wh]
;  endfor





  ;; plot,  freq2 ,gc2[*,0],/ylog,/ys,yrange=[0.1,1], /xs,xrange = [0, 3000], $
  ;;        background = 255, color = 254 , thick = 2, xtitle = 'Hz', ytitle = 'dB', $
  ;;        title = 'Filter Bank Unity response curves...these are the ones used in this program',$
  ;;        psym=4
  plot,  freq2 ,gaincurve_db[*,0],/ys,yrange=[-100,10], /xs,xrange = [0, 3000], $
         background = 255, color = 254 , thick = 2, xtitle = 'Hz', ytitle = 'dB', $
         title = 'Filter Bank Unity response curves...these are the ones used in this program',$
         psym=4
  oplot,  freq ,gaincurve_norm[*,0] ,color=0,psym=5

  for kk = 1, n_elements(freq_peak_for_each_gaincurve)-1, 1 do oplot, freq2, gc2[*,kk],$
     color = kk*20 + 20, thick = 2,psym=4
  for kk = 1, n_elements(freq_peak_for_each_gaincurve)-1, 1 do oplot, freq, gaincurve_norm[*,kk],$
     color = 0, thick = 1,psym=5
  stop


tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4']


  t0 = time_double('2016-01-20/19:43:50')
  t1 = time_double('2016-01-20/19:44:20')

spec0_red = tsample('rbspa_efw_64_spec0',[t0,t1],times=tms)
spec4_red = tsample('rbspa_efw_64_spec4',[t0,t1],times=tms)

plot,ew.v,spec0_red[0,*],xrange=[0,3000],/ylog,yrange=[1d-5,1d-1],/nodata
for i=0,n_elements(spec0_red[*,0])-1 do oplot,ew.v,spec0_red[i,*]
plot,bw.v,spec4_red[0,*],xrange=[0,3000],/ylog,yrange=[1d-9,1d-6],/nodata
for i=0,n_elements(spec4_red[*,0])-1 do oplot,ew.v,spec4_red[i,*]


plot,bw.v,bw.y[gooe[0],*],/ylog,yrange=[1d-9,1d-6],xrange=[0,3000]


;t0 = time_double('2016-01-20/19:44')
gooe = where(ew.x ge tz)

title = time_string(ew.x[gooe[0]],tformat="YYYY-MM-DD/hh:mm:ss.fff")
print,title
;2016-01-20/19:44:00.615

plot,ew.v,ew.y[gooe[0],*],xrange=[100,10000],/xlog,/ylog,yrange=[1d-5,1d-1],psym=-4,title=title
plot,bw.v,bw.y[gooe[0],*],/xlog,/ylog,yrange=[1d-9,1d-6],xrange=[100,10000],psym=-4



;peak at 1.7 kHz

