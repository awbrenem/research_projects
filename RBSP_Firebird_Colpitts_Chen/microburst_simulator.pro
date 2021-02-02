;Simulate a microburst at the location of FIREBIRD as a function of energy and time.


;f(E,t) = A(t)*exp(-1*(E - Eo)/deltaE(t))

;A(t) = For each time step this defines the peak amplitude value and the energy it occurs at.
;dE = For each time step this defines the width of Gaussian curve
;Eo = time-offset of curve. Currently this is time-independent


;We want to define the functional forms of A, Eo, and dE such that
;the total flux (integrated over all energies) mimicks what probably happens in real life. Namely,
;it should start low, ramp up, then ramp down.

;Steps:
;1) define f(E,t) as time-varying exponential f(E) = fo*exp(-E/Eo)
;2) For each individual channel multiply f(E) by energy response (Gaussian).
;   Fch_integrated = integral(f(E)*fch(E)) from 0 to infinity
;   This is the instantaneous integrated energy response. If FB detectors respond very quickly
;   than we may not need to worry about a ramp-up time.
;3) Do this for all the channels and combine the signals.

;-------
;Gets more complicated if FB has a slow ramp-up response time.
;for ex: f(t) = int(F(E,t)) from 250-400




rbsp_efw_init
!p.charsize = 1.5




;------------------------------------------------------------------------
;Define microburst parameters
;------------------------------------------------------------------------

;energy profile --> exp(-(E-Eo)/dE)
nenergies = 1000. ;number of microburst energy steps
emin_keV = 0. 
emax_keV = 1000.
energies_uB = (emax_keV - emin_keV)*indgen(nenergies)/(nenergies-1) + emin_keV   ;creates a 1000 element array
Eo = 0. ;Center energy for Gaussian
dE = 300. ;Width of energy Gaussian curve (keV)


;time profile  (exp(-(t-to)^2/dt^2))
ntsteps = 100. ;number of microburst time steps
tend_sec = 1.  ;total time duration considered in seconds (microburst contained within this)
;tpeak_sec = 0. ;***NOT YET IMPLEMENTED  time when the peak of the microburst occurs for the first energy channel. 
;(note that due to dispersion this time will vary with energy)
dt = 0.1  ;Width (sec) of the exponential falloff
;to = 0.  ;NOT YET IMPLEMENTED********
t_dispersion = 0.5 ;sec  - delta time b/t lowest and highest energy channels



;Define FIREBIRD detector channels
;Values from Crew16 for the collimated detector on FU4
fblow = [220.,283.,384.,520.,721.]
fbhig = [283.,384.,520.,721.,985.]
nchannels = n_elements(fblow)




;----------------------------------------------------------------------------
;Define time variation of flux --> exp(-t^2/dt^2) for first energy bin. 
;----------------------------------------------------------------------------


tstep_sec = tend_sec/ntsteps   ;number of seconds per time tick
times_sec = indgen(ntsteps)*tstep_sec ;times (sec) b/t 0 and tend_sec

flux_tprofile_zeroenergy = exp(-1.*times_sec^2/dt^2)
flux_tprofile_zeroenergy = [reverse(flux_tprofile_zeroenergy),flux_tprofile_zeroenergy] ;full Gaussian

!p.multi = [0,0,1]
ttmp = [-1*reverse(times_sec),times_sec]
plot,ttmp,flux_tprofile_zeroenergy,xtitle='time(sec)',ytitle='Flux profile for zeroth energy'


;------------------------------------------------------------------------------
;Now add in dispersion for the higher energy bins
;------------------------------------------------------------------------------

;First calculate the amount of dispersion from one energy channel to the next. 
;This [e,t] array consists of only normalized Gaussians^2 for  

dt_sec_singlechannel_jump = t_dispersion/nenergies   ;dispersive time shift (sec) from one energy channel to the next

;sec_per_tbin = dt_sec_singlechannel_jump*ntsteps
sec_per_tbin = tend_sec/ntsteps  ;how many seconds in each time grid chunk?


dt_bin_singlechannel_jump = dt_sec_singlechannel_jump/sec_per_tbin   ;number of grid time steps to shift by to have every successive energy peak arrive dt (sec) later 

flux_tprofile = fltarr(nenergies,ntsteps)

