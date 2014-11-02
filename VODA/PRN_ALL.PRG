********************* SETUP **************************
do p_prepare

****************** OPEN DATABASE *********************
******************** DEFINES *************************
************** BEGIN PROGRAMM ************************

wait window nowait [ Хвилинку! ]
select;
	narax.kodbk,;
	narax.kodnor,;
	narax.ov,;
	narax.ost,;
	narax.sv,;
	narax.st,;	
	narax.svp,;
	narax.stp;	
	from narax;
	into dbf out1

close data
use dovad  in 1 order kodbk
use lich   in 2 order kodbk
use lichb  in 3 order kodbl
use dovnor in 4 order kodnor
use out1 in 5
select out1
set relat to kodbk into dovad,;
		kodbk into lich,;
		f_adr1([dovad]) into lichb

repl all kodnor with;
	iif(not empty(lich.kodbk),[LL],;
	iif(not empty(f_adr1([lichb])),[LB],kodnor))

select dovnor
copy to out3 for inlist(kodnor,[01],[02],[03],[04],[05],[06],[07]);
	field kodnor,naznor
use out3
insert into out3 (kodnor,naznor) values ([LL],[Лўчильник])
insert into out3 (kodnor,naznor) values ([LB],[Будинковий лўчильник])

select out1
select;
	out1.kodnor,;
	out3.naznor,;
	sum(out1.ov)     as ov,;
	sum(out1.ost)    as ost,;
	sum(out1.sv)     as sv,;
	sum(out1.st)     as st,;	
	sum(out1.svp)    as svp,;
	sum(out1.stp)    as stp;	
	from out1,out3;
	into dbf out;
	where out1.kodnor==out3.kodnor;
	order by out1.kodnor;
	group by out1.kodnor
close data
use out
wait clear
do p_print with [prn_all]

***************** END OF PROGRAMM *********************
do p_clear
****************** PROCEDURES *************************

