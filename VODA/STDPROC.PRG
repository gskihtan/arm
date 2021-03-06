*////////////////////////////////////////////////////////////////////////*
*////////////////////         Sdt procs       ///////////////////////////*
*////////////////////////////////////////////////////////////////////////*

*******************
proc p_end
*******************
param mmode
mflag=mmode
deact menu

*******************
proc p_reindex
*******************
DEFINE WINDOW _0gp0sjf9u FROM 3, 6 TO 12,45 ;
                TITLE " ������������ " ;
                FLOAT NOCLOSE SHADOW DOUBLE ;
                COLOR SCHEME 5
ACTIVATE WINDOW _0gp0sjf9u

? [ LICH.DBF       - ]
use lich
delete tag all
index on kodbk+lich tag kodbk comp
index on kodm tag kodm comp
??[OK]

? [ LICHB.DBF      - ]
use lichb
delete tag all
index on kodv+padr(allt(bud),4)+lich tag kodbl comp
??[OK]

? [ DOVAD.DBF      - ]
use dovad
delete tag all
index on kodbk tag kodbk comp
index on val(subs(kodbk,2)) tag kod comp
index on fio tag fio comp
index on kodrax tag kodrax comp
index on kodv+padr(allt(bud),4)+padr(allt(kvar),3) tag adr comp
index on f_adr1([dovad]) tag adr1 comp
??[OK]

? [ DOVNOR.DBF     - ]
use dovnor
delete tag all
index on kodnor tag kodnor comp
index on naznor tag naznor comp
??[OK]

? [ DOVPIL.DBF     - ]
use dovpil
delete tag all
index on kodpil tag kodpil comp
??[OK]

? [ DOVVUL.DBF     - ]
use dovvul
delete tag all
index on kodv tag kodv comp
index on chrtran(allt(vul),[��㪥������䨢��஫�����������],;
                           [�����������򔈂������������������]);
                           tag vul comp
                
??[OK]

? [ DOVLICH.DBF    - ]
use dovlich
delete tag all
index on kodm tag kodm comp
index on marka tag marka comp
??[OK]

? [ NARAX.DBF      - ]
use narax
delete tag all
index on kodbk tag kodbk comp
index on kodnor tag kodnor comp
??[OK]

? [ NARAX2.DBF     - ]
use narax2
delete tag all
index on kodbk tag kodbk comp
??[OK]

? [ POST.DBF       - ]
use post
delete tag all
index on npach tag pach comp
index on kodbk tag kodbk comp
??[OK]

? [ POSTP.DBF      - ]
use postp
delete tag all
index on npach tag pach comp
index on npach tag u_pach unique comp
??[OK]

? [ SUBS.DBF       - ]
use subs
delete tag all
index on npach tag pach comp
index on kodbk tag kodbk comp
??[OK]

? [ SUBSN.DBF      - ]
use subsn
delete tag all
index on npach tag pach comp
index on npach tag u_pach comp unique
index on kodbk tag kodbk comp
??[OK]

? [ SUBSP.DBF      - ]
use subsp
delete tag all
index on npach tag pach comp
index on npach tag u_pach unique comp
??[OK]

? [ SUBSNP.DBF     - ]
use subsnp
delete tag all
index on npach tag pach comp
index on npach tag u_pach unique comp
??[OK]

? [ ZPILGA.DBF     - ]
use zpilga
delete tag all
index on kodbk tag kodbk comp
index on kodpil tag kodpil comp
??[OK]

? [ RAZNARAX.DBF     - ]
use raznarax
delete tag all
index on razindex() tag type comp
??[OK]

deact wind _0gp0sjf9u
RELEASE WINDOW _0gp0sjf9u
use

******************************
func allcdx
******************************
if 	   not file([lich.cdx]),;
	or not file([lichb.cdx]),;
	or not file([dovad.cdx]),;
	or not file([dovnor.cdx]),;
	or not file([dovpil.cdx]),;
	or not file([dovvul.cdx]),;
	or not file([dovlich.cdx]),;
	or not file([narax.cdx]),;
	or not file([post.cdx]),;
	or not file([postp.cdx]),;
	or not file([subs.cdx]),;
	or not file([subsn.cdx]),;
	or not file([subsp.cdx]),;
	or not file([subsnp.cdx]),;
	or not file([zpilga.cdx]),;
	or not file([raznarax.cdx])
		return .f.
