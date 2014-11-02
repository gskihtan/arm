********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use dovad in 1 order tag kodbk
use dovvul in 2 order tag kodv
use narax in 3 order tag kodbk
select dovad
set relat to kodbk into narax,kodv into dovvul

******************** DEFINES *************************

define wind w from 2,1 to 22,78;
        panel color schem 10;
    title [ Dovad - „®¢÷¤­¨ª  ¤à¥á ]
define popup pvul prom field dovvul.vul;
        from 0,10 to 10,35;
        color scheme 2 marg shad
on select popup pvul deact popup

define popup adv from 5,5 title [ Œ¥­î ] shad
define bar 1 of adv prom [ ö­ä®à¬ æ÷ï ¯à® ¡ã¤¨­®ª ]
define bar 2 of adv prom [ ‘®àâã¢ â¨ § ...]
define bar 3 of adv prom [ ‚÷«ì­¨© ®á. à åã­®ª]
on select bar 1 of adv do p_info
on select bar 2 of adv do p_sort
on select bar 3 of adv do p_freekod
mcurbar=1

************** BEGIN PROGRAMM ************************

@ 24,0 say padr([F1 ®èãª³INS H®¢¨©³DEL ‡­¨é¨â¨ ³]+;
               [F4 ¥¤.³Ctrl+ENTER Œ¥­î³F12 „àãª³],75) color &m_mescolor

on key label F4  do p_edit with [EDIT]
on key label INS do p_edit with [CREATE]
on key label DEL do p_delete
on key label F1  do poshuk
on key label F12 do p_printex
on key label CTRL+ENTER do p_adv

m.newkod=[]

browse window w field;
        kodbk   :r :h=[á.à å],;
        fio     :r :h=[à÷§¢¨é¥  ¡®­¥­â ],;
        dovvul.vul :20 :h=[‚ã«¨æï] ,;
        bud     :r :h=[ã¤.],;
        kvar    :r :h=[Š¢.],;
        poverh  :r :h=[®¢.],;
        sector  =iif(!empty(derg),iif(derg==[D],[¤¥à¦],[¢« á]),[]) :h=[‘¥ªâ®à],;
        kodrax  :r :h=[ô¤.à å],;
        datainv :r :h=[ö­¢¥­â.];
    NOAPPEND NODELETE NOEDIT

on key label F4
on key label INS
on key label DEL
on key label F1
on key label F5
on key label F12
on key label F3

set relat to
wait wind nowait [ •¢¨«¨­ªã! ]
pack
wait clear

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

*****************
proc p_sort
*****************
mcurbar=2
define wind w_sort from 7,20 to 11,43;
        doub shad color schem 5;
        title [ ‘®àâã¢ ­­ï ]
activ wind w_sort
@ 0,0 say [ ‡  ®á®¡®¢¨¬ à åã­ª®¬]
@ 1,0 say [ ‡   ¤à¥á®î]
@ 2,0 say [ ‡  ¯à÷§¢¨é¥¬]
@ 0,0 get mp pict [@*IVT ;;] defa 1 valid p_pop_sort();
        size 1,22
read cycle modal
rele wind w_sort
deact popup

func p_pop_sort
do case
        case mp=1
                set order to kodbk
        case mp=2
                set order to adr
        case mp=3
                set order to fio
endcase

******************************************************
proc p_edit
******************************************************
parameter mode
push key
on key
select dovad
morder=order()
mrecno=recno()
scatter memvar
m.vul=dovvul.vul
set order to kodbk
if mode==[CREATE]
	MTITLE = " H®¢¨© § ¯¨á "
	m.fio=space(25)
	m.kvar=space(3)
	kod_access=.t.
	if not empty(m.newkod)
		m.kodbk=m.newkod
	endif
else
	if eof()
		wait wind nowait [ „®¢÷¤­¨ª ¯®à®¦­÷© ]
		pop key
		return
	endif
	MTITLE = " ¥¤ £ã¢ ­­ï "
	kod_access=.f.
endif

do case
	case derg==[W]
		msel=2
	case derg==[D]
	    msel=1
   	other
   		msel=0
endcase

DEFINE WINDOW wappend ;
                FROM 3, 6 ;
                TO 19,70 ;
                TITLE MTITLE;
                FLOAT NOCLOSE SHADOW DOUBLE ;
                COLOR SCHEME 5
ACTIVATE WINDOW wappend

@ 4,5 SAY "‚ã«."
@ 4,37 SAY "ã¤."
@ 4,48 SAY "Š¢ à."
@ 1,17 SAY "á®¡®¢¨© à åã­®ª"
@ 3,2 TO 5,59
@ 2,3 SAY "€¤à¥á "
@ 8,42 SAY "‘¥ªâ®à"
@ 11,3 SAY "ô¤¨­¨© à åã­®ª.............."
@ 9,3 SAY "„ â  ÷­¢¥­â à¨§ æ¨ù......"
@ 7,3 SAY "à÷§¢¨é¥.."
@ 11,42 SAY "®¢¥àå.."
@ 13,26 SAY "[ ‡ ¯¨á â¨ ]"

@ 1,35 GET m.kodbk valid fv_kodbk();
        error [  åã­®ª ­¥ª®à¥ªâ­¨©  ¡® ¢¦¥ ÷á­ãõ ];
        when kod_access
@ 4,10 GET m.vul valid fv_vul() error [ ‚¢¥¤÷âì ¢ã«¨æî ]
@ 4,42 GET m.bud valid val(m.bud)>0;
        error [ H¥¢÷à­¥ §­ ç¥­­ï ]
