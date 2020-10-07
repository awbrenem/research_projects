pro rbsp_survey_read_hsk_ascii,info


;************************
;ADJUST THESE PARAMETERS
;************************

;location of gigantic file
;file = '~/Desktop/code/Aaron/datafiles/rbsp/survey_data/rbspb_hsk_60sec_20120905_20131120.txt'
;file = '~/Desktop/code/Aaron/datafiles/rbsp/survey_data/rbspa_hsk_16sec_20130401_20131031.txt'
file = '~/Desktop/code/Aaron/datafiles/rbsp/survey_data/rbspb_hsk_16sec_20130401_20131031.txt'
probe = 'b'
rbspx = 'rbsp'+probe
;************************
;************************

rbsp_efw_init
yellow_to_orange

;Read in the HSK ascii file 
ft = [3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
fg = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44]
fl = [0,13,27,33,46,53,67,78,88,98,108,118,128,138,148,158,168,178,188,193,199,207,212,218,226,233,241,247,252,260,266,271,276,282,290,299,309,319,329,339,349,359,369,379,389]
fn = ['f01','f02','f03','f04','f05','f06','f07','f08','f09','f10','f11','f12','f13','f14','f15','f16','f17','f18','f19','f20','f21','f22','f23','f24','f25','f26','f27','f28','f29','f30','f31','f32','f33','f34','f35','f36','f37','f38','f39','f40','f41','f42','f43','f44','f45']

t = {version:1.,$
	 datastart:0L,$
	 delimiter:32B,$
	 missingvalue:!values.f_nan,$
	 commentsymbol:'',$
	 fieldcount:45,$
	 fieldtypes:ft,$
	 fieldnames:fn,$
	 fieldlocations:fl,$
	 fieldgroups:indgen(45)}


d = read_ascii(file,template=t)



;Grab data from the structure
times = d.f01
ibias1 = d.f02 & ibias2 = d.f03 & ibias3 = d.f04 & ibias4 = d.f05 & ibias5 = d.f06 & ibias6 = d.f07
guard1 = d.f08 & guard2 = d.f09 & guard3 = d.f10 & guard4 = d.f11 & guard5 = d.f12 & guard6 = d.f13 &
usher1 = d.f14 & usher2 = d.f15 & usher3 = d.f16 & usher4 = d.f17 & usher5 = d.f18 & usher6 = d.f19
tmon_lvps = d.f20 & tmon_axb5 = d.f21 & tmon_axb6 = d.f22
imon_beb = d.f23 & imon_idpu = d.f24 & imon_fvx = d.f25 & imon_fvy = d.f26 & imon_fvz = d.f27
vmon_beb_p10va = d.f28 & vmon_beb_n10va = d.f29 & vmon_beb_p5va = d.f30 & vmon_beb_p5vd = d.f31
vmon_idpu_p10va = d.f32 & vmon_idpu_n10va = d.f33 & vmon_idpu_p36vd = d.f34 & vmon_idpu_p18vd = d.f35
analog_p33vd = d.f36 & analog_p15vd = d.f37
ssr_per = d.f38
fast_b1_evalmax = d.f39 & fast_b1_playreq = d.f40 & fast_b1_recbbi = d.f41 & fast_b1_receci = d.f42 & fast_b1_thresh = d.f43 & fast_b2_recstate = d.f44 & fast_b2_thresh = d.f45  


;Store data as tplot variables and plot

store_data,'beb_analog_IEFI_IBIAS1',data={x:times,y:ibias1}
store_data,'beb_analog_IEFI_IBIAS2',data={x:times,y:ibias2}
store_data,'beb_analog_IEFI_IBIAS3',data={x:times,y:ibias3}
store_data,'beb_analog_IEFI_IBIAS4',data={x:times,y:ibias4}
store_data,'beb_analog_IEFI_IBIAS5',data={x:times,y:ibias5}
store_data,'beb_analog_IEFI_IBIAS6',data={x:times,y:ibias6}

