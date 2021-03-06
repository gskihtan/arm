****************** OPEN DATABASE *********************

fileno=fcreate([datcheck.txt])
if fileno=-1
	wait wind nowait [ ��������� �⢮�� 䠩� ]
else

******************** DEFINES *************************

define wind w from 3,10 to 18,60;
	double shadow color w+/gb,w+/gb,w+/gb,w+/gb;
	title [ ��ॢ�ઠ ����� ]

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
	?[ ������� �� ��������]
else
	?[ �������- ]+allt(str(mtcnte))
endif
if m_result
	keyb [ ]
endif
wait [ ������� any key...]
rele wind w

***************** END OF PROGRAMM *********************

	=fputs(fileno,[])
	if mtcnte=0
		=fputs(fileno,[������� �� ��������])
	else
		=fputs(fileno,[������� : ]+allt(str(mtcnte)))
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
?[ �������� �㫨�� (DOVVUL.DBF)       - ]
=fputs(fileno,[�������� �㫨�� (DOVVUL.DBF) :])
*/////////////////////////////////////////
use dovvul order kodv
mkod=[]
go top
scan
	mkod1=kodv
	if empty(kodv)
		=pe([��஦�� ���祭�� ����])
	endif
	if mkod1==mkod
		=pe([��������� KODV ��� ���� �㫨��- ]+kodv)
	endif
	mkod=mkod1
	if len(allt(kodv))#4
		=pe([����୥ ���祭�� KODV- ]+kodv)
	endif
	if empty(allt(vul))
		=pe([��஦�� ���祭�� VUL,KODV = ]+kodv+;
		[,VUL = ]+vul)
	endif
