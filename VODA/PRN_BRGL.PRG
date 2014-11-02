********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

DEFINE WINDOW wlich ;
	FROM INT((SROW()-9)/2),INT((SCOL()-53)/2) ;
	TO INT((SROW()-9)/2)+8,INT((SCOL()-53)/2)+52 ;
	TITLE " Заборгованнўсть по лўч. " ;
	FLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE ;
	COLOR SCHEME 5

************** BEGIN PROGRAMM ************************
 
ACTIVATE WINDOW wlich

@ 5,11 SAY "[ Перерахунок ]"
@ 5,30 SAY "[ Друк ]"
@ 5,11 GET ms_print PICTURE "@*IVN " SIZE 1,15 DEFAULT 0 VALID fv_data()
@ 5,30 GET ms_data PICTURE "@*IVN " SIZE 1,8 DEFAULT 0 VALID fv_print()
@ 2,6 SAY "Обробка архўву за     р. - "
@ 1,4 TO 3,45 COLOR W/RB    
@ 2,24 GET msyear color w+/br,w+/br when .f. defa space(4)
@ 2,33 GET msproc color gr+/br,gr+/br when .f. defa space(10)

READ CYCLE MODAL
RELEASE WINDOW wlich

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

****************
proc fv_data
****************
push key
on key
on key label END do p_end
wait wind nowait [ <END> - закiнчити ]

select;
	kodbk,;
	date_vst,;
	00000000.00 as saldn,;
	00000000.00 as opl,;
	00000000.00 as ov,;
	0000        as nmis;
	from lich;
	into dbf out3101;
	order by kodbk;
	group by kodbk

use in lich
index on kodbk to itmpl comp

*
* Read arhives
*

myear=2001-1
if file([out3102.dbf])	
	erase out3102.dbf
endif

do while .t.
		myear=myear+1
		msyear=str(myear,4)

		aname=[ARHIV\]+msyear+[\NARAX.DBF]
		lname=[ARHIV\]+msyear+[\LICH.DBF]
		if not file(aname) or not file(lname)
			exit
		endif
		*
		* process arhive
		*
		select 0
		use (lname) order tm
		select 0
		use (aname)
		set relat to kodbk+mis into lich,kodbk into out3101
		mn = recc()
		scan for kodbk==out3101.kodbk
			msproc = allt(str(recn()/mn*100))+[%]
			show gets	
			do case
				case at([ЛЛ],fio)=0 and empty(lich.kodbk)
					loop
				case not empty(lich.kodbk) and out3101.nmis=0
					repl out3101.saldn with;
						saldn+svp+stp+svd+std-subs-subsn-opl
					repl out3101.ov with ov
					repl out3101.nmis with 1
				case not empty(lich.kodbk) and out3101.nmis>0
					repl out3101.opl with out3101.opl+opl
					repl out3101.ov with out3101.ov+ov
					repl out3101.nmis with out3101.nmis+1
			endcase
		endscan
enddo
close data
pop key
rename out3101.dbf to out3102.dbf
wait clear
msproc = [OK!]
show gets

**************
proc p_end
**************
wait clear
pop key
RELEASE WINDOW wlich
close data
do p_clear
cancel

**********************
proc fv_print
**********************
if not file([out3102.dbf])
	wait wind nowait [ Данў не готовў, зробўть перерахунок ]
	return
endif

select;
	out3102.*,;
	narax.kprop,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as fio;
    from out3102,narax,dovad,dovvul;
    into dbf out;
	where dovad.kodv==dovvul.kodv and out3102.kodbk==narax.kodbk;
	  and out3102.kodbk==dovad.kodbk;
	order by out3102.kodbk
close data
use out
do p_print with [prn_brgl]
use
