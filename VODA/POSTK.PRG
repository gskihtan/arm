********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovad  in 3 order kodbk
use dovvul in 4 order kodv
use post   in 5 order pach
select dovad
set relat to kodv into dovvul

******************** DEFINES *************************

define wind w from 2,2 to 20,77;
	panel shadow color schem 10

************** BEGIN PROGRAMM ************************

set defa to kasa
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
set relat to str(nra,7) into dovad

flag_zap=.f.

@ 24,0 say padr([F1 Пошук│F2 Контр.сума│ESC Вихўд│],75) color &m_mescolor

do p_onkey
browse window w field;
        nra     :h=[Ос.рах],;
        suma    :h=[Сума],;
        adr	    = f_adrf() :h=[Прўзвище,адреса],;
        datao   :h=[Дата];
        title mfname
do p_offkey
use
if flag_zap
	mcomm=[erase ]+mfname
	&mcomm
endif
return

*****************
proc p_onkey
*****************
on key label F1 do p_posh
on key label F2 do p_save

*****************
proc p_offkey
*****************
on key label F1 do p_posh
on key label F2 do p_save

*****************
proc p_posh
*****************
do p_offkey
do ..\poshuk
if m_result
	wait [ Особовий рахунок - ] + m_kodbk wind time 7 nowait 
endif
do p_onkey

*****************
proc p_save
*****************
do p_offkey

wait wind nowait [ Хвилинку! ]
mrec=recno()
go top
scan for not deleted()
	if str(nra,7)#dovad.kodbk
		wait wind nowait [ Рахунок не знайдено ]
		do p_onkey
		return
	endif
endscan	

count to m.cnt for not deleted()
sum suma to m.sum for not deleted()
goto mrec
wait clear

mmess=[     Кўлькўсть - ]+allt(str(m.cnt))+;
      [     Сума - ]+allt(str(m.sum,9,2))+[     ##]+;
      [Записати пачку ?]
	
if p_confirm(mmess,.t.)
	define wind wposh from 5,40 to 9,64;
		doub shad color n/w,w+/b
	
	activ wind wposh
	@ 1,2 say [Hомер пачки] get m.npach defa space(4);
		valid len(allt(m.npach))=4;
		and not seek(m.npach,5);
		error [ Hевўрне значення або пачка вже ўснуї ]
	read modal
	rele wind wposh
	
	if last()#27
		wait wind nowait [ Хвилинку! ]
        go top
        scan for not deleted()
               insert into post (npach,kodbk,suma,date);
               		values (allt(m.npach),str(postp.nra,7),;
               		postp.suma,postp.datao)
               delete
        endscan
	    pack
	    wait clear
	    flag_zap=.t.
	endif
endif
do p_onkey
return
