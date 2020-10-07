;Read in the RBSP/FIREBIRD conjunction summary files created by
;master_conjunction_list_part3.pro and part1 and part2
;Outputs statistics on conjunctions, like:
;# conjunctions
;hours of B1, B2, EMFISIS burst total.
;etc...

;Also plot histograms of conjunctions vs L, MLT, separation, etc...


rbsp_efw_init
tplot_options,'title','master_conjunction_list_part4.pro'

hires = 1

if KEYWORD_SET(hires) then $
  suffix = '_conjunction_values_hr.txt' else $
  suffix = '_conjunction_values.txt'


path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/all_conjunctions_with_hires_data/RBSPa_FU3_burst_minutes/'
fn = 'RBSPa_FU3'+suffix
openr,lun,path+fn,/get_lun
jnk = ''
readf,lun,jnk
;date					  L		 MLT     mnsep	  dL	   dMLT   col	sur	  EMFb   B1b   B2b  7E4	 7E5  7E6  7B4  7B5	7B6  13E7 13E8 13E9 13E10 13E11	13E12 13B7 13B8	13B9 13B10 13B11 13B12
;2015-06-11     5.8  18.7     1.830  0.287    1.219   94 317   749     0     0    0    0    0    5    0   3    0    0     0    0     0     0     0    0    0    0    0     0


datetime = '' & lshell = '' & mlt = '' & min_sep = '' & dlmin = '' & dmltmin = ''
max_flux_col = '' & max_flux_sur = '' & nsec_EMF_burst = ''
nsec_B1_burst = '' & nsec_B2_burst	= ''
fbk7_Ewmax = [[''],[''],['']] & fbk7_Bwmax = [[''],[''],['']]
fbk13_Ewmax = [[''],[''],[''],[''],[''],['']] & fbk13_Bwmax = [[''],[''],[''],[''],[''],['']]


while not eof(lun) do begin
  readf,lun,jnk
  vals = strsplit(jnk,' ',/extract)
  datetime = [datetime,vals[0]]
  lshell = [lshell,vals[1]]
  mlt = [mlt,vals[2]]
  min_sep = [min_sep,vals[3]]
  dlmin = [dlmin,vals[4]]
  dmltmin  = [dmltmin,vals[5]]
  max_flux_col = [max_flux_col,vals[6]]
  max_flux_sur = [max_flux_sur,vals[7]]
  nsec_EMF_burst = [nsec_EMF_burst,vals[8]]
  nsec_B1_burst = [nsec_B1_burst,vals[9]]
  nsec_B2_burst = [nsec_B2_burst,vals[10]]
  fbk7_Ewmax = [[fbk7_Ewmax[*,0],vals[11]],[fbk7_Ewmax[*,1],vals[12]],[fbk7_Ewmax[*,2],vals[13]]]
  fbk7_Bwmax = [[fbk7_Bwmax[*,0],vals[14]],[fbk7_Bwmax[*,1],vals[15]],[fbk7_Bwmax[*,2],vals[16]]]
  fbk13_Ewmax = [[fbk13_Ewmax[*,0],vals[17]],[fbk13_Ewmax[*,1],vals[18]],[fbk13_Ewmax[*,2],vals[19]],[fbk13_Ewmax[*,0],vals[20]],[fbk13_Ewmax[*,0],vals[21]],[fbk13_Ewmax[*,0],vals[22]]]
  fbk13_Bwmax = [[fbk13_Bwmax[*,0],vals[23]],[fbk13_Bwmax[*,1],vals[24]],[fbk13_Bwmax[*,2],vals[25]],[fbk13_Bwmax[*,0],vals[26]],[fbk13_Bwmax[*,0],vals[27]],[fbk13_Bwmax[*,0],vals[28]]]
endwhile


close,lun
free_lun,lun




