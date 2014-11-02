****************** OPEN DATABASE *********************

fileno=fcreate([datcheck.txt])
if fileno=-1
	wait wind nowait [ Неможливо створити файл ]
else

******************** DEFINES *************************

define wind w from 3,10 to 18,60;
	double shadow color w+/gb,w+/gb,w+/gb,w+/gb;
	title [ Перевўрка даних ]

************** BEGIN PROGRAMM ************************

activ wind w
mcnte=0
mtcnte=0
mcol1=[w+/gb]
mcol2=[r/gb]
m_result=.t.

do p_dovvul
do p_dovad
do p_dovnor
do p_dovlich
do p_dovpil

do p_narax
do p_narax2
do p_zpilga
do p_lich

do p_postp
do p_post
do p_subsp
do p_subs
do p_subsnp
do p_subsn

do p_lichb
do p_raznar

?
?[ ==========================================]
if mtcnte=0
	?[ Помилок не знайдено]
else
	?[ Помилок- ]+allt(str(mtcnte))
endif
if m_result
	keyb [ ]
endif
wait [ Натиснўть any key...]
rele wind w

***************** END OF PROGRAMM *********************

	=fputs(fileno,[])
	if mtcnte=0
		=fputs(fileno,[Помилок не знайдено])
	else
		=fputs(fileno,[Помилок : ]+allt(str(mtcnte)))
	endif
	=fclose(fileno)
	if mtcnte#0
		modify command datcheck.txt noedit
	endif
endif

****************** PROCEDURES *************************

**********************
proc p_dovvul
**********************
mcnte=0
?[ Довўдник вулиць (DOVVUL.DBF)       - ]
=fputs(fileno,[Довўдник вулиць (DOVVUL.DBF) :])
*/////////////////////////////////////////
use dovvul order kodv
mkod=[]
go top
scan
	mkod1=kodv
	if empty(kodv)
		=pe([Порожнї значення коду])
	endif
	if mkod1==mkod
		=pe([Однаковий KODV для двох вулиць- ]+kodv)
	endif
	mkod=mkod1
	if len(allt(kodv))#4
		=pe([Невўрне значення KODV- ]+kodv)
	endif
	if empty(allt(vul))
		=pe([Порожнї значення VUL,KODV = ]+kodv+;
		[,VUL = ]+vul)
	endif
endscan
set order to vul
mkod=[]
go top
scan
	mkod1=allt(vul)
	if mkod1==mkod
		=pe([Однаковий VUL для двох вулиць- ]+vul)
	endif
	mkod=mkod1
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_dovad
**********************
mcnte=0
?[ Довўдник адрес (DOVAD.DBF)         - ]
=fputs(fileno,[Довўдник адрес (DOVAD.DBF) :])
*/////////////////////////////////////////
select 0
use dovvul order kodv
select 0
use dovad order kod
set relat to kodv into dovvul

mkod=-1
go top
scan
	mkod1=val(subs(kodbk,2))
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if mkod1=mkod
		=pe([Однаковий KODBK для двох абонентўв- ]+kodbk)
	endif
	mkod=mkod1
	if len(allt(kodbk))#7
		=pe([Невўрне значення KODBK- ]+kodbk)
	endif
	if kodv#dovvul.kodv
		=pe([Не знaйдено вулицў з KODV = ]+kodv+;
		[,KODBK = ]+kodbk)
	endif
	if not empty(derg) and derg#[D] and derg#[W]
		=pe([Невўрне значення DERG = ]+derg+;
		[,KODBK = ]+kodbk)
	endif
	if not empty(poverh) and poverh<0
		=pe([Невўрне значення POVERH- ]+allt(str(poverh))+;
		[,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_dovnor
**********************
mcnte=0
?[ Довўдник норм (DOVNOR.DBF)         - ]
=fputs(fileno,[Довўдник норм (DOVNOR.DBF) :])
*/////////////////////////////////////////
select 0
use dovnor order kodnor

mkod=[]
go top
scan
	mkod1=kodnor
	if empty(kodnor)
		=pe([Порожнї значення коду])
	endif
	if mkod1==mkod
		=pe([Однаковий KODNOR для двох норм- ]+kodnor)
	endif
	mkod=mkod1
	if len(allt(kodnor))#2
		=pe([Невўрне значення KODNOR- ]+kodnor)
	endif
	if empty(allt(naznor))
		=pe([Порожнї значення NAZNOR]+;
		[,KODNOR = ]+kodnor)
	endif
	if ov<0
		=pe([Невўрне значення OV- ]+str(ov,9,4)+;
		[,KODNOR = ]+kodnor)
	endif
	if tvod<=0
		=pe([Невўрне значення TVOD- ]+str(tvod,9,4)+;
		[,KODNOR = ]+kodnor)
	endif
	if tstok<=0
		=pe([Невўрне значення TSTOK- ]+str(tstok,9,4)+;
		[,KODNOR = ]+kodnor)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_dovlich
**********************
mcnte=0
?[ Довўдник лўчильникўв (DOVLICH.DBF) - ]
=fputs(fileno,[Довўдник лўчильникўв (DOVLICH.DBF) :])
*/////////////////////////////////////////
select 0
use dovlich order kodm

mkod=[]
go top
scan
	mkod1=kodm
	if empty(kodm)
		=pe([Порожнї значення коду])
	endif
	if mkod1==mkod
		=pe([Однаковий KODM для двох марок- ]+kodm)
	endif
	mkod=mkod1
	if len(allt(kodm))#2
		=pe([Невўрне значення KODM- ]+kodm)
	endif
	if maxp<2
		=pe([Невўрне значення MAXP- ]+allt(str(maxp))+;
		[,KODM = ]+kodm)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_dovpil
**********************
mcnte=0
?[ Довўдник пўльг (DOVPIL.DBF)        - ]
=fputs(fileno,[Довўдник пўльг (DOVPIL.DBF) :])
*/////////////////////////////////////////
select 0
use dovpil order kodpil

mkod=[]
go top
scan
	mkod1=kodpil
	if empty(kodpil)
		=pe([Порожнї значення коду])
	endif
	if mkod1==mkod
		=pe([Однаковий KODPIL для двох пўльг- ]+kodpil)
	endif
	mkod=mkod1
	if len(allt(kodpil))#2
		=pe([Невўрне значення KODPIL- ]+kodpil)
	endif
	if empty(allt(nazpil))
		=pe([Порожнї значення NAZPIL]+;
		[,KODPIL = ]+kodpil)
	endif
	if pil<0
		=pe([Невўрне значення PIL- ]+allt(str(pil))+;
		[,KODPIL = ]+kodpil)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_narax
**********************
mcnte=0
?[ База нарахувань (NARAX.DBF)        - ]
=fputs(fileno,[База нарахувань (NARAX.DBF) :])
*/////////////////////////////////////////
select 0
use dovad order kodbk
select 0
use dovnor order kodnor
select 0
use lich order kodbk
select 0
use narax order kodbk
set relat to kodbk into dovad,kodnor into dovnor,kodbk into lich

mkod=[]
go top
scan
	mkod1=kodbk
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if mkod1==mkod
		=pe([Два нарахування для одного абонента- ]+kodbk)
	endif
	mkod=mkod1
	if dovad.kodbk#narax.kodbk
		=pe([Нема ўнформацў∙ в довўднику адрес,KODBK = ]+kodbk)
	endif
	if dovnor.kodnor#narax.kodnor
		=pe([Нема ўнформацў∙ в довўднику норм,KODNOR = ]+kodnor+;
		[,KODBK = ]+kodbk)
	endif
	if kprop<1 and empty(oplomb)
		=pe([Невўрне значення KPROP- ]+allt(str(kprop))+;
		[,KODBK = ]+kodbk)
	endif
	if kanal#0 and kanal#1
		=pe([Невўрне значення KANAL- ]+allt(str(kanal))+;
		[,KODBK = ]+kodbk)
	endif
	if not empty(datev) and (;
	year(datev)#year(date()) or month(datev)#month(date()))
		=pe([Невўрне значення DATEV- ]+dtoc(datev)+;
		[,KODBK = ]+kodbk)
	endif
	if oplomb>date()
		=pe([Невўрне значення OPLOMB,KODBK = ]+kodbk+;
		[,OPLOMB- ]+dtoc(oplomb))
	endif
	if empty(lich.kodbk) and kodnor==[08]
		=pe([Код норми - 08, але вўдсутнўй запис в таблицў LICH.DBF, KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_narax2
**********************
mcnte=0
?[ База перерахункўв (NARAX2.DBF)     - ]
=fputs(fileno,[База перерахункўв (NARAX2.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use narax2 order kodbk
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#narax2.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_zpilga
**********************
mcnte=0
?[ База пўльговикўв (ZPILGA.DBF)      - ]
=fputs(fileno,[База пўльговикўв (ZPILGA.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use dovpil order kodpil
select 0
use zpilga order kodbk
set relat to kodbk into narax,kodpil into dovpil

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#zpilga.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
	if dovpil.kodpil#zpilga.kodpil
		=pe([Нема ўнформацў∙ в довўднику пўльг,KODBK = ]+kodbk+;
		[,KODPIL = ]+kodpil)
	endif
endscan
close data

select 0
use dovpil order kodpil
select 0
use zpilga
set relat to kodpil into dovpil
repl all pil with dovpil.pil,kpil with 1
select dovpil
use
select zpilga
set order to kodbk
total on kodbk to $pilga field pil,kpil
use $pilga alias tpil
select 0
use narax order kodbk
select tpil
set relat to kodbk into narax
go top
scan
	if narax.kprop<tpil.kpil
		=pe([К-сть пўльговикўв ]+str(kpil,2)+;
		[, к-сть прописаних ]+str(narax.kprop,2)+;
		[, KODBK = ]+kodbk)
	endif
endscan
close data
*
* Unique n_posv
*
use zpilga
index on n_posv to i comp
set filter to val(n_posv)>0
mn=[]
kod1=[]
scan
	if allt(n_posv)==mn
		=pe([Неунўкальне значення номеру посв. ]+[, KODBK = ]+kodbk+[,]+kod1)
	endif
	mn=allt(n_posv)
	kod1=kodbk
endscan
close data

*/////////////////////////////////////////
do pinfo

**********************
proc p_lich
**********************
mcnte=0
?[ База лўчильникўв (LICH.DBF)        - ]
=fputs(fileno,[База лўчильникўв (LICH.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use dovlich order kodm
select 0
use lich order kodbk
set relat to kodbk into narax,kodm into dovlich

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#lich.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	else
		if not empty(narax.oplomb)
			=pe([Вода опломбована,KODBK = ]+kodbk)
		endif
	endif
	if not empty(kodm) and dovlich.kodm#lich.kodm
		=pe([Нема ўнформацў∙ в довўднику лўчильникўв,KODM = ]+kodm+;
		[,KODBK = ]+kodbk)
	endif
	if val(lich)=0
		=pe([Невўрне значення LICH,KODBK = ]+kodbk)
	endif
	if poks<0
		=pe([Невўрне значення POKS,KODBK = ]+kodbk+[,POKS = ]+str(poks,9,2))
	endif
	if not empty(hvoda) and hvoda#[H] and hvoda#[G])
		=pe([Невўрне значення HVODA,KODBK = ]+kodbk+[,LICH = ]+lich+;
		[,HVODA = ]+hvoda)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_postp
**********************
mcnte=0
?[ Пачка оплати (POSTP.DBF)           - ]
=fputs(fileno,[Пачка оплати (POSTP.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use postp
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#postp.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([Невўрне значення DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([Невўрне значення SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([Невўрне значення NPACH- ]+npach+;
		[,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_post
**********************
mcnte=0
?[ База оплати (POST.DBF)             - ]
=fputs(fileno,[База оплати (POST.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use post
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#post.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([Невўрне значення DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([Невўрне значення SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([Невўрне значення NPACH- ]+npach+;
		[,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_subsp
**********************
mcnte=0
?[ Пачка субсидўй (SUBSP.DBF)         - ]
=fputs(fileno,[Пачка субсидўй (SUBSP.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subsp
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#subsp.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([Невўрне значення DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([Невўрне значення SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([Невўрне значення NPACH- ]+npach+;
		[,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_subs
**********************
mcnte=0
?[ База субсидўй (SUBS.DBF)           - ]
=fputs(fileno,[База субсидўй (SUBS.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subs
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#subs.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([Невўрне значення DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([Невўрне значення SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([Невўрне значення NPACH- ]+npach+;
		[,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_subsnp
**********************
mcnte=0
?[ Пачка субсидўй неопл. (SUBSNP.DBF) - ]
=fputs(fileno,[Пачка субсидўй неопл. (SUBSNP.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subsnp
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#subsnp.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([Невўрне значення DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([Невўрне значення SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([Невўрне значення NPACH- ]+npach+;
		[,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_subsn
**********************
mcnte=0
?[ База субсидўй неопл. (SUBSN.DBF)   - ]
=fputs(fileno,[База субсидўй неопл. (SUBSN.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subsn
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([Порожнї значення коду])
	endif
	if narax.kodbk#subsn.kodbk
		=pe([Нема нарахувань,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([Невўрне значення DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([Невўрне значення SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([Невўрне значення NPACH- ]+npach+;
		[,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_lichb
**********************
mcnte=0
?[ Будинковў лўчильники (LICHB.DBF)   - ]
=fputs(fileno,[Будинковў лўчильники (LICHB.DBF) :])
*/////////////////////////////////////////
select 0
use dovvul order kodv
select 0
use dovad
index on kodv+padr(allt(bud),4) to iadr comp
set relat to kodv into dovvul
select 0
use dovlich order kodm
select 0
use dovnor order kodnor
select 0
use lichb
set relat to kodv+padr(allt(bud),4) into dovad,;
	kodnor into dovnor,;
	kodm into dovlich

go top
scan
	if kodv+padr(allt(bud),4)#dovad.kodv+padr(allt(dovad.bud),4)
		=pe([Адресу не знайдено])
	endif
	if not empty(kodm) and dovlich.kodm#kodm
		=pe([Нема ўнформацў∙ в довўднику лўчильникўв,KODM = ]+kodm+;
		[,]+allt(dovvul.vul)+[ ]+bud)
	endif
	if val(lich)=0
		=pe([Невўрне значення LICH- ]+lich+;
		[,]+allt(dovvul.vul)+[ ]+bud)
	endif
	if poks<0
		=pe([Невўрне значення POKS- ]+str(poks,9,2)+;
		[,]+allt(dovvul.vul)+[ ]+bud)
	endif
	if dovnor.kodnor#kodnor
		=pe([Нема ўнформацў∙ в довўднику норм,KODM = ]+kodm+;
		[,]+allt(dovvul.vul)+[ ]+bud)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_raznar
**********************
mcnte=0
?[ Разовў змўни (RAZNARAX.DBF)        - ]
=fputs(fileno,[Разовў змўни (RAZNARAX.DBF) :])
*/////////////////////////////////////////
select 0
use dovvul order kodv
select 0
use dovad
index on kodv+padr(allt(bud),4) to iadr comp
set relat to kodv into dovvul
select 0
use dovnor order kodnor
select 0
use raznarax
set relat to kodv+padr(allt(bud),4) into dovad,;
	kodnor into dovnor

go top
scan
	do case
		case not empty(dil)
			if !empty(kodv) or !empty(bud) or !empty(kodbk1);
			or !empty(kodbk2)
				=pe([Невўрний формат запису])
			endif
			select dovad
			set order to kodbk
			seek raznarax.dil
			if subs(kodbk,1,1)#raznarax.dil
				=pe([Не знайдено дўльницю ]+raznarax.dil)	
			endif
			set order to iadr
			select raznarax
		case not empty(kodv)
			if !empty(dil) or !empty(kodbk1) or	!empty(kodbk2)
				=pe([Невўрний формат запису])
			endif
			if kodv+padr(allt(bud),4)#dovad.kodv+padr(allt(dovad.bud),4)
				=pe([Адресу не знайдено])
			endif
		case not empty(kodbk2)
			if !empty(dil) or !empty(kodv) or !empty(bud);
			or empty(kodbk1)
				=pe([Невўрний формат запису])
			endif
			select dovad
			set order to kodbk
			mmres1=seek(raznarax.kodbk1)
			mmres2=seek(raznarax.kodbk2)
			set order to iadr
			select raznarax
			if not mmres1
				=pe([Не знайдено рахунок ]+raznarax.kodbk1)	
			endif
			if not mmres2
				=pe([Не знайдено рахунок ]+raznarax.kodbk2)
			endif
		case not empty(kodbk1) and empty(kodbk2)
			if !empty(dil) or !empty(kodv) or !empty(bud)
				=pe([Невўрний формат запису])
			endif
			select dovad
			set order to kodbk
			mmres=seek(raznarax.kodbk1)
			set order to iadr
			select raznarax
			if not mmres
				=pe([Не знайдено рахунок ]+raznarax.kodbk1)
			endif
	endcase
	if dovnor.kodnor#raznarax.kodnor
		=pe([Нема ўнформацў∙ в довўднику норм,KODNOR = ]+kodnor)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc pinfo
**********************
if mcnte=0
	??[OK!]
	=fputs(fileno,[     NO ERROR])
else
	set color to &mcol2
	??allt(str(mcnte))+[ errors!]
	set color to &mcol1
endif

**********************
func pe
**********************
param mmess
mcnte=mcnte+1
mtcnte=mtcnte+1
=fwrite(fileno,[     Запис #]+allt(str(recno()))+[ : ])
=fputs(fileno,mmess)
m_result=.f.