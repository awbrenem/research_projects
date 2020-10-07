;Creates an ascii file with the max filterbank value (out of all 7 or 13 bins) each time (8 S/s cadence)
;At the cadence of FBK data this program removes values if they are outside of
;info.minamp_pk(av) and info.maxamp_pk(av) and fce_eq*info.minfreq and fce_eq*info.maxfreq
;
;Also creates ascii file of various values (pk, avg, avg4sec, pk/avg)
;as a function of amplitude and frequency
;
;
;Output variables:
;--Amplitude distribution [timesc, bins2] -> bins2 = 25 amplitude bins
;
;
;
;Won't write to the ascii file if one or both of the EMFISIS or EFW data doesn't exist.
;
;
;calls rbsp_efw_fbk_freq_interpolate.pro
;
;
;keywords:	test_mock_fbk7 -> eliminates every other FBK13 bin and saves it as a FBK7 variable.
;							  Do this to see how much is lost from the missing bins in FBK7
;							  To compare the results see the "testing" code at the end of
;							  rbsp_survey_fbk_percenttime_crib.pro
;
;
;Notes: must first call rbsp_survey_create_ephem_ascii so that the mlat values are available
;		to let fce -> fce_eq
;
;      WARNING: don't detrend the interpolated freq data. If
;there are multiple bands of waves occurring then the detrended
;version will split the difference b/t them, leading to a false frequency
;
;Written by Aaron W Breneman, Oct, 2013


