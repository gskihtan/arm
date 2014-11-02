********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

define wind warh from 3,15 to 15,67;
	shadow double color schem 7;
	title [ Знищення ўнформацў∙ ]

define popup pop_dir title [Виберўть архўв];
	marg scroll
mdir=0
do def_popdir

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │],75) color &m_mescolor
mdate=ctod([01]+subs(dtoc(date()),3))

activ wind warh
@ 1,2 get mdir popup pop_dir size 6,46
@ 9,2 SAY "За який перўод - " GET mdate
@ 9,35 SAY "[ Вилучити ]"
@ 9,35 GET msel pict [@*IT] size 1,12 defa 1 valid del_arh()

READ CYCLE MODAL
rele wind warh


***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

***********************
func del_arh
***********************
mdmis=subs(dtoc(mdate),4,2)
mdyear=subs(PRMBAR([pop_dir],mdir),10,4)
path=[ARHIV\]+mdyear
mess=[Вилучити данў за ]+m_mis[val(mdmis),1]+[ ]+mdyear+[ року ?]
if p_confirm(mess,.f.)
	do cr_del with [dovpil]
	do cr_del with [dovnor]
	do cr_del with [narax]
	do cr_del with [narax2]
	do cr_del with [post]
	do cr_del with [subs]
	do cr_del with [zpilga]
	do cr_del with [lich]
	do cr_del with [lichb]
	do cr_del with [raznarax]
endif

************************
proc cr_del
************************
parameter dbname,indx
mfile=path+[\]+dbname+[.dbf]
if not file(mfile)
	return
endif

wait wind nowait mfile+[...]
use (mfile)
delete for mis==mdmis
pack
use

wait clear
