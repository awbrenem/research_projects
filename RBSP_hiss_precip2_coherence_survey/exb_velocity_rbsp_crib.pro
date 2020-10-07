;General routine to calculate ExB velocity
;See specific crib sheets for various sc, like exb_velocity_rbsp_crib.pro
;to call this routine.


;pro exb_velocity_rbsp_crib

    rbsp_efw_init
    date = '2014-01-11'
    timespan,date
    sc = 'a'

    smootime = 2.  ;smooth over this many minutes


    omni_hro_load 
    rbsp_detrend,'OMNI_HRO_1min_Pressure',60.*smootime

;load ephemeris data

    rbsp_load_spice_cdf_file,sc
    copy_data,'rbsp'+sc+'_state_pos_gse','rbsp'+sc+'_state_pos_gse1'
    copy_data,'rbsp'+sc+'_spinaxis_direction_gse','rbsp'+sc+'_spinaxis_direction_gse1'

    timespan,'2014-01-12'
    rbsp_load_spice_cdf_file,sc
    get_data,'rbsp'+sc+'_state_pos_gse1',data=d1
    get_data,'rbsp'+sc+'_state_pos_gse',data=d2
    store_data,'rbsp'+sc+'_state_pos_gse',[d1.x,d2.x],[d1.y,d2.y]
    get_data,'rbsp'+sc+'_spinaxis_direction_gse1',data=d1
    get_data,'rbsp'+sc+'_spinaxis_direction_gse',data=d2
    store_data,'rbsp'+sc+'_spinaxis_direction_gse',[d1.x,d2.x],[d1.y,d2.y]


;    rbsp_efw_position_velocity_crib
    get_data,'rbsp'+sc+'_state_pos_gse',data=pos
    r = SQRT(pos.y[*,0]^2+pos.y[*,1]^2+pos.y[*,2]^2)/6371.
    store_data,'r',data={x:pos.x,y:r}

    get_data,'rbsp'+sc+'_spinaxis_direction_gse',data=wgse
    rbsp_gse2mgse,'rbsp'+sc+'_state_pos_gse',reform(wgse.y[0,*]),newname='pos_mgse'


;Load EMFISIS L3 magnetic field GSE
    timespan,'2014-01-11'
    rbsp_load_emfisis,probe=sc,cadence='4sec',coord='gse',level='l3'
    copy_data,'rbsp'+sc+'_emfisis_l3_4sec_gse_Mag','rbsp'+sc+'_emfisis_l3_4sec_gse_Mag1'
    timespan,'2014-01-12'
    rbsp_load_emfisis,probe=sc,cadence='4sec',coord='gse',level='l3'
    get_data,'rbsp'+sc+'_emfisis_l3_4sec_gse_Mag1',data=d1
    get_data,'rbsp'+sc+'_emfisis_l3_4sec_gse_Mag',data=d2
    store_data,'rbsp'+sc+'_emfisis_l3_4sec_gse_Mag',[d1.x,d2.x],[d1.y,d2.y]



    get_data,'rbsp'+sc+'_emfisis_l3_4sec_gse_Mag',data=Bmag_l3
    store_data,'Mag_gse',data=Bmag_l3
    rbsp_gse2mgse,'Mag_gse',reform(wgse.y[0,*]),newname='Mag_mgse'