path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/all_conjunctions_with_hires_data/RBSPa_FU4_burst_minutes/'
fn = 'RBSPa_FU4'+suffix
openr,lun,path+fn,/get_lun
jnk = ''
readf,lun,jnk
while not eof(lun) do begin
  readf,lun,jnk
  vals = strsplit(jnk,' ',/extract)
  datetime = [datetime,vals[0]]
  lshell = [lshell,vals[1]]
  mlt = [mlt,vals[2]]
  min_sep = [min_sep,vals[3]]
  dlmin = [dlmin,vals[4]]
  dmltmin  = [dmltmin,vals[5]]
  max_flux_col = [max_flux_col,vals[6]]
  max_flux_sur = [max_flux_sur,vals[7]]
  nsec_EMF_burst = [nsec_EMF_burst,vals[8]]
  nsec_B1_burst = [nsec_B1_burst,vals[9]]
  nsec_B2_burst = [nsec_B2_burst,vals[10]]
  fbk7_Ewmax = [[fbk7_Ewmax[*,0],vals[11]],[fbk7_Ewmax[*,1],vals[12]],[fbk7_Ewmax[*,2],vals[13]]]
  fbk7_Bwmax = [[fbk7_Bwmax[*,0],vals[14]],[fbk7_Bwmax[*,1],vals[15]],[fbk7_Bwmax[*,2],vals[16]]]
  fbk13_Ewmax = [[fbk13_Ewmax[*,0],vals[17]],[fbk13_Ewmax[*,1],vals[18]],[fbk13_Ewmax[*,2],vals[19]],[fbk13_Ewmax[*,0],vals[20]],[fbk13_Ewmax[*,0],vals[21]],[fbk13_Ewmax[*,0],vals[22]]]
  fbk13_Bwmax = [[fbk13_Bwmax[*,0],vals[23]],[fbk13_Bwmax[*,1],vals[24]],[fbk13_Bwmax[*,2],vals[25]],[fbk13_Bwmax[*,0],vals[26]],[fbk13_Bwmax[*,0],vals[27]],[fbk13_Bwmax[*,0],vals[28]]]
endwhile
close,lun
free_lun,lun



path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/all_conjunctions_with_hires_data/RBSPb_FU3_burst_minutes/'
fn = 'RBSPb_FU3'+suffix
openr,lun,path+fn,/get_lun
jnk = ''
readf,lun,jnk
while not eof(lun) do begin
  readf,lun,jnk
  vals = strsplit(jnk,' ',/extract)
  datetime = [datetime,vals[0]]
  lshell = [lshell,vals[1]]
  mlt = [mlt,vals[2]]
  min_sep = [min_sep,vals[3]]
  dlmin = [dlmin,vals[4]]
  dmltmin  = [dmltmin,vals[5]]
  max_flux_col = [max_flux_col,vals[6]]
  max_flux_sur = [max_flux_sur,vals[7]]
  nsec_EMF_burst = [nsec_EMF_burst,vals[8]]
  nsec_B1_burst = [nsec_B1_burst,vals[9]]
  nsec_B2_burst = [nsec_B2_burst,vals[10]]
  fbk7_Ewmax = [[fbk7_Ewmax[*,0],vals[11]],[fbk7_Ewmax[*,1],vals[12]],[fbk7_Ewmax[*,2],vals[13]]]
  fbk7_Bwmax = [[fbk7_Bwmax[*,0],vals[14]],[fbk7_Bwmax[*,1],vals[15]],[fbk7_Bwmax[*,2],vals[16]]]
  fbk13_Ewmax = [[fbk13_Ewmax[*,0],vals[17]],[fbk13_Ewmax[*,1],vals[18]],[fbk13_Ewmax[*,2],vals[19]],[fbk13_Ewmax[*,0],vals[20]],[fbk13_Ewmax[*,0],vals[21]],[fbk13_Ewmax[*,0],vals[22]]]
  fbk13_Bwmax = [[fbk13_Bwmax[*,0],vals[23]],[fbk13_Bwmax[*,1],vals[24]],[fbk13_Bwmax[*,2],vals[25]],[fbk13_Bwmax[*,0],vals[26]],[fbk13_Bwmax[*,0],vals[27]],[fbk13_Bwmax[*,0],vals[28]]]
endwhile
close,lun
free_lun,lun


