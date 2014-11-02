********************* SETUP **************************

do p_prepare
cYear=[]

****************** OPEN DATABASE *********************

select 0
use dovvul order kodv

select 0
use dovad order kod
set relat to kodv into dovvul

******************** DEFINES *************************

define wind wkod from 2,2 to 16,54;
	shadow double color n/w,w+/n,n/w,n/w;
	title [ Архўв ]
define wind warh from 0,0 to 15,79 color w+/gb,w+/b,gr+/w,gr+/w,gr+/w,;
	gr+/w,gr+/b;
	panel
define wind wbr1 from 3,2 to 20,77 shad panel;
 color schem 8
define wind winf from 16,0 to 23,79 none color w/b,w/b,w/b,w/b
define wind wa from 1,0 to 23,79 color g/n fill '░' none

define popup pop_dir title [Виберўть архўв];
	marg scroll
mdir=0
do def_popdir

define popup pop_full from 4,20 to 13,50 in screen;
	shad color schem 2;
	title [Додаткова ўнформацўя]
define bar 1 of pop_full prom [Оплата]
define bar 2 of pop_full prom [Субсидў∙]
define bar 3 of pop_full prom [Субсидў∙ неопл.]
define bar 4 of pop_full prom [Донарахування]
define bar 5 of pop_full prom [Лўчильники]
define bar 6 of pop_full prom [Пўльги]
define bar 7 of pop_full prom [Довўдник норм]
define bar 8 of pop_full prom [Довўдник пўльг]
on select popup pop_full do full_info

define popup pop_lich in winf;
	 margin scroll prom field;
	 padr(allt(outlich.n_lich),10)+[│]+str(outlich.pokn,9,2)+[│]+;
	 	str(outlich.pokp,9,2);
	 title [Номер─────Пок.поч───-Пок.кўн─]

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ F1 Пошук,додаткова ўнформацўя │ F12 Друк ;
	│ Esc Вихўд │ F9 Кальк. │],75);
	 color &m_mescolor
activ wind wa
activ wind wkod
m.kodbk=space(7)
m.fio=[]
m.adr=[]
@ 10,2 say [Абонент :] get m.fio size 1,35 when .f. color n/w,n/gb
@ 11,2 say [Адреса  :] get m.adr size 1,35 when .f. color n/w,n/gb
@ 1,2 say [Особовий рахунок] get m.kodbk;
	when fw_kodbk();
	valid fv_kodbk();
	error [ Рахунок не знайдено ]
@ 3,2 get mdir popup pop_dir size 6,46;
	valid open_arh()
READ CYCLE MODAL
rele wind wa
rele wind wkod
rele wind warh
rele wind winf
rele wind wb1
close data

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************************
func fw_kodbk
*****************************
on key label f1 do p_poshuk
keyb [{SHIFT+END}]

*****************************
func fv_kodbk
*****************************
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
select dovad
if not seek(mkod)
        return .f.
endif
on key label f1

m.kodbk=kodbk
m.fio=fio
m.adr=f_adro()
show gets

******************************
func open_arh
******************************
if last()#13
	return
endif

cYear=subs(PRMBAR([pop_dir],mdir),10,4)
path=[ARHIV\]+cYear

if not all_files()
	return
endif

select 0
use &path\dovnor order tm

select 0
use &path\dovpil order tm

select 0
use &path\zpilga order tm
seek m.kodbk
copy to $zpilga while kodbk==m.kodbk
use $zpilga alias zpilga
index on mis to $mis comp
set relat to kodpil+mis into dovpil

select 0
use &path\narax order tm
seek m.kodbk
copy to $narax while kodbk==m.kodbk
use $narax alias narax
index on mis to $mis comp

select 0
use &path\lich order tm
seek m.kodbk
copy to $lich while kodbk==m.kodbk
use $lich alias lich
index on mis+lich to lich comp
copy stru to outlich
select 0
use outlich

select 0
use &path\lichb order tm
*seek f_adr1([dovad])+[01]
copy to $lichb for f_adr1([lichb])==f_adr1([dovad])
use $lichb alias lichb
index on mis to lichb comp
set filter to mis==narax.mis

select narax
set relat to kodn+mis into dovnor,mis+[1] into lich

if recc()>0
	do a_scr
else
	wait wind nowait [По рахунку немаї даних]
endif
		
use in dovnor
use in dovpil
use in zpilga
use in lich
use in lichb
use in narax
use in outlich

_curobj=4

