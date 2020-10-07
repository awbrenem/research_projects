;; Creates rectangular plots of f_fce vs Lshell or f_fce vs MLT with the color being the %occ
;; Called from rbsp_survey_fbk_crib.pro



pro rbsp_survey_f_fce_plots,$
   info,$
   type=type,$                  ;'mlt' or 'lshell'
   minc_vals=mincolor_vals,$
   maxc_vals=maxcolor_vals,$
   minc_peaks=mincolor_peaks,$
   maxc_peaks=maxcolor_peaks,$
   minc_cnt=mincolor_cnt,$
   maxc_cnt=maxcolor_cnt,$
   text = text_vals,$
   title = title,$
   cbtitle = cbtitle,$
   cb2title = cb2title,$
   ps=ps,$
   formatleft=formatleft,$
   formatright=formatright,$
   nvformatleft=nvformatleft,$
   nvformatright=nvformatright,$
   yrange=yrange,$
   xrange=xrange,$
   plot_linecounts=plot_linecounts


  rbsp_efw_init

  if ~keyword_set(plot_linecounts) then plot_linecounts = 0
  if ~keyword_set(yrange) then begin
     if type eq 'lshell' then yrange=[0,7]
     if type eq 'mlt' then yrange=[0,24]
  endif
  if ~keyword_set(xrange) then xrange=[0,1.3]
  if ~keyword_set(nvformatleft) then nvformatleft = 5
  if ~keyword_set(nvformatright) then nvformatright = 5
  if ~keyword_set(formatleft) then formatleft = '(F4.1)'
  if ~keyword_set(formatright) then formatright = '(F6.1)'
  if ~keyword_set(mincolor_vals) then mincolor_vals = 0.1
  if ~keyword_set(maxcolor_vals) then maxcolor_vals = 150
  if ~keyword_set(mincolor_peaks) then mincolor_peaks = 2
  if ~keyword_set(maxcolor_peaks) then maxcolor_peaks = 100
  if ~keyword_set(mincolor_cnt) then mincolor_cnt = 50

  if ~keyword_set(text_vals) then begin
     if info.combined_sc eq 0 then text_vals = 'Sector values ('+strtrim(floor(info.dt),2)+$
                                               ' sec chunks)!Cfor!C'+'RBSP-'+strupcase(info.probe) + $
                                               '!C'+info.D0+' to '+info.D1+'!C'
     if info.combined_sc eq 1 then text_vals = 'Sector values ('+strtrim(floor(info.dt),2)+$
                                               ' sec chunks)!Cfor!C'+'both sc' + $
                                               '!C'+info.D0+' to '+info.D1+'!C'
  endif
  if ~keyword_set(title) then title = '%occ'
  if ~keyword_set(cbtitle) then cbtitle = ''
  if ~keyword_set(cb2title) then cb2title = ''



  if type eq 'lshell' then begin
     nyaxis = info.grid.nshells
     grid_yaxis_center = info.grid.grid_lshell_center
     grid_yaxis = info.grid.grid_lshell
     ytitle='Lshell'
  endif
  if type eq 'mlt' then begin
     nyaxis = info.grid.nthetas
     grid_yaxis_center = info.grid.grid_theta_center
     grid_yaxis = info.grid.grid_theta
     ytitle='MLT'
  endif

  if ~keyword_set(maxcolor_cnt) then maxcolor_cnt = max(counts)+1

  nf_fce = 12
  f_fce = 0.1*indgen(nf_fce)
  f_fce_center = f_fce + (f_fce[1]-f_fce[0])
  f_fce_center = f_fce_center[0:n_elements(f_fce_center)-2]

  f_fce[n_elements(f_fce)-1] = 1.3
  f_fce_center[n_elements(f_fce)-2] = 1.3



  if info.fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'

  
  ;;Find the %-time in each sector for d0 to d1 (uses
  ;;histogram). Note, I may be able to use the below program if
  ;;I define a single MLT sector
  rbsp_survey_fbk_percenttime_bin,info,'0001' ;,/combinesc
  bins0001 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0001c = reform(info.percentoccurrence_bin.counts)
  peak0001 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0102' ;,/combinesc
  bins0102 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0102c = reform(info.percentoccurrence_bin.counts)
  peak0102 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0203' ;,/combinesc
  bins0203 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0203c = reform(info.percentoccurrence_bin.counts)
  peak0203 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0304' ;,/combinesc
  bins0304 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0304c = reform(info.percentoccurrence_bin.counts)
  peak0304 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0405' ;,/combinesc
  bins0405 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0405c = reform(info.percentoccurrence_bin.counts)
  peak0405 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0506' ;,/combinesc
  bins0506 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0506c = reform(info.percentoccurrence_bin.counts)
  peak0506 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0607' ;,/combinesc
  bins0607 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0607c = reform(info.percentoccurrence_bin.counts)
  peak0607 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0708' ;,/combinesc
  bins0708 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0708c = reform(info.percentoccurrence_bin.counts)
  peak0708 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0809' ;,/combinesc
  bins0809 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0809c = reform(info.percentoccurrence_bin.counts)
  peak0809 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'0910' ;,/combinesc
  bins0910 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0910c = reform(info.percentoccurrence_bin.counts)
  peak0910 = info.amps_bin.peaks
  rbsp_survey_fbk_percenttime_bin,info,'10100' ;,/combinesc
  bins10100 = reform(info.percentoccurrence_bin.percent_peaks)
  bins10100c = reform(info.percentoccurrence_bin.counts)
  peak10100 = info.amps_bin.peaks



  vals_plot = fltarr(info.grid.nshells,info.grid.nthetas,nf_fce-1)
  peaks_plot = fltarr(info.grid.nshells,info.grid.nthetas,nf_fce-1)

  vals_plot[*,*,0] = bins0001
  vals_plot[*,*,1] = bins0102
  vals_plot[*,*,2] = bins0203
  vals_plot[*,*,3] = bins0304
  vals_plot[*,*,4] = bins0405
  vals_plot[*,*,5] = bins0506
  vals_plot[*,*,6] = bins0607
  vals_plot[*,*,7] = bins0708
  vals_plot[*,*,8] = bins0809
  vals_plot[*,*,9] = bins0910
  vals_plot[*,*,10] = bins10100

  vals_plot = 100.*vals_plot

  counts = fltarr(info.grid.nshells,info.grid.nthetas,nf_fce-1)

  counts[*,*,0] = bins0001c
  counts[*,*,1] = bins0102c
  counts[*,*,2] = bins0203c
  counts[*,*,3] = bins0304c
  counts[*,*,4] = bins0405c
  counts[*,*,5] = bins0506c
  counts[*,*,6] = bins0607c
  counts[*,*,7] = bins0708c
  counts[*,*,8] = bins0809c
  counts[*,*,9] = bins0910c
  counts[*,*,10] = bins10100c


  peaks_plot[*,*,0] = peak0001
  peaks_plot[*,*,1] = peak0102
  peaks_plot[*,*,2] = peak0203
  peaks_plot[*,*,3] = peak0304
  peaks_plot[*,*,4] = peak0405
  peaks_plot[*,*,5] = peak0506
  peaks_plot[*,*,6] = peak0607
  peaks_plot[*,*,7] = peak0708
  peaks_plot[*,*,8] = peak0809
  peaks_plot[*,*,9] = peak0910
  peaks_plot[*,*,10] = peak10100



