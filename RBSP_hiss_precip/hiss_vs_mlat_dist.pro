;This plot shows that the low freq hiss is very confined to the 
;magnetic equator, and therefore off-equator diffusion isn't important

date = '2014-01-02'
timespan,date,7
probe = 'a'

rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace


rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype='vsvy'
split_vec,rbspx + '_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,rbspx + '_efw_vsvy_V1',data=v1
get_data,rbspx + '_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'density'+probe,data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'density'+probe,'ytitle','density'+strupcase(probe)+'!Ccm^-3'

store_data,'sum12',data={x:v1.x,y:sum12}


get_data,'rbspa_efw_64_spec2',data=bu2
get_data,'rbspa_efw_64_spec3',data=bv2
get_data,'rbspa_efw_64_spec4',data=bw2


       0       4
       1      12
       2      20
       3      28
       4      36
       5      44
       6      52
       7      60
       8      68
       9      76
      10      84
      11      92
      12     100
      13     108
      14     116
      15     124
      16     136
      17     152
      18     168
      19     184
      20     200
      21     216
      22     232
      23     248
      24     272
      25     304
      26     336
      27     368
      28     400
      29     432
      30     464
      31     496
      32     544

;Remove freqs <= 36 Hz
bu2.y[*,0:4] = 0.
bv2.y[*,0:4] = 0.
bw2.y[*,0:4] = 0.

;Remove freqs >= 216 Hz
bu2.y[*,22:63] = 0.
bv2.y[*,22:63] = 0.
bw2.y[*,22:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}


tinterpol_mxn,'rbspa_state_mlat','Bfield_hissinta'
tinterpol_mxn,'densitya','Bfield_hissinta'
tinterpol_mxn,'sum12','Bfield_hissinta'

ylim,'rbspa_efw_64_spec4',30,200,1
ylim,'Bfield_hissinta',0,150

get_data,'rbspa_state_mlat_interp',data=mlat
store_data,'rbspa_state_mlat_interp',data={x:mlat.x,y:abs(mlat.y)}
tplot,['rbspa_efw_64_spec4','Bfield_hissinta','rbspa_state_mlat_interp','densitya_interp']




get_data,'rbspa_state_mlat_interp',data=mlat
get_data,'Bfield_hissinta',data=hiss
get_data,'densitya_interp',data=dens

;Remove low density values. These may not correspond to PS
goo = where(dens.y ge 30.)


!p.multi = [0,0,1]
plot,abs(mlat.y[goo]),hiss.y[goo],title='RBSP-A RMS hiss from 40-200 Hz for!C2014-01-02 - 2014-01-08!CValues removed when density < 30 cm-3',$
	ytitle='RMS amp (mV/m)',xtitle='|Mlat| deg',yrange=[0,150]
;plot,mlat.y[goo],hiss.y[goo],title='RBSP-A RMS hiss from 40-200 Hz for!C2014-01-02 - 2014-01-08!CValues removed when density < 30 cm-3',$
;	ytitle='RMS amp (mV/m)',xtitle='|Mlat| deg',yrange=[0,150]



