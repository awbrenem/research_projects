;; Plots a 2d contour histogram of counts (z-axis) vs amplitude
;; (y-axis) and f/fce (x-axis) 
;; for a range of Lshell and MLT



;; mltr -> MLT range (low to high)
;; lshellr -> Lshell range
;; type -> set to select which type of ampdist file to read. Options are:
;; 			'avg'
;; 			'avg4s'
;; 			'ratio'
;; 			'ratio4s'
;; Defaults to read the peak values

;; yr -> [y0,y1] linear yrange
;; yrlog -> [y0,y1] log yrange

pro rbsp_survey_fbk_ampfreq_2dhist_bin,$
   info,mltr,lshellr,$
   type=type,$
   minc_vals=mincolor_vals,$
   maxc_vals=maxcolor_vals,$
   minc_cnt=mincolor_cnt,$
   maxc_cnt=maxcolor_cnt,$
   text = text_vals,$
   title = title2,$
   cbtitle = cbtitle,$
   ps=ps,$
   formatleft=formatleft,$
   formatright=formatright,$
   nvformatleft=nvformatleft,$
   nvformatright=nvformatright,$
   yrange=yrange,$
   xrange=xrange,$

   
   rbsp_efw_init
  

  
  if ~keyword_set(plot_linecounts) then plot_linecounts = 0
  if ~keyword_set(yrange) then yrange = [1,1000.]
  if ~keyword_set(xrange) then xrange=[0,1.3]
  if ~keyword_set(nvformatleft) then nvformatleft = 5
  if ~keyword_set(nvformatright) then nvformatright = 5
  if ~keyword_set(formatleft) then formatleft = '(F4.1)'
  if ~keyword_set(formatright) then formatright = '(F6.1)'
  if ~keyword_set(mincolor_vals) then mincolor_vals = 0.1
  if ~keyword_set(maxcolor_vals) then maxcolor_vals = 150
  if ~keyword_set(mincolor_cnt) then mincolor_cnt = 50
  ;; if ~keyword_set(maxcolor_cnt) then mincolor_cnt = 10000


  if ~keyword_set(text_vals) then begin
     if info.combined_sc eq 0 then text_vals = 'Sector values ('+strtrim(floor(info.dt),2)+$
                                               ' sec chunks)!Cfor!C'+'RBSP-'+strupcase(info.probe) + $
                                               '!C'+info.D0+' to '+info.D1+'!C'
     if info.combined_sc eq 1 then text_vals = 'Sector values ('+strtrim(floor(info.dt),2)+$
                                               ' sec chunks)!Cfor!C'+'both sc' + $
                                               '!C'+info.D0+' to '+info.D1+'!C'
  endif
  if ~keyword_set(title2) then title2 = '%occ'
  if ~keyword_set(cbtitle) then cbtitle = ''




  if ~keyword_set(type) then type = 'pk'


  get_data,'rbsp' + info.probe + '_mlt',data=mlt
  get_data,'rbsp' + info.probe + '_lshell',data=lshell


  ;;Get the freq-separated amplitude histograms
  if type eq 'pk' then begin
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk00100_counts',data=ac
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0001_counts',data=ac1
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0102_counts',data=ac2
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0203_counts',data=ac3
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0304_counts',data=ac4
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0405_counts',data=ac5
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0506_counts',data=ac6
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0607_counts',data=ac7
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0708_counts',data=ac8
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0809_counts',data=ac9
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk0910_counts',data=ac10
     get_data,'rbsp' + info.probe + '_amp_ampdist_pk10100_counts',data=ac11
  endif


  ;; tplot,'rbsp' + info.probe + '_amp_ampdist_pk????_counts'

;; get the bins of wave amplitude
  if type eq 'pk' then amp_bins = info.amp_bins_pk

  