;;--------------------------------------------------
;;Reduce vals_plot to a [a,f] size array (from a [L,m,f]) by slicing
;;over one of the dimensions. For example, if vals_plot = [L,m,f],
;;where L=lshell, m=mlt, f=freq, and we want to plot f_fce vs MLT,
;;then we will integrate over the Lshell values. 

;;For example, if we are considering the MLT=5 hr bin over the slice
;;of L=4-6 and the L bins have a 5%, 20% and 10% chance of seeing a >2
;;mV/m wave, then our total chance in all three L bins of seeing a >2
;;mV/m wave is 5+20+10 = 35%. 
;;--------------------------------------------------

;;The following is correct. I've tested it with artificial input. 

  
  if type eq 'mlt' then begin
     vals_plot2 = fltarr(info.grid.nthetas,nf_fce-1)
     peaks_plot2 = fltarr(info.grid.nthetas,nf_fce-1)
     counts2 = fltarr(info.grid.nthetas,nf_fce-1)
     for t=0,info.grid.nthetas-1 do begin
        for f=0,nf_fce-2 do vals_plot2[t,f] = total(vals_plot[*,t,f],/nan)/info.grid.nshells
        for f=0,nf_fce-2 do peaks_plot2[t,f] = max(peaks_plot[*,t,f],/nan)
        for f=0,nf_fce-2 do counts2[t,f] = total(counts[*,t,f],/nan)
     endfor
  endif
  
  if type eq 'lshell' then begin
     vals_plot2 = fltarr(info.grid.nshells,nf_fce-1)
     peaks_plot2 = fltarr(info.grid.nshells,nf_fce-1)
     counts2 = fltarr(info.grid.nshells,nf_fce-1)
     for l=0,info.grid.nshells-1 do begin
        for f=0,nf_fce-2 do vals_plot2[l,f] = total(vals_plot[l,*,f],/nan)/info.grid.nthetas
        for f=0,nf_fce-2 do peaks_plot2[l,f] = max(peaks_plot[l,*,f],/nan)
        for f=0,nf_fce-2 do counts2[l,f] = total(counts[l,*,f],/nan)
     endfor
  endif



