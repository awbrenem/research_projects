;Wave modes seen by various spacecraft on Jan 11, 2014 following the
;19:10 substorm injection.


;thm_load_efi,probe='a',type='calibrated'


timespan,'2014-01-11'
kyoto_load_ae
omni_hro_load
rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*80.

thm_load_fft,probe='a d e',type='calibrated'
thm_load_fbk,probe='a d e',type='calibrated'


;THEMIS-A FGM data won't load from TDAS routines so I'll load it manually
thm_load_fgm,probe='d e',type='calibrated'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
tplot_restore,filenames=path+'jan11_tha_b.tplot'


rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt


rbsp_load_emfisis,probe='a',level='l3',coord='gse',cadence='4sec'
rbsp_load_emfisis,probe='b',level='l3',coord='gse',cadence='4sec'

get_data,'rbspa_emfisis_l3_4sec_gse_Magnitude',data=daa & rba_bmag = daa.y
fce = 28.*rba_bmag & fce_10 = fce/10. & fce_2 = fce/2.
Z = 1 & muu = 1. & fci = fce*Z/(1836.*muu) & flhr = sqrt(abs(fce)*fci)
store_data,'rba_fce',daa.x,fce
store_data,'rba_fce_2',daa.x,fce_2
store_data,'rba_fce_10',daa.x,fce_10
store_data,'rba_flhr',daa.x,flhr

get_data,'rbspb_emfisis_l3_4sec_gse_Magnitude',data=db & rbb_bmag = db.y
fce = 28.*rbb_bmag & fce_10 = fce/10. & fce_2 = fce/2.
Z = 1 & muu = 1. & fci = fce*Z/(1836.*muu) & flhr = sqrt(abs(fce)*fci)
store_data,'rbb_fce',db.x,fce
store_data,'rbb_fce_2',db.x,fce_2
store_data,'rbb_fce_10',db.x,fce_10
store_data,'rbb_flhr',db.x,flhr

store_data,'rbspa_efw_64_spec0_comb',data=['rbspa_efw_64_spec0','rba_fce','rba_fce_2','rba_fce_10','rba_flhr'] & ylim,'rbspa_efw_64_spec0_comb',10,2000,1
store_data,'rbspa_efw_64_spec4_comb',data=['rbspa_efw_64_spec4','rba_fce','rba_fce_2','rba_fce_10','rba_flhr'] & ylim,'rbspa_efw_64_spec4_comb',10,2000,1

store_data,'rbspb_efw_64_spec0_comb',data=['rbspb_efw_64_spec0','rbb_fce','rbb_fce_2','rbb_fce_10','rbb_flhr'] & ylim,'rbspb_efw_64_spec0_comb',10,2000,1
store_data,'rbspb_efw_64_spec4_comb',data=['rbspb_efw_64_spec4','rbb_fce','rbb_fce_2','rbb_fce_10','rbb_flhr'] & ylim,'rbspb_efw_64_spec4_comb',10,2000,1



get_data,'tha_bvec11',data=da & tha_bmag = sqrt(da.y[*,0]^2 + da.y[*,1]^2 + da.y[*,2]^2)
get_data,'thd_fgl',data=dd & thd_bmag = sqrt(dd.y[*,0]^2 + dd.y[*,1]^2 + dd.y[*,2]^2)
get_data,'the_fgl',data=de & the_bmag = sqrt(de.y[*,0]^2 + de.y[*,1]^2 + de.y[*,2]^2)

fce = 28.*tha_bmag & fce_10 = fce/10. & fce_2 = fce/2.
Z = 1 & muu = 1. & fci = fce*Z/(1836.*muu) & flhr = sqrt(abs(fce)*fci)
store_data,'tha_fce',da.x,fce
store_data,'tha_fce_2',da.x,fce_2
store_data,'tha_fce_10',da.x,fce_10
store_data,'tha_flhr',da.x,flhr

fce = 28.*thd_bmag & fce_10 = fce/10. & fce_2 = fce/2.
Z = 1 & muu = 1. & fci = fce*Z/(1836.*muu) & flhr = sqrt(abs(fce)*fci)
store_data,'thd_fce',dd.x,fce
store_data,'thd_fce_2',dd.x,fce_2
store_data,'thd_fce_10',dd.x,fce_10
store_data,'thd_flhr',dd.x,flhr

fce = 28.*the_bmag & fce_10 = fce/10. & fce_2 = fce/2.
Z = 1 & muu = 1. & fci = fce*Z/(1836.*muu) & flhr = sqrt(abs(fce)*fci)
store_data,'the_fce',de.x,fce
store_data,'the_fce_2',de.x,fce_2
store_data,'the_fce_10',de.x,fce_10
store_data,'the_flhr',de.x,flhr

store_data,'tha_fff_32_scm3_comb',data=['tha_fff_32_scm3','tha_fce','tha_fce_2','tha_fce_10','tha_flhr'] & ylim,'tha_fff_32_scm3_comb',10,2000,1
store_data,'thd_fff_32_scm3_comb',data=['thd_fff_32_scm3','thd_fce','thd_fce_2','thd_fce_10','thd_flhr'] & ylim,'thd_fff_32_scm3_comb',10,2000,1
store_data,'the_fff_32_scm3_comb',data=['the_fff_32_scm3','the_fce','the_fce_2','the_fce_10','the_flhr'] & ylim,'the_fff_32_scm3_comb',10,2000,1

