;Plot all available payloads (BARREL, Cluster, Themis, RBSP, GOES, LANL) on a dial
;plot for either a single time or multiple times.


;Satellite files created with load_sscweb_ephemeris_for_satellites.pro
;t --> time (e.g. '2014-01-01/21:00'). Values have thus far been created for the two
;BARREL campaigns.
;noload --> if tplot variables and LANL IDL variables are already loaded, then
;           you can set this (best for replotting).
;plotpp --> add to overlay the Goldstein plasmapause location

pro plot_dial_payload_location_specific_time,t,noload=noload,ps=ps,charsize=chrsz,plotpp=plotpp

if ~KEYWORD_SET(chrsz) then chrsz = 1.
if keyword_set(plotpp) then nppp = 0. else nppp = 1.

xrange = [-13,13]
yrange = xrange

t = time_double(t)
ntimes = n_elements(t)


;The ephemeris files for missions of interest for
;both campaigns 1 and 2
fn = ['Cluster1_campaign1_ephem.sav','Cluster1_campaign2_ephem.sav',$
'Cluster2_campaign1_ephem.sav','Cluster2_campaign2_ephem.sav',$
'Cluster3_campaign1_ephem.sav','Cluster3_campaign2_ephem.sav',$
'Cluster4_campaign1_ephem.sav','Cluster4_campaign2_ephem.sav',$
'GOES13_campaign1_ephem.sav','GOES13_campaign2_ephem.sav',$
'GOES15_campaign1_ephem.sav','GOES15_campaign2_ephem.sav',$
'RBSPa_campaign1_ephem.sav','RBSPa_campaign2_ephem.sav',$
'RBSPb_campaign1_ephem.sav','RBSPb_campaign2_ephem.sav',$
'THA_campaign1_ephem.sav','THA_campaign2_ephem.sav',$
'THB_campaign1_ephem.sav','THB_campaign2_ephem.sav',$
'THC_campaign1_ephem.sav','THC_campaign2_ephem.sav',$
'THD_campaign1_ephem.sav','THD_campaign2_ephem.sav',$
'THE_campaign1_ephem.sav','THE_campaign2_ephem.sav']

prefix = ['C1','C1','C2','C2','C3','C3','C4','C4','G13','G13','G15','G15','RBa',$
'RBa','RBb','RBb','THA','THA','THB','THB','THC','THC','THD','THD','THE','THE']

;Color for the above payloads
colorplot = [120,120,120,120,120,120,120,120,254,254,254,254,200,200,200,200,50,50,50,50,50,50,50,50,50,50]


rbsp_efw_init
ephem = 'folder_singlepayload'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/'
path2 = path + ephem



if keyword_set(ps) then begin
    ttmp = time_string(t[0])
    timetitle = strmid(ttmp,0,4)+strmid(ttmp,5,2)+strmid(ttmp,8,2)+'_'+strmid(ttmp,11,2)+strmid(ttmp,14,2)+strmid(ttmp,17,2)+'UT'
    popen,'~/Desktop/psphere_plot_'+timetitle+'.ps'
    !p.charsize = 0.4
    !p.font = 0.
    device,/helvetica,font_size=9,/bold
endif

;dummy plot

plot_plasmapause_goldstein_boundary,time_string(t[0]),0.,0.,payloadname='',symbolplot=3,noplotpp=nppp,yrange=yrange,xrange=xrange,xsize=800,extratitle=time_string(t[0]),charsize=chrsz


;-----------------------------------------------------
;load and plot all BARREL payload files for campaign 1
;-----------------------------------------------------

payloads = strupcase(['b','d','i','g','c','h','a','j','k','m','o','q','r','s','t','u','v'])
for i=0,n_elements(payloads)-1 do begin
    tms = !values.f_nan
    if ~keyword_set(noload) then tplot_restore,filenames=path2 + '/' + 'barrel_1'+payloads[i]+'_fspc_fullmission.tplot'

    for j=0,ntimes-1 do begin
      mltv = tsample('MLT_Kp2_1'+payloads[i],t[j],times=tms)
      lv = tsample('L_Kp2_1'+payloads[i],t[j],times=goo)
      tdiff = tms - t[j]
      print,'1'+payloads[i],abs(tdiff)
      pln = '1'+payloads[i]+strtrim(j,2)
      if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,charsize=chrsz
      print,'****'
      print,'BARREL 1'+payloads[i]+' MLT=',mltv,' L=',lv
    endfor
endfor


;-----------------------------------------------------
;load and plot all BARREL payload files for campaign 2
;-----------------------------------------------------

payloads = strupcase(['i','t','w','k','l','x','a','b','e','o','p'])
for i=0,n_elements(payloads)-1 do begin
    tms = !values.f_nan
    if ~keyword_set(noload) then tplot_restore,filenames=path2 + '/' + 'barrel_2'+payloads[i]+'_fspc_fullmission.tplot'
    for j=0,ntimes-1 do begin
      mltv = tsample('MLT_Kp2_2'+payloads[i],t[j],times=tms)
      lv = tsample('L_Kp2_2'+payloads[i],t[j],times=goo)
      tdiff = tms - t[j]
      print,'2'+payloads[i],abs(tdiff)
      pln = '2'+payloads[i]+strtrim(j,2)
      if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,charsize=chrsz
      print,'****'
      print,'BARREL 2'+payloads[i]+' MLT=',mltv,' L=',lv
    endfor
endfor


