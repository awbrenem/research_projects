;; Creates contour plots of some xaxis quantity (like DST or AE) vs Lshell or MLT with
;; separate plots the z-axis color being the %occ or peak value
;; Called from rbsp_survey_fbk_percenttime_crib.pro


pro rbsp_survey_contour_plots_allamps,$
   info,$
   fstr=fstr,$
   yaxis=yaxis,$
   xaxis=xaxis,$
   nbins=nbins,$
   xmin=xmin,$
   xmax=xmax,$
   type=type,$
   minc_vals=mincolor_vals,$
   maxc_vals=maxcolor_vals,$
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
   lineplots=lineplots


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
  if ~keyword_set(mincolor_peaks) then mincolor_peaks = 2
  if ~keyword_set(maxcolor_peaks) then maxcolor_peaks = 100
  if ~keyword_set(mincolor_cnt) then mincolor_cnt = 50
  if ~keyword_set(nbins) then nbins=15
  if ~keyword_set(xmin) then xmin=0
  if ~keyword_set(xmax) then xmax=100

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



  if yaxis eq 'rbsp'+info.probe+'_lshell' then begin
     nyaxis = info.grid.nshells
     grid_yaxis_center = info.grid.grid_lshell_center
     grid_yaxis = info.grid.grid_lshell
     ytitle='Lshell'
  endif

  if yaxis eq 'rbsp'+info.probe+'_mlt' then begin
     nyaxis = info.grid.nthetas
     grid_yaxis_center = info.grid.grid_theta_center
     grid_yaxis = info.grid.grid_theta
     ytitle='MLT'
  endif

  if ~keyword_set(maxcolor_cnt) then maxcolor_cnt = max(counts)+1

  if info.fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'

  


  ;;--------------------------------------------------
  ;;Histogram the x-axis values
  ;;--------------------------------------------------

  get_data,xaxis,data=xvals

;;histogram the xvalues (e.g. DST) into chunks of size "xdt"
  ;; xdt = (xmax-xmin)/(nbins-1)
  nsamples = HISTOGRAM(xvals.y,reverse_indices=ri,nbins=nbins,min=xmin,max=xmax,locations=loc) 

  loc_center = (loc + shift(loc,1))/2.
  loc_center = loc_center[1:n_elements(loc)-1]

  ;; ;;***actual values
  ;; for b=0,nbins-1 do if ri[b] ne ri[b+1] then print,xvals.y[ri[ri[b] : ri[b+1]-1]]  
  ;; for b=0,nbins-1 do if ri[b] ne ri[b+1] then print,[ri[ri[b] : ri[b+1]-1]]  


  ;;--------------------------------------------------



  get_data,'rbsp'+info.probe+'_amp_ampdist_pk'+fstr+'_counts',data=amppk


;; ;*****testing


;; ;;107      1.98112     
;; ;;108      2.79840      
;; ;; 3.95285      
;; ;; 5.58355      
;; ;; 7.88697      
;; ;;112      11.1406
;; ;; 15.7366      
;; ;; 22.2285      
;; ;; 31.3986      
;; ;; 44.3517      
;; ;; 62.6484      
;; ;; 88.4932      
;; ;; 125.000
;; ;; 176.567      
;; ;; 249.408      
;; ;; 352.298      
;; ;; 497.634

;;      per_amppk = amppk.y
;;      per_amppk[*] = 0.
;;      per_amppk = amppk.y * (1/8.)/info.dt

;;      store_data,rbspx+'_amppk_test_percent',data={x:amppk.x,y:per_amppk}


;; split_vec,rbspx+'_amppk_test_percent'

;; ;*****end testing


  ;; get_data,'rbsp'+info.probe+'_nfbk_pk'+fstr,data=npk
  ;; get_data,'rbsp'+info.probe+'_nfbk_av'+fstr,data=nav
  ;; get_data,'rbsp'+info.probe+'_fbk_pk'+fstr,data=pk
  ;; get_data,'rbsp'+info.probe+'_fbk_av'+fstr,data=av
  ;; get_data,rbspx+'_mlt',data=mlt
  ;; get_data,rbspx+'_lshell',data=lshell
  namps = n_elements(amppk.v)


  vals_plot = fltarr(info.grid.nshells,info.grid.nthetas,namps,nbins)
  counts = fltarr(info.grid.nshells,info.grid.nthetas,namps,nbins)


  ;;For each x-axis bin extract the appropriate pk, av values and
  ;;calculate the overall peak value and %occ
  for b=0,nbins-1 do begin
     if ri[b] ne ri[b+1] then whloc = [ri[ri[b] : ri[b+1]-1]] else whloc = -1

     if whloc[0] ne -1 then begin

        ;;data that falls within the "bth" histogram bin
        amppktmp = {x:amppk.x[whloc],y:reform(amppk.y[whloc,*]),v:amppk.v}


        ;;set up these tplot variables for the %occ program
        optstr = 'contour_tmp'
        store_data,'rbsp'+info.probe+'_amp_ampdist_pk'+optstr+'_counts',data=amppktmp



