;Calculate flux tube content for MagEIS
;e0 = 29-41
;e1 = 46-66
;e2 = 68-92
;e3 = 95-126
;e4 = 126-164
;e5 = 164-204
;e6 = 206-247

;PA resolved MagEIS HIRES files have values of
;flux = #/s-sr-cm2-keV-deg
;Strategy is to integrate the area under the curve of the e6 channel (one
;with overlap with FB). This totals up over all PA giving
;flux = #/s-sr-cm2-keV


;Values used
;MagEIS integrated flux from 0-90 deg:  fme = 19621.

;Aaron's value for the "average-looking" uB at 43:56.800
  ;duty_cycle = .163  seconds/uB
  ;ffb = 32.  ;averaged uB flux value over 163 msec
  ;ub_number_per_second = 0.4  ;uB per second (0.6 seems too high)

  ;ffb_eff = ffb*duty_cycle*ub_number_per_second   ;#/cm2-s-sr-keV



path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/MagEIS/MagEISA_HRPADs_4AaronB_20Jan2016_1940UT/'

;Read the flux values
fn = 'rbspa_mageis_elec_flux_hr_pa_e6_sub.txt'
openr,lun,path+fn,/get_lun
jnk = ''
i=0.
while not eof(lun) do begin
  readf,lun,jnk
  vals = strsplit(jnk,' ',/extract)
  if i eq 0 then flux = vals[1:n_elements(vals)-1] else flux = [[flux],[vals[1:n_elements(vals)-1]]]
  if i eq 0 then times = vals[0] else times = [times,vals[0]]
  i++
endwhile
close,lun
free_lun,lun




;Read the PA bins
fn = 'rbspa_mageis_elec_flux_hr_pa_e6_sub_v.txt'
openr,lun,path+fn,/get_lun
jnk = ''
readf,lun,jnk
pa1 = jnk
readf,lun,jnk
pa2 = jnk
readf,lun,jnk
pa3 = jnk

pa1 = strsplit(pa1,' ',/extract)
pa2 = strsplit(pa2,' ',/extract)
pa3 = strsplit(pa3,' ',/extract)
goo = where(pa3 ge 0)

pa = [pa1,pa2,pa3[goo]]
goo = where(pa le 180.)

pa = pa[goo]

close,lun
free_lun,lun

flux = double(flux)