;-----------------------------------------------------
;load and plot all satellite positions
;Cluster, Themis, RBSP, GOES
;-----------------------------------------------------

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/ephemeris_allsatellites/'
for i=0,n_elements(fn)-1 do begin
    restore,path+fn[i]
    for j=0,ntimes-1 do begin
      good = where(vals.datetime ge t[j])
      tdiff = t[j] - vals.datetime[good[0]]
      mltv = vals.gselt[good[0]]
      lv = vals.dipl[good[0]]
      pln = prefix[i]+strtrim(j,2)
      if abs(tdiff) lt 20*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,colorplot=colorplot[i],charsize=chrsz
      print,prefix[i],'MLT=',mltv,' L=',lv
    endfor
endfor


;-------------------------------------------------
;load and plot LANL sat positions
;-------------------------------------------------

;Determine if we're requesting campaign 1 or 2 data
yeartmp = strmid(time_string(t[0]),0,4)
if yeartmp eq '2013' then camptmp = '1'
if yeartmp eq '2014' then camptmp = '2'

if camptmp eq '1' then days = '2013' + ['0114','0115','0116','0117','0118','0119','0120','0121','0122','0123','0124','0125','0126','0127','0128','0129','0130','0131','0201','0202','0203','0204','0205','0206']
if camptmp eq '2' then days = '2014' + ['0101','0102','0103','0104','0105','0106','0107','0108','0109','0110','0111','0112','0113','0114','0115']
if camptmp eq '1' then folders2 = ['Jan14','Jan15','Jan16','Jan17','Jan18','Jan19','Jan20','Jan21','Jan22','Jan23','Jan24','Jan25','Jan26','Jan27','Jan28','Jan29','Jan30','Jan31','Feb1','Feb2','Feb3','Feb4','Feb5','Feb6']
if camptmp eq '2' then folders2 = ['Jan1','Jan2','Jan3','Jan4','Jan5','Jan6','Jan7','Jan8','Jan9','Jan10','Jan11','Jan12','Jan13','Jan14','Jan15']

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign'+camptmp+'/'
;folders2 = 'Jan'+strtrim(1+indgen(15),2)


colorlanl = 85.
datestmp = strmid(days,0,4) + '-' + strmid(days,4,2) + '-' + strmid(days,6,2) + '/00:00:00'

for j=0,ntimes-1 do begin
  ttmp = time_double(strmid(time_string(t[j]),0,10))
  tdiffgoo = time_double(datestmp)-ttmp
  correctfolder = where(tdiffgoo eq 0.)

  tms = !values.f_nan
  tplot_restore,filenames=path+folders2[correctfolder]+'/'+'lanl_sat_LANL-97A_'+days[correctfolder]+'.tplot'
  mltv = tsample('LANL-97A_mlt',t[j],times=tms) & lv = tsample('LANL-97A_RE',t[j])
  tdiff = tms - t[j]
  pln = 'L97A'+strtrim(j,2)
  if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,colorplot=colorlanl,charsize=chrsz
  print,'LANL-97A MLT=',mltv,' L=',lv

  tms = !values.f_nan
  tplot_restore,filenames=path+folders2[correctfolder]+'/'+'lanl_sat_LANL-04A_'+days[correctfolder]+'.tplot'
  mltv = tsample('LANL-04A_mlt',t[j],times=tms) & lv = tsample('LANL-04A_RE',t[j])
  tdiff = tms - t[j]
  pln = 'L04A'+strtrim(j,2)
  if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,colorplot=colorlanl,charsize=chrsz
  print,'LANL-04A MLT=',mltv,' L=',lv

  tms = !values.f_nan
  tplot_restore,filenames=path+folders2[correctfolder]+'/'+'lanl_sat_LANL-02A_'+days[correctfolder]+'.tplot'
  mltv = tsample('LANL-02A_mlt',t[j],times=tms) & lv = tsample('LANL-02A_RE',t[j])
  tdiff = tms - t[j]
  pln = 'L02A'+strtrim(j,2)
  if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,colorplot=colorlanl,charsize=chrsz
  print,'LANL-02A MLT=',mltv,' L=',lv

  tms = !values.f_nan
  tplot_restore,filenames=path+folders2[correctfolder]+'/'+'lanl_sat_LANL-01A_'+days[correctfolder]+'.tplot'
  mltv = tsample('LANL-01A_mlt',t[j],times=tms) & lv = tsample('LANL-01A_RE',t[j])
  tdiff = tms - t[j]
  pln = 'L01A'+strtrim(j,2)
  if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,colorplot=colorlanl,charsize=chrsz
  print,'LANL-01A MLT=',mltv,' L=',lv

  tms = !values.f_nan
  tplot_restore,filenames=path+folders2[correctfolder]+'/'+'lanl_sat_1994-084_'+days[correctfolder]+'.tplot'
  mltv = tsample('1994-084_mlt',t[j],times=tms) & lv = tsample('1994-084_RE',t[j])
  tdiff = tms - t[j]
  pln = 'L084'+strtrim(j,2)
  if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,colorplot=colorlanl,charsize=chrsz
  print,'LANL-1994-084 MLT=',mltv,' L=',lv

  tms = !values.f_nan
  tplot_restore,filenames=path+folders2[correctfolder]+'/'+'lanl_sat_1991-080_'+days[correctfolder]+'.tplot'
  mltv = tsample('1991-080_mlt',t[j],times=tms) & lv = tsample('1991-080_RE',t[j])
  tdiff = tms - t[j]
  pln = 'L080'+strtrim(j,2)
  if abs(tdiff) lt 5*60. then plot_plasmapause_goldstein_boundary,t[j],mltv,lv,symbolplot=3,payloadname=pln,/oplot,colorplot=colorlanl,charsize=chrsz
  print,'LANL-1991-080 MLT=',mltv,' L=',lv

endfor

if keyword_set(ps) then pclose

end