;for i=0,nenergies-1 do print,dt_bin_singlechannel_jump*i
for i=0,nenergies-1 do begin $
  tmp = shift(flux_tprofile_zeroenergy,dt_bin_singlechannel_jump*i) & $
  flux_tprofile[i,*] = tmp[ntsteps:(ntsteps*2)-1]
endfor


;!p.multi = [0,0,1]
;plot,times_sec,flux_tprofile[40.,*],yrange=[0,1],xtitle='time(sec)',ytitle='flux for specific energies',title='Dispersion test'
;for e=0,nenergies-1 do oplot,times_sec,flux_tprofile[e,*],color=e/20

t0 = '2014-01-01'  ;dummy time
tms = time_double(t0) + double(times_sec)

store_data,'ub_timevariation',data={x:tms,y:transpose(flux_tprofile),v:energies_uB}
options,'ub_timevariation','spec',1
options,'ub_timevariation','ytitle','Energy (keV)'
options,'ub_timevariation','xtitle','time (unitless)'
options,'ub_timevariation','title','Simulated Microburst time variation (normalized)'

ylim,'ub_timevariation',0,1000
zlim,'ub_timevariation',0,1,0
;Plot the normalized dispersive time signature
tplot,'ub_timevariation'










;Construct flux array f(E,t). It'll have size [nenergies, ntsteps]
flux = flux_tprofile 
for i=0,ntsteps-1 do flux[*,i] *= exp(-1*(energies_uB - Eo)/dE)


store_data,'ub_spec_nonoise',data={x:tms,y:transpose(flux),v:energies_uB}
options,'ub_spec_nonoise','spec',1
options,'ub_spec_nonoise','ytitle','Energy (keV)'
options,'ub_spec_nonoise','xtitle','time (unitless)'
options,'ub_spec_nonoise','title','Simulated Microburst flux (normalized)!Cno noise'

ylim,'ub_spec_nonoise',0,1000
zlim,'ub_spec_nonoise',0.1,1,1
;***plot5
tplot,['ub_timevariation','ub_spec_nonoise']




;Now add in a noise spectrum to this. 
scalefac = 0.4
fluxN = flux

!p.multi = [0,0,4]
for ee=0.,nenergies-1 do begin $
  etmp = ee & $
  noise = scalefac*(2*randomu(etmp,ntsteps) - 1.) & $
  noiseS = noise * sqrt(max(flux[*,*]) - flux[ee,*]) & $
  fluxN[ee,*] += noiseS
endfor



;;***This is my check to see how the integrated flux profile changes.
;Eint_t = fltarr(ntsteps)
;for t=0,ntsteps-1 do Eint_t[t] = int_tabulated(energies_uB,flux[*,t])
;!p.multi = [0,0,1]



;;Plot flux spectra vs energy for all time steps
;nrows = ceil(sqrt(ntsteps))
;!p.multi = [0,nrows,nrows]
;ytitles = 'flux (t=' + strtrim(indgen(ntsteps),2)+')'
;for i=0,ntsteps-1 do plot,energies_uB,fluxN[*,i],yrange=[0,1],xtitle='Energy (keV)',ytitle=ytitles[i]

;stop

;fluxorig = flux

;noisesize = 0.1*fluxmax
;;
;;Add random noise to flux
;for t=0,ntsteps-1 do begin $
;  ttmp = t & $
;  noise = 0.2*(randomu(ttmp,nenergies)) & $
;  noise_mod = noise / flux[*,t] & $
;  flux[*,t] += noise_mod
;endfor
;
;!p.multi = [0,0,3]
;plot,fluxorig[*,100]
;plot,flux[*,100]
;plot,noise_mod
;stop

;;Make a plot of all times stacked on top of each other
;;--define colors
;deltac = 256/ntsteps - 1
;colorv = deltac*indgen(ntsteps)
;!p.multi = [0,0,1]
;plot,energies_uB,flux[*,0],yrange=[0,1],xtitle='Energy (keV)',ytitle='flux'
;for i=0,ntsteps-1 do oplot,energies_uB,flux[*,i],color=colorv[i]



;Plot a microburst spectrogram (Energy vs time with color indicating flux)
;****NOTE: NEED TO COMPARE THIS TO ACTUAL FIREBIRD MICROBURST FLUX.



