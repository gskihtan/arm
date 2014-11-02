********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************
	DEFINE WINDOW w ;
		FROM INT((SROW()-13)/2),INT((SCOL()-60)/2) ;
		TO INT((SROW()-13)/2)+12,INT((SCOL()-60)/2)+59 ;
		TITLE " Статистика по забогованостi " ;
		FLOAT ;
		NOCLOSE ;
		SHADOW ;
		DOUBLE ;
		COLOR SCHEME 5
******************** DEFINES *************************

************** BEGIN PROGRAMM ************************
mdate=date()

ACTIVATE WINDOW w
@ 1,5 SAY "Hа яку дату"
@ 3,4 TO 5,27 COLOR W/RB    
@ 1,33 TO 7,51 COLOR W/RB    
@ 7,8 SAY "Архўв   -"
@ 9,8 SAY "Обробка -"

@ 1,18 GET mdate SIZE 1,10 DEFAULT {  /  /  }
@ 4,6 GET msel  PICTURE "@*HN Сформувати звўт" ;
	SIZE 1,20,1 DEFAULT 1 VALID p_make()
@ 2,36 GET msel PICTURE "@*HN Browse" ;
	SIZE 1,13,1 DEFAULT 1 DISABLE VALID pbrow()
@ 4,36 GET msel PICTURE "@*HN Друк" 	SIZE 1,13,1 ;
	DEFAULT 1 DISABLE VALID pprint()
@ 6,36 GET msel PICTURE "@*HNT Вихўд" ;
	SIZE 1,13,1 DEFAULT 1

READ CYCLE MODAL WHEN preadwhen()
RELEASE WINDOW w

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

******************
func pbrow
******************
use outstat
browse field;
	kodbk :h=[Ос.рах],;
	sborg :h=[Борг],;
	nmis  :h=[к.мiсяцiв];
	normal;
	for nmis>0;
	title [Статистика заборгованостi на ]+dtoc(mdate)
use

******************
func pprint
******************
use outstat
store 0 to cnt1,cnt2,cnt3,cnt4
store 0.00 to sum1,sum2,sum3,sum4
go top
wait wind nowait [ Хвилинку ]
scan
	do case
		case nmis < 12	
			cnt1=cnt1+1
			sum1=sum1+sborg
		case nmis >=12 and nmis <24
			cnt2=cnt2+1
			sum2=sum2+sborg
		case nmis >=24 and nmis <36
			cnt3=cnt3+1
			sum3=sum3+sborg
		case nmis >=36
			cnt4=cnt2+1
			sum4=sum4+sborg
	endcase
endscan
wait clear
do p_print with [prn_stat]
use

******************
func preadwhen
******************
if file([outstat.dbf])
	show object 3 enabled
	show object 4 enabled
	show object 5 enabled
endif

******************
func p_make
******************
close data
create table outstat ( kodbk c(7),sborg n(9,2),borg n(9,2),nmis n(4) )
index on kodbk to istatyst comp
marhy=year(mdate)+1

do while marhy>1998
	marhy=marhy-1
	marhname=[ARHIV\]+str(marhy,4)+[\NARAX.DBF]
	if not file(marhname)
		wait wind nowait [ Hема архўву за ]+str(marhy,4)+[ p. ]
		exit
	endif
	
	@ 7,18 say str(marhy,4) color g+/br
	
	select 0
	use (marhname) order tm alias arh
	set relat to kodbk into outstat
	mrecc=recc()
	mrecn=0
	go bottom
	do while not bof()
		mcurdate=ctod([01.]+mis+[.]+str(marhy,4))
		if mcurdate<mdate
			if kodbk==outstat.kodbk
				if outstat.borg>0
					repl outstat.borg with outstat.borg-svp-stp-svd-std
					repl outstat.nmis with outstat.nmis+1
				endif
			else
				if saldp-subsn>0
					insert into outstat (kodbk,sborg,borg,nmis);
					values (arh.kodbk,arh.saldp-arh.subsn,;
					arh.saldp-arh.subsn-arh.svp-arh.stp-arh.svd-arh.std,1)
				else
					insert into outstat (kodbk,sborg,borg,nmis);
					values (arh.kodbk,0,0,0)
				endif
			endif
		endif
					
		mrecn=mrecn+1
		@ 9,18 say str(mrecn/mrecc*100,3,0)+[%    ] color g+/br
		skip -1
	enddo
	use
enddo	
close data
show object 3 enabled
show object 4 enabled
show object 5 enabled
