;; Creates rectangular plots of f_fce vs Lshell or f_fce vs MLT with the color being the %occ
;; Called from rbsp_survey_fbk_crib.pro



pro rbsp_survey_f_fce_peak_plots,$
   info,$
   values,$
   counts,$
   type=type,$                  ;'mlt' or 'lshell'
   minc_vals=mincolor_vals,$
   maxc_vals=maxcolor_vals,$
   minc_cnt=mincolor_cnt,$
   maxc_cnt=maxcolor_cnt,$
   text = text_vals,$
   title = title,$
   cbtitle = cbtitle,$
   ps=ps,$
   formatleft=formatleft,$
   formatright=formatright,$
   nvformatleft=nvformatleft,$
   nvformatright=nvformatright,$
   yrange=yrange,$
   xrange=xrange


  rbsp_efw_init


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



  if info.fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'

  
  ;;Find the %-time in each sector for d0 to d1 (uses
  ;;histogram). Note, I may be able to use the below program if
  ;;I define a single MLT sector
  rbsp_survey_fbk_percenttime_bin,info,'0001' ;,/combinesc
  bins0001 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0001c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0102' ;,/combinesc
  bins0102 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0102c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0203' ;,/combinesc
  bins0203 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0203c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0304' ;,/combinesc
  bins0304 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0304c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0405' ;,/combinesc
  bins0405 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0405c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0506' ;,/combinesc
  bins0506 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0506c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0607' ;,/combinesc
  bins0607 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0607c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0708' ;,/combinesc
  bins0708 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0708c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0809' ;,/combinesc
  bins0809 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0809c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'0910' ;,/combinesc
  bins0910 = reform(info.percentoccurrence_bin.percent_peaks)
  bins0910c = reform(info.percentoccurrence_bin.counts)
  rbsp_survey_fbk_percenttime_bin,info,'10100' ;,/combinesc
  bins10100 = reform(info.percentoccurrence_bin.percent_peaks)
  bins10100c = reform(info.percentoccurrence_bin.counts)


                                ;fce,L
  vals_plot = 100.*transpose([[bins0001],[bins0102],[bins0203],[bins0304],[bins0405],[bins0506],[bins0607],[bins0708],[bins0809],[bins0910],[bins10100]])
  counts = transpose([[bins0001c],[bins0102c],[bins0203c],[bins0304c],[bins0405c],[bins0506c],[bins0607c],[bins0708c],[bins0809c],[bins0910c],[bins10100c]])

  if ~keyword_set(maxcolor_cnt) then maxcolor_cnt = max(counts)+1

  nf_fce = 12
  f_fce = 0.1*indgen(nf_fce)
  f_fce_center = f_fce + (f_fce[1]-f_fce[0])
  f_fce_center = f_fce_center[0:n_elements(f_fce_center)-2]

  f_fce[n_elements(f_fce)-1] = 1.3
  f_fce_center[n_elements(f_fce)-2] = 1.3


;; ----------------------------
;; Define colors
;; ----------------------------

  ;; --data values
  bs_vals = BYTSCL(vals_plot,min=mincolor_vals,max=maxcolor_vals)
  ;; The last colorbar value is white. To avoid having the largest values be white
  ;; let's change to a value of 254 which is red
  boo = where(bs_vals eq 255)
  if boo[0] ne -1 then bs_vals[boo] = 254

  ;; Change zero-counts to white
  goo = where(bs_vals eq 0)
  if goo[0] ne -1 then bs_vals[goo] = 255
  
  
  ;; --counts
  bs_cnt = BYTSCL(counts,min=mincolor_cnt,max=maxcolor_cnt)
  boo = where(bs_cnt eq 255)
  if boo[0] ne -1 then bs_cnt[boo] = 254
  goo = where(bs_cnt eq 0)
  if goo[0] ne -1 then bs_cnt[goo] = 255 ;change zero-counts to white


  ;; REMOVE VALUES WHEN THE LSHELL-MLT BIN CONTAINS LESS THAN THE MINIMUM COUNTS
  goo = where(bs_cnt eq 255)
  if goo[0] ne -1 then bs_vals[goo] = 255


  

  
