;Test out various detrending versions in order to better identify microbursts.
;FB cubesats have a 40sec roll period that can dominate the signal. Not usually
;present inside the SAA.



;tlimit,'2016-01-21/22:46:11','2016-01-21/22:48:23'

timespan,'2016-01-21'
firebird_load_data,'3'

split_vec,'fu3_fb_col_hires_flux'
ylim,'fu3_fb_col_hires_flux_0',0,0,0
tlimit,'2016-01-21/22:46:11','2016-01-21/22:46:23'

;40 sec roll
rbsp_detrend,'fu3_fb_col_hires_flux_0',10  & copy_data,'fu3_fb_col_hires_flux_0_detrend','fu3_10'
rbsp_detrend,'fu3_fb_col_hires_flux_0',1   & copy_data,'fu3_fb_col_hires_flux_0_detrend','fu3_1'
rbsp_detrend,'fu3_fb_col_hires_flux_0',0.1 & copy_data,'fu3_fb_col_hires_flux_0_detrend','fu3_01'
tplot,['fu3_fb_col_hires_flux_0','fu3_10','fu3_1','fu3_01']



tplot,[1,3]
1 fu3_fb_col_hires_flux
3 fu3_fb_sur_hires_flux