;;   tplot,['rbsp'+info.probe+'_amp_ampdist_pk'+fstr+'_counts','rbsp'+info.probe+'_amp_ampdist_pk'+optstr+'_counts',$
;;         'rbspa_amppkcontour_tmp_percent']
;; stop


        ;; ;;********************************
        ;; ;;Check the data filtering by DST
        ;; ;;********************************

        ;; ylim,'rbspa_dst',-50,50
        ;; tplot,['rbspa_amp_ampdist_pk0110_counts',$
        ;;       'rbspa_amp_ampdist_pkcontour_tmp_counts',$
        ;;       'rbspa_dst']

        ;; timebar,[loc[b]],/databar,varname='rbspa_dst'
        ;; timebar,[loc[b+1]],/databar,varname='rbspa_dst'

        ;; ;;**************************************************


        ;;find the %occ of these values for the "bth" range of
        ;;histogrammed values

        rbsp_survey_fbk_percenttime_bin_amphist,info,optstr


        vals_plot[*,*,*,b] = reform(info.percentoccurrence_ampbin.percent_amppeaks)
        counts[*,*,*,b] = reform(info.percentoccurrence_ampbin.counts)

     endif
  endfor

  ;;[nshells,nmlt,namps,nbins]
  vals_plot = 100.*vals_plot
;;Note: I'm not sure these are being normalized
;;properly. "nsamples" includes all DST values, and not just the ones
;;in question......maybe....


;;*******************
;;test values of vals_plot
;;*******************

;;DST values
;; RBSP_EFW> print,loc
;;         -150        -128        -106         -84         -62         -40         -18           4
;;           26          48


  ;; print,info.grid.grid_lshell
;; RBSP_EFW>   print,info.grid.grid_lshell
;;       2.00000      2.50000      3.00000      3.50000      4.00000      4.50000      5.00000
;;       5.50000      6.00000      6.50000      7.00000

  ;; print,info.grid.grid_theta
;;; RBSP_EFW>   print,info.grid.grid_theta
;;       0.00000      24.0000



;; print,amppk.v
;; RBSP_EFW> print,amppk.v
;;      0.125000     0.176567     0.249408     0.352298     0.497634     0.702927     0.992910
;;       1.40252      1.98112      2.79840      3.95285      5.58355      7.88697      11.1406
;;       15.7366      22.2285      31.3986      44.3517      62.6484      88.4932      125.000
;;       176.567      249.408      352.298      497.634


  ;; lshell = 4
  ;; dst = 4
  ;; for a=0,namps-2 do print,amppk.v[a],amppk.v[a+1],vals_plot[lshell,0,a,dst]



;;*******************



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


  if yaxis eq 'rbsp'+info.probe+'_mlt' then begin
     vals_plot2 = fltarr(info.grid.nthetas,namps,nbins-1)
     counts2 =    fltarr(info.grid.nthetas,namps,nbins-1)
     for a=0,namps-1 do begin
        for t=0,info.grid.nthetas-1 do begin
           for d=0,nbins-2 do vals_plot2[t,a,d] = total(vals_plot[*,t,a,d],/nan)/info.grid.nshells
           for d=0,nbins-2 do counts2[t,a,d] = total(counts[*,t,a,d],/nan)
        endfor
     endfor
  endif
  
  if yaxis eq 'rbsp'+info.probe+'_lshell' then begin
     vals_plot2 = fltarr(info.grid.nshells,namps,nbins-1)
     counts2 =    fltarr(info.grid.nshells,namps,nbins-1)
     for a=0,namps-1 do begin
        for l=0,info.grid.nshells-1 do begin
           for d=0,nbins-2 do vals_plot2[l,a,d] = total(vals_plot[l,*,a,d],/nan)/info.grid.nthetas
           for d=0,nbins-2 do counts2[l,a,d] = total(counts[l,*,a,d],/nan)
        endfor
     endfor     
  endif
  