endif

******************
proc p_open
******************
do while .t.
        mfname=getfile("dbf","�������� 䠩�")
        if empty(mfname)
                exit
        endif
        use (mfname)
        brow normal
        pack
        use
enddo

*******************
proc p_scr
*******************
set color to
clear
*@ 0,0,24,79 box replicate([�],9)
@ 17,25,20,55 box [�ͻ���Ⱥ ]
@ 18,27 say [      ��� ���������]
@ 19,27 say [    H � � � � � � � �]
@ 24,0 say padr([ Alt+X ����� � FoxPro � Alt+Q ����� � �� �],75) color &m_mescolor
save screen to m_scr
set color to

*******************
proc p_prepare
*******************
on key
_m_correct=.f.
save all like _m_* to setup
m_pad=pad()
close data
set color to

*******************
proc p_clear
*******************
_m_correct=.t.
save all like _m_* to setup
on key label ALT-X do p_end with [FOX]
on key label ALT-Q do p_end with [OS]
deact menu m_menu
close data

*******************
func p_confirm
*******************
param mess,mode
mr=1
mc=15
declare amess[5]
do while .t.
        pos=at([#],mess)
        if pos=0
                amess[mr]=mess
                if len(amess[mr])>mc
                        mc=len(amess[mr])
                endif
                exit
        endif
        amess[mr]=left(mess,pos-1)
        if len(amess[mr])>mc
                mc=len(amess[mr])
        endif
        mess=subs(mess,pos+1)
        mr=mr+1
enddo
sy=round(10-mr/2-2,0)
sx=round(40-mc/2-5,0)
ey=sy+mr+5
ex=sx+mc+10

define wind wconf from sy,sx to ey,ex;
        doub shad color schem 7
activ wind wconf
for i=1 to mr
        @ i,int((ex-sx-len(amess[i]))/2) say amess[i]
endfor

@ mr+2,int((ex-sx)/4-3) say '[ ��� ]'
@ mr+2,int((ex-sx)/4*3-3) say '[ H� ]'

msel=1
@ mr+2,int((ex-sx)/4-2)-1 GET msel PICTURE '@*IT ';
        SIZE 1,7 VALID f0001(.t.)
@ mr+2,int((ex-sx)/4*3-2)-1 GET msel PICTURE '@*IT ';
        SIZE 1,6 VALID f0001(.f.)

mret=.f.
if mode
        READ CYCLE MODAL OBJECT 1
else
        READ CYCLE MODAL OBJECT 2
endif

rele wind wconf
return mret

func f0001
param mparam
mret=mparam

********************
func f_adr
********************
return padr(dovvul.vul,11)+padl(dovad.bud,5)+padl(dovad.kvar,4)

********************
func f_adrf
********************
return padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+;
       iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[])

********************
func f_adro
********************
return allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+;
       iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[])

********************
func f_adr1
********************
parameter malias
if malias==[MEMORY]
	malias=[m]
endif
mcomm=[return ]+malias+[.kodv+padr(allt(]+malias+[.bud),4)]
&mcomm

*****************
proc p_poshuk
*****************
on key label f1
do poshuk
if m_result
        m.kodbk=m_kodbk
endif
on key label f1 do p_poshuk
return

********************
func razindex
********************
if not empty(dil)
	return [0]
endif
if not empty(kodv) 
	return [1]
endif
if not empty(kodbk1) and not empty(kodbk2)
	return [2]
endif
if not empty(kodbk1) and empty(kodbk2)
	return [3]
endif
     
*******************************
proc def_popdir
*******************************
mcntdir=adir(a_dir,[arhiv\????],[D])
=asort(a_dir)
for i=1 to mcntdir
	if inlist(a_dir[i,1],[.],[..])
		loop
	endif
	mdir=mdir+1
	define bar mdir of pop_dir prom [����� �� ]+a_dir[i,1]+[ ���]
endfor

*/////////////////////////////////////////////////////////////////////////*
*/////////////////////         Printing        ///////////////////////////*
*/////////////////////////////////////////////////////////////////////////*

