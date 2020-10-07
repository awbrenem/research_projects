;Calculates cyclotron resonance energies for the BARREL/RBSP hiss
;events. Outputs a file at the end that Alexa uses for the diffusion
;calculations



tplot_options,'title','from cycl_res_energy_alexa.pro'

date = '2013-01-26'

timespan,date
probe = 'a'

rbsp_efw_init


rbsp_efw_position_velocity_crib,/noplot,/notrace

;---------------------------------------------------------
;EMFISIS file with wave normal angles
pn = '~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/'
fnt = 'rbsp-a_wna-survey_emfisis-L4_20130126_v1.5.2.cdf'
;fnt = 'rbsp-b_wna-survey_emfisis-L4_20130126_v1.5.2.cdf'


cdf_leap_second_init
cdf2tplot,file=pn+fnt

get_data,'thsvd',data=thk,dlim=lim,lim=lim
store_data,'thk',data={x:thk.x,y:thk.y,v:reform(thk.v)}
options,'thk','spec',1
ylim,'thk',300,2000,1

tplot,'thk'
;--------------------------------------------------------
;; ;EMFISIS file with hiss spec
pn = '~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/'
fnt = 'rbsp-a_WFR-spectral-matrix-diagonal_emfisis-L2_20130126_v1.2.4.cdf'
;; ;fnt = 'rbsp-a_WFR-spectral-matrix_emfisis-L2_20140103_v1.3.2.cdf'
;; fnt = 'rbsp-a_WFR-spectral-matrix-diagonal_emfisis-L2_20140103_v1.3.2.cdf'
;; ;fnt = 'rbsp-a_WFR-spectral-matrix_emfisis-L2_20140106_v1.3.4.cdf'
cdf2tplot,file=pn+fnt

get_data,'BwBw',data=bw2
store_data,'BwBw',data={x:bw2.x,y:1000.*1000.*bw2.y,v:reform(bw2.v)}
options,'BwBw','spec',1
zlim,'BwBw',1d-6,100,1
ylim,'BwBw',20,1000,1

get_data,'BuBu',data=bu2
store_data,'BuBu',data={x:bu2.x,y:1000.*1000.*bu2.y,v:reform(bu2.v)}
options,'BuBu','spec',1
zlim,'BuBu',1d-6,100,1
ylim,'BuBu',20,1000,1

get_data,'BvBv',data=bv2
store_data,'BvBv',data={x:bv2.x,y:1000.*1000.*bv2.y,v:reform(bv2.v)}
options,'BvBv','spec',1
zlim,'BvBv',1d-6,100,1
ylim,'BvBv',20,1000,1


;; get_data,'EuEu',data=dd
;; store_data,'EuEu',data={x:dd.x,y:1000.*1000.*dd.y,v:reform(dd.v)}
;; options,'EuEu','spec',1
;; zlim,'EuEu',1d-6,100,1
;; ylim,'EuEu',20,1000,1

ylim,['BwBw','BuBu','BvBv'],100,3000,1
tplot,['BwBw','BuBu','BvBv']



bandw = reform(bw2.v) - shift(reform(bw2.v),1)
bandw[0:32] = 0.
bandw[49:64] = 0.
bt = fltarr(n_elements(bu2.x))

ball = bu2.y + bv2.y + bw2.y
for j=0L,n_elements(bu2.x)-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_chorusint',data={x:bu2.x,y:bt}
tplot,'Bfield_chorusint'



;-------------------------------------------------------



rbspx = 'rbsp' + probe
t0 = time_double('2013-01-26/10:00')
t1 = time_double('2013-01-26/12:00')
timespan, date

rbsp_efw_init	
!rbsp_efw.user_agent = ''
tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	

;rbsp_load_emfisis,probe=probe,/quicklook
rbsp_load_emfisis,probe=probe,type='4sec',coord='gse'

rbsp_load_efw_spec,probe=probe,type='calibrated',/pt


;density from EMFISIS
;rbsp_leap_second_init
cdf2tplot,file='~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/rbsp-a_density_emfisis_20130126_v1.4.15.cdf'
copy_data,'density','densitya'
cdf2tplot,file='~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/rbsp-b_density_emfisis_20130126_v1.3.15.cdf'
copy_data,'density','densityb'



rbsp_detrend,'densitya',60.*30.



get_data,'BwBw',data=spec2
;delete non chorus bands
spec2.y[*,0:32] = 0.
spec2.y[*,49:64] = 0.
freqm2 = fltarr(n_elements(spec2.x))
;ampm2 = fltarr(n_elements(spec2.x))



;store_data,'specfin',data={x:spec.x,y:spec.y,v:spec.v}
store_data,'specfin2',data={x:spec2.x,y:spec2.y,v:spec2.v}

get_data,'Bfield_chorusint',data=ampm
;ampm = ampm.y
;ampm2 = ampm.y

options,['specfin','specfin2'],'spec',1
ylim,['specfin','specfin2'],100,10000,1
zlim,['specfin','specfin2'],1d-8,1d-2,1


;; for i=0L,n_elements(spec.x)-1 do begin $
;; 	tmp = max(spec.y[i,*],wh)	& $
;; 	freqm[i] = spec.v[wh] ;& $
;; ;	ampm[i] = sqrt(spec.y[i,wh])
;; for i=0L,n_elements(spec2.x)-1 do begin $
;; 	tmp = max(spec2.y[i,*],wh)	& $
;; 	freqm2[i] = spec2.v[wh]  ; & $
;; ;	ampm2[i] = sqrt(spec2.y[i,wh])

;; for i=0L,n_elements(spec.x)-1 do begin 
;; 	tmp = max(spec.y[i,*],wh)
;; 	freqm[i] = spec.v[wh] 
;; ;	ampm[i] = sqrt(spec.y[i,wh])
;; endfor
for i=0L,n_elements(spec2.x)-1 do begin 
	tmp = max(spec2.y[i,*],wh)	
	freqm2[i] = spec2.v[wh]
;	ampm2[i] = sqrt(spec2.y[i,wh])
endfor
;---------------------------------


;get min freq of chorus band
;; freqbottom = fltarr(n_elements(spec.x))
;; freqtop = fltarr(n_elements(spec.x))
;; minampb = 0.0001   ;min amp for lower hiss bound
;; minampt = 0.0001	;min amp for upper hiss bound
freqbottom2 = fltarr(n_elements(spec2.x))
freqtop2 = fltarr(n_elements(spec2.x))
minampb2 = 0.01   ;min amp for lower hiss bound
minampt2 = 0.01	;min amp for upper hiss bound
;minampb = ampm/exp(1)^2
;minampt = ampm/exp(1)^2