options,'beb_analog_IEFI_IBIAS1','ytitle','IEFI_IBIAS1'
options,'beb_analog_IEFI_IBIAS2','ytitle','IEFI_IBIAS2'
options,'beb_analog_IEFI_IBIAS3','ytitle','IEFI_IBIAS3'
options,'beb_analog_IEFI_IBIAS4','ytitle','IEFI_IBIAS4'
options,'beb_analog_IEFI_IBIAS5','ytitle','IEFI_IBIAS5'
options,'beb_analog_IEFI_IBIAS6','ytitle','IEFI_IBIAS6'

store_data,'beb_analog_IEFI_GUARD1',data={x:times,y:GUARD1}
store_data,'beb_analog_IEFI_GUARD2',data={x:times,y:GUARD2}
store_data,'beb_analog_IEFI_GUARD3',data={x:times,y:GUARD3}
store_data,'beb_analog_IEFI_GUARD4',data={x:times,y:GUARD4}
store_data,'beb_analog_IEFI_GUARD5',data={x:times,y:GUARD5}
store_data,'beb_analog_IEFI_GUARD6',data={x:times,y:GUARD6}

options,'beb_analog_IEFI_GUARD1','ytitle','IEFI_GUARD1'
options,'beb_analog_IEFI_GUARD2','ytitle','IEFI_GUARD2'
options,'beb_analog_IEFI_GUARD3','ytitle','IEFI_GUARD3'
options,'beb_analog_IEFI_GUARD4','ytitle','IEFI_GUARD4'
options,'beb_analog_IEFI_GUARD5','ytitle','IEFI_GUARD5'
options,'beb_analog_IEFI_GUARD6','ytitle','IEFI_GUARD6'


store_data,'beb_analog_IEFI_USHER1',data={x:times,y:USHER1}
store_data,'beb_analog_IEFI_USHER2',data={x:times,y:USHER2}
store_data,'beb_analog_IEFI_USHER3',data={x:times,y:USHER3}
store_data,'beb_analog_IEFI_USHER4',data={x:times,y:USHER4}
store_data,'beb_analog_IEFI_USHER5',data={x:times,y:USHER5}
store_data,'beb_analog_IEFI_USHER6',data={x:times,y:USHER6}

options,'beb_analog_IEFI_USHER1','ytitle','IEFI_USHER1'
options,'beb_analog_IEFI_USHER2','ytitle','IEFI_USHER2'
options,'beb_analog_IEFI_USHER3','ytitle','IEFI_USHER3'
options,'beb_analog_IEFI_USHER4','ytitle','IEFI_USHER4'
options,'beb_analog_IEFI_USHER5','ytitle','IEFI_USHER5'
options,'beb_analog_IEFI_USHER6','ytitle','IEFI_USHER6'


store_data,rbspx+'_efw_hsk_idpu_analog_TMON_LVPS',data={x:times,y:tmon_lvps}
store_data,rbspx+'_efw_hsk_idpu_analog_TMON_AXB5',data={x:times,y:tmon_axb5}
store_data,rbspx+'_efw_hsk_idpu_analog_TMON_AXB6',data={x:times,y:tmon_axb6}

store_data,rbspx+'_efw_hsk_idpu_analog_IMON_BEB',data={x:times,y:imon_beb}
store_data,rbspx+'_efw_hsk_idpu_analog_IMON_IDPU',data={x:times,y:imon_idpu}
store_data,rbspx+'_efw_hsk_idpu_analog_IMON_FVX',data={x:times,y:imon_fvx}
store_data,rbspx+'_efw_hsk_idpu_analog_IMON_FVY',data={x:times,y:imon_fvy}
store_data,rbspx+'_efw_hsk_idpu_analog_IMON_FVZ',data={x:times,y:imon_fvz}

