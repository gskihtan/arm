********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************
select 0
use dovvul order kodv

select 0
use dovad order kodbk
set relat to kodv into dovvul

select 0
use narax order kodbk

select 0
use dovpil order kodpil

select 0
use zpilga order kodbk

select 0
use dovnor order kodnor
set filter to inlist(kodnor,[01],[02],[03],[04],[05],[06],[07])

select narax
******************** DEFINES *************************

	DEFINE WINDOW winfo ;
		FROM 1,0 TO 23,79;
		TITLE " Ўнформацўя по абоненту " ;
		FLOAT ;
		NOCLOSE ;
		DOUBLE ;
		COLOR SCHEME 5

define wind wbr1 from 3,2 to 20,77 shad panel color schem 8

define popup pop_pil scroll marg prom fields;
str(recno([tm]),2)+[│]+tm.kodpil+[│]+dovpil.nazpil+[│]+str(dovpil.pil,3)+[│]+dtoc(tm.date)+;
	[ ]+subs(tm.fiopil,1,11);
title [───Назва пўльги─────────%───Дўйсна до────────────]

define popup pop_pil1 from 1,14 shad scroll marg in screen;
	prompt field dovpil.kodpil+[ ]+padr(dovpil.nazpil,20)
on select popup pop_pil1 deact popup

define popup pop_nor from 6,44 shad scroll marg;
	prompt field dovnor.kodnor+[ ]+padr(dovnor.naznor,20)
on select popup pop_nor deact popup

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ F1 Пошук │ Ctrl+ENTER Зберегти │],75) color &m_mescolor
ACTIVATE WINDOW winfo

m.kodbk=space(7)
m_err=[]

@ 1,24 GET m.kodbk when fw_kodbk();
					valid fv_kodbk();
					error m_err

READ CYCLE MODAL
RELEASE WINDOW winfo

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

***********************
func fw_kodbk
***********************
clear
@ 0,3 TO 2,43 COLOR W/RB    
@ 1,6 SAY "Особовий рахунок"
on key label f1 do p_poshuk

***********************
func fv_kodbk
***********************
select dovad
set order to kod
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
if not seek(mkod)
        m_err=[ Рахунок не знайдено ]
        return .f.
endif
m.kodbk=dovad.kodbk
show gets
set order to kodbk
select narax
if not seek(m.kodbk)
	m_err=[ Нарахувань нема ]
	return .f.
endif

on key label f1
mrec=recno()

m.kodnor=kodnor
m.kanal=kanal
m.kprop=kprop
m.ugoda=ugoda
m.ugdate=ugdate
m.datev=datev
m.oplomb=oplomb
m.U_P=U_P
m.ug_suma=ug_suma
m.ug_da_k=ug_da_k
select dovnor
if seek(m.kodnor)
	m.naznor=naznor
	m.kodnor=kodnor
endif

store [DISABLED] to fnarax,fpost,fsubs,fsubsn,flich,fnarax,fnarax2
do set_flags

select zpilga
seek m.kodbk
copy to $pilga while kodbk==m.kodbk
select 0
use $pilga alias tm

set relat to kodpil into dovpil

select dovad
m.fio=fio
m.kodv=kodv
m.bud=bud
m.kvar=kvar
m.datainv=datainv
m.kodrax=kodrax
m.vul=dovvul.vul
m.oplm=iif(not empty(m.oplomb),[ОПЛОМБОВАНО !],space(15))

do show_scr
select tm
use
m.kodbk=space(7)

