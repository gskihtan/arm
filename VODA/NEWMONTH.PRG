********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************
DEFINE WINDOW wnmonth ;
		FROM 5,INT((SCOL()-50)/2) ;
		TO 13,INT((SCOL()-50)/2)+49 ;
		TITLE " Перехўд на новий мўсяць " ;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 1
define wind wnew from 4,2 to 14,60;
	double shad color w+/gr,w+/gr,w+/gr,w+/gr,w+/gr;
	title [ Закриття мўсяця ]
	
************** BEGIN PROGRAMM ************************

wait [ Формування кiнцевого сальдо... ] wind nowait
use post order kodbk
total on kodbk to $post field suma
use $post alias post
index on kodbk to ipost comp
select 0
use narax
set relat to kodbk into post
repl all opl with post.suma
repl all saldp with saldn+svp+stp+svd+std-opl-subs
close data
wait clear

@ 24,0 say padr([ ESC Вихўд │ ],75) color &m_mescolor

ACTIVATE WINDOW wnmonth

mdate=ctod([01]+subs(dtoc(date()),3))

@ 1,2 SAY "Введўть дату на 1-ше число поточного мўсяця"
@ 3,19 GET mdate
@ 5,15 SAY "[ Закрити мўсяць ]"
@ 5,15 GET m.go PICTURE "@*IT " SIZE 1,18 DEFAULT 0;
	VALID p_close()

READ CYCLE MODAL
RELEASE WINDOW wnmonth


***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
func p_close 
*****************
amis=subs(dtoc(mdate),4,2)
if not p_confirm([Закрити ]+m_mis[val(amis),1]+;
	[ та перейти на новий мўсяць ?],.t.)
	return
endif

activ wind wnew

mres=.t.
do newm_arhiv
if mres
	do newm_post
	do newm_lich
	do newm_saldo
	do newm_pilga
endif
wait [ Натиснўть any key...]
deact wind wnew
return

************************
proc newm_arhiv
************************
?[ Створення архўву - ]
mcyear=subs(dtoc(mdate),7,4)
mpath=[arhiv\]+mcyear
if not file(mpath+[\narax.dbf])
	mcomm=[run md ]+mpath+[ > nul ]
	activ screen
	&mcomm
	activ wind wnew
	
	do cr_anew with [dovpil],   [kodpil+mis]
	do cr_anew with [dovnor],   [kodnor+mis]
	do cr_anew with [narax],    [kodbk+mis]
	do cr_anew with [narax2],   [kodbk+mis]
	do cr_anew with [post],     [kodbk+mis]
	do cr_anew with [subs],     [kodbk+mis]
	do cr_anew with [zpilga],   [kodbk+mis]
	do cr_anew with [lich],     [kodbk+mis]
	do cr_anew with [lichb],    [f_adr1("lichb")+mis]
	do cr_anew with [raznarax], [mis]
else
	use &mpath\narax order tm
	go top
	
	if recc()>12
		for i=1 to 12
			if mis==amis
				mres=.f.
			endif
			skip
		endfor
	endif
	use
	
	if not mres
		wait wind [В архўвў вже ї данў за ]+m_mis[val(amis),1]
		return
	endif
	
	do cr_add with [dovpil]
	do cr_add with [dovnor]
	do cr_add with [narax]
	do cr_add with [narax2]
	do cr_add with [post]
	do cr_add with [subs]
	do cr_add with [zpilga]
	do cr_add with [lich]
	do cr_add with [lichb]
	do cr_add with [raznarax]
endif
??[OK!]
		
************************
proc cr_anew
************************
parameter dbname,indx
if dbname==[narax]
 mcomm = [select narax.*,amis as mis,dovad.fio as fio ]+;
 	[from narax,dovad into dbf ];
	+mpath+[\narax where narax.kodbk==dovad.kodbk]
else
	mcomm = [select *,amis as mis from ]+dbname+;
	[ into dbf ]+mpath+[\]+dbname
endif
&mcomm
mcomm = [index on ]+indx+[ tag tm comp]
&mcomm
close data

************************
proc cr_add
************************
parameter dbname
if dbname==[narax]
	select narax.*,dovad.fio as fio from narax,dovad;
		into dbf $temp where narax.kodbk==dovad.kodbk
	close data
	mdbf=mpath+[\narax]
	use (mdbf) order 0
	go bott
    mrec=recno()
    append from $temp
	repl all mis with amis for recno()>mrec
else
	mdbf=mpath+[\]+dbname
	use (mdbf) order 0
	go bott
    mrec=recno()
    mcomm=[append from ]+dbname
    &mcomm
	repl all mis with amis for recno()>mrec
endif
close data

************************
proc newm_post
************************
?[ Знищення перерахункўв - ]
use narax2
zap
??[OK!]
?[ Знищення поступлень - ]
use post
zap
use postp
zap
use subs
zap
use subsp
zap
use subsn
*zap
use subsnp
zap
??[OK!]
close data

************************
proc newm_lich
************************
?[ Лўчильники - ]
use lich
repl all;
	ov    with 0,;
	pokn  with pokp,;
	pokp  with 0,;
	datep with {},;
	date1 with iif(not empty(date2),{},date1),;
	date2 with {},;
	pokpipo with 0
close data

use lichb
repl all;
	ov    with 0,;
	ov1   with 0,;
	pokn  with pokp,;
	pokp  with 0
close data
??[OK!]

************************
proc newm_saldo
************************
?[ Сальдо - ]
use narax
go top
scan all
	if saldp <= (svp+stp)*3
		repl ugoda with 0
		repl ugdate with {}
	endif
endscan
go top
repl all;
	ov    with 0,;
	ost   with 0,;
	sv    with 0,;
	st    with 0,;
	ovd   with 0,;
	ostd  with 0,;
	svd   with 0,;
	std   with 0,;
	svp   with 0,;
	stp   with 0,;
	subs  with 0,;
	subsn with 0,;
	opl   with 0,;
	datev with {};
	saldn with saldp,;
	saldp with 0,;
	pdv_saldn with pdv_saldp,;
	pdv_saldp with 0,;
	pdv_deb with 0,;
	pdv_kred with 0
close data
??[OK!]

************************
proc newm_pilga
************************
?[ Пўльги - ]
select 0
use zpilga

delete all for del and not inlist(kodpil,[150],[151])
pack

select 0
use dovpil order kodpil
select zpilga
set relat to kodpil into dovpil
copy to outpil for dovpil.user==[U]

select dovpil
use outpil
index on kodbk to i comp
select zpilga
set relat to kodbk into outpil

scan for del
	if not empty(outpil.kodbk)
		repl del with .f.
		repl kodpil with outpil.kodpil
		repl date with outpil.date
	else
		delete
	endif
endscan
pack

close data
??[OK!]