endscan
set order to vul
mkod=[]
go top
scan
	mkod1=allt(vul)
	if mkod1==mkod
		=pe([��������� VUL ��� ���� �㫨��- ]+vul)
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
?[ �������� ���� (DOVAD.DBF)         - ]
=fputs(fileno,[�������� ���� (DOVAD.DBF) :])
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
		=pe([��஦�� ���祭�� ����])
	endif
	if mkod1=mkod
		=pe([��������� KODBK ��� ���� ���������- ]+kodbk)
	endif
	mkod=mkod1
	if len(allt(kodbk))#7
		=pe([����୥ ���祭�� KODBK- ]+kodbk)
	endif
	if kodv#dovvul.kodv
		=pe([�� ��a����� �㫨�� � KODV = ]+kodv+;
		[,KODBK = ]+kodbk)
	endif
	if not empty(derg) and derg#[D] and derg#[W]
		=pe([����୥ ���祭�� DERG = ]+derg+;
		[,KODBK = ]+kodbk)
	endif
	if not empty(poverh) and poverh<0
		=pe([����୥ ���祭�� POVERH- ]+allt(str(poverh))+;
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
?[ �������� ��� (DOVNOR.DBF)         - ]
=fputs(fileno,[�������� ��� (DOVNOR.DBF) :])
*/////////////////////////////////////////
select 0
use dovnor order kodnor

mkod=[]
go top
scan
	mkod1=kodnor
	if empty(kodnor)
		=pe([��஦�� ���祭�� ����])
	endif
	if mkod1==mkod
		=pe([��������� KODNOR ��� ���� ���- ]+kodnor)
	endif
	mkod=mkod1
	if len(allt(kodnor))#2
		=pe([����୥ ���祭�� KODNOR- ]+kodnor)
	endif
	if empty(allt(naznor))
		=pe([��஦�� ���祭�� NAZNOR]+;
		[,KODNOR = ]+kodnor)
	endif
	if ov<0
		=pe([����୥ ���祭�� OV- ]+str(ov,9,4)+;
		[,KODNOR = ]+kodnor)
	endif
	if tvod<=0
		=pe([����୥ ���祭�� TVOD- ]+str(tvod,9,4)+;
		[,KODNOR = ]+kodnor)
	endif
	if tstok<=0
		=pe([����୥ ���祭�� TSTOK- ]+str(tstok,9,4)+;
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
?[ �������� ��稫쭨��� (DOVLICH.DBF) - ]
=fputs(fileno,[�������� ��稫쭨��� (DOVLICH.DBF) :])
*/////////////////////////////////////////
select 0
use dovlich order kodm

mkod=[]
go top
scan
	mkod1=kodm
	if empty(kodm)
		=pe([��஦�� ���祭�� ����])
	endif
	if mkod1==mkod
		=pe([��������� KODM ��� ���� ��ப- ]+kodm)
	endif
	mkod=mkod1
	if len(allt(kodm))#2
		=pe([����୥ ���祭�� KODM- ]+kodm)
	endif
	if maxp<2
		=pe([����୥ ���祭�� MAXP- ]+allt(str(maxp))+;
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
?[ �������� ���� (DOVPIL.DBF)        - ]
=fputs(fileno,[�������� ���� (DOVPIL.DBF) :])
*/////////////////////////////////////////
select 0
use dovpil order kodpil

mkod=[]
go top
scan
	mkod1=kodpil
	if empty(kodpil)
		=pe([��஦�� ���祭�� ����])
	endif
	if mkod1==mkod
		=pe([��������� KODPIL ��� ���� ����- ]+kodpil)
	endif
	mkod=mkod1
	if len(allt(kodpil))#2
		=pe([����୥ ���祭�� KODPIL- ]+kodpil)
	endif
	if empty(allt(nazpil))
		=pe([��஦�� ���祭�� NAZPIL]+;
		[,KODPIL = ]+kodpil)
	endif
	if pil<0
		=pe([����୥ ���祭�� PIL- ]+allt(str(pil))+;
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
?[ ���� ����㢠�� (NARAX.DBF)        - ]
=fputs(fileno,[���� ����㢠�� (NARAX.DBF) :])
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
		=pe([��஦�� ���祭�� ����])
	endif
	if mkod1==mkod
		=pe([��� ����㢠��� ��� ������ �������- ]+kodbk)
	endif
	mkod=mkod1
	if dovad.kodbk#narax.kodbk
		=pe([���� ���ଠ��� � ��������� ����,KODBK = ]+kodbk)
	endif
	if dovnor.kodnor#narax.kodnor
		=pe([���� ���ଠ��� � ��������� ���,KODNOR = ]+kodnor+;
		[,KODBK = ]+kodbk)
	endif
	if kprop<1 and empty(oplomb)
		=pe([����୥ ���祭�� KPROP- ]+allt(str(kprop))+;
		[,KODBK = ]+kodbk)
	endif
	if kanal#0 and kanal#1
		=pe([����୥ ���祭�� KANAL- ]+allt(str(kanal))+;
		[,KODBK = ]+kodbk)
	endif
	if not empty(datev) and (;
	year(datev)#year(date()) or month(datev)#month(date()))
		=pe([����୥ ���祭�� DATEV- ]+dtoc(datev)+;
		[,KODBK = ]+kodbk)
	endif
	if oplomb>date()
		=pe([����୥ ���祭�� OPLOMB,KODBK = ]+kodbk+;
		[,OPLOMB- ]+dtoc(oplomb))
	endif
	if empty(lich.kodbk) and kodnor==[08]
		=pe([��� ��ନ - 08, ��� �������� ����� � ⠡���� LICH.DBF, KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_narax2
**********************
mcnte=0
?[ ���� �����㭪�� (NARAX2.DBF)     - ]
=fputs(fileno,[���� �����㭪�� (NARAX2.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use narax2 order kodbk
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#narax2.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
endscan
close data
*/////////////////////////////////////////
do pinfo

**********************
proc p_zpilga
**********************
mcnte=0
?[ ���� ���죮����� (ZPILGA.DBF)      - ]
=fputs(fileno,[���� ���죮����� (ZPILGA.DBF) :])
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
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#zpilga.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
	if dovpil.kodpil#zpilga.kodpil
		=pe([���� ���ଠ��� � ��������� ����,KODBK = ]+kodbk+;
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
		=pe([�-��� ���죮����� ]+str(kpil,2)+;
		[, �-��� �ய�ᠭ�� ]+str(narax.kprop,2)+;
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
		=pe([�������쭥 ���祭�� ������ ���. ]+[, KODBK = ]+kodbk+[,]+kod1)
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
?[ ���� ��稫쭨��� (LICH.DBF)        - ]
=fputs(fileno,[���� ��稫쭨��� (LICH.DBF) :])
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
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#lich.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	else
		if not empty(narax.oplomb)
			=pe([���� �����������,KODBK = ]+kodbk)
		endif
	endif
	if not empty(kodm) and dovlich.kodm#lich.kodm
		=pe([���� ���ଠ��� � ��������� ��稫쭨���,KODM = ]+kodm+;
		[,KODBK = ]+kodbk)
	endif
	if val(lich)=0
		=pe([����୥ ���祭�� LICH,KODBK = ]+kodbk)
	endif
	if poks<0
		=pe([����୥ ���祭�� POKS,KODBK = ]+kodbk+[,POKS = ]+str(poks,9,2))
	endif
	if not empty(hvoda) and hvoda#[H] and hvoda#[G])
		=pe([����୥ ���祭�� HVODA,KODBK = ]+kodbk+[,LICH = ]+lich+;
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
?[ ��窠 ����� (POSTP.DBF)           - ]
=fputs(fileno,[��窠 ����� (POSTP.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use postp
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#postp.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([����୥ ���祭�� DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([����୥ ���祭�� SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([����୥ ���祭�� NPACH- ]+npach+;
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
?[ ���� ����� (POST.DBF)             - ]
=fputs(fileno,[���� ����� (POST.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use post
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#post.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([����୥ ���祭�� DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([����୥ ���祭�� SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([����୥ ���祭�� NPACH- ]+npach+;
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
?[ ��窠 ��ᨤ�� (SUBSP.DBF)         - ]
=fputs(fileno,[��窠 ��ᨤ�� (SUBSP.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subsp
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#subsp.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([����୥ ���祭�� DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([����୥ ���祭�� SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([����୥ ���祭�� NPACH- ]+npach+;
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
?[ ���� ��ᨤ�� (SUBS.DBF)           - ]
=fputs(fileno,[���� ��ᨤ�� (SUBS.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subs
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#subs.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([����୥ ���祭�� DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([����୥ ���祭�� SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([����୥ ���祭�� NPACH- ]+npach+;
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
?[ ��窠 ��ᨤ�� �����. (SUBSNP.DBF) - ]
=fputs(fileno,[��窠 ��ᨤ�� �����. (SUBSNP.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subsnp
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#subsnp.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([����୥ ���祭�� DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([����୥ ���祭�� SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([����୥ ���祭�� NPACH- ]+npach+;
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
?[ ���� ��ᨤ�� �����. (SUBSN.DBF)   - ]
=fputs(fileno,[���� ��ᨤ�� �����. (SUBSN.DBF) :])
*/////////////////////////////////////////
select 0
use narax order kodbk
select 0
use subsn
set relat to kodbk into narax

go top
scan
	if empty(kodbk)
		=pe([��஦�� ���祭�� ����])
	endif
	if narax.kodbk#subsn.kodbk
		=pe([���� ����㢠��,KODBK = ]+kodbk)
	endif
	if date>date()
		=pe([����୥ ���祭�� DATE- ]+dtoc(date)+;
		[,KODBK = ]+kodbk)
	endif
*	if suma<=0
*		=pe([����୥ ���祭�� SUMA- ]+str(suma,9,2)+;
*		[,KODBK = ]+kodbk)
*	endif
	if len(allt(npach))#4
		=pe([����୥ ���祭�� NPACH- ]+npach+;
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
?[ �㤨����� ��稫쭨�� (LICHB.DBF)   - ]
=fputs(fileno,[�㤨����� ��稫쭨�� (LICHB.DBF) :])
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
		=pe([����� �� ��������])
	endif
	if not empty(kodm) and dovlich.kodm#kodm
		=pe([���� ���ଠ��� � ��������� ��稫쭨���,KODM = ]+kodm+;
		[,]+allt(dovvul.vul)+[ ]+bud)
	endif
	if val(lich)=0
		=pe([����୥ ���祭�� LICH- ]+lich+;
		[,]+allt(dovvul.vul)+[ ]+bud)
	endif
	if poks<0
		=pe([����୥ ���祭�� POKS- ]+str(poks,9,2)+;
		[,]+allt(dovvul.vul)+[ ]+bud)
	endif
	if dovnor.kodnor#kodnor
		=pe([���� ���ଠ��� � ��������� ���,KODM = ]+kodm+;
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
?[ ������ ����� (RAZNARAX.DBF)        - ]
=fputs(fileno,[������ ����� (RAZNARAX.DBF) :])
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
				=pe([����୨� �ଠ� ������])
			endif
			select dovad
			set order to kodbk
			seek raznarax.dil
			if subs(kodbk,1,1)#raznarax.dil
				=pe([�� �������� ���쭨�� ]+raznarax.dil)	
			endif
			set order to iadr
			select raznarax
		case not empty(kodv)
			if !empty(dil) or !empty(kodbk1) or	!empty(kodbk2)
				=pe([����୨� �ଠ� ������])
			endif
			if kodv+padr(allt(bud),4)#dovad.kodv+padr(allt(dovad.bud),4)
				=pe([����� �� ��������])
			endif
		case not empty(kodbk2)
			if !empty(dil) or !empty(kodv) or !empty(bud);
			or empty(kodbk1)
				=pe([����୨� �ଠ� ������])
			endif
			select dovad
			set order to kodbk
			mmres1=seek(raznarax.kodbk1)
			mmres2=seek(raznarax.kodbk2)
			set order to iadr
			select raznarax
			if not mmres1
				=pe([�� �������� ��㭮� ]+raznarax.kodbk1)	
			endif
			if not mmres2
				=pe([�� �������� ��㭮� ]+raznarax.kodbk2)
			endif
		case not empty(kodbk1) and empty(kodbk2)
			if !empty(dil) or !empty(kodv) or !empty(bud)
				=pe([����୨� �ଠ� ������])
			endif
			select dovad
			set order to kodbk
			mmres=seek(raznarax.kodbk1)
			set order to iadr
			select raznarax
			if not mmres
				=pe([�� �������� ��㭮� ]+raznarax.kodbk1)
			endif
	endcase
	if dovnor.kodnor#raznarax.kodnor
		=pe([���� ���ଠ��� � ��������� ���,KODNOR = ]+kodnor)
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
=fwrite(fileno,[     ����� #]+allt(str(recno()))+[ : ])
=fputs(fileno,mmess)
m_result=.f.