***********************
proc show_scr
***********************
@ 13,4 to 19,74 COLOR W/RB
@ 0,51 TO 7,74  COLOR W/RB
@ 3,3 TO 6,43   COLOR W/RB
@ 20,60 SAY "[ Зберегти ]"
@ 15,58 SAY "[ Додати     ]"
@ 16,58 SAY "[ Корегувати ]"
@ 17,58 SAY "[ Знищити    ]"
@ 13,58 SAY "Пўльги"
@ 8,44 SAY  "Їд.рах"
@ 9,44 SAY  "Уг.послуги"
@ 10,44 SAY "Hомер угоди"
@ 11,44 SAY "Дата  угоди"
@ 12,44 SAY "Suma  уг."
@ 13,57 SAY "Кўн. уг."
@ 1,53 SAY "[ Оплата          ]"
@ 2,53 SAY "[ Субсидў∙        ]"
@ 3,53 SAY "[ Субсидў∙ неопл. ]"
@ 4,53 SAY "[ Hарахування     ]"
@ 5,53 SAY "[ Перерахунки     ]"
@ 6,53 SAY "[ Лўчильники      ]"

@ 11,5 SAY "Hорма витрат води"
@ 9,5 SAY "Каналўзацўя....."
@ 10,5 SAY "Поч.нарахувань.."
@ 8,5 SAY "Прописано......."
@ 7,5 SAY "Ўнвентаризацўя.."
@ 3,5 SAY "Абонент"
@ 5,36 SAY "кв."

@ 4,5 GET m.fio SIZE 1,25 
@ 5,31 SAY m.bud SIZE 1,4
@ 5,39 GET m.kvar SIZE 1,3 
@ 5,5 SAY m.vul SIZE 1,25
@ 7,21 GET m.datainv SIZE 1,10 
@ 8,21 GET m.kprop SIZE 1,2 
@ 9,21 GET m.kanal valid inlist(m.kanal,1,0) error [ Невўрне значення ] ;
	size 1,1
@ 10,21 GET m.datev color ,g+/br valid fv_datev()
@ 11,23 GET m.naznor SIZE 1,20 valid fv_nor();
	error [Невўрне значення] DEFA []
@ 12,23 get m.oplm when .f. color ,br+/br
@ 9,56 GET m.U_P SIZE 1,7
@ 12,64 GET m.Ug_suma SIZE 1,8
@ 13,65 GET m.Ug_da_k SIZE 1,10
@ 8,62 get m.kodrax
@ 10,62 get m.ugoda valid fw_ugoda();
	error [Такий номер вже ўснуї]
@ 11,62 get m.ugdate

@ 1,53 get ms pict [@*I] defa 1 size 1,19 valid f0(1) &fpost
@ 2,53 get ms pict [@*I] defa 1 size 1,19 valid f0(2) &fsubs
@ 3,53 get ms pict [@*I] defa 1 size 1,19 valid f0(3) &fsubsn
@ 4,53 get ms pict [@*I] defa 1 size 1,19 valid f0(4) &fnarax
@ 5,53 get ms pict [@*I] defa 1 size 1,19 valid f0(5) &fnarax2
@ 6,53 get ms pict [@*I] defa 1 size 1,19 valid f0(6) &flich

@ 13,1 get mpil pict [@&] popup pop_pil when fw_pil();
	size 7,55 defa 1 color w+/gb,w+/gb,b/gb,b/gb
@ 15,58 get ms pict [@*I] defa 1 size 1,14 valid fp_kor([NEW])
@ 16,58 get ms pict [@*I] defa 1 size 1,14 valid fp_kor([EDIT])
@ 17,58 get ms pict [@*I] defa 1 size 1,14 valid fp_del()
@ 20,60 get msave pict [@*I] defa 1 size 1,12 valid save001()

on key label Ctrl+enter do save001
READ CYCLE MODAL
on key label Ctrl+enter

**************************
func fw_pil
**************************
select tm
if recc()=0
	return .f.
else
	return .t.
endif

**************************
func fv_datev
**************************
if not empty(m.datev)
	m.oplm=space(15)
	m.oplomb={}
	show gets
endif

**************************
func fw_ugoda
**************************
if m.ugoda=0
	m.ugdate={}
	show gets
	return .t.
endif
select narax
wait wind nowait [Перевўрка...]
locate for ugoda=m.ugoda and not kodbk==m.kodbk
wait clear
return not found()