;; for i=0L,n_elements(spec.x)-1 do begin $
;; 	goo = where(spec.y[i,*] ge minampb)  & $
;; 	if goo[0] ne -1 then freqbottom[i] = spec.v[goo[0]]   & $
;; 	goo = where(spec.y[i,*] ge minampt)  & $
;; 	if goo[0] ne -1 then freqtop[i] = spec.v[max(goo)]

;; for i=0L,n_elements(spec2.x)-1 do begin $
;; 	goo = where(spec2.y[i,*] ge minampb2)  & $
;; 	if goo[0] ne -1 then freqbottom2[i] = spec2.v[goo[0]]   & $
;; 	goo = where(spec2.y[i,*] ge minampt2)  & $
;; 	if goo[0] ne -1 then freqtop2[i] = spec2.v[max(goo)]
;; for i=0L,n_elements(spec.x)-1 do begin 
;; 	goo = where(spec.y[i,*] ge minampb)
;; 	if goo[0] ne -1 then freqbottom[i] = spec.v[goo[0]]  
;; 	goo = where(spec.y[i,*] ge minampt) 
;; 	if goo[0] ne -1 then freqtop[i] = spec.v[max(goo)]
;; endfor

for i=0L,n_elements(spec2.x)-1 do begin 
	goo = where(spec2.y[i,*] ge minampb2)  
	if goo[0] ne -1 then freqbottom2[i] = spec2.v[goo[0]]   
	goo = where(spec2.y[i,*] ge minampt2)  
	if goo[0] ne -1 then freqtop2[i] = spec2.v[max(goo)]
endfor


;; store_data,'freqmax',data={x:spec.x,y:freqm}
;; store_data,'freqbottom',data={x:spec.x,y:freqbottom}
;; store_data,'freqtop',data={x:spec.x,y:freqtop}
store_data,'freqmax2',data={x:spec2.x,y:freqm2}
store_data,'freqbottom2',data={x:spec2.x,y:freqbottom2}
store_data,'freqtop2',data={x:spec2.x,y:freqtop2}
options,['freqtop','freqtop2'],'colors',50
options,['freqbottom','freqbottom2'],'colors',150

;; rbsp_detrend,['freqmax','freqbottom','freqtop',$
;;              'freqmax2','freqbottom2','freqtop2'],60.*0.2
rbsp_detrend,['freqmax2','freqbottom2','freqtop2'],60.*0.2



;; ;Remove values where this condition isn't true:   fbottom < fmax < ftop
;; get_data,'freqmax_smoothed',data=fm
;; get_data,'freqbottom_smoothed',data=fb
;; get_data,'freqtop_smoothed',data=ft

;; bad = where((fb.y gt fm.y) or (fb.y gt ft.y) or (fm.y gt ft.y) or (ft.y lt fb.y) or (ft.y lt fm.y) or (fm.y lt fb.y))

;; if bad[0] ne -1 then fm.y[bad] = !values.f_nan
;; if bad[0] ne -1 then ft.y[bad] = !values.f_nan
;; if bad[0] ne -1 then fb.y[bad] = !values.f_nan
;; if bad[0] ne -1 then ampm[bad] = !values.f_nan



get_data,'freqmax2_smoothed',data=fm2
get_data,'freqbottom2_smoothed',data=fb2
get_data,'freqtop2_smoothed',data=ft2

bad = where((fb2.y gt fm2.y) or (fb2.y gt ft2.y) or (fm2.y gt ft2.y) or (ft2.y lt fb2.y) or (ft2.y lt fm2.y) or (fm2.y lt fb2.y))

if bad[0] ne -1 then fm2.y[bad] = !values.f_nan
if bad[0] ne -1 then ft2.y[bad] = !values.f_nan
if bad[0] ne -1 then fb2.y[bad] = !values.f_nan
;if bad[0] ne -1 then ampm2[bad] = !values.f_nan



;; ;remove very small amplitude values
;; minampp = 0.8   ;just above noise floor
;; bad = where(ampm lt minampp)
;; fm.y[bad] = !values.f_nan
;; ft.y[bad] = !values.f_nan
;; fb.y[bad] = !values.f_nan
;; ampm[bad] = !values.f_nan

;; minampp2 = 0.02   ;just above noise floor
;; bad = where(ampm2 lt minampp2)
;; if bad[0] ne -1 then fm2.y[bad] = !values.f_nan
;; if bad[0] ne -1 then ft2.y[bad] = !values.f_nan
;; if bad[0] ne -1 then fb2.y[bad] = !values.f_nan
;; if bad[0] ne -1 then ampm2[bad] = !values.f_nan



;; store_data,'amp_max',data={x:fm.x,y:ampm}
;; store_data,'freqmax_smoothed',data={x:fm.x,y:fm.y}
;; store_data,'freqbottom_smoothed',data={x:fm.x,y:fb.y}
;; store_data,'freqtop_smoothed',data={x:fm.x,y:ft.y}

;store_data,'amp_max2',data={x:fm2.x,y:ampm2}
store_data,'freqmax2_smoothed',data={x:fm2.x,y:fm2.y}
store_data,'freqbottom2_smoothed',data={x:fm2.x,y:fb2.y}
store_data,'freqtop2_smoothed',data={x:fm2.x,y:ft2.y}

;**************************************************
;Temporary versions for plotting
;; copy_data,'freqmax','freqmaxtmp'
;; copy_data,'freqbottom','freqbottomtmp'
;; copy_data,'freqtop','freqtoptmp'
copy_data,'freqmax2','freqmaxtmp2'
copy_data,'freqbottom2','freqbottomtmp2'
copy_data,'freqtop2','freqtoptmp2'

;; get_data,'freqmaxtmp',data=dat
;; goo = where(dat.y eq 4.)
;; if goo[0] ne -1 then dat.y[goo] = !values.f_nan
;; store_data,'freqmaxtmp',data=dat

;; get_data,'freqbottomtmp',data=dat
;; goo = where(dat.y eq 4.)
;; if goo[0] ne -1 then dat.y[goo] = !values.f_nan
;; store_data,'freqbottomtmp',data=dat

;; get_data,'freqtoptmp',data=dat
;; goo = where(dat.y eq 4.)
;; if goo[0] ne -1 then dat.y[goo] = !values.f_nan
;; store_data,'freqtoptmp',data=dat


get_data,'freqmaxtmp2',data=dat
goo = where(dat.y eq 4.)
if goo[0] ne -1 then dat.y[goo] = !values.f_nan
store_data,'freqmaxtmp2',data=dat

get_data,'freqbottomtmp2',data=dat
goo = where(dat.y eq 4.)
if goo[0] ne -1 then dat.y[goo] = !values.f_nan
store_data,'freqbottomtmp2',data=dat

get_data,'freqtoptmp2',data=dat
goo = where(dat.y eq 4.)
if goo[0] ne -1 then dat.y[goo] = !values.f_nan
store_data,'freqtoptmp2',data=dat