@ 4,54 GET m.kvar when w_poverh()
@ 7,13 GET m.fio
@ 9,28 GET m.datainv
@ 11,31 GET m.kodrax
@ 7,49 GET msel ;
        PICTURE "@^ „¥à¦.;‚« á." ;
        SIZE 3,10 defa 1;
        valid v_msel();
        COLOR SCHEME 5
@ 11,50 GET m.poverh size 1,2
@ 13,26 GET mok PICTURE '@*IT ' defa 1;
        SIZE 1,12 VALID p_ok()

READ CYCLE MODAL NOMOUSE
RELEASE WIND wappend

select dovad
set order to &morder
if mrecno>0 and mrecno<=recc()
        goto mrecno
endif
pop key
return

*/////////////////
func fv_kodbk
*/////////////////
select dovad
set order to kod
mkod=val(subs(m.kodbk,2))
if seek(mkod) or len(allt(m.kodbk))#7
        set order to kodbk
        return .f.
else
        set order to kodbk
        return .t.
endif

*/////////////////
func w_poverh
*/////////////////
select dovad
madr=f_adr1([MEMORY])
set order to adr
if seek(madr)
        m.poverh=poverh
        m.derg=derg
		do case
			case derg==[W]
                msel=2
			case derg==[D]
			    msel=1
        	other
        		msel=0
        endcase
else
        m.poverh=0
        msel=0
        m.derg=[]
endif
show gets

*/////////////////
func p_ok
*/////////////////
select dovad
if mode==[EDIT]
	goto mrecno
	gather memvar
else
	insert into dovad from memvar
endif
madr=f_adr1([DOVAD])
set order to adr
seek madr
repl poverh with m.poverh,derg with m.derg;
        while madr==f_adr1([DOVAD])

*/////////////////
func v_msel
*/////////////////
if msel==1
        m.derg=[D]
else
        m.derg=[W]
endif

*/////////////////
func fv_vul
*/////////////////
select dovvul
set order to vul
if !seek(m.vul)
        m.vul=chrtran(m.vul,[©æãª¥­£èé§åóä¨¢ ¯à®«¤¦õïçá¬÷âì¡îù],;
           [‰–“Š…]+CHR(141)+[ƒ˜™‡•ò”ˆ‚€‹„†ôŸ—‘Œö’œø])
        seek(m.vul)
        activ popup pvul rest
        if last()=27
                set order to kodv
                return .f.
        endif
endif
m.kodv=dovvul.kodv
m.vul=dovvul.vul
set order to kodv

*****************
proc p_delete
*****************
push key
on key
select dovad
if recc()=0
        wait wind nowait [ „®¢÷¤­¨ª ¯®à®¦­÷© ]
        pop key
        return
endif
if narax.kodbk==dovad.kodbk
        wait wind nowait [ H¥¬®¦«¨¢® §­¨é¨â¨,÷á­ãîâì ­ à åã¢ ­­ï ]
else
        if deleted()
                if p_confirm(" ‚÷¤­®¢¨â¨ ? ",.t.)
                        recall
                endif
        else
                mcc=[‡­¨é¨â¨ § ¯¨á#]+kodbk+[ ]+allt(fio)+[ ?]
                if p_confirm(mcc,.t.)
                        delete
                endif
        endif
endif
pop key

************************
procedure  p_printex
************************
push key
on key
select dovad
do p_print with [dovad]
go top
pop key

*************************
procedure p_info
*************************
mcurbar=1
select 0
use lich order kodbk

select dovad
mr=recno()
mord=order()
set relat to kodbk into lich additive
madr=f_adr1([dovad])
mfooter=[ ]+allt(dovvul.vul)+[ ]+allt(bud)+[ ]
set order to adr
seek(madr)
mkprop=0
mklich=0
scan while f_adr1([dovad])==madr
	mkprop=mkprop+narax.kprop
	if lich.kodbk==dovad.kodbk
		mklich=mklich+narax.kprop
	endif
endscan

select lich
use lichb order kodbl
if seek(madr)
	mkbud=mkprop-mklich
else
	mkbud=0
endif
use

DEFINE WINDOW wbud ;
		FROM INT((SROW()-7)/2),INT((SCOL()-47)/2) ;
		TO INT((SROW()-7)/2)+6,INT((SCOL()-47)/2)+46 ;
		TITLE " ö­äà¬ æ÷ï ¯® ¡ã¤¨­ªã " ;
		FOOTER mfooter;
		NOFLOAT ;
		NOCLOSE ;
		SHADOW ;
		NOMINIMIZE ;
		COLOR SCHEME 5
ACTIVATE WINDOW wbud
@ 1,3 SAY "Š÷«ìª÷áâì ¯à®¯¨á ­¨å ®á÷¡ -" color w/br
@ 2,3 SAY "Š¢ àâ¨à­÷ «÷ç¨«ì­¨ª¨      -" color w/br
@ 3,3 SAY "ã¤¨­ª®¢÷ «÷ç¨«ì­¨ª¨      -" color w/br
@ 1,31 say mkprop color gr+/br
@ 2,31 say mklich color w+/br
@ 3,31 say mkbud  color w+/br
set cursor off
READ
set cursor on
rele wind wbud
select dovad
set order to &mord
if mr>0 and mr<=recc()
	goto mr
endif
deact popup

*************************
proc p_adv
*************************
push key
on key
activ popup adv bar mcurbar
pop key

*************************
proc p_freekod
*************************
mcurbar=3
m.newkod=[]
set order to adr
set order to kod
do while not eof()
        mnkod=val(subs(kodbk,2))
        mckod=kodbk
        skip
        if val(subs(kodbk,2))=mnkod+1
                loop
        endif
        m.newkod=subs(mckod,1,1)+padl(allt(str(mnkod+1)),6,[0])
        wait wind nowait m.newkod
        exit
enddo
deact popup