*******************************
proc p_print
*******************************
parameter frxname
push key
on key
DEFINE WINDOW wprint ;
		FROM 2,2 TO 12,56 ;
		TITLE [ ��� ] ;
		FLOAT NOCLOSE SHADOW DOUBLE;
		COLOR n/w,n/g,n/w,n/w,n/w,n/g,,,n/w,w/g
ACTIVATE WINDOW wprint

report format &frxname to file $prn noconsole for not deleted()
mcntall=_pageno

fname=frxname+[.txt]
_mpageno=0

@ 0,2 SAY "������ ������� ������" COLOR n+/w
@ 8,1 SAY "H���㪮���� ������� : "  COLOR n+/w
@ 8,38 SAY "��쮣� : "+allt(str(mcntall)) COLOR n+/w
@ 5,2 SAY "����"  COLOR n+/w
@ 1,40 SAY "[ ������ ]"
@ 2,40 SAY "[ ��࠭   ]"
@ 3,40 SAY "[ ����    ]"
@ 5,40 SAY "[ �����   ]"
@ 1,1 TO 4,37 COLOR n+/w
@ 7,1 SAY "�������� �����      :" COLOR n+/w
@ 6,0 TO 6,52 COLOR n+/w

@ 2,3 GET _m_printer ;
	PICT '@*RVN ��� �����쪨� ᨬ�����;������ "��������"->"����IiIi"' ;
	SIZE 1,33,0 VALID fv_setup()

@ 1,40 get ms_prn pict [@*I] size 1,11 defa 1 valid fv_prn()
@ 2,40 get ms_scr pict [@*I] size 1,11 defa 1 valid fv_scr()
@ 3,40 get ms_file pict [@*I] size 1,11 defa 1 valid fv_file()
@ 5,8 GET  fname DISABLE valid fv_fname() size 1,12
@ 5,40 get ms_exit pict [@*IT] size 1,11 defa 1
@ 7,24 GET m_count defa 1
@ 8,24 GET _mpageno WHEN .f. COLOR gr/w,gr/w

m_count=1
READ CYCLE MODAL OBJECT 3
RELEASE WINDOW wprint
pop key

*/////////////////////////
func fv_prn
*/////////////////////////
mrec=recno()
if _m_printer=1
	???CHR(0)+CHR(0)+CHR(0)
endif
wait wind nowait [ Printing... ]
for i=1 to m_count
	report format &frxname to print noeject noconsole for not deleted()
endfor
wait wind nowait [ ��⮢�! ]
if _m_printer=1
	???CHR(0)+CHR(0)+CHR(0)
endif
if mrec>0 and mrec<=recc()
	goto mrec
endif

*/////////////////////////
func fv_scr
*/////////////////////////
mrec=recno()
report format &frxname preview for not deleted()
if mrec>0 and mrec<=recc()
	goto mrec
endif

*/////////////////////////
func fv_file
*/////////////////////////
show get fname ENABLED

*/////////////////////////
func fv_fname
*/////////////////////////
mrec=recno()
if last()=13
	wait wind nowait [ Printing... ]
	report format &frxname to file &fname noconsole for not deleted()
	wait clear
	mcomm = [modi comm ]+fname+[ noedit]
	&mcomm
endif
show get fname DISABLED
if mrec>0 and mrec<=recc()
	goto mrec
endif

*/////////////////////////
func fv_setup
*/////////////////////////
save all like _m_* to setup

*/////////////////////////
func p_page
*/////////////////////////
_mpageno=_pageno
show get _mpageno
return []

*//////////////////////////
func ukr
*//////////////////////////
parameter str
if _m_printer=1
	return chrtran(str,;
	[�����������򔈂��������������������㪥������䨢��஫�����������],;
	[�����������򔈂��������������������㪥������䨢��஫�����������])
else
	return chrtran(str,[��������],[IiIi����])
endif

******************************
procedure p_date
******************************
DEFINE WINDOW wdate ;
		FROM INT((SROW()-5)/2),INT((SCOL()-48)/2) ;
		TO INT((SROW()-5)/2)+4,INT((SCOL()-48)/2)+47 ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		DOUBLE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wdate
@ 1,6 SAY "��� �஢������ ஡��" ;
	SIZE 1,21, 0
@ 1,29 GET _m_date
READ
RELE WIND wdate

