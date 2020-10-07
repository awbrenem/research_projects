;Read the ASCII files sent to me by Xiaojia Zheng for THEMIS A
;energy spectra near the loss cone. See email on 7/17/2019.

tplot_options,'title','read_themis_eflux_energy_spectra.pro'


timespan,'2014-01-11',2,/days
load_barrel_lc,'2X',type='sspc'
load_barrel_lc,'2X',type='rcnt'

omni_hro_load

zlim,'SSPC_2X',.1,100,1
ylim,'SSPC_2X',1,300,1
timespan,'2014-01-11/19:00',7,/hours

rbsp_detrend,'PeakDet_2X',60.*2.
rbsp_detrend,'PeakDet_2X_smoothed',60.*80.

rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*2.
rbsp_detrend,'OMNI_HRO_1min_proton_density_smoothed',60.*80.


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
filename = 'eflux_1-300keV_20140111_190000-20140112_020000.txt'

;x = ascii_template(path+fn)


ft = [7,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
fn = ['time','FIELD02','FIELD03','FIELD04','FIELD05','FIELD06','FIELD07','FIELD08','FIELD09','FIELD10','FIELD11','FIELD12','FIELD13','FIELD14','FIELD15','FIELD16','FIELD17','FIELD18','FIELD19','FIELD20','FIELD21','FIELD22','FIELD23','FIELD24','FIELD25']
fl = long([0,32,46,60,74,88,102,116,130,144,158,172,186,200,214,228,242,252,270,284,298,312,326,340,354])
fg = long([0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24])

str = {version:1.,$
datastart:2L,$
delimiter:32b,$
missingvalue:!values.f_nan,$
commentsymbol:'',$
fieldcount:25L,$
fieldtypes:ft,$
fieldnames:fn,$
fieldlocations:fl,$
fieldgroups:fg}

;energies in keV
energies =[1304.46,1717.47,2260.87,2976.85,3917.75,5157.26,6788.92,8936.37,11763.4,15484.9,20383.3,26831.4,27000.0,28000.0,29000.0,30000.0,31000.0,41000.0,52000.0,65500.0,93000.0,139000.,203500.,293000.]/1000.

times = time_double(vals.time)

vals = read_ascii(path+filename,template=str)

eflux = [[vals.FIELD02],[vals.FIELD03],[vals.FIELD04],[vals.FIELD05],[vals.FIELD06],[vals.FIELD07],[vals.FIELD08],[vals.FIELD09],[vals.FIELD10],[vals.FIELD11],[vals.FIELD12],[vals.FIELD13],[vals.FIELD14],[vals.FIELD15],[vals.FIELD16],[vals.FIELD17],[vals.FIELD18],[vals.FIELD19],[vals.FIELD20],[vals.FIELD21],[vals.FIELD22],[vals.FIELD23],[vals.FIELD24],[vals.FIELD25]]

store_data,'eflux',times,eflux,energies
options,'eflux','spec',1
ylim,'eflux',1,300.,1
zlim,'eflux',1d0,1d7,1
options,'eflux','ytitle','THEMIS A!CEflux [keV]!C0-22.5deg PA'
options,'eflux','ztitle','(eV/s-sr-cm2-eV)'

;Create number flux
nflux = eflux & nflux[*] = 0.
  ;Make sure to multiply energies by 1000 b/c the energy flux is in eV/cm2-s-sr-eV)
  ;but "energies" are currently in keV
for i=0,n_elements(energies)-1 do nflux[*,i] = eflux[*,i]/(1000.*energies[i])

store_data,'nflux',times,nflux,energies
options,'nflux','spec',1
ylim,'nflux',1,300.,1
zlim,'nflux',1d0,1d7,1
options,'nflux','ytitle','THEMIS A!C#flux [keV]!C0-22.5deg PA'
options,'nflux','ztitle','(#/s-sr-cm2-eV)'


split_vec,'eflux',suffix='_'+strtrim(energies,2)
options,'eflux_*','spec',0
ylim,'eflux_*',0,0
split_vec,'nflux',suffix='_'+strtrim(energies,2)
options,'nflux_*','spec',0
ylim,'nflux_*',0,0

rbsp_detrend,'?flux_*',60.*80.
tplot,['eflux','nflux','eflux_52.0000','nflux_52.0000','eflux_52.0000_detrend','nflux_52.0000_detrend']



;determine fractional change due to SW modulation.


;rbsp_detrend,'nflux_52.0000',60.*80.
rbsp_detrend,'nflux_??.????',60.*80.
rbsp_detrend,'nflux_???.???',60.*80.
store_data,'frac_comb',data=['nflux_52.0000_smoothed','nflux_52.0000']
options,'frac_comb','colors',[0,250]
tplot,'frac_comb'


get_data,'nflux_30.0000',t,d1 & get_data,'nflux_30.0000_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_30.000keV',t,fracocc
get_data,'nflux_41.0000',t,d1 & get_data,'nflux_41.0000_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_41.000keV',t,fracocc
get_data,'nflux_52.0000',t,d1 & get_data,'nflux_52.0000_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_52.000keV',t,fracocc
get_data,'nflux_65.5000',t,d1 & get_data,'nflux_65.5000_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_65.500keV',t,fracocc
get_data,'nflux_93.0000',t,d1 & get_data,'nflux_93.0000_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_93.000keV',t,fracocc
get_data,'nflux_139.000',t,d1 & get_data,'nflux_139.000_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_139.000keV',t,fracocc
get_data,'nflux_203.500',t,d1 & get_data,'nflux_203.500_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_203.500keV',t,fracocc
get_data,'nflux_293.000',t,d1 & get_data,'nflux_293.000_smoothed',t,d2
fracocc = (d1-d2)/d2  & store_data,'fracocc_293.000keV',t,fracocc

