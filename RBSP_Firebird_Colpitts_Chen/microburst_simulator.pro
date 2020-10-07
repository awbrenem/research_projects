;Simulate a microburst at the location of FIREBIRD as a function of energy and time.


;f(E,t) = A(t)*exp(-1*(E - Eo)^2/deltaE(t)^2)

;A(t) = For each time step this defines the peak amplitude value and the energy it occurs at.
;deltaE = For each time step this defines the width of Gaussian curve
;Eo = time-offset of curve. Currently this is time-independent


;We want to define the functional forms of A, Eo, and deltaE such that
;the total flux (integrated over all energies) mimicks what probably happens in real life. Namely,
;it should start low, ramp up, then ramp down.

;Steps:
;1) define f(E,t) as time-varying exponential f(E) = fo*exp(-E/Eo)
;2) For each individual channel multiply f(E) by energy response (Gaussian).
;   Fch_total = integral(f(E)*fch(E)) from 0 to infinity
;   This is the instantaneous integrated energy response. If FB detectors respond very quickly
;   than we may not need to worry about a ramp-up time.
;3) Do this for all the channels and combine the signals.

;-------
;Gets more complicated if FB has a slow ramp-up response time.
;for ex: f(t) = int(F(E,t)) from 250-400




rbsp_efw_init
!p.charsize = 1.5



;For each single time (t) define a "continuous" uB flux spectrum. It won't
;actually be continuous (i.e. infinite number of values), but I'll make it have
;1000 energy bins.

nenergies = 1000.
energies = indgen(nenergies)   ;creates a 1000 element array


;Number of time steps
ntsteps = 200.


;Define deltaE (width) profile over time for each time step
deltaE = 2*indgen(ntsteps) + 300.
;***plot1
plot,indgen(ntsteps),deltaE,xtitle='time',ytitle='deltaE',title='deltaE(t) functional form'


;Define flux amplitude profile over time.
;I'm having the peak amplitude fall off as an exponential
tmax = ntsteps/2.
dt = 10.
fluxmax = exp(-1.*(indgen(ntsteps)-tmax)^2/dt^2)
!p.multi = [0,0,1]
;***plot2
plot,indgen(ntsteps),fluxmax,xtitle='time',ytitle='Flux integrated',title='I want peak flux to occur at time=10'


;Define center energy for Gaussian (this can also be a function of time)
Eo = 0.


;Construct flux array f(E,t). It'll have size [nenergies, ntsteps]
flux = fltarr(nenergies,ntsteps)
for t=0,ntsteps-1 do flux[*,t] = fluxmax[t]*exp(-1*(energies - Eo)^2/deltaE[t]^2)
;for t=0,ntsteps-1 do flux[*,t] = fluxmax[t]*exp(-1*(energies - Eo)/deltaE[t])




;Now add in a noise spectrum to this. 
scalefac = 0.8

!p.multi = [0,0,4]
for ee=0.,nenergies-1 do begin 


  etmp = ee
  noise = scalefac*(2*randomu(etmp,ntsteps) - 1.)
;  noiseS = noise * sqrt(max(flux[ee,*]) - flux[ee,*])
  noiseS = noise * sqrt(max(flux[*,*]) - flux[ee,*])
  flux[ee,*] += noiseS

;  plot,flux[ee,*]-noiseS,yrange=[-2,2]
;  plot,noise,yrange=[-2,2]
;  plot,noiseS,yrange=[-2,2]
;  plot,flux[ee,*],yrange=[-2,2]
;stop
endfor



;;***This is my check to see how the integrated flux profile changes.
;Eint_t = fltarr(ntsteps)
;for t=0,ntsteps-1 do Eint_t[t] = int_tabulated(energies,flux[*,t])
;!p.multi = [0,0,1]



;Plot flux spectra vs energy for all time steps
nrows = ceil(sqrt(ntsteps))
!p.multi = [0,nrows,nrows]
ytitles = 'flux (t=' + strtrim(indgen(ntsteps),2)+')'
for i=0,ntsteps-1 do plot,energies,flux[*,i],yrang=[0,1],xtitle='Energy (keV)',ytitle=ytitles[i]