store_data,'ub_spec_wnoise',data={x:tms,y:transpose(fluxN),v:energies_uB}
options,'ub_spec_wnoise','spec',1
options,'ub_spec_wnoise','ytitle','Energy (keV)'
options,'ub_spec_wnoise','xtitle','time (unitless)'
options,'ub_spec_wnoise','title','Simulated Microburst flux (normalized)'

ylim,'ub_spec_wnoise',0,1000
zlim,'ub_spec_wnoise',0.1,1,1
tplot,['ub_timevariation','ub_spec_nonoise','ub_spec_wnoise']

stop


;---------------------------------------------------------------------
;Now let's push this microburst into a simulated FIREBIRD detector
;---------------------------------------------------------------------


binwidth = fbhig - fblow
;Ecenter = [251,334,452,621,852]
Ecenter = (fblow + fbhig)/2.
fb_channel_resp = fltarr(nenergies,nchannels)


;;Assume a Gaussian response for each FB channel. (This probably isn't correct)
;;dE = fbhig - fblow
;dE = replicate(50.,nchannels)
;for i=0,4 do fb_channel_resp[*,i] = exp(-1*(energies_uB - Ecenter[i])^2/dE[i]^2)


;Assume a square response for each FB channel - may be more accurate than a Gaussian
for i=0,4 do begin $
  goo = where((energies_uB ge fblow[i]) and (energies_uB le fbhig[i])) & $
  fb_channel_resp[goo,i] = 1.
endfor
;Plot imagined energy response for all FB channels
!p.multi = [0,0,1]
plot,energies_uB,fb_channel_resp[*,0],yrange=[0,1.2]
for i=0,4 do oplot,energies_uB,fb_channel_resp[*,i],color=50*i





;Multiply the FB channel response by the incident uB flux for each time.
Fch_integrated = fltarr(nchannels,ntsteps)

;Choose which array to use 
;fluxfin = flux_tprofile  ;normalized time profile 
;fluxfin = flux  ;flux with NO noise
fluxfin = fluxN  ;flux with noise added

for t=0,ntsteps-1 do begin $
  fluxtmp = reform(fluxfin[*,t]) & $
  flux_after_fb = fltarr(nenergies,nchannels) & $
  for i=0,nchannels-1 do flux_after_fb[*,i] = fluxtmp*fb_channel_resp[*,i] & $
  ;Now integrate the FB fluxes for each channel over all energies.
  ;Also divide out bin width
  for i=0,nchannels-1 do Fch_integrated[i,t] = int_tabulated(energies_uB,flux_after_fb[*,i])/binwidth[i]

endfor ;each time




;;  ;plot output of FB detector at each time
;  !p.multi = [0,0,3]
;  plot,energies_uB,fluxtmp  ;total flux vs energy at current time
;  plot,energies_uB,fb_channel_resp[*,0],yrange=[0,2]  ;FB gain channels
;  for i=0,4 do oplot,energies_uB,fb_channel_resp[*,i],color=50*i
;  plot,energies_uB,flux_after_fb[*,0]
;  for i=0,4 do oplot,energies_uB,flux_after_fb[*,i],color=50*i
;stop




;Plot resultant uB after FIREBIRD detect

store_data,'uB_after_detection',tms,transpose(Fch_integrated)
split_vec,'uB_after_detection',suffix='_'+['220','283','384','520','721']
ylim,'uB_after_detection_'+['220','283','384','520','721'],0,max(Fch_integrated)

options,'uB_after_detection_220','colors',0
options,'uB_after_detection_283','colors',50
options,'uB_after_detection_384','colors',100
options,'uB_after_detection_520','colors',150
options,'uB_after_detection_721','colors',200

ylim,['ub_spec_nonoise','ub_spec_wnoise'],200,1000
tplot,['ub_spec_nonoise','ub_spec_wnoise','uB_after_detection_721','uB_after_detection_520','uB_after_detection_384','uB_after_detection_283','uB_after_detection_220']


;!p.charsize = 2
;!p.multi = [0,0,5]
;for i=0,4 do plot,Fch_integrated[4-i,*],xtitle='time',ytitle='FB channel = '+strtrim(fblow[4-i],2)

stop


end




;;Define deltaE (width) profile over time for each time step
;deltaE = 2*indgen(ntsteps) + 300.
;;***plot1
;plot,indgen(ntsteps),deltaE,xtitle='time',ytitle='deltaE',title='deltaE(t) functional form'