;; ----------------------------
;; Define colors
;; ----------------------------

  ;; --data values
  bs_vals = BYTSCL(vals_plot2,min=mincolor_vals,max=maxcolor_vals)
  bs_peaks = BYTSCL(peaks_plot2,min=mincolor_peaks,max=maxcolor_peaks)
  ;; The last colorbar value is white. To avoid having the largest values be white
  ;; let's change to a value of 254 which is red
  boo = where(bs_vals eq 255)
  if boo[0] ne -1 then bs_vals[boo] = 254
  boo = where(bs_peaks eq 255)
  if boo[0] ne -1 then bs_peaks[boo] = 254


  ;;sometimes really low counts will be associated with 
  ;;bs_vals of zero. Fix this
  goo = where((vals_plot2 ne 0) and (bs_vals eq 0))
  if goo[0] ne -1 then bs_vals[goo] = 1
  goo = where((peaks_plot2 ne 0) and (bs_peaks eq 0))
  if goo[0] ne -1 then bs_peaks[goo] = 1

  ;; Change zero-counts to white
  goo = where(bs_vals eq 0)
  if goo[0] ne -1 then bs_vals[goo] = 255
  goo = where(bs_peaks eq 0)
  if goo[0] ne -1 then bs_peaks[goo] = 255
    
  ;; --counts
  bs_cnt = BYTSCL(counts2,min=mincolor_cnt,max=maxcolor_cnt)
  boo = where(bs_cnt eq 255)
  if boo[0] ne -1 then bs_cnt[boo] = 254
  goo = where(bs_cnt eq 0)
  if goo[0] ne -1 then bs_cnt[goo] = 255 ;change zero-counts to white


  ;; REMOVE VALUES WHEN THE LSHELL-MLT BIN CONTAINS LESS THAN THE MINIMUM COUNTS
  goo = where(bs_cnt eq 255)
  if goo[0] ne -1 then bs_vals[goo] = 255

  goo = where(bs_cnt eq 255)
  if goo[0] ne -1 then bs_peaks[goo] = 255


  
