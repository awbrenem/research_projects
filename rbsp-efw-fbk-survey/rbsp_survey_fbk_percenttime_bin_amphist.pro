;; Calculates the % time that waves b/t info.minamp_pk(av) and info.maxamp_pk(av) 
;; are seen in the filterbank data. 
;; Adds the following % time results to the "info" structure
;;The output values have size  (nshells,nthetas)

;; Called from rbsp_survey_fbk_percenttime_crib.pro

;; %time = [number * (1/8)]/dt

;; where dt = block size (sec)
;; and number = number of counts above certain amp threshold in time t0 to t0+dt


;; Ex. let dt=10 sec. There are 10*8=80 FBK blocks in this time. If we see 80 large
;; amplitude peaks during this time then %time=100

;; Since the FBK data is spin modulated its probably best to have dt as a multiple of  
;; half a spin period. 


;; NOTE: SINCE I HAVE A CONSTANT DT VALUE I NEED TO DO THE FOLLOWING:
;; 	1) CALCULATE THE %TIME FOR EACH DT USING EQUATION ABOVE
;; 	2) AVERAGE THE "AVERAGES" FOR ALL THE DTS IN EACH SECTOR. 
;; 		ex, if a single sector has 5 dt chunks and each sees a wave above
;; 			the threshold 50% of the time then the duty cycle for that wave
;; 			is (50 + 50 + 50 + 50 + 50)/5. = 50%




;; Written by Aaron W Breneman 03/12/2013



;; CURRENT TESTING
;; ---I've set the threshold amplitude to 0 mV/m and the return results indicate that each
;; 	freq in each sector has a 100% duty cycle which is good! 
;; ---I've tested this by isolating a chunk of data during a single apogee pass where 
;; 	Mlat ranged from 6-7 and Lshell ranged from 6-7 (i.e. a single grid bin). During this 
;; 	time the tplot variable npk_percent showed that peak values above 1 mV/m with dt=60 seconds
;; 	occurred with a 31.6% duty cycle. When I then plotted the binned data using 
;; 	rbsp_survey_fbk_plot.pro the %-time value in the single bin was exactly 31.6%




pro rbsp_survey_fbk_percenttime_bin_amphist,info,optstr,testing=testing,combinesc=combinesc



;;******

  rbspx = 'rbsp' + info.probe

  loadct,39
  !p.charsize = 1.5

  if ~keyword_set(combinesc) then begin


     get_data,rbspx+'_amp_ampdist_pk'+optstr+'_counts',data=amppk
     namps = n_elements(amppk.v)

     get_data,rbspx+'_mlt',data=mlt

     ;; Check for NaN values that may have been inserted b/c of AE, DST or Mlat limiting
     ;; Find the intersection of the ranges and grab only good MLT and
     ;; Lshell values (used for normalizing by nsamples)
     mina = Min(mlt.x, Max=maxa) 
     minb = Min(amppk.x, Max=maxb)
     minab = mina > minb
     maxab = maxa < maxb
     
     r = Where((Histogram(amppk.x, Min=minab, Max=maxab) NE 0) AND  $
               (Histogram(mlt.x, Min=minab, Max=maxab) NE 0), count)
     mlt = {x:mlt.x[r],y:mlt.y[r]}



     get_data,rbspx+'_lshell',data=lshell
     mina = Min(lshell.x, Max=maxa) 
     minb = Min(amppk.x, Max=maxb)
     minab = mina > minb
     maxab = maxa < maxb
     lshell = {x:lshell.x[r],y:lshell.y[r]}


     

     ;;Since we normalize the results by the number of "dt" in a
     ;;certain MLT, Lshell range, we want to be sure that we're
     ;;only counting MLT and Lshell values where we don't have NaN'd data