**************************
func fv_nor
**************************
select dovnor
set order to naznor
if seek(m.naznor)
	m.kodnor=kodnor
	set order to kodnor
	return .t.
endif

set order to kodnor
activ popup pop_nor
if last()=27
	mnaznor=[]
	show gets
	return .f.
endif

m.kodnor=kodnor
m.naznor=naznor
show gets

**************************
func save001
**************************
push key
on key
if p_confirm([Зберегти змўни ?],.t.)
	select narax
	goto mrec
	repl kodnor with m.kodnor
	repl kanal with m.kanal
	repl kprop with m.kprop
	repl ugoda with m.ugoda
	repl ugdate with m.ugdate
    repl datev with m.datev
	repl oplomb with m.oplomb
	repl U_P with m.U_P
	repl Ug_suma with m.Ug_suma
    repl Ug_da_k with m.Ug_da_k
	select zpilga
	seek m.kodbk
	delete while kodbk=m.kodbk
	pack
	select tm
	use
	select zpilga
	append from $pilga
	select 0
	use $pilga alias tm

	select dovad
	repl fio with m.fio
	repl kvar with m.kvar
	repl datainv with m.datainv
	repl kodrax with m.kodrax
 	clear read
endif
pop key

**************************
func f0
**************************
parameter mode
push key
on key
do case
	case mode=1
		select 0
		use post order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $temp
		if recc()>0
			brow wind wbr1;
				noappend noedit nodelete;
				title [Оплата];
				field;
					suma                        :h=[оплата],;
					date                        :h=[дата оплати],;
					npach                       :h=[№пач]
		else
			wait wind nowait [ Оплату не знайдено ]
		endif
		use
	case mode=2
		select 0
		use subs order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $temp
		if recc()>0
			brow wind wbr1;
				noappend noedit nodelete;
				title [Субсидў∙];
				field;
					suma                        :h=[Субсидўя],;
					date                        :h=[дата субсидў∙],;
					npach                       :h=[№пач]
		else
			wait wind nowait [ Субсидўю не знайдено ]
		endif
		use
	case mode=3
		select 0
		use subsn order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $temp
		if recc()>0
			brow wind wbr1;
				noappend noedit nodelete;
				title [Субсидў∙ неоплаченў];
				field;
					suma                        :h=[субс.н.],;
					date                        :h=[дата субсидў∙],;
					npach                       :h=[№пач]
		else
			wait wind nowait [ Субсидўю не знайдено ]
		endif
		use
	case mode=4
		DEFINE WINDOW wnarax ;
		FROM INT((SROW()-20)/2),INT((SCOL()-72)/2) ;
		TO INT((SROW()-20)/2)+19,INT((SCOL()-72)/2)+71 ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 1
		
		ACTIVATE WINDOW wnarax
		col1=[bg/b]
		col2=[w/b]
		col3=[w+/gb]
		col4=[w+/b]
		col5=[br+/b]
		
		@ 0,2 SAY "Hарахування" 	COLOR &col1
		@ 2,3 SAY "Об'їм води"		COLOR &col2
		@ 3,3 SAY "Об'їм стокўв"	COLOR &col2
		@ 4,3 SAY "Сума за воду"	COLOR &col2
		@ 5,3 SAY "Сума за стоки"	COLOR &col2
		@ 6,3 SAY "Сума разом"
		@ 7,3 SAY "Пўльга"			COLOR &col2
		@ 9,3 SAY "Сума з пўльгою"
		
		@ 2,19 SAY narax.ov 		SIZE 1,9 COLOR &col3
		@ 3,19 SAY narax.ost 		SIZE 1,9 COLOR &col3
		@ 4,19 SAY narax.sv 		SIZE 1,9 COLOR &col3
		@ 5,19 SAY narax.st 		SIZE 1,9 COLOR &col3
		@ 6,19 SAY narax.sv + narax.st 	SIZE 1,9  COLOR &col4
		@ 7,19 SAY narax.sv + narax.st - narax.svp - narax.stp ;
									SIZE 1,9 COLOR &col3
		@ 9,19 SAY narax.svp + narax.stp SIZE 1,9  COLOR &col5
		
		@ 0,32 SAY "Доплати" 		COLOR &col1
		@ 2,33 SAY "Об'їм води"		COLOR &col2
		@ 3,33 SAY "Об'їм стокўв"	COLOR &col2
		@ 4,33 SAY "Сума за воду"	COLOR &col2
		@ 5,33 SAY "Сума за стоки"	COLOR &col2
		@ 7,33 SAY "Сума разом"

		@ 2,47 SAY narax.ovd 				SIZE 1,9 COLOR &col3
		@ 3,47 SAY narax.ostd 				SIZE 1,9 COLOR &col3
		@ 4,47 SAY narax.svd 				SIZE 1,9 COLOR &col3
		@ 5,47 SAY narax.std 				SIZE 1,9 COLOR &col3
		@ 7,47 SAY narax.svd + narax.std 	SIZE 1,9 COLOR &col5
		
		@ 13,2 SAY "Всього нараховано" 	COLOR &col2
		@ 14,2 SAY "Оплата"				COLOR &col2
		@ 15,2 SAY "Субсидў∙"			COLOR &col2
		@ 16,2 SAY "Субсидў∙ неопл."	COLOR &col2

		@ 13,20 SAY narax.svp+ narax.stp+ narax.svd+ narax.std ;
			SIZE 1,9 COLOR &col2
		@ 14,20 SAY narax.opl 		SIZE 1,9 COLOR &col2
		@ 15,20 SAY narax.subs 		SIZE 1,9 COLOR &col2
		@ 16,20 SAY narax.subsn 	SIZE 1,9 COLOR &col2
		
		
		@ 13,35 SAY "Сальдо поч."		COLOR &col4
		@ 14,35 SAY "Сальдо кўн."		COLOR &col4
		@ 15,35 SAY "Сальдо кўн. (субс.н.)"	COLOR &col4
		
		@ 13,58 SAY narax.saldn 	SIZE 1,9 COLOR &col5
		@ 14,58 SAY narax.saldp 	SIZE 1,9 COLOR &col5
		@ 15,58 SAY narax.saldp- narax.subsn SIZE 1,9  COLOR G+/B
		
		@ 6,32 TO 6,56 						 COLOR &col1
		@ 1,1 TO 10,31 						 COLOR &col1
		@ 8,2 TO 8,30 						 COLOR &col1
		@ 1,31 TO 8,57 						 COLOR &col1    
		@ 2,61 SAY "[ OK ]"
		@ 11,0 SAY "========================================="+;
		"=============================" 	 COLOR &col1
		
		@ 2,61 get msel pict [@*IT] defa 1 size 1,6

		READ CYCLE MODAL
		RELEASE WINDOW wnarax
	case mode=5
		select 0
		use narax2 order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $temp
		if recc()>0
			brow wind wbr1;
				noappend noedit nodelete;
				title [Донарахування];
				field;
					ovd                   :h=[Об.води],;
					ostd                  :h=[Об.сток],;
					svd                   :h=[S за воду],;
					std                   :h=[S за сток],;
					memo                  :h=[Примўтка]
		else
			wait wind nowait [ Перерахункўв не знайдено ]
		endif
		use
	case mode=6
		select 0
		use lich order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $temp

		count to m
		if m>0
			brow wind wbr1 ;
				noappend noedit nodelete;
				title [ Лўчильники];
				field;
					lich							:h=[],;
					n_lich							:h=[номер л.],;
					pokn                            :h=[поч.пок],;
					pokp                            :h=[кўн.пок],;
					poks                            :h=[сер.пок],;
					ov                              :h=[об.води],;
					datep                           :h=[дата]
			use
		else
			use lichb order kodbl
			seek f_adr1([dovad])
			copy to $temp while f_adr1([DOVAD])==f_adr1([lichb])
			use $temp

			count to m
			if m>0
				brow wind wbr1;
				noappend noedit nodelete;
				title [Будинковў лўчильники];
				field;
					lich							:h=[],;
					pokn                            :h=[поч.пок],;
					pokp                            :h=[кўн.пок],;
					ov                              :h=[заг.об.],;
					ov1                             :h=[об.на 1 особу],;
					ov2=ov1*narax.kprop 			:h=[об.води]
				use
			else
				use
				wait [Лўчильникўв не знайдено] wind nowait
			endif
		endif
