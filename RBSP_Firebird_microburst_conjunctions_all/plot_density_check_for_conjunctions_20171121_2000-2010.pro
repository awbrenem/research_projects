;19:46
tplot_options,'title','from plot_density_check_for_conjunctions_20171121_2000-2010.pro'

rbsp_efw_init
timespan,'2017-11-21'
;timespan,'2017-12-04'
;fn = 'rbspa_l1_vb1_20171121_v02_2000-2010.cdf'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/data/rbspa_20171121/'



;sc = 'a'
;rbsp_read_ect_mag_ephem,sc,   perigeetimes,pre=pre,type=type

;--------------------------------------

.compile /Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/antenna_analysis/EFW_probe_potentials_test.pro
EFW_probe_potentials_test

;---------------------------------------------------
;Load EFW antenna potentials to calculate density

;rbsp_load_efw_waveform_l2,probe='a'
;rbsp_load_efw_waveform_l2,probe='b'
;split_vec,'rbsp?_efw_vsvy-hires_vsvy'
;tplot,'rbspa_efw_vsvy-hires_vsvy_?'
;tplot,'rbspb_efw_vsvy-hires_vsvy_?'

;get_data,'rbspa_efw_vsvy-hires_vsvy_1',t2,d2  ;v2
;get_data,'rbspa_efw_vsvy-hires_vsvy_3',t3,d3  ;v4
;store_data,'rbspa_dens_proxy_lowres24',t2,(d2+d3)/2.
;get_data,'rbspb_efw_vsvy-hires_vsvy_0',t1,d1  ;v1
;get_data,'rbspb_efw_vsvy-hires_vsvy_1',t2,d2  ;v3
;store_data,'rbspb_dens_proxy_lowres12',t1,(d1+d2)/2.




;----------------------------
;load HOPE
rbsp_load_ect_l3,'a','hope',/get_support_data
zlim,'rbspa_ect_hope_L3_FEDO',1d3,1d7,1
ylim,'rbspa_ect_hope_L3_FEDO',100,50000,1

options,'rbspa_ect_hope_L3_FEDO','spec',0

tplot,['rbspa_ect_hope_L3_FEDO','rbspa_ect_hope_L3_FEDU']
get_data,'rbspa_ect_hope_L3_FEDO',data=p
goo = where(p.v[0,*] ge 1000.)
store_data,'rbspa_hope_1kev',p.x,p.y[*,goo[0]]
goo = where(p.v[0,*] ge 10000.)
store_data,'rbspa_hope_10kev',p.x,p.y[*,goo[0]]
;-----------------------------------------
