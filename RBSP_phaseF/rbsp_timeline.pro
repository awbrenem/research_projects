;Make a timeline plot of mode changes, campaigns, milestones, etc for EFW


;FBK modes
;Survey modes
;Boom full deployment
;EMFISIS 19dB attenuator
;V1 bad




rbsp_efw_init
tplot_options,'title','rbsp_burst1_availability_plots.pro'
tplot_options,'xmargin',[20.,16.] & tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08 & tplot_options,'yticklen',0.02
tplot_options,'xthick',2 & tplot_options,'ythick',2
tplot_options,'labflag',-1

d0 = time_double('2012-09-01')
d1 = time_double('2019-11-01')
timespan,d0,d1-d0,/sec



;Instrument mode changes
;----------
;FBK modes
;----------
;2013-03-17 - 2016-04-12: FBK 7 with Ew from E12AC and Bw from SCMw.
;2016-04-13: FBK13 with SCMw and E34AC.
fbk1 = ['2012-09-01','2013-03-15']   ;FBK13 Ew only (E12AC)
fbk2 = ['2013-03-16','2018-04-13']   ;FBK7 Ew, Bw (E12AC and Bw from SCMw.)
fbk3a = ['2018-04-14','2019-08-27']  ;FBK13 Ew, Bw (FBK13 with SCMw and E34AC.)
fbk3b = ['2018-04-14','2019-07-16']  ;FBK13 Ew, Bw (FBK13 with SCMw and E34AC.)

;----------
;Xspec modes
;----------
;Xspec was sourced from SPEC data E12AC and SCMw (Malaspina email 2016-08-16)
;until Aug 2016 then changed to E34AC. Unfortunately this product never produced
;very useful results and was discontinued on 2018-04-13 to increase filter bank
;telemetry available for a midnight-dawn chorus “campaign”.
;----------
;Spec modes
;----------



cp0 = rbsp_efw_get_cal_params(trange[0])

gain19dB = rbsp_efw_emfisis_scm_gain_list()