********************
proc full_info
********************
on key label f1
nom_bar=bar()
do case
	case bar()=1
		mfile=path+[\post.dbf]
		if not file(mfile)
			wait wind nowait [Нема файлу ]+mfile
			return
		endif
		select 0
		use (mfile) order tm
		seek m.kodbk
		copy to $post while kodbk==m.kodbk
		use post order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $post alias post
		append from $temp
		index on mis to post comp
		if recc()>0
			seek narax.mis
			brow wind wbr1;
				noappend noedit nodelete;
				title [Оплата];
				field;
					month=iif(not empty(mis),m_mis[val(mis),1],[Поточна]);
					  :8 :h=[мўсяць] ,;
					suma                        :h=[оплата],;
					date                        :h=[дата оплати],;
					npach                       :h=[№пач]
		else
			wait wind nowait [ Оплату не знайдено ]
		endif
		use
	case bar()=2
		mfile=path+[\subs.dbf]
		if not file(mfile)
			wait wind nowait [Нема файлу ]+mfile
			return
		endif
		select 0
		use (mfile) order tm
		seek m.kodbk
		copy to $subs while kodbk==m.kodbk
		use subs order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $subs alias subs
		append from $temp
		index on mis to subs comp
		if recc()>0
			seek narax.mis
			brow wind wbr1;
				noappend noedit nodelete;
				title [Субсидў∙];
				field;
					month=iif(not empty(mis),m_mis[val(mis),1],[Поточна]);
					  :8 :h=[мўсяць] ,;
					suma                        :h=[субсидўя],;
					date                        :h=[дата],;
					npach                       :h=[№пач]
		else
			wait wind nowait [ Субсидў∙ не знайдено ]
		endif
		use
	case bar()=3
		select 0
		use subsn order kodbk
		seek m.kodbk
		copy to $subsn while kodbk==m.kodbk
		use $subsn alias subsn
		if recc()>0
			brow wind wbr1;
				noappend noedit nodelete;
				title [Субсидў∙ неоплаченў];
				field;
					month=[Поточна]          :8 :h=[мўсяць] ,;
					suma                        :h=[субс.н.],;
					date                        :h=[дата],;
					npach                       :h=[№пач]
		else
			wait wind nowait [ Субсидў∙ не знайдено ]
		endif
		use
	case bar()=4
		mfile=path+[\narax2.dbf]
		if not file(mfile)
			wait wind nowait [Нема файлу ]+mfile
			return
		endif
		select 0
		use (mfile) order tm
		seek m.kodbk
		copy to $narax2 while kodbk==m.kodbk
		use narax2 order kodbk
		seek m.kodbk
		copy to $temp while kodbk==m.kodbk
		use $narax2 alias narax2
		append from $temp
		index on mis to narax2 comp
		if recc()>0
			seek narax.mis
			brow wind wbr1;
				noappend noedit nodelete;
				title [Донарахування];
				field;
					month=iif(not empty(mis),m_mis[val(mis),1],[Поточна]);
					  :8 :h=[мўсяць] ,;
				ovd                   :h=[Об.води],;
				ostd                  :h=[Об.сток],;
				svd                   :h=[S за воду],;
				std                   :h=[S за сток],;
				memo                  :h=[Примўтка]
		else
			wait wind nowait [ Перерахункўв не знайдено ]
		endif
		use
	case bar()=5
		select lichb
		mfilter2=filter()
		set filter to
		
		select lich
		mfilter1=filter()
		set filter to
		
		count to m
		if m>0
			seek(narax.mis)
			brow wind wbr1 ;
				noappend noedit nodelete;
				title [ Лўчильники];
				field;
					month=m_mis[val(mis),1]      :8 :h=[мўсяць],;
					lich							:h=[],;
					n_lich							:h=[номер л.],;
					pokn                            :h=[поч.пок],;
					pokp                            :h=[кўн.пок],;
					poks                            :h=[сер.пок],;
					ov1                             :h=[об.води],;
					datep                           :h=[дата],;
					date1                           :h=[на повўрку],;
					date2                           :h=[з повўрки],;
					pokdpo                          :h=[пок. до повўрки],;
					pokpipo                         :h=[пок. пўсля повўрки]
		else
			select lichb
			count to m
			if m>0
			seek narax.mis
			brow wind wbr1;
				noappend noedit nodelete;
				title [Будинковў лўчильники];
				field;
					month=m_mis[val(mis),1]      :8 :h=[мўсяць],;
					lich							:h=[],;
					pokn                            :h=[поч.пок],;
					pokp                            :h=[кўн.пок],;
					ov                              :h=[заг.об.],;
					ov1                             :h=[об.на 1 особу],;
					ov2=ov1*narax.kprop 			:h=[об.води]
			else
				wait [Лўчильникўв не знайдено] wind nowait
			endif
		endif
		select lich
		set filter to &mfilter1
		select lichb
		set filter to &mfilter2
	case bar()=6
		select zpilga
		if recc()>0
			seek narax.mis
			brow wind wbr1;
				noappend noedit nodelete;
				title [Пўльги];
				field;
					month=m_mis[val(mis),1]	  :8 :h=[мўсяць] ,;
					dovpil.nazpil                :h=[пўльга],;
					dovpil.pil                   :h=[%],;
					fiopil                       :h=[пўльговик],;
					date                         :h=[дўйсна до]
		else
			wait wind nowait [ Пўльг не знайдено ]
		endif
	case bar()=7
		select dovnor
		if recc()>0
			seek narax.mis
			brow wind wbr1 for mis=narax.mis;
				noappend noedit nodelete;
				title [Довўдник норм - ]+m_mis[val(narax.mis),1];
				field;
					kodnor :r :h=[Код],;
					naznor :r :h=[Hазва норми],;
					ov	   :r :h=[Об.води],;
					tvod   :r :h=[Цўна за воду],;
					tstok  :r :h=[Цўна за стоки]
		else
			wait wind nowait [ Пўльг не знайдено ]
    	endif
	case bar()=8
		select dovpil
		if recc()>0
			seek narax.mis
			brow wind wbr1 for mis=narax.mis;
				noappend noedit nodelete;
				title [Довўдник пўльг - ]+m_mis[val(narax.mis),1];
				field;
					kodpil                 :h=[код],;
					nazpil                 :h=[пўльга],;
					dovpil.pil             :h=[%]
		else
			wait wind nowait [ Пўльг не знайдено ]
    	endif