;; copy_data,'freqmax_smoothed','freqmaxtmp_smoothed'
;; copy_data,'freqbottom_smoothed','freqbottomtmp_smoothed'
;; copy_data,'freqtop_smoothed','freqtoptmp_smoothed'

copy_data,'freqmax2_smoothed','freqmaxtmp2_smoothed'
copy_data,'freqbottom2_smoothed','freqbottomtmp2_smoothed'
copy_data,'freqtop2_smoothed','freqtoptmp2_smoothed'

;; get_data,'freqmaxtmp_smoothed',data=dat
;; goo = where(dat.y eq 4.)
;; if goo[0] ne -1 then dat.y[goo] = !values.f_nan
;; store_data,'freqmaxtmp_smoothed',data=dat

;; get_data,'freqbottomtmp_smoothed',data=dat
;; goo = where(dat.y eq 4.)
;; if goo[0] ne -1 then dat.y[goo] = !values.f_nan
;; store_data,'freqbottomtmp_smoothed',data=dat

;; get_data,'freqtoptmp_smoothed',data=dat
;; goo = where(dat.y eq 4.)
;; if goo[0] ne -1 then dat.y[goo] = !values.f_nan
;; store_data,'freqtoptmp_smoothed',data=dat


get_data,'freqmaxtmp2_smoothed',data=dat
goo = where(dat.y eq 4.)
if goo[0] ne -1 then dat.y[goo] = !values.f_nan
store_data,'freqmaxtmp2_smoothed',data=dat

get_data,'freqbottomtmp2_smoothed',data=dat
goo = where(dat.y eq 4.)
if goo[0] ne -1 then dat.y[goo] = !values.f_nan
store_data,'freqbottomtmp2_smoothed',data=dat

get_data,'freqtoptmp2_smoothed',data=dat
goo = where(dat.y eq 4.)
if goo[0] ne -1 then dat.y[goo] = !values.f_nan
store_data,'freqtoptmp2_smoothed',data=dat

;**************************************************


;; store_data,'spec_max_smoothed',data=['specfin','freqmaxtmp_smoothed','freqbottomtmp_smoothed','freqtoptmp_smoothed']
;; store_data,'spec_max',data=['specfin','freqmaxtmp','freqbottomtmp','freqtoptmp']

store_data,'spec_max2_smoothed',data=['specfin2','freqmaxtmp2_smoothed','freqbottomtmp2_smoothed','freqtoptmp2_smoothed']
store_data,'spec_max2',data=['specfin2','freqmaxtmp2','freqbottomtmp2','freqtoptmp2']


;; options,['freqbottomtmp_smoothed','freqbottom_smoothed','freqbottomtmp2_smoothed','freqbottom2_smoothed'],'colors',250
;; options,['freqtoptmp_smoothed','freqtop_smoothed','freqtoptmp2_smoothed','freqtop2_smoothed'],'colors',50
;; options,['freqmax_smoothed','freqbottom_smoothed','freqtop_smoothed',$
;;          'freqmaxtmp_smoothed','freqbottomtmp_smoothed','freqtoptmp_smoothed'],'thick',3
;; options,['freqmax2_smoothed','freqbottom2_smoothed','freqtop2_smoothed',$
;;          'freqmaxtmp2_smoothed','freqbottomtmp2_smoothed','freqtoptmp2_smoothed'],'thick',3
options,['freqbottomtmp2_smoothed','freqbottom2_smoothed'],'colors',250
options,['freqtoptmp2_smoothed','freqtop2_smoothed'],'colors',50
options,['freqmax2_smoothed','freqbottom2_smoothed','freqtop2_smoothed',$
         'freqmaxtmp2_smoothed','freqbottomtmp2_smoothed','freqtoptmp2_smoothed'],'thick',3

store_data,'thkcomb',data=['thk','freqmaxtmp2_smoothed','freqbottomtmp2_smoothed','freqtoptmp2_smoothed']

ylim,['specfin','specfin2','spec_max','spec_max_smoothed','spec_max2','spec_max2_smoothed','thk','thkcomb'],200,2000,1
zlim,['spec_max','spec_max_smoothed'],1d-8,1d-2,1
zlim,['specfin2','spec_max2','spec_max2_smoothed'],1d-6,1d0,1
options,['spec_max','spec_max_smoothed','spec_max2','spec_max2_smoothed'],'psym',0



tplot,['specfin2','spec_max2_smoothed','thk','thkcomb']



stop



;At this point everything is smoothed to the spinperiod, but need to put all data sets on the same cadence
get_data,'specfin2',data=spec
tinterpol_mxn,'densitya',spec.x,newname='densitya2'
tinterpol_mxn,'densityb',spec.x,newname='densityb2'
tinterpol_mxn,'rbspa_emfisis_l3_4sec_gse_Mag',spec.x,newname='rbspa_emfisis_l3_4sec_gse_Mag2'
tinterpol_mxn,'rbspb_emfisis_l3_4sec_gse_Mag',spec.x,newname='rbspb_emfisis_l3_4sec_gse_Mag2'
tinterpol_mxn,'rbspa_emfisis_l3_4sec_gse_Magnitude',spec.x,newname='rbspa_emfisis_l3_4sec_gse_Magnitude2'
tinterpol_mxn,'rbspb_emfisis_l3_4sec_gse_Magnitude',spec.x,newname='rbspb_emfisis_l3_4sec_gse_Magnitude2'
tinterpol_mxn,'freqmaxtmp2_smoothed',spec.x,newname='freqmaxtmp2_smoothed2'
tinterpol_mxn,'freqbottomtmp2_smoothed',spec.x,newname='freqbottomtmp2_smoothed2'
tinterpol_mxn,'freqtoptmp2_smoothed',spec.x,newname='freqtoptmp2_smoothed2'
tinterpol_mxn,'Bfield_chorusint',spec.x,newname='Bfield_chorusint2'


;; tinterpol_mxn,'densitya_smoothed',spec.x,newname='densitya_smoothed2'
;; tinterpol_mxn,'rbspa_emfisis_l3_4sec_gse_Magnitude',spec.x,newname='rbspa_emfisis_l3_4sec_gse_Magnitude2'


tinterpol_mxn,'thk',spec.x,newname='thk2'
zlim,['thk','thk2'],0,90



get_data,'densitya2',data=dens
;get_data,'rbspa_emfisis_quicklook_Magnitude_smoothed2',data=mag
get_data,'rbspa_emfisis_l3_4sec_gse_Magnitude2',data=mag
get_data,'thk2',data=thk
get_data,'freqmaxtmp2_smoothed2',data=d
freqm = d.y
get_data,'freqbottomtmp2_smoothed2',data=d
freqbottom = d.y
get_data,'freqtoptmp2_smoothed2',data=d
freqtop = d.y



