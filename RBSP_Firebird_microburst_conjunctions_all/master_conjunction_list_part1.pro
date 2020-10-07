;Part 1 of the programs that create the master conjunction list
;for the FIREBIRD/RBSP burst collection campaign.
;This part takes files from Mykhaylo 
;e.g. 'FU4_RBSPB_conjunctions_dL10_dMLT10_hr.txt'  for times with FIREIBRD hires data only
;and  'FU4_RBSPB_conjunctions_dL10_dMLT10.txt'     for all conjunctions
;and saves them as an an IDL .sav file (e.g FU4_RBSPB_conjunctions.sav')



;startTime,endTime,meanL,meanMLT,minMLT,minD [km]
;2018-07-31 01:28:50.204080,2018-07-31 01:30:03.673476,5.214955510288944,0.5507639935853478,0.07520647557065624,nan


;Decide whether to use the "hr" files or regular files.
;The hr (hires) files only include conjunctions when FIREBIRD hires data was taken.
hires = 0

if keyword_set(hires) then $
  fnsuffix = '_conjunctions_dL10_dMLT10_hr_final.txt' else $
  fnsuffix = '_conjunctions_dL10_dMLT10_final.txt'



;pm_time = 2.5*60.  ;plus and minus times for conjunction collection.
rbsp_efw_init
;path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/all_conjunctions_with_hires_data/'
path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_microburst_conjunctions_all/'


fb = 'FU4'
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


t0 = time_double(vals2[*,0])
t1 = time_double(vals2[*,1])
meanL = float(vals2[*,2])
meanMLT = float(vals2[*,3])
minMLT = float(vals2[*,4])
mindist = float(vals2[*,5])

;-----------
;Save data to file
SAVE,/variables,FILENAME = path+savename
;-----------


end