;Plot data (we'll average this over 3 consecutive spin periods)
;t = time_double('2016-01-20/19:39:45')
t = time_double('2016-01-20/19:43:48')
tboo = where(time_double(times) ge t)

stop
vals3ptavg = (flux[goo,tboo[0]] + flux[goo,tboo[1]] + flux[goo,tboo[2]])/3.
pa = float(pa)

!p.charsize = 1.5
plot,pa,vals3ptavg,psym=-5,yrange=[4d2,2d4],/ylog,ystyle=1,xrange=[0,180],$
  xstyle=1,title='MagEIS PA distribution for 206-247 keV channel',xtitle='PA[deg]',ytitle='#/cm2-s-sr-keV'
xyouts,0.4,0.5,/normal,'3 consecutive MagEIS PADs averaged!Cstarting at '+time_string(times[tboo[0]])
;plot,pa,vals3ptavg,psym=-5,yrange=[0,2d4],ystyle=1,xrange=[0,180],$
;  xstyle=1,title='MagEIS PA distribution for 206-247 keV channel',xtitle='PA[deg]',ytitle='#/cm2-s-sr-keV'
;xyouts,0.4,0.5,/normal,'3 consecutive MagEIS PADs averaged!Cstarting at '+time_string(times[tboo[0]])


;Extrapolate MagEIS energies to the loss cone using sin^n
vals = indgen(90)*!dtor
vals2 = (indgen(90)+90.)*!dtor
poo = where((pa ge 88) and (pa le 92))
;peak=11000. ;peak flux value at 90 deg for peak*sin^n fit
;expon = indgen(10)*0.6 + 1

ep = 1.8
;overplot sin^n curves
oplot,vals/!dtor,14000.*sin(vals)^ep,color=250 & oplot,vals2/!dtor,14000.*sin(vals2)^ep,color=250
oplot,vals/!dtor,12000.*sin(vals)^ep,color=250 & oplot,vals2/!dtor,12000.*sin(vals2)^ep,color=250
oplot,vals/!dtor,10000.*sin(vals)^ep,color=250 & oplot,vals2/!dtor,10000.*sin(vals2)^ep,color=250

;*********************************************************
;*********************************************************
;*********************************************************


;Best fit seems to be
;int (peak*sin(x)^1.8) = 12000. ;integrated from 0 - 180
;fme1 = 11944.  ;for peak=14000.
;fme2 = 11091.  ;for peak=13000
;fme3 = 9384    ;for peak=11000
;fme = [fme1,fme2,fme3]
fme = 20000.

;this is the MagEIS flux in the ~250 keV energy channel integrated over all PA



;**************************************
;Same calculation for FIREBIRD.
;From Arlo's email on 09/13/2017
;"I've integrated 150 ms across the max of your data (12 data points)
;from 19:43:56.5125 to 19:43:56.6625. Here's what I got for the averages:"
;Col_flux_0            50.723879
;Col_flux_1            26.643010
;Col_flux_2             8.534504
;Col_flux_3             1.859244
;Col_flux_4             0.199026

;John Sample's email indicates that GEANT results mean I should multiply these
;flux values by (9/4.94)
;For the uB marked with X this gives me 92.4 #/cm2-s-sr-keV for 220-280 keV channel  (=50.7*9/4.94)
;************************************

;duty_cycle = 0.15           ;seconds per uB (the amount of time Arlo averaged over)
;ffb = 92.4  ;Arlo's averaged value over 150 msec, with the applied GF of 9/4.94
;;Subtract off the background counts. For the X microburst, background about 60 counts.
;frac_background = 0.25  ;25% of the flux is background (VERIFIED)
;ffb = ffb*(1-frac_background)  ;#/cm2-s-sr-keV for 220-280 keV channel  (=50.7*9/4.94)

;Aaron's value for the "average-looking" uB at 43:56.800
duty_cycle = .235
ffb = 69  ;average value over span of uB (average of a number of uB) (background Subtracted)


;Note that intensities are preserved when mapping down field lines. This is b/c
;of the exactly competing factors of increased area and decreased loss cone size.
;(see Dombeck and Scott's calculations)

;Consider duty cycle. The MagEIS values are per second.
;The microbursts only last a fraction of a sec.
;I estimate (visual 1/e falloff) they last for about 150 msec
;From a FWHM method I'm finding that most of the uB on this pass range
;from about 240-330 msec.


ub_number_per_second = 0.36  ;uB per second (0.6 seems too high)
ffb_eff = ffb*duty_cycle*ub_number_per_second   ;#/cm2-s-sr-keV



;Number of uB it would take to deplete the flux tube
fluxRAT = fme/ffb_eff
print,fluxRAT


;So, it would take this many uB of size 114/cm2-s-sr-keV to deplete all of the
;flux (at all PA) MagEIS sees in the ~250 keV channel.
;Assuming about 6 uB of this size every 10 sec (from conjunction), or about
;0.6 uB/sec, the total time to deplete this flux tube is:
ttime = fluxRAT/60d/ub_number_per_second  ;minutes
print,ttime




;This time is for any representative cross-section within the microburst region.
;It already takes into account duty cycle and fill factor and is therefore
;the combination of both microbursts and empty space.
;So, the total time to deplete a drift shell then only depends on the fraction
;of MLT the microbursts exist over.

totaltime_driftshell = ttime/(5/24.)
print,totaltime_driftshell/60.  ; hours

stop


















;*****************************************************
;*****************************************************
;....OLD
;*****************************************************
;*****************************************************


;**********************************
;Time to deplete entire drift shell
;**********************************
;Assume each uB has a diameter of 100 km. Integrate over a thin ring
;of thickness 100 km to find integral MagEIS flux in this ring.


Bo_fb = 44211.  ;dip model  (at 500 km) for L=5.5
Bo_me = 144. ;nT  (at 19:43:55 UT)

radius_rat = sqrt(Bo_fb/Bo_me)
;16

;Say the uB size is 10 km at the 500 km alt of FIREBIRD
dr = radius_rat * 10.
;162  ;km

r = 5.5*6370.
area_ring = !pi*((r + 2*dr)^2 - r^2)
area_ring *= 1000d^2 * 100^2
;   7.1966504e+17  cm2




;Total MagEIS population in flux tube is
fme_tot = fme2 * area_ring
;      7.9818050e+21  e-/s-sr-keV

;****Aaron's estimate of fill factor
;;Estimate fill factor of uB in this ring.
;If a uB has a 10 km diameter, and FIREBIRD sees 1 uB/sec while traveling 10 km/s
;then it’s always inside of a uBs (assuming they last for 1 sec).
;If they last for 70 msec, then this gives us a fill factor of 0.07.
;ff = 0.07

;vel_fb = 7.7  ;km/s
;duration = .150 ;sec
;radius_fb = 10. ;km
;ff = vel_fb*duration/radius_fb
;*************************************

;Alex's estimate of fill factor
ff = ub_number_per_second * duty_cycle
;0.06


;Let's correct this fill factor by considering that uB only exist in a 6 hr wedge
mlt_wedge = 6.  ;hrs
ff = ff * (mlt_wedge/24.)

area_eff_ub = ff * area_ring
;      1.0794976e+16



areaRAT = area_ring/area_eff_ub
;       66

;So, if it takes the uB "ttime" min to clear out a single flux tube, then they
;will be 1/areaRAT as effective at clearing out the entire drift shell.
totaltime_driftshell = areaRAT * ttime/60.  ;hours
;          132.98771       123.49018       104.48398
;       5.5411545       5.1454240       4.3534990  (days)







stop



end






;;;limit PAs used in integration
;too = where(pa le 90.)
;print,pa[too]
;oplot,pa[too],vals3ptavg[too],color=250,thick=2


;;rough and tough integration of flux over all pitch angles
;dps = !dtor*(pa[too] - shift(pa[too],1))
;areas = fltarr(n_elements(dps))

;for i=0, n_elements(dps)-1 do areas[i] = dps[i] * vals3ptavg[i]
;bboo = where(areas lt 0.)
;if bboo[0] ne -1 then areas[bboo] = 0.

;area = 2.*total(areas,/nan)  ;factor of 2 mirrors the 0-90 results to 0-180.
                             ;I do this b/c the 90-180 counts don't go as close
                             ;to loss cone.
;print,area  ;#/cm2-s-sr-keV  integrated over all PA





;;Energy channel width is e6 = 206-247 = 41 keV
;dE = 41.  ;keV
;GF = 5.  ;cm2 sr keV

;flux = area*GF*dE   ;#/s in the flux tube
;;  7.64429e+06  #/s
