*set talk off
*set near on
*close all
*clear


********************* SETUP **************************

do p_prepare
*m.sborg=0.00

****************** OPEN DATABASE *********************


******************** DEFINES *************************

*DEFINE WINDOW wb ;
*		FROM INT((SROW()-20)/2),INT((SCOL()-64)/2) ;
*		TO INT((SROW()-14)/2)+12,INT((SCOL()-64)/2)+63 ;
*		TITLE " Друк заборговагостў абонентўв " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		DOUBLE ;
		COLOR SCHEME 5

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ Esc Вихўд │],75) color &m_mescolor
*activ wind wb

****************** PROCEDURES *************************


sele 1
use narax 
index on kodbk to s_i1 comp

sele 2
use dovad 
index on kodbk+kodv to s_i2 comp
sele 1
set relat to kodbk into dovad 

sele 3
use dovvul 
index on kodv to s_i3 comp
sele 2
set relat to kodv into dovvul addit
sele 1
i=.t.
do while i
 e1=[       ]
 @ 10,10 say [ Hижня межа] get e1 
 read
if val(e1)#0
e2=[       ]

* @ 12,10 say [ Кўлькўсть] get e2 
 *read
 *if lastk()=27
 * e2=[       ]

  @ 12,10 say [Верхня межа] get e2
  read
  um=[while kodbk<=e2]
 seek e1

*else
 *um=[next val(e2)]
*endif
*seek e1
***************** END OF PROGRAMM *********************
do p_clear
******************
*rele wind wb

@12,10 say 'Видавати вiдомiсть на '
     @12,35 prompt 'ПРIHТЕРI '
     @12,45 PROMPT ' ЕКРАHI  '
*     @12,55 prompt ' У ФАЙЛ  '
               menu TO PP1
 DO CASE
       CASE PP1=1
        DO WHILE  sys(13)='OFFLINE'
         WAIT'      Включить прiнтер и натиснiть <ENTER>'
        ENDDO
        report form poper &um NOEJECT to print  
       CASE PP1=2
        report form poper &um prev
 *  CASE PP1=3
  *      set device to screen
   *     report form poper &um TO FILE poper.TXT
    *    MODI COMM poper.TXT
     *   clear     
  endcase
clear
else
 i=.f.
endif
enddo
close all
clear
erase s_i1.idx
erase s_i2.idx
erase s_i3.idx
erase s_i21.idx
use
*clos all
*clear
*do p_clear
*retu
wait clear


