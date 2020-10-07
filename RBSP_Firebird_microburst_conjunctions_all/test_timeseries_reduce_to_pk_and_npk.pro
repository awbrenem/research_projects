

;Crib sheet for testing timeseries_reduce_to_pk_and_npk.probe

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/tplot_vars_2014/'
fn = 'IK.tplot'

tplot_restore,filenames=path + fn

get_data,'coh_IK_band0',data=d

;test at 0.1 Hz
store_data,'test',d.x,d.y[*,3]

dt = 24.*3600.
timeseries_reduce_to_pk_and_npk.probe,'test',dt
