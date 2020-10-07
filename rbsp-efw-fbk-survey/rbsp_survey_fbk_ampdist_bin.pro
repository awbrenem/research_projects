;; Return total counts as a function of amplitude for a range of Lshell and MLT

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

pro rbsp_survey_fbk_ampdist_bin,info,mltr,lshellr,ps=ps,type=type,yr=yr,yrlog=yrlog,text=text,title=tt

  if ~keyword_set(type) then type = 'pk'

  get_data,'rbsp' + info.probe + '_mlt',data=mlt
  get_data,'rbsp' + info.probe + '_lshell',data=lshell

  get_data,'rbsp'+info.probe+'_amp_ampdist_'+type+'_counts',data=ac


;; get the bins of wave amplitude
  if strmid(type,0,2) eq 'pk' then amp_bins = info.amp_bins_pk
  if strmid(type,0,3) eq 'avg' then amp_bins = info.amp_bins_avg
  if strmid(type,0,5) eq 'avg4s' then amp_bins = info.amp_bins_avg4s
  if strmid(type,0,2) eq 'ratio' then amp_bins = info.amp_bins_ratio
  if strmid(type,0,7) eq 'ratio4s' then amp_bins = info.amp_bins_ratio4s
  


  ;; Remove negative values
  goo = where(ac.y lt 0.)
  if goo[0] ne -1 then ac.y[goo] = 0.


  goo = where((mlt.y ge mltr[0]) and (mlt.y le mltr[1]) and $
              (lshell.y ge lshellr[0]) and (lshell.y le lshellr[1]))


  ac2 = ac.y[goo,*]

  store_data,'ac2',data={x:ac.x[goo],y:ac2,v:ac.v}
;	tplot,['rbsp'+info.probe+'_amp_counts','ac2','rbsp'+info.probe+'_mlt','rbsp'+info.probe+'_lshell']



  ;; Add up the totals in each amplitude bin
  actots = fltarr(n_elements(ac2[0,*]))
  for i=0,n_elements(ac2[0,*])-1 do actots[i] = total(ac2[*,i],/nan)


  maxc = strtrim(floor(info.dt*8.),2)
  ndts = strtrim(floor(n_elements(info.timesb)),2)

  yrange = [1,max(actots,/nan)]
  if info.fbk_type eq 'Ew' then xt = 'Amplitude (mV/m)'
  if info.fbk_type eq 'Bw' then xt = 'Amplitude (nT)'


  if keyword_set(ps) then popen,'~/Desktop/ampdist_' + type + '.ps'

  goo = strpos(type,'0')
  if goo[0] ne -1 then fmin = strmid(type,goo,1) + '.' + strmid(type,goo+1,1)
  if goo[0] ne -1 then fmax = strmid(type,goo+2,1) + '.' + strmid(type,goo+3,1)
  if goo[0] eq -1 then fmin = '0.1-'
  if goo[0] eq -1 then fmax = '1.0-'

  title = 'Amplitude distribution ' + type 
  if info.fbk_type eq 'Ew' then title += '(mV/m)' else title += '(nT)'
  title += '!Cf/fce_eq from '+fmin+' to '+fmax


;; counts total = number of FBK "chorus" samples used in histogram
;; determination. Number of seconds = (counts_total)/8
;; maxc = 8 (Samples/sec) * dt (sec) -> max number of FBK ticks in a
;;      chunk of size dt (usually 60s) 
;; ndts = number of dt chunks per day (=86400/dt)

  title += '!C' + strtrim(floor(total(actots)),2) + ' counts total!CMax of '+maxc + $
           ' counts per dt!C' + strtrim(floor(info.ndays*ndts),2) + ' dts in timerange'


  title2 = info.d0 + ' to ' + info.d1 + ' RBSP-' + strupcase(info.probe)


  !x.margin = [18.,14.]
  !y.margin = [4,6]


  if ~keyword_set(yr) then yr=[0,max(actots)]
  if ~keyword_set(yrlog) then yrlog=[1,max(actots)]
  

  !p.multi = [0,0,4]

  ;; plot full versions with count levels
  plot,amp_bins,actots,/xlog,xrange=[0.01,1000],yrange=yr,ytitle='Counts',xtitle=xt,title=title
  plot,amp_bins,actots,/xlog,xrange=[0.01,1000],yrange=yrlog,/ylog,ytitle='Counts',xtitle=xt,title=title2

  ;; plot versions normalized to max counts
  plot,amp_bins,actots/max(actots,/nan),/xlog,xrange=[0.01,1000],yrange=[0,1],$
       ytitle='Normalized!Ccounts',xtitle=xt,title=tt
  plot,amp_bins,actots/max(actots,/nan),/xlog,xrange=[0.01,1000],yrange=[1d-8,1],$
       /ylog,ytitle='Normalized!Ccounts',xtitle=xt

  
  if keyword_set(ps) then pclose

end