do scrinit
?script(1235.26,3)
return


***********************************************************
*                      Speeling(nSumma)                   *
*                  �������� �㬬� �ய����                *
***********************************************************
FUNCTION Speeling
PARAMETER nSumma
PRIVATE cSumma
  * k - �������
  cSumma = TRANSFORM(M.nSumma,'9,9,,9,,,,,,9,9,,9,,,,,9,9,,9,,,,9,9,,9,,,.99')+'k'

  * t - �����; m - �������; M - ��������
  cSumma = STRTRAN(M.cSumma, ',,,,,,', 'eM')
  cSumma = STRTRAN(M.cSumma, ',,,,,',  'em')
  cSumma = STRTRAN(M.cSumma, ',,,,',   'et')

  * e - �������; d - ����⪨; c - �⭨
  cSumma = STRTRAN(M.cSumma, ',,,', 'e')
  cSumma = STRTRAN(M.cSumma, ',,',  'd')
  cSumma = STRTRAN(M.cSumma, ',',   'c')

  cSumma = STRTRAN(M.cSumma, '0c0d0et', '')
  cSumma = STRTRAN(M.cSumma, '0c0d0em', '')
  cSumma = STRTRAN(M.cSumma, '0c0d0eM', '')

  cSumma = STRTRAN(M.cSumma, '0c', '')
  cSumma = STRTRAN(M.cSumma, '1c', '�� ')
  cSumma = STRTRAN(M.cSumma, '2c', '����� ')
  cSumma = STRTRAN(M.cSumma, '3c', '���� ')
  cSumma = STRTRAN(M.cSumma, '4c', '����� ')
  cSumma = STRTRAN(M.cSumma, '5c', "�'���� ")
  cSumma = STRTRAN(M.cSumma, '6c', '������ ')
  cSumma = STRTRAN(M.cSumma, '7c', '����� ')
  cSumma = STRTRAN(M.cSumma, '8c', '������� ')
  cSumma = STRTRAN(M.cSumma, '9c', "���'���� ")

  cSumma = STRTRAN(M.cSumma, '1d0e', '������ ')
  cSumma = STRTRAN(M.cSumma, '1d1e', '���������� ')
  cSumma = STRTRAN(M.cSumma, '1d2e', '���������� ')
  cSumma = STRTRAN(M.cSumma, '1d3e', '�ਭ������ ')
  cSumma = STRTRAN(M.cSumma, '1d4e', '��ୠ����� ')
  cSumma = STRTRAN(M.cSumma, '1d5e', "�'�⭠����� ")
  cSumma = STRTRAN(M.cSumma, '1d6e', '���⭠����� ')
  cSumma = STRTRAN(M.cSumma, '1d7e', '���������� ')
  cSumma = STRTRAN(M.cSumma, '1d8e', '������������ ')
  cSumma = STRTRAN(M.cSumma, '1d9e', "���'�⭠����� ")

  cSumma = STRTRAN(M.cSumma, '0d', '')
  cSumma = STRTRAN(M.cSumma, '2d', '�������� ')
  cSumma = STRTRAN(M.cSumma, '3d', '�ਤ���� ')
  cSumma = STRTRAN(M.cSumma, '4d', '�ப ')
  cSumma = STRTRAN(M.cSumma, '5d', "�'��줥��� ")
  cSumma = STRTRAN(M.cSumma, '6d', '���⤥��� ')
  cSumma = STRTRAN(M.cSumma, '7d', '�������� ')
  cSumma = STRTRAN(M.cSumma, '8d', '���������� ')
  cSumma = STRTRAN(M.cSumma, '9d', "���'ﭮ�� ")

  cSumma = STRTRAN(M.cSumma, '0e', '')
  cSumma = STRTRAN(M.cSumma, '5e', "�'��� ")
  cSumma = STRTRAN(M.cSumma, '6e', '����� ')
  cSumma = STRTRAN(M.cSumma, '7e', '��� ')
  cSumma = STRTRAN(M.cSumma, '8e', '����� ')
  cSumma = STRTRAN(M.cSumma, '9e', "���'��� ")

  cSumma = STRTRAN(M.cSumma, '1e.', '���� �ਢ�� ')
  cSumma = STRTRAN(M.cSumma, '2e.', '��� �ਢ�� ')
  cSumma = STRTRAN(M.cSumma, '3e.', '�� �ਢ�� ')
  cSumma = STRTRAN(M.cSumma, '4e.', '��� �ਢ�� ')
  cSumma = STRTRAN(M.cSumma, '1et', '���� ���� ')
  cSumma = STRTRAN(M.cSumma, '2et', '��� ����� ')
  cSumma = STRTRAN(M.cSumma, '3et', '�� ����� ')
  cSumma = STRTRAN(M.cSumma, '4et', '��� ����� ')
  cSumma = STRTRAN(M.cSumma, '1em', '���� ���쩮� ')
  cSumma = STRTRAN(M.cSumma, '2em', '��� ���쩮�� ')
  cSumma = STRTRAN(M.cSumma, '3em', '�� ���쩮�� ')
  cSumma = STRTRAN(M.cSumma, '4em', '��� ���쩮�� ')
  cSumma = STRTRAN(M.cSumma, '1eM', '���� ������ ')
  cSumma = STRTRAN(M.cSumma, '2eM', '��� �����न ')
  cSumma = STRTRAN(M.cSumma, '3eM', '�� �����न ')
  cSumma = STRTRAN(M.cSumma, '4eM', '��� �����न ')

  cSumma = STRTRAN(M.cSumma, '11k', '11 �������')
  cSumma = STRTRAN(M.cSumma, '12k', '12 �������')
  cSumma = STRTRAN(M.cSumma, '13k', '13 �������')
  cSumma = STRTRAN(M.cSumma, '14k', '14 �������')
  cSumma = STRTRAN(M.cSumma, '1k', '1 �������')
  cSumma = STRTRAN(M.cSumma, '2k', '2 �������')
  cSumma = STRTRAN(M.cSumma, '3k', '3 �������')
  cSumma = STRTRAN(M.cSumma, '4k', '4 �������')

  cSumma = STRTRAN(M.cSumma, '.', '�ਢ��� ')
  cSumma = STRTRAN(M.cSumma, 't', '���� ')
  cSumma = STRTRAN(M.cSumma, 'm', '���쩮��� ')
  cSumma = STRTRAN(M.cSumma, 'M', '�������� ')
  cSumma = STRTRAN(M.cSumma, 'k', ' �������')
  m.cSumma=allt(IIF(M.nSumma < 10**12, M.cSumma, ALLTRIM(STR(M.nSumma,20,2))))
