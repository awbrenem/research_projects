;(formerly master_conjunction_list_part1.pro)

;This part takes files from Mykhaylo 
;e.g. 'FU4_RBSPB_conjunctions_dL10_dMLT10_hr.txt'  (for times with FIREIBRD hires data only)
;and  'FU4_RBSPB_conjunctions_dL10_dMLT10.txt'     (for all conjunctions)
;and saves them as an an IDL .sav file (e.g FU4_RBSPB_conjunctions.sav')
;to the folder github/research_projects/RBSP_FIREBIRD_conjunction_statistics/conjunction_lists/Breneman/


;Mike's files have the format:
  ;startTime,endTime,meanL,meanMLT,minMLT,minD [km]
  ;2018-07-31 01:28:50.204080,2018-07-31 01:30:03.673476,5.214955510288944,0.5507639935853478,0.07520647557065624,nan


;The .sav files have the same variables as Mike's files, but are in a more convenient format and have the time correction 
;for survey data appled, fixing the start/stop times



;NOTES:
;(1) Shumko's .txt files have a lot of NaN values for the minimum distance (mindist). Not sure why this is, but 
;I don't use this variable at any point. 
;(2) No need to time-correct these. Mikes values come from ephemeris, which Arlo has indicated doesn't need to be time-corrected. 
;    (Mike verified this with email on July 15, 2022)




;----------------------------------------------------------------------------------
;INPUT VARIABLES 

;Decide whether to use the "hr" files or regular files.
;The hr (hires) files only include conjunctions when FIREBIRD hires data was taken.
hires = 1
fb = 'FU3'
rb = 'RBSPA'

;----------------------------------------------------------------------------------







if keyword_set(hires) then $
  fnsuffix = '_conjunctions_dL10_dMLT10_hr_final.txt' else $
  fnsuffix = '_conjunctions_dL10_dMLT10_final.txt'


paths = get_project_paths()




fn = fb+'_'+rb+fnsuffix
if KEYWORD_SET(hr) then $
  savename = fb + '_' + rb + '_conjunctions_hr.sav' else $
  savename = fb + '_' + rb + '_conjunctions.sav'




openr,lun,paths.shumko_conjunctions+fn,/get_lun
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




t0 = time_double(vals2[*,0])
t1 = time_double(vals2[*,1])
meanL = float(vals2[*,2])
meanMLT = float(vals2[*,3])
minMLT = float(vals2[*,4])
mindist = float(vals2[*,5])


for i=0,n_elements(t0)-1 do print,time_string(t0[i])+'-'+time_string(t1[i])+' '+strtrim(meanL[i],2)+' '+strtrim(meanMLT[i],2)+' '+strtrim(minMLT[i],2)+' '+strtrim(mindist[i],2)

;-----------
;Save data to file
SAVE,/variables,FILENAME = paths.breneman_conjunctions+savename
;-----------


end