ylim,'fracocc_*',-1,1
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','fracocc_30.000keV','fracocc_41.000keV','fracocc_52.000keV','fracocc_65.500keV','fracocc_93.000keV','fracocc_139.000keV','fracocc_203.500keV','fracocc_293.000keV']

store_data,'nflux_comb',data=['nflux_30.0000','nflux_41.0000','nflux_52.0000','nflux_65.5000','nflux_93.0000','nflux_139.000','nflux_203.500','nflux_293.000']
options,'nflux_comb','colors',indgen(8)*40.
ylim,'nflux_comb',0,0,0
ylim,'nflux_comb',1,1d5,1

tplot,['fracocc_30.000keV','fracocc_41.000keV','fracocc_52.000keV','fracocc_65.500keV','fracocc_93.000keV','fracocc_139.000keV','fracocc_203.500keV','fracocc_293.000keV']
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','nflux_comb'],/add

tplot,['OMNI_HRO_1min_proton_density_smoothed','nflux_30.0000','nflux_41.0000','nflux_52.0000','nflux_65.5000','nflux_93.0000','nflux_139.000','nflux_203.500','nflux_293.000']
tplot,['OMNI_HRO_1min_proton_density_smoothed','nflux_30.0000_detrend','nflux_41.0000_detrend','nflux_52.0000_detrend','nflux_65.5000_detrend','nflux_93.0000_detrend','nflux_139.000_detrend','nflux_203.500_detrend','nflux_293.000_detrend']



ylim,'fracocc_52.000keV',-0.5,0.5
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','SSPC_2X','PeakDet_2X_smoothed_detrend','nflux','nflux_52.0000','nflux_52.0000_detrend','fracocc_52.000keV']



;--------------------------------------------------------------------
;Create an energy spectrum for Leslie

get_data,'nflux',data=d


t0z = time_double('2014-01-11/21:55')
t1z = time_double('2014-01-11/22:05')

thayv = tsample('nflux',[t0z,t1z],times=tmstha)
nelem = n_elements(tmstha)

;Average
thaavg = fltarr(n_elements(d.v))
for i=0,n_elements(d.v)-1 do thaavg[i] = total(thayv[*,i])/nelem

plot,d.v,thayv[0,*]
oplot,d.v,thaavg,color=250

;Change from (#/cm2-s-sr-eV) to (#/cm2-s-sr-keV)


for i=0,n_elements(d.v)-1 do print,d.v[i],thaavg[i]*1000.


;---------------------------------------------------------------------
;Figure out the energy range of precipitated electron


get_data,'SSPC_2X',data=d
barbins = d.v

t0z = time_double('2014-01-11/21:30')
t1z = time_double('2014-01-11/23:20')

baryv = tsample('SSPC_2X',[t0z,t1z],times=tmsbar)

;Now compare this to the THEMIS A energy distribution during conjunction
;first run crib sheet thm_crib_esa_dist2scpot.pro (first few lines only)

get_data,'nflux',data=d
;get_data,'tha_peer_en_counts',data=d
thayv = tsample('nflux',[t0z,t1z],times=tmstha)


;normalize each energy spectrum to 40 keV count rate
good = where(barbins ge 40.) & good = good[0]
max40bar = max(baryv[*,good])

;....energies are in order of highest-lowest
good = where(energies ge 50.) & good = good[0]
max40tha = max(thayv[*,good])


;!p.multi = [0,0,2]
;plot,barbins,baryv[0,*],xrange=[20,150],xstyle=1;,yrange=[0,1.5]
;for i=0,n_elements(tmsbar)-1 do oplot,barbins,baryv[i,*]
;plot,energies,thayv[0,*],xrange=[20,150],xstyle=1;,yrange=[0,1.5]
;for i=0,n_elements(tmstha)-1 do oplot,energies,thayv[i,*],color=250


!p.multi = [0,0,2]
plot,barbins,baryv[0,*]/max40bar,xrange=[20,150],xstyle=1,yrange=[0,1.5]
for i=0,n_elements(tmsbar)-1 do oplot,barbins,baryv[i,*]/max40bar
for i=0,n_elements(tmstha)-1 do oplot,energies,thayv[i,*]/max40tha,color=250


;log scale shows these two have very similar slopes
plot,barbins,baryv[0,*]/max40bar,xrange=[20,300],xstyle=1,yrange=[0.003,2],/ylog,/ystyle
for i=0,n_elements(tmsbar)-1 do oplot,barbins,baryv[i,*]/max40bar
for i=0,n_elements(tmstha)-1 do oplot,energies,thayv[i,*]/max40tha,color=250


;---------------------------------------------------
;Flux comparison b/t 2X and THEMIS A

;2X flux at 52 keV from fit
f(E) = 8597*exp(-E/44)
f2x = 2636  ;e-/cm2-s-keV

;THEMIS A fluctuation of the 52 keV channel at 23:00:50.
f = 6871  ;e-/cm2-s-eV-sr
;convert to keV
f = f * 1000.  ;e-/cm2-s-keV-sr

;Since most of this is at 22.5 deg, I'm going to guess at what fraction
;is at the loss cone.
f = f/10.

;Guess at solid angle (multiply by 2*pi for the thin ring solid angle)
ang0 = 3.  ;loss cone angle (deg)
dangleA0 = 0.8 ;deg   (angular extent of ring)
SAA0 = 2*!pi*sin(ang0*!dtor) * dangleA0*!dtor
ff = f*SAA0
ff = 3154. ;e-/cm2-s-keV

frat = ff/f2x
;frat ~1.2
