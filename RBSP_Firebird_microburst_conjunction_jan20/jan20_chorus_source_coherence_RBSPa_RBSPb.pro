

  tplot_options,'xmargin',[20.,16.]
  tplot_options,'ymargin',[3,9]
  tplot_options,'xticklen',0.08
  tplot_options,'yticklen',0.02
  tplot_options,'xthick',2
  tplot_options,'ythick',2
  tplot_options,'labflag',-1	

  rbsp_efw_position_velocity_crib

 
;  fb = '3'
  date = '2016-01-20'

  timespan,date

  tplot_options,'title','from jan20_microburst_chorus_comparison.pro'

  rbsp_load_efw_fbk,probe=['a','b'],type='calibrated',/pt
  rbsp_load_efw_spec,probe=['a','b'],type='calibrated'

  rbsp_split_fbk,'a'
  rbsp_split_fbk,'b'

  ylim,['rbsp'+sc+'_efw_64_spec0','rbsp'+sc+'_efw_64_spec4','rbsp'+sc+'_efw_fbk_7_fb2_pk'],0,3000,0
  tplot,['rbsp'+sc+'_efw_64_spec0','rbsp'+sc+'_efw_64_spec4','rbsp'+sc+'_fbk1_7pk_5','rbsp'+sc+'_fbk2_7pk_5']

  rbsp_detrend,['rbspa_fbk1_7pk_5','rbspb_fbk1_7pk_5',$
                'rbspa_fbk2_7pk_5','rbspb_fbk2_7pk_5'],60.*0.2

  tplot,['rbspa_fbk1_7pk_5_smoothed','rbspb_fbk1_7pk_5_smoothed',$
         'rbspa_fbk2_7pk_5_smoothed','rbspb_fbk2_7pk_5_smoothed']



fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

get_data,'rbspa_efw_64_spec2',data=bu2
get_data,'rbspa_efw_64_spec3',data=bv2
get_data,'rbspa_efw_64_spec4',data=bw2
bu2.y[*,0:30] = 0.
bv2.y[*,0:30] = 0.
bw2.y[*,0:30] = 0.
;bu2.y[*,45:63] = 0.
;bv2.y[*,45:63] = 0.
;bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'

get_data,'rbspb_efw_64_spec2',data=bu2
get_data,'rbspb_efw_64_spec3',data=bv2
get_data,'rbspb_efw_64_spec4',data=bw2
bu2.y[*,0:30] = 0.
bv2.y[*,0:30] = 0.
bw2.y[*,0:30] = 0.
;bu2.y[*,45:63] = 0.
;bv2.y[*,45:63] = 0.
;bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,'Bfield_hissintb'


get_data,'rbspa_efw_64_spec0',data=bu2
bu2.y[*,0:30] = 0.
;bv2.y[*,0:2] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Efield_hissinta',data={x:bu2.x,y:bt}
tplot,'Efield_hissinta'

get_data,'rbspb_efw_64_spec0',data=bu2
bu2.y[*,0:30] = 0.
;bv2.y[*,0:2] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Efield_hissintb',data={x:bu2.x,y:bt}
tplot,'Efield_hissintb'

rbsp_detrend,['Bfield_hissinta','Bfield_hissintb','Efield_hissinta','Efield_hissintb'],60.*0.2


options,['Bfield_hissintb_smoothed','rbspb_fbk2_7pk_5_smoothed',$
         'Efield_hissintb_smoothed','rbspb_fbk1_7pk_5_smoothed'],'colors',250


tplot,['Bfield_hissinta_smoothed','Bfield_hissintb_smoothed',$
       'rbspa_fbk2_7pk_5_smoothed','rbspb_fbk2_7pk_5_smoothed']


tplot,['Efield_hissinta_smoothed','Efield_hissintb_smoothed',$
       'rbspa_fbk1_7pk_5_smoothed','rbspb_fbk1_7pk_5_smoothed']


