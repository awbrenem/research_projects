;Compare FBK7 Ew with Ew calculated from Bw
;This may give me an idea if I'm getting spuriously large Ew amplitudes when
;the antennas are near the resonance cone. 




date = '2013-03-17'
timespan,date
probe = 'a'
rbspx = 'rbsp' + probe

rbsp_load_efw_fbk,probe=probe,type='calibrated'
rbsp_efw_position_velocity_crib,/noplot
rbsp_load_emfisis,probe=probe,coord='gse',cadence='hires',level='l3'  
rbsp_load_emfisis,probe=probe,/quicklook

rbsp_split_fbk,probe


get_data,rbspx+'_efw_fbk_7_fb1_pk',data=Ew
get_data,rbspx+'_efw_fbk_7_fb2_pk',data=Bw

get_data,rbspx+'_emfisis_l3_hires_gse_Mag',data=mag
get_data,rbspx+'_emfisis_l3_hires_gse_Magnitude',data=Bo

bo2 = interpol(bo.y,bo.x,Ew.x)
mag2 = [[interpol(mag.y[*,0],mag.x,Ew.x)/bo2],[interpol(mag.y[*,1],mag.x,Ew.x)/bo2],[interpol(mag.y[*,2],mag.x,Ew.x)/bo2]]


fce = 28.*interpol(Bo.y,Bo.x,Ew.x)
store_data,'fce',data={x:Ew.x,y:fce}
tinterpol_mxn,rbspx+'_state_mlat',Ew.x,newname='mlat'


rbsp_survey_project_fce
get_data,'fce_eq',data=fce_eq



;Get accurate freqs

info = {probe:probe,fbk_mode:'7'}

;I'll use the Ew to find the freq and bin of the max element each time
;Ew seems to pick up the chorus better
rbsp_efw_fbk_freq_interpolate,rbspx+'_efw_fbk_7_fb1_pk',info


tplot,[rbspx+'_fbk_binnumber_of_max_orig',rbspx+'_fbk_freq_of_max_adj']

get_data,rbspx+'_fbk_binnumber_of_max_orig',data=binn

;Original Ew values (after freq interpolation)
get_data,rbspx+'_fbk_maxamp_adj',data=Ewvals_orig

;Original Ew values (based on the chosen Ew freq)
Bwvals = fltarr(n_elements(binn.y))
for i=0L,n_elements(Bw.y[*,0])-1 do Bwvals[i] = Bw.y[i,binn.y[i]]

;Frequencies of those values
get_data,rbspx+'_fbk_freq_of_max_adj',data=freqs

;Find which freqs are in chorus range
f2fce = freqs.y/fce_eq.y

;goodf = where((f2fce ge 0.1) and (f2fce le 1))


ckm = 3d5   ;km/s

;Ew values calculated from Bw
Ewvals = Bwvals*freqs.y*ckm/1000./sqrt(freqs.y*fce_eq.y^2/(fce_eq.y-freqs.y))


;Calculate whistler resonance cone angle
theta_res = acos(freqs.y/fce)/!dtor
store_data,'theta_res',data={x:Ew.x,y:theta_res}


;Find angle b/t spinaxis and Bo

tinterpol_mxn,'rbspa_spinaxis_direction_gse',Ew.x,newname='rbspa_spinaxis_direction_gse'

get_data,'rbspa_spinaxis_direction_gse',data=sa

angle = acos(mag2[*,0]*sa.y[*,0] + mag2[*,1]*sa.y[*,1] + mag2[*,2]*sa.y[*,2])/!dtor
store_data,'angle',data={x:Ew.x,y:angle}


;-----------------------------------------------------------------
;Find difference b/t resonance cone angle and spin plane antennas. 
;See if the antennas dramatically change their effective length when
;they are near the whistler resonance cone (Santolik's suggestion)
;-----------------------------------------------------------------


get_data,rbspx + '_emfisis_quicklook_Mag',data=maguvw
get_data,rbspx + '_emfisis_quicklook_Magnitude',data=bouvw

maguvw2 = [[maguvw.y[*,0]/bouvw.y],[maguvw.y[*,1]/bouvw.y],[maguvw.y[*,2]/bouvw.y]]


angle12 = acos(maguvw2[*,0])/!dtor
angle34 = acos(maguvw2[*,1])/!dtor
angle56 = acos(maguvw2[*,2])/!dtor

angle12 = interpol(angle12,maguvw.x,Ew.x)
angle34 = interpol(angle34,maguvw.x,Ew.x)
angle56 = interpol(angle56,maguvw.x,Ew.x)


store_data,'angle12',data={x:Ew.x,y:angle12}
store_data,'angle34',data={x:Ew.x,y:angle34}
store_data,'angle56',data={x:Ew.x,y:angle56}


dif_data,'angle12','theta_res',newname='a12_res_diff'
dif_data,'angle34','theta_res',newname='a34_res_diff'
dif_data,'angle56','theta_res',newname='a56_res_diff'

store_data,'Ew_orig_cmp',data={x:Ew.x,y:Ewvals_orig.y}

tplot,['a12_res_diff','Ew_orig_cmp']

;See if there is any trend for amps to be larger when we're near the res cone angle
get_data,'a12_res_diff',data=rd12
get_data,'Ew_orig_cmp',data=ewc

;plot with interpolated freqs
plot,rd12.y,ewc.y,psym=4,xtitle='Angle b/t E12 antenna and whistler res cone',ytitle='FBK Ew amp'

;plot with individual FBK bins
get_data,rbspx+'_fbk1_7pk_6',data=fbk7_e12
plot,rd12.y,fbk7_e12.y,xtitle='Angle b/t E12 antenna and whistler res cone',ytitle='FBK Ew amp'



;-------------------------------------------------------


goodv = where((angle ge 85.) and (angle le 95.) and (f2fce ge 0.1) and (f2fce le 1))


store_data,'Ew_from_Bw',data={x:Ew.x[goodv],y:Ewvals[goodv]}
store_data,'Ew_orig',data={x:Ew.x[goodv],y:Ewvals_orig.y[goodv]}
store_data,'Bw_orig',data={x:Ew.x[goodv],y:Bwvals[goodv]}

store_data,'Ew_comb',data=['Ew_orig','Ew_from_Bw']
options,'Ew_comb','colors',[0,250]


tplot,['Ew_comb','Bw_orig','angle',rbspx+'_efw_fbk_7_fb1_pk']



