********************* SETUP **************************
parameter mbase
do p_prepare

do case
        case mbase==[POST]
                use postp in 1 order u_pach alias postp
                use post  in 4 order pach alias post
                mv_title = [ Ввўд оплати ]
                ms_1 = [Оплата──]
        case mbase==[SUBS]
                use subsp in 1 order u_pach alias postp
                use subs  in 4 order pach alias post
                mv_title = [ Ввўд субсидўй ]
                ms_1 = [Субсидўя]
        case mbase==[SUBSN]
                use subsnp in 1 order u_pach alias postp
                use subsn  in 4 order pach alias post
                mv_title = [ Ввўд субсидўй (неоплачених) ]
                ms_1 = [Субсидўя]
        other
                do p_clear
                return
endcase

****************** OPEN DATABASE *********************

use dovad in 2 order kod
use dovvul in 3 order kodv
use narax in 20 order kodbk
select dovad
set relat to kodv into dovvul
select postp
set relat to val(subs(kodbk,2)) into dovad,kodbk into narax

******************** DEFINES *************************

DEFINE WINDOW wsuma ;
                FROM INT((SROW()-20)/2),INT((SCOL()-60)/2) ;
                TO INT((SROW()-20)/2)+20,INT((SCOL()-60)/2)+59 ;
                TITLE mv_title ;
                FLOAT ;
                NOCLOSE ;
                SHADOW ;
                DOUBLE ;
                COLOR SCHEME 5

define popup pop_pach;
        from 0,12 to 6,20 marg scroll;
        prompt field postp.npach;
        color schem 5
on select popup pop_pach deact popup

************** BEGIN PROGRAMM ************************

ACTIVATE WINDOW wsuma
m.npach = space(4)
m.date  = date()
m.fio   = space(25)
m.adr   = space(30)
m.kodbk = space(7)
m.suma  = 0.00
do make_scr

@ 1,12 GET m.npach valid fv_npach() ;
	error [ Невўрне значення ]
@ 1,44 GET m.date valid fv_date() error [ Введўть дату поступлення ]

push key
on key
on key label F9 do p_calc
READ CYCLE NOMOUSE MODAL
pop key
RELEASE WINDOW wsuma

pack
***************** END OF PROGRAMM *********************

do p_clear

****************** PROCEDURES *************************

*****************
func fv_npach
*****************
if len(allt(m.npach))#4 and not empty(m.npach)
	return .f.
endif
if not empty(m.npach)
        select post
        mt=seek(m.npach)
        select postp
        if mt
        	return p_confirm("Пачка вже записана, продовжити ?",.f.)
        else
        	return .t.
        endif
endif
if last()#13
        return .f.
endif
activ popup pop_pach
if bar()=0
        return .f.
endif
m.npach=prompt()
m.date=postp.date
show gets
return .t.

*****************
func fv_date
*****************
mkey=last()
if inlist(mkey,4,5,19,24)
        return .t.
endif
set order to pach
set filter to npach==m.npach and not deleted()
activ screen
@ 24,0 say padr([ F1 Пошук │ ESC Вихўд │],75) color &m_mescolor
activ wind wsuma

m.fio   = space(25)
m.adr   = space(30)
m.kodbk = space(7)
m.suma  = 0.00
MOBJECT=.f.
mcnt=0
msum=0.00

do proc000
merror=[]

@ 14,4 GET m.kodbk when fw_kodbk() valid fv_kodbk();
        error merror
@ 14,42 GET m.suma size 1,9  valid fv_suma();
        when MOBJECT;
        error [ Hевўрне значення ]
@ 17,34 GET mkor pict [@*I] size 1,14 defa 1 valid fv_kor()
@ 17,9 GET msave pict [@*I] size 1,18 defa 1 valid fv_save()

READ CYCLE NOMOUSE MODAL

set order to u_pach
set filter to
do make_scr
return .t.