;**************************************************



freq = freqm
theta_k = fltarr(n_elements(freq))

;Find the theta_kb value of the requested freq
;; for i=0L,n_elements(freq)-1 do begin   $
;; 	goo = where(thk.v ge freq[i])   & $
;; 	if goo[0] ne -1 then theta_k[i] = thk.y[i,goo[0]] else theta_k[i] = 0.
for i=0L,n_elements(freq)-1 do begin   
   goo = where(thk.v ge freq[i])  
   if goo[0] ne -1 then theta_k[i] = thk.y[i,goo[0]] else theta_k[i] = 0.
endfor




store_data,'theta_k_max',data={x:spec.x,y:theta_k}
ylim,'theta_k_max',0,180.
tplot,['specfin2','spec_max2_smoothed','thk','thkcomb','theta_k_max']



	c_ms      = 2.99792458d8      ; -Speed of light in vacuum (m/s)	
	pa = 0.  ;test pitch angle in deg
	;theta_k = 0.0  ;wave normal angle
	fce = 28.*mag.y
	fpe = 8980*sqrt(dens.y)
	c=3d8


	kvec = sqrt(4*!pi^2*fpe^2*freq/(c^2*(fce*cos(theta_k*!dtor)-freq)))
	;kvec = 1./1000.   ;1/m
	
	kz = abs((kvec)*cos(theta_k*!dtor))
	

	Etots_cycl = fltarr(n_elements(spec.x))
	Etots_anom = fltarr(n_elements(spec.x))
	Etots_landau = fltarr(n_elements(spec.x))
	Ez_cycl = fltarr(n_elements(spec.x))
	Ez_anom = fltarr(n_elements(spec.x))
	Ez_landau = fltarr(n_elements(spec.x))


;; for q=0,n_elements(freq) - 1 do begin    $
;; 	vz = indgen(10000)*c/9999. * cos(pa*!dtor)    & $
;; 	gama = 1/sqrt(1-(vz/c/cos(pa*!dtor))^2)    & $ ;relativistic gamma factor
;; 	f1cycl = vz   & $
;; 	f2cycl = (2*!pi/kz[q])*(1*fce[q]/gama - freq[q])  & $
;; 	diff = abs(f1cycl-f2cycl)  & $
;; 	tmp = min(diff,val)  & $
;; 	vz_cycl = vz[val]     & $;m/s
;; 	vtots_cycl = vz_cycl/cos(pa*!dtor)   & $ ;electron velocity
;; 	vc_ratio_cycl = vtots_cycl/c  & $
;; 	if vc_ratio_cycl ge 0.1 then relativistic_cycl = 'yes' else relativistic_cycl = 'no'  & $
;; 	f1anom = -1*vz  & $
;; 	f2anom = (2*!pi/kz[q])*(-1*fce[q]/gama - freq[q])  & $
;; 	diff = abs(f1anom-f2anom)  & $
;; 	tmp = min(diff,val)  & $
;; 	vz_anom = vz[val]     & $;m/s
;; 	vtots_anom = vz_anom/cos(pa*!dtor)   & $ ;ion velocity
;; 	vc_ratio_anom = vtots_anom/c  & $
;; 	if vc_ratio_anom ge 0.1 then relativistic_anom = 'yes' else relativistic_anom = 'no'  & $
;; 	vz_landau = 2*!pi*freq[q]/kz[q]  & $
;; 	vtots_landau = vz_landau/cos(pa*!dtor)  & $
;; 	vc_ratio_landau = vtots_landau/c  & $
;; 	if vc_ratio_landau ge 0.1 then relativistic_landau = 'yes' else relativistic_landau = 'no'  & $
;; 	Etots_cycl[q] = 0.511d6/sqrt(1-(vtots_cycl^2/c^2)) - 0.511d6  & $
;; 	Etots_anom[q] = 0.511d6/sqrt(1-(vtots_anom^2/c^2)) - 0.511d6  & $
;; 	Etots_landau[q] = 0.511d6/sqrt(1-(vtots_landau^2/c^2)) - 0.511d6  & $
;; 	Ez_cycl[q] = 0.511d6/sqrt(1-(vz_cycl^2/c^2)) - 0.511d6  & $
;; 	Ez_anom[q] = 0.511d6/sqrt(1-(vz_anom^2/c^2)) - 0.511d6  & $
;; 	Ez_landau[q] = 0.511d6/sqrt(1-(vz_landau^2/c^2)) - 0.511d6
        
        for q=0,n_elements(freq) - 1 do begin    
           vz = indgen(10000)*c/9999. * cos(pa*!dtor)    
           gama = 1/sqrt(1-(vz/c/cos(pa*!dtor))^2) ;relativistic gamma factor
           f1cycl = vz   
           f2cycl = (2*!pi/kz[q])*(1*fce[q]/gama - freq[q])  
           diff = abs(f1cycl-f2cycl)  
           tmp = min(diff,val)  
           vz_cycl = vz[val]                  ;m/s
           vtots_cycl = vz_cycl/cos(pa*!dtor) ;electron velocity
           vc_ratio_cycl = vtots_cycl/c  
           if vc_ratio_cycl ge 0.1 then relativistic_cycl = 'yes' else relativistic_cycl = 'no'  
           f1anom = -1*vz  
           f2anom = (2*!pi/kz[q])*(-1*fce[q]/gama - freq[q])  
           diff = abs(f1anom-f2anom)  
           tmp = min(diff,val)  
           vz_anom = vz[val]                  ;m/s
           vtots_anom = vz_anom/cos(pa*!dtor) ;ion velocity
           vc_ratio_anom = vtots_anom/c  
           if vc_ratio_anom ge 0.1 then relativistic_anom = 'yes' else relativistic_anom = 'no'  
           vz_landau = 2*!pi*freq[q]/kz[q]  
           vtots_landau = vz_landau/cos(pa*!dtor)  
           vc_ratio_landau = vtots_landau/c  
           if vc_ratio_landau ge 0.1 then relativistic_landau = 'yes' else relativistic_landau = 'no'  
           Etots_cycl[q] = 0.511d6/sqrt(1-(vtots_cycl^2/c^2)) - 0.511d6  
           Etots_anom[q] = 0.511d6/sqrt(1-(vtots_anom^2/c^2)) - 0.511d6  
           Etots_landau[q] = 0.511d6/sqrt(1-(vtots_landau^2/c^2)) - 0.511d6  
           Ez_cycl[q] = 0.511d6/sqrt(1-(vz_cycl^2/c^2)) - 0.511d6  
           Ez_anom[q] = 0.511d6/sqrt(1-(vz_anom^2/c^2)) - 0.511d6  
           Ez_landau[q] = 0.511d6/sqrt(1-(vz_landau^2/c^2)) - 0.511d6
        endfor
        store_data,'E_cycl',data={x:spec.x,y:Etots_cycl/1000.}
        store_data,'Ez_cycl',data={x:spec.x,y:Ez_cycl/1000.}