;load E field
    rbsp_efw_edotb_to_zero_crib,'2014-01-11',sc
    copy_data,'rbsp'+sc+'_efw_esvy_mgse_vxb_removed_coro_removed_spinfit_edotb','rbsp'+sc+'_efw_esvy_mgse_vxb_removed_coro_removed_spinfit_edotb1'
    rbsp_efw_edotb_to_zero_crib,'2014-01-12',sc

    get_data,'rbsp'+sc+'_efw_esvy_mgse_vxb_removed_coro_removed_spinfit_edotb1',data=d1
    get_data,'rbsp'+sc+'_efw_esvy_mgse_vxb_removed_coro_removed_spinfit_edotb',data=d2
    store_data,'rbsp'+sc+'_efw_esvy_mgse_vxb_removed_coro_removed_spinfit_edotb',[d1.x,d2.x],[d1.y,d2.y]


    tplot,['rbsp'+sc+'_efw_esvy_mgse_vxb_removed_coro_removed_spinfit_edotb']
    get_data,'rbsp'+sc+'_efw_esvy_mgse_vxb_removed_coro_removed_spinfit_edotb',data=E_sf


    etimes=E_sf.x
    Ex = (E_sf.y)[*,0] & Ey = (E_sf.y)[*,1] & Ez = (E_sf.y)[*,2]

    r = interp(r,pos.x,etimes,/no_extrap)
    Ex[where(r lt 2.5)] = !values.f_nan & Ey[where(r lt 2.5)] = !values.f_nan & Ez[where(r lt 2.5)] = !values.f_nan

    store_data,'Ex-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m',data={x:etimes,y:Ex},dlim={constant:[0]}
    store_data,'Ey-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m',data={x:etimes,y:Ey},dlim={constant:[0]}
    store_data,'Ez-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m',data={x:etimes,y:Ez},dlim={constant:[0]}

    intedt = total(Ey,/nan,/cumulative)*find_datarate(etimes)
    store_data,'Time-Int-Ey!Cmgse!CmV/m-s',data={x:etimes,y:intedt},dlim={constant:[0]}



;interp B to E times

    tinterpol_mxn,'Mag_mgse',etimes,/quadratic
    get_data,'Mag_mgse_interp',data=B_mgse

