********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

select 0
use dovdil 
index on kodd to i1 comp
select 0
use dovkon
index on kodd to i2 comp
select 0
use dovvul order kodv

select dovdil
set relat to kodd into dovkon, kodv into dovvul

******************** DEFINES *************************

define wind w from 2,1 to 22,78;
        panel color schem 10;
    title [ Dovdil - Довўдник дўльниць ]

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([F12 Друк│],75) color &m_mescolor

on key label F12 do p_printex

browse window w field;
        kodd       :h=[дил.],;
        dovvul.vul :h=[вулиця],;
        bud        :5 :h=[буд.] ,;
        dovkon.name :h=[контролер];
    NOAPPEND NODELETE NOEDIT

on key label F12

close data

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

************************
procedure  p_printex
************************
push key clear
select;
	dovdil.kodd,;
	dovdil.kodv,;
	dovvul.vul,;
	dovdil.bud,;
	dovkon.name;
from dovdil,dovvul,dovkon;
into dbf out;
where dovdil.kodv == dovvul.kodv and dovdil.kodd = dovkon.kodd;
order by dovdil.kodd, dovvul.vul, dovdil.bud
	
do p_print with [dovdil]
go top
pop key

