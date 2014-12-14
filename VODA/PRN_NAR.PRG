********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

	DEFINE WINDOW wnar ;
		FROM INT((SROW()-15)/2),INT((SCOL()-65)/2) ;
		TO INT((SROW()-15)/2)+15,INT((SCOL()-65)/2)+64 ;
		TITLE " Друк оборотки зведено∙ " ;
		FLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE ;
		COLOR SCHEME 5

******************** DEFINES *************************

************** BEGIN PROGRAMM ************************

ACTIVATE WINDOW wnar

@ 1,2 SAY "Друк оборотки на"

@ 6,2 SAY "[ Всўх абонентўв  ]" 
@ 7,2 SAY "[ По дўльницў     ] -"
@ 8,2 SAY "[ По вулицў       ] -"
@ 9,2 SAY "[ По ос. рахунках ] -"
@ 10,2 SAY "[ По дўльницў 1   ] -"
@ 7,24 SAY "дўльниця №" COLOR W/RB    
@ 10,24 SAY "дўльниця №" COLOR W/RB    
@ 8,24 SAY "вулиця"		COLOR W/RB    
@ 9,24 SAY "з" 			COLOR W/RB    
@ 9,35 SAY "по"			COLOR W/RB    
@ 12,22 SAY "[ Друк ]"

mdate1 = {}
mdate2 = date()

@ 1,21 GET m.date DEFAULT date()
@ 3,2 GET ms_short PICTURE "@*C Коротка" SIZE 1,11;
	DEFAULT 1 VALID fv_short() WHEN ms_short=0
@ 4,2 GET ms_full 	PICTURE "@*C Повна"   SIZE 1,9;
 	DEFAULT 0 VALID fv_full()  WHEN ms_full=0
@ 6,2 GET ms_all PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_all()
@ 7,2 GET ms_dil PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_dil()
@ 8,2 GET ms_vul PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_vul()
@ 9,2 GET ms_kod PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_kod()
@ 10,2 GET ms_kod PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_dil1()

@ 12,22 GET ms_print PICTURE "@*IVN " SIZE 1,8 ;
	DEFAULT 0 VALID fv_print() DISABLED

store [] to m.kodv,m.dil,m.kodbk1,m.kodbk2,m.vul,m.bud,mfilter
m.dil1 = 0

READ CYCLE MODAL
RELEASE WINDOW wnar

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

********************
func fv_short
********************
ms_full=0
show gets
_curobj=objnum(ms_all)

********************
func fv_full
********************
ms_short=0
show gets
_curobj=objnum(ms_all)

*********************
func fv_all
*********************
show get ms_print enabled
mfilter=[.t.]
_curobj=objnum(ms_print)

*********************
func fv_dil
*********************
@ 7,35 GET m.dil SIZE 1,1
read
if last()=27
	return
endif

select 0
use dovad order kodbk
seek(m.dil)
mdilexist=subs(kodbk,1,1)==m.dil
use

if not mdilexist
	wait wind nowait [ Дўльницю не знайдено ]
else
	mfilter=[subs(narax.kodbk,1,1)==m.dil]
	show get ms_print enabled
	_curobj=objnum(ms_print)
endif

*********************
func fv_vul
*********************
@ 8,35 GET m.vul SIZE 1,25
read
if last()=27
	return
endif

select 0
use dovvul order vul
define popup pvul prom field dovvul.vul;
        from 0,35 color scheme 2 marg shad
on select popup pvul deact popup
m.vul=chrtran(m.vul,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
   [ЙЦУКЕ]+CHR(141)+[ГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
seek(m.vul)
activ popup pvul rest
if last()=27
	use
    return .f.
endif
m.kodv=dovvul.kodv
m.vul=dovvul.vul

use

@ 8,35 say padr(m.vul,25) color w+/gb
@ 9,51 say [буд.] GET m.bud SIZE 1,4
read
if last()=27
	return
endif
mfilter=[dovad.kodv==m.kodv]
if not empty(m.bud)
	mfilter=mfilter+[ and dovad.bud==m.bud]
endif
show get ms_print enabled
_curobj=objnum(ms_print)

*********************
func fv_kod
*********************
select 0
use dovad order kod
@ 9,26 GET m.kodbk1 SIZE 1,7 valid fv_kodbk(1)
@ 9,38 GET m.kodbk2 SIZE 1,7 valid fv_kodbk(2)
read
if last()=27
	use
	return
endif
mfilter=[narax.kodbk>=m.kodbk1 and narax.kodbk<=m.kodbk2]
show get ms_print enabled
use
_curobj=objnum(ms_print)

**********************
func fv_kodbk
**********************
parameter m12
m.kodbk=iif(m12=1,m.kodbk1,m.kodbk2)
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
if not seek(mkod)
		wait wind nowait [ Рахунок не знайдено ]
        return .f.
endif
if m12=1
	m.kodbk1=kodbk
else
	m.kodbk2=kodbk
endif
show gets

*********************
func fv_dil1
*********************
@ 10,35 GET m.dil1 SIZE 1,2
read
if last()=27
	return
endif

select 0
use dovkon
locate for kodd = m.dil1
mdilexist = found()
use

if not mdilexist
	wait wind nowait [ Дўльницю не знайдено ]
else
	mfilter=[!DIL_FILTER!]
	show get ms_print enabled
	_curobj=objnum(ms_print)
endif

********************
func fv_print
********************
wait wind nowait [ Хвилинку! ]

if mfilter == [!DIL_FILTER!]
	mfilter = [.t.]
	mf_dil1 = .t.
else
	mf_dil1 = .f.
endif

select;
	narax.*,;
	.t. as flag,;
	dovad.kodv,;
	dovad.bud,;
	space(20) as lich1,;
	space(20) as lich2,;
	space(20) as lich3,;
	space(20) as lich4,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr;
	from narax,dovad,dovvul;
	into dbf out;
	where dovad.kodv==dovvul.kodv and narax.kodbk==dovad.kodbk;
		and &mfilter;
	order by narax.kodbk;
	group by narax.kodbk

if mf_dil1
	do select_dil
endif

close data
use out
index on kodbk to i comp
*index on (vul+bud) to r1
select 0
use lich order kodbk
set relat to kodbk into out
scan for not empty(out.kodbk)
	select out
	if inlist(lich.lich,[1],[2],[3],[4])
		mfield=[lich]+lich.lich
		repl &mfield with;
			[(]+allt(lich.n_lich)+[ - ]+allt(str(lich.pokp,9,2))+[)]
	endif
	select lich
endscan
use in lich
select out

wait clear

if ms_full=1
	do p_print with [prn_narf]
else
	do p_print with [prn_nars]
endif
show get ms_print disabled
show get m.dil disabled
_curobj=objnum(ms_dil)
use

**************************
procedure select_dil
**************************
wait wind nowait [Хвилинку...]
select 0
use dovdil
index on kodv for kodd = m.dil1 to i3101
select out
go top
scan
	select dovdil
	if not seek(out.kodv)
		select out
		repl flag with .f.
	else
		if empty(bud)
			select out
		else
			mflag3101 = .f.
			scan while kodv == out.kodv
				if allt(bud) == allt(out.bud)
					mflag3101 = .t.
					exit
				endif
			endscan
			select out
			repl flag with mflag3101
		endif
	endif
endscan

use in dovdil
select out
delete for not flag
pack
wait clear