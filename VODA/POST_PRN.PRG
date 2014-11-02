do case
case mbase==[POST]
	mt = [ Друк оплат ]
case mbase==[SUBS]
	mt = [ Друк субсидўй ]
case mbase==[SUBSN]
	mt = [ Друк субсидўй неопл. ] 
endcase

DEFINE WINDOW wb ;
		FROM INT((SROW()-14)/2),INT((SCOL()-64)/2) ;
		TO INT((SROW()-14)/2)+12,INT((SCOL()-64)/2)+63 ;
		TITLE mt ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

ACTIVATE WINDOW wb

@ 1,2 SAY "Друк поступлень за перўод з            по " COLOR W/RB    
@ 3,2 SAY "[ Всўх абонентўв  ]" 
@ 4,2 SAY "[ По дўльницў     ] -"
@ 5,2 SAY "[ По вулицў       ] -"
@ 6,2 SAY "[ По ос. рахунках ] -"
@ 7,2 SAY "[ По дўльницў 1   ] -"
@ 4,24 SAY "дўльниця №" COLOR W/RB    
@ 7,24 SAY "дўльниця №" COLOR W/RB    
@ 5,24 SAY "вулиця"		COLOR W/RB    
@ 6,24 SAY "з" 			COLOR W/RB    
@ 6,35 SAY "по"			COLOR W/RB    
@ 9,26 SAY "[ Друк ]"

mdate1 = {}
mdate2 = date()

@ 1,30 get mdate1
@ 1,44 get mdate2

@ 3,2 GET msf_all PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_all()
@ 4,2 GET msf_dil PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_dil()
@ 5,2 GET msf_vul PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_vul()
@ 6,2 GET msf_kod PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_kod()
@ 7,2 GET msf_kod PICTURE "@*IVN " SIZE 1,19,1 DEFAULT 0 VALID fv_dil1()

@ 9,26 GET ms_print PICTURE "@*IVN " SIZE 1,8 ;
	DEFAULT 0 VALID fv_print() DISABLED

store [] to m.kodv,m.dil,m.kodbk1,m.kodbk2,m.vul,m.bud,mfilter
m.dil1 = 0

READ CYCLE MODAL
RELEASE WINDOW wb

****************** PROCEDURES *************************

*********************
func fv_all
*********************
show get ms_print enabled
mfilter=[.t.]
_curobj=objnum(ms_print)

*********************
func fv_dil
*********************
@ 4,35 GET m.dil SIZE 1,1
read
if last()=27
	return
endif

select dovad
seek(m.dil)
mdilexist=subs(kodbk,1,1)==m.dil

if not mdilexist
	wait wind nowait [ Дўльницю не знайдено ]
else
	mfilter=[subs(postp.kodbk,1,1)==m.dil]
	show get ms_print enabled
	_curobj=objnum(ms_print)
endif

*********************
func fv_vul
*********************
@ 5,35 GET m.vul SIZE 1,25
read
if last()=27
	return
endif

select dovvul
set order to vul
define popup pvul prom field dovvul.vul;
        from 0,35 color scheme 2 marg shad
on select popup pvul deact popup
m.vul=chrtran(m.vul,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
   [ЙЦУКЕ]+CHR(141)+[ГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
seek(m.vul)
activ popup pvul rest
if last()=27
	set order to kodv
	select dovad
	set relat to kodv into dovvul
    return .f.
endif
m.kodv=dovvul.kodv
m.vul=dovvul.vul

set order to kodv
select dovad
set relat to kodv into dovvul

@ 5,35 say padr(m.vul,25) color w+/gb
@ 6,51 say [буд.] GET m.bud SIZE 1,4
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
select dovad
set order to kod
@ 6,26 GET m.kodbk1 SIZE 1,7 valid fv_kodbk(1)
@ 6,38 GET m.kodbk2 SIZE 1,7 valid fv_kodbk(2)
read
if last()=27
	select dovad
	set order to kodbk
	select postp
	set relat to kodbk into dovad
	return
endif
mfilter=[postp.kodbk>=m.kodbk1 and postp.kodbk<=m.kodbk2]
show get ms_print enabled
select dovad
set order to kodbk
select postp
set relat to kodbk into dovad

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

************************
func fv_print
************************
wait wind nowait [ Хвилинку! ]
if empty(mdate1)
	fd = [.t.]
else 
	fd = [postp.date >= mdate1 and postp.date <= mdate2]
endif

if mfilter == [!DIL_FILTER!]
	mfilter = [.t.]
	mf_dil1 = .t.
else
	mf_dil1 = .f.
endif

select;
	postp.*,;
	dovad.kodv,;
	dovad.bud,;
	.t. as flag,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr;
	from postp,dovad,dovvul;
	into dbf out;
	where dovad.kodv==dovvul.kodv and postp.kodbk==dovad.kodbk;
		and &mfilter and &fd;
	order by postp.kodbk
wait clear
select out

if mf_dil1
	do select_dil
endif

do p_print with [prn_post]

use in out
select postp
show get ms_print disabled

*********************
func fv_dil1
*********************
@ 7,35 GET m.dil1 SIZE 1,1
read
if last()=27
	return
endif

select 0
use dovkon
locate for kodd = m.dil1
mdilexist = found()
use
select postp

if not mdilexist
	wait wind nowait [ Дўльницю не знайдено ]
else
	mfilter=[!DIL_FILTER!]
	show get ms_print enabled
	_curobj=objnum(ms_print)
endif

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