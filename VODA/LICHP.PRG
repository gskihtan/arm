********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovad in 1 order kod
use dovvul in 2 order kodv
use lich in 3 order kodbk
use dovlich in 4 order kodm

select dovad 
set relat to kodv into dovvul

select lich
set relat to kodm into dovlich

******************** DEFINES *************************

define window wlich from 1,0 to 23,79;
	doub color w/b,w+/gb,w/b,w/b;
	title [ Ввўд показникўв лўчильникўв ]

************** BEGIN PROGRAMM ************************

activ wind wlich
mcolor1=[w/b]
mcolor2=[gr+/b]

scatter memvar blank
m.datep=date()
m.oldkod=[]
mcntlich=0

@ 1,13 get m.datep;
	when fw_date();
	valid fv_date();
	error [ Введўть дату ]
read cycle modal

rele wind wlich

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************
*********************
func fw_date
*********************
activ screen
@ 24,0 say padr([ ESC Вихўд │],75) color &m_mescolor
activ wind wlich
clear
@ 1,2 say [Дата вводу]
@ 2,2 to 13,75
@ 14,3 say [Ос.рах]
@ 14,11 say [Лўч.]
@ 14,16 say [Поп.показ]
@ 14,27 say [Ост.показ]
@ 14,38 say [Об'їм]
@ 15,51 say "[ OK ]" color &mcolor2
@ 17,2 say [Прўзвище   - ]
@ 18,2 say [Адреса     - ]
@ 19,2 say [Лўчиьникўв - ]
@ 17,51 say [Номер - ]
@ 18,51 say [Марка - ]
return .t.

***********************
func fv_date
***********************
m.kodbk=space(7)
m.lich=space(1)
store 0.00 to m.pokn,m.pkp,m.ov

@ 15,3 get m.kodbk;
	when fw_kodbk();
	valid fv_kodbk();
	error [ По даному рахунку лўчильнўка немаї або вўн на повўрцў ]
@ 15,11 get m.lich;
	when fw_lich();
	valid fv_lich();
	error [ Лўчильник не знайдено ]
@ 15,16 get m.pokn size 1,9 when .f.
@ 15,27 get m.pokp size 1,9;
	valid fv_pokp();
	error [ Невўрне значння ]
@ 15,38 get m.ov size 1,9
@ 15,51 get msel pict [@*I] size 1,6 color gr+/br defa 1 valid psave()

read cycle modal nomouse
return .t.

*///////////////////////
func fv_pokp
*///////////////////////
if m.pokp<0
	return .f.
else
	m.ov=m.pokp-m.pokn
	return .t.
endif

*///////////////////////
func psave
*///////////////////////
repl pokp with m.pokp
repl ov with m.ov
repl datep with m.datep
@ 17,15 say space(25)
@ 18,15 say space(35)
@ 19,15 say space(2)
@ 17,59 say space(11)
@ 18,59 say space(11)
m.oldkod=m.kodbk
store 0.00 to m.pkn,m.pokp,m.ov
show gets
scroll 3,3,12,74,1
@ 12,3 say kodbk+[ ]+lich+[ ]+str(pokn,9,2)+[ ]+;
		str(pokp,9,2)+[ ]+str(ov,9,2)
keyb [{SHIFT+END}]

************************
func fw_kodbk
************************
activ screen
@ 24,0 say padr([ F1 Пошук │ ESC Вихўд │],75) color &m_mescolor
activ wind wlich
on key label f1 do p_poshuk
return .t.

*************************
func fv_kodbk
*************************
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
select dovad
if not seek(mkod)
        select lich
        return .f.
endif
select lich
m.kodbk=dovad.kodbk
show gets
seek m.kodbk
if kodbk # m.kodbk or not empty(lich.date1) or not empty(lich.date2)
	return .f.
endif

mcntlich=0
scan while kodbk==m.kodbk
	mcntlich=mcntlich+1
endscan

@ 17,15 say dovad.fio color &mcolor1
@ 18,15 say padr(dovvul.vul,20)+;
       padr(allt(dovad.bud)+;
       iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]),8)  color &mcolor1
@ 19,15 say allt(str(mcntlich)) color &mcolor1

if m.kodbk==m.oldkod
	m.lich=allt(str(val(m.lich)+1))
else
	m.lich=[1]
endif

************************
func fw_lich
************************
on key label f1

************************
func fv_lich
************************
do while not seek(m.kodbk+m.lich)
	seek(m.kodbk)
	do while not bof() and kodbk==m.kodbk
		skip -1
	enddo
	if kodbk#m.kodbk
		skip
	endif
	declare arr_lich[mcntlich]
	i=1
	do while kodbk==m.kodbk
		arr_lich[i]=lich+[ ]+padr(n_lich,11)+[ ]+padr(dovlich.marka,10)
		i=i+1
		skip
	enddo
	
	save screen to ecr001
	@ 15,11 get mmm001 from arr_lich defa arr_lich[1];
		color w/b,w/b,w+/b,n/w
	read
	restore screen from ecr001
	if last()=27
		return .f.
	endif
	m.lich=left(mmm001,1)
enddo

@ 17,59 say n_lich color &mcolor1
@ 18,59 say dovlich.marka color &mcolor1

m.pokn=pokn
m.pokp=pokp
m.ov=ov
show gets
return .t.