store_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P10VA',data={x:times,y:VMON_BEB_p10va}
store_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_N10VA',data={x:times,y:VMON_BEB_n10va}
store_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VA',data={x:times,y:VMON_BEB_p5va}
store_data,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_P5VD',data={x:times,y:VMON_BEB_p5vd}

store_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P10VA',data={x:times,y:VMON_IDPU_p10va}
store_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_N10VA',data={x:times,y:VMON_IDPU_n10va}
store_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P36VD',data={x:times,y:VMON_IDPU_p36vd}
store_data,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_P18VD',data={x:times,y:VMON_IDPU_p18vd}
	
store_data,rbspx+'_efw_hsk_idpu_analog_P33VD',data={x:times,y:analog_p33vd}
store_data,rbspx+'_efw_hsk_idpu_analog_P15VD',data={x:times,y:analog_p15vd}

store_data,'ssr_per',data={x:times,y:ssr_per}
store_data,'fast_b1_evalmax',data={x:times,y:fast_b1_evalmax}
store_data,'fast_b1_playreq',data={x:times,y:fast_b1_playreq}
store_data,'fast_b1_recbbi',data={x:times,y:fast_b1_recbbi}
store_data,'fast_b1_receci',data={x:times,y:fast_b1_receci}
store_data,'fast_b1_thresh',data={x:times,y:fast_b1_thresh}
store_data,'fast_b2_recstate',data={x:times,y:fast_b2_recstate}
store_data,'fast_b2_thresh',data={x:times,y:fast_b2_thresh}


;Modify the housekeeping labels
rbsp_efw_hsk_simplify_labels,probe

;add in the yellow and red alert limits
rbsp_efw_hsk_add_alert_limits,probe



;Plot the HSK variables

!p.charsize = 0.9
tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	


popen,'~/Desktop/ibias.ps',/landscape
ylim,'beb_analog_IEFI_IBIAS'+['1','2','3','4','5','6'],-100,100
tplot,'beb_analog_IEFI_IBIAS'+['1','2','3','4','5','6']
pclose

popen,'~/Desktop/guard.ps',/landscape
ylim,'beb_analog_IEFI_GUARD'+['1','2','3','4','5','6'],-100,100
tplot,'beb_analog_IEFI_GUARD'+['1','2','3','4','5','6']
pclose

popen,'~/Desktop/usher.ps',/landscape
ylim,'beb_analog_IEFI_USHER'+['1','2','3','4','5','6'],-100,100
tplot,'beb_analog_IEFI_USHER'+['1','2','3','4','5','6']
pclose

popen,'~/Desktop/tmon.ps',/landscape
tplot,rbspx+'_efw_hsk_idpu_analog_TMON_' + ['LVPS','AXB5','AXB6'] + '_C'
pclose

popen,'~/Desktop/imon.ps',/landscape
tplot,rbspx+'_efw_hsk_idpu_analog_IMON_' + ['BEB','IDPU','FVX','FVY','FVZ'] + '_C'
pclose

popen,'~/Desktop/vmon_beb.ps',/landscape
tplot,rbspx+'_efw_hsk_idpu_analog_VMON_BEB_' + ['P10VA','N10VA','P5VA','P5VD'] + '_C'
pclose

popen,'~/Desktop/vmon_idpu.ps',/landscape
tplot,rbspx+'_efw_hsk_idpu_analog_VMON_IDPU_' + ['P10VA','N10VA','P36VD','P18VD'] + '_C'
pclose


popen,'~/Desktop/idpu_p33_p15.ps',/landscape
tplot,rbspx+'_efw_hsk_idpu_analog_' + ['P33VD','P15VD'] + '_C'
pclose

popen,'~/Desktop/b1_b2.ps',/landscape
ylim,'fast_b1_thresh',-2,2
tplot,['ssr_per','fast_b1_evalmax','fast_b1_playreq','fast_b1_recbbi','fast_b1_receci','fast_b1_thresh','fast_b2_recstate','fast_b2_thresh']
pclose






end