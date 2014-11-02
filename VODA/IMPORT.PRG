p_month = "09"
p_year = "2006"
close data
select;
	00 as cnt_pil,;
	zpilga.ind_pod,;
	zpilga.fiopil,;
	zpilga.kodbk,;
	dovpil.kodpil_s,;
	zpilga.kodpil,;
	narax.sv,;
	narax.st,;
	narax.kprop,;
	dovpil.pil;
browse
from zpilga, dovpil, narax;
into dbf out_pod;
where zpilga.kodpil==dovpil.kodpil;
	and zpilga.kodbk==narax.kodbk;
	and dovpil.user=="P";
*    and zpilga.ind_pod
	and not empty(dovpil.for_pod);
order by dovpil.kodpil_s

close data
use zpilga in 0 order kodbk
use dovpil in 0 order kodpil
use out_pod in 0
select zpilga
set relat to kodpil into dovpil
select out_pod
go top
scan
	select zpilga
	seek out_pod.kodbk
	scan while kodbk==out_pod.kodbk
		if zpilga.kodpil==out_pod.kodpil or out_pod.kodpil==dovpil.kodpil1
			select out_pod
			repl out_pod.cnt_pil with out_pod.cnt_pil+1
			repl out_pod.ind_pod with out_pod.ind_pod+1
			select zpilga
		endif
	endscan
	select out_pod
endscan

close data
use out_pod alias pod
repl all sv with round(sv/kprop*cnt_pil*pod.pil/100,2),;
		 st with round(st/kprop*cnt_pil*pod.pil/100,2)
copy to z_p
go top
brow
**********************************
fp = fcreate("out\import.txt")
str_record = padl(allt(str(recc())),6,"0")
header = "IMPORT_LGT" + p_year + p_month + "000003348531" + str_record + "252"
=fputs(fp,header)
scan
	str = padl(alltrim(pod.ind_pod),10,"0")
	str = str + padr(allt(fiopil),50)
	str = str + padl(kodbk,15,"0")
	str = str + padl(kodpil_s,6,"0")
	str = str + padl(allt(str(cnt_pil)),2,"0")
	for i = 0 to 4
		str = str + "00000.00"
	endfor
	str = str + padl(allt(str(sv,5,2)),8,"0")
	str = str + padl(allt(str(pil)),5,"0") + ".00"
	for i = 0 to 8
		str = str + "00000.00"
	endfor
	str = str + padl(allt(str(st,5,2)),8,"0")
	str = str + padl(allt(str(pil)),5,"0") + ".00"
	for i = 0 to 4
		str = str + "00000.00"
	endfor
	str = str + "00000.00"
	str = str + "00000.00"
	=fputs(fp,str)
endscan
=fclose(fp)
close data
modi comm out\import.txt