;; ---------------------------------------
;; Plot the data values
;; ---------------------------------------
  
  
  !p.multi = [0,2,0]
  if keyword_set(ps) then !p.charsize = 0.8 else !p.charsize = 1.5


  d0t = strmid(info.d0,0,4)+strmid(info.d0,5,2)+strmid(info.d0,8,2)
  d1t = strmid(info.d1,0,4)+strmid(info.d1,5,2)+strmid(info.d1,8,2)
  if info.maxamp_pk ge 1000 then maxamp = 'inf' else $
     maxamp = strtrim(string(info.maxamp_pk,format='(f6.1)'),2)
  
  text_title = 'fbk_%occ_RBSP'+info.probe+'_dt='+$
               string(info.dt,format='(i2)')+'s_'+d0t+'-'+d1t + '_(' + $
               strtrim(string(info.minamp_pk,format='(f5.1)'),2)+'<'+units+'<'+maxamp+')_('+ $
               strtrim(string(info.mlatL,format='(I2)'),2)+'<mlat<'+$
               strtrim(string(info.mlatH,format='(I2)'),2)+')_(' + $
               strtrim(string(info.aeL,format='(I5)'),2)+'<AE<'+$
               strtrim(string(info.aeH,format='(I5)'),2)+')_(' + $
               strtrim(string(info.dstL,format='(I6)'),2)+'<DST<'+$
               strtrim(string(info.dstH,format='(I6)'),2)+').ps'



  if keyword_set(ps) then popen,'~/Desktop/'+text_title,/landscape




  ;;Plot the results
  contour,bs_vals,f_fce_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
          xrange=xrange,yrange=yrange,title=title,ytitle=ytitle,xtitle='f/fce_eq',$
          ystyle=1,xstyle=1,position=[0.1,0.1,0.4,0.7],$
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

        if xtmp0 lt 1.3 then polyfill,[xtmp0,xtmp1,xtmp2,xtmp3,xtmp4],$
                                      [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4],color=bs_vals[j,h]
        
     endfor
  endfor

  for q=0,nyaxis do oplot,[0,10],[grid_yaxis[q],grid_yaxis[q]]
  for q=0,nf_fce-1 do oplot,[f_fce[q],f_fce[q]],[0,1000]
  oplot,[0.1,0.1],[0,1000],thick=3
  oplot,[0.5,0.5],[0,1000],thick=3
  oplot,[1,1],[0,1000],thick=3
  



  ;; ticknames for the peak values
  tn = maxcolor_vals*indgen(nvformatleft)/(nvformatleft-1)
  tn = string(tn,format=formatleft)

  colorbar,ticknames=tn,divisions=nvformatleft-1,position=[.05,.85,.35,.87],title=cbtitle


  ;;Because the instrument samples at 16384 S/s, the FBK limit is
  ;;about 8192 Hz. Oplot a line representing this limitation.
  Lplot = [2,3,4,5,6,7]

stop
  if type eq 'lshell' then begin
     ;;Bvals from standard dipole field
     Bvals = [3750,1111,470,240,140,87]
     fce = 28.*Bvals
     maxf = 8192./fce
     
     oplot,maxf,Lplot,thick=3
  endif


;--------------------------------------------------
;plot the counts
;--------------------------------------------------

  plot,grid_yaxis_center,counts[0,*],xtitle=type,ytitle='counts',$
       ystyle=1,xstyle=1,position=[0.6,0.1,0.9,0.7]


  ;; contour,bs_cnt,f_fce_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
  ;;         xrange=xrange,title='counts',yrange=yrange,ytitle=ytitle,xtitle='f/fce',$
  ;;         ystyle=1,xstyle=1,position=[0.6,0.1,0.9,0.7],$
  ;;         xtickname=['0.0','0.2','0.4','0.6','0.8','1.0','10']



  ;; ;; fill in the cells
  ;; for h=0,nyaxis-1 do begin
  ;;    for j=0,nf_fce-2 do begin
  ;;       xtmp0 = f_fce[j]
  ;;       xtmp1 = f_fce[j+1]
  ;;       xtmp2 = xtmp1
  ;;       xtmp3 = xtmp0
  ;;       xtmp4 = xtmp0

        
  ;;       ytmp0 = grid_yaxis[h]
  ;;       ytmp1 = ytmp0
  ;;       ytmp2 = grid_yaxis[h+1]
  ;;       ytmp3 = ytmp2
  ;;       ytmp4 = ytmp0

  ;;       polyfill,[xtmp0,xtmp1,xtmp2,xtmp3,xtmp4],$
  ;;                [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4],color=bs_cnt[j,h]
        
  ;;    endfor
  ;; endfor

  ;; for q=0,nyaxis do oplot,[0,10],[grid_yaxis[q],grid_yaxis[q]]
  ;; for q=0,nf_fce-1 do oplot,[f_fce[q],f_fce[q]],[0,1000]
  ;; oplot,[0.1,0.1],[0,1000],thick=3
  ;; oplot,[0.5,0.5],[0,1000],thick=3
  ;; oplot,[1,1],[0,1000],thick=3




  ;; ;; ticknames for the peak values
  ;; tn = maxcolor_cnt*indgen(nvformatright)/(nvformatright-1)
  ;; tn = string(tn,format=formatright)

  ;; colorbar,ticknames=tn,divisions=nvformatright-1,position=[.55,.85,.85,.87],title='counts'






  
  if keyword_set(ps) then pclose

end