*////////////////
func fw_kodbk
*////////////////
MOBJECT = .f.
SHOW OBJECT 3 ENABLE
SHOW OBJECT 4 ENABLE
on key label f1 do p_poshuk
m.fio   = space(25)
m.adr   = space(30)
@ 14,14 say m.fio
@ 15,14 say m.adr

*////////////////
func fv_kodbk
*////////////////
mkey=last()
if inlist(mkey,4,5,19,24)
        on key label f1
        return .t.
endif
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
select dovad
if not seek(mkod)
        select postp
        merror=[ Рахунок не знайдено ]
        return .f.
endif
select narax
m.kodbk=dovad.kodbk
if not seek(m.kodbk)
        select postp
        merror=[ Нема нарахувань ]
        return .f.
endif
on key label f1
select postp
m.fio=dovad.fio
m.adr=allt(dovvul.vul)+[ ]+allt(dovad.bud)+;
        +iif(empty(dovad.kvar),[],[/])+allt(dovad.kvar)
@ 14,14 say m.fio color w/br
@ 15,14 say m.adr color w/br
show gets
MOBJECT = .t.
return .t.

*////////////////
func fv_suma
*////////////////
mkey=last()
if inlist(mkey,4,5,19,24)
        return .t.
endif
if m.suma=0
        return .f.
endif
SHOW OBJECT 3 DISABLE
SHOW OBJECT 4 DISABLE
insert into postp from memvar
mcnt=mcnt+1
msum=msum+suma
do proc001
m.kodbk = space(7)
m.suma = 0
return .t.

*////////////////
func fv_save
*////////////////
if p_confirm([Записати пачку ]+m.npach+[ ?],.t.)
        select 0
        select post
        select postp
        scan
                insert into post (npach,kodbk,suma,date);
                        values (postp.npach,postp.kodbk,postp.suma,postp.date)
                delete
        endscan
        select postp
        pack
        clear read
endif

*////////////////
func fv_kor
*////////////////
define popup pop_kor from 4,2 TO 13,56;
        prompt field [ ]+postp.kodbk+[ │ ]+dovad.fio+[ │ ]+str(suma,9,2)+[ ];
        title [Ос.рах.───Прўзвище────────────────────]+ms_1+[──────];
        COLOR W/BR,W+/BR,W/BR,W/BR
on select popup pop_kor deact popup
activ popup pop_kor rest
if last()#13
        return
endif
m.kodbk=kodbk
m.suma=suma
delete
do proc000
SHOW OBJECT 3 DISABLE
SHOW OBJECT 4 DISABLE
show gets
return

*****************
proc make_scr
*****************
ACTIVATE screen
@ 24,0 say padr([ ENTER Вибўр пачки │ ESC Вихўд │],75) color &m_mescolor
ACTIVATE WINDOW wsuma
@ 3,0 clear
@ 4,2 TO 13,56 COLOR W/RB
@ 1,26 SAY "Дата поступлення"
@ 1,5 SAY "Пачка"
@ 4,5 SAY "Ос.рах."   COLOR W/RB
@ 4,15 SAY "Прўзвище" COLOR W/RB
@ 4,43 SAY ms_1   COLOR W/RB
@ 3,5 SAY "Кўлькўсть -" COLOR W/RB
@ 3,25 SAY "Контрольна сума -" COLOR W/RB
@ 0,2 TO 2,56  COLOR W/RB
@ 17,34 SAY "[ Корегувати ]"
@ 17,9 SAY "[ Записати пачку ]"

m.npach = space(4)
m.date  = date()
return

*****************
proc proc000
*****************
mcnt=0
msum=0.00
do proc001
@ 5,3 clear to 12,55
go top
scan
        mcnt=mcnt+1
        msum=msum+suma
        do proc001
endscan
return

*****************
proc proc001
*****************
@ 3,16 SAY mcnt size 1,5 color g+/br
@ 3,42 SAY msum size 1,9 color g+/br
scroll 5,3,12,55,1
@ 12,4 say kodbk+[ │ ]+dovad.fio+[ │ ]+str(suma,9,2)
return