;*************************

	freq = freqbottom
	theta_k = fltarr(n_elements(freq))

	;Find the theta_kb value of the requested freq
	;; for i=0L,n_elements(freq)-1 do begin   $
	;; 	goo = where(thk.v ge freq[i])   & $
	;; 	if goo[0] ne -1 then theta_k[i] = thk.y[i,goo[0]] else theta_k[i] = 0.
	for i=0L,n_elements(freq)-1 do begin   
		goo = where(thk.v ge freq[i])  
		if goo[0] ne -1 then theta_k[i] = thk.y[i,goo[0]] else theta_k[i] = 0.
             endfor
                
	store_data,'theta_k_bottom',data={x:spec.x,y:theta_k}

	kvec = sqrt(4*!pi^2*fpe^2*freq/(c^2*(fce*cos(theta_k*!dtor)-freq)))
	;kvec = 1./1000.   ;1/m
	
	kz = abs((kvec)*cos(theta_k*!dtor))
	

	Etots_cycl = fltarr(n_elements(spec.x))
	Etots_anom = fltarr(n_elements(spec.x))
	Etots_landau = fltarr(n_elements(spec.x))
	Ez_cycl = fltarr(n_elements(spec.x))
	Ez_anom = fltarr(n_elements(spec.x))
	Ez_landau = fltarr(n_elements(spec.x))


;; for q=0,n_elements(freq) - 1 do begin    $
;; 	vz = indgen(10000)*c/9999. * cos(pa*!dtor)    & $
;; 	gama = 1/sqrt(1-(vz/c/cos(pa*!dtor))^2)    & $ ;relativistic gamma factor
;; 	f1cycl = vz   & $
;; 	f2cycl = (2*!pi/kz[q])*(1*fce[q]/gama - freq[q])  & $
;; 	diff = abs(f1cycl-f2cycl)  & $
;; 	tmp = min(diff,val)  & $
;; 	vz_cycl = vz[val]     & $;m/s
;; 	vtots_cycl = vz_cycl/cos(pa*!dtor)   & $ ;electron velocity
;; 	vc_ratio_cycl = vtots_cycl/c  & $
;; 	if vc_ratio_cycl ge 0.1 then relativistic_cycl = 'yes' else relativistic_cycl = 'no'  & $
;; 	f1anom = -1*vz  & $
;; 	f2anom = (2*!pi/kz[q])*(-1*fce[q]/gama - freq[q])  & $
;; 	diff = abs(f1anom-f2anom)  & $
;; 	tmp = min(diff,val)  & $
;; 	vz_anom = vz[val]     & $;m/s
;; 	vtots_anom = vz_anom/cos(pa*!dtor)   & $ ;ion velocity
;; 	vc_ratio_anom = vtots_anom/c  & $
;; 	if vc_ratio_anom ge 0.1 then relativistic_anom = 'yes' else relativistic_anom = 'no'  & $
;; 	vz_landau = 2*!pi*freq[q]/kz[q]  & $
;; 	vtots_landau = vz_landau/cos(pa*!dtor)  & $
;; 	vc_ratio_landau = vtots_landau/c  & $
;; 	if vc_ratio_landau ge 0.1 then relativistic_landau = 'yes' else relativistic_landau = 'no'  & $
;; 	Etots_cycl[q] = 0.511d6/sqrt(1-(vtots_cycl^2/c^2)) - 0.511d6  & $
;; 	Etots_anom[q] = 0.511d6/sqrt(1-(vtots_anom^2/c^2)) - 0.511d6  & $
;; 	Etots_landau[q] = 0.511d6/sqrt(1-(vtots_landau^2/c^2)) - 0.511d6  & $
;; 	Ez_cycl[q] = 0.511d6/sqrt(1-(vz_cycl^2/c^2)) - 0.511d6  & $
;; 	Ez_anom[q] = 0.511d6/sqrt(1-(vz_anom^2/c^2)) - 0.511d6  & $
;; 	Ez_landau[q] = 0.511d6/sqrt(1-(vz_landau^2/c^2)) - 0.511d6
	 
for q=0,n_elements(freq) - 1 do begin   
	vz = indgen(10000)*c/9999. * cos(pa*!dtor)    
	gama = 1/sqrt(1-(vz/c/cos(pa*!dtor))^2)     ;relativistic gamma factor
	f1cycl = vz   
	f2cycl = (2*!pi/kz[q])*(1*fce[q]/gama - freq[q])  
	diff = abs(f1cycl-f2cycl)  
	tmp = min(diff,val)  
	vz_cycl = vz[val]     ;m/s
	vtots_cycl = vz_cycl/cos(pa*!dtor)    ;electron velocity
	vc_ratio_cycl = vtots_cycl/c  
	if vc_ratio_cycl ge 0.1 then relativistic_cycl = 'yes' else relativistic_cycl = 'no'  
	f1anom = -1*vz  
	f2anom = (2*!pi/kz[q])*(-1*fce[q]/gama - freq[q])  
	diff = abs(f1anom-f2anom)  
	tmp = min(diff,val)  
	vz_anom = vz[val]     ;m/s
	vtots_anom = vz_anom/cos(pa*!dtor)    ;ion velocity
	vc_ratio_anom = vtots_anom/c  
	if vc_ratio_anom ge 0.1 then relativistic_anom = 'yes' else relativistic_anom = 'no'  
	vz_landau = 2*!pi*freq[q]/kz[q]  
	vtots_landau = vz_landau/cos(pa*!dtor)  
	vc_ratio_landau = vtots_landau/c  
	if vc_ratio_landau ge 0.1 then relativistic_landau = 'yes' else relativistic_landau = 'no'  
	Etots_cycl[q] = 0.511d6/sqrt(1-(vtots_cycl^2/c^2)) - 0.511d6  
	Etots_anom[q] = 0.511d6/sqrt(1-(vtots_anom^2/c^2)) - 0.511d6  
	Etots_landau[q] = 0.511d6/sqrt(1-(vtots_landau^2/c^2)) - 0.511d6  
	Ez_cycl[q] = 0.511d6/sqrt(1-(vz_cycl^2/c^2)) - 0.511d6  
	Ez_anom[q] = 0.511d6/sqrt(1-(vz_anom^2/c^2)) - 0.511d6  
	Ez_landau[q] = 0.511d6/sqrt(1-(vz_landau^2/c^2)) - 0.511d6
     endfor
store_data,'E_cycl_bottom',data={x:spec.x,y:Etots_cycl/1000.}
store_data,'Ez_cycl_bottom',data={x:spec.x,y:Ez_cycl/1000.}