path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/all_conjunctions_with_hires_data/RBSPb_FU4_burst_minutes/'
fn = 'RBSPb_FU4'+suffix
openr,lun,path+fn,/get_lun
jnk = ''
readf,lun,jnk
while not eof(lun) do begin
  readf,lun,jnk
  vals = strsplit(jnk,' ',/extract)
  datetime = [datetime,vals[0]]
  lshell = [lshell,vals[1]]
  mlt = [mlt,vals[2]]
  min_sep = [min_sep,vals[3]]
  dlmin = [dlmin,vals[4]]
  dmltmin  = [dmltmin,vals[5]]
  max_flux_col = [max_flux_col,vals[6]]
  max_flux_sur = [max_flux_sur,vals[7]]
  nsec_EMF_burst = [nsec_EMF_burst,vals[8]]
  nsec_B1_burst = [nsec_B1_burst,vals[9]]
  nsec_B2_burst = [nsec_B2_burst,vals[10]]
  fbk7_Ewmax = [[fbk7_Ewmax[*,0],vals[11]],[fbk7_Ewmax[*,1],vals[12]],[fbk7_Ewmax[*,2],vals[13]]]
  fbk7_Bwmax = [[fbk7_Bwmax[*,0],vals[14]],[fbk7_Bwmax[*,1],vals[15]],[fbk7_Bwmax[*,2],vals[16]]]
  fbk13_Ewmax = [[fbk13_Ewmax[*,0],vals[17]],[fbk13_Ewmax[*,1],vals[18]],[fbk13_Ewmax[*,2],vals[19]],[fbk13_Ewmax[*,0],vals[20]],[fbk13_Ewmax[*,0],vals[21]],[fbk13_Ewmax[*,0],vals[22]]]
  fbk13_Bwmax = [[fbk13_Bwmax[*,0],vals[23]],[fbk13_Bwmax[*,1],vals[24]],[fbk13_Bwmax[*,2],vals[25]],[fbk13_Bwmax[*,0],vals[26]],[fbk13_Bwmax[*,0],vals[27]],[fbk13_Bwmax[*,0],vals[28]]]
endwhile
close,lun
free_lun,lun




stop








ngood = n_elements(datetime)-1

datetime = time_double(datetime[1:ngood])
lshell = float(lshell[1:ngood])
mlt = float(mlt[1:ngood])
min_sep = float(min_sep[1:ngood])
dlmin = float(dlmin[1:ngood])
dmltmin = float(dmltmin[1:ngood])
max_flux_col = float(max_flux_col[1:ngood])
max_flux_sur = float(max_flux_sur[1:ngood])
nsec_EMF_burst = float(nsec_EMF_burst[1:ngood])
nsec_B1_burst = float(nsec_B1_burst[1:ngood])
nsec_B2_burst = float(nsec_B2_burst[1:ngood])


;FBK7 bins
;1) 200-400 Hz
;2) 0.8-1.6 kHz
;3) 3.2-6.5 kHz
fbk7_Ewmax = float([[fbk7_Ewmax[1:ngood,0]],[fbk7_Ewmax[1:ngood,1]],[fbk7_Ewmax[1:ngood,2]]])
fbk7_Bwmax = float([[fbk7_Bwmax[1:ngood,0]],[fbk7_Bwmax[1:ngood,1]],[fbk7_Bwmax[1:ngood,2]]])


fbk13_Ewmax = float([[fbk13_Ewmax[1:ngood,0]],[fbk13_Ewmax[1:ngood,1]],[fbk13_Ewmax[1:ngood,2]],[fbk13_Ewmax[1:ngood,3]],[fbk13_Ewmax[1:ngood,4]],[fbk13_Ewmax[1:ngood,5]]])
fbk13_Bwmax = float([[fbk13_Bwmax[1:ngood,0]],[fbk13_Bwmax[1:ngood,1]],[fbk13_Bwmax[1:ngood,2]],[fbk13_Bwmax[1:ngood,3]],[fbk13_Bwmax[1:ngood,4]],[fbk13_Bwmax[1:ngood,5]]])


;;**************
;;BAND AID FIX...WILL BE CORRECTED NEXT TIME I RUN THE BURST AVAILABILITY PROGRAM
;boo = where(fbk13_Bwmax[*,0] ne 0.)
;fbk7_Ewmax[boo,*] = 0.
;fbk7_Bwmax[boo,*] = 0.
;;**************


days_relative = (datetime - datetime[0])/86400

store_data,'lshell',datetime,lshell
store_data,'mlt',datetime,mlt

store_data,'fbk7_Ew',datetime,fbk7_Ewmax
store_data,'fbk7_Bw',datetime,fbk7_Bwmax

store_data,'fbk13_Ew',datetime,fbk13_Ewmax
store_data,'fbk13_Bw',datetime,fbk13_Bwmax


;Combine FBK13 and FBK7 into single plot
store_data,'fbk_Bw_comb',data=['fbk13_Bw','fbk7_Bw']
store_data,'fbk_Ew_comb',data=['fbk13_Ew','fbk7_Ew']




store_data,'max_flux_col',datetime,max_flux_col
store_data,'max_flux_sur',datetime,max_flux_sur

ylim,'max_flux_???',10,8000,1
ylim,'max_flux_???',10,8000,0
options,['lshell','mlt','fbk_Ew_comb','fbk_Bw_comb','fbk13_Bw','fbk7_Bw'],'psym',2
options,['max_flux_col','max_flux_sur'],'psym',4
options,['lshell','mlt','fbk_Ew_comb','fbk_Bw_comb','fbk13_Bw','fbk7_Bw'],'symsize',1
options,['max_flux_col','max_flux_sur'],'symsize',2

t0 = min(datetime) & t1 = max(datetime)
tlimit,t0,t1
tplot,['lshell','mlt','max_flux_col','max_flux_sur','fbk_Ew_comb','fbk_Bw_comb']
stop

;Compare max Bw amplitudes to FB flux
ylim,'max_flux_???',0,0,0
ylim,'fbk_Ew_comb',0,0,0
ylim,'fbk_Bw_comb',0,0,0

ylim,'max_flux_???',1d1,1d4,1
ylim,'fbk_Ew_comb',1d0,1d4,1
ylim,'fbk_Bw_comb',1d0,1d4,1


store_data,'alldat_comb',data=['fbk13_Bw','fbk7_Bw','max_flux_sur']

;ylim,['max_flux_???','fbk_Ew_comb','fbk_Bw_comb'],0,0,1
tplot,['mlt','max_flux_col','max_flux_sur','fbk_Ew_comb','fbk_Bw_comb']
tplot,['mlt','max_flux_sur','fbk_Bw_comb']


popen,'~/Desktop/grab1.ps'
!p.charsize = 1.
tplot,['lshell','mlt','max_flux_col','fbk_Bw_comb']
pclose



;--------------------------------------------
;X vs Y plots of Bw amplitude vs FB flux
fbkcomb = [[fbk7_bwmax],[fbk13_bwmax]]
maxvb = fltarr(n_elements(fbkcomb[*,0]))
for i=0,n_elements(maxvb)-1 do maxvb[i] = max(fbkcomb[i,*])
get_data,'max_flux_sur',data=mfs
get_data,'max_flux_col',data=mfc


!p.multi = [0,0,2]
plot,maxvb,mfs.y,psym=4,xrange=[10,3000],yrange=[20,8000],/ylog,/xlog,symsize=2,ytitle='Bw vs FB!Csurface flux',xmargin=[20,16],title='master_conjunction_list_part4.pro',xtitle='VLF Bw amplitudes (pT)'
plot,maxvb,mfc.y,psym=4,xrange=[10,3000],yrange=[20,8000],/ylog,/xlog,symsize=2,ytitle='Bw vs FB!Ccolumn flux',xmargin=[20,16],xtitle='VLF Bw amplitudes (pT)'


fbkcomb = [[fbk7_ewmax],[fbk13_ewmax]]
maxve = fltarr(n_elements(fbkcomb[*,0]))
for i=0,n_elements(maxve)-1 do maxve[i] = max(fbkcomb[i,*])

