*
do p_prepare
push key clear
*
* open tables
*
select 0
use dovvul order kodv
select 0
use raznar2
set relat to kodv into dovvul
index on dovvul.vul to raznar2 comp
*
define wind w from 2,2 to 22,41;
	panel color schem 10;
    title [ raznar2 - Разовў змўни по вулицях ]
@ 24,0 say padr([ INS Hовий │ ESC Вихўд │],75) color &m_mescolor
on key label INS do p_append
browse window w field;
	raznar2.kodv   :h=[Код вулицў],;
	dovvul.vul  :w=.f. :h=[Hазва вулицў];
    NOAPPEND NODELETE
*
pop key
select raznar2
set relat to kodv into dovvul
go top
delete for empty(dovvul.kodv)
pack
close data
do p_clear

*******************
proc p_append
*******************
select raznar2
append blank
show window raznar2 refresh
