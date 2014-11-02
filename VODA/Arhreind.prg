********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

define popup pop_dir title [ Переўндексацўя архўву ];
	marg scroll;
	from 5,20 to 15,60 shad
mdir=0
do def_popdir
on select popup pop_dir do ind_arh

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │],75) color &m_mescolor
activ popup pop_dir

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

***********************
func ind_arh
***********************
path=[ARHIV\]+subs(PRMBAR([pop_dir],mdir),10,4)

do cr_ind with [dovpil],   [kodpil+mis]
do cr_ind with [dovnor],   [kodnor+mis]
do cr_ind with [narax],    [kodbk+mis]
do cr_ind with [narax2],   [kodbk+mis]
do cr_ind with [post],     [kodbk+mis]
do cr_ind with [subs],     [kodbk+mis]
do cr_ind with [zpilga],   [kodbk+mis]
do cr_ind with [lich],     [kodbk+mis]
do cr_ind with [lichb],    [f_adr1("lichb")+mis]
do cr_ind with [raznarax], [mis]


************************
proc cr_ind
************************

parameter dbname,indx
mfile=path+[\]+dbname+[.dbf]
if not file(mfile)
	return
endif

wait wind nowait mfile+[...]

use (mfile)
delete tag all
mcomm = [index on ]+indx+[ tag tm comp]
&mcomm
use

wait clear
