close all
clear all


use zpilga in 0
use out in 0

select;
	out.kodbk as out_kodbk,;
	out.kodpil as out_kodpil,;
	zpilga.kodbk,;
	zpilga.kodpil,;
	zpilga.fiopil,;
	zpilga.pil,;
	zpilga.kpil,;
	zpilga.n_posv,;
	zpilga.ind_pod,;
    out.ov,;
    out.ost,;
	out.sv,;
	out.sv_4,;
	out.st_4,;
    out.cntpil,;
	out.st;
from zpilga, out into dbf t_result;
where zpilga.kodbk = out.kodbk;
	and zpilga.kodpil = out.kodpil;
	and allt(zpilga.fiopil) = allt(left(out.adr, 25));
	and zpilga.kodpil in ('10','20','15','16','30','32','34','38','44','48','50','52','54','58','71','73','75','77','83','87','43');
order by zpilga.kodbk, zpilga.kodpil

brow