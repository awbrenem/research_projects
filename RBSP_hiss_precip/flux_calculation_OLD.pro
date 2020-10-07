;Calculate the flux of e- scattered into loss cone on RBSP

;Jan 3rd, 2014 for time 20:05 UT


;Here's what I'm doing. By knowing the pitch angle diffusion rate I can find how far in
;pitch angle an electron will scatter in a single bounce period. (Half of) Electrons within this 
;angular distance from the loss cone will be lost in this time. If I take into account the
;entire 2*Pi solid angle, all electrons within this "thin slice" are lost. 
;For simplicity, I'm using the MagEIS differential flux at the 8 deg pitch angle and assuming
;that the DLC is at 7 deg pitch angle (I find that e- will scatter by ~1 deg in pitch angle
;each bounce.)


	t = '2014-01-03/20:05'

;Start with MagEIS differential flux at 8 deg PA, 30 keV  (from Joe Fennell)
	df30 = 8d4   ;#/cm2/s/sr/keV
	df50 = 9d4
	df80 = 4d4

;Energy bin width
;	dE = 14.3  ;keV  energy acceptance of 30 keV channel  (Table 1, Blake et al., 2013)
	dE30 = 8.    ;From Joe Fennell's email   
	dE50 = 9.
	dE80 = 12.
	
;MagEIS angular bin size at 8 deg (Table 1, Blake et al., 2013)
	dtheta30 = 7.8
	dtheta50 = 6.4
	dtheta80 = 5.6
	

;Now find the "thin slice" solid angle term.
;To get this I need to know how far an electron will random walk in a single
;bounce period.

	;bounce-averaged diffusion coeff for 30 keV
	Daa30 = 0.00014   ;1/s
	Daa50 = 8.12d-5
	Daa80 = 5.00d-5


	;Bounce period
	ang = 8.  ;Pitch angle
	L = 5.0   ;Lshell
	;bounce period for 30 keV e- at 8 deg pitch angle at L=5.2
	Tb30 = 5.62d-2 * L * (1-0.43*sin(ang*!dtor))/sqrt(30./1000.) ;=1.5 s
	Tb50 = 5.62d-2 * L * (1-0.43*sin(ang*!dtor))/sqrt(50./1000.) ;=1.2 s
	Tb80 = 5.62d-2 * L * (1-0.43*sin(ang*!dtor))/sqrt(80./1000.) ;=0.9 s



	;Random walk distance in single bounce <Daa> = dangle^2/2tb  (Kennel69 eqn3)
	dangle30 = sqrt(Daa30*2*Tb30)/!dtor  ;=1.2 deg
	dangle50 = sqrt(Daa50*2*Tb50)/!dtor  ;=0.8 deg
	dangle80 = sqrt(Daa80*2*Tb80)/!dtor  ;=0.6 deg

	;"thin slice" solid angle
	SA30 = 2*!pi*sin(8*!dtor) * dangle30*!dtor ;=0.018
	SA50 = 2*!pi*sin(8*!dtor) * dangle50*!dtor ;=0.012
	SA80 = 2*!pi*sin(8*!dtor) * dangle80*!dtor ;=0.008


;Now I can solve for the #/s/cm2 of electrons lost
	n30 = df30 * SA30 * dE30   ;#/sec/cm^2 (30 keV MagEIS bin only)
	n50 = df50 * SA50 * dE50   
	n80 = df80 * SA80 * dE80   

;Change to e-/bounce/cm2 (b/c this is the time for which thin slice
;was calculated)	
	n30 = n30 * tb30
	n50 = n50 * tb50	
	n80 = n80 * tb80	

;Of these electrons in the "thin slice" half will random walk to the DLC and the other
;half to higher pitch angles. So, 
	n30 = n30/2. ;=8820 e-/bounce/cm2
	n50 = n50/2. ;=5795
	n80 = n80/2. ;=1894


;Total MagEIS contributions 50-80 keV (e-/bounce/cm2)
        nm = n50 + n80   ;=7690 e-/bounce/cm2


;BARREL e-/s/cm2 for 50-100 keV range
        nb = 10000.      
	;nb = 1054641.8 ;e-/cm2/s  (OLD NUMBER)

        print,nm/nb   ;=0.77






;But, we have to account for the enhanced flux caused by 
;narrowing flux tube
;Find ratio of B2/B1 = A1/A2

	ilat = acos(sqrt(1/L))/!dtor  ;invariant latitude

	.compile ~/Desktop/community/dipole.pro
	dip = dipole(L)

	plot,dip.r - 6370.,yrange=[0,700]
	radius = dip.r - 6370.
	boo = where(radius le 70.)
	boo = boo[0]

	Bo_70km = dip.b[boo]    ;Bo_70km = 53505 nT
	Bo_mageq = 160.   ;nT  at 20:05 UT


;B2/B1 = 334


;--------------------------------------------------
;Michael McCarthy's method
;--------------------------------------------------

