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
	kodbk :r       :h= [��.��.]	,;
	lich  :r       :h= [���.]	,;
	adr = f_adrf() :h=[�������, ����],;
	pokn :r        :h=[���.���.],;
	pokp :r        :h=[���.���.] :v = f011(),;
	ov 			   :h=[��.����],;
	poks :r        :h=[���.���.],;
	datep          :h=[��� �����];
	window w title [ ��ॣ㢠��� �������� ���������� ��稫쭨��� ];
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