;; ---------------------------------------
;; Plot the data values
;; ---------------------------------------
  
  
  !p.multi = [0,3,0]
  if keyword_set(ps) then !p.charsize = 1.2 else !p.charsize = 1.5


  d0t = strmid(info.d0,0,4)+strmid(info.d0,5,2)+strmid(info.d0,8,2)
  d1t = strmid(info.d1,0,4)+strmid(info.d1,5,2)+strmid(info.d1,8,2)
  if info.maxamp_pk ge 1000 then maxamp = 'inf' else $
     maxamp = strtrim(string(info.maxamp_pk,format='(f6.1)'),2)
  
  ;; text_title = 'fbk_%occ_RBSP'+info.probe+'_dt='+$
  ;;              string(info.dt,format='(i2)')+'s_'+d0t+'-'+d1t + '_(' + $
  ;;              strtrim(string(info.minamp_pk,format='(f5.1)'),2)+'<'+units+'<'+maxamp+')_('+ $
  ;;              strtrim(string(info.mlatL,format='(I2)'),2)+'<mlat<'+$
  ;;              strtrim(string(info.mlatH,format='(I2)'),2)+')_(' + $
  ;;              strtrim(string(info.aeL,format='(I5)'),2)+'<AE<'+$
  ;;              strtrim(string(info.aeH,format='(I5)'),2)+')_(' + $
  ;;              strtrim(string(info.dstL,format='(I6)'),2)+'<DST<'+$
  ;;              strtrim(string(info.dstH,format='(I6)'),2)+').ps'
  ;; text_titlep = 'fbk_peakvalue_RBSP'+info.probe+'_dt='+$
  ;;              string(info.dt,format='(i2)')+'s_'+d0t+'-'+d1t + '_(' + $
  ;;              strtrim(string(info.minamp_pk,format='(f5.1)'),2)+'<'+units+'<'+maxamp+')_('+ $
  ;;              strtrim(string(info.mlatL,format='(I2)'),2)+'<mlat<'+$
  ;;              strtrim(string(info.mlatH,format='(I2)'),2)+')_(' + $
  ;;              strtrim(string(info.aeL,format='(I5)'),2)+'<AE<'+$
  ;;              strtrim(string(info.aeH,format='(I5)'),2)+')_(' + $
  ;;              strtrim(string(info.dstL,format='(I6)'),2)+'<DST<'+$
  ;;              strtrim(string(info.dstH,format='(I6)'),2)+').ps'


  text_title = 'perocc'
  text_titlep = 'peakv'



  if keyword_set(ps) then popen,'~/Desktop/'+text_title,/landscape



  ;;Plot the results
  contour,transpose(bs_vals),f_fce_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
          xrange=xrange,yrange=yrange,title='%occ!C'+title,ytitle=ytitle,xtitle='f/fce_eq',$
          ystyle=1,xstyle=1,position=[0.05,0.1,0.3,0.7],$
          xtickname=['0.0','0.2','0.4','0.6','0.8','1.0','10']


  ;; fill in the cells
  for h=0,nyaxis-1 do begin
     for j=0,nf_fce-2 do begin
        xtmp0 = f_fce[j]
        xtmp1 = f_fce[j+1]
        xtmp2 = xtmp1
        xtmp3 = xtmp0
        xtmp4 = xtmp0

        ytmp0 = grid_yaxis[h]
        ytmp1 = ytmp0
        ytmp2 = grid_yaxis[h+1]
        ytmp3 = ytmp2
        ytmp4 = ytmp0

        if xtmp0 ge min(xrange) and $
           xtmp1 le max(xrange) and $
           ytmp0 ge min(yrange) and $
           ytmp2 le max(yrange) then polyfill,[xtmp0,xtmp1,xtmp2,xtmp3,xtmp4],$
                                              [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4],color=bs_vals[h,j]
        
     endfor
  endfor

  for q=0,nyaxis do oplot,[0,10],[grid_yaxis[q],grid_yaxis[q]]
  for q=0,nf_fce-1 do oplot,[f_fce[q],f_fce[q]],[0,1000]
  oplot,[0.1,0.1],[0,1000],thick=4
  oplot,[0.5,0.5],[0,1000],thick=4
  oplot,[1,1],[0,1000],thick=4
  


  ;; ticknames for the peak values
  tn = (maxcolor_vals-mincolor_vals)*indgen(nvformatleft)/(nvformatleft-1) + mincolor_vals
  tn = string(tn,format=formatleft)

  colorbar,ticknames=tn,divisions=nvformatleft-1,position=[.05,.85,.3,.87],title=cbtitle



  if type eq 'lshell' then begin
     ;;Because the instrument samples at 16384 S/s, the FBK limit is
     ;;about 8192 Hz. Oplot a line representing this limitation.
     Lplot = [2,3,4,5,6,7]
     ;;Bvals from standard dipole field
     Bvals = [3750,1111,470,240,140,87]
     fce = 28.*Bvals
     maxf = 8192./fce
     
     oplot,maxf,Lplot,thick=4

  endif