endcase
on key label f1 activ popup pop_full bar nom_bar
*deact popup
	
*********************
proc a_scr
*********************
nom_bar=1
on key label f1 activ popup pop_full bar nom_bar
mtitle=[Narax - ]+m.kodbk+[ - ]+f_adro()+[, ]+cYear+[ рўк]
mwin=[Narax]
brow nowait wind warh;
	noappend noedit nodelete;
	when br_when();
	title mtitle;
	field;
		month=m_mis[val(mis),1]  :8 :h=[мўсяць] ,;
		fio                         :h=[Прўзвище] ,;
		nar=iif(not empty(oplomb),[ОПЛ],iif(not empty(lich.kodbk),;
				     [ ЛЛ],[   ]))  :h=[] :w=.f. ,; 
		kprop                       :h=[проп] ,;
		pil 			            :h=[%],;
		saldn                       :h=[сальдо п.],;
		narax=svp+stp               :h=[нарах.] ,;
		doplat=svd+std              :h=[доплати] ,;
		subs                        :h=[субс.] ,;
		subsn                       :h=[субс.н] ,;
		opl                         :h=[оплата] ,;
		saldp                       :h=[сальдо к.] ,;
		saldpn=saldp-subsn          :h=[сальд.к.субс.н] ,;
		ugoda=iif(not empty(ugoda),str(ugoda,5)+[ ]+dtoc(ugdate),[]);
		 :16 :h=[угода]

ACTIVATE WINDOW winf
@ 1,1 SAY "Ов" COLOR BG/B    
@ 2,1 SAY "Ос" COLOR BG/B    
@ 3,1 SAY "Sв" COLOR BG/B    
@ 4,1 SAY "Sс" COLOR BG/B    
@ 0,4 SAY "Hарахов." color w+/b
@ 0,45 SAY "Лўчильники" color w+/b

@ 0,24 SAY "Сальдо п.." COLOR BG/B    
@ 1,24 SAY "Hарахов..." COLOR BG/B    
@ 2,24 SAY "Оплата...." COLOR BG/B    
@ 3,24 SAY "Субс......" COLOR BG/B    
@ 4,24 SAY "Субс.н...." COLOR BG/B    
@ 5,24 SAY "Пўл.в....." COLOR BG/B    
@ 6,24 SAY "Пўл.ст...." COLOR BG/B    
@ 7,24 SAY "Сальдо к.." COLOR BG/B    