!p.multi = [0,0,2]
plot,maxve,mfs.y,psym=4,xrange=[10,50],yrange=[20,8000],/ylog,/xlog,symsize=2,ytitle='Ew vs FB!Csurface flux',xtitle='VLF Ew amplitudes (mV/m)'
plot,maxve,mfc.y,psym=4,xrange=[10,50],yrange=[20,8000],/ylog,/xlog,symsize=2,ytitle='Ew vs FB!Csurface flux',xtitle='VLF Ew amplitudes (mV/m)'



;--------------------------------------------


lshell_hist = histogram(lshell,binsize=0.3,locations=loc_lshell)
mlt_hist = histogram(mlt,binsize=1,locations=loc_mlt)
minsep_hist = histogram(min_sep,binsize=0.2,locations=loc_minsep)
mindL_hist = histogram(abs(dLmin),binsize=0.1,locations=loc_dl)
mindMLT_hist = histogram(abs(dMLTmin),binsize=0.1,locations=loc_dMLT)

;plot,loc_lshell,lshell_hist,xtitle='Lshell',ytitle='# conjunctions',title='Conjunction histograms',ymargin=[3,1]
;plot,loc_mlt,mlt_hist,xtitle='MLT',ytitle='# conjunctions',ymargin=[3,1]
;plot,loc_minsep,minsep_hist,xtitle='minimum cross-field separation [RE]',ytitle='# conjunctions',ymargin=[3,1]
;plot,loc_dl,mindL_hist,xrange=[-0.5,0.5],xtitle='delta-Lshell (RBSP-FB) at minimum separation',ytitle='# conjunctions',ymargin=[3,1]
;plot,loc_dMLT,mindMLT_hist,xtitle='delta-MLT (RBSP-FB) at minimum separation',ytitle='# conjunctions',ymargin=[3,1]


b1 = barplot(loc_lshell,lshell_hist,layout=[1,5,1],fill_color='black',ytitle='# conj',xtitle='L',title='Conjunctions histograms for RBSP/FIREBIRD')
b2 = barplot(loc_mlt,mlt_hist,/current,layout=[1,5,2],fill_color='black',ytitle='# conj',xtitle='MLT')
b3 = barplot(loc_minsep,minsep_hist,/current,layout=[1,5,3],fill_color='black',ytitle='# conj',xtitle='min cross-field sep [RE]')
b4 = barplot(loc_dl,abs(mindl_hist),/current,layout=[1,5,4],fill_color='black',ytitle='# conj',xtitle='|dL| at min sep')
b5 = barplot(loc_dMLT,abs(mindMLT_hist),/current,layout=[1,5,5],fill_color='black',ytitle='# conj',xtitle='|dMLT| at min sep')
b1.save,'~/Desktop/grab1.eps'
;-----------------------




;Find totals, etc.
yyyymmdd = time_string(datetime,precision=-3)
b = yyyymmdd[UNIQ(yyyymmdd, SORT(yyyymmdd))]
print,'# unique days with conjunctions = ',n_elements(b)
;# unique days with conjunctions = 138
goo = where(nsec_EMF_burst ne 0.)
print,'# conjunctions with EMF burst = ',n_elements(goo)
;# conjunctions with EMF burst =           389
goo = where(nsec_B1_burst ne 0.)
print,'# conjunctions with B1 burst = ',n_elements(goo)
;# conjunctions with B1 burst =           62
goo = where(nsec_B2_burst ne 0.)
print,'# conjunctions with B2 burst = ',n_elements(goo)
;# conjunctions with B2 burst =           148

print,'# minutes with EMF burst = ',total(nsec_EMF_burst)/60.
;2540
print,'# minutes with B1 burst = ',total(nsec_B1_burst)/60.
;2571
print,'# minutes with B2 burst = ',total(nsec_B2_burst)/60.
;137






;----------------
emax = fltarr(n_elements(fbk7_ewmax[*,0]))
for q=0,n_elements(fbk7_ewmax[*,0])-1 do emax[q] = max(fbk7_ewmax[q,*])
bmax = fltarr(n_elements(fbk7_bwmax[*,0]))
for q=0,n_elements(fbk7_bwmax[*,0])-1 do bmax[q] = max(fbk7_bwmax[q,*])

goo = where(bmax ge 100.)





stop

end
