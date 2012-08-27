set DEL_PARAMS=/F /S /Q

del *.dcu %DEL_PARAMS%
del *.~* %DEL_PARAMS%
del .#*.* %DEL_PARAMS%

del *.dproj.local %DEL_PARAMS%
del *.identcache %DEL_PARAMS%
del *.stat %DEL_PARAMS%
del *.bak %DEL_PARAMS%
del *.pas.bak %DEL_PARAMS%
del *.dsk %DEL_PARAMS%
del *.drc %DEL_PARAMS%
rem del *.cfg %DEL_PARAMS%
del *.tvsconfig %DEL_PARAMS%
del *.groupproj.local %DEL_PARAMS%

pause
