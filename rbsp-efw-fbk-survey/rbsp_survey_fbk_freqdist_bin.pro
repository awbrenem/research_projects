;; Return total counts as a function of frequency for a range of Lshell and MLT

;; mltr -> MLT range (low to high)
;; lshellr -> Lshell range

pro rbsp_survey_fbk_freqdist_bin,info,mltr,lshellr,ps=ps


  get_data,'rbsp' + info.probe + '_mlt',data=mlt
  get_data,'rbsp' + info.probe + '_lshell',data=lshell
  get_data,'rbsp' + info.probe + '_amp_freq_counts',data=ac

  ;; Remove negative values
  goo = where(ac.y lt 0.)
  if goo[0] ne -1 then ac.y[goo] = 0.


  goo = where((mlt.y ge mltr[0]) and (mlt.y le mltr[1]) and $
              (lshell.y ge lshellr[0]) and (lshell.y le lshellr[1]))


  ac2 = ac.y[goo,*]

  store_data,'ac2',data={x:ac.x[goo],y:ac2,v:ac.v}
  tplot,['rbsp'+info.probe+'_freq_counts','ac2','rbsp'+info.probe+'_mlt','rbsp'+info.probe+'_lshell']



  ;; Add up the totals in each amplitude bin
  actots = fltarr(n_elements(ac2[0,*]))
  for i=0,n_elements(ac2[0,*])-1 do actots[i] = total(ac2[*,i],/nan)


  yrange = [1,max(actots,/nan)]
  xt = 'Frequency (f/fce_eq)'
  

  if keyword_set(ps) then popen,'~/Desktop/freqdist.ps'


  amin = strtrim(floor(info.minamp_pk),2)
  amax = strtrim(floor(info.maxamp_pk),2)

  if info.maxamp_pk gt 1000. then amax = 'inf'

  title = 'Frequency distribution for !CAmps from '+amin+' to '+amax
  if info.fbk_type eq 'Ew' then title += ' mV/m' else title += ' nT'


  !x.margin = [18.,14.]
  !y.margin = [4,6]


  !p.multi = [0,0,2]
  plot,info.freq_bins,actots/max(actots,/nan),xrange=[0,1],yrange=[0,1],$
       ytitle='Normalized!Ccounts',xtitle=xt,$
       title=title
  plot,info.freq_bins,actots/max(actots,/nan),xrange=[0,1],yrange=[1d-8,1],$
       /ylog,ytitle='Normalized!Ccounts',xtitle=xt,$
       title=title
  

  if keyword_set(ps) then pclose


end

