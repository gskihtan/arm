********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

	DEFINE WINDOW wper ;
		FROM INT((SROW()-12)/2),INT((SCOL()-51)/2) ;
		TO INT((SROW()-12)/2)+11,INT((SCOL()-51)/2)+50 ;
		TITLE " Перерахунки " ;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 8

define wind w from 2,1 to 20,78;
	panel color schem 10;
    title [ Новў цўни ]

define wind wnar2 from 2,2 to 20,78	system color schem 8

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([],75) color &m_mescolor
merr=[]

ACTIVATE WINDOW wper

@ 2,3 SAY "За який перўод робити перерахунок"
@ 5,5 SAY "[ Ввести новў цўни    ]"
@ 6,5 SAY "[ Зробити перерахунок ]"
@ 7,5 SAY "[ Вихўд               ]"
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
	merr = [ Нема файлу - ]+mnamea
	return .f.
endif

mnamec=[arhiv\]+mcyear+[\dovnor.dbf]
if not file(mnamec)
	merr = [ Нема файлу - ]+mnamec
	return .f.
endif

wait [ Хвилинку! ] wind nowait

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
	merr=[За цей перўод в архўвў нема даних]
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
	kodnor :w=.f. :h=[Код],;
	naznor :w=.f. :h=[Hазва норми],;
	tvod   :w=.f. :h=[Ц.за воду],;
	tstok  :w=.f. :h=[Ц.за стоки],;
	tvod1         :h=[Нова ц.за в.],;
	tstok1        :h=[Нова ц.за ст.];
    NOAPPEND NODELETE

close data

*********************
func fv_go
*********************
wait wind nowait [ Чекайте... ]

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
		values (arh.kodbk,0,0,msvd,mstd,[Перерахунок за ]+dtoc(mdate))
	endif
	select arh
endscan
wait clear

select narax2
go bott
brow wind wnar2 field;
		kodbk  :r    :h=[Ос.рах],;
		ovd    :r    :h=[Об.води],;  
		ostd   :r    :h=[Об.ст],;
		svd    :r    :h=[S за воду],;
		std    :r    :h=[S за ст],;
		memo   :r    :h=[Прўмитка];
		noappend nodelete noedit;
		title [Перерахунок]
close data

