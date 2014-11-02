********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************


******************** DEFINES *************************

DEFINE WINDOW wb ;
		FROM INT((SROW()-14)/2),INT((SCOL()-64)/2) ;
		TO INT((SROW()-14)/2)+8,INT((SCOL()-64)/2)+40 ;
		TITLE " „àãª ¯®¢÷àª¨ §  ¯¥à÷®¤ " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc ‚¨å÷¤ ³ ],75) color &m_mescolor
ACTIVATE WINDOW wb

@ 1,2 SAY "¥à÷®¤ :" COLOR W/RB    
@ 3,2 SAY "§" 			COLOR W/RB    
@ 3,15 SAY "¯®"			COLOR W/RB    
@ 5,2 SAY "[ „àãª ]"

@ 3,4 GET m.date1 defa date()
@ 3,18 GET m.date2 defa date()

@ 5,2 GET ms_print PICTURE "@*IVN " SIZE 1,8 ;
	DEFAULT 0 VALID fv_print()

READ CYCLE MODAL
RELEASE WINDOW wb

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

************************
func fv_print
************************
wait wind nowait [ •¢¨«¨­ªã! ]
nyear1 = year(m.date1)
nyear2 = year(m.date2)
for i=nyear1 to nyear2
	cyear = allt(str(i))
	mfile = [ARHIV\]+cyear+[\LICH.DBF]
	if not file(mfile)
		wait wind [¥ §­ ©¤¥­® ä ©« ]+mfile
		return
	endif
endfor

create dbf outt (kodbk c(7),date1 d(8), date2 d(8))
for i=nyear1 to nyear2
	cyear = allt(str(i))
	mfile = [ARHIV\]+cyear+[\LICH.DBF]
	select 0
	use &mfile
	copy to out for date2 >= m.date1 and date2 <=m.date2;
	fields kodbk, date1, date2
	use
	select outt
	append from out
endfor

select 0
use dovvul
select 0
use dovad


select;
	outt.kodbk,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
	outt.date1,;
	outt.date2;
	from outt,dovad,dovvul;
	into dbf out;
	where dovad.kodv==dovvul.kodv and outt.kodbk==dovad.kodbk;
	order by outt.kodbk group by outt.kodbk
wait clear
select out
*brow normal
do p_print with [lich_p1]
close data