@ 6,47 SAY "С.кўн.субс.н........." COLOR BG/B    
@ 5,1 SAY "Пўльга - " color w+/b
@ 6,1 SAY "Опломб - " color w+/b
@ 0,14 SAY "Доплати" color w+/b
@ 1,44 get msel popup pop_lich defa 1 size 6,35;
	color w/b,w/b,w/b,w/b,w/b,w/b when f_00()

on key label F9 do p_calc
on key label F12 do a_print
READ CYCLE with winf,&mwin activate show_00()
on key label f1
on key label f9
on key label f12
deact wind winf

*****************
func br_when
*****************
activ wind winf noshow
mcolor1=[w/n]
@ 1,4 SAY narax.ov 	SIZE 1,9 color &mcolor1
@ 2,4 SAY narax.ost SIZE 1,9 color &mcolor1
@ 3,4 SAY narax.svp SIZE 1,9 color &mcolor1
@ 4,4 SAY narax.stp SIZE 1,9 color &mcolor1
@ 1,14 SAY narax.ovd SIZE 1,9 color &mcolor1
@ 2,14 SAY narax.ostd SIZE 1,9 color &mcolor1
@ 3,14 SAY narax.svd SIZE 1,9 color &mcolor1
@ 4,14 SAY narax.std SIZE 1,9 color &mcolor1

@ 0,34 SAY narax.saldn SIZE 1,9 color &mcolor1
@ 1,34 SAY narax.svp+narax.stp+narax.svd+narax.std SIZE 1,9 color &mcolor1
@ 2,34 SAY narax.opl SIZE 1,9 color &mcolor1
@ 3,34 SAY narax.subs SIZE 1,9 color &mcolor1
@ 4,34 SAY narax.subsn SIZE 1,9 color &mcolor1
@ 5,34 SAY narax.sv - narax.svp SIZE 1,9 color &mcolor1
@ 6,34 SAY narax.st - narax.stp SIZE 1,9 color &mcolor1
@ 7,34 SAY narax.saldp SIZE 1,9 color &mcolor1

@ 7,68 SAY narax.saldp- narax.subsn SIZE 1,10  color gb+/b
@ 5,10 SAY pil SIZE 1,3 color gb+/b
@ 6,10 SAY narax.oplomb color gb+/b

@ 7,1 SAY dovnor.naznor SIZE 1,22 color gb+/b
select lich
copy to $temp for mis==narax.mis
select outlich
zap
append from $temp
select narax
show gets
activ wind &mwin

******************
func f_00
******************
keyb [{Ctrl+F1}]

******************
func show_00
******************
if not wvisible(mwin)
	clear read
endif

******************
func all_files
******************
err=[]
if  not file(path+[\dovnor.dbf]) 
	err=[dovnor.dbf]
endif
if  not file(path+[\dovpil.dbf]) 
	err=[dovpil.dbf]
endif
if  not file(path+[\zpilga.dbf]) 
	err=[zpilga.dbf]
endif
if  not file(path+[\narax.dbf]) 
	err=[narax.dbf]
endif
if  not file(path+[\lich.dbf]) 
	err=[lich.dbf]
endif
if  not file(path+[\lichb.dbf]) 
	err=[lichb.dbf]
endif
if  not file(path+[\dovnor.cdx]) 
	err=[dovnor.cdx]
endif
if  not file(path+[\dovpil.cdx]) 
	err=[dovpil.cdx]
endif
if  not file(path+[\zpilga.cdx]) 
	err=[zpilga.cdx]
endif
if  not file(path+[\narax.cdx]) 
	err=[narax.cdx]
endif
if  not file(path+[\lich.cdx]) 
	err=[lich.cdx]
endif
if  not file(path+[\lichb.cdx]) 
	err=[lichb.cdx]
endif

if empty(err)
	return .t.
else
	wait wind nowait [Файл не знайдений ]+path+[\]+err
	return .f.
endif

**********************
proc a_print
**********************
select narax
go bott
mpFio=fio
mpKodbk=kodbk
mpSubsn=subsn
select lich
store [] to lich1,lich2,lich3,lich4
scan for mis==narax.mis
	if inlist(lich,[1],[2],[3],[4])
		mvar=[lich]+lich
		&mvar=[Лўчильник ]+lich+[ : номер ]+allt(n_lich)+;
		[ показ : ]+allt(str(pokp,9,2))
	endif
endscan
select narax
do p_print with [arhivs]