;*************************

	freq = freqtop
	theta_k = fltarr(n_elements(freq))

	;Find the theta_kb value of the requested freq
	;; for i=0L,n_elements(freq)-1 do begin   $
	;; 	goo = where(thk.v ge freq[i])   & $
	;; 	if goo[0] ne -1 then theta_k[i] = thk.y[i,goo[0]] else theta_k[i] = 0.
	for i=0L,n_elements(freq)-1 do begin   
		goo = where(thk.v ge freq[i])  
		if goo[0] ne -1 then theta_k[i] = thk.y[i,goo[0]] else theta_k[i] = 0.
             endfor
	store_data,'theta_k_top',data={x:spec.x,y:theta_k}

	kvec = sqrt(4*!pi^2*fpe^2*freq/(c^2*(fce*cos(theta_k*!dtor)-freq)))
	;kvec = 1./1000.   ;1/m
	
	kz = abs((kvec)*cos(theta_k*!dtor))
	

	Etots_cycl = fltarr(n_elements(spec.x))
	Etots_anom = fltarr(n_elements(spec.x))
	Etots_landau = fltarr(n_elements(spec.x))
	Ez_cycl = fltarr(n_elements(spec.x))
	Ez_anom = fltarr(n_elements(spec.x))
	Ez_landau = fltarr(n_elements(spec.x))


;; for q=0,n_elements(freq) - 1 do begin    $
;; 	vz = indgen(10000)*c/9999. * cos(pa*!dtor)    & $
;; 	gama = 1/sqrt(1-(vz/c/cos(pa*!dtor))^2)    & $ ;relativistic gamma factor
;; 	f1cycl = vz   & $
;; 	f2cycl = (2*!pi/kz[q])*(1*fce[q]/gama - freq[q])  & $
;; 	diff = abs(f1cycl-f2cycl)  & $
;; 	tmp = min(diff,val)  & $
;; 	vz_cycl = vz[val]     & $;m/s
;; 	vtots_cycl = vz_cycl/cos(pa*!dtor)   & $ ;electron velocity
;; 	vc_ratio_cycl = vtots_cycl/c  & $
;; 	if vc_ratio_cycl ge 0.1 then relativistic_cycl = 'yes' else relativistic_cycl = 'no'  & $
;; 	f1anom = -1*vz  & $
;; 	f2anom = (2*!pi/kz[q])*(-1*fce[q]/gama - freq[q])  & $
;; 	diff = abs(f1anom-f2anom)  & $
;; 	tmp = min(diff,val)  & $
;; 	vz_anom = vz[val]     & $;m/s
;; 	vtots_anom = vz_anom/cos(pa*!dtor)   & $ ;ion velocity
;; 	vc_ratio_anom = vtots_anom/c  & $
;; 	if vc_ratio_anom ge 0.1 then relativistic_anom = 'yes' else relativistic_anom = 'no'  & $
;; 	vz_landau = 2*!pi*freq[q]/kz[q]  & $
;; 	vtots_landau = vz_landau/cos(pa*!dtor)  & $
;; 	vc_ratio_landau = vtots_landau/c  & $
;; 	if vc_ratio_landau ge 0.1 then relativistic_landau = 'yes' else relativistic_landau = 'no'  & $
;; 	Etots_cycl[q] = 0.511d6/sqrt(1-(vtots_cycl^2/c^2)) - 0.511d6  & $
;; 	Etots_anom[q] = 0.511d6/sqrt(1-(vtots_anom^2/c^2)) - 0.511d6  & $
;; 	Etots_landau[q] = 0.511d6/sqrt(1-(vtots_landau^2/c^2)) - 0.511d6  & $
;; 	Ez_cycl[q] = 0.511d6/sqrt(1-(vz_cycl^2/c^2)) - 0.511d6  & $
;; 	Ez_anom[q] = 0.511d6/sqrt(1-(vz_anom^2/c^2)) - 0.511d6  & $
;; 	Ez_landau[q] = 0.511d6/sqrt(1-(vz_landau^2/c^2)) - 0.511d6
for q=0,n_elements(freq) - 1 do begin   
	vz = indgen(10000)*c/9999. * cos(pa*!dtor)    
	gama = 1/sqrt(1-(vz/c/cos(pa*!dtor))^2)     ;relativistic gamma factor
	f1cycl = vz   
	f2cycl = (2*!pi/kz[q])*(1*fce[q]/gama - freq[q])  
	diff = abs(f1cycl-f2cycl)  
	tmp = min(diff,val)  
	vz_cycl = vz[val]     ;m/s
	vtots_cycl = vz_cycl/cos(pa*!dtor)    ;electron velocity
	vc_ratio_cycl = vtots_cycl/c  
	if vc_ratio_cycl ge 0.1 then relativistic_cycl = 'yes' else relativistic_cycl = 'no'  
	f1anom = -1*vz  
	f2anom = (2*!pi/kz[q])*(-1*fce[q]/gama - freq[q])  
	diff = abs(f1anom-f2anom)  
	tmp = min(diff,val)  
	vz_anom = vz[val]     ;m/s
	vtots_anom = vz_anom/cos(pa*!dtor)    ;ion velocity
	vc_ratio_anom = vtots_anom/c  
	if vc_ratio_anom ge 0.1 then relativistic_anom = 'yes' else relativistic_anom = 'no'  
	vz_landau = 2*!pi*freq[q]/kz[q]  
	vtots_landau = vz_landau/cos(pa*!dtor)  
	vc_ratio_landau = vtots_landau/c  
	if vc_ratio_landau ge 0.1 then relativistic_landau = 'yes' else relativistic_landau = 'no'  
	Etots_cycl[q] = 0.511d6/sqrt(1-(vtots_cycl^2/c^2)) - 0.511d6  
	Etots_anom[q] = 0.511d6/sqrt(1-(vtots_anom^2/c^2)) - 0.511d6  
	Etots_landau[q] = 0.511d6/sqrt(1-(vtots_landau^2/c^2)) - 0.511d6  
	Ez_cycl[q] = 0.511d6/sqrt(1-(vz_cycl^2/c^2)) - 0.511d6  
	Ez_anom[q] = 0.511d6/sqrt(1-(vz_anom^2/c^2)) - 0.511d6  
	Ez_landau[q] = 0.511d6/sqrt(1-(vz_landau^2/c^2)) - 0.511d6
     endfor
store_data,'E_cycl_top',data={x:spec.x,y:Etots_cycl/1000.}
store_data,'Ez_cycl_top',data={x:spec.x,y:Ez_cycl/1000.}

;--------------------


;Re-NAN values that have been interpolated
;get_data,'freqmax_smoothed',data=ff
get_data,'freqmaxtmp2_smoothed2',data=ff
goo = where(finite(ff.y) eq 0.)
if goo[0] ne -1 then freqtop[goo] = !values.f_nan
if goo[0] ne -1 then freqbottom[goo] = !values.f_nan
if goo[0] ne -1 then freqm[goo] = !values.f_nan
get_data,'E_cycl_bottom',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'E_cycl_bottom',data=ff
get_data,'E_cycl_top',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'E_cycl_top',data=ff
get_data,'E_cycl',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'E_cycl',data=ff
get_data,'Bfield_chorusint',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'Bfield_chorusint',data=ff
get_data,'amp_max',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'amp_max',data=ff


get_data,'theta_k_bottom',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'theta_k_bottom',data=ff
get_data,'theta_k_top',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'theta_k_top',data=ff
get_data,'theta_k_max',data=ff
if goo[0] ne -1 then ff.y[goo] = !values.f_nan
store_data,'theta_k_max',data=ff


store_data,'thk2_comb',data=['thk2','freqmax_smoothed','freqbottom_smoothed','freqtop_smoothed']
options,'freqbottomtmp2_smoothed2','colors',250
options,'freqtoptmp2_smootheds','colors',200
options,['freqmaxtmp2_smoothed2','freqbottommp2_smoothed2','freqtoptmp2_smoothed2'],'thick',3

stop


get_data,'freqtoptmp2_smoothed2',data=freqtop
freqtop = freqtop.y
get_data,'freqbottomtmp2_smoothed2',data=freqbottom
freqbottom = freqbottom.y
get_data,'freqmaxtmp2_smoothed2',data=freqm
freqm = freqm.y

store_data,'chorus_bandwidth',data={x:spec.x,y:(abs(freqtop-freqbottom))}
store_data,'chorus_bandwidth2',data={x:spec.x,y:(abs(freqm-freqbottom))}

ylim,['theta_k_bottom','theta_k_top','theta_k_max'],0,180
tplot,['theta_k_bottom','theta_k_top','theta_k_max','chorus_bandwidth']

;slightly values for a pretty plot. They're very noisy
rbsp_detrend,['theta_k_bottom','theta_k_top','theta_k_max','chorus_bandwidth'],60.*1  ;0.2
store_data,'theta_kb_all_smoothed',data=['theta_k_bottom_smoothed','theta_k_top_smoothed','theta_k_max_smoothed']
store_data,'theta_kb_all',data=['theta_k_bottom','theta_k_top','theta_k_max']
options,['theta_kb_all_smoothed'],'colors',[250,200,0]
options,['theta_kb_all'],'colors',[250,200,0]

rbsp_detrend,['E_cycl_bottom','E_cycl_top','E_cycl'],60.*1  ;0.2
store_data,'E_cycl_comb_smoothed',data=['E_cycl_bottom_smoothed','E_cycl_top_smoothed','E_cycl_smoothed']
store_data,'E_cycl_comb',data=['E_cycl_bottom','E_cycl_top','E_cycl']
options,['E_cycl_comb_smoothed'],'colors',[250,200,0]
options,['E_cycl_comb'],'colors',[250,200,0]


ylim,['E_cycl_comb','E_cycl_comb_smoothed'],1,1000,1
ylim,['spec_max','spec_max_smoothed'],100,3000,1
ylim,'thk2_comb',100,3000,1
;zlim,['spec_max','spec_max_smoothed'],0.1,50,1
zlim,['spec_max','spec_max_smoothed'],1d-8,1,1
ylim,'spec_max_smoothed',100,3000,1


options,['chorus_bandwidth_smoothed','theta_kb_all_smoothed','E_cycl_comb_smoothed'],'panel_size',0.7

;tplot,['E_cycl_comb','spec_max','chorus_bandwidth','densitya_smoothed','rbspa_emfisis_quicklook_Magnitude_smoothed']
;tplot,['spec_max','thk2_comb','E_cycl_comb','chorus_bandwidth','theta_kb_all','dn_n','densitya_smoothed2','rbspa_emfisis_quicklook_Magnitude_smoothed2']
tplot,['Bfield_chorusint','specfin2','spec_max_smoothed','chorus_bandwidth_smoothed','thk2_comb','theta_kb_all_smoothed','E_cycl_comb_smoothed','freqtoptmp2_smoothed2','freqbottomtmp2_smoothed2','freqmaxtmp2_smoothed2']



stop



;----------------------------
;TEST VALUES BEFORE SENDING
;----------------------------

tplot,['Bfield_chorusint','rbspa_emfisis_l3_4sec_gse_Magnitude2','densitya2','freqtoptmp2_smoothed2','freqbottomtmp2_smoothed2','freqmaxtmp2_smoothed2']
tlimit,t0,t1

;rbsp_detrend,['rbspa_emfisis_quicklook_Magnitude_smoothed2','densitya_smoothed2'],60.*5.
;tplot,['rbspa_emfisis_quicklook_Magnitude_smoothed2_detrend','densitya_smoothed2_detrend','freqtop_smoothed']
stop


;-------------------------------------------------------------------------------
;Save data for Alexa


freqtop = tsample('freqtoptmp2_smoothed2',[t0,t1],times=freqtopt)
freqbottom = tsample('freqbottomtmp2_smoothed2',[t0,t1],times=freqbottomt)
freqmax = tsample('freqmaxtmp2_smoothed2',[t0,t1],times=freqmaxt)
amp_rms_nt = tsample('Bfield_chorusint',[t0,t1],times=amp_rms_nTt)
;amp_max_nt = tsample('amp_max',[t0,t1],times=amp_max_nTt)
bandw = tsample('chorus_bandwidth_smoothed',[t0,t1],times=bandwt)
ecyclbottom = tsample('E_cycl_bottom_smoothed',[t0,t1],times=ecyclbottomt)
ecycltop = tsample('E_cycl_top_smoothed',[t0,t1],times=ecycltopt)
ecyclmax = tsample('E_cycl_smoothed',[t0,t1],times=ecyclmaxt)
mag = tsample('rbspa_emfisis_l3_4sec_gse_Magnitude2',[t0,t1],times=magt)
dens = tsample('densitya2',[t0,t1],times=denst)




;freqtop = tsample('freqtop_smoothed_smoothed',[t0,t1],times=freqtopt)
;freqbottom = tsample('freqbottom_smoothed_smoothed',[t0,t1],times=freqbottomt)
;freqmax = tsample('freqmax_smoothed_smoothed',[t0,t1],times=freqmaxt)
;amp_rms_nt = tsample('Bfield_hissint_smoothed',[t0,t1],times=amp_rms_nTt)
;amp_max_nt = tsample('amp_max_smoothed',[t0,t1],times=amp_max_nTt)