;    Bx = B_mgse.y[*,0] & By = B_mgse.y[*,1] & Bz = B_mgse.y[*,2]
;    Bx=interp(Bx,B_mgse.x,etimes,/no_extrap)
;    By=interp(By,B_mgse.x,etimes,/no_extrap)
;    Bz=interp(Bz,B_mgse.x,etimes,/no_extrap)

    B_mag = SQRT(B_mgse.y[*,0]^2+B_mgse.y[*,1]^2+B_mgse.y[*,2]^2)


    rate = find_datarate(etimes[0:1000])
    smoo = round((smootime*60.)/rate)
    smoothed_int = string(format='(i0.1)',round(smoo*rate/60.))
    print,'Smoothing (averaging) the data '+smoothed_int+ ' min'

    rbsp_detrend,'Mag_mgse_interp',60.*smootime
    rbsp_detrend,'E?-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m',60.*smootime
    get_data,'Mag_mgse_interp_smoothed',data=B_bkgrd
    get_data,'Ex-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m_smoothed',tmp,Ex_smooth
    get_data,'Ey-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m_smoothed',tmp,Ey_smooth
    get_data,'Ez-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m_smoothed',tmp,Ez_smooth

    Bx_bkgrd = B_bkgrd.y[*,0]
    By_bkgrd = B_bkgrd.y[*,1]
    Bz_bkgrd = B_bkgrd.y[*,2]

    B_field_mag = sqrt(Bx_bkgrd^2 + By_bkgrd^2 + Bz_bkgrd^2)


    vx = 1000.*(Ey_smooth*Bz_bkgrd - Ez_smooth*By_bkgrd)/B_field_mag^2
    vy = 1000.*(Ez_smooth*Bx_bkgrd - Ex_smooth*Bz_bkgrd)/B_field_mag^2
    vz = 1000.*(Ex_smooth*By_bkgrd - Ey_smooth*Bx_bkgrd)/B_field_mag^2

    edb_stat='E-dot-B-where-OK'

    store_data,'Vx!CExB-drift!Ckm/s',data={x:etimes,y:vx}
    store_data,'Vy!CExB-drift!C'+edb_stat+'!Ckm/s',data={x:etimes,y:vy}
    store_data,'Vz!CExB-drift!C'+edb_stat+'!Ckm/s',data={x:etimes,y:vz}

    options,['E-dot-B!Cflag','Vx!CExB-drift!Ckm/s','Vy!CExB-drift!CE-dot-B-where-OK!Ckm/s','Vz!CExB-drift!CE-dot-B-where-OK!Ckm/s'],thick=2,constant=0
    tplot,['E-dot-B!Cflag',$
    'Vx!CExB-drift!Ckm/s',$
    'Vy!CExB-drift!CE-dot-B-where-OK!Ckm/s',$
    'Vz!CExB-drift!CE-dot-B-where-OK!Ckm/s']




    ;put E field and ExB velocities in FAC coordinates
    nb= n_elements(Bx_bkgrd)
    bg_field = fltarr(nb,3)
    bg_field[*,0]  = Bx_bkgrd/B_field_mag & bg_field[*,1]  = By_bkgrd/B_field_mag & bg_field[*,2]  = Bz_bkgrd/B_field_mag

    nef = n_elements(Ex)
    dE_field = fltarr(nef,3)
    dE_field[*,0] = Ex_smooth & dE_field[*,1] = Ey_smooth & dE_field[*,2] = Ez_smooth

    nbf = n_elements(vx)
    exb_flow = fltarr(nbf,3)
    exb_flow[*,0] = vx & exb_flow[*,1] = vy & exb_flow[*,2] = vz



    get_data,'pos_mgse',data=mgse_pos
    mptimes = mgse_pos.x
    xmgse = mgse_pos.y[*,0] & ymgse = mgse_pos.y[*,1] & zmgse = mgse_pos.y[*,2]

    radial_pos = SQRT(xmgse^2+ymgse^2+zmgse^2)

    xmgse = interp(xmgse,mptimes,etimes,/no_extrap)
    ymgse = interp(ymgse,mptimes,etimes,/no_extrap)
    zmgse = interp(zmgse,mptimes,etimes,/no_extrap)

    radial_pos = interp(radial_pos,mptimes,etimes,/no_extrap)

    r_dir_vec = fltarr(nbf,3) ;the vectors along the spin axis
    r_dir_vec[*,0] = xmgse/radial_pos   ;REPLACE WITH RADIAL VECTOR MGSE
    r_dir_vec[*,1] = ymgse/radial_pos
    r_dir_vec[*,2] = zmgse/radial_pos


    ;define orthogonal perpendicular unit vectors
    perp1_dir = fltarr(nef,3)
    for xx=0L,nef-1 do perp1_dir[xx,*] = crossp(bg_field[xx,*],r_dir_vec[xx,*])  ;azimuthal, east
    perp2_dir = fltarr(nef,3)
    for xx=0L,nef-1 do perp2_dir[xx,*] = crossp(perp1_dir[xx,*],bg_field[xx,*]) ;radial, outward


    ;need to normalize perp 1 and perp2 direction
    bdotr = fltarr(nef)
    for xx=0L,nef-1 do bdotr[xx] = bg_field[xx,0]*r_dir_vec[xx,0]+bg_field[xx,1]*r_dir_vec[xx,1]+bg_field[xx,2]*r_dir_vec[xx,2]

    one_array = fltarr(nef)
    one_array[*] = 1.0
    perp_norm_fac1 = SQRT(one_array - (bdotr*bdotr))
    perp_norm_fac = fltarr(nef,3)
    perp_norm_fac[*,0] = perp_norm_fac1 & perp_norm_fac[*,1] = perp_norm_fac1 & perp_norm_fac[*,2] = perp_norm_fac1

    perp1_dir = perp1_dir/(perp_norm_fac) & perp2_dir = perp2_dir/(perp_norm_fac)


    store_data,'perp1_dir!Cazimuthal!Ceastward!Cunit-vec',data={x:etimes,y:perp1_dir},dlim={colors:[2,4,6],labels:['x','y','z']}
    store_data,'perp2_dir!Cradial!Coutward!Cunit-vec',data={x:etimes,y:perp2_dir},dlim={colors:[2,4,6],labels:['x','y','z']}



    ;take dot product of E perp into the two perp unit vecs to find perp E in FAC
    E_perp_1  = fltarr(nef)
    for xx=0L,nef-1 do E_perp_1[xx] = dE_field[xx,0]*perp1_dir[xx,0] +  dE_field[xx,1]*perp1_dir[xx,1] +  dE_field[xx,2]*perp1_dir[xx,2]
    E_perp_2  = fltarr(nef)
    for xx=0L,nef-1 do E_perp_2[xx] = dE_field[xx,0]*perp2_dir[xx,0] +  dE_field[xx,1]*perp2_dir[xx,1] +  dE_field[xx,2]*perp2_dir[xx,2]

    edb_stat='E-dot-B-where-OK'
    store_data,'E-field!CAzimuthal(East)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m',data = {x:etimes,y:E_perp_1},dlim={constant:[0],colors:[0],labels:['']}
    store_data,'E-field!CRadial(Outward)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m',data = {x:etimes,y:E_perp_2},dlim={constant:[0],colors:[0],labels:['']}


    inteadt = total(E_perp_1,/nan,/cumulative)*find_datarate(etimes)

    store_data,'Time-Int!CE-azimuthal!CmV/m-s',data={x:etimes,y:inteadt},dlim={constant:[0]}



    ; Put ExB flow using E dot B = 0 to find Ex into FAC
    dV_perp_1  = fltarr(nef)
    for xx=0L,nef-1 do dV_perp_1[xx] = exb_flow[xx,0]*perp1_dir[xx,0] +  exb_flow[xx,1]*perp1_dir[xx,1] +  exb_flow[xx,2]*perp1_dir[xx,2]
    dV_perp_2  = fltarr(nef)
    for xx=0L,nef-1 do dV_perp_2[xx] = exb_flow[xx,0]*perp2_dir[xx,0] +  exb_flow[xx,1]*perp2_dir[xx,1] +  exb_flow[xx,2]*perp2_dir[xx,2]

    edb_stat='E-dot-B-where-OK'
    store_data,'RBSP'+sc+'ExB-flow!CAzimuthal(East)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',data = {x:etimes,y:dV_perp_1},dlim={constant:[0],colors:[0],labels:['']}
    store_data,'RBSP'+sc+'ExB-flow!CRadial(Outward)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',data = {x:etimes,y:dV_perp_2},dlim={constant:[0],colors:[0],labels:['']}



    title='FAC Perp1 is in the B cross X R direction (azimuthal) and!CPerp2 is in the perp1 cross B direction (radial)'
    print,title





    tplot,['RBSP'+sc+'ExB-flow!CAzimuthal(East)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'RBSP'+sc+'ExB-flow!CRadial(Outward)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'E-field!CAzimuthal(East)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m',$
    'E-field!CRadial(Outward)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m']


    rbsp_detrend,['RBSP'+sc+'ExB-flow!CAzimuthal(East)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'RBSP'+sc+'ExB-flow!CRadial(Outward)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'E-field!CAzimuthal(East)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m',$
    'E-field!CRadial(Outward)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m'],60.*80.

    ylim,['RBSP'+sc+'ExB-flow!CAzimuthal(East)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'RBSP'+sc+'ExB-flow!CRadial(Outward)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'E-field!CAzimuthal(East)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m',$
    'E-field!CRadial(Outward)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m']+'_detrend',-0.6,0.6

    tplot,['RBSP'+sc+'ExB-flow!CAzimuthal(East)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'RBSP'+sc+'ExB-flow!CRadial(Outward)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',$
    'E-field!CAzimuthal(East)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m',$
    'E-field!CRadial(Outward)!C'+edb_stat+'!C'+smoothed_int+'-min-ave!CmV/m']+'_detrend'


    get_data,'Mag_mgse',data = b_mgse
    get_data,'rbsp'+sc+'_state_vel_gse',data = v_mgse

    vx = v_mgse.y[*,0] & vy = v_mgse.y[*,1] & vz = v_mgse.y[*,2]

    vx=interp(vx,v_mgse.x,b_mgse.x,/no_extrap)
    vy=interp(vy,v_mgse.x,b_mgse.x,/no_extrap)
    vz=interp(vz,v_mgse.x,b_mgse.x,/no_extrap)

    bx = b_mgse.y[*,0] & by = b_mgse.y[*,1] & bz = b_mgse.y[*,2]

    bmag = SQRT(bx^2+by^2+bz^2)
    vmag = SQRT(vx^2+vy^2+vz^2)

    bdotv  = (vx*bx+vy*by+vz*bz)/(bmag)

    store_data,'B-dot-V!isc!n!Cnormailized!Ckm/s',data={x:b_mgse.x,y:bdotv}







    tplot,['E-dot-B!Cflag','Vx!CExB-drift!Ckm/s','Vy!CExB-drift!CE-dot-B-where-OK!Ckm/s','Vz!CExB-drift!CE-dot-B-where-OK!Ckm/s',$
    'ExB-flow!CAzimuthal(East)!CE-dot-B-where-OK!Ckm/s',$
    'ExB-flow!CRadial(Outward)!CE-dot-B-where-OK!Ckm/s','E-dot-B!Cflag']