;Scale the BARREL observations by this ratio
        nbF = nb * (Bo_70km/Bo_mageq)  ;=3d6

        print,nbF/nm  ;=434



;--------------------------------------------------
;Aaron's method
;--------------------------------------------------

;Now let's add up all of the electrons that can reach the
;BARREL balloons within its field of view. 


;BARREL FOV is 100 km radius at 70 km altitude (for 1 MEV only!!! Not sure what it is for 30-100 keV)
	fov_70km = !pi*100.^2  
	fov_mageq = fov_70km * Bo_70km/Bo_mageq


;e-/s precipitating into entire BARREL FOV as observed on MagEIS each bounce
	nm30 = n30 * fov_mageq ;=9.2d10 e-/bounce    
	nm50 = n50 * fov_mageq ;=6.1d10   
	nm80 = n80 * fov_mageq ;=2d10   

;Total MagEIS (50 and 80 keV) into FOV (e-/bounce)
	nmA = nm50 + nm80  ;=8d10

;Total BARREL (50 - 100 keV) into FOV (e-/s, but bounce~1sec so this
;                   should be a valid comparison)
	nbA = nb * fov_70km ;=3d8


;ratio of e- precipitated by hiss to those detected by BARREL 2I
	ratio = nmA/nbA ;=257	




















;Number on 2I
100000d/(energy bin width)














;sin^2(alpha) functionality of MagEIS data
;But, it's pretty flat from 18 deg to loss cone

Total counts inside of solid angle "ring" are those
that are lost in a single bounce. So, it's a rate
#/bounce period


;---------------------------------------------------
;Jan3 A  cos2 dependence at 20:00
110deg -> 25000
160deg -> 15000

175deg -> translates to ~5000 counts at 5 deg from loss cone
;---------------------------------------------------


;------------------------------------------
;Jan 6th - best we can do is 18deg PA (has to do w/ angle b/t detector and Bo)
;2-5d3 @ 18 deg  30 keV
;2-5d3 @ 8 deg





;Say loss cone is at 4 deg
alpha = 4.
;Electrons are scattered by the hiss about 1 deg per second
dalpha = 1.

;Solid angle
ds = 2*!pi*sin(alpha*!dtor) * dalpha

;Need to multiply the MagEIS fluxes by ds to compare to BARREL fluxes
;b/c BARREL doesn't have the solid angle term. 

5d4 @ 8 deg at 30 keV  ;cm-2*s-1*sr-1*keV-1
;With a cos2 dependence this means that we have
49000 e- at 30 keV at 4 deg



;n = 49000.*gf30kev

;Reintroduce solid angle


;print,49000.*daa30keV





;MagEIS flux at 18 deg pitch angle (lower bins don't have significant counts)
;t0 = '2014-01-03/19:30'
;n30kev = 6d4    ;cm-2*s-1*sr-1*keV-1













;180/!pi = 175 sec  to go 57 deg

;3 sec per degree of PA

;0.05 deg in 1/4 s

;0.2 deg/quarter bounce (strong diffusion)

;moves length of loss cone in 1/4 bounce
;4 deg in 1/4 sec = 16 deg/sec

;for observed diffusion rate this is 0.2 deg/quarter bounce

;Move 4 deg from 8 deg PA MagEIS to loss cone
;0.2 deg/0.2 sec = 1 deg /sec








;Normally you'd multiply this by the geometric factor to get #/s. Geometric
;factor takes into account the effective detector area, angular bin size (via solid angle term), 
;and energy bin size. 

;GF = dA * SA * dE   

;However, we're not interested in the MagEIS solid angle, but the #/s in the "thin slice"
;solid angle. So, I can't use the geometric factor
;as is. To get around this I'll find
;each of the terms that make up the geometric factor and use the "thin slice"
;solid angle. 





;Area term. Get from  GF = dA * SA * dE   -->  dA = GF/SA/dE
;In this case SA is the solid angle of the MagEIS detector, and not the "thin slice" solid angle
	;GF30 = 0.0526  ;Geometric factor
	;GF50 = 0.0607
	;GF80 = 0.0663





;	SA230 = 2*!pi*sin(8.*!dtor)*dtheta30*!dtor
;	SA250 = 2*!pi*sin(8.*!dtor)*dtheta50*!dtor
;	SA280 = 2*!pi*sin(8.*!dtor)*dtheta80*!dtor

	;Effective area of detector
;	dA30 = GF30/dE30/SA230   ;cm^2
;	dA50 = GF50/dE50/SA250   ;cm^2
;	dA80 = GF80/dE80/SA280   ;cm^2

;This result isn't too useful b/c it's only the #/s passing tiny MagEIS detector
;;Divide out the MagEIS detector area
;	n30 = n30/dA30    ;#/sec/cm^2
;	n50 = n50/dA50    ;#/sec/cm^2
;	n80 = n80/dA80    ;#/sec/cm^2

