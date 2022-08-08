;This finds properties of the microbursts during the conjunctions with RBSP

;This is kept separately from code that identifies chorus properties near conjunctions because 
;the identification of microbursts isn't so simple, and it's nice to have the flexibility to re-identify without having to rerun the 
;aforementioned programs. 

;For each FB/RBSP combination outputs a text file to
;conjunction_values/immediate_conjunction_microbursts/


;Microbursts are identified using Shumko's microburst id code 


;Properties identified include:
;max, median, average amplitude
;Total number of microbursts 
;Duty cycle 
;Duration



;--------------------------------------------------------
;User-defined variables
;--------------------------------------------------------

testing = 0
noplot = 1

rb = 'b'
fb = '4'

;add padding to the conjunction times for finding microbursts.
padsec = 100.


fbtmp = fb
rbtmp = rb


;--------------------------------------------------------
;Grab local path to save data
;--------------------------------------------------------

paths = get_project_paths()
pathoutput = paths.immediate_conjunction_microbursts



;--------------------------------------------------------
;Load the data from all identified conjunctions (from master_conjunction_list_part3.pro)
;--------------------------------------------------------


restore,paths.breneman_conjunctions + 'FU'+fbtmp+'_RBSP'+strupcase(rbtmp)+'_conjunctions_hr.sav'
nconj = n_elements(t0)





;--------------------------------------------------------
;Print list of times (since these are based on FB ephemeris data, they don't need a time correction)
;--------------------------------------------------------

for bb=0,nconj-1 do print,bb,' ',time_string(t0[bb])



;-----------------------------------------------------
;Find microburst properties based on Shumko list. 
;This list now has flux values!
;-----------------------------------------------------

;ub_filename = 'FU'+fbtmp+'_microburst_catalog_00.csv'
ub_filename = 'FU'+fbtmp+'_microburst_catalog_01.csv'
;ub_filename = 'FU'+fbtmp+'_microburst_catalog_02.csv'
;ub_filename = 'FU'+fbtmp+'_microburst_catalog_03.csv'

ub = firebird_load_shumko_microburst_list(fbtmp,filename=ub_filename)

goodv = where(finite(ub.flux_0) ne 0.)
ubtimes = ub.time[goodv]
ubflux = ub.flux_0[goodv]



;------------------------------------------------------
;Testing microburst id times 
;------------------------------------------------------

;store_data,'ub_shumko_flux',data={x:time_double(ubtimes),y:ubflux}
;options,'ub_shumko_flux','psym',4
;options,'ub_shumko_flux','symsize',1
;options,'ub_shumko_flux','thick',2
;options,'ub_shumko_flux','color',250
;ylim,['ub_shumko_flux'],0,150
;tplot,['ub_shumko_flux']
;stop





;------------------------------------------------------
;Loop through every conjuction day
;------------------------------------------------------

for j=0.,nconj-1 do begin

  fbtmp = fb

  
  goo = where((time_double(ubtimes) ge t0[j]-padsec) and (time_double(ubtimes) le t1[j]+padsec))
  

  ;Calculate flux properties during the conjunction
  if goo[0] ne -1 then begin
    max_flux = max(ubflux[goo],/nan)
    avg_flux = mean(ubflux[goo],/nan)
    med_flux = median(ubflux[goo])
    num_ub = n_elements(goo)
  endif else begin
    max_flux = !values.f_nan
    avg_flux = !values.f_nan
    med_flux = !values.f_nan
    num_ub = !values.f_nan
  endelse
  
  


  ;---------------------------------------------------------------
  ;If first time opening file, then print the header
  ;---------------------------------------------------------------



	fn_save = 'RBSP'+rbtmp+'_'+fbtmp+'_conjunction_microbursts.txt'

	result = FILE_TEST(pathoutput + fn_save)


	if not result then begin
		openw,lun,pathoutput + fn_save,/get_lun
		printf,lun,'Conjunction microburst data for RBSP'+rbtmp+' and '+fbtmp + ' based on conjunctions from RBSP'+rbtmp+'_'+fbtmp+'_conjunction_values_hr.txt'
    printf,lun,'From ' + fbtmp+'_microburst_catalog_01.csv' + ' microburst catalog'
    printf,lun,'Tstart  Tend    number_uB   maxflux   avgflux   medflux'
		close,lun
		free_lun,lun
	endif




	tstart = time_string(t0[j])
	tend = time_string(t1[j])
	num_ub =   string(num_ub,format='(F10.0)')
  max_flux = string(max_flux,format='(F12.2)')
  avg_flux = string(avg_flux,format='(F12.2)')
  med_flux = string(med_flux,format='(F12.2)')


	print,time_string(t0[j]),'  ', time_string(t1[j]) + num_ub + max_flux + avg_flux + med_flux



	openw,lun,pathoutput + fn_save,/get_lun,/append
	printf,lun,tstart+' '+tend+' '+ num_ub + max_flux + avg_flux+ med_flux
	close,lun
	free_lun,lun




endfor
end


