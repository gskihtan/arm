********************* SETUP **************************
do p_prepare
*
u_start = 3954
start_date = {01.07.2003}
cur_date = date()
cur_year = year(cur_date)
wait wind nowait [Wait ...]
*
arh_name = [ARHIV\]+str(cur_year,4)+[\NARAX.DBF]
if not file(arh_name)
	wait wind [File not found - ]+arh_name
	do p_clear
	return
endif
use (arh_name)
calc max(val(mis)) to cur_month
close data
*
* create table
*
create table out (kodbk c(7), ugoda n(10), cnt n(7),;
	u_sum n(11,2), tot_borg1 n(11,2), tot_borg2 n(11,2),;
	tot_opl n(11,2), cur_opl n(11,2))
index on ugoda to iout comp
*
* precess arhives
*
arh_no = year(start_date)
m_tsum1 = 0
m_tsum2 = 0
do while arh_no <= year(cur_date)
	arh_name=[ARHIV\]+str(arh_no,4)+[\NARAX.DBF]
	if not file(arh_name)
		wait wind nowait [ Hема архўву за ]+str(marhy,4)+[ p. ]
		do p_clear
		return
	endif
	wait wind nowait [Process ]+arh_name+[ ...]
	*
	select 0
	use (arh_name) order tm alias arh
	go top
	scan
		if arh_no = year(start_date) and val(arh.mis) = month(start_date)
			if (arh.saldn>0)
				m_tsum1 = m_tsum1 + arh.saldn
			endif
		endif
		if arh_no = cur_year and val(arh.mis) = cur_month
			if (arh.saldp>0)
				m_tsum2 = m_tsum2 + arh.saldp
			endif
		endif
		if empty(arh.ugoda) or arh.ugoda < u_start
			loop
		endif
		select out
		if not seek(arh.ugoda)
			append blank
			repl out.kodbk with arh.kodbk
			repl out.cnt with 1
			repl out.ugoda with arh.ugoda
			repl out.u_sum with arh.saldn - arh.subs - arh.subsn
		endif
		mc = arh.opl - (arh.svp+arh.stp+arh.svd+arh.std)
		if mc>0
			repl out.tot_opl with out.tot_opl+mc
			if arh_no = cur_year and val(arh.mis) = cur_month
				repl out.cur_opl with mc
			endif
		endif
		*
		select arh
	endscan
	use in arh
	arh_no = arh_no + 1
enddo
select out
go top
repl tot_borg1 with m_tsum1
repl tot_borg2 with m_tsum2
wait clear
copy to out1
use out1
select;
	sum(cnt) as cnt,;
	sum(u_sum) as u_sum,;
	sum(tot_borg1) as tot_borg1,;
	sum(tot_borg2) as tot_borg2,;
	sum(tot_opl) as tot_opl,;
	sum(cur_opl) as cur_opl;
from out1;
into dbf out;
group by cnt
use in out1
select out
do p_print with [u_report]

***************** END OF PROGRAMM *********************
do p_clear
