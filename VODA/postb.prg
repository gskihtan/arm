********************* SETUP **************************
parameter mbase
do p_prepare

do case
        case mbase==[POST]
                use post  in 1 order pach alias postp
                mv_title = [ ����� : ।��㢠��� ���� (F12 - ���)]
        case mbase==[SUBS]
                use subs in 1 order pach alias postp
                mv_title = [ ��ᨤ�� : ।��㢠��� ���� (F12 - ���)]
        case mbase==[SUBSN]
                use subsn in 1 order pach alias postp
                mv_title = [ ��ᨤ�� (������祭�) : ।��㢠��� ���� (F12 - ���)]
        other
                do p_clear
                return
endcase

****************** OPEN DATABASE *********************

use dovad in 3 order kodbk
use dovvul in 4 order kodv
select postp
set relat to kodbk into dovad
select dovad 
set relat to kodv into dovvul
select postp

******************** DEFINES *************************

define wind w from 2,2 to 20,75;
	panel shadow color schem 10;
	title mv_title zoom float grow

************** BEGIN PROGRAMM ************************

do p_onkey
@ 24,0 say padr([F1 ���㪳F2 �㬠�F3 ��䮳F8 ����./����.�]+;
				[F6 ��३���.�F7�ESC ������],75) color &m_mescolor

browse window w field;
        kodbk   :h=[��.��] :r,;
        npach   :h=[��窠],;
        suma    :h=[�㬠],;
        date    :h=[���],;
        adr	    = f_adrf() :h=[�������,����]
do p_offkey

wait wind nowait [ ��������! ]
delete for kodbk#dovad.kodbk
pack
wait clear


***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
proc p_onkey
*****************
on key label F1 do p_posh
on key label F2 do p_save
on key label F8 do p_del
on key label F6 do p_ren
on key label F3 do p_info
on key label F12 do post_prn
on key label F7 do p_inf2

*****************
proc p_offkey
*****************
on key label F1
on key label F2
on key label F8
on key label F6
on key label F3
on key label F12
on key label F7

*****************
proc p_save
*****************
if recc()=0
	wait [���� ��஦��] wind nowait
	return
endif
do p_offkey
wait wind nowait [ ��������! ]
mrec=recno()
m.npach=npach
count to m.cnt for npach==m.npach and not deleted()
sum to m.sum for npach==m.npach and not deleted()
if mrec>0 and mrec<recc()
	goto mrec
endif
wait clear
wait [��窠 - ]+m.npach+;
	 [     �������� - ]+allt(str(m.cnt))+;
 	 [     �㬠 - ]+allt(str(m.sum,10,2));
	wind nowait
do p_onkey

*****************
proc p_del
*****************
if recc()=0
	wait [���� ��஦��] wind nowait
	return
endif
do p_offkey
m.npach=npach
if not deleted()
	mmess=[   ����� ���� ]+m.npach+[ ?   ]
	mcomm=[delete for npach==m.npach]
else 
	mmess=[   �������� ���� ]+m.npach+[ ?   ]
	mcomm=[recall for npach==m.npach]
endif
if p_confirm(mmess,.t.)
	wait wind nowait [ ��������! ]
	mrec=recno()
	&mcomm
	goto mrec
	wait clear
endif
do p_onkey

*****************
proc p_ren
*****************
if recc()=0
	wait [���� ��஦��] wind nowait
	return
endif
do p_offkey
define wind wren from 5,30 to 13,68;
	doub shad color n/w,w+/b
activ wind wren
m.npach=npach
m.sum=0.00

@ 1,2 say [��窠 ]+npach
@ 3,2 say [������ �� ��� ] get m.sum defa m.npach
@ 5,2 say [��३���㢠� ��] get m.npach2 defa m.npach;
	size 1,4;
	valid len(allt(m.npach2))=4 and not seek(m.npach2);	
	error [ H���୥ ���祭�� ��� ��窠 ��� ���� ]
read modal
rele wind wren

if last()=27
	do p_onkey
	return
endif
wait wind nowait [ ��������! ]
mtsum=0.00
mflagren=.f.
set order to
go top
scan for npach==m.npach
	if not mflagren
		mtsum=mtsum+suma
		if mtsum>=m.sum
			mflagren=.t.
			ma_kod=kodbk
			ma_dat=date
			ma_sum=mtsum-m.sum
			repl suma with suma-ma_sum
			loop
		endif
	endif
	if mflagren
		repl npach with m.npach2
	endif
endscan
append blank
repl kodbk with ma_kod
repl suma with ma_sum
repl date with ma_dat
repl npach with m.npach2
set order to pach
seek m.npach

wait clear
do p_onkey

*****************
proc p_posh
*****************
if recc()=0
	wait [���� ��஦��] wind nowait
	return
endif
do p_offkey
define wind wposh from 5,40 to 9,64;
	doub shad color n/w,w+/b
activ wind wposh
@ 1,2 say [����� ����] get m.npach2 defa space(4);
	valid not empty(m.npach2);
	error [ H���୥ ���祭�� ]
read modal
if last()#27
	if not seek(m.npach2)
		wait wind nowait [ ���� �� �������� ]
	endif
endif
rele wind wposh
do p_onkey

****************
proc p_info
****************
if recc()=0
	wait [���� ��஦��] wind nowait
	return
endif
do p_offkey
wait wind nowait [ ��������! ]
select postp
mrec=recn()
total on npach to $pach
select 0
use $pach alias qwerty
calc sum(suma) to m.sum
wait clear

define popup pop_pach from 1,12 to 22,46;
	shad scroll marg;
	prompt field [ ]+padr(npach,4)+[ � ]+str(suma,10,2)+[ � ]+dtoc(date)+[ ];
	title [ ��窠,�㬠,��� ];
	foot [����� ]+str(m.sum,10,2);
	
on select popup pop_pach deact popup
activ popup pop_pach
m.npach=npach
use
select postp
if last()#27
	seek(m.npach)
else
	if mrec>0 and mrec<=recc()
		goto mrec
	endif
endif
	
select postp
do p_onkey	

****************
proc p_inf2
****************
if recc()=0
	wait [���� ��஦��] wind nowait
	return
endif
do p_offkey
wait wind nowait [ ��������! ]
select postp
*
select subs(postp.npach,4,1) as group, sum(postp.suma) as suma from postp into dbf $inf2 group by 1 order by 1
*
wait clear
brow normal title [�㬠] color scheme 7
use
select postp
go top
do p_onkey	
