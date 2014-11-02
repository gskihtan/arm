********************* SETUP **************************

do p_prepare

MAX_OV_PIL = 4

****************** OPEN DATABASE *********************

******************** DEFINES *************************

define wind www from 3,10 to 18,60;
	double shadow color w+/gb,w+/gb,w+/gb,w+/gb;
	title [ Формування нарахувань ]
	
DEFINE WINDOW wdate ;
		FROM INT((SROW()-5)/2),INT((SCOL()-34)/2) ;
		TO INT((SROW()-5)/2)+4,INT((SCOL()-34)/2)+33 ;
		FLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ ],75) color &m_mescolor
do datcheck
if not m_result
	m_result=p_confirm([Продовжити нарахування ?],.t.)
endif

if not m_result
	do p_clear
	return
endif

activ wind wdate
@ 1,2 SAY "Дата нарахувань" 
@ 1,19 GET m.daten defa date()
read
rele wind wdate

if last()=27
	do p_clear
	return
endif

activ wind www
	
do p_zpilga
do p_lich
do p_narax2

do p_subs
do p_subsn

do p_lichb
do p_raz2

do p_raznar
do p_narax
do p_saldo

?
? [===========================]
?
? [ Нарахування сформованў]
wait [ Натиснўть any key...]
rele wind www

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

************************
proc p_raz2
************************
?[ Разовў змўни по вулицям - ]
use narax order kodbk
select 0
use dovad order kodbk
select 0
use raznar2
index on kodv to raxnar2 comp
select dovad
set relat to kodv into raznar2
select narax
set relat to kodbk into dovad
go top
scan
	if empty(raznar2.kodv)
		repl narax.kodn2 with []
		loop
	endif
	do case
	case narax.kodnor == [01]
		repl narax.kodn2 with [20]
	case narax.kodnor == [02]
		repl narax.kodn2 with [30]
	case narax.kodnor == [03]
		repl narax.kodn2 with [40]
	case narax.kodnor == [04]
		repl narax.kodn2 with [50]
	case narax.kodnor == [05]
		repl narax.kodn2 with [60]
	case narax.kodnor == [06]
		repl narax.kodn2 with [70]
	case narax.kodnor == [07]
		repl narax.kodn2 with [90]
	endcase
endscan
close data
??[OK!]

************************
proc p_zpilga
************************
?[ Пўльги - ]
select 0
use dovpil order kodpil
select 0
use zpilga
repl all zpilga.del with zpilga.date<=m.daten and not empty(zpilga.date)
set filter to not zpilga.del
set relat to kodpil into dovpil
repl all pil with dovpil.pil,kpil with 1
select dovpil
use
select zpilga
set order to kodbk
*total on kodbk to $pilga field pil,kpil,kodpil_s
total on kodbk to $pilga field pil,kpil
use $pilga
index on kodbk to ipilga comp
close data
??[OK!]

************************
proc p_lich
************************
?[ Лўчильники - ]

select 0
use dovlich order kodm
select 0
use lich order kodbk
set relat to kodm into dovlich

repl all ov1 with ov+poks,pokp with flich_00()

total on kodbk to $lich field ov1
use $lich
index on kodbk to ilich comp
close data

* Lich before 1 year;

select;
	lich.kodbk,;
	min(lich.date_vst) as min_date;
	from lich;
	into dbf $y_lich;
	order by kodbk;
	group by kodbk
close data
use $y_lich
md_del = gomonth(m.daten,1)
delete for (md_del-min_date > 365)
pack
index on kodbk to i_y_lich

close data

??[OK!]

************************
proc p_narax2
************************
?[ Перерахунки - ]
use narax2
index on kodbk to inarax2 comp
total on kodbk to $narax2
use $narax2
index on kodbk to inarax2 comp
close data
??[OK!]

************************
proc p_subs
************************
?[ Субсидў∙ - ]
use subs order kodbk
total on kodbk to $subs field suma
use $subs
index on kodbk to isubs comp
close data
??[OK!]

************************
proc p_subsn
************************
?[ Субсидў∙ неоплаченў - ]
use subsn order kodbk
total on kodbk to $subsn field suma
use $subsn
index on kodbk to isubsn comp
close data
??[OK!]

************************
proc p_lichb
************************
?[ Будинковў лўчильники - ]
select kodv,bud,kodnor,sum(ov) as ov,00000.0000 as ov1;
 from lichb into dbf outlichb;
 group by kodv,bud
close data
use outlichb alias lichb
select 0
use $lich index ilich alias tlich
select 0
use dovad order adr1
select 0
use narax order kodbk
select dovad
set relat to kodbk into tlich,kodbk into narax
select lichb
go top
scan
	select dovad
	seek f_adr1([lichb])
	store 0 to mkpr,mkpl,movl
	scan while f_adr1([dovad])==f_adr1([lichb])
		if not empty(tlich.kodbk)
			movl=movl+tlich.ov1
			mkpl=mkpl+narax.kprop
		endif
		if not empty(narax.oplomb)
			mkpl=mkpl+narax.kprop
		endif
		mkpr=mkpr+narax.kprop
	endscan
	select lichb
	if mkpr=0
		repl ov1 with 0
	else
		repl ov1 with (ov-movl)/(mkpr-mkpl)
	endif
endscan
select lichb
index on f_adr1([lichb]) to iadrl comp
close data
??[OK!]

