********************* SETUP **************************

do p_prepare

_m_date=date()

****************** OPEN DATABASE *********************

wait wind nowait [ Хвилинку ]

select 0
use dovvul order kodv

select 0
use dovad order kod
set relat to kodv into dovvul

select 0
use dovlich order kodm

select 0
use lich order kodbk
set filter to not deleted()

select 0
use narax order kodbk

select 0
use dovnor order kodnor

select 0
use dovpil order kodpil
select 0
use zpilga
set relat to kodpil into dovpil
repl all pil with dovpil.pil
select dovpil
use
select zpilga
set order to kodbk
total on kodbk to $pilga fields pil

select 0
use $pilga alias tpilga
index on kodbk to ipil comp

select 0
use narax2

wait clear

******************** DEFINES *************************
DEFINE WINDOW wlich ;
		FROM INT((SROW()-20)/2),INT((SCOL()-78)/2) ;
		TO INT((SROW()-20)/2)+19,INT((SCOL()-78)/2)+77 ;
		TITLE " Встановлення,редагування лўчильникўв " ;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR w/b,w+/gb,w/b,w/b
define popup pop_lich ;
	prom field tm.lich+[│]+padr(tm.n_lich,11)+[│]+padr(dovlich.marka,10);
	+[ ]+chrtran(tm.hvoda,[GH],[ГХ])+[│]+dtoc(tm.date_vst)+;
	[│]+str(tm.pokn,9,2)+[│]+str(tm.poks,9,2)+[│]+;
	+dtoc(tm.date1)	scroll marg;
	title [─Hомер───────Марка────────Дата вст.──Поч.показ─Сер.показ─Повўрка──]
define popup pop_marka prom field dovlich.marka;
        from 4,50;
        color scheme 2 marg shad scroll
on select popup pop_marka deact popup

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ F1 Пошук │ ESC Вихўд │],75) color &m_mescolor

ACTIVATE WINDOW wlich

m.kodbk=space(7)

m.error=[]
@ 1,21 GET m.kodbk ;
	when fw_kodbk();
	valid fv_kodbk();
	error m.error

READ CYCLE MODAL
RELEASE WINDOW wlich

wait wind nowait [ Хвилинку ]
select lich
pack
select narax2
pack
wait clear

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************
******************
func fw_kodbk
******************
clear
@ 1,3 SAY "Особовий рахунок"
@ 11,3 SAY "Прўзвище    -"
@ 12,3 SAY "Адреса      -"
@ 13,3 SAY "Лўчильникўв -"
@ 14,3 SAY "Прописано   -"
@ 3,3 TO 9,74
@ 11,58 SAY "[ Додати     ]"
@ 12,58 SAY "[ Корегувати ]"
@ 13,58 SAY "[ Знищити    ]"
@ 15,58 SAY "[ Повўрка    ]"
@ 16,30 SAY "[ Записати ]"
on key label f1 do p_poshuk

******************
func fv_kodbk
******************
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
select dovad
if not seek(mkod)
    	m.error=[ Рахунок не знайдено ]    
        return .f.
endif
store kodbk to m.kodbk,m_kodbk
show gets
select narax
if not seek(m.kodbk)
   	m.error=[ Нарахувань немаї ]    
	return .f.
endif
if not empty(oplomb)
   	m.error=[ Вода опломбована ]    
	return .f.
endif

on key label f1

select lich
seek m.kodbk+chr(0)
copy to $lich while m.kodbk==kodbk
select 0
use $lich alias tm
index on lich to i$lich comp
set relat to kodm into dovlich
if recc()=0
	flag_first=.t.
else
	flag_first=.f.
endif

select narax2
copy stru to $narax2

@ 11,18 say dovad.fio 
@ 12,18 say allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+[ ]+;
       iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[])
@ 14,18 say allt(str(narax.kprop))
select tm
@ 13,18 say allt(str(recc()))

@ 3,3 GET list_lich ;
	PICTURE "@&N" POPUP pop_lich ;
	SIZE 7,72 color schem 2;
	DEFAULT 1