RETURN m.cSumma

***********************
proc p_calc
***********************
push key
on key
DEFINE WINDOW wcalc ;
		FROM INT((SROW()-5)/2),INT((SCOL()-36)/2) ;
		TO INT((SROW()-5)/2)+4,INT((SCOL()-36)/2)+35 ;
		TITLE " �������� " ;
		FLOAT NOCLOSE ;
		SHADOW NOMINIMIZE DOUBLE COLOR SCHEME 4
ACTIVATE WINDOW wcalc
@ 0,1 GET expr ;
	SIZE 3,32,0 ;
	DEFAULT [] VALID fv_calc()

READ CYCLE MODAL
RELEASE WINDOW wcalc
pop key
return 

*-----------------
proc fv_calc
*-----------------
on error flag=.t.
mcomm=[expr=allt(str(]+allt(expr)+[,15,4))]
flag=.f.
&mcomm
on error
if flag
	expr=[�������]
endif
show gets
keyb [{SHIFT+END}]

**************************
proc p_rcopy
**************************
parameter mparam
clear
cdate=dtoc(date())
rarname=patharh+[\]+subs(cdate,1,2)+subs(cdate,4,2)+subs(cdate,7,4)+[.rar]
if not file(rarname) or mparam
	?[�������� ���������� �����...]
	?
	set defa to ..
	! rar_dbf.bat
	set defa to voda
	if not file([..\voda_dbf.rar])
		?[�� ���� �⢮�� �����]
		wait
		return
	endif
	copy file ..\voda_dbf.rar to &rarname
	if not file(rarname)
		?[�� ���� ᪮��� �����]
		wait
		return
	endif
	?[����ࢭ� ����� �⢮७� : ]+rarname
	erase ..\voda_dbf.rar
	wait
endif