;;--------------------------------------------------
;;plot the peak values
;;--------------------------------------------------

  ;;Plot the results
  contour,transpose(bs_peaks),f_fce_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
          xrange=xrange,yrange=yrange,title='peak amp!C'+title,ytitle=ytitle,xtitle='f/fce_eq',$
          ystyle=1,xstyle=1,position=[0.35,0.1,0.6,0.7],$
          xtickname=['0.0','0.2','0.4','0.6','0.8','1.0','10']


  ;; fill in the cells
  for h=0,nyaxis-1 do begin
     for j=0,nf_fce-2 do begin
        xtmp0 = f_fce[j]
        xtmp1 = f_fce[j+1]
        xtmp2 = xtmp1
        xtmp3 = xtmp0
        xtmp4 = xtmp0

        ytmp0 = grid_yaxis[h]
        ytmp1 = ytmp0
        ytmp2 = grid_yaxis[h+1]
        ytmp3 = ytmp2
        ytmp4 = ytmp0

        if xtmp0 ge min(xrange) and $
           xtmp1 le max(xrange) and $
           ytmp0 ge min(yrange) and $
           ytmp2 le max(yrange) then polyfill,[xtmp0,xtmp1,xtmp2,xtmp3,xtmp4],$
                                              [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4],color=bs_peaks[h,j]
        
     endfor
  endfor

  for q=0,nyaxis do oplot,[0,10],[grid_yaxis[q],grid_yaxis[q]]
  for q=0,nf_fce-1 do oplot,[f_fce[q],f_fce[q]],[0,1000]
  oplot,[0.1,0.1],[0,1000],thick=4
  oplot,[0.5,0.5],[0,1000],thick=4
  oplot,[1,1],[0,1000],thick=4
  



  ;; ticknames for the peak values
  tn = (maxcolor_peaks-mincolor_peaks)*indgen(nvformatleft)/(nvformatleft-1) + mincolor_peaks
  tn = string(tn,format=formatleft)

  colorbar,ticknames=tn,divisions=nvformatleft-1,position=[.35,.85,.6,.87],title=cb2title



  if type eq 'lshell' then begin
     ;;Because the instrument samples at 16384 S/s, the FBK limit is
     ;;about 8192 Hz. Oplot a line representing this limitation.
     Lplot = [2,3,4,5,6,7]
     ;;Bvals from standard dipole field
     Bvals = [3750,1111,470,240,140,87]
     fce = 28.*Bvals
     maxf = 8192./fce
     
     oplot,maxf,Lplot,thick=4

  endif



;--------------------------------------------------
;plot the counts
;--------------------------------------------------

  if plot_linecounts then begin
     plot,grid_yaxis_center,counts2[*,0],xtitle=type,ytitle='counts',$
          ystyle=1,xstyle=1,position=[0.65,0.1,0.9,0.7],yrange=[mincolor_cnt,maxcolor_cnt]
  endif else begin

     contour,transpose(bs_cnt),f_fce_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
             xrange=xrange,title='counts',yrange=yrange,ytitle=ytitle,xtitle='f/fce',$
             ystyle=1,xstyle=1,position=[0.65,0.1,0.9,0.7],$
             xtickname=['0.0','0.2','0.4','0.6','0.8','1.0','10']



     ;; fill in the cells
     for h=0,nyaxis-1 do begin
        for j=0,nf_fce-2 do begin
           xtmp0 = f_fce[j]
           xtmp1 = f_fce[j+1]
           xtmp2 = xtmp1
           xtmp3 = xtmp0
           xtmp4 = xtmp0

           
           ytmp0 = grid_yaxis[h]
           ytmp1 = ytmp0
           ytmp2 = grid_yaxis[h+1]
           ytmp3 = ytmp2
           ytmp4 = ytmp0

           if xtmp0 ge min(xrange) and $
              xtmp1 le max(xrange) and $
              ytmp0 ge min(yrange) and $
              ytmp2 le max(yrange) then polyfill,[xtmp0,xtmp1,xtmp2,xtmp3,xtmp4],$
                                                 [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4],color=bs_cnt[h,j]
           
        endfor
     endfor

     for q=0,nyaxis do oplot,[0,10],[grid_yaxis[q],grid_yaxis[q]]
     for q=0,nf_fce-1 do oplot,[f_fce[q],f_fce[q]],[0,1000]
     oplot,[0.1,0.1],[0,1000],thick=4
     oplot,[0.5,0.5],[0,1000],thick=4
     oplot,[1,1],[0,1000],thick=4




     ;; ticknames for the peak values
     tn = (maxcolor_cnt-mincolor_cnt)*indgen(nvformatright)/(nvformatright-1) + mincolor_cnt
     tn = string(tn,format=formatright)

     colorbar,ticknames=tn,divisions=nvformatright-1,position=[.65,.85,.9,.87],title='counts'

  endelse









  
  if keyword_set(ps) then pclose

end


