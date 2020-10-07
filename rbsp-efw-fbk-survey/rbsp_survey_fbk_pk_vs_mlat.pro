;; Plot of filterbank values vs magnetic latitude

;; mlts = [mlt1,mlt2] limit to these magnetic local times


pro rbsp_survey_fbk_pk_vs_mlat,info,mlts=mlts,text=text,title=tt


  if ~keyword_set(mlts) then mlts = [0.,24.]

  rbspx = 'rbsp' + info.probe
  
  get_data,rbspx+'_fbk_pk',data=pk
  get_data,rbspx+'_fbk_av',data=av
  get_data,rbspx+'_mlat',data=mlat
  get_data,rbspx+'_mlt_ect',data=mlt
  get_data,rbspx+'_npk_percent',data=npk


  bad = where((mlt.y lt mlts[0]) or (mlt.y gt mlts[1]))

  if bad[0] ne -1 then pk.y[bad] = !values.f_nan
  if bad[0] ne -1 then av.y[bad] = !values.f_nan
  if bad[0] ne -1 then npk.y[bad] = !values.f_nan
  if bad[0] ne -1 then mlat.y[bad] = !values.f_nan



  if keyword_set(ps) then popen,'~/Desktop/latdist_' + info.fbk_type + '.ps'
  if keyword_set(ps) then !p.charsize = 0.8

  fmin = strtrim(string(info.minfreq,format='(f4.2)'),2)
  fmax = strtrim(string(info.maxfreq,format='(f4.2)'),2)

  mlts0 = strtrim(string(floor(mlts[0])),2)
  mlts1 = strtrim(string(floor(mlts[1])),2)


  title = 'Latitude distribution '
  if info.fbk_type eq 'Ew' then title += '(mV/m)' else title += '(nT)'
  title += '!Cf/fce_eq from '+fmin+' to '+fmax
  title2 = info.d0 + ' to ' + info.d1 + ' RBSP-' + strupcase(info.probe) +$
           '!CMLTs from ' +mlts0 + ' to ' + mlts1 + ' hrs'
  if keyword_set(tt) then title3 = tt else title3 = ''

  !x.margin = [18.,14.]
  !y.margin = [4,6]

  xt = 'Magnetic latitude (deg)'
  yt = 'Peak value'
  yt2 = 'Avg value'
  yt3 = 'Peak %occurrence'

  !p.multi = [0,0,2]
  plot,mlat.y,pk.y,title=title,xtitle=xt,ytitle=yt,xrange=[-25,25]
;	plot,mlat.y,av.y,title=title2,xtitle=xt2,ytitle=yt2,xrange=[-25,25]
  plot,mlat.y,npk.y,title=title3,xtitle=xt,ytitle=yt3,xrange=[-25,25]
;	plot,mlat.y,nav.y,title=title2,xtitle=xt2,ytitle=yt,xrange=[-25,25]

  
  if keyword_set(ps) then pclose

end