store_data,'tha_fff_32_scm2_comb',data=['tha_fff_32_scm2','tha_fce','tha_fce_2','tha_fce_10','tha_flhr'] & ylim,'tha_fff_32_scm2_comb',10,2000,1
store_data,'thd_fff_32_scm2_comb',data=['thd_fff_32_scm2','thd_fce','thd_fce_2','thd_fce_10','thd_flhr'] & ylim,'thd_fff_32_scm2_comb',10,2000,1
store_data,'the_fff_32_scm2_comb',data=['the_fff_32_scm2','the_fce','the_fce_2','the_fce_10','the_flhr'] & ylim,'the_fff_32_scm2_comb',10,2000,1

store_data,'tha_fff_32_edc12_comb',data=['tha_fff_32_edc12','tha_fce','tha_fce_2','tha_fce_10','tha_flhr'] & ylim,'tha_fff_32_edc12_comb',10,2000,1
store_data,'thd_fff_32_edc12_comb',data=['thd_fff_32_edc12','thd_fce','thd_fce_2','thd_fce_10','thd_flhr'] & ylim,'thd_fff_32_edc12_comb',10,2000,1
store_data,'the_fff_32_edc12_comb',data=['the_fff_32_edc12','the_fce','the_fce_2','the_fce_10','the_flhr'] & ylim,'the_fff_32_edc12_comb',10,2000,1

store_data,'tha_fff_32_edc34_comb',data=['tha_fff_32_edc34','tha_fce','tha_fce_2','tha_fce_10','tha_flhr'] & ylim,'tha_fff_32_edc34_comb',10,2000,1
store_data,'thd_fff_32_edc34_comb',data=['thd_fff_32_edc34','thd_fce','thd_fce_2','thd_fce_10','thd_flhr'] & ylim,'thd_fff_32_edc34_comb',10,2000,1
store_data,'the_fff_32_edc34_comb',data=['the_fff_32_edc34','the_fce','the_fce_2','the_fce_10','the_flhr'] & ylim,'the_fff_32_edc34_comb',10,2000,1


options,'tha_fb_scm1','spec',1 & ylim,'tha_fb_scm1',10,2000,1 & zlim,'tha_fb_scm1',1d-3,1d0,1
store_data,'tha_fb_scm1_comb',data=['tha_fb_scm1','tha_fce','tha_fce_2','tha_fce_10','tha_flhr'] & ylim,'tha_fb_scm1_comb',10,2000,1
options,'thd_fb_scm1','spec',1 & ylim,'thd_fb_scm1',10,2000,1 & zlim,'thd_fb_scm1',1d-3,1d0,1
store_data,'thd_fb_scm1_comb',data=['thd_fb_scm1','thd_fce','thd_fce_2','thd_fce_10','thd_flhr'] & ylim,'thd_fb_scm1_comb',10,2000,1
options,'the_fb_scm1','spec',1 & ylim,'the_fb_scm1',10,2000,1 & zlim,'the_fb_scm1',1d-3,1d0,1
store_data,'the_fb_scm1_comb',data=['the_fb_scm1','the_fce','the_fce_2','the_fce_10','the_flhr'] & ylim,'the_fb_scm1_comb',10,2000,1

options,'tha_fb_edc12','spec',1 & ylim,'tha_fb_edc12',10,2000,1 & zlim,'tha_fb_edc12',1d-3,1d0,1
store_data,'tha_fb_edc12_comb',data=['tha_fb_edc12','tha_fce','tha_fce_2','tha_fce_10','tha_flhr'] & ylim,'tha_fb_edc12_comb',10,2000,1
options,'thd_fb_edc12','spec',1 & ylim,'thd_fb_edc12',10,2000,1 & zlim,'thd_fb_edc12',1d-3,1d0,1
store_data,'thd_fb_edc12_comb',data=['thd_fb_edc12','thd_fce','thd_fce_2','thd_fce_10','thd_flhr'] & ylim,'thd_fb_edc12_comb',10,2000,1
options,'the_fb_edc12','spec',1 & ylim,'the_fb_edc12',10,2000,1 & zlim,'the_fb_edc12',1d-3,1d0,1
store_data,'the_fb_edc12_comb',data=['the_fb_edc12','the_fce','the_fce_2','the_fce_10','the_flhr'] & ylim,'the_fb_edc12_comb',10,2000,1



tplot,'th?_fff_32_scm2_comb'
tplot,'th?_fff_32_edc12_comb'
tplot,'th?_fb_scm1_comb'
tplot,'th?_fb_edc12_comb'


;Create cB/E specs
get_data,'thd_fff_32_scm3',data=d1
get_data,'thd_fff_32_edc12',data=d2
d1.y = d1.y*1000.*1000.   ;pT^2/Hz
d2.y = d2.y*1000.*1000.   ;mV/m^2/Hz