stop


;sloshing distance
t0z = time_double('2014-01-11/20:00')
t1z = time_double('2014-01-12/02:00')
rbsp_detrend,'RBSP'+sc+'ExB-flow!CRadial(Outward)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s',60.*80.
yv = tsample('RBSP'+sc+'ExB-flow!CRadial(Outward)!C'+smoothed_int+'-min-ave!C'+edb_stat+'!Ckm/s_detrend',[t0z,t1z],times=tms)
dt = tms[1]-tms[0]
vals = total(-1*yv*dt,/cumulative,/nan)/6370.
store_data,'RBSP'+sc+'_sloshing_distance2',tms,vals
options,'RBSP'+sc+'_sloshing_distance2','ytitle','-1*radial sloshing distance!Cth'+sc+'[RE]'
ylim,'RBSP'+sc+'_sloshing_distance2',0,0,0

tplot,'RBSP'+sc+'_sloshing_distance2'




rbsp_detrend,'Vx!CExB-drift!Ckm/s',60.*80.


t0z = time_double('2014-01-11/21:00')
t1z = time_double('2014-01-12/02:00')
yv = tsample('Vx!CExB-drift!Ckm/s_detrend',[t0z,t1z],times=tms)
dt = tms[1]-tms[0]
vals = total(-1*yv*dt,/cumulative,/nan)/6370.
store_data,'RBSP'+sc+'_sloshing_distance',tms,vals
options,'RBSP'+sc+'_sloshing_distance','ytitle','-1*X-MGSE sloshing distance!Cth'+sc+'[RE]'
ylim,'RBSP'+sc+'_sloshing_distance',0,0,0

