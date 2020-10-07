;;First run survey daily to get these tplot variables

tplot,['rbspa_efw_64_spec0_C','rbspa_efw_64_spec0','fce','fce_2','fci',$
       'flh','rbspa_efw_64_spec4_C','rbspa_efw_64_spec4','fce','fce_2',$
       'fci','flh']


tplot,['rbspa_efw_64_spec0_C','rbspa_efw_64_spec4_C','rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5']



tbx = '2016-01-20/19:44:00'
tbx = '2016-01-20/19:44:03'
tbx = '2016-01-20/19:44:05'
tbx = '2016-01-20/19:44:06'

tbx = '2016-01-20/19:44:00'
tsuff = indgen(40)/5.

tbx = time_double(tbx)+tsuff


get_data,'rbspa_efw_64_spec0',data=dd
freqs = dd.v
bandw = freqs - shift(freqs,1)


fce_2 = 2052.   ;Hz

   !p.multi = [0,0,2]
      v = tsample('rbspa_efw_64_spec0',time_double(tbx[0]),times=t)
      ew_amp = sqrt(v*bandw)

      colors=indgen(n_elements(tsuff))*5

      plot,freqs,reform(ew_amp),yrange=[0,2],xrange=[0,4000],psym=-4,title='from jan20_chorus_microburst_freq_spectrum.pro',$
           ytitle='Spectral Ew [mV/m]!Cat!C'+tbx[i],xtitle='freq [Hz]',/nodata


   for i=0,n_elements(tsuff)-1 do begin  $
      v = tsample('rbspa_efw_64_spec0',time_double(tbx[i]),times=t)  & $
      ew_amp = sqrt(v*bandw)  & $
      oplot,freqs,reform(ew_amp),psym=-4,color=colors[i]





      oplot,[fce_2,fce_2],[0,1d6],thick=2





      plot,freqs,bw_amp,yrange=[0,5],xrange=[0,4000],psym=-4,ytitle='Spectral Bw [pT]!Cat!C'+tbx,xtitle='freq [Hz]'  & $
      oplot,[fce_2,fce_2],[0,1d6],thick=2





   !p.multi = [0,0,2]
   for i=0,n_elements(tsuff)-1 do begin  $
      v = tsample('rbspa_efw_64_spec0',time_double(tbx[i]),times=t)  & $
      v2 = tsample('rbspa_efw_64_spec4',time_double(tbx[i]),times=t)  & $
      ew_amp = sqrt(v*bandw)  & $
      bw_amp = sqrt(v2*bandw)  & $
      plot,freqs,ew_amp,yrange=[0,2],xrange=[0,4000],psym=-4,title='from jan20_chorus_microburst_freq_spectrum.pro',ytitle='Spectral Ew [mV/m]!Cat!C'+tbx,xtitle='freq [Hz]'  & $
      oplot,[fce_2,fce_2],[0,1d6],thick=2  & $
      plot,freqs,bw_amp,yrange=[0,5],xrange=[0,4000],psym=-4,ytitle='Spectral Bw [pT]!Cat!C'+tbx,xtitle='freq [Hz]'  & $
      oplot,[fce_2,fce_2],[0,1d6],thick=2
      