tplot,['tha_fff_32_scm3','tha_fff_32_edc12']

;---------------------------------------------------------------
;THEMIS-E
;---------------------------------------------------------------

;First need to identify if this is inside of magnetosphere. From SSCWeb, seems
;to be right on Mpause boundary.

;From online survey plots, it seems to be inside of magnetosphere.
;Density is about 1/cc, Bo~50, flow velocity is small. Compared to THB, THC,
;which are in SW, they see Bo~10, density~10, flow velocity~200-300 km/s


;Immediately following substorm onset, 10-30 Hz power assoc. with Bo dips that last >10 sec.
;Right before onset there is some chorus, but it's promptly terminated at onset.
;After 19:40 extremely quiet with little wave activity except some minor chorus from 21:30-22:00
zlim,['the_fff_32_scm2_comb','the_fff_32_scm3_comb'],1d-9,1d-4,1
zlim,['the_fff_32_edc12_comb','the_fff_32_edc12_comb'],1d-12,1d-8,1
tplot,['kyoto_ae','the_fff_32_scm2_comb','the_fff_32_scm3_comb','the_fb_scm1_comb']
tplot,['kyoto_ae','the_fff_32_edc12_comb','the_fff_32_edc34_comb','the_fb_edc12_comb']




;---------------------------------------------------------------
;THEMIS-D
;---------------------------------------------------------------

;Sees some f<flh waves starting at 21:30 through rest of day, maybe.
;Definitely inside of magnetosphere at 21:30 but maybe outside of plume (according
;to Goldstein), so I'm not sure if this is seeing the same thing as THA.
zlim,['thd_fff_32_scm2_comb','thd_fff_32_scm3_comb'],1d-9,1d-4,1
zlim,['thd_fff_32_edc12_comb','thd_fff_32_edc12_comb'],1d-12,1d-9,1
zlim,'thd_fb_scm1_comb',1d-3,1d-1,1
tplot,['kyoto_ae','thd_fff_32_scm2_comb','thd_fff_32_scm3_comb','thd_fb_scm1_comb']
tplot,['kyoto_ae','thd_fff_32_edc12_comb','thd_fff_32_edc34_comb','thd_fb_edc12_comb']



;---------------------------------------------------------------
;THEMIS-A
;---------------------------------------------------------------

;Definitely inside of magnetosphere
zlim,['tha_fff_32_scm2_comb','tha_fff_32_scm3_comb'],1d-9,1d-4,1
zlim,['tha_fff_32_edc12_comb','tha_fff_32_edc12_comb'],1d-12,1d-9,1
tplot,['kyoto_ae','tha_fff_32_scm2_comb','tha_fff_32_scm3_comb','tha_fb_scm1_comb']
tplot,['kyoto_ae','tha_fff_32_edc12_comb','tha_fff_32_edc34_comb','tha_fb_edc12_comb']


;---------------------------------------------------------------
;THEMIS-A + THEMIS-D + THEMIS-E
;---------------------------------------------------------------
zlim,'thd_fff_32_scm3_comb',1d-7,1d-5,1
zlim,'tha_fb_scm1_comb',1d-3,1d0,1
zlim,'thd_fb_scm1_comb',1d-3,1d-1,1
tplot,['OMNI_HRO_1min_proton_density_detrend','kyoto_ae','thd_fff_32_scm3_comb','thd_fb_scm1_comb','tha_fb_scm1_comb','the_fff_32_scm3_comb'];,'rbsp?_efw_64_spec4_comb']
tplot,['OMNI_HRO_1min_proton_density_detrend','kyoto_ae','thd_fff_32_edc12_comb','thd_fb_edc12_comb','tha_fb_edc12_comb','the_fff_32_edc12_comb'];,'rbsp?_efw_64_spec4_comb']


;---------------------------------------------------------------
;RBSP-A
;---------------------------------------------------------------
;RBSP-A sees >100 Hz hiss from 20-23 UT, when it's afternoon and night.
;It doesn't see it at ~19:30 or before when it's at ~16 MLT, L=4
tplot,['kyoto_ae','rbspa_efw_64_spec[0:4]_comb']

;---------------------------------------------------------------
;RBSP-B
;---------------------------------------------------------------


;RBSP_B definitely sees >100 Hz hiss from 22:30-23:50, i.e. when it's
;at L<~6 at 24:00. So, this population either doesn't extend out beyond L=6
;or this is a time-domain effect.
tplot,['kyoto_ae','rbspb_efw_64_spec[0:4]_comb']



;---------------------------------------------------------------
;RBSP-B and THEMIS-D comparison
;---------------------------------------------------------------
;RBSP-B sees >100 Hz hiss from 22:30-24 UT. However, it's on dayside here.
tplot,['OMNI_HRO_1min_proton_density_detrend','kyoto_ae','thd_fff_32_scm3_comb','tha_fb_scm1_comb','thd_fb_scm1_comb','rbspb_efw_64_spec4_comb']
tplot,['OMNI_HRO_1min_proton_density_detrend','kyoto_ae','thd_fff_32_edc12_comb','thd_fb_edc12_comb','rbspb_efw_64_spec0_comb']