;BARREL campaigns
;https://earthweb.ess.washington.edu/mccarthy/BARREL/SWD2015/welcome.html
b13 = ['2013-01-01','2013-01-30']
b14 = ['2013-12-27','2014-02-11']
b_kiruna1 = ['2015-08-10','2015-08-26']
b_kiruna2 = ['2016-08-13','2016-08-31']
b_kiruna3 = ['2018-06-25','2018-06-27']
b18 = ['2018-12-09','2019-02-21']
;FIREBIRD campaigns (NOTE THAT DEFINITIVE LIST IS IN ARLO'S PAPER)
fb1 = ['2015-02-01','2015-02-21']
fb2 = ['2015-03-21','2015-04-19']
fb3 = ['2015-05-16','2015-06-15']
fb4 = ['2015-07-03','2015-08-04']
fb5 = ['2015-08-08','2015-09-04']
fb6 = ['2015-11-15','2015-12-15']
fb7 = ['2016-01-15','2016-02-03']
fb8 = ['2016-05-20','2016-06-20']
fb9 = ['2016-08-12','2016-09-07']
fb10 = ['2016-12-21','2017-01-04']
fb11 = ['2017-05-01','2017-05-21']
fb12 = ['2017-07-01','2017-07-21']
fb13 = ['2017-11-19','2017-12-14']
fb14 = ['2018-02-27','2018-03-28']
fb15 = ['2018-04-20','2018-05-13']
fb16 = ['2018-06-25','2018-07-18']
fb17 = ['2018-07-31','2018-08-20']
fb18 = ['2018-09-17','2018-10-13']
fb19 = ['2018-12-16','2019-01-10']
fb20 = ['2019-01-24','2019-02-20']
fb21 = ['2019-03-16','2019-04-10']
fb22 = ['2019-05-05','2019-05-17']
fb23 = ['2019-07-05','2019-07-29']
fb24 = ['2019-09-10','2019-10-08']

;Schumann resonance campaign
schum = ['2019-03-17','2019-05-08']


;***NEED ALL 2018/2019 CAMPAIGNS

store_data,'b13',time_double(b13),replicate(1.2,2) & ylim,'b13',0,2 & options,'b13','psym',0 & options,'b13','thick',4
store_data,'b14',time_double(b14),replicate(1.2,2) & ylim,'b14',0,2 & options,'b14','psym',0 & options,'b14','thick',4
store_data,'b_kiruna1',time_double(b_kiruna1),replicate(1.2,2) & ylim,'b_kiruna1',0,2 & options,'b_kiruna1','psym',0 & options,'b_kiruna1','thick',4
store_data,'b_kiruna2',time_double(b_kiruna2),replicate(1.2,2) & ylim,'b_kiruna2',0,2 & options,'b_kiruna2','psym',0 & options,'b_kiruna2','thick',4
store_data,'b_kiruna3',time_double(b_kiruna3),replicate(1.2,2) & ylim,'b_kiruna3',0,2 & options,'b_kiruna3','psym',0 & options,'b_kiruna3','thick',4
store_data,'fb1',time_double(fb1),replicate(1,2) & ylim,'fb1',0,2 & options,'fb1','psym',0 & options,'fb1','thick',4 & options,'fb1','colors',250
store_data,'fb2',time_double(fb2),replicate(1,2) & ylim,'fb2',0,2 & options,'fb2','psym',0 & options,'fb2','thick',4 & options,'fb2','colors',250
store_data,'fb3',time_double(fb3),replicate(1,2) & ylim,'fb3',0,2 & options,'fb3','psym',0 & options,'fb3','thick',4 & options,'fb3','colors',250
store_data,'fb4',time_double(fb4),replicate(1,2) & ylim,'fb4',0,2 & options,'fb4','psym',0 & options,'fb4','thick',4 & options,'fb4','colors',250
store_data,'fb5',time_double(fb5),replicate(1,2) & ylim,'fb5',0,2 & options,'fb5','psym',0 & options,'fb5','thick',4 & options,'fb5','colors',250
store_data,'fb6',time_double(fb6),replicate(1,2) & ylim,'fb6',0,2 & options,'fb6','psym',0 & options,'fb6','thick',4 & options,'fb6','colors',250
store_data,'fb7',time_double(fb7),replicate(1,2) & ylim,'fb7',0,2 & options,'fb7','psym',0 & options,'fb7','thick',4 & options,'fb7','colors',250
store_data,'fb8',time_double(fb8),replicate(1,2) & ylim,'fb8',0,2 & options,'fb8','psym',0 & options,'fb8','thick',4 & options,'fb8','colors',250
store_data,'fb9',time_double(fb9),replicate(1,2) & ylim,'fb9',0,2 & options,'fb9','psym',0 & options,'fb9','thick',4 & options,'fb9','colors',250
store_data,'fb10',time_double(fb10),replicate(1,2) & ylim,'fb10',0,2 & options,'fb10','psym',0 & options,'fb10','thick',4 & options,'fb10','colors',250
store_data,'fb11',time_double(fb11),replicate(1,2) & ylim,'fb11',0,2 & options,'fb11','psym',0 & options,'fb11','thick',4 & options,'fb11','colors',250
store_data,'fb12',time_double(fb12),replicate(1,2) & ylim,'fb12',0,2 & options,'fb12','psym',0 & options,'fb12','thick',4 & options,'fb12','colors',250
store_data,'fb13',time_double(fb13),replicate(1,2) & ylim,'fb13',0,2 & options,'fb13','psym',0 & options,'fb13','thick',4 & options,'fb13','colors',250
store_data,'fb14',time_double(fb14),replicate(1,2) & ylim,'fb14',0,2 & options,'fb14','psym',0 & options,'fb14','thick',4 & options,'fb14','colors',250
store_data,'fb15',time_double(fb15),replicate(1,2) & ylim,'fb15',0,2 & options,'fb15','psym',0 & options,'fb15','thick',4 & options,'fb15','colors',250
store_data,'fb16',time_double(fb16),replicate(1,2) & ylim,'fb16',0,2 & options,'fb16','psym',0 & options,'fb16','thick',4 & options,'fb16','colors',250
store_data,'fb17',time_double(fb17),replicate(1,2) & ylim,'fb17',0,2 & options,'fb17','psym',0 & options,'fb17','thick',4 & options,'fb17','colors',250
store_data,'fb18',time_double(fb18),replicate(1,2) & ylim,'fb18',0,2 & options,'fb18','psym',0 & options,'fb18','thick',4 & options,'fb18','colors',250
store_data,'fb19',time_double(fb19),replicate(1,2) & ylim,'fb19',0,2 & options,'fb19','psym',0 & options,'fb19','thick',4 & options,'fb19','colors',250
store_data,'fb20',time_double(fb20),replicate(1,2) & ylim,'fb20',0,2 & options,'fb20','psym',0 & options,'fb20','thick',4 & options,'fb20','colors',250
store_data,'fb21',time_double(fb21),replicate(1,2) & ylim,'fb21',0,2 & options,'fb21','psym',0 & options,'fb21','thick',4 & options,'fb21','colors',250
store_data,'fb22',time_double(fb22),replicate(1,2) & ylim,'fb22',0,2 & options,'fb22','psym',0 & options,'fb22','thick',4 & options,'fb22','colors',250
store_data,'fb23',time_double(fb23),replicate(1,2) & ylim,'fb23',0,2 & options,'fb23','psym',0 & options,'fb23','thick',4 & options,'fb23','colors',250
store_data,'fb24',time_double(fb24),replicate(1,2) & ylim,'fb24',0,2 & options,'fb24','psym',0 & options,'fb24','thick',4 & options,'fb24','colors',250
store_data,'schum',time_double(schum),replicate(0.8,2) & ylim,'schum',0,2 & options,'schum','psym',0 & options,'schum','thick',4 & options,'schum','colors',50

store_data,'campaigns',data=['b13','b14','b_kiruna1','b_kiruna2','b_kiruna3','fb1','fb2','fb3','fb4','fb5','fb6','fb7','fb8','fb9','fb10','fb11','fb12','fb13','fb14','fb15','fb16','fb17','fb18','fb19','fb20','fb21','fb22','fb23','fb24','schum'] & ylim,'campaigns',0,2
options,'campaigns','panel_size',0.8
options,'campaigns','ytitle','Burst collection!Ccampaigns!CBlack=BARREL!CRed=FIREBIRD!CBlue=Schumann'
ylim,'running_samples_monthly_rate_comb',0,600,0

tplot,['b1?comb','DST1800_smoothed_inverted','running_samples_monthly_rate_comb','running_samples_comb','campaigns']


ylim,'DST1800_smoothed_inverted',-20,40
tplot,['DST1800_smoothed_inverted','running_samples_monthly_rate_comb']
;tplot,['running_samples_comb','campaigns']
;tplot,['running_samples_monthly_rate_comb','running_samples_comb']

stop

end
