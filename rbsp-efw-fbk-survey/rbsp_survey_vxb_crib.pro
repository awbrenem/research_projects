;Crib sheet for creating, getting and plotting long durations of survey data.


;pass along structure with all relevant data


info = {probe:'a',$
	   d0:'2012-10-13',$
	   d1:'2012-10-19',$
	   dt:60.,$
	   tag:'vxb'}

rbsp_efw_init


;Create the actual data and save as ASCII
rbsp_survey_vxb_create_ascii,info
help,info,/st


;Read ASCII file and store data as tplot vars
rbsp_survey_vxb_read_ascii,info 
help,info,/st


;Get the RBSP positional data for the appropriate times
rbsp_survey_create_ephem_ascii,info


;Read in the positional data and save as tplot vars
rbsp_survey_ephem_read_ascii,info



;   1 vxb                 
;   2 Esvy                
;   3 Bsvy                
;   4 rbspa_state_pos_sm  
;   5 rbspa_state_pos_sm2 
;   6 radius              
;   7 mlt                 
;   8 lshell              
;   9 mlat                
;  10 ilat                

dif_data,'Esvy','vxb'

split_vec,'Esvy'
split_vec,'vxb'
split_vec,'Esvy-vxb'



;E-vxb vs time
tplot,['Esvy-vxb_x','Esvy-vxb_y','Esvy-vxb_z']



get_data,'lshell',data=lshell
get_data,'mlt',data=mlt
get_data,'Esvy-vxb_x',data=Ediffx
get_data,'Esvy-vxb_y',data=Ediffy
get_data,'Esvy-vxb_z',data=Ediffz

!p.charsize = 1.8
!p.multi = [0,0,3]
plot,lshell.y,Ediffx.y,title='MGSE  Ex-(vxb)x vs Lshell'
plot,lshell.y,Ediffy.y,title='MGSE  Ey-(vxb)y vs Lshell'
plot,lshell.y,Ediffz.y,title='MGSE  Ez-(vxb)z vs Lshell'


!p.charsize = 1.8
!p.multi = [0,0,3]
plot,mlt.y,Ediffx.y,title='MGSE  Ex-(vxb)x vs MLT'
plot,mlt.y,Ediffy.y,title='MGSE  Ey-(vxb)y vs MLT'
plot,mlt.y,Ediffz.y,title='MGSE  Ez-(vxb)z vs MLT'





