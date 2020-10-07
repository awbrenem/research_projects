;Plot the survey data vs Lshell instead of time


timespan,info.days[0],info.ndays

;Need more accurate Lshell values 
rbsp_efw_position_velocity_crib,/noplot


get_data,'rbsp' + info.probe + '_lshell',data=lshell
get_data,'rbsp' + info.probe + '_npk_percent',data=npk
get_data,'rbsp' + info.probe + '_fbk_pk',data=pk


tinterpol_mxn,'rbsp' + info.probe + '_state_lshell',npk.x,newname='rbsp' + info.probe + '_state_lshell2'
get_data,'rbsp' + info.probe + '_state_lshell2',data=lshell2


;t01 = time_double('2012-10-13/00:30')
;t11 = time_double('2012-10-13/05:00')

;t02 = time_double('2012-10-13/05:00')
;t12 = time_double('2012-10-13/09:20')

;t03 = time_double('2012-10-13/09:20')
;t13 = time_double('2012-10-13/14:00')

;t04 = time_double('2012-10-13/14:00')
;t14 = time_double('2012-10-13/18:30')

;t05 = time_double('2012-10-13/18:30')
;t15 = time_double('2012-10-13/23:30')


;g1 = where((npk.x gt t01) and (npk.x lt t11))
;g2 = where((npk.x gt t02) and (npk.x lt t12))
;g3 = where((npk.x gt t03) and (npk.x lt t13))
;g4 = where((npk.x gt t04) and (npk.x lt t14))
;g5 = where((npk.x gt t05) and (npk.x lt t15))


!p.multi = [0,0,1]
plot,lshell2.y,npk.y,xtitle='Lshell',ytitle='%occurrence',xrange=[2.5,7],color=0


!p.multi = [0,0,1]
plot,lshell2.y,pk.y,xtitle='Lshell',ytitle='FBK peak values',xrange=[2.5,7],color=0


;!p.multi = [0,0,5]
;plot,lshell2.y[g1],npk.y[g1],xtitle='Lshell',ytitle='%occurrence',xrange=[2.5,7],color=0
;plot,lshell2.y[g2],npk.y[g2],xtitle='Lshell',ytitle='%occurrence',xrange=[2.5,7],color=0
;plot,lshell2.y[g3],npk.y[g3],xtitle='Lshell',ytitle='%occurrence',xrange=[2.5,7],color=0
;plot,lshell2.y[g4],npk.y[g4],xtitle='Lshell',ytitle='%occurrence',xrange=[2.5,7],color=0
;plot,lshell2.y[g5],npk.y[g5],xtitle='Lshell',ytitle='%occurrence',xrange=[2.5,7],color=0



tplot,['rbsp' + info.probe + '_lshell','rbsp' + info.probe + '_npk_percent']




















;-----------------------------------------------------------------------
;THE BELOW CODE IS MY ATTEMPT TO "STRETCH" THE TIME AXIS ACCORDING TO 
;HOW FAST THE SC IS MOVING. I DON'T THINK THIS IS ANY BETTER THAN PLOTTING
;WITH LSHELL ON THE X-AXIS
;-----------------------------------------------------------------------


;have an x-axis that has EVENLY distributed quantities of distance. 
;


get_data,'rbspb_state_vel_mgse',data=vmgse
vmag = sqrt(vmgse.y[*,0]^2 + vmgse.y[*,1]^2 + vmgse.y[*,2]^2)

t2 = npk.x - npk.x[0]


;calculate the integrated distance traveled
dtmp = vmag * t2
dtmp = dtmp - dtmp[0]
d = fltarr(n_elements(npk.x))
for i=1L,n_elements(d)-1 do d[i] = d[i-1] + dtmp[i]

d = d/6370.


;Test to see that integrated distance increases most rapidly near perigee
!p.charsize = 1.5
!p.multi = [0,0,2]
plot,dindgen(n_elements(d)),d,xtitle='#',ytitle='Integrated distance from start of day (RE)'
plot,dindgen(n_elements(d)),lshell.y,xtitle='#',ytitle='Lshell'


;THIS IS NOT THE CORRECT WAY TO DO THINGS. AS INTEGRATED DISTANCE INCREASES
;THE PLOTS BECOME MORE AND MORE STRETCHED OUT.
!p.charsize = 1.5
!p.multi = [0,0,3]
plot,d,npk.y,xtitle='Integrated distance from start of day (RE)',ytitle='%occurrence'
plot,d,vmag,xtitle='Integrated distance from start of day (RE)',ytitle='|V|'
plot,d,lshell.y,xtitle='Integrated distance from start of day (RE)',ytitle='Lshell'
;plot,t2/60.,npk.y
;plot,t2/60.,lshell.y


v2 = deriv(d)
!p.multi = [0,0,2]
plot,d
plot,v2


!p.multi = [0,0,3]
plot,v2,npk.y,ytitle='%occurrence'
plot,v2,vmag,ytitle='|V|'
plot,v2,lshell.y,ytitle='Lshell'


t01 = time_double('2012-10-13/00:30')
t11 = time_double('2012-10-13/05:00')

t02 = time_double('2012-10-13/05:00')
t12 = time_double('2012-10-13/09:20')

t03 = time_double('2012-10-13/09:20')
t13 = time_double('2012-10-13/14:00')

t04 = time_double('2012-10-13/14:00')
t14 = time_double('2012-10-13/18:30')

t05 = time_double('2012-10-13/18:30')
t15 = time_double('2012-10-13/23:30')


g1 = where((npk.x gt t01) and (npk.x lt t11))
g2 = where((npk.x gt t02) and (npk.x lt t12))
g3 = where((npk.x gt t03) and (npk.x lt t13))
g4 = where((npk.x gt t04) and (npk.x lt t14))
g5 = where((npk.x gt t05) and (npk.x lt t15))


v3 = v2
v3[g1] = v2[g1]
v3[g2] = v2[g2] + max(v3[g1])
v3[g3] = v2[g3] + max(v3[g2])
v3[g4] = v2[g4] + max(v3[g3])
v3[g5] = v2[g5] + max(v3[g4])



!p.multi = [0,0,3]
plot,v3,npk.y,ytitle='%occurrence'
plot,v3,vmag,ytitle='|V|'
plot,v3,lshell.y,ytitle='Lshell'






