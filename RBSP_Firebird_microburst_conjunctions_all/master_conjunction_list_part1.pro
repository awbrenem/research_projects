;Part 1 of the programs that create the master conjunction list
;for the FIREBIRD/RBSP burst collection campaign.
;This part takes files from Mykhaylo 
;e.g. 'FU4_RBSPB_conjunctions_dL10_dMLT10_hr.txt'  for times with FIREIBRD hires data only
;and  'FU4_RBSPB_conjunctions_dL10_dMLT10.txt'     for all conjunctions
;and saves them as an an IDL .sav file (e.g FU4_RBSPB_conjunctions.sav')

;Note that the time correction from the FIREBIRD context files is applied to all times

;startTime,endTime,meanL,meanMLT,minMLT,minD [km]
;2018-07-31 01:28:50.204080,2018-07-31 01:30:03.673476,5.214955510288944,0.5507639935853478,0.07520647557065624,nan





;****************************
;problem dates to test 







;Decide whether to use the "hr" files or regular files.
;The hr (hires) files only include conjunctions when FIREBIRD hires data was taken.
hires = 0


if keyword_set(hires) then $
  fnsuffix = '_conjunctions_dL10_dMLT10_hr_final.txt' else $
  fnsuffix = '_conjunctions_dL10_dMLT10_final.txt'



;pm_time = 2.5*60.  ;plus and minus times for conjunction collection.
rbsp_efw_init
;path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/all_conjunctions_with_hires_data/'
path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_microburst_conjunctions_all/Schumko_conjunction_lists/'
path2 = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/'


fb = 'FU3'
rb = 'RBSPB'
;fn = fb+'_'+rb+'_conjunctions_dL10_dMLT10_hr_final.txt'
fn = fb+'_'+rb+fnsuffix


if KEYWORD_SET(hr) then $
  savename = fb + '_' + rb + '_conjunctions_hr.sav' else $
  savename = fb + '_' + rb + '_conjunctions.sav'


openr,lun,path+fn,/get_lun
jnk = ''
readf,lun,jnk

strvals = ''
strv = ''
while not eof(lun) do begin $
    readf,lun,strvals     & $
    strv = [strv,strvals]
endwhile

close,lun
free_lun,lun


strv = strv[1:n_elements(strv)-1]

vals = strarr(n_elements(strv),6)
for i=0,n_elements(strv)-1 do vals[i,*] = strsplit(strv[i],',',/extract)

;startTime,endTime,meanL,meanMLT,minMLT,minD [km]
;vals[*,0] = time_string(vals[*,0])
for b=0,n_elements(vals[*,0])-1 do if vals[b,0] ne 'nan' then vals[b,0] = time_string(vals[b,0])
for b=0,n_elements(vals[*,1])-1 do if vals[b,1] ne 'nan' then vals[b,1] = time_string(vals[b,1])


;Get rid of NaN value times
goo = where(vals[*,0] ne 'nan')
if goo[0] ne -1 then valstmp = vals[goo,*] else valstmp = vals
goo = where(valstmp[*,1] ne 'nan')
if goo[0] ne -1 then vals2 = valstmp[goo,*] else vals2 = valstmp





;Apply time-correction to all the conjunction times (if the daily context file exists) 
for i=0.,n_elements(t0)-1 do begin 
  
  timespan,strmid(time_string(t0[i]),0,10)
  ff = 0.
  firebird_load_context_data_cdf_file,strmid(fb,2,1),file_fail=ff

  if not ff then begin 
    tcor = tsample('Count_Time_Correction',t0[i],time=tms)
    tdelta_test = abs(t0[i] - tms)
    if tdelta_test gt 3600. then begin 
      print,'ISSUE WITH APPLYING TIME CORRECTION'
    endif else begin 
      t0[i] += tcor
      t1[i] += tcor
      print,'***TCOR = ',tcor , ' sec'
    endelse
    store_data,'*',/del
  endif
endfor

t0 = time_double(vals2[*,0])
t1 = time_double(vals2[*,1])
meanL = float(vals2[*,2])
meanMLT = float(vals2[*,3])
minMLT = float(vals2[*,4])
mindist = float(vals2[*,5])

;-----------
;Save data to file
SAVE,/variables,FILENAME = path2+savename
;-----------


end
