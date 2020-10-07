;Determine if the THEMIS-A EFI data on 2014-01-11/22 - 24 UT is good
;for the BARREL paper


;NOT using VAF, VAP, VAW data b/c they stop at ~16 UT


timespan,'2014-01-11'
thm_load_efi,probe='a'
;None of the data from this routines extends past 16 UT




rbsp_efw_init


fn = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/tha_l1_vaf_20140111_v01.cdf'
cdf2tplot,fn



fn = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/tha_l1_vap_20140111_v01.cdf'
cdf2tplot,fn


fn = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/tha_l1_vaw_20140111_v01.cdf'
cdf2tplot,fn


fn = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/tha_l2_efi_20140111_v01.cdf'
cdf2tplot,fn


fn = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/tha_l2s_fit_20140111000001_20140112235959.cdf'
cdf2tplot,fn
STORE_DATA(261): Creating tplot variable: 22 tha_fgs_sigma
STORE_DATA(261): Creating tplot variable: 23 tha_fgs_dsl
STORE_DATA(261): Creating tplot variable: 24 tha_fgs_gse
STORE_DATA(261): Creating tplot variable: 25 tha_fgs_gsm
STORE_DATA(261): Creating tplot variable: 26 tha_efs_sigma
STORE_DATA(261): Creating tplot variable: 27 tha_efs_dsl
STORE_DATA(261): Creating tplot variable: 28 tha_efs_0_dsl
STORE_DATA(261): Altering tplot variable: 12 tha_efs_dot0_dsl
STORE_DATA(261): Creating tplot variable: 29 tha_efs_gse
STORE_DATA(261): Creating tplot variable: 30 tha_efs_0_gse
STORE_DATA(261): Altering tplot variable: 10 tha_efs_dot0_gse
STORE_DATA(261): Creating tplot variable: 31 tha_efs_gsm
STORE_DATA(261): Creating tplot variable: 32 tha_efs_0_gsm
STORE_DATA(261): Altering tplot variable: 11 tha_efs_dot0_gsm
STORE_DATA(261): Creating tplot variable: 33 tha_fit_bfit
STORE_DATA(261): Creating tplot variable: 34 tha_fit_efit