endcase
pop key

**************************
func fp_del
**************************
push key
on key
select tm
m.mes = [ Знищити пўльгу ]+allt(dovpil.nazpil)+[ ?]
if p_confirm(m.mes,.t.)
	delete
	pack
	show gets
endif
pop key

**************************
func fp_kor
**************************
parameter mode
select tm

if mode<>[NEW] and recc()=0
	return
endif

push key
on key
if mode=[NEW]
	append blank
	repl kodbk with m.kodbk
endif

scatter memvar
m.nazpil=dovpil.nazpil
m_result=.f.

do p_edit

select tm
if m_result
	gather memvar
else
	if mode=[NEW]
		delete
		pack
	endif
endif
show gets
pop key

**************************
procedure p_edit
**************************
DEFINE WINDOW wpil ;
		FROM INT((SROW()-12)/2),INT((SCOL()-65)/2) ;
		TO INT((SROW()-12)/2)+11,INT((SCOL()-65)/2)+64 ;
		TITLE " Ввўд пўльги " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 1

ACTIVATE WINDOW wpil

@ 1,3 SAY "Код пўльги"
@ 7,31 SAY "Примўтка"
@ 1,17 SAY "-"
@ 3,3 SAY "Пўльговик..."
@ 1,50 SAY "Ўнд.податк."
@ 5,3 SAY "Hомер посв.."
@ 6,3 SAY "Група......."
@ 7,3 SAY "KS.........."
@ 8,3 SAY "DV.........."
@ 5,31 SAY "Дўйсне до."
@ 8,54 SAY "[ OK ]"

