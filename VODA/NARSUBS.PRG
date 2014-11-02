********************* SETUP **************************

do p_prepare
private tabname

****************** OPEN DATABASE *********************

******************** DEFINES *************************

DEFINE WINDOW w ;
		FROM INT((SROW()-11)/2),INT((SCOL()-62)/2) ;
		TO INT((SROW()-11)/2)+11,INT((SCOL()-62)/2)+61 ;
		TITLE " Hарахувуння для вўддўлу субсидўй " ;
		FOOTER " <ESC> - вихўд " ;
		FLOAT NOCLOSE SHADOW DOUBLE COLOR SCHEME 5

************** BEGIN PROGRAMM ************************
arhname=[]
tabname=[]

ACTIVATE WINDOW w 
@ 1,4 SAY "За який перўод" COLOR W/RB    
@ 4,7 SAY "Рўк"
@ 4,18 SAY "Мўсяць"
@ 2,3 TO 6,39 COLOR W/RB    

@ 4,11 GET myear SIZE 1,4 DEFAULT " " ;
	PICTURE "9999"
@ 3,25 GET mmonth ;
	PICTURE "@^ Сўчень;Лютий;Березень;Квўтень;Травень;Червень;Липень;Серпень;Вересень;Жовтень;Листопад;Грудень" ;
	SIZE 3,12 DEFAULT month(date()) ;
	COLOR SCHEME 5, 6
@ 7,4 GET msarh PICTURE "@*C Взяти данў з архўву" SIZE 1,9 DEFAULT 0
@ 8,4 GET msel PICTURE "@*HN Сформувати таблицю" ;
	SIZE 1,20,1 DEFAULT 1;
	WHEN exist_file() VALID cr_table()

@ 2,44 GET msel PICTURE "@*HN Browse" ;
	SIZE 1,13,1 DEFAULT 1 DISABLE VALID p_brow()
@ 4,44 GET msel PICTURE "@*HN Copy to a:\" SIZE 1,13,1 ;
	DEFAULT 1 DISABLE VALID p_copy()
@ 6,44 GET msel PICTURE "@*HNT Вихўд" SIZE 1,13,1 DEFAULT 1

READ CYCLE MODAL
RELEASE WINDOW w
close data

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
func exist_file
*********************
if msarh=1
	arhname=[ARHIV\]+myear+[\NARAX.DBF]
else 
	arhname=[NARAX.DBF]
endif
if not file(arhname)
	wait wind nowait [ Hе ўснуї архўву за ]+myear+[ рўк ]+arhname
	return .f.
else 
	return .t.
endif

*********************
func cr_table
*********************
select 0
mt1=allt(str(mmonth))
if len(mt1)=1
	mt1=[0]+mt1
endif
select 1
tabname=[OUT\V_]+mt1+myear+[.DBF]
wait wind nowait [ Формуїться таблиця ]+tabname+[... ]
create table (tabname) ( kodbk c(7),;
						 fio   c(25),;
						 lich  c(2),;
						 adr   c(30),;
						 kodnor c(2),;
                         kanal n(1),;
						 kprop n(2),;
         				 pil   n(3),;
         				 narax n(9,2),;
          				 narax_norm n(9,2),;
    					 saldn_fakt n(9,2),;	     
    					 saldn_12_06 n(9,2) )

select 0
use dovnor order kodnor
select 0
use dovvul order kodv
select 0
use dovad order kodbk
set relat to kodv into dovvul
select 0

if msarh=1
	use (arhname) order tm alias arhiv
	umova=[val(mis)=mmonth]
else 
	use (arhname) order kodbk alias arhiv
	umova = [.t.]
endif

set relat to kodbk into dovad, kodnor into dovnor

scan for &umova
	select 1
	append blank
	repl kodbk with arhiv.kodbk
	if msarh=1 
		repl fio with arhiv.fio
	else
		repl fio with dovad.fio
	endif
	repl adr with allt(dovvul.vul)+[ ]+allt(dovad.bud)+[/]+allt(dovad.kvar),;
		 kprop with arhiv.kprop,;
		 kodnor with arhiv.kodnor,;
		 kanal with arhiv.kanal,;
         pil with arhiv.pil,;
         narax with arhiv.svp+arhiv.stp
		 
	msv = dovnor.ov*kprop*dovnor.tvod
	mst = kanal*dovnor.ov*kprop*dovnor.tstok
	repl narax_norm with round((msv+mst)/kprop*(kprop*100-pil)/100,2)
*    repl saldn_fakt with saldn
	select arhiv
endscan
select 1
wait clear
show object 5 enable
*show object 6 enable
close data

* Added later
select 0
use lichb order kodbl
select 0
use dovad order kodbk
set relat to f_adr1([dovad]) into lichb
select 0
use lich order kodbk
select 0
use (tabname) alias tab
set relat to kodbk into lich,kodbk into dovad
repl all lich with;
 iif(not empty(lich.kodbk) or not empty(lichb.kodv),[ЛЛ],[])
close data
						 
*********************
func p_brow
*********************
use (tabname)
brow field kodbk  :h=[Ос.рах],;
		   fio    :h=[Прўзвище],;
		   lich   :h=[],;
		   adr    :h=[Адреса],;
		   kodnor :h=[Код норми],;
		   kanal  :h=[Каналўзацўя],;
		   kprop  :h=[к.проп],;
           pil    :h=[% пўльги],;
    	   narax  :h=[Hарах.fact],;
    	   narax_norm  :h=[Hарах.norm],;
           saldn_fakt   :h=[борг на поч.м-ця],;
           saldn_12_06  :h=[борг на 12.06];
		   NOMODI NOAPPEND NODELETE NORMAL
use 