;; ----------------------------
;; Define colors
;; ----------------------------

  ;; --data values
  bs_vals = BYTSCL(vals_plot2,min=mincolor_vals,max=maxcolor_vals)
  ;; The last colorbar value is white. To avoid having the largest values be white
  ;; let's change to a value of 254 which is red
  boo = where(bs_vals eq 255)
  if boo[0] ne -1 then bs_vals[boo] = 254


  ;; Change zero-counts to white
  goo = where(bs_vals eq 0)
  if goo[0] ne -1 then bs_vals[goo] = 255

  
  
  ;; --counts
  bs_cnt = BYTSCL(counts2,min=mincolor_cnt,max=maxcolor_cnt)


stop

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
  
  
  !p.multi = [0,3,0]
  !p.charsize = 1.5
  if keyword_set(ps) and ~keyword_set(lineplot) then !p.charsize = 1.8 else !p.charsize = 1.8
  if keyword_set(ps) and keyword_set(lineplot) then !p.charsize = 1.2 else !p.charsize = 1.2



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
  ;;               string(info.dt,format='(i2)')+'s_'+d0t+'-'+d1t + '_(' + $
  ;;               strtrim(string(info.minamp_pk,format='(f5.1)'),2)+'<'+units+'<'+maxamp+')_('+ $
  ;;               strtrim(string(info.mlatL,format='(I2)'),2)+'<mlat<'+$
  ;;               strtrim(string(info.mlatH,format='(I2)'),2)+')_(' + $
  ;;               strtrim(string(info.aeL,format='(I5)'),2)+'<AE<'+$
  ;;               strtrim(string(info.aeH,format='(I5)'),2)+')_(' + $
  ;;               strtrim(string(info.dstL,format='(I6)'),2)+'<DST<'+$
  ;;               strtrim(string(info.dstH,format='(I6)'),2)+').ps'


  text_title = 'perocc'
  text_titlep = 'peakv'


  if keyword_set(ps) then popen,'~/Desktop/'+text_title,/landscape




;;--------------------------------------------------
;;Line plots
;;--------------------------------------------------


  if keyword_set(lineplots) then begin
     !p.multi = [0,4,4]

     ny = n_elements(grid_yaxis)

     if ~keyword_set(yr) then yr=[0,max(vals_plot2,/nan)]
     if ~keyword_set(yrlog) then yrlog=[1,max(vals_plot2,/nan)]


                                ;define colors
     colors = indgen(ny-1)*3.15*10


     ;; plot full versions (chorus only) with count levels
     plot,loc_center,vals_plot2[0,*],$
          xrange=[xmin,xmax],yrange=yr,ytitle='%occ',$
          xtitle=xaxis,/nodata,ystyle=1 ;,$
;          position=[0.1,0.75,0.6,0.9]
     for f=0,ny-2 do oplot,loc_center,vals_plot2[f,*],color=colors[f]

     plot,loc_center,vals_plot2[0,*],$
          xrange=[xmin,xmax],yrange=yrlog,/ylog,ytitle='%occ',$
          xtitle=xaxis,/nodata,ystyle=1 ;,$
;          position=[0.1,0.55,0.6,0.7]  
     for f=0,ny-2 do oplot,loc_center,vals_plot2[f,*],color=colors[f]


     ;; plot versions normalized to max counts
     plot,loc_center,vals_plot2[0,*]/max(vals_plot2[0,*],/nan),$
          xrange=[xmin,xmax],yrange=[0,1],$
          ytitle='Normalized!C%occ',xtitle=xaxis,title=tt,/nodata,ystyle=1 ;,$
;          position=[0.1,0.35,0.6,0.5]  
     for f=0,ny-2 do oplot,loc_center,vals_plot2[f,*]/max(vals_plot2[f,*],/nan),color=colors[f]

     plot,loc_center,vals_plot2[0,*]/max(vals_plot2[0,*],/nan),$
          xrange=[xmin,xmax],yrange=[1d-3,1],$
          /ylog,ytitle='Normalized!C%occ',xtitle=xaxis,/nodata,ystyle=1 ;,$
;          position=[0.1,0.15,0.6,0.3]  
     for f=0,ny-2 do oplot,loc_center,vals_plot2[f,*]/max(vals_plot2[f,*],/nan),color=colors[f]





;--------------------------------------------------
     ;;plot the color key
     ylocs = (0.4-0.0)*reverse(indgen(ny)*0.15)/2. + 0.1
     for f=0,ny-2 do xyouts,/normal,0.7,ylocs[f],yaxis+'='+string(grid_yaxis[f],format='(f4.1)')+'-'+string(grid_yaxis[f+1],format='(f4.1)'),color=colors[f]

  endif else begin