;; freq bins (f/fce)
  freqmin = [0,indgen(9)*0.1 + 0.1]
  freqmax = [1,indgen(9)*0.1 + 0.2]


  ;; Remove negative values
  goo = where(ac.y lt 0.)
  if goo[0] ne -1 then ac.y[goo] = 0.


  goo = where((mlt.y ge mltr[0]) and (mlt.y le mltr[1]) and $
              (lshell.y ge lshellr[0]) and (lshell.y le lshellr[1]))



  ;;Create the ahvals array [ntimes,n_ampbins,n_freqs]
  ahvals = ac.y[goo,*]
  ahvals = replicate(0,n_elements(ahvals[*,0]),n_elements(ahvals[0,*]),11)


  ahvals[*,*,0] = ac1.y[goo,*]
  ahvals[*,*,1] = ac2.y[goo,*]
  ahvals[*,*,2] = ac3.y[goo,*]
  ahvals[*,*,3] = ac4.y[goo,*]
  ahvals[*,*,4] = ac5.y[goo,*]
  ahvals[*,*,5] = ac6.y[goo,*]
  ahvals[*,*,6] = ac7.y[goo,*]
  ahvals[*,*,7] = ac8.y[goo,*]
  ahvals[*,*,8] = ac9.y[goo,*]
  ahvals[*,*,9] = ac10.y[goo,*]
  ahvals[*,*,10] = ac11.y[goo,*]


  store_data,'ahvals_0',data={x:ac.x[goo],y:ahvals[*,*,0],v:ac.v}
  store_data,'ahvals_1',data={x:ac.x[goo],y:ahvals[*,*,1],v:ac.v}
  store_data,'ahvals_2',data={x:ac.x[goo],y:ahvals[*,*,2],v:ac.v}
  store_data,'ahvals_3',data={x:ac.x[goo],y:ahvals[*,*,3],v:ac.v}
  store_data,'ahvals_4',data={x:ac.x[goo],y:ahvals[*,*,4],v:ac.v}
  store_data,'ahvals_5',data={x:ac.x[goo],y:ahvals[*,*,5],v:ac.v}
  store_data,'ahvals_6',data={x:ac.x[goo],y:ahvals[*,*,6],v:ac.v}
  store_data,'ahvals_7',data={x:ac.x[goo],y:ahvals[*,*,7],v:ac.v}
  store_data,'ahvals_8',data={x:ac.x[goo],y:ahvals[*,*,8],v:ac.v}
  store_data,'ahvals_9',data={x:ac.x[goo],y:ahvals[*,*,9],v:ac.v}
  store_data,'ahvals_10',data={x:ac.x[goo],y:ahvals[*,*,10],v:ac.v}
;	tplot,['rbsp'+info.probe+'_amp_counts','ahvals','rbsp'+info.probe+'_mlt','rbsp'+info.probe+'_lshell']

  fbins = indgen(11)*0.1
  abins = info.amp_bins_pk

  nf_fce = n_elements(fbins)


  ;; Add up the totals in each amplitude and freq bin for all times
  actots = fltarr(n_elements(ahvals[0,*]),11)
  for j=0,n_elements(fbins)-1 do for i=0,n_elements(abins)-1 do actots[i,j] = total(ahvals[*,i,j],/nan)

  ;; Add up the totals for waves in chorus range in each amplitude and freq bin for all times
  actots_chorus = fltarr(n_elements(ahvals[0,*]),9)
  for j=2,n_elements(fbins)-1 do for i=0,n_elements(abins)-1 do actots_chorus[i,j-2] = total(ahvals[*,i,j],/nan)


  maxc = strtrim(floor(info.dt*8.),2)
  ndts = strtrim(floor(n_elements(info.timesb)),2)

  ;; yrange = [1,max(actots,/nan)]
  if info.fbk_type eq 'Ew' then xt = 'Amplitude (mV/m)'
  if info.fbk_type eq 'Bw' then xt = 'Amplitude (nT)'



  ;;ACTOTS          FLOAT     = Array[25, 11]
  ;;...array with all the amplitude histograms for each frequency


  bs_vals = BYTSCL(actots,min=mincolor_vals,max=maxcolor_vals,/nan)


  boo = where(bs_vals eq 255)
  if boo[0] ne -1 then bs_vals[boo] = 254
  goo = where(bs_vals eq 0)
  if goo[0] ne -1 then bs_vals[goo] = 255 ;change zero-counts to white


  ;; REMOVE VALUES WHEN THE LSHELL-MLT BIN CONTAINS LESS THAN THE MINIMUM COUNTS
  goo = where(bs_vals eq 255)
  if goo[0] ne -1 then bs_vals[goo] = 255





  if ~keyword_set(ps) then !p.charsize = 1.5 else !p.charsize = 1.0
  if keyword_set(ps) then popen,'~/Desktop/ampdist_' + type + '.ps',/landscape



