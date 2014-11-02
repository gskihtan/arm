@ echo off
if exist voda\lock.dbf goto end
keyukr /fast
resfree 10
cd voda
..\foxpro\foxprox -t main > nul
type removing temporary files:
del $*.* > nul
del *.idx > nul
del *.tmp > nul
del *.bak > nul
del *.fxp > nul
del *.err > nul
del *.txt > nul
del out*.* >nul
del lock.dbf
cd ..
cls
:end
