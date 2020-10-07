;tplot_restore,filenames='/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/FB_calibrated_counts_flux.tplot'


;****************************
;Create the calibrated flux file...only have to do once:

fn = 'FU4_Hires_2016-01-20_L2.txt'
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/'

openr,lun,path+fn,/get_lun

jnk = ''
for i=0,84 do readf,lun,jnk


time = ''
flux1='' & flux2='' & flux3='' & flux4='' & flux5='' & flux6=''
counts1='' & counts2='' & counts3='' & counts4='' & counts5='' & counts6=''
i = 0d

while not eof(lun) do begin

readf,lun,jnk

vals = strsplit(jnk,' ',/extract)

time = [time,vals[0]]
flux1 = [flux1,vals[1]]
flux2 = [flux2,vals[2]]
flux3 = [flux3,vals[3]]
flux4 = [flux4,vals[4]]
flux5 = [flux5,vals[5]]
flux6 = [flux6,vals[6]]

counts1 = [counts1,vals[13]]
counts2 = [counts2,vals[14]]
counts3 = [counts3,vals[15]]
counts4 = [counts4,vals[16]]
counts5 = [counts5,vals[17]]
counts6 = [counts6,vals[18]]


i++
endwhile

time = time[1:i]
flux1 = flux1[1:i]
flux2 = flux2[1:i]
flux3 = flux3[1:i]
flux4 = flux4[1:i]
flux5 = flux5[1:i]
flux6 = flux6[1:i]
counts1 = counts1[1:i]
counts2 = counts2[1:i]
counts3 = counts3[1:i]
counts4 = counts4[1:i]
counts5 = counts5[1:i]
counts6 = counts6[1:i]

time2 = time_double(time_string(time,prec=3))

;9/4.94 corrects the flux values for J. Sample's better geometric factor
store_data,'flux1',time2,float(flux1)*(9/4.94)
store_data,'flux2',time2,float(flux2)*(9/4.94)
store_data,'flux3',time2,float(flux3)*(9/4.94)
store_data,'flux4',time2,float(flux4)*(9/4.94)
store_data,'flux5',time2,float(flux5)*(9/4.94)
store_data,'flux6',time2,float(flux6)*(9/4.94)
store_data,'counts1',time2,float(counts1)
store_data,'counts2',time2,float(counts2)
store_data,'counts3',time2,float(counts3)
store_data,'counts4',time2,float(counts4)
store_data,'counts5',time2,float(counts5)
store_data,'counts6',time2,float(counts6)

options,'flux1','ytitle','Flux 251.5 keV'
options,'flux2','ytitle','Flux 333.5 keV'
options,'flux3','ytitle','Flux 452.0 keV'
options,'flux4','ytitle','Flux 620.5 keV'
options,'flux5','ytitle','Flux 852.8 keV'
options,'flux6','ytitle','Flux >984 keV'
options,'counts1','ytitle','counts 251.5 keV'
options,'counts2','ytitle','counts 333.5 keV'
options,'counts3','ytitle','counts 452.0 keV'
options,'counts4','ytitle','counts 620.5 keV'
options,'counts5','ytitle','counts 852.8 keV'
options,'counts6','ytitle','counts >984 keV'


tplot_save,'*',filename='~/Desktop/FB_calibrated_counts_flux'




rbsp_efw_init
tplot,'flux*'
t0 = time_double('2016-01-20/19:43:20')
t1 = time_double('2016-01-20/19:44:40')
tlimit,t0,t1

stop
;SAVE DATA FOR LUNJIN
get_data,'flux1',data=d1
get_data,'flux2',data=d2
get_data,'flux3',data=d3
get_data,'flux4',data=d4
get_data,'flux5',data=d5
get_data,'flux6',data=
times = d1.x - d1.x[0]
;times are seconds from 2016-01-20/11:43:00.982


openw,lun,'~/Desktop/FB4_flux_20160120.txt',/get_lun
;for i=0L,n_elements(d0.x)-1 do print,d0.x[i],d0.y[i],d1.y[i],d2.y[i],d3.y[i],d4.y[i],d5.y[i]
;for i=0L,20 do print,times[i],d1.y[i],d2.y[i],d3.y[i],d4.y[i],d5.y[i],d6.y[i],format='(f10.3,5x,6(f6.0))'

printf,lun,'Times (first column) are seconds since 2016-01-20/11:43:00.982'
printf,lun,'Energy channels (keV) 251  333  452   620   852   >984'
printf,lun,'UNITS: counts cm^-2 s^-1 sr^-1 keV^-1 for lowest 5 channels, counts cm^-2 s^-1 sr^-1 for integral channel'
for i=0L,n_elements(d1.x)-1 do printf,lun,times[i],d1.y[i],d2.y[i],d3.y[i],d4.y[i],d5.y[i],d6.y[i],format='(d10.3,3x,6(f6.0))'

close,lun & free_lun,lun



end
