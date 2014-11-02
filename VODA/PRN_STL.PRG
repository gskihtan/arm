********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************
******************** DEFINES *************************

DEFINE WINDOW wstatl ;
		FROM INT((SROW()-17)/2),INT((SCOL()-32)/2) ;
		TO INT((SROW()-17)/2)+16,INT((SCOL()-32)/2)+31 ;
		TITLE " Статистика по вст. лўч. " ;
		FLOAT NOCLOSE SHADOW NOMINIMIZE DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ESC Вихўд│],75) color &m_mescolor

ACTIVATE WINDOW wstatl
@ 2,2 SAY "Темрўн :" 
@ 2,12 SAY "з" 
@ 4,11 SAY "по" 
@ 6,1 TO 10,28 COLOR W/RB    
@ 13,11 SAY "[ Друк ]"

@ 2,14 GET mdate1 defa date()
@ 4,14 GET mdate2 defa date()
@ 7,3 GET ms_mode ;
	PICTURE "@*RVN Державний сектор;Приватний сектор;Будинковў лўчильники" ;
	SIZE 1,24,0 DEFAULT 1 valid fv_mode()
@ 13,11 GET ms_print pict [@*IN] defa 1 size 1,8 valid fv_print()

READ CYCLE MODAL
RELEASE WINDOW wstatl

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
proc fv_print
*********************

mfilt1 = [between(lich.date_vst,mdate1,mdate2)]
do case
	case ms_mode=1
		mfilt2=[(dovad.derg=="D" and empty(f_adr1("lichb")))]
	case ms_mode=2
		mfilt2=[(dovad.derg=="W" and empty(f_adr1("lichb")))]
	case ms_mode=3
		mfilt2=[(not empty(f_adr1("lichb")))]
endcase

wait wind nowait [ Хвилинку! ]

select 0
use lichb order kodbl

select 0
use dovad order kodbk
set relat to f_adr1([dovad]) into lichb

select 0
use lich order kodbk
set relat to kodbk into dovad

copy to outlich fields kodbk,date_vst,hvoda,kodm,lich;
	for &mfilt1 and &mfilt2
*=================================================
close data
select 0
use dovvul order kodv
select 0
use dovlich order kodm

select 0
use dovad order kodbk
set relat to kodv into dovvul

select 0
use outlich
index on kodbk + lich to i comp
set relat to kodbk into dovad, kodm into dovlich

select 0
create table out (nom n(6),adr c(29),kodbk c(7),markah c(10),;
	markag c(10),date_vst d(8),poverh n(2))
select outlich
go top
scan
	if  kodbk<>out.kodbk or;
		kodbk==out.kodbk and hvoda==[H] and not empty(out.markah) or;
		kodbk==out.kodbk and hvoda==[G] and not empty(out.markag)
		
		select out
		append blank
		repl kodbk with outlich.kodbk
		repl markah with iif(outlich.hvoda==[H],dovlich.marka,[])
		repl markag with iif(outlich.hvoda==[G],dovlich.marka,[])
		repl date_vst with outlich.date_vst
		repl adr with allt(dovvul.vul)+[ ]+;
			allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[])
		repl poverh with dovad.poverh
		select outlich
	else
		repl out.kodbk with kodbk
		repl out.markah with iif(hvoda==[H],dovlich.marka,out.markah)
		repl out.markag with iif(hvoda==[G],dovlich.marka,out.markag)
	endif
endscan

close data
use out
select out.kodbk from out into dbf out_knom group by kodbk
select out_knom
mcount = recc()
use

select out

repl all nom with recno()
wait clear
*brow normal		
do p_print with [prn_stl]
use

*******************
proc fv_mode
*******************
_curobj=objnum(ms_print)