pro rbsp_survey_create_fbk_ascii

  testing = 1

  if ~keyword_set(testing) then begin

     args = command_line_args()


     fn = args[0]
     currdate = args[1]
     mlats = args[2]
     sax = args[3]              ;spinaxis data
     say = args[4]
     saz = args[5]
     restore,fn


     mlats = strmid(mlats,1,strlen(mlats)-2)
     sax = strmid(sax,1,strlen(sax)-2)
     say = strmid(say,1,strlen(say)-2)
     saz = strmid(saz,1,strlen(saz)-2)


     mlats = float(strsplit(mlats,',',/extract))
     sax = float(strsplit(sax,',',/extract))
     say = float(strsplit(say,',',/extract))
     saz = float(strsplit(saz,',',/extract))

  endif


  ;;**************************************************
  if keyword_set(testing) then begin

     ;;**************************
    ;;  fn = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/runtest_tmp/info.idl'

    ;;  restore,fn
    ;;  currdate = '2012-10-13'
    ;;  timespan,currdate
    ;;  timesc = time_double(currdate)+info.timesb+info.dt/2.

    ;;  rbsp_efw_position_velocity_crib
    ;;  tinterpol_mxn,'rbspa_state_mlat',timesc
    ;;  get_data,'rbspa_state_mlat_interp',data=mlats
    ;;  mlats = mlats.y
    ;;  str_element,info,'scale_fac_lim',5,/add_replace

    ;; info.f_fceB = [0.0, 0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
    ;; info.f_fceT = [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0]
     ;;**************************


     currdate = '2012-11-01'
     timespan,currdate

     ;; fn = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/runtest_l=5.5_mlt=0..12/info.idl'
     ;; fn = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/runtest_l=2-5_mlt=5/info.idl'
;     fn = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/amptest_basic/info.idl'
     fn = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/rbsp-efw-fbk-survey/runtest_evan/info.idl'
     restore,fn
     timesc = time_double(currdate)+info.timesb+info.dt/2.

;**************************************************




     rbsp_efw_position_velocity_crib
     tinterpol_mxn,'rbspa_state_mlat',timesc
     get_data,'rbspa_state_mlat_interp',data=mlats
     mlats = mlats.y
     str_element,info,'scale_fac_lim',5,/add_replace

     info.f_fceB = [0.0, 0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
     info.f_fceT = [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0]

     sax = replicate(0.,n_elements(timesc))
     say = replicate(0.,n_elements(timesc))
     saz = replicate(0.,n_elements(timesc))


  endif
  ;;**************************************************

  ;;Find times of center of bins
  timesc = time_double(currdate)+info.timesb+info.dt/2.

  nf_fce = n_elements(info.f_fceB)


  ;;Create Mlat variable
  store_data,'mlat',data={x:timesc,y:mlats}

  rbspx = 'rbsp' + info.probe


  ;;define the bin values for the amplitude distributions
  if info.fbk_type eq 'Ew' then bins = 10^(0.15*indgen(25))/8.
  if info.fbk_type eq 'Bw' then bins = 10^(0.17*indgen(25))/8.
  if info.fbk_type eq 'Ew' then bins_avg = bins/10.
  if info.fbk_type eq 'Bw' then bins_avg = bins/10.
  bins2 = alog10(bins)
  bins2_avg = alog10(bins_avg)
  nbins = n_elements(bins2)
  binsize = (max(bins2,/nan) - min(bins2,/nan))/(n_elements(bins2)-1)
  binsize_avg = (max(bins2_avg,/nan) - min(bins2_avg,/nan))/(n_elements(bins2_avg)-1)

  bins_ratio = exp(indgen(25)/3.2) ;ratio of peak to average values
;;bins_ratio = exp(indgen(25)/2.5)	;ratio of peak to average values
  bins2_ratio = alog10(bins_ratio)
  binsize_ratio = (max(bins2_ratio,/nan) - min(bins2_ratio,/nan))/(n_elements(bins2_ratio)-1)


;; define the bin values for the frequency distributions
  binsf = indgen(25)/(25. - 1.)
  nbinsf = n_elements(binsf)
  binsizef = (max(binsf,/nan) - min(binsf,/nan))/(n_elements(binsf)-1)





  timespan,currdate

  rbsp_load_efw_fbk_l2,probe=info.probe

  magcadence = '1sec'
  rbsp_load_emfisis,probe=info.probe,coord='gse',cadence=magcadence,level='l3'

  get_data,rbspx+'_emfisis_l3_'+magcadence+'_gse_Magnitude',data=mag
  get_data,rbspx+'_emfisis_l3_'+magcadence+'_gse_Mag',data=bfield


  if info.fbk_mode eq '13' then begin
     get_data,rbspx+'_efw_fbk13_e12dc_av',data=av,dlim=dlim,lim=lim
     get_data,rbspx+'_efw_fbk13_e12dc_pk',data=pk,dlim=dlim,lim=lim
     ;;eliminate bottom bins which often seem to carry extra power
     av.y[*,0:1] = 0.
     pk.y[*,0:1] = 0.
     store_data,rbspx+'_efw_fbk13_e12dc_av',data=av,dlim=dlim,lim=lim
     store_data,rbspx+'_efw_fbk13_e12dc_pk',data=pk,dlim=dlim,lim=lim
  endif

  if info.fbk_mode eq '7' then begin
     if info.fbk_type eq 'Ew' then begin
        get_data,rbspx+'_efw_fbk7_e12dc_av',data=av,dlim=dlim,lim=lim
        get_data,rbspx+'_efw_fbk7_e12dc_pk',data=pk,dlim=dlim,lim=lim
        ;;eliminate bottom bins which often seem to carry extra power
        av.y[*,0] = 0.
        pk.y[*,0] = 0.
        store_data,rbspx+'_efw_fbk7_e12dc_av',data=av,dlim=dlim,lim=lim
        store_data,rbspx+'_efw_fbk7_e12dc_pk',data=pk,dlim=dlim,lim=lim
     endif
     if info.fbk_type eq 'Bw' then begin
        get_data,rbspx+'_efw_fbk7_scmw_av',data=av,dlim=dlim,lim=lim
        get_data,rbspx+'_efw_fbk7_scmw_pk',data=pk,dlim=dlim,lim=lim
        ;;eliminate bottom bins which often seem to carry extra power
        av.y[*,0] = 0.
        pk.y[*,0] = 0.
        store_data,rbspx+'_efw_fbk7_scmw_av',data=av,dlim=dlim,lim=lim
        store_data,rbspx+'_efw_fbk7_scmw_pk',data=pk,dlim=dlim,lim=lim
     endif
  endif



  ;;*********************TESTING***************
  if keyword_set(test_mock_fbk7) then begin
     pktmp = [[pk.y[*,0]],[pk.y[*,2]],[pk.y[*,4]],[pk.y[*,6]],[pk.y[*,8]],[pk.y[*,10]],[pk.y[*,12]]]
     pkv = [1.50000,6.00000,25.0000,100.000,400.000,1600.00,6500.00]
     store_data,rbspx+'_efw_fbk7_scmw_pk',data={x:pk.x,y:pktmp,v:pkv}

     pk = {x:pk.x,y:pktmp,v:pkv}

     ;;We have to trick the interpolation routine into thinking that this is FBK7 data
     ;;otherwise the interpolation won't work b/c the adjacent bin always has zero amp.
     info.fbk_mode = '7'
  endif
  ;;*******************************************





  ;;Interpolate the Bfield data to the cadence of FBK data so that I
  ;;can sort by f/fce
  mag = {x:pk.x,y:interpol(mag.y,mag.x,pk.x)}
  bfield2 = [[interpol(bfield.y[*,0],bfield.x,pk.x)],$
             [interpol(bfield.y[*,1],bfield.x,pk.x)],$
             [interpol(bfield.y[*,2],bfield.x,pk.x)]]
  fce = 28.*mag.y


  ;;Project the Bfield to the magnetic eq
  ;;tinterpol_mxn,rbspx+'_mlat',pk.x,newname='mlat_hires'
  tinterpol_mxn,'mlat',pk.x,newname='mlat_hires'
  get_data,'mlat_hires',data=mlat

;		;ECT's fce_eq product (from OP77Q model)
;		get_data,rbspx+'_fce_eq_ect',data=fce_eq
;		fce_eq_ect = interpol(fce_eq.y,fce_eq.x,pk.x)

                                ;EMFISIS fce_eq product (should be more accurate than ECT OP77Q model)
  fce_eq = fce*cos(2*mlat.y*!dtor)^3/sqrt(1+3*sin(mlat.y*!dtor)^2)

  if keyword_set(testing) then begin
     store_data,'fce',data={x:pk.x,y:fce}
     store_data,'fce_eq',data={x:pk.x,y:fce_eq}
     store_data,'fce_eq2',data={x:pk.x,y:0.5*fce_eq}
     store_data,'fce_eq01',data={x:pk.x,y:0.1*fce_eq}
     store_data,'fci',data={x:pk.x,y:fce_eq/1836.}
     store_data,'flh',data={x:pk.x,y:sqrt(fce_eq*fce_eq/1836.)}
  endif


  if info.fbk_mode eq '13' then ftmp = info.fbk_freqs.fbk13_binsL
  if info.fbk_mode eq '7'  then ftmp = info.fbk_freqs.fbk7_binsL


;;***********************************************
;;***NOTE: I'm no longer doing this b/c i'm saving data outside of the
;;chorus freq range. This is a tradeoff b/c sometimes the largest amp
;;wave is outside of the chorus range. However, seeing as I'm
;;mostly interested in larger amplitude chorus, I don't think
;;that this would be a problem too often.
;; ;;--------------------------------------------------
;; ;;eliminate FBK values that are below 0.1*fce_eq
;; ;;before I do the interpolation
;;   for qq=0L,n_elements(mlat.x)-1 do begin
;;      goo = where(ftmp lt 0.1*fce_eq[qq])
;;      if goo[0] ne -1 then pk.y[qq,goo] = 0
;;   endfor

;;   store_data,'rbsp'+probe+'_efw_fbk13_e12dc_pk',data=pk,dlim=dlim,lim=lim
;; ;;--------------------------------------------------


  ;; mf = info.minfreq
  ;; for j=0L,n_elements(fce_eq)-1 do begin
  ;;    minfce = fce_eq[j]*info.minfreq
  ;;    goo  = where(ftmp lt fce_eq[j]*mf)
  ;;    if n_elements(goo) gt 3 then pk.y[j,goo[0]:n_elements(goo)-4] = 0.
  ;; endfor
;;***********************************************








  ;;-----------------------------------------------------------------------------------
  ;;If we actually have both EMFISIS and EFW data then let's do the freq interpolation.
  ;;-----------------------------------------------------------------------------------

  if is_struct(pk) and is_struct(mag) then begin

     ;; if info.fbk_mode eq '13' then rbsp_efw_fbk_freq_interpolate,$
     ;;    rbspx+'_efw_fbk13_e12dc_pk',info,scale_fac_lim=info.scale_fac_lim
     ;; if info.fbk_mode eq '7' and info.fbk_type eq 'Ew' then rbsp_efw_fbk_freq_interpolate,$
     ;;    rbspx+'_efw_fbk7_e12dc_pk',info,scale_fac_lim=info.scale_fac_lim
     ;; if info.fbk_mode eq '7' and info.fbk_type eq 'Bw' then rbsp_efw_fbk_freq_interpolate,$
     ;;    rbspx+'_efw_fbk7_scmw_pk',info,scale_fac_lim=info.scale_fac_lim



;;**********
;;For testing see rbsp_efw_fbk_freq_interpolate_test.pro
;;**********

;;fbk13
     if info.fbk_mode eq '13' then rbsp_efw_fbk_freq_interpolate,$
        rbspx+'_efw_fbk13_e12dc_pk',$
        info,$
        scale_fac_lim=info.scale_fac_lim,$
        maxamp_lim=1.,$
        minamp=2                ;,/testing

;;fbk7,Ew
     if info.fbk_mode eq '7' and info.fbk_type eq 'Ew' then rbsp_efw_fbk_freq_interpolate,$
        rbspx+'_efw_fbk7_e12dc_pk',info,$
        scale_fac_lim=info.scale_fac_lim,$
        maxamp_lim=1.,$
        minamp=2                ; ,/testing

;;fbk7,Bw
     if info.fbk_mode eq '7' and info.fbk_type eq 'Bw' then rbsp_efw_fbk_freq_interpolate,$
        rbspx+'_efw_fbk7_scmw_pk',info,$
        scale_fac_lim=info.scale_fac_lim,$
        maxamp_lim=1,$
        minamp=10.              ;,/testing




     ;; ;;Smooth the freq_of_max_adj. This cleans things up nicely
     ;; rbsp_detrend,rbspx+'_fbk_freq_of_max_adj',60.*0.2
     ;; ylim,rbspx+'_fbk_freq_of_max_adj_smoothed',100,10000,1


     ;; get_data,rbspx+'_fbk_freq_of_max_adj_smoothed',data=freqs
     get_data,rbspx+'_fbk_freq_of_max_adj',data=freqs
     get_data,rbspx+'_fbk_maxamp_adj',data=amps





;;Pick out the average FBK value corresponding to the freq bin of the peak value for each time.
;;Otherwise the selected average value may not correspond to the maximum peak value.
;;The drawback with this method is that I can't use the amp-corrected average values, but this
;;shouldn't be important

     get_data,rbspx+'_fbk_binnumber_of_max_orig',data=maxbin

     if info.fbk_type eq 'Ew' then get_data,rbspx+'_efw_fbk' + info.fbk_mode+'_e12dc_av',data=avg_tmp
     if info.fbk_type eq 'Bw' then get_data,rbspx+'_efw_fbk' + info.fbk_mode+'_scmw_av',data=avg_tmp

     amps_avg = fltarr(n_elements(maxbin.x))
     for qq=0L,n_elements(maxbin.x) - 1 do amps_avg[qq] = avg_tmp.y[qq,maxbin.y[qq]]


     ;;4-sec average the 1/8s average FBK values so that they correspond to Cully's 2008 THEMIS FBK results
     if info.fbk_type eq 'Ew' then  rbsp_detrend,rbspx+'_efw_fbk' + info.fbk_mode+'_e12dc_av',4.
     if info.fbk_type eq 'Bw' then  rbsp_detrend,rbspx+'_efw_fbk' + info.fbk_mode+'_scmw_av',4.


     ;;interpolate the smoothed results up to the correct time cadence
     if info.fbk_type eq 'Ew' then tinterpol_mxn,rbspx+'_efw_fbk' + info.fbk_mode+'_e12dc_av_smoothed',$
        maxbin.x,newname=rbspx+'_efw_fbk' + info.fbk_mode+'_e12dc_av_4s'
     if info.fbk_type eq 'Bw' then tinterpol_mxn,rbspx+'_efw_fbk' + info.fbk_mode+'_scmw_av_smoothed',$
        maxbin.x,newname=rbspx+'_efw_fbk' + info.fbk_mode+'_scmw_av_4s'


     if info.fbk_type eq 'Ew' then get_data,rbspx+'_efw_fbk' + info.fbk_mode+'_e12dc_av_4s',data=avg_tmp
     if info.fbk_type eq 'Bw' then get_data,rbspx+'_efw_fbk' + info.fbk_mode+'_scmw_av_4s',data=avg_tmp

     amps_avg4s = fltarr(n_elements(maxbin.x))
     for qq=0L,n_elements(maxbin.x) - 1 do amps_avg4s[qq] = avg_tmp.y[qq,maxbin.y[qq]]




     ;;--------------------------------------------------
     ;;Make copies of the two arrays we'll be working with
     ;;--------------------------------------------------

     freqs2 = freqs.y
     amps2 = amps.y
     amps_avg2 = amps_avg
     amps_avg4s2 = amps_avg4s


     ;;-------------------------------------------------------
     ;;Remove waves outside of the designated amplitude range.
     ;;-------------------------------------------------------

     amptst = ((amps2 ge info.minamp_pk) and (amps2 le info.maxamp_pk))
     goo = where(amptst eq 0)
     if goo[0] ne -1 then amps2[goo] = !values.f_nan
     ;; if goo[0] ne -1 then amps2[goo] = 0.


     amptst = ((amps_avg2 ge info.minamp_av) and (amps_avg2 le info.maxamp_av))
     goo = where(amptst eq 0)
     if goo[0] ne -1 then amps_avg2[goo] = !values.f_nan
     ;; if goo[0] ne -1 then amps_avg2[goo] = 0.

     amptst = ((amps_avg4s2 ge info.minamp_av) and (amps_avg4s2 le info.maxamp_av))
     goo = where(amptst eq 0)
     if goo[0] ne -1 then amps_avg4s2[goo] = !values.f_nan
     ;; if goo[0] ne -1 then amps_avg4s2[goo] = 0.


     ;;--------------------------------------------------
     ;;Find out what values reside in specific freq ranges
     ;;--------------------------------------------------


     ;;I've tested this loop using a nested loop and it works fine.
     freq_binary = replicate(0.,[n_elements(freqs2),nf_fce])
     for f=0,nf_fce-1 do $
        freq_binary[*,f] = ((freqs2 ge info.f_fceB[f]*fce_eq) and (freqs2 lt info.f_fceT[f]*fce_eq))


;;******************************
;; ;Test of freq binary...(works)
;; print,total(freq_binary[*,0])

;; print,total(freq_binary[*,1]+freq_binary[*,2]+freq_binary[*,3]+freq_binary[*,4]+freq_binary[*,5]+freq_binary[*,6]+freq_binary[*,7]+freq_binary[*,8]+freq_binary[*,9]+freq_binary[*,10]+freq_binary[*,11])
;;******************************



     ;; ;;---------------------------------------------------------
     ;; ;;Now let's find out what the 1/8s avg values are corresponding to the
     ;; ;;surviving peak values
     ;; ;;---------------------------------------------------------

     ;; amps2_avg = amps_avg
     ;; boo = where((finite(amps2) eq 0) or finite(freqs2) eq 0,count)
     ;; if boo[0] ne -1 then amps2_avg[boo] = !values.f_nan


     ;;--------------------------------------------------
     ;;Copy of the amplitude array for the amplitude distribution.
     ;;Note: we don't want to use the version that has had small amplitudes removed
     ;;b/c we want to count those here

     amplitudes = replicate(0.,[n_elements(amps2),nf_fce])
     amplitudes_avg = replicate(0.,[n_elements(amps2),nf_fce])
     amplitudes_avg4s = replicate(0.,[n_elements(amps2),nf_fce])


     ;;populate amplitudes and amplog arrays and turn zero values into NaNs
     for f=0,nf_fce-1 do begin
        amplitudes[*,f] = amps2 * freq_binary[*,f]
        amplitudes_avg[*,f] = amps_avg2 * freq_binary[*,f]
        amplitudes_avg4s[*,f] = amps_avg4s2 * freq_binary[*,f]


;;         ;;-------------------------------------------------------
;;         ;;Remove times when the FBK instrument doesn't have a high enough freq
;;         ;;range to observe waves outside of the designated amplitude range.
;;         ;;It seems that the FBK instrument can almost always resolve chorus
;;         ;;outside of the plasmasphere
;;         ;;-------------------------------------------------------

        ;; goo = where(f_fceB[f]*fce_eq gt max(info.fbk_freqs.fbk13_binsh))
        ;; if goo[0] ne -1 then amplitudes[goo,f] = !values.f_nan
;        if goo[0] ne -1 then freqs2[goo] = !values.f_nan


        goo = where(amplitudes[*,f] eq 0)
        if goo[0] ne -1 then amplitudes[goo,f] = !values.f_nan ;Remove bad freqs from the amp array.
        goo = where(amplitudes_avg[*,f] eq 0)
        if goo[0] ne -1 then amplitudes_avg[goo,f] = !values.f_nan ;Remove bad freqs from the amp array.
        goo = where(amplitudes_avg4s[*,f] eq 0)
        if goo[0] ne -1 then amplitudes_avg4s[goo,f] = !values.f_nan ;Remove bad freqs from the amp array.

     endfor

     ;;Remove ratio values when the AVG value is at the noise level
     ;;We'll remove these values in the peak/average ratio later
     bad_avg = where(amplitudes_avg lt 0.05)
     ;; if bad_avg[0] ne -1 then amplitudes_avg[bad_avg] = !values.f_nan
     ;; if bad_avg[0] ne -1 then amplitudes_avg4s[bad_avg] = !values.f_nan


     amplitudes_ratio = amplitudes/amplitudes_avg
     goo = where(amplitudes_ratio eq 0)
     if goo[0] ne -1 then amplitudes_ratio[goo] = !values.f_nan ;Remove bad freqs from the amp array.
     ;; if goo[0] ne -1 then amplitudes_ratio[goo] = 0.
     amplitudes_ratio4s = amplitudes/amplitudes_avg4s
     goo = where(amplitudes_ratio4s eq 0)
     if goo[0] ne -1 then amplitudes_ratio4s[goo] = !values.f_nan ;Remove bad freqs from the amp array.
     ;; if goo[0] ne -1 then amplitudes_ratio4s[goo] = 0.


     amplog = alog10(amplitudes)
     amplog_avg = alog10(amplitudes_avg)
     amplog_avg4s = alog10(amplitudes_avg4s)
     amplog_ratio = alog10(amplitudes_ratio)
     amplog_ratio4s = alog10(amplitudes_ratio4s)




;;      ;;**************************************************
;;      if keyword_set(testing) then begin

;;         store_data,'fbk_spec',data={x:pk.x,y:pk.y,v:pk.v},dlim=dlim,lim=lim
;;         rbsp_load_efw_spec,probe=info.probe,type='calibrated'


;;         ;;eliminate the small amplitudes
;;         goo = where(amptst eq 0)
;;         get_data,rbspx+'_fbk_freq_of_max_adj',data=dx
;;         if goo[0] ne -1 then dx.y[goo] = !values.f_nan
;;         store_data,rbspx+'_fbk_freq_of_max_adj_al',data=dx
;;         get_data,rbspx+'_fbk_freq_of_max_adj_smoothed',data=dx
;;         if goo[0] ne -1 then dx.y[goo] = !values.f_nan
;;         store_data,rbspx+'_fbk_freq_of_max_adj_smoothed_al',data=dx
;;         get_data,rbspx+'_fbk_freq_of_max_orig',data=dx
;;         if goo[0] ne -1 then dx.y[goo] = !values.f_nan
;;         store_data,rbspx+'_fbk_freq_of_max_orig_al',data=dx


;;         ylim,rbspx+'_fbk_freq_of_max_adj_smoothed_al',100,10000,1

;;                                 ;compare originals to version with small amplitudes removed
;;         tplot,[rbspx+'_fbk_freq_of_max_adj_smoothed',rbspx+'_fbk_freq_of_max_adj_smoothed_al']
;;         stop


;;         store_data,'maxamp_comb',data=[rbspx+'_fbk_maxamp_adj_al',rbspx+'_fbk_maxamp_orig_al']
;;         dif_data,rbspx+'_fbk_maxamp_adj_al',rbspx+'_fbk_maxamp_orig_al',newname='ampdiff'
;;         div_data,rbspx+'_fbk_maxamp_adj_al',rbspx+'_fbk_maxamp_orig_al',newname='amp_scalefac'

;;         ylim,'amp_scalefac',0,info.scale_fac_lim + 0.5
;;         options,'maxamp_comb','colors',[250,0]
;;         options,'amp_scalefac','ytitle','FBK_newamp/FBK_originalamp'
;;         options,'maxamp_comb','ytitle','Original FBK amp(black)!CAdjusted FBK amp(red)'
;;         options,'ampdiff','ytitle','Adjusted-Original!CFBK amp'

;;         ;;Check adjusted amplitudes
;;         tplot,['maxamp_comb','ampdiff','amp_scalefac']
;;         stop
;;         ;;make sure adjusted frequencies are reasonable




;;         store_data,rbspx+'_fbk_freq_of_max_orig_al_comb',$
;;                    data=[rbspx+'_fbk_freq_of_max_orig_al','fce_eq','fce_eq2','fce_eq01','fci','flh']
;;         store_data,rbspx+'_fbk_freq_of_max_adj_al_comb',$
;;                    data=[rbspx+'_fbk_freq_of_max_adj_al','fce_eq','fce_eq2','fce_eq01','fci','flh']
;;         store_data,rbspx+'_fbk_freq_of_max_adj_smoothed_al_comb',$
;;                    data=[rbspx+'_fbk_freq_of_max_adj_al_smoothed','fce_eq','fce_eq2','fce_eq01','fci','flh']
;;         zlim,rbspx+'_efw_64_spec0',1d-5,0.01
;;         store_data,rbspx+'_efw_64_spec0_comb',data=[rbspx+'_efw_64_spec0','fce_eq','fce_eq2','fce_eq01','fci','flh']



;;         ylim,[rbspx+'_fbk_freq_of_max_orig_al_comb',rbspx+'_fbk_freq_of_max_adj_al_comb',$
;;               rbspx+'_fbk_freq_of_max_adj_smoothed_al_comb',rbspx+'_efw_64_spec0_comb'],100,10000,1

;;         options,rbspx+'_fbk_freq_of_max_orig_al_comb','colors',[0,250,50,250,50,120]
;;         options,rbspx+'_fbk_freq_of_max_adj_al_comb','colors',[0,250,50,250,50,120]
;;         options,rbspx+'_fbk_freq_of_max_adj_smoothed_al_comb','colors',[0,250,50,250,50,120]
;;         tplot,[rbspx+'_fbk_freq_of_max_orig_al_comb',rbspx+'_fbk_freq_of_max_adj_al_comb',$
;;                rbspx+'_fbk_freq_of_max_adj_smoothed_al_comb',rbspx+'_efw_64_spec0_comb']
;;         stop






;;         store_data,'freqs2',data={x:pk.x,y:freqs2}
;;         store_data,'amplitudes',data={x:pk.x,y:amplitudes}
;; ;        store_data,'amps2',data={x:pk.x,y:amps2}




;;         zlim,rbspx+'_efw_64_spec0',1d-5,0.01
;;         store_data,rbspx+'_efw_64_spec0_comb',data=[rbspx+'_efw_64_spec0','fce_eq','fce_eq2','fce_eq01','fci','flh']
;;         store_data,'fbk_freq_of_max_orig2',data=[rbspx+'_fbk_freq_of_max_orig','fce_eq','fce_eq2','fce_eq01','fci','flh']
;;         store_data,'fbk_freq_of_max_adj2',data=[rbspx+'_fbk_freq_of_max_adj','fce_eq','fce_eq2','fce_eq01','fci','flh']
;;         store_data,'fbk_spec_comb',data=['fbk_spec','fce_eq','fce_eq2','fce_eq01','fci','flh']
;;         store_data,rbspx+'_fbk_freq_of_max_adj_smoothed_comb',$
;;                    data=[rbspx+'_fbk_freq_of_max_adj_smoothed','fce_eq','fce_eq2','fce_eq01','fci','flh']

;;         ;;eliminate the small amplitudes
;;         freqs3 = freqs2
;;         goo = where(amptst eq 0)
;;         if goo[0] ne -1 then freqs3[goo] = !values.f_nan
;;         store_data,'freqs3',data={x:freqs.x,y:freqs3}


;;         store_data,'fbkadj_fce',data=['freqs3','fce_eq','fce_eqL','fce_eqH']
;;         ylim,['fbk_freq_of_max_orig2','fbk_freq_of_max_adj2',rbspx+'_fbk_freq_of_max_adj_smoothed_comb',$
;;               'fbkadj_fce',rbspx+'_efw_64_spec0_comb','fbk_spec_comb'],100,10000,1
;;         options,['fbk_freq_of_max_orig2','fbk_freq_of_max_adj2','fbkadj_fce'],'psym',0
;;         zlim,'fbk_spec',1d-2,1,1


;;         tplot,['fbk_freq_of_max_orig2','fbk_freq_of_max_adj2',$
;;                rbspx+'_fbk_freq_of_max_adj_smoothed_comb','fbkadj_fce',$
;;                rbspx+'_efw_64_spec0_comb','fbk_spec_comb']
;;         stop


;;      endif
;;      ;;****************************************************************








     ;;**************************************************
     ;;Testing...plot all the amplitude arrays for each frequency range and
     ;;compare to f/fce
     if keyword_set(testing) then begin

;; RBSP_EFW> print,info.f_fceb
;;       0.00000      0.00000     0.100000     0.200000     0.300000     0.400000     0.500000     0.600000     0.700000     0.800000
;;      0.900000      1.00000
;; RBSP_EFW> print,info.f_fcet
;;       10.0000     0.100000     0.200000     0.300000     0.400000     0.500000     0.600000     0.700000     0.800000     0.900000
;;       1.00000      10.0000


        store_data,'amps_00100',data={x:pk.x,y:amplitudes[*,0]}
        store_data,'amps_0001',data={x:pk.x,y:amplitudes[*,1]}
        store_data,'amps_0102',data={x:pk.x,y:amplitudes[*,2]}
        store_data,'amps_0203',data={x:pk.x,y:amplitudes[*,3]}
        store_data,'amps_0304',data={x:pk.x,y:amplitudes[*,4]}
        store_data,'amps_0405',data={x:pk.x,y:amplitudes[*,5]}
        store_data,'amps_0506',data={x:pk.x,y:amplitudes[*,6]}
        store_data,'amps_0607',data={x:pk.x,y:amplitudes[*,7]}
        store_data,'amps_0708',data={x:pk.x,y:amplitudes[*,8]}
        store_data,'amps_0809',data={x:pk.x,y:amplitudes[*,9]}
        store_data,'amps_0910',data={x:pk.x,y:amplitudes[*,10]}
        store_data,'amps_10100',data={x:pk.x,y:amplitudes[*,11]}

        div_data,rbspx+'_fbk_freq_of_max_adj_smoothed','fce_eq'
        ylim,'rbspa_fbk_freq_of_max_adj_smoothed/fce_eq',0,1
        options,'rbspa_fbk_freq_of_max_adj_smoothed/fce_eq','ytitle','f/fce'

        options,'*amps*','psym',4
        tplot,['*amps_*','rbspa_state_lshell',$
               rbspx+'_fbk_freq_of_max_adj',rbspx+'_fbk_freq_of_max_adj_smoothed',$
               'rbspa_fbk_freq_of_max_adj_smoothed/fce_eq']

        ;; tplot,['amps_00100','amps_0910','amps_0809','amps_0708','amps_0607','amps_0506',$
        ;;        'amps_0405','amps_0304','amps_0203','amps_0102','rbspa_state_lshell',$
        ;;        rbspx+'_fbk_freq_of_max_adj',rbspx+'_fbk_freq_of_max_adj_smoothed',$
        ;;        'rbspa_fbk_freq_of_max_adj_smoothed/fce_eq']

        stop
     endif
     ;;**************************************************






     ;; Now that we have 1-D arrays for freq and amp of the FBK data we can divide
     ;; it up into discrete chunks so that we can save an entire mission's worth of data.

     ;;number of times with timestep dt
     ntimes = n_elements(timesc)

     t0 = freqs.x[0]
     t1 = freqs.x[0] + info.dt

     ;;number of FBK spikes above threshold
     peakn = fltarr(ntimes,nf_fce)
     avgn = fltarr(ntimes,nf_fce)

     ;;peak values (peakv = peak channel; avgv = average channel) within each bin
     peakv = fltarr(ntimes,nf_fce)
     avgv = fltarr(ntimes,nf_fce)




     ;; amps_tmp_avg = amps_avg

     ;; goo = where(amps_tmp_avg[*] eq 0)
     ;; if goo[0] ne -1 then amps_tmp_avg[goo] = !values.f_nan ;Remove bad freqs from the amp array.
     ;; amplog_avg = alog10(amps_tmp_avg)

     ;; amps_tmp_avg4s = amps_avg4s
     ;; goo = where(amps_tmp_avg4s[*] eq 0)
     ;; if goo[0] ne -1 then amps_tmp_avg4s[goo] = !values.f_nan ;Remove bad freqs from the amp array.
     ;; amplog_avg4s = alog10(amps_tmp_avg4s)


;     freqs_tmp = freqs2/fce_eq  ;bad freqs already removed
;**     boo = where(finite(amps2) eq 0.)
;     boo = where(finite(amplitudes) eq 0.)
;     if boo[0] ne -1 then freqs_tmp[boo] = !values.f_nan ;Remove where amp outside of designated range



     ;;--------------------------------------------------
     ;;Histogram dummy runs to determine all the amplitude and
     ;;frequency bins...save each of these to a file
     ;;--------------------------------------------------


     woo = HISTOGRAM(amplog[*,0],reverse_indices=ri,nbins=nbins,binsize=binsize,min=min(bins2),locations=loc)
     ampbins = 10^loc

     woo = HISTOGRAM(amplog_avg[*,0],reverse_indices=ri,nbins=nbins,binsize=binsize_avg,min=min(bins2_avg),$
                     locations=loc)
     ampbins_avg = 10^loc

     woo = HISTOGRAM(amplog_ratio[*,0],reverse_indices=ri,nbins=nbins,binsize=binsize_ratio,min=min(bins2_ratio),$
                     locations=loc)
     ampbins_ratio = 10^loc


     ;; woo = HISTOGRAM(freqs_tmp,reverse_indices=ri,nbins=nbinsf,binsize=binsizef,min=min(binsf),locations=loc)
     ;; freqbins = loc


     openw,lun3,info.path+'pk_bins.txt',/get_lun
     printf,lun3,'amplitude bins for pk values'
     for qq=0,n_elements(ampbins)-1 do printf,lun3,ampbins[qq]
     close,lun3
     free_lun,lun3

     openw,lun3,info.path+'avg_bins.txt',/get_lun
     printf,lun3,'amplitude bins for av values'
     for qq=0,n_elements(ampbins_avg)-1 do printf,lun3,ampbins_avg[qq]
     close,lun3
     free_lun,lun3

     openw,lun3,info.path+'ratio_bins.txt',/get_lun
     printf,lun3,'amplitude bins for ratio values'
     for qq=0,n_elements(ampbins_ratio)-1 do printf,lun3,ampbins_ratio[qq]
     close,lun3
     free_lun,lun3

     openw,lun3,info.path+'freq_bins.txt',/get_lun
     printf,lun3,'frequency bins'
     for qq=0,n_elements(freqbins)-1 do printf,lun3,freqbins[qq]
     close,lun3
     free_lun,lun3


     ;;--------------------------------------------------
     ;;Now let's get the actual histogrammed values for each
     ;;time chunk dt
     ;;--------------------------------------------------


     amphist_pk = fltarr(ntimes,nbins,nf_fce) ;for the amp histogram
     amphist_avg = fltarr(ntimes,nbins,nf_fce)       ;...same but for average values
     amphist_avg4s = fltarr(ntimes,nbins,nf_fce)     ;...same but for average values
     amphist_ratio = fltarr(ntimes,nbins,nf_fce)     ;...same but for peak/average ratio
     amphist_ratio4s = fltarr(ntimes,nbins,nf_fce)   ;...same but for peak/average ratio
     ;; freqhist = fltarr(ntimes,nbins,nf_fce)          ;for the freq histogram


     for ntime=0d,ntimes-1 do begin
        ;;All data in timechunk dt
        tchunk = where((freqs.x ge t0) and (freqs.x le t1))

        if tchunk[0] ne -1 then begin
           for f=0,nf_fce-1 do begin


              print,'t0 = ' + time_string(t0)
              print,'t1 = ' + time_string(t1)
              print,'*****'

              ;;-----------------------------
              ;;Save the peak values each dt
              ;;-----------------------------


              boo = where(finite(amplitudes[tchunk,f]) ne 0 and finite(freqs2[tchunk]) ne 0,count)
              peakn[ntime,f] = count

              boo_avg = where(finite(amplitudes_avg[tchunk,f]) ne 0 and finite(freqs2[tchunk]) ne 0,count_avg)
              avgn[ntime,f] = count_avg


              if count ne 0 then begin
                 tmp = amplitudes[tchunk[boo],f]
                 peakv[ntime,f] = max(tmp,/nan)
              endif

              if count_avg ne 0 then begin
                 tmp = amplitudes_avg[tchunk[boo_avg],f]
                 avgv[ntime,f] = max(tmp,/nan)
              endif




              ;;peak values
              woo = where(finite(amplog[tchunk,f]) ne 0)
              if woo[0] ne -1 then amphist_pk[ntime,*,f] = HISTOGRAM(amplog[tchunk,f],reverse_indices=ri,nbins=nbins,$
                                                                        binsize=binsize,min=min(bins2),locations=loc)
              ;;average values (1/8s)
              woo = where(finite(amplog_avg[tchunk,f]) ne 0)
              if woo[0] ne -1 then amphist_avg[ntime,*,f] = HISTOGRAM(amplog_avg[tchunk,f],reverse_indices=ri,$
                                                                    nbins=nbins,binsize=binsize_avg,$
                                                                    min=min(bins2_avg),locations=loc)
              ;;average values (4s)
              woo = where(finite(amplog_avg4s[tchunk,f]) ne 0)
              if woo[0] ne -1 then amphist_avg4s[ntime,*,f] = HISTOGRAM(amplog_avg4s[tchunk,f],reverse_indices=ri,$
                                                                      nbins=nbins,binsize=binsize_avg,$
                                                                      min=min(bins2_avg),locations=loc)
              ;;peak/average ratio (using 1/8s avg values)
              woo = where(finite(amplog_ratio[tchunk,f]) ne 0)
              if woo[0] ne -1 then amphist_ratio[ntime,*,f] = HISTOGRAM(amplog_ratio[tchunk,f],reverse_indices=ri,$
                                                                      nbins=nbins,binsize=binsize_ratio,$
                                                                      min=min(bins2_ratio),locations=loc)
              ;;peak/average ratio (using 4s avg values)
              woo = where(finite(amplog_ratio4s[tchunk,f]) ne 0)
              if woo[0] ne -1 then amphist_ratio4s[ntime,*,f] = HISTOGRAM(amplog_ratio4s[tchunk,f],reverse_indices=ri,$
                                                                        nbins=nbins,binsize=binsize_ratio,$
                                                                        min=min(bins2_ratio),locations=loc)

           endfor
        endif

        t0 = t0 + info.dt
        t1 = t1 + info.dt

     endfor







     if testing then begin
        ;;MLT ranging from 0-12 and Lshell

        tinterpol_mxn,'rbspa_state_mlt',timesc,newname='rbspa_state_mlt'
        tinterpol_mxn,'rbspa_state_lshell',timesc,newname='rbspa_state_lshell'

        get_data,'rbspa_state_mlt',data=mlt
        mlt.y[*] = 5.  ;12d*dindgen(1440)/1439.
        store_data,'rbspa_state_mlt',data=mlt


        get_data,'rbspa_state_lshell',data=lshell
        lshell.y = (7-2)*indgen(1440)/1439. + 2.
        store_data,'rbspa_state_lshell',data=lshell

        tplot,'rbspa_state_'+['mlt','lshell']


        stop

;;**************************************************
;;***Test by artificially setting all the Lshell values of a SINGLE MLT
;;**************************************************

        ;; goo = where((lshell.y ge 2.) and (lshell.y lt 3.))
        ;; peakn[goo,4] = (60.*8*1.0)

        ;; goo = where((lshell.y ge 3.) and (lshell.y lt 4.))
        ;; peakn[goo,4] = (60.*8*0.9)
        ;; peakv[goo,4] = 2.

        ;; goo = where((lshell.y ge 4.) and (lshell.y lt 5.))
        ;; peakn[goo,4] = (60.*8*0.7)
        ;; peakv[goo,4] = 20.

        ;; goo = where((lshell.y ge 5.) and (lshell.y lt 6.))
        ;; peakn[goo,4] = (60.*8*0.5)
        ;; peakv[goo,4] = 50.

        ;; goo = where((lshell.y ge 6.) and (lshell.y lt 7.))
        ;; peakn[goo,4] = (60.*8*0.3)
        ;; peakv[goo,4] = 100.

;;**************************************************
;;***Test by artificially setting all the MLT values of a SINGLE Lshell
;;**************************************************
;;         goo = where((mlt.y ge 0.) and (mlt.y lt 1.))
;; ;;number of "dt" chunks
;; ;; RBSP_EFW> help,goo
;; ;; GOO             LONG      = Array[120]

;;         ;;In each of these "dt"s we want to see 60.*8 counts
;;         peakn[goo,4] = (60.*8*1.0)
;;         ;;this gives us a 100% duty cycle
;;         print,(60.*8)*(1/8.)/info.dt

;;         ;;Decrease duty cycle with each increasing MLT sector
;;         goo = where((mlt.y ge 1.) and (mlt.y lt 2.))
;;         peakn[goo,4] = (60.*8.*0.9)
;;         peakv[goo,4] = 2.
;;         goo = where((mlt.y ge 2.) and (mlt.y lt 3.))
;;         peakn[goo,4] = (60.*8.*0.8)
;;         peakv[goo,4] = 10.
;;         goo = where((mlt.y ge 3.) and (mlt.y lt 4.))
;;         peakn[goo,4] = (60.*8.*0.7)
;;         peakv[goo,4] = 20.
;;         goo = where((mlt.y ge 4.) and (mlt.y lt 5.))
;;         peakn[goo,4] = (60.*8.*0.6)
;;         peakv[goo,4] = 30.
;;         goo = where((mlt.y ge 5.) and (mlt.y lt 6.))
;;         peakn[goo,4] = (60.*8.*0.5)
;;         peakv[goo,4] = 40.
;;         goo = where((mlt.y ge 6.) and (mlt.y lt 7.))
;;         peakn[goo,4] = (60.*8.*0.4)
;;         peakv[goo,4] = 50.
;;         goo = where((mlt.y ge 7.) and (mlt.y lt 8.))
;;         peakn[goo,4] = (60.*8.*0.3)
;;         peakv[goo,4] = 60.
;;         goo = where((mlt.y ge 8.) and (mlt.y lt 9.))
;;         peakn[goo,4] = (60.*8.*0.2)
;;         peakv[goo,4] = 70.
;;         goo = where((mlt.y ge 9.) and (mlt.y lt 10.))
;;         peakn[goo,4] = (60.*8.*0.1)
;;         peakv[goo,4] = 80.
;;         goo = where((mlt.y ge 10.) and (mlt.y lt 11.))
;;         peakn[goo,4] = (60.*8.*0.05)
;;         peakv[goo,4] = 90.
;;         goo = where((mlt.y ge 11.) and (mlt.y lt 12.))
;;         peakn[goo,4] = (60.*8.*0.0)
;;         peakv[goo,4] = 100.



        stop

     endif






;; ;**************************************************
;; ;testing the above arrays (all seems to work)
;; ;**************************************************

;;      if testing then begin


;; ;**************************************************
;; ;Test of peakv and avgv (note that total of the peak value in the
;; ;0.0*fce-10*fce bin should equal the total of the SINGLE peak value in
;; ;all the other bins)
;;         print,total(peakv[*,0])
;;         print,total(peakv[*,1]>peakv[*,2]>peakv[*,3]>peakv[*,4]>peakv[*,5]>peakv[*,6]>peakv[*,7]>peakv[*,8]>peakv[*,9]>peakv[*,10]>peakv[*,11])

;;         print,total(avgv[*,0])
;;         print,total(avgv[*,1]>avgv[*,2]>avgv[*,3]>avgv[*,4]>avgv[*,5]>avgv[*,6]>avgv[*,7]>avgv[*,8]>avgv[*,9]>avgv[*,10]>avgv[*,11])
;; ;**************************************************


;; ;**************************************************
;; ;Total number of counts in the 0*fce-10*fce bin should be equal to
;; ;                                      the total number of counts in
;; ;                                      all the other bins
;; ;                                      (e.g. 0*fce-0.1*fce +
;; ;                                      0.1*fce-0.2*fce...+1.0*fce-10.0*fce)
;;         print,total(peakn[*,0])
;;         print,total(peakn[*,1]+peakn[*,2]+peakn[*,3]+peakn[*,4]+peakn[*,5]+peakn[*,6]+peakn[*,7]+peakn[*,8]+peakn[*,9]+peakn[*,10]+peakn[*,11])

;;         print,total(avgn[*,0])
;;         print,total(avgn[*,1]+avgn[*,2]+avgn[*,3]+avgn[*,4]+avgn[*,5]+avgn[*,6]+avgn[*,7]+avgn[*,8]+avgn[*,9]+avgn[*,10]+avgn[*,11])
;; ;**************************************************


;; ;**************************************************
;; ;The amplitude arrays should also sum up properly

;;         print,total(amplog[*,0],/nan)
;;         sum = 0L
;;         for i=1,11 do sum += total(amplog[*,i],/nan)
;;         print,sum

;;         print,total(amplog_avg[*,0],/nan)
;;         sum = 0L
;;         for i=1,11 do sum += total(amplog_avg[*,i],/nan)
;;         print,sum

;;         print,total(amplog_avg4s[*,0],/nan)
;;         sum = 0L
;;         for i=1,11 do sum += total(amplog_avg4s[*,i],/nan)
;;         print,sum

;;         print,total(amplog_ratio[*,0],/nan)
;;         sum = 0L
;;         for i=1,11 do sum += total(amplog_ratio[*,i],/nan)
;;         print,sum

;;         print,total(amplog_ratio4s[*,0],/nan)
;;         sum = 0L
;;         for i=1,11 do sum += total(amplog_ratio4s[*,i],/nan)
;;         print,sum


;; ;**************************************************


;;         print,total(amphist_pk[*,*,0])
;;         print,total(amphist_pk[*,*,1]+amphist_pk[*,*,2]+amphist_pk[*,*,3]+amphist_pk[*,*,4]+amphist_pk[*,*,5]+amphist_pk[*,*,6]+amphist_pk[*,*,7]+amphist_pk[*,*,8]+amphist_pk[*,*,9]+amphist_pk[*,*,10]+amphist_pk[*,*,11])


;;         print,total(amphist_avg[*,*,0])
;;         print,total(amphist_avg[*,*,1]+amphist_avg[*,*,2]+amphist_avg[*,*,3]+amphist_avg[*,*,4]+amphist_avg[*,*,5]+amphist_avg[*,*,6]+amphist_avg[*,*,7]+amphist_avg[*,*,8]+amphist_avg[*,*,9]+amphist_avg[*,*,10]+amphist_avg[*,*,11])

;;         print,total(amphist_avg4s[*,*,0])
;;         print,total(amphist_avg4s[*,*,1]+amphist_avg4s[*,*,2]+amphist_avg4s[*,*,3]+amphist_avg4s[*,*,4]+amphist_avg4s[*,*,5]+amphist_avg4s[*,*,6]+amphist_avg4s[*,*,7]+amphist_avg4s[*,*,8]+amphist_avg4s[*,*,9]+amphist_avg4s[*,*,10]+amphist_avg4s[*,*,11])

;;         print,total(amphist_ratio[*,*,0])
;;         print,total(amphist_ratio[*,*,1]+amphist_ratio[*,*,2]+amphist_ratio[*,*,3]+amphist_ratio[*,*,4]+amphist_ratio[*,*,5]+amphist_ratio[*,*,6]+amphist_ratio[*,*,7]+amphist_ratio[*,*,8]+amphist_ratio[*,*,9]+amphist_ratio[*,*,10]+amphist_ratio[*,*,11])

;;         print,total(amphist_ratio4s[*,*,0])
;;         print,total(amphist_ratio4s[*,*,1]+amphist_ratio4s[*,*,2]+amphist_ratio4s[*,*,3]+amphist_ratio4s[*,*,4]+amphist_ratio4s[*,*,5]+amphist_ratio4s[*,*,6]+amphist_ratio4s[*,*,7]+amphist_ratio4s[*,*,8]+amphist_ratio4s[*,*,9]+amphist_ratio4s[*,*,10]+amphist_ratio4s[*,*,11])


;;         stop

;;      endif


     ;;Now that we're done using the high cadence Bfield data let's interpolate
     ;;it to the common times

     sz = n_elements(timesc)/info.ndays
     goo = strmid(time_string(timesc),0,10)
     goo2 = strmid(time_string(freqs.x[0]),0,10)
     goo = where(goo eq goo2)

     tcurrent = timesc[goo]

     fce = 28.*interpol(mag.y,mag.x,tcurrent)
     fce_eq = interpol(fce_eq,pk.x,tcurrent)

     tinterpol_mxn,rbspx+'_emfisis_l3_'+magcadence+'_gse_Mag',tcurrent,newname='Bfield'
     get_data,'Bfield',data=Bfield


     ;;************
     if keyword_set(test_mock_fbk7) then info.fbk_mode = '13'
     ;;************





     f_fceBstr = strtrim(string(floor(10*info.f_fceB),format='(i8)'),2)
     f_fceTstr = strtrim(string(floor(10*info.f_fceT),format='(i8)'),2)


     ;;---------------------------------------------------------
     ;;Save the peak and average values each dt to a file
     ;;---------------------------------------------------------

     ;;filenames will look like  fbk13_RBSPa_fbk0102_Ew_20121013.txt
     goo = where(float(f_fceBstr) lt 10)
     if goo[0] ne -1 then f_fceBstr[goo] = '0' + f_fceBstr[goo]
     goo = where(float(f_fceTstr) lt 10)
     if goo[0] ne -1 then f_fceTstr[goo] = '0' + f_fceTstr[goo]


     currdate2 = strmid(time_string(time_double(currdate),format=2),0,8)





;;save the file with the ephemeris data
     fnametmp = 'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_fbk_ephem2_' + $
                info.fbk_type+'_'+currdate2+'.txt'

     openw,lun,info.path + fnametmp,/get_lun
     for zz=0L,ntimes-1 do printf,lun,format='(I10,5x,5f10.1,3f8.3)',$
                                  tcurrent[zz],$
                                  fce[zz],fce_eq[zz],$
                                  Bfield.y[zz,0],Bfield.y[zz,1],Bfield.y[zz,2],$
                                  sax[zz],say[zz],saz[zz]

;;save the peak and avg values, etc for each freq range
     for f=0,nf_fce-1 do begin
        fnametmp = 'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_fbk'+f_fceBstr[f]+f_fceTstr[f]+$
                   '_'+info.fbk_type+'_'+currdate2+'.txt'

        openw,lun,info.path + fnametmp,/get_lun
        for zz=0L,ntimes-1 do printf,lun,format='(I10,5x,4f10.3)',$
                                     tcurrent[zz],$
                                     peakn[zz,f],avgn[zz,f],peakv[zz,f],avgv[zz,f]

     endfor
     close,lun
     free_lun,lun


     ;;---------------------------------------------------------
     ;;Save the amplitude distributions to a file
     ;;---------------------------------------------------------
     ;;filenames will look like  fbk13_RBSPa_ampdist0102_Ew_20121013.txt

     str = strtrim(n_elements(bins),2)
     format = '(I10.5,5x,' + strtrim(n_elements(bins),2) + 'I5)'



     if keyword_set(testing) then begin
        stop


        amphist_pk[*,0,1] = 1;./1440.
        amphist_pk[*,0,2] = 2;./1440.
        amphist_pk[*,0,3] = 3;./1440.
        amphist_pk[*,0,4] = 4;./1440.
        amphist_pk[*,0,5] = 5;./1440.

        amphist_pk[*,24,1] = 1;./1440.
        amphist_pk[*,24,2] = 2;./1440.
        amphist_pk[*,24,3] = 3;./1440.
        amphist_pk[*,24,4] = 4;./1440.
        amphist_pk[*,24,5] = 5;./1440.



     endif


     for i=0,nf_fce-1 do begin
        ;;Peak values
        fnametmp = 'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_pk'+f_fceBstr[i]+f_fceTstr[i]+$
                   '_'+info.fbk_type+'_'+currdate2+'.txt'

        openw,lun,info.path + fnametmp,/get_lun
        for zz=0L,ntimes-1 do printf,lun,tcurrent[zz],amphist_pk[zz,*,i],format=format
        close,lun
        free_lun,lun


        ;;Average values (1/8s)
        fnametmp = 'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg'+f_fceBstr[i]+f_fceTstr[i]+$
                   '_'+info.fbk_type+'_'+currdate2+'.txt'
        openw,lun,info.path + fnametmp,/get_lun
        for zz=0L,ntimes-1 do printf,lun,tcurrent[zz],amphist_avg[zz,*,i],format=format
        close,lun
        free_lun,lun


        ;;Average values (4s)
        fnametmp = 'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_avg4sec'+f_fceBstr[i]+f_fceTstr[i]+$
                   '_'+info.fbk_type+'_'+currdate2+'.txt'
        openw,lun,info.path + fnametmp,/get_lun
        for zz=0L,ntimes-1 do printf,lun,tcurrent[zz],amphist_avg4s[zz,*,i],format=format
        close,lun
        free_lun,lun


        ;;Peak/Average ratio values (using 1/8s avg values)
        fnametmp = 'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio'+f_fceBstr[i]+f_fceTstr[i]+$
                   '_'+info.fbk_type+'_'+currdate2+'.txt'
        openw,lun,info.path + fnametmp,/get_lun
        for zz=0L,ntimes-1 do printf,lun,tcurrent[zz],amphist_ratio[zz,*,i],format=format
        close,lun
        free_lun,lun


        ;;Peak/Average ratio values (using 4s avg values)
        fnametmp = 'fbk'+info.fbk_mode+'_RBSP'+info.probe+'_ampdist_ratio4sec'+f_fceBstr[i]+f_fceTstr[i]+$
                   '_'+info.fbk_type+'_'+currdate2+'.txt'
        openw,lun,info.path + fnametmp,/get_lun
        for zz=0L,ntimes-1 do printf,lun,tcurrent[zz],amphist_ratio4s[zz,*,i],format=format
        close,lun
        free_lun,lun



     endfor

  endif
end