;; ** Structure <2827408>, 6 tags, length=25758728, data length=25758728, refs=1:
;;    X               LONG      Array[247679]
;;    Y               LONG      Array[247679, 25]
;;    V               FLOAT     Array[25]
     

     mlt = mlt.y
     lshell = lshell.y		
     
  endif
  
  ;; if keyword_set(combinesc) then begin

  ;;    get_data,'rbspa'+'_nfbk_pk'+optstr,data=npka
  ;;    get_data,'rbspa'+'_nfbk_av'+optstr,data=nava
  ;;    get_data,'rbspa'+'_fbk_pk'+optstr,data=pka
  ;;    get_data,'rbspa'+'_fbk_av'+optstr,data=ava
  ;;    get_data,'rbspa'+'_mlt',data=mlta
  ;;    get_data,'rbspa'+'_lshell',data=lshella

  ;;    ;; Check for NaN values that may have been inserted b/c of AE, DST or Mlat limiting
  ;;    goo = where(finite(npka.y) eq 1)
  ;;    if goo[0] ne -1 then begin
  ;;       npka = {x:npka.x[goo],y:npka.y[goo]}
  ;;       nava = {x:nava.x[goo],y:nava.y[goo]}
  ;;       pka = {x:pka.x[goo],y:pka.y[goo]}
  ;;       ava = {x:ava.x[goo],y:ava.y[goo]}
  ;;       mlta = {x:mlta.x[goo],y:mlta.y[goo]}
  ;;       lshella = {x:lshella.x[goo],y:lshella.y[goo]}
  ;;    endif	

  
  ;;    get_data,'rbspb'+'_nfbk_pk'+optstr,data=npkb
  ;;    get_data,'rbspb'+'_nfbk_av'+optstr,data=navb
  ;;    get_data,'rbspb'+'_fbk_pk'+optstr,data=pkb
  ;;    get_data,'rbspb'+'_fbk_av'+optstr,data=avb
  ;;    get_data,'rbspb'+'_mlt',data=mltb
  ;;    get_data,'rbspb'+'_lshell',data=lshellb

  ;;    ;; Check for NaN values that may have been inserted b/c of AE, DST or Mlat limiting
  ;;    goo = where(finite(npkb.y) eq 1)
  ;;    if goo[0] ne -1 then begin
  ;;       npkb = {x:npkb.x[goo],y:npkb.y[goo]}
  ;;       navb = {x:navb.x[goo],y:navb.y[goo]}
  ;;       pkb = {x:pkb.x[goo],y:pkb.y[goo]}
  ;;       avb = {x:avb.x[goo],y:avb.y[goo]}
  ;;       mltb = {x:mltb.x[goo],y:mltb.y[goo]}
  ;;       lshellb = {x:lshellb.x[goo],y:lshellb.y[goo]}
  ;;    endif	


  ;;    mlt = [mlta.y,mltb.y]
  ;;    lshell = [lshella.y,lshellb.y] 

  ;; endif		


;;--------------------------------------------------
;; Calculate the percent time for each "dt"
;; %T = 1/(8*dt)*npk
;;--------------------------------------------------

;; ******************************************************
;; HERE'S WHERE WE WANT TO COMBINE RESULTS FOR A AND B. We don't care about the times at
;; this point so we'll combine npkA and npkB into a single array. We also need to do this
;; with Lshell and MLT. 
;; %T = 1/(8*dt)*[npkA,npkB]



  if ~keyword_set(combinesc) then begin

     per_amppk = amppk.y
     per_amppk[*] = 0.
     per_amppk = amppk.y * (1/8.)/info.dt
     ;; per_nav = nav.y * (1/8.)/info.dt

     store_data,rbspx+'_amppk'+optstr+'_percent',data={x:amppk.x,y:per_amppk}
  endif

  ;; if keyword_set(combinesc) then begin

  ;;    per_npka = npka.y * (1/8.)/info.dt
  ;;    per_nava = nava.y * (1/8.)/info.dt

  ;;    per_npkb = npkb.y * (1/8.)/info.dt
  ;;    per_navb = navb.y * (1/8.)/info.dt
  
  ;;    npk = [npka.y,npkb.y]
  ;;    nav = [nava.y,navb.y]	
  ;;    per_npk = npk * (1/8.)/info.dt
  ;;    per_nav = nav * (1/8.)/info.dt

  ;;    store_data,'rbspa'+'_npk'+optstr+'_percent',data={x:npka.x,y:per_npka}
  ;;    store_data,'rbspa'+'_nav'+optstr+'_percent',data={x:nava.x,y:per_nava}
  ;;    store_data,'rbspb'+'_npk'+optstr+'_percent',data={x:npkb.x,y:per_npkb}
  ;;    store_data,'rbspb'+'_nav'+optstr+'_percent',data={x:navb.x,y:per_navb}

  ;; endif




;; ;; ******************************************************
;; ;; TESTING: Use this to isolate a part of the orbit to see if data are binning correctly
;; ;; ******************************************************
;;   if keyword_set(testing) then begin

;;      get_data,rbspx+'_npk_percent',data=npk
;;      t0 = time_double('2012-10-15/20:00')
;;      t1 = time_double('2012-10-15/20:18')

