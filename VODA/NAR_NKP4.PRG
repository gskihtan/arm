close all
clear all
USE D:\ARM\VODA\NARAX.DBF
copy fields kodbk to nkp_4
clos all
SELE 1
create table D:\ARM\VODA\NKP4.dbf (kodbk C(7),kodn C(2),kprop N(2),kanal N(1,0),ov N(9,2),ost N(9,2),ovd N(9,2),ostd N(9,2),kvar C(3),derg C(1))
APPEND FROM nkp_4.DBF
CLOS ALL

sele 1
*����� � NKP4 �ਧ���� ���/�ਢ�� � � ��*
USE D:\ARM\VODA\NKP4.DBF
sele 2
use D:\ARM\VODA\dovad.dbf
index on kodbk to r1
sele 1
set relat to kodbk into dovad
repl all derg with dovad.derg
repl all kvar with dovad.kvar
*browse

clos all

sele 1
*****����� � NKP4 ����㢠��*
USE D:\ARM\VODA\NKP4.DBF
sele 2
use D:\ARM\VODA\narax.dbf
index on kodbk to r1
sele 1
set relat to kodbk into narax
repl all kodn with narax.kodn
repl all kprop with narax.kprop
repl all kanal with narax.kanal
repl all ov with narax.ov
repl all ost with narax.ost
repl all ovd with narax.ovd
repl all ostd with narax.ostd
copy to g_nkp4
*browse
clos all

sele 3
*****�����쭠 �-�� ��/ᥪ�� ��-� � ������������ g_nkp42 *
use g_nkp4
set filter to kanal = 1
copy to g_nkp41
use
use g_nkp41
set filter to kvar = '1  ' or kvar = '   '
*set filter to kvar = '   '
copy to g_nkp42
use
use g_nkp42
browse
list
**** 1 *******
clos all

sele 4
*****�-�� ����-�(��) �ਢ.ᥪ�.�� �⮪�� � nkp_w*
use nkp4
set filter to derg ='W'and kanal = 1
*browse
copy to nkp_w1
clos all
sele 5
use nkp_w1
*set filter to kvar = '   '  
set filter to kvar = '1  ' or kvar = '   '
copy to nkp_w
clos all
sele 6
use nkp_w
browse
list
clos all

sele 7
*****�-�� ����-� �ਢ.ᥪ�.�� �⮪�� � ���. � nkp_w2*
use nkp_w
set filter to kvar = '   '
copy to nkp_ww
clos all
use nkp_ww
set filter to kodn = '08' or kodn ='11'
*browse
copy to nkp_w2
clos all
use nkp_w2
browse
list
clos all

sele 8
*****����㢠��� �ਢ.ᥪ�. � g1_nkp4*
use g_nkp4
set filter to derg='W'
sum (ov+ovd) to s1
? s1
sum (ost+ostd) to s2
? s2
sum kprop to s5
? s5
browse
list
copy to g1_nkp4
clos all

sele 9
*****�������� �ਢ.��.� g2_nkp4*
use g1_nkp4
*set filter to kvar ='   ' 
set filter to kvar = '1  ' or kvar = '   '
copy to  g2_nkp4
clos all
use g2_nkp4
browse
list
clos all

sele 10
*****�������� �ਢ.��.� ���. � g3_nkp4, ॠ�������*
use g2_nkp4
set filter to kvar = '   '
copy to g2_nkp444
clos all
use g2_nkp444
set filter to kodn ='08' or kodn ='11'
*browse
sum (ov+ovd) to s3
? s3
sum (ost+ostd) to s4
? s4
sum kprop to s6
? s6
copy to g3_nkp4
clos all
use g3_nkp4
browse
list
clos all

sele 11
*****�������� �ਢ.��.� ���. � g3_nkp4*
use g3_nkp4
sum kprop to s
? s 
list
clos all

sele 12
*****�����쭠 �������� �㤨���� � g4_nkp4*
use g_nkp4
*browse
set filter to kvar = '1  ' or kvar = '   '
copy to g4_nkp4
use
sele 13
use g4_nkp4
browse
list
clos all

sele 14
*****�����쭠 �-�� ��. �ਢ/ᥪ�.*
use g4_nkp4
set filter to derg = 'W'
copy to g6_nkp4
clos all
sele 15
use g6_nkp4
browse
list 
clos all

sele 16
*****�����쭠 �-�� ��-� � �������.*
use g4_nkp4
set filter to kanal = 1
copy to g5_nkp4
use
use g5_nkp4
list
clos all


*sele 4
*use nkp_w
*list
*clos all
*sum kprop to s
*? s
*browse
*clos all
*use PIL_MOY
*copy fields cdpr,idcode,fio,PROS,rs,yearin,monthin,lgcode,DATA1,DATA2,lgkol,LGKAT,lgprc,summ,fact,tarif,flag to woda_pil1
*clos all