;; counts total = number of FBK "chorus" samples used in histogram
;; determination. Number of seconds = (counts_total)/8
;; maxc = 8 (Samples/sec) * dt (sec) -> max number of FBK ticks in a
;;      chunk of size dt (usually 60s) 
;; ndts = number of dt chunks per day (=86400/dt)

  total_overall = strtrim(floor(total(actots)),2)
  total_chorus = strtrim(floor(total(actots_chorus)),2)


  title = 'Amp/freq histogram for FBK' + type 
  title += '!C'+total_overall+' total values!C'+$
           total_chorus+' total chorus values!C'+'Max of '+maxc + $
           'counts per dt=' + string(info.dt,format='(I4)')+$
           ' sec!C'+strtrim(floor(info.ndays*ndts),2) + ' chunks of size dt in timerange !C'
  title += info.d0 + ' to ' + info.d1 + ' RBSP-' + strupcase(info.probe)+'!C'
  title += title2
  title += '!C'




  !x.margin = [18.,14.]
  !y.margin = [4,6]

  ytitle = 'Amplitude '
  if info.fbk_type eq 'Ew' then ytitle += '(mV/m)' else ytitle += '(nT)'




  !p.multi = [0,0,5]
  contour,transpose(actots),fbins,abins,/cell_fill,$
          nlevels=20,yrange=yrange,/ylog,xrange=xrange,/nodata,$
          xtitle='f/fce',ytitle=ytitle,$
          title=title,$
          position=[0.1,0.1,0.4,0.7],$
          xstyle=5,ystyle=5


  fbins2 = [fbins,1.3]
  abins2 = [abins,1000.]
  for f=0,n_elements(fbins)-1 do for a=0,n_elements(abins)-1 do begin
     if fbins2[f] ge xrange[0] and $
        fbins2[f+1] le xrange[1] and $
        abins2[a] ge yrange[0] and $
        abins2[a+1] le yrange[1] then $
           polyfill,[fbins2[f],fbins2[f],fbins2[f+1],fbins2[f+1]],$
                    [abins2[a],abins2[a+1],abins2[a+1],abins2[a]],$
                    color=bs_vals[a,f]   
  endfor

  
  for i=0,n_elements(fbins)-1 do oplot,[fbins[i],fbins[i]],[yrange[0],yrange[1]]
  for i=0,n_elements(fbins)-1 do oplot,[1.3,1.3],[yrange[0],yrange[1]]
  for i=0,n_elements(abins)-1 do oplot,[xrange[0],xrange[1]],[abins[i],abins[i]]     


  oplot,[0.1,0.1],[0.001,1000],thick=3
  oplot,[0.5,0.5],[0.001,1000],thick=3
  oplot,[1,1],[0.001,1000],thick=3
  

  axis,xaxis=0,xtickname=['0.0','0.2','0.4','0.6','0.8','1.0','10'],xstyle=1,xtitle='f/fce_eq'
  axis,xaxis=1,xstyle=1,xtickname=['0.0','0.2','0.4','0.6','0.8','1.0','10']
  axis,yaxis=0,ystyle=1,ytitle=ytitle
  axis,yaxis=1,ystyle=8

  
  ;; ticknames for the peak values
  tn = (maxcolor_vals-mincolor_vals)*indgen(nvformatleft)/(nvformatleft-1) + mincolor_vals
  tn = string(tn,format=formatleft)

  colorbar,ticknames=tn,divisions=nvformatleft-1,position=[.1,.94,.4,.96],title=cbtitle


;;--------------------------------------------------
;;Make the line plots for each f_fce range
;;--------------------------------------------------


  if ~keyword_set(yr) then yr=[0,max(actots)]
  if ~keyword_set(yrlog) then yrlog=[1,max(actots)]


  ;; plot full versions (chorus only) with count levels
  plot,amp_bins,actots[*,0],$
       /xlog,xrange=[1,200],yrange=yr,ytitle='Counts',$
       xtitle=xt,/nodata,$
       position=[0.6,0.75,0.9,0.9]  
  for f=1,nf_fce-2 do oplot,amp_bins,actots[*,f],color=f*2.4*10.

  plot,amp_bins,actots[*,0],$
       /xlog,xrange=[1,200],yrange=yrlog,/ylog,ytitle='Counts',$
       xtitle=xt,/nodata,$
       position=[0.6,0.55,0.9,0.7]  
  for f=1,nf_fce-2 do oplot,amp_bins,actots[*,f],color=f*2.4*10


  ;; plot versions normalized to max counts
  plot,amp_bins,actots[*,0]/max(actots[*,0],/nan),$
       /xlog,xrange=[1,200],yrange=[0,1],$
       ytitle='Normalized!Ccounts',xtitle=xt,title=tt,/nodata,$
       position=[0.6,0.35,0.9,0.5]  
  for f=1,nf_fce-2 do oplot,amp_bins,actots[*,f]/max(actots[*,f],/nan),color=f*2.4*10

  plot,amp_bins,actots[*,0]/max(actots[*,0],/nan),$
       /xlog,xrange=[1,200],yrange=[1d-8,1],$
       /ylog,ytitle='Normalized!Ccounts',xtitle=xt,/nodata,$
       position=[0.6,0.15,0.9,0.3]  
  for f=1,nf_fce-2 do oplot,amp_bins,actots[*,f]/max(actots[*,f],/nan),color=f*2.4*10.





  ;;plot the color key
  ylocs = (0.5-0.1)*reverse(indgen(11)*0.1)/2. + 0.5
  for f=1,nf_fce-2 do xyouts,/normal,0.5,ylocs[f],'f/fce='+string(fbins[f],format='(f3.1)')+'-'+string(fbins[f+1],format='(f3.1)'),color=f*2.4*10


  
  if keyword_set(ps) then pclose

end

