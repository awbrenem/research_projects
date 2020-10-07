;Test to see if the chorus waves are being ducted.
;...comparisons of density and Bo fluctuations on few min timescales.
;...density from both UH line and EFW antenna potentials


fn = 'rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
cdf2tplot,path+fn

fn = 'rbspa_rel03_ect-hope-MOM-L3_20160120_v6.3.2.cdf'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/HOPE/'
cdf2tplot,path+fn

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
tplot_restore,filename=path+'RBSPa_upper_hybrid_densities_Jan_20_2016.tplot'



path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EFW/'
tplot_restore,filenames=path+'densitya.tplot'

probe = 'a'
rbsp_efw_init

timespan,'2016-01-20'
rbsp_load_efw_spec,probe='a',type='calibrated'




fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2
bu2.y[*,0:28] = 0.
bv2.y[*,0:28] = 0.
bw2.y[*,0:28] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.

nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y

for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)

store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'

rbsp_detrend,'Bfield_hissinta',60.*0.4
rbsp_detrend,'RBSPa!Cdensity!Ccm!e-3!n',60.*0.4


ylim,'RBSPa!Cdensity!Ccm!e-3!n',5,10,0
ylim,'Ion_density',0.6,1.4
ylim,'Magnitude',130,160
ylim,'Bfield_hissinta_smoothed',0.001,0.3,1
ylim,'rbspa_efw_64_spec4',300,2000,0
tplot,['RBSPa!Cdensity!Ccm!e-3!n','rbspa_density34','Dens_e_200','Ion_density','Magnitude','Bfield_hissinta_smoothed','rbspa_efw_64_spec4']
tplot,['RBSPa!Cdensity!Ccm!e-3!n_smoothed','Magnitude','Bfield_hissinta_smoothed','rbspa_efw_64_spec4']
