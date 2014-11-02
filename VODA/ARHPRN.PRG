********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

define wind warh from 3,15 to 15,67;
	shadow double color schem 5;
	title [ Друк архўву ]

define popup pop_dir title [Виберўть архўв];
	marg scroll
mdir=0
do def_popdir

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │],75) color &m_mescolor
mdate=ctod([01]+subs(dtoc(date()),3))
mdil=[ ]

activ wind warh
@ 1,2 get mdir popup pop_dir size 6,46 valid fv_popdir()
@ 8,2 say "Дўльниця :" get mdil
@ 9,2 SAY "Перўод   : з            по"
@ 9,41 SAY "[ Друк ]"
@ 9,15 get mdate1 defa {}
@ 9,29 get mdate2 defa {}
@ 9,41 GET msel pict [@*I] size 1,8 defa 1 valid prn_arh()

READ CYCLE MODAL
rele wind warh


***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

***********************
func fv_popdir
***********************
mcyear=subs(PRMBAR([pop_dir],mdir),10,4)
mdate1=ctod([01.01.]+mcyear)
mdate2=ctod([31.12.]+mcyear)
show gets

***********************
func prn_arh
***********************
mcyear=subs(PRMBAR([pop_dir],mdir),10,4)
path=[ARHIV\]+mcyear
use &path\narax order tm
if empty(mdil)
	mu=[.t.]
else
	mu=[subs(narax.kodbk,1,1)==mdil]
endif

wait wind nowait [Хвилинку!]

select;
	narax.kodbk,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
    padr(allt(str(narax.kprop)),3) as kprop,;
    padr(allt(str(narax.pil)),4) as pil,;
    narax.saldn,;
    sum(narax.ov) as ov,;
    sum(narax.ost) as ost,;
    sum(narax.svp) as svp,;
    sum(narax.stp) as stp,;
    sum(narax.ovd) as ovd,;
    sum(narax.ostd) as ostd,;
    sum(narax.svd) as svd,;
    sum(narax.std) as std,;
    sum(narax.opl) as opl,;
    sum(narax.subs) as subs,;
    sum(narax.subsn) as subsn,;
    space(20) as lich1,;
    space(20) as lich2,;
    space(20) as lich3,;
    space(20) as lich4,;
    narax.saldp,;
    narax.ugoda;
    from narax,dovad,dovvul;
    into dbf out;
    where narax.kodbk==dovad.kodbk and dovad.kodv==dovvul.kodv;
    	and val(narax.mis)>=month(mdate1);
    	and val(narax.mis)<=month(mdate2);
    	and &mu;
    order by narax.kodbk;
    group by narax.kodbk
close data    

wait wind nowait [Ще чуть-чуть...]
use out
index on kodbk to i comp

symb=[*]
select 0
use &path\narax order tm
set relat to kodbk into out
mkod=[q]
scan for val(narax.mis)>=month(mdate1);
		 and val(narax.mis)<=month(mdate2);
		 and &mu
    if kodbk<>mkod
    	repl out.saldn with saldn
    	mkod=kodbk
    endif
	if padr(allt(str(narax.kprop)),3)<>out.kprop;
	and at(symb,out.kprop)=0
		repl out.kprop with allt(out.kprop)+symb
	endif
	if padr(allt(str(narax.pil)),4)<>out.pil;
	and at(symb,out.pil)=0
		repl out.pil with allt(out.pil)+symb
	endif
	repl out.subsn with subsn
	repl out.saldp with saldp
endscan
select out
repl all pil with [] for allt(pil)==[0]

close data
select 0
use out index i
select 0
use &path\lich order tm
set relat to kodbk into out

scan for not empty(out.kodbk) and val(lich.mis)=month(mdate2)
	select out
	if inlist(lich.lich,[1],[2],[3],[4])
		mfield=[lich]+lich.lich
		repl &mfield with;
			[(]+allt(lich.n_lich)+[ - ]+allt(str(lich.pokp,9,2))+[)]
	endif
	select lich
endscan

wait clear
close data
use out
do p_print with [arhiv3]
use
