********************* SETUP **************************

do p_prepare
_m_date=date()

****************** OPEN DATABASE *********************

wait wind nowait [ �������� ]

select 0
use dovvul order kodv

select 0
use dovad order kod
set relat to kodv into dovvul

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
use $pilga alias tpilga
index on kodbk to ipil comp

select 0
use narax order kodbk
set relat to kodbk into tpilga,kodnor into dovnor

select 0
use narax2

wait clear

******************** DEFINES *************************

DEFINE WINDOW wnardel ;
		FROM INT((SROW()-10)/2),INT((SCOL()-50)/2) ;
		TO INT((SROW()-10)/2)+10,INT((SCOL()-50)/2)+49 ;
		TITLE " ������㢠��� " ;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW ;
		SYSTEM ;
		COLOR SCHEME 8


************** BEGIN PROGRAMM ************************

ACTIVATE WINDOW wnardel

m.kodbk=space(7)
m.oplomb=date()
m.error=[]
@ 1,19 GET m.kodbk when fw_kodbk() valid fv_kodbk();
	error m.error

READ CYCLE MODAL
RELEASE WINDOW wnardel

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************************
func fw_kodbk
*****************************
activ screen
@ 24,0 say padr([ F1 ���� � ],75) color &m_mescolor
activ wind wnardel
on key label f1 do p_poshuk
clear
@ 1,2 SAY "�ᮡ���� ��㭮�"
@ 3,2 SAY "������� -"
@ 4,2 SAY "����   -"
@ 5,2 say [��� ������㢠���]
@ 7,17 SAY "[ ������㢠� ]"
select dovad

*****************************
func fv_kodbk
*****************************
activ screen
@ 24,0 say padr([],75) color &m_mescolor
activ wind wnardel
on key label f1
if len(allt(m.kodbk))#7
        mkod=val(m.kodbk)
else
        mkod=val(subs(m.kodbk,2))
endif
select dovad
if not seek(mkod)
        on key label f1 do p_poshuk
        m.error=[ ���㭮� �� �������� ]
        return .f.
endif
m.kodbk=dovad.kodbk
select narax
if not seek(m.kodbk)
        on key label f1 do p_poshuk
        m.error=[ ����㢠�� ����� ]
        return .f.
endif
if not empty(oplomb)
        on key label f1 do p_poshuk
        m.error=[ ��� ����������� ]
        return .f.
endif
if kodnor==[08]
        on key label f1 do p_poshuk
        m.error=[ ��⠭������� ��稫쭨� ]
        return .f.
endif

show gets
@ 3,13 say dovad.fio
@ 4,13 say padr(dovvul.vul,20)+padr(allt(dovad.bud)+;
       iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]),8)

@ 5,20 get m.oplomb valid not empty(m.oplomb);
	error [ ����୥ ���祭�� ]
@ 7,17 get msel pict [@*IT] size 1,15 defa 1 valid p_narax()
read modal cycle

m.kodbk=space(7)

*/////////////////
proc p_narax
*////////////////
select narax
seek m.kodbk
repl oplomb with m.oplomb
mdatr=m.oplomb

wait wind nowait [ ��������! ]
if month(mdatr)=month(_m_date) and year(mdatr)=year(_m_date)
	mday=day(mdatr)-1
	do p_donar
else
	mday=31-day(mdatr)
	do p_deznar
endif

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
		repl memo with [H��客��� �� ]+allt(str(mday))+[ ��.(O)]
		wait clear
		brow normal title [������㢠���]
endif

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
		repl memo with [���� � ]+dtoc(mdatr)+[ (O)]
		wait clear
		brow normal title [������㢠���]
endif
