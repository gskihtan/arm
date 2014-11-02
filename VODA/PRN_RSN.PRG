********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

******************** DEFINES *************************

define wind w from 5,15 to 15,65;
        doub shad color schem 5;
        title [ Hарахування ў субсидў∙ ]

************** BEGIN PROGRAMM ************************

activ wind w
set color to w+/br,gr+/b
do while .t.
        clear
        close data
        @ 1,1 say [Субсидў∙ - ]
        @ 1,12 prom [ Оплаченў   ]
        @ 2,12 prom [ Heoплаченў ]
        menu to mm
        if mm=0
        	exit
        endif

        @ 4,1 say [Дата    - з] get mdate1;
                defa {}
        @ 5,1 say [         по] get mdate2;
                defa {};
                valid year(mdate2)=year(mdate1);
                error [ Invalid date ! ]
        read
        if last()=27
                loop
        endif

    cyear=subs(dtoc(mdate1,1),1,4)
    wait [ Шукаю... ] wind nowait
    select 0
    crea table out_n_s.dbf (kodbk c(7),subs n(7,2),nar n(7,2),sss c(20),npach c(4))
    index on kodbk to i0

   do case
         case mm=1
			   arhname=[ARHIV\]+cyear+[\SUBS.DBF]
         case mm=2
			   arhname=[SUBSN.DBF]
   endcase
    
    
    if file(arhname)
                select 0
                use &arhname alias asubsn
                scan for date>=mdate1 and date<=mdate2
                        select out_n_s
                        append blank
                        repl subs with asubsn.suma
                        repl kodbk with asubsn.kodbk
                        repl npach with asubsn.npach
                        select asubsn
                endscan
                use
    else
    	wait wind [ Не знайдено файл ]+arhname
    endif
    select out_n_s
    index on kodbk+str(subs,14,2)+npach to i123 comp unique
    copy to outtm
    use outtm

    arhname=[ARHIV\]+cyear+[\NARAX.DBF]
    if not file(arhname)
        wait wind nowait [ Не знайдено файл  - ]+arhname
        loop
    endif
    select 0
    use &arhname alias arhiv
    scan for val(mis)>=month(mdate1) and val(mis)<=month(mdate2)
        select outtm
        append blank
        repl nar with arhiv.svp+arhiv.stp
        repl kodbk with arhiv.kodbk
        select arhiv
    endscan
    use
    select outtm
    index on kodbk to itmpl comp
    wait clear
    total on kodbk to outcm
    use outcm
    delete for nar>=subs
    delete for subs = 0

    pack
    select 0
    use dovvul order kodv
    select 0
    use dovad order kodbk
    set relat to kodv into dovvul
    select outcm
    set relat to kodbk into dovad

    on key label F12 do prnt
    wait wind nowait [ F12 - Друк ]
    brow field;
        kodbk  :h=[Ос.рах.],;
        dovad.fio :h=[ПЎБ] :r,;
        adr=allt(dovvul.vul)+[ ]+allt(dovad.bud)+[/]+allt(dovad.kvar) :30 :h=[Адреса],;
        subs   :r :h=[Субсидў∙],;
        nar    :h=[Hарах.],;
        sss    :h=[Примiтка];
        normal;
        title iif(mm=1,[ О],[ Hео])+[плаченў субсидў∙+нарахування]
    on key
    pack
enddo
clea wind

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************
******************
proc prnt
******************
push key clear
select;
	outcm.kodbk,;
	padr(dovad.fio,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
	outcm.subs,;
	outcm.nar,;
	outcm.sss;
	from outcm,dovad,dovvul;
	into dbf out;
	where dovad.kodv==dovvul.kodv and outcm.kodbk==dovad.kodbk;
		and not deleted();
	order by outcm.kodbk

do p_print with [prn_rsn]
use in out
pop key
