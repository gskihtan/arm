********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

	DEFINE WINDOW wper ;
		FROM INT((SROW()-12)/2),INT((SCOL()-51)/2) ;
		TO INT((SROW()-12)/2)+11,INT((SCOL()-51)/2)+50 ;
		TITLE " �����㭪� " ;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 8

define wind w from 2,1 to 20,78;
	panel color schem 10;
    title [ ���� ���� ]

define wind wnar2 from 2,2 to 20,78	system color schem 8

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([],75) color &m_mescolor
merr=[]

ACTIVATE WINDOW wper

@ 2,3 SAY "�� 直� ������ ஡�� �����㭮�"
@ 5,5 SAY "[ ����� ���� ����    ]"
@ 6,5 SAY "[ �஡�� �����㭮� ]"
@ 7,5 SAY "[ �����               ]"
@ 4,3 TO 8,29 COLOR W/BG    

@ 2,37 GET mdate SIZE 1,10 DEFAULT {  /  /  };
	VALID fv_date()	error merr
@ 5,5 get msel pict [@*I] defa 0 size 1,23 valid fv_norm()
@ 6,5 get msel pict [@*I] defa 0 size 1,23 valid fv_go()
@ 7,5 get msel pict [@*IT] defa 0 size 1,23

READ CYCLE NOLOCK
RELEASE WINDOW wper

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*********************
func fv_date
*********************
mcyear=subs(dtoc(mdate),7,4)
mnamea=[arhiv\]+mcyear+[\narax.dbf]
if not file(mnamea)
	merr = [ ���� 䠩�� - ]+mnamea
	return .f.
endif

mnamec=[arhiv\]+mcyear+[\dovnor.dbf]
if not file(mnamec)
	merr = [ ���� 䠩�� - ]+mnamec
	return .f.
endif

wait [ ��������! ] wind nowait

select 0
use (mnamea) alias arh order tm
mmis=subs(dtoc(mdate),4,2)
go top
mres=.f.
if recc()>12
	for i=1 to 12
		if mis==mmis
			mres=.t.
		endif
		skip
	endfor
endif

if not mres
	merr=[�� 楩 ������ � ������ ���� �����]
	close data
	return .f.
endif

go top
copy to $naraxp for mis==mmis
use

use (mnamec) alias newnorm order tm

select *,tvod as tvod1,tstok as tstok1;
	from newnorm into dbf $normp;
	where mis==mmis;
	order by kodnor

close data
wait clear

*********************
func fv_norm
*********************
select 0
use $normp alias norm

browse window w field;
	kodnor :w=.f. :h=[���],;
	naznor :w=.f. :h=[H���� ��ନ],;
	tvod   :w=.f. :h=[�.�� ����],;
	tstok  :w=.f. :h=[�.�� �⮪�],;
	tvod1         :h=[���� �.�� �.],;
	tstok1        :h=[���� �.�� ��.];
    NOAPPEND NODELETE

close data

*********************
func fv_go
*********************
wait wind nowait [ ������... ]

select 0
use narax2

select 0
use $normp alias dovnor
index on kodnor to i comp

select 0
use $naraxp alias arh
set relat to kodn into dovnor

go top
scan for sv>0
	msvd=sv/dovnor.tvod*dovnor.tvod1-sv
	mstd=st/dovnor.tstok*dovnor.tstok1-st
	
	if pil>0
        msvd = msvd/kprop*(kprop*100-pil)/100
        mstd = mstd/kprop*(kprop*100-pil)/100
    endif

    msvd = round(msvd,2)
    mstd = round(mstd,2)

	if msvd#0 or mstd#0
		insert into narax2 (kodbk,ovd,ostd,svd,std,memo);
		values (arh.kodbk,0,0,msvd,mstd,[�����㭮� �� ]+dtoc(mdate))
	endif
	select arh
endscan
wait clear

select narax2
go bott
brow wind wnar2 field;
		kodbk  :r    :h=[��.��],;
		ovd    :r    :h=[��.����],;  
		ostd   :r    :h=[��.��],;
		svd    :r    :h=[S �� ����],;
		std    :r    :h=[S �� ��],;
		memo   :r    :h=[�����⪠];
		noappend nodelete noedit;
		title [�����㭮�]
close data

