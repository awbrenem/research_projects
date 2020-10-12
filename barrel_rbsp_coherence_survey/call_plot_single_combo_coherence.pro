;p1 = 'K' & p2 = 'L'
;p1 = 'W' & p2 = 'K'
;p1 = 'L' & p2 = 'X'
;p1 = 'K' & p2 = 'X'
p1 = 'W' & p2 = 'L'
period_fspc_low = 20.*60.
period_fspc_high = 60.*60.
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/tplot_vars_2014_run2/'
fn = p1+p2+'.tplot'
anglemax = 50.
tbperiod = 20. ;min - time period for overplotted vertical lines. Helps to identify waves of certain periods
yrangespec = [10,60]

mincoh = 0.7
periodmin = 20.
periodmax = 60.
max_mltdiff = 12.
max_ldiff=10.
ratiomax=2



plot_single_combo_coherence,p1,p2,fn,path,$
    period_fspc_low=period_fspc_low,period_fspc_high=period_fspc_high,anglemax=anglemax,tbperiod=tbperiod,yrangespec=yrangespec,$
    mincoh=mincoh,periodmin=periodmin,periodmax=periodmax,$
    max_mltdiff=max_mltdiff,max_ldiff=max_ldiff,ratiomax=ratiomax,/filter_spec