tplot,['OMNI_HRO_1min_Pressure_smoothed','Vx!CExB-drift!Ckm/s_detrend','RBSP'+sc+'_sloshing_distance','E?-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m_smoothed']




tplot,['RBSP'+sc+'_sloshing_distance2','RBSP'+sc+'_sloshing_distance']



    options,['E-dot-B!Cflag','Vx!CExB-drift!Ckm/s','Vy!CExB-drift!CE-dot-B-where-OK!Ckm/s','Vz!CExB-drift!CE-dot-B-where-OK!Ckm/s'],thick=2,constant=0
    tplot,['E-dot-B!Cflag',$
    'Vx!CExB-drift!Ckm/s',$
    'Vy!CExB-drift!CE-dot-B-where-OK!Ckm/s',$
    'Vz!CExB-drift!CE-dot-B-where-OK!Ckm/s']





stop








    copy_data,'Mag_mgse_interp_smoothed','Bfield_for_ExB'
    get_data,'Ex-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m_smoothed',tmp,Ex_smooth
    get_data,'Ey-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m_smoothed',tmp,Ey_smooth
    get_data,'Ez-mgse!Cspinfit!Cvxb-sub!Ccorot-frame!CmV/m_smoothed',tmp,Ez_smooth
    store_data,'Efield_for_ExB',etimes,[[Ex_smooth],[Ey_smooth],[Ez_smooth]]

    savevars = ['Bfield_for_ExB','Efield_for_ExB','Vx!CExB-drift!Ckm/s']

    tplot_save,savevars,filename='~/Desktop/exb_20140111_rbspb'

end