;;--------------------------------------------------
;;contour plots
;;--------------------------------------------------
     
     amptitles = info.amp_bins_pk

     at0 = amptitles
     at = strarr(n_elements(at0))
     for uu=0,n_elements(at0)-2 do at[uu] = strtrim(string(at0[uu],format='(f7.2)'),2)+'-'+strtrim(string(at0[uu+1],format='(f7.2)'),2)



     !p.multi = [0,4,5]
;     !p.multi = [0,1,0]
     
     stop

     for a=5,24 do begin

        ;;Plot the results
        ;; contour,transpose(reform(bs_vals[*,a,*])),loc_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
        ;;         xrange=xrange,yrange=yrange,title='%occ!C'+title+'!C!C',ytitle=yaxis,xtitle=xaxis,$
        ;;         ystyle=5,xstyle=5 ;,position=[0.05,0.1,0.3,0.7]


        contour,transpose(reform(bs_vals[*,a,*])),loc_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
                xrange=xrange,yrange=yrange,title=at[a]+units+'!C!C',ytitle=yaxis,xtitle=xaxis,$
                ystyle=5,xstyle=5 ;,position=[0.1,0.1,0.9,0.8]



        ;; fill in the cells
        for h=0,nyaxis-1 do begin
           for j=0,nbins-2 do begin
              xtmp0 = loc[j]
              xtmp1 = loc[j+1]
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
                                                    [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4],color=bs_vals[h,a,j]
              
           endfor
        endfor


        for q=0,nyaxis do oplot,[-1d5,1d5],[grid_yaxis[q],grid_yaxis[q]]
        for q=0,nbins-1 do oplot,[loc[q],loc[q]],[-1d5,1d5]
        
        axis,xaxis=0,xstyle=1,xtitle=xaxis
        axis,xaxis=1,xstyle=1             
        axis,yaxis=0,ystyle=1,ytitle=yaxis
        axis,yaxis=1,ystyle=8


        ;; ticknames for the peak values
        tn = (maxcolor_vals-mincolor_vals)*indgen(nvformatleft)/(nvformatleft-1) + mincolor_vals
        tn = string(tn,format=formatleft)

        colorbar,ticknames=tn,divisions=nvformatleft-1,position=[.05,.95,.3,.97],title=cbtitle


     endfor

     ;; ;; ticknames for the peak values
     ;; tn = (maxcolor_vals-mincolor_vals)*indgen(nvformatleft)/(nvformatleft-1) + mincolor_vals
     ;; tn = string(tn,format=formatleft)

     ;; colorbar,ticknames=tn,divisions=nvformatleft-1,position=[.05,.85,.3,.87],title=cbtitle



     stop

     if keyword_set(ps) then pclose


;--------------------------------------------------
;plot the counts
;--------------------------------------------------

     if keyword_set(ps) then popen,'~/Desktop/contour_plots_allamps_counts.ps'

     !p.multi = [0,1,0]
     

     contour,transpose(reform(bs_cnt[*,0,*])),loc_center,grid_yaxis_center,/cell_fill,/nodata,nlevels=20,$
             xrange=xrange,title='counts!C!C',yrange=yrange,ytitle=yaxis,xtitle=xaxis,$
             ystyle=5,xstyle=5,position=[0.65,0.1,0.9,0.7]


     ;; fill in the cells
     for h=0,nyaxis-1 do begin
        for j=0,nbins-2 do begin
           xtmp0 = loc[j]
           xtmp1 = loc[j+1]
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
                                                 [ytmp0,ytmp1,ytmp2,ytmp3,ytmp4],color=bs_cnt[h,0,j]
           

        endfor
     endfor

     for q=0,nyaxis do oplot,[-1d5,1d5],[grid_yaxis[q],grid_yaxis[q]]
     for q=0,nbins-1 do oplot,[loc[q],loc[q]],[-1d5,1d5]


     axis,xaxis=0,xstyle=1,xtitle=xaxis
     axis,xaxis=1,xstyle=1             
     axis,yaxis=0,ystyle=1,ytitle=yaxis
     axis,yaxis=1,ystyle=8



     ;; ticknames for the peak values
     tn = (maxcolor_cnt-mincolor_cnt)*indgen(nvformatright)/(nvformatright-1) + mincolor_cnt
     tn = string(tn,format=formatright)

     colorbar,ticknames=tn,divisions=nvformatright-1,position=[.65,.85,.9,.87],title='counts'


  endelse

  
  if keyword_set(ps) then pclose

end


