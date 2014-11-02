********************* SETUP **************************

do p_prepare

****************** OPEN DATABASE *********************

use narax order kodbk

******************** DEFINES *************************
************** BEGIN PROGRAMM ************************

sum pdv_deb to m.debet
sum pdv_kred to m.kredet
do p_print with [prn_pdv]
close data

***************** END OF PROGRAMM *********************
do p_clear

****************** PROCEDURES *************************

