****************************
*  ��� ����� /� ������� �����/
****************************
set talk off
set near on
close all
clear
@0,0 to 24,79 double
@0,30 say'� � �  ���������  '
save screen to ekra
dat1=date()
dat2=date()
*clos all
SELE 1
USE post
index on kodbk to i_1
sele 2
use dovad
index on kodbk to i_2
sele 1
set rela to kodBK into DOVAD
i=.t.
do while i
 e1=[       ]
 @ 10,10 say [ H���� ����] get e1 
 read
if val(e1)#0
  e2=[       ]
  @ 12,10 say [����� ����] get e2
  read
  um=[while kodbk<=e2]
seek e1
@12,10 say '������� �i���i��� �� '
     @12,35 prompt '��IH���I '
     @12,45 PROMPT ' ����HI  '
               menu TO PP1
 DO CASE
       CASE PP1=1
        DO WHILE  sys(13)='OFFLINE'
         WAIT'      ������� ��i��� � ����i�� <ENTER>'
        ENDDO
        report form r_dopl1 &um NOEJECT to print  
       CASE PP1=2
        report form r_dopl1 &um prev
  endcase
clear
else
 i=.f.
endif
enddo
close all
clear
*erase s_i1.idx
*erase s_i2.idx
*erase s_i3.idx
retu

*******mdil=0

do while .t.
   @ 2,5 say '��� ����㯫��� �          �� '
   @ 2,23 get dat1
   @ 2,36 get dat2 
   read
   if lastkey()=27
      exit
   endif
   @ 5,5 prom "�� ��i� �i�쭨���     " 
   @ 6,5 prom "�� ������i� �i�쭨�i" 
   menu to mn
   do case
      case mn=1
           set filter to dat1<=datp.and.datp<=dat2
      case mn=2
           @ 5,0 clear
           @ 6,5 say '������ ����� �i�쭨�i ' get mdil pict '@z 99'
           read  
           set filter to mdil=dil.and.dat1<=datp.and.datp<=dat2
   endcase
   sele 1
   go top
   index on str(dil,2)+rax to i1 
*   brow
      *set relation to nm into mes
   SET RELATION TO rax inTO dovad additi
   @10,10 say '������� �i���i��� �� '
   @10,35 prompt '��IH���I '
   @10,45 PROMPT ' ����HI  '
   MENU TO PP1
   DO CASE
      CASE PP1=1
           DO WHILE  sys(13)='OFFLINE'
              WAIT'      ������� ��i��� � ����i�� <ENTER>'
           ENDDO
           report form r_dopl to print  
      CASE PP1=2
           set device to screen
           report form r_dopl preview
           clear
   endcase
enddo
SET DEVI TO SCREEN
close database
clear
return
