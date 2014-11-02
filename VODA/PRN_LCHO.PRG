********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************
wait wind nowait [ Хвилинку! ]
select;
	zpilga.kodbk,;
	sum(1) as cntpil;
	from zpilga;
	into dbf outcnt;
	where inlist(zpilga.kodpil,[50],[51]);
	order by zpilga.kodbk;
	group by zpilga.kodbk
close data

select;
	zpilga.kodbk,;
	zpilga.n_posv,;
	padr(zpilga.fiopil,26)+allt(dovvul.vul)+[ ]+;
       allt(dovad.bud)+iif(!empty(dovad.kvar),[/]+allt(dovad.kvar),[]);
       as adr,;
	dovpil.pil as proc,;
	narax.ov/narax.kprop as ov,;
	narax.ost/narax.kprop as ost,;
	narax.sv/narax.kprop*dovpil.pil/100 as sv,;
	narax.st/narax.kprop*dovpil.pil/100 as st,;
	outcnt.cntpil as cntpil;
    from zpilga,dovad,dovvul,dovpil,narax,outcnt;
    where zpilga.kodbk==dovad.kodbk;
    	and zpilga.kodbk==narax.kodbk;
    	and zpilga.kodbk==outcnt.kodbk;
    	and zpilga.kodpil==dovpil.kodpil;
    	and dovad.kodv==dovvul.kodv;
    	and zpilga.kodpil==[50];
    into dbf out;
    order by zpilga.kodbk
close data
wait clear

use out
repl all ov with ov*cntpil,;
	ost with ost*cntpil,;
	sv with sv*cntpil,;
	st with st*cntpil

*brow normal
do p_print with [prn_lcho]
use in out

******************** DEFINES *************************
do p_clear

	