;; save,mag,magt,dens,denst,freqtop,freqtopt,freqbottom,freqbottomt,freqmax,freqmaxt,amp_rms_nT,amp_rms_nTt,amp_max_nt,amp_max_nTt,filename='~/Desktop/Jan6_vals_for_alexa_1800-2300.idl'
save,ecyclmax,ecyclmaxt,ecyclbottom,ecyclbottomt,ecycltop,ecycltopt,mag,magt,dens,denst,freqtop,freqtopt,freqbottom,freqbottomt,freqmax,freqmaxt,amp_rms_nT,amp_rms_nTt,filename='~/Desktop/Jan26_vals_for_alexa_1000-1200_RBSPa.idl'


;------------------------------------------
;RESTORE AND TEST
;-----------------------------------------

restore,'~/Desktop/Jan26_vals_for_alexa_1000-1200_RBSPa.idl'
store_data,'bmag',data={x:magt,y:mag}
store_data,'dens',data={x:denst,y:dens}
store_data,'freqtop',data={x:freqtopt,y:freqtop}
store_data,'freqbottom',data={x:freqtopt,y:freqbottom}
store_data,'freqmax',data={x:freqtopt,y:freqmax}
store_data,'amp_rms_nt',data={x:amp_rms_ntt,y:amp_rms_nt}
store_data,'ecycl_max',data={x:ecyclmaxt,y:ecyclmax}
store_data,'ecycl_bottom',data={x:ecyclbottomt,y:ecyclbottom}
store_data,'ecycl_top',data={x:ecycltopt,y:ecycltop}

store_data,'Ecyclcomb',data=['ecycl_max','ecycl_bottom','ecycl_top']
options,'Ecyclcomb','colors',[0,50,250]


tplot,'*'


;store_data,'amp_max_nt_30m',data={x:amp_max_ntt,y:amp_max_nt}

;; ;restore,'~/Desktop/Jan6_vals_for_alexa_15min_resolution.idl'
;; ;store_data,'bmag_15m',data={x:magt,y:mag}
;; ;store_data,'dens_15m',data={x:denst,y:dens}
;; restore,'~/Desktop/Jan6_vals_for_alexa_12s_resolution.idl'
;; store_data,'bmag_12s',data={x:magt,y:mag}
;; store_data,'dens_12s',data={x:denst,y:dens}
;; store_data,'freqtop_12s',data={x:freqtopt,y:freqtop}
;; store_data,'freqbottom_12s',data={x:freqtopt,y:freqbottom}
;; store_data,'freqmax_12s',data={x:freqtopt,y:freqmax}
;; store_data,'amp_rms_nt_12s',data={x:amp_rms_ntt,y:amp_rms_nt}
;; store_data,'amp_max_nt_12s',data={x:amp_max_ntt,y:amp_max_nt}

;tplot_options,'title','Various smoothing values for Alexas diffusion code'


;; rbsp_detrend,['bmag_30m','bmag_12s'],60.*0.9
;; ylim,['bmag_30m','bmag_12s'] + '_detrend',-0.3,0.3
;; tplot,['bmag_30m','bmag_12s','bmag_30m_detrend','bmag_12s_detrend']

;; rbsp_detrend,['dens_30m','dens_12s'],60.*5
;; ylim,['dens_30m','dens_12s'] + '_detrend',-30,30
;; tplot,['dens_30m','dens_12s','dens_30m_detrend','dens_12s_detrend']


;; store_data,'freqtops',data=['freqtop_30m','freqtop_12s']
;; store_data,'freqbottoms',data=['freqbottom_30m','freqbottom_12s']
;; store_data,'freqmaxs',data=['freqmax_30m','freqmax_12s']
;; options,'freqtops','colors',[0,250]
;; options,'freqbottoms','colors',[0,250]
;; options,'freqmaxs','colors',[0,250]

;; ylim,['freqtops','freqmaxs','freqbottoms'],0,400
;; tplot,['freqtops','freqmaxs','freqbottoms']


;; store_data,'amprms',data=['amp_rms_nt_30m','amp_rms_nt_12s']
;; store_data,'ampmax',data=['amp_max_nt_30m','amp_max_nt_12s']
;; options,'amprms','colors',[0,250]
;; options,'ampmax','colors',[0,250]

;; tplot,['amprms','ampmax']



;----------------------------------------------------------------


rbsp_detrend,'rbspa_emfisis_quicklook_Magnitude',60.*0.2
rbsp_detrend,'rbspa_emfisis_quicklook_Magnitude_smoothed',60.*5

tplot,['Bfield_hissint','PeakDet_2K_smoothed','densitya','rbspa_emfisis_quicklook_Magnitude']


tplot,['Bfield_hissint','PeakDet_2K_smoothed','densitya_detrend','rbspa_emfisis_quicklook_Magnitude_smoothed_detrend']

tinterpol_mxn,'PeakDet_2K_smoothed','Bfield_hissint'
tinterpol_mxn,'densitya_detrend','Bfield_hissint'
tinterpol_mxn,'rbspa_emfisis_quicklook_Magnitude_smoothed_detrend','Bfield_hissint'

x = tsample('Bfield_hissint',[t0,t1],times=tms)
store_data,'Bfield_hissint0',data={x:tms,y:x}
x = tsample('PeakDet_2K_smoothed',[t0,t1],times=tms)
store_data,'PeakDet_2K_smoothed0',data={x:tms,y:x}
x = tsample('densitya_detrend',[t0,t1],times=tms)
store_data,'densitya_detrend0',data={x:tms,y:x}
x = tsample('rbspa_emfisis_quicklook_Magnitude_smoothed_detrend',[t0,t1],times=tms)
store_data,'rbspa_emfisis_quicklook_Magnitude_smoothed_detrend0',data={x:tms,y:x}

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2K_smoothed0',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2K_smoothed0',data={x:xv,y:yv}






get_data,'Bfield_hissint0',data=dd
store_data,'Bfield_hissint0',data={x:dd.x,y:dd.y/max(abs(dd.y))}
get_data,'PeakDet_2K_smoothed0',data=dd
store_data,'PeakDet_2K_smoothed0',data={x:dd.x,y:dd.y/max(abs(dd.y))}
get_data,'densitya_detrend0',data=dd
store_data,'densitya_detrend0',data={x:dd.x,y:dd.y/max(abs(dd.y))}
get_data,'rbspa_emfisis_quicklook_Magnitude_smoothed_detrend0',data=dd
store_data,'rbspa_emfisis_quicklook_Magnitude_smoothed_detrend0',data={x:dd.x,y:dd.y/max(abs(dd.y))}


tplot,['Bfield_hissint0','PeakDet_2K_smoothed0','densitya_detrend0','rbspa_emfisis_quicklook_Magnitude_smoothed_detrend0']

tplot,['Bfield_hissint','PeakDet_2K_smoothed','densitya','rbspa_emfisis_quicklook_Magnitude']



end