stop

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
;plot,energies,flux[*,0],yrange=[0,1],xtitle='Energy (keV)',ytitle='flux'
;for i=0,ntsteps-1 do oplot,energies,flux[*,i],color=colorv[i]



;Plot a microburst spectrogram (Energy vs time with color indicating flux)
;****NOTE: NEED TO COMPARE THIS TO ACTUAL FIREBIRD MICROBURST FLUX.


;Karl, don't worry about what I'm doing here.
t0 = '2014-01-01'  ;dummy time
tms = time_double(t0) + dindgen(ntsteps)

store_data,'ub_spec',data={x:tms,y:transpose(flux),v:energies}
options,'ub_spec','spec',1
options,'ub_spec','ytitle','Energy (keV)'
options,'ub_spec','xtitle','time (unitless)'
options,'ub_spec','title','Simulated Microburst flux (normalized)'

ylim,'ub_spec',0,1000
zlim,'ub_spec',0.1,1,1
;***plot5
tplot,'ub_spec'

stop


;Now let's push this microburst into a simulated FIREBIRD detector
;Values from Crew16 for the collimated detector on FU4
fblow = [220.,283.,384.,520.,721.]
fbhig = [283.,384.,520.,721.,985.]
binwidth = fbhig - fblow
;dE = fbhig - fblow
dE = replicate(50.,5)
Ecenter = [251,334,452,621,852]


fbgain = fltarr(nenergies,5)

;;Assume a Gaussian response for each FB channel. (This probably isn't correct)
;for i=0,4 do fbgain[*,i] = exp(-1*(energies - Ecenter[i])^2/dE[i]^2)

;Assume a square response - may be more accurate than a Gaussian
for i=0,4 do begin $
  goo = where((energies ge fblow[i]) and (energies le fbhig[i])) & $
  fbgain[goo,i] = 1.
endfor



;Plot imagined energy response for all FB channels
!p.multi = [0,0,1]
plot,energies,fbgain[*,0]
for i=0,4 do oplot,energies,fbgain[*,i]



;Multiply the FB energy gain by the incident uB flux for each time.
Fch_total = fltarr(5,ntsteps)

for t=0,ntsteps-1 do begin

  fluxtmp = reform(flux[*,t])

  flux_after_fb = fltarr(nenergies,5)
  for i=0,4 do flux_after_fb[*,i] = fluxtmp*fbgain[*,i]


;;  ;plot output of FB detector at each time
;  !p.multi = [0,0,3]
;  plot,energies,fluxtmp  ;total flux vs energy at current time
;  plot,energies,fbgain[*,0],yrange=[0,2]  ;FB gain channels
;  for i=0,4 do oplot,energies,fbgain[*,i],color=50*i
;  plot,energies,flux_after_fb[*,0]
;  for i=0,4 do oplot,energies,flux_after_fb[*,i],color=50*i
;stop


  ;Now integrate the FB fluxes for each channel over all energies.
  ;Also divide out bin width
  for i=0,4 do Fch_total[i,t] = int_tabulated(energies,flux_after_fb[*,i])/binwidth[i]


endfor ;each time



;Plot resultant uB after FIREBIRD detect

store_data,'uB_after_detection',tms,transpose(Fch_total)
split_vec,'uB_after_detection',suffix='_'+['220','283','384','520','721']
ylim,'uB_after_detection_'+['220','283','384','520','721'],0,max(Fch_total)

options,'uB_after_detection_220','colors',0
options,'uB_after_detection_283','colors',50
options,'uB_after_detection_384','colors',100
options,'uB_after_detection_520','colors',150
options,'uB_after_detection_721','colors',200

tplot,['ub_spec','uB_after_detection_721','uB_after_detection_520','uB_after_detection_384','uB_after_detection_283','uB_after_detection_220']


;!p.charsize = 2
;!p.multi = [0,0,5]
;for i=0,4 do plot,Fch_total[4-i,*],xtitle='time',ytitle='FB channel = '+strtrim(fblow[4-i],2)

stop


end