@ 11,58 get ms_add  pict [@*I] size 1,14 defa 1 valid  f_kor([CREATE])
@ 12,58 get ms_kor  pict [@*I] size 1,14 defa 1 valid  f_kor([EDIT])
@ 13,58 get ms_add  pict [@*I] size 1,14 defa 1 valid  f_del()
@ 15,58 get ms_pov  pict [@*I] size 1,14 defa 1 valid  f_pov()
@ 16,30 get ms_save pict [@*IT] size 1,12 defa 1 valid f_save()

on key label HOME do p_homekey
if recc()=0
	READ CYCLE MODAL OBJECT 2
else
	READ CYCLE MODAL OBJECT 1
endif
m.kodbk=space(7)
use in tm

proc p_homekey
_curobj=1
show gets

***********************************************************
func f_kor
***********************************************************
parameter mode

select dovlich
if recc()=0
	wait wind nowait [ Заповнўть довўдник лўчильникўв ]
	return
endif

select tm
scatter memvar
m.marka=dovlich.marka
m.hv=iif(hvoda==[G],2,iif(hvoda==[H],1,0))


if mode==[CREATE]
	select tm
	m.lich=allt(str(recc()+1))
	m.kodbk=m_kodbk
	if empty(m.date_vst)
		m.date_vst=date()
	endif
	m.pokp=0
	m.poks=narax.kprop
	m.n_lich=space(11)
	mtitle=[ Встановлення нового лўчильника ]
else
	mtitle=[ Корегування лўчильника ]
endif

DEFINE WINDOW wlich1 ;
		FROM INT((SROW()-15)/2),INT((SCOL()-65)/2) ;
		TO INT((SROW()-15)/2)+14,INT((SCOL()-65)/2)+64 ;
		TITLE mtitle ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wlich1

@ 1,3  SAY "Лўчильник........."
@ 1,28 SAY "Дата встановлення"
@ 3,3  SAY "Hомер............."
*@ 4,3  SAY "Hомер.пломби....."
@ 5,3  SAY "Початковий показ.."
@ 7,3  SAY "Середнўй показ...."
@ 4,41 SAY "Марка"
@ 7,41 SAY "Вода"
@ 11,26 SAY "[ Записати ]"
@ 3,48 to 5,61 color w/br

@ 1,21 GET m.lich SIZE 1,1 PICTURE "9";
	when mode==[CREATE];
	valid not seek(m.lich) or mode==[EDIT];
	error [ Лўчильник вже ўснуї ]
@ 1,49 GET m.date_vst SIZE 1,10
@ 3,21 GET m.n_lich SIZE 1,11
@ 5,21 GET m.pokn SIZE 1,9 PICTURE "999999.99"
*@ 6,21 GET m.n_plomba SIZE 1,11
@ 7,21 GET m.poks SIZE 1,9 PICTURE "999999.99"
@ 4,50 GET m.marka valid fv_marka()
@ 6,48 GET m.hv ;
	PICTURE "@^ Холодна;Гаряча" ;
	SIZE 3,11 DEFAULT 1 ;
	COLOR SCHEME 5,5
@ 11,26 get mm_ok pict [@*IT] size 1,12 defa 1 valid fv_OK()

READ CYCLE MODAL
RELEASE WINDOW wlich1

show gets
select tm
@ 13,18 say allt(str(recc()))
keyb([{UPARROW}])

*////////////////////////
func fv_marka
*///////////////////////
if last()#13
	return .t.
