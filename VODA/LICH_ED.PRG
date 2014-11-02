********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

select 0
use dovvul order kodv
select 0
use dovad order kodbk
set relat to kodv into dovvul
select 0
use lich order kodbk
set relat to kodbk into dovad
set filter to not empty(lich.ov)

******************** DEFINES *************************

define window w from 1,0 to 23,80 system color schem 8

************** BEGIN PROGRAMM ************************

set delete off
brow field;
	kodbk :r       :h= [Ос.рах.]	,;
	lich  :r       :h= [Лўч.]	,;
	adr = f_adrf() :h=[Прўзвище, адреса],;
	pokn :r        :h=[Поч.пок.],;
	pokp :r        :h=[Кўн.пок.] :v = f011(),;
	ov 			   :h=[Об.води],;
	poks :r        :h=[Сер.пок.],;
	datep          :h=[Дата вводу];
	window w title [ Корегування введених показникўв лўчильникўв ];
	nodelete noappend
	
pack
close data

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
proc f011
*****************
repl ov with pokp-pokn
