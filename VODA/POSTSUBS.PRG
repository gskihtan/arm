********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************
use subs  in 1
use subsn in 2 order u_pach
select subsn
set filter to not deleted()

******************** DEFINES *************************

define popup pop_pach from 2,2 to 22,24;
	shad scroll marg;
	prompt field [ ]+padr(subsn.npach,4)+[ � ]+dtoc(date)+[ ];
	title [ ��窠,��� ]
on select popup pop_pach do p_process

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([ ENTER ��४���� ���� � ESC ����� �],75);
			 color &m_mescolor
activ popup pop_pach
set filter to
select subsn
pack

***************** END OF PROGRAMM *********************
do p_clear
****************** PROCEDURES *************************

*********************
procedure p_process
*********************
m.npach=npach
if p_confirm(" ��७��� � ����祭� ��ᨤ�� ���� "+m.npach+[ ?],.t.)
	wait wind nowait [ ��������! ]
	select subsn
	mfilter=filter()
	set filter to
	set order to pach
	seek(m.npach)
	copy to $pach while npach==m.npach
	seek(m.npach)
	delete while npach==m.npach
	set order to u_pach
	set filter to &mfilter

	select subs
	append from $pach
	wait clear
	select subsn
endif