;;      goo = where((npk.x lt t0) or (npk.x gt t1))

;;      npk.y[goo] = 0
;;      store_data,rbspx+'_npk'+optstr+'_percent',data=npk


;;      get_data,rbspx+'_lshell',data=npk
;;      npk.y[goo] = 0
;;      store_data,rbspx+'_lshell',data=npk
;;      get_data,rbspx+'_mlt',data=npk
;;      npk.y[goo] = 0
;;      store_data,rbspx+'_mlt',data=npk

;;      per_npk[goo] = 0.
;;      get_data,rbspx+'_mlt',data=mlt
;;      get_data,rbspx+'_lshell',data=lshell

;;   endif
;; ;; ******************************************************




  nshells = info.grid.nshells
  nthetas = info.grid.nthetas
  grid_lshell = info.grid.grid_lshell
  grid_mlt = info.grid.grid_theta





;; Final saved FBK peak values
  per_peaks = fltarr(nshells,nthetas,namps)
  per_averages = fltarr(nshells,nthetas,namps)
  counts = fltarr(nshells,nthetas,namps)


;;--------------------------------------------------
;;This histogram loop works. I've tested it against an explicit
;;nested loop that loops over all values of L and MLT. The histogram
;;version is much faster
;;--------------------------------------------------




  for i=0,n_elements(grid_lshell)-2 do begin

     ;;select only current Lshell slice
     l1 = grid_lshell[i]
     l2 = grid_lshell[i+1]

     ;;make sure that only allowed MLT values are used
     m1 = grid_mlt[0]
     m2 = grid_mlt[n_elements(grid_mlt)-1]

     print,'lshell range = ',l1,l2
     print,'***'
     print,'mlt range = ',m1,m2

     goo = where(((lshell ge l1) and (lshell lt l2)) and $
                 ((mlt ge m1) and (mlt lt m2)))
     


     if goo[0] ne -1 then begin
        mlt_tmp = mlt[goo]        
        
        nsamples = HISTOGRAM(mlt_tmp,reverse_indices=ri,nbins=nthetas,binsize=info.grid.dtheta,min=info.grid.grid_theta[0],locations=loc) 
        ;; nsamples -> the number of "dt" chunks in each MLT bin for the current Lshell range
        
        ;; These are the actual values of the dt elements of theta bin "b" and freq "f"
        ;; 		print,'Local times for current bin are: '
        ;; 		if ri[b] ne ri[b+1] then print,(mlt_tmp[ri[ri[b] : ri[b+1]-1]])
           ;; 		print,'Peak values corresponding to the current bin are: '
        ;; 		if ri[b] ne ri[b+1] then print,(per_npk_tmp[ri[ri[b] : ri[b+1]-1],f])
        
        for a=0,namps-1 do begin
           
           ;; For each theta bin in current Lshell range let's tally up all the actual values of each "dt" chunk
           ;; and divide by their total. This is step #2 above and represents the overall %time in each
           ;; sector that waves above a certain amplitude threshold exist. 			
           for b=0,nthetas-1 do if ri[b] ne ri[b+1] then per_peaks[i,b,a] = total(per_amppk[ri[ri[b] : ri[b+1]-1],a],/nan)/nsamples[b] 
           ;; for b=0,nthetas-1 do if ri[b] ne ri[b+1] then per_averages[i,b] = total(per_nav_tmp[ri[ri[b] : ri[b+1]-1]],/nan)/nsamples[b]

           ;; help,'ri = ',ri
                                ;       print,transpose(per_peaks[i,*,a])

           
        endfor
        counts[i,*,*] = nsamples

     endif
     ;; print,'i=',i
     ;; print,total(per_peaks[i,*,*],/nan)

  endfor


;; Save values in structure and add to "info"
  percenttime_bin = {percent_amppeaks:per_peaks,$
                                ;percent_ampaverages:per_averages,$
                     counts:counts}

  ;; amps_bin = {peaks:peaks,$
  ;;             averages:averages,$
  ;;             counts:counts}


  str_element,info,'percentoccurrence_ampbin',percenttime_bin,/add_replace
  ;; str_element,info,'amps_bin',amps_bin,/add_replace

  if keyword_set(combinesc) then str_element,info,'combined_sc',1,/add_replace
  if ~keyword_set(combinesc) then str_element,info,'combined_sc',0,/add_replace


end