************************
proc p_raznar
************************
?[ Разовў змўни - ]
create table $raznar (kodbk c(7),kodnor c(2))
use $raznar alias raznar
select 0
use dovad
select 0
use raznarax
go top
scan
	mmode=razindex()
	select dovad
	do case
		case mmode=[0]
			set order to kodbk
			seek raznarax.dil+space(6)
			scan while subs(kodbk,1,1)==raznarax.dil
				insert into raznar (kodbk,kodnor);
				values (dovad.kodbk,raznarax.kodnor)
			endscan
		case mmode=[1]
			set order to adr1
			seek f_adr1([raznarax])
			scan while f_adr1([dovad])==f_adr1([raznarax])
				insert into raznar (kodbk,kodnor);
				values (dovad.kodbk,raznarax.kodnor)
			endscan
		case mmode=[2]
			set order to kodbk
			seek raznarax.kodbk1
			scan while kodbk<=raznarax.kodbk2
				insert into raznar (kodbk,kodnor);
				values (dovad.kodbk,raznarax.kodnor)
			endscan
		case mmode=[3]
			set order to kodbk
			seek raznarax.kodbk1
			insert into raznar (kodbk,kodnor);
			values (dovad.kodbk,raznarax.kodnor)
	endcase
	select raznarax
endscan
select raznar
index on kodbk to iraznar comp unique
close data
??[OK!]

************************
proc p_narax
************************
?
?[ Формування нарахувань - ]

use narax in 1
use $pilga   in 2 index ipilga  alias tpil
use $lich    in 3 index ilich   alias tlich
use $subs    in 5 index isubs   alias tsubs
use $subsn   in 6 index isubsn  alias tsubsn
use $raznar  in 7 index iraznar alias raznar
use outlichb in 8 index iadrl	alias lichb
use dovad    in 9 order kodbk
use $narax2  in 10 index inarax2 alias tnarax2
use dovnor   in 11 order kodnor
use $y_lich  in 12 index i_y_lich alias y_lich

select dovad
set relat to f_adr1([dovad]) into lichb

select narax
set relat to kodbk into dovad,;
			 kodbk into tpil,;
			 kodbk into tlich,;
			 kodbk into tsubs,;
			 kodbk into tsubsn,;
			 kodbk into raznar,;
			 kodbk into tnarax2,;
			 kodbk into y_lich

go top

scan

	repl subs  with tsubs.suma,;
		 subsn with tsubsn.suma,;
		 ovd   with tnarax2.ovd,;
		 ostd  with tnarax2.ostd,;
		 svd   with tnarax2.svd,;
		 std   with tnarax2.std
	
	mkodnor = [08]

	if empty(oplomb)
		if empty(tlich.kodbk) && нема квартирного лўчильника
			if not empty(f_adr1([lichb])) && ї будинковий лўчильник
				repl ov with lichb.ov1*kprop
				mkodnor = lichb.kodnor
			else && по нормў
				if empty(raznar.kodbk)
					mkodnor= iif(empty(narax.kodn2),narax.kodnor,narax.kodn2)
				else
					mkodnor=raznar.kodnor
				endif
				select dovnor
				seek mkodnor
				select narax
				repl ov with dovnor.ov*kprop
				if not empty(datev)
					repl ov with ov*(30-day(datev))/30
				endif
			endif
		else
			repl ov with tlich.ov1
			if not empty(y_lich.kodbk)
				mkodnor = [11]
			endif
		endif
	else
		repl ov with 0
	endif
	
	select dovnor
	seek mkodnor
	select narax
	
	repl kodn with mkodnor
	repl ost  with ov*kanal
	msv = ov*dovnor.tvod
	mst = ost*dovnor.tstok
	repl sv with round(msv,2)
	repl st with round(mst,2)
	
	if empty(tpil.kodbk)
		repl svp with sv,stp with st
		repl pil with 0
	else
        repl pil with tpil.pil
        
        m_max_v = MAX_OV_PIL * tpil.kpil
        msv_p = min(ov / kprop * tpil.kpil, m_max_v) * dovnor.tvod
        mst_p = min(ost / kprop * tpil.kpil, m_max_v) * dovnor.tstok
        m_sv_p = msv_p * pil/100/tpil.kpil	
        m_st_p = mst_p * pil/100/tpil.kpil
                
        repl svp with round(sv - m_sv_p, 2)
        repl stp with round(st - m_st_p, 2)
        
        * repl svp with round(msv/kprop*(kprop*100-pil)/100,2)
        * repl stp with round(mst/kprop*(kprop*100-pil)/100,2)
    endif

    
*     PDV
    
	mzal=opl
	mnarax=svp+stp
	msal1=saldn+mnarax-pdv_saldn
	if saldn>0
		if pdv_saldn>=mzal
			repl pdv_saldp with pdv_saldn-mzal
			repl pdv_deb with mzal
			repl pdv_kred with 0
			mzal=0
		else
			repl pdv_saldp with 0
			repl pdv_deb with pdv_saldn
			mzal=mzal-pdv_saldn
		endif
	else
		repl pdv_saldp with 0
		repl pdv_deb with 0
	endif
	
	if msal1>0
		if mzal<=msal1
			repl pdv_kred with 0
		else
			repl pdv_kred with mzal-msal1
		endif
	else
		if mzal>mnarax
			repl pdv_kred with mzal-mnarax
		else
			repl pdv_kred with 0
		endif
	endif

endscan

close data
??[OK!]

************************
func flich_00
************************
if empty(date2)
	mpokp=pokn+ov1
else
	mpokp=pokpipo+poks
endif
if empty(dovlich.maxp)
	return mpokp
endif
mmax=10^dovlich.maxp
if mpokp>mmax
	mpokp=mpokp-mmax
endif
return mpokp

************************
proc p_saldo
************************
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


