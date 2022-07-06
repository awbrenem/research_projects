;Load the list that Mike Shumko's FIREBIRD microburst id code ("microburst_detection" package)
;spits out. These are individual microbursts pulled from the FIREBIRD flux data. 
;These microbursts have been time-corrected, as comparison to my detrended data from firebird_subtract_tumble...pro shows 


;Mike Shumko's code returns microburst counts. I can turn these into flux using firebird_get_calibration_counts2flux.pro 




;------------------------------------------------------------------------
;OBSOLETE - APPLIES ONLY TO THE OLDER MICROBURST FILES MIKE SHUMKO CREATED
;Listed microburst amplitudes ("sig0" through "sig5" in the .csv file) are actually signal/background ratio for each energy channel.
;To turn these into counts use:
;   counts = sig*sqrt(A+1) + A, 
;where A is the running average.
;Once in counts, these can be turned into fluxes using calibrations from 
;  firebird_get_calibration_counts2flux.pro. 
;Since the above conversions require loading of daily data, they aren't performed in this code. 
;------------------------------------------------------------------------




;fb = '3' or '4'  corresponding to FIREBIRD FU3 or FU4

function load_firebird_microburst_list,fb,filename=fntmp

    pathtmp = '/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_Firebird_Colpitts_Chen/microburst_detection/data/'

    if not keyword_set(fntmp) then fntmp = 'FU'+fb+'_microbursts.csv'

;fntmp= 'FU4_microburst_catalog_background=0.5_foreground=0.1_threshold=10.csv'
;openr,lun,pathtmp + fntmp,/get_lun 
;jnk = ''
;readf,lun,jnk
;
;
;while not eof(lun) do begin
;  readf,lun,jnk 
;  vals = strsplit(jnk,',',/extract) 
;endwhile




    ft = [7,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
    fn = ['time','lat','lon','alt','mcilwainL','MLT','kp','counts_s_0','counts_s_1','counts_s_2','counts_s_3','counts_s_4','counts_s_5','sig_0','sig_1','sig_2','sig_3','sig_4','sig_5','time_gap','saturated','n_zeros']
    floc = [0, 27, 46, 66, 84,102,120,125,143,162,180,199,203,207,225,244,263,283,287,308,310,312]
    fg = indgen(22)

    template = {version:1.,$
      datastart:1L,$
      delimiter:44B,$
      missingvalue:!values.f_nan,$
      commentsymbol:'',$
      fieldcount:22L,$
      fieldtypes:ft,$
      fieldnames:fn,$
      fieldlocations:floc,$
      fieldgroups:fg}



    vals = read_ascii(pathtmp+fntmp,template=template)

    vals.time = time_string(vals.time,prec=6)

    ;day occurrence of each microburst
    dates = time_string(vals.time,tformat='YYYY-MM-DD')


    ;------------------------------
    ;Convert counts to flux (only differential channels)
    flux = fltarr(n_elements(vals.counts_s_0),5)

    x = firebird_get_calibration_counts2flux(dates[0],fb)
    energy_width = x.energy_range_collimated[*,1] - x.energy_range_collimated[*,0]     

    for i=0.,n_elements(vals.counts_s_0)-1 do begin
      x = firebird_get_calibration_counts2flux(dates[i],fb)

      if is_struct(x) then begin 
        ;To calibrate from counts to flux (only for differential channels):
        flux[i,0] = vals.counts_s_0[i]/(x.cadence/1000.)/energy_width[0]/x.g_factor_collimated[0]
        flux[i,1] = vals.counts_s_1[i]/(x.cadence/1000.)/energy_width[1]/x.g_factor_collimated[1]
        flux[i,2] = vals.counts_s_2[i]/(x.cadence/1000.)/energy_width[2]/x.g_factor_collimated[2]
        flux[i,3] = vals.counts_s_3[i]/(x.cadence/1000.)/energy_width[3]/x.g_factor_collimated[3]
        flux[i,4] = vals.counts_s_4[i]/(x.cadence/1000.)/energy_width[4]/x.g_factor_collimated[4]
      endif else begin
        flux[i,*] = !values.f_nan
      endelse
      
    endfor


;TEST
;store_data,'flux0',time_double(vals.time),flux[*,0]
;store_data,'counts0',time_double(vals.time),vals.counts_s_0



    vals_fin = {TIME:vals.time,LAT:vals.lat,LON:vals.lon,ALT:vals.alt,MCILWAINL:vals.mcilwainl,MLT:vals.mlt,KP:vals.kp,$
    flux_1:flux[*,0],flux_2:flux[*,1],flux_3:flux[*,2],flux_4:flux[*,3],flux_5:flux[*,4],$
    COUNTS_S_0:vals.counts_s_0,COUNTS_S_1:vals.counts_s_1,COUNTS_S_2:vals.counts_s_2,COUNTS_S_3:vals.counts_s_3,$
    COUNTS_S_4:vals.counts_s_4,COUNTS_S_5:vals.counts_s_5,$
    SIG_0:vals.sig_0,SIG_1:vals.sig_1,SIG_2:vals.sig_2,SIG_3:vals.sig_3,SIG_4:vals.sig_4,SIG_5:vals.sig_5,$
    TIME_GAP:vals.time_gap,SATURATED:vals.saturated,N_ZEROS:vals.n_zeros}

stop
    return,vals_fin

end