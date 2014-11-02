close all

select 0
use narax2
copy stru to out_n2
use out_n2

select 0
use out_n alias arh

go top
scan
	msvd=sv/1.19*1.14-sv
	mstd=st/0.33*0.30-st
	
	if pil>0
        msvd = msvd/kprop*(kprop*100-pil)/100
        mstd = mstd/kprop*(kprop*100-pil)/100
    endif

    msvd = round(msvd,2)
    mstd = round(mstd,2)

	if msvd#0 or mstd#0
		insert into out_n2 (kodbk,ovd,ostd,svd,std,memo);
		values (arh.kodbk,arh.ov,arh.ost,msvd,mstd,[Перерахунок за грудень])
	endif
	select arh
endscan
