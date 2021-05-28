;Load the list that Mike Shumko's FIREBIRD microburst id code ("microburst_detection" package)
;spits out. These are individual microbursts pulled from the FIREBIRD flux data. 

;fb = '3' or '4'  corresponding to FIREBIRD FU3 or FU4

function load_firebird_microburst_list,fb

    pathtmp = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_Colpitts_Chen/microburst_detection/data/'
    fntmp = 'FU'+fb+'_microbursts.csv'


    ft = [7,4,4,4,4,4,4,4,4,4,4,4,4]
    fn = ['time','lat','lon','alt','mcilwainL','MLT','kp','flux_ch1','flux_ch2','flux_ch3','flux_ch4','flux_ch5','flux_ch6']
    floc = [ 0,27,45,64,82,101,119,124,143,161,179,198,217]
    fg = indgen(13)

    template = {version:1.,$
                datastart:1L,$
                delimiter:44B,$
                missingvalue:!values.f_nan,$
                commentsymbol:'',$
                fieldcount:13L,$
                fieldtypes:ft,$
                fieldnames:fn,$
                fieldlocations:floc,$
                fieldgroups:fg}



    vals = read_ascii(pathtmp+fntmp,template=template)

    vals.time = time_string(vals.time,prec=6)

    return,vals 

end