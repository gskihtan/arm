****************************
*  ��� �����
****************************
clear
set date brit
set talk off
set safety off
set score off
SEt curs on
col1="w+/bg,gr+/b+"
col2="w+/b,r+/b"
set color to &col1
clear
@0,0 to 24,79 double
@0,30 say'� � �  ���������  '
save screen to ekra
dat1=date()
dat2=date()
clos all
SELE 1
USE post
sele 2
use dovad
index on kodbk to i2
sele 1
mdil=0
do while .t.
   @ 2,5 say '��� ����㯫��� �           �� '
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
           set filter to dat1<=date.and.date<=dat2
      case mn=2
           @ 5,0 clear
           @ 6,5 say '������ ����� �i�쭨�i ' get mdil pict '@z 99'
           read  
           set filter to mdil=substr(kodbk,1,1).and.dat1<=date.and.date<=dat2
   endcase
   sele 1
   go top
   index on str(substr(kodbk,1,1),2)+kodbk to i1 
*   brow
      *set relation to nm into mes
   SET RELATION TO kodbk inTO dovad additi
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
