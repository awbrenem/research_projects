;plot_sw_conditions from OMNI data (including clock, cone angles) for BARREL 2nd mission
;Saves as .tplot file for later recall


rbsp_efw_init
tplot_options,'title','plot_sw_conditions.pro'

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path2 = path + 'coh_vars_barrelmission1/'
path3 = path + 'solar_wind_data/'


timespan,'2013-01-01',45,/days
;timespan,'2014-01-01',45,/days


;---------------------------------------------------------------------------
;Load OMNI data
omni_hro_load
;Create |B| variable
get_data,'OMNI_HRO_1min_BX_GSE',ttmp,bx
get_data,'OMNI_HRO_1min_BY_GSE',ttmp,by
get_data,'OMNI_HRO_1min_BZ_GSE',ttmp,bz
store_data,'OMNI_HRO_1min_Bmag',ttmp,sqrt(bx^2+by^2+bz^2)


ylim,'OMNI_HRO_1min_proton_density',0,30


;Use these to find average values for pressure comparison.
t0tmp = time_double('2013-01-01/00:00')
t1tmp = time_double('2013-02-15/00:00')
vtmp = tsample('OMNI_HRO_1min_Vx',[t0tmp,t1tmp],times=ttt)
ntmp = tsample('OMNI_HRO_1min_proton_density',[t0tmp,t1tmp],times=ttt)

get_data,'OMNI_HRO_1min_Vx',data=vv
get_data,'OMNI_HRO_1min_proton_density',data=dd


vsw = vv.y ;change velocity to m/s
dens = dd.y ;change number density to 1/m^3


;Pressure in nPa (rho*v^2)
press_proxy = 2d-6 * dens * vsw^2
store_data,'OMNI_press_dyn',data={x:vv.x,y:press_proxy}
;calculate pressure using averaged Vsw value
vsw_mean = mean(vtmp,/nan)
press_proxy = 2d-6 * dens * vsw_mean^2
store_data,'OMNI_press_dyn_constant_vsw',data={x:vv.x,y:press_proxy}
;calculate pressure using averaged density value
dens_mean = mean(ntmp,/nan)
press_proxy = 2d-6 * dens_mean * vsw^2
store_data,'OMNI_press_dyn_constant_dens',data={x:vv.x,y:press_proxy}

store_data,'OMNI_pressure_dyn_compare',data=['OMNI_press_dyn','OMNI_press_dyn_constant_dens','OMNI_press_dyn_constant_vsw']
ylim,['OMNI_HRO_1min_Pressure','OMNI_pressure_dyn_compare'],0,10
options,'OMNI_pressure_dyn_compare','colors',[0,50,250]

;BLACK = DYNAMIC PRESSURE
;BLUE = CONSTANT DENSITY (fluctuations due to Vsw)
;RED = CONSTANT VSW (fluctuations due to density)


;Calculate clock and cone angles

;^^Check the SW clock angle (GSE coord)
;Clockangle: zero deg is along yGSE, 90 deg is along zGSE
;Coneangle: zero deg is along xGSE, 90 along r=sqrt(yGSE^2+zGSE^2)
get_data,'OMNI_HRO_1min_BX_GSE',ttmp,bx
get_data,'OMNI_HRO_1min_BY_GSE',ttmp,by
get_data,'OMNI_HRO_1min_BZ_GSE',ttmp,bz
bmag = sqrt(bx^2 + by^2 + bz^2)

store_data,'OMNI_clockangle',ttmp,atan(by/bz)/!dtor
store_data,'OMNI_coneangle',ttmp,acos(bx/bmag)/!dtor


rbsp_detrend,'OMNI_clockangle',60.*60.
rbsp_detrend,'OMNI_coneangle',60.*60.



tplot,['OMNI_clockangle_smoothed','OMNI_coneangle_smoothed','OMNI_pressure_dyn_compare','OMNI_HRO_1min_flow_speed','OMNI_HRO_1min_proton_density']
tplot,'coh_allcombos_meanfilter',/add






tplot_restore,filenames=path2+'all_coherence_plots_combined_meanfilter_noextremefiltering.tplot'
copy_data,'coh_allcombos_meanfilter','coh_allcombos_meanfilter_noextreme'
tplot_restore,filenames=path2+'all_coherence_plots_combined_meanfilter.tplot'

zlim,'coh_allcombos_meanfilter_noextreme',0,6
tplot,['coh_allcombos_meanfilter_noextreme','coh_allcombos_meanfilter']







tplot_save,'*OMNI*',filename=path3+'OMNI_sw_values_campaign1'
tplot_save,'*OMNI*',filename=path3+'OMNI_sw_values_campaign2'










;;-----------------------------------------------------------
;;load Wind magnetic field data
;wi_mfi_load
;get_data,'wi_h0_mfi_B3GSE',ttmp,bo
;bmag = sqrt(bo[*,0]^2+bo[*,1]^2+bo[*,2]^2)
;store_data,'wi_h0_mfi_bmag',ttmp,bmag

;path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/solar_wind_data/'
;cdf2tplot,path+'wi_ems_3dp_20140101000001_20140214235958.cdf',prefix='wi_'

;cdf2tplot,path+'wi_h0s_mfi_20140101000030_20140214235930.cdf',prefix='wi_'
;cdf2tplot,path+'wi_h2s_mfi_20140101000000_20140214235959.cdf',prefix='wi_'
;cdf2tplot,path+'wi_k0s_swe_20140101000113_20140214235829.cdf',prefix='wi_'


;wi_plsps_3dp_20140101000009_20140214235941.cdf
;wi_pms_3dp_20140101000000_20140215000000.cdf
;wind_h1s_swe_20140101000156_20140214235935.cdf