endif
select dovlich
set order to marka
m.marka=chrtran(m.marka,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
  [ЙЦУКЕ]+CHR(141)+[ГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
seek(m.marka)
activ popup pop_marka rest
if last()=27
      return .t.
endif
m.kodm=dovlich.kodm
m.marka=dovlich.marka
set order to kodm

*///////////////////
func fv_ok
*///////////////////
select tm
if mode==[CREATE]
	insert into tm from memvar
else
	gather memvar
endif
repl hvoda with iif(m.hv=1,[H],iif(m.hv=2,[G],[]))

***********************************************************
func f_del
***********************************************************
select tm
if recc()=0
	wait wind nowait [ Лўчильникўв немаї ]
	return
endif
m.mes = [ Знищити лўчильник ]+lich+[ ]+allt(n_lich)+;
	[ ]+allt(dovlich.marka)+[ ?]
if p_confirm(m.mes,.t.)
	delete
	pack
	show gets
	@ 13,18 say allt(str(recc()))
endif
keyb([{UPARROW}])

***********************************************************
func f_pov
***********************************************************
select tm
if recc()=0
	wait wind nowait [ Лўчильникўв немаї ]
	return
endif
if empty(date1)
	do to_pov
	keyb([{UPARROW}])
	return
endif
if not empty(date1) and empty(date2)
	do from_pov
	keyb([{UPARROW}])
	return
endif

*////////////////////
proc to_pov
*////////////////////
select tm
DEFINE WINDOW wpov ;
		FROM INT((SROW()-13)/2),INT((SCOL()-50)/2) ;
		TO INT((SROW()-13)/2)+12,INT((SCOL()-50)/2)+49 ;
		TITLE " Зняття на повўрку " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wpov
@ 1,2 SAY "Лўчильник"
@ 4,2 SAY "Hомер"
*@ 3,2 SAY "Пломба"
@ 4,28 SAY "Марка"
@ 1,22 SAY "Дата зняття"
@ 6,27 SAY "Об'їм води" COLOR W/RB    
@ 6,2 SAY "Поч.Показ" 	COLOR W/RB    
@ 6,15 SAY "Кўн.показ"	COLOR W/RB    
@ 3,0 TO 3,47 			COLOR W/RB    
@ 5,0 TO 5,47 			COLOR W/RB    
@ 9,20 SAY "[ OK ]"

scatter memvar
m.marka=dovlich.marka
m.date1=date()
m.date2={}

@ 1,12 GET m.lich when .f.
@ 1,35 GET m.date1
@ 4,8 GET m.n_lich disable
@ 4,34 GET m.marka disable
@ 7,2 GET m.pokn SIZE 1,9 when .f.
@ 7,15 GET m.pokp SIZE 1,9 valid fv_pokp()
@ 7,27 GET m.ov SIZE 1,9 
@ 9,20 get mpov0OK pict [@*IT] defa 1 size 1,6 valid mpto()

READ CYCLE MODAL
RELEASE WINDOW wpov
show gets

*/////////////////////////
func fv_pokp
m.ov=m.pokp-m.pokn
*/////////////////////////
func mpto
select tm
gather memvar
repl pokdpo with pokp
repl datep with date1

*////////////////////
proc from_pov
*////////////////////
select tm
DEFINE WINDOW wpov ;
		FROM INT((SROW()-13)/2),INT((SCOL()-50)/2) ;
		TO INT((SROW()-13)/2)+12,INT((SCOL()-50)/2)+49 ;
		TITLE " Прийняття з повўрки " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5

ACTIVATE WINDOW wpov
@ 1,2 SAY "Лўчильник"
@ 4,2 SAY "Hомер"
*@ 3,2 SAY "Пломба"
@ 4,28 SAY "Марка"
@ 1,18 SAY "Дата прийняття"
@ 6,27 SAY "Об'їм води" COLOR W/RB    
@ 6,2 SAY "Поч.Показ" 	COLOR W/RB    
@ 6,15 SAY "Кўн.показ"	COLOR W/RB    
@ 3,0 TO 3,47 			COLOR W/RB    
@ 5,0 TO 5,47 			COLOR W/RB    
@ 9,20 SAY "[ OK ]"

scatter memvar
m.marka=dovlich.marka
m.date2=date()

@ 1,12 GET m.lich when .f.
@ 1,35 GET m.date2;
	valid m.date2>=m.date1;
	error [ Невўрно введена дата ]
@ 4,8 GET  m.n_lich
@ 4,34 GET m.marka valid fv_pmarka()
@ 7,2 GET  m.pokn SIZE 1,9 disable
@ 7,15 GET m.pokpipo SIZE 1,9 valid fv_pokp()
@ 7,27 GET m.ov SIZE 1,9 disable
@ 9,20 get mpov0OK pict [@*IT] defa 1 size 1,6 valid mpfrom()

READ CYCLE MODAL NOMOUSE
RELEASE WINDOW wpov
show gets

*////////////////////
func fv_pmarka
if last()#13
	return .t.
endif
select dovlich
set order to marka
m.marka=chrtran(m.marka,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
     [ЙЦУКЕ]+CHR(141)+[ГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
seek(m.marka)
activ popup pop_marka rest at 4,34
if last()=27
     return .t.
endif
m.kodm=dovlich.kodm
m.marka=dovlich.marka
set order to kodm

*////////////////////
func mpfrom
select tm
gather memvar

select narax
seek m.kodbk
select tpilga
seek m.kodbk
select dovnor
seek [08]

mday=date2-date1
mov=poks/30*mday
most=mov*narax.kanal
msv=tvod*mov
mst=tstok*most

select narax
if tpilga.kodbk==m.kodbk
        msv = msv/kprop*(kprop*100-tpilga.pil)/100
        mst = mst/kprop*(kprop*100-tpilga.pil)/100
endif 	

if mov#0  
		select 0
		use $narax2
		append blank
		repl kodbk with m.kodbk
		repl svd with msv
		repl std with mst
	    repl ovd with mov
		repl ostd with most
		repl memo with [Повўрка за ]+allt(str(mday))+[ дн.(Л]+tm.lich+[)]
		brow normal title [Донарахування]
		pack
		use
endif

***********************************************************
func f_save
***********************************************************
select lich
seek m.kodbk+chr(0)
delete while kodbk==m.kodbk

select tm
use
select lich
append from $lich
select 0
use $lich alias tm index i$lich
set relat to kodm into dovlich

if recc()#0 and flag_first
	do p_narax
endif
select narax2
append from $narax2

*/////////////////
proc p_narax
*////////////////
select narax
seek m.kodbk
select lich
seek m.kodbk+chr(0)
mdatr=date_vst

wait wind nowait [ Хвилинку! ]
if month(mdatr)=month(_m_date) and year(mdatr)=year(_m_date)
	mday=day(mdatr)-1
	do p_donar
else
	mday=31-day(mdatr)
	do p_deznar
endif
do delpil_90

*******************
proc p_donar
*******************
sele tpilga
seek m.kodbk
sele narax
seek m.kodbk
sele dovnor
seek narax.kodnor	

mov=ov/30*mday*narax.kprop
most=mov*narax.kanal
msv=tvod*mov
mst=tstok*most

if tpilga.kodbk==m.kodbk
        msv = msv/narax.kprop*(narax.kprop*100-tpilga.pil)/100
        mst = mst/narax.kprop*(narax.kprop*100-tpilga.pil)/100
endif 	

if mov#0  
		sele narax2
		append blank
		repl kodbk with m.kodbk
		repl svd with msv
		repl std with mst
	    repl ovd with mov
		repl ostd with most
		repl memo with [Hараховано за ]+allt(str(mday))+[ дн.(Л)]
		wait clear
		brow normal title [Донарахування]
endif

**********************
proc delpil_90
**********************
select zpilga 
if not seek(m.kodbk)
	return
endif
delete while kodbk==m.kodbk for kodpil==[90] or kodpil==[91]
wait wind [ Знищення пўльг 90,91 ] nowait
pack
wait clear
return

*******************
proc p_deznar
*******************
mnyear=year(mdatr)

store 0 to msvp,mstp,mov,most
do while .t.
	mcyear=str(mnyear,4)
	mname=[arhiv\]+mcyear+[\narax.dbf]
	if not file(mname)
		exit
	endif
	select 0
	use (mname) alias arh order tm
	
	seek m.kodbk
	scan while kodbk==m.kodbk
		do case
			case mnyear=year(mdatr) and val(mis)<month(mdatr)
				loop
			case mnyear=year(mdatr)  and val(mis)=month(mdatr)
				msvp=msvp-svp*mday/30
				mstp=mstp-stp*mday/30
				mov=mov-ov*mday/30
				most=most-ost*mday/30
			case mnyear>=year(mdatr) and val(mis)>month(mdatr)
				msvp=msvp-svp
				mstp=mstp-stp
				mov=mov-ov
				most=most-ost
		endcase
	endscan
	use
	mnyear=mnyear+1
enddo
	
if mov#0  
		sele narax2
		append blank
		repl kodbk with m.kodbk
		repl svd with msvp
		repl std with mstp
	    repl ovd with mov
		repl ostd with most
		repl memo with [Знято з ]+dtoc(mdatr)+[ (Л)]
		wait clear
		brow normal title [Донарахування]
endif
