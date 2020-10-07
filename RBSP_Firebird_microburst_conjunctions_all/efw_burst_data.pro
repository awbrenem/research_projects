;efw_burst_data
;load burst data for conjunctions

;2017-11-21
A:
00:52 (maybe B2)
01:06 (maybe B2)
19:49 (B1, maybe B2)
20:03 (B1, maybe B2)

B:
00:52 (maybe B2)
01:06 (maybe B2)
07:43 (maybe B2)
19:49 (maybe B2)
20:03 (maybe B2)


rbsp_load_efw_waveform,probe='a',datatype='mscb1'

pro rbsp_load_efw_waveform,probe=probe, datatype=datatype, trange=trange, $
                 level=level, verbose=verbose, downloadonly=downloadonly, $
                 cdf_data=cdf_data,get_support_data=get_support_data, $
                 tplotnames=tns, make_multi_tplotvar=make_multi_tplotvar, $
                 varformat=varformat, valid_names = valid_names, files=files,$
                 type=type, integration=integration, msim=msim, etu=etu, $
                 qa=qa, coord = coord, noclean = noclean, $
                 tper = tper, tphase = tphase, _extra = _extra