@ 1,14 GET m.kodpil VALID fv_kodpil()
@ 1,19 GET m.nazpil when .f. color gr+/b,gr+/b
@ 3,15 GET m.fiopil 
@ 3,50 GET m.ind_pod 
@ 5,15 GET m.n_posv	
@ 5,41 GET m.date 
@ 6,15 GET m.gr	size 1,1
@ 7,15 GET m.kc
@ 8,15 GET m.dv 
@ 8,31 GET m.memo 
@ 8,54 get msave pict [@*IT] defa 1 size 1,6 VALID fv_psav()

READ CYCLE MODAL NOMOUSE
RELEASE WINDOW wpil

*////////////////////
func fv_kodpil
*////////////////////
select dovpil
if seek(m.kodpil)
	m.nazpil=nazpil
	show gets
	return .t.
endif

activ popup pop_pil1
if last()=27
	m.nazpil=space(20)
	show gets
	return .f.
endif

m.kodpil=kodpil
m.nazpil=nazpil
show gets

********************
func fv_psav
********************
m_result=.t.

********************
procedure set_flags
********************
select 0
use post order kodbk
if seek(m.kodbk)
	fpost=[ENABLED]
endif
use subs order kodbk
if seek(m.kodbk)
	fsubs=[ENABLED]
endif
use subsn order kodbk
if seek(m.kodbk)
	fsubsn=[ENABLED]
endif
use
select narax
if ov>0
	fnarax=[ENABLED]
endif
select 0
use narax2 order kodbk
if seek(m.kodbk)
	fnarax2=[ENABLED]
endif
use lich order kodbk
seek(m.kodbk)
if kodbk==m.kodbk
	flich=[ENABLED]
endif
use lichb order kodbl
if seek(f_adr1([DOVAD]))
	flich=[ENABLED]
endif
use 
