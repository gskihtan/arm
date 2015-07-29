********************* SETUP **************************

do p_prepare
m.date = date()
****************** OPEN DATABASE *********************

use dovad  in 3 order kodbk
use dovvul in 4 order kodv
use subsn  in 5 order pach
select dovad
set relat to kodv into dovvul
select 0
use narax order kodbk

******************** DEFINES *************************

define wind w from 1,0 to 23,79;
	panel color schem 10

************** BEGIN PROGRAMM ************************

set defa to subs
do while .t.
		@ 24,0 say padr([ESC Вихўд│],75) color &m_mescolor
        mfname=getfile("dbf","Виберўть файл")
        if empty(mfname)
                exit
        endif
        do p_process
enddo
set defa to ..

***************** END OF PROGRAMM *********************
do p_clear
return

****************** PROCEDURES *************************
********************
proc p_process
********************
select 0
use (mfname) alias postp
set relat to alltrim(RASH) into dovad, alltrim(RASH) into narax

flag_zap=.f.

@ 24,0 say padr([F1 Пошук│F2 Контр.сума│ESC Вихўд│],75) color &m_mescolor

push key
on key
on key label F1 do p_posh
on key label F2 do p_save
browse window w field;
        RASH    :h=[Ос.рах],;
        Summa     :h=[Субсидўя],;
        FIO	    = f_adrf() :h=[Прўзвище,адреса],;
        fio,name_v,Bld,Flat;
        title mfname
pop key
use
if flag_zap
	mcomm=[erase ]+mfname
	&mcomm
endif
return

*****************
proc p_posh
*****************
push key
on key
do ..\poshuk
if m_result
	wait [ Особовий рахунок - ] + m_kodbk wind time 14 nowait 
endif
pop key

*****************
proc p_save
*****************
push key
on key

wait wind nowait [ Хвилинку! ]
mrec=recno()
go top
scan for not deleted()
	if empty(narax.kodbk)
		wait wind nowait [ Рахунок не знайдено ]
		pop key
		return
	endif
endscan	

count to m.cnt for not deleted()
sum summa to m.sum for not deleted()
goto mrec
wait clear

mmess=[     Кўлькўсть - ]+allt(str(m.cnt))+;
      [     Сума - ]+allt(str(m.sum,13,2))+[     ##]+;
      [Записати пачку ?]
	
if p_confirm(mmess,.t.)
	define wind wposh from 5,40 to 11,70;
		doub shad color n/w,w+/b
	
	activ wind wposh
	@ 1,2 say [Hомер пачки] get m.npach defa space(4);
		valid len(allt(m.npach))=4;
		and not seek(m.npach,5);
		error [ Hевўрне значення або пачка вже ўснуї ]
	@ 3,2 say [Дата внес. ] get m.date
	read modal
	rele wind wposh
	
	if last()#27
		wait wind nowait [ Хвилинку! ]
        go top
        select postp
        scan for not deleted()
               insert into subsn (npach,kodbk,suma,date);
               		values (allt(m.npach),postp.RASH,;
               		postp.Summa,m.date)
               delete
        endscan
	    pack
	    wait clear
	    flag_zap=.t.
	endif
endif
pop key
return
