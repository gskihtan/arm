*******************************************
*      SETUP                              *
*******************************************
set talk off
set safety off
set status off
set century on
set date british
set clock to 24,69
set near on
set delete off
set escape off
set help off

create table lock (lock c(1))
close all
clear wind
clear memory
set color to
clear
on key
=numlock(.t.)

*************************** PUBLIC VARIABLES

set proc to stdproc
public m_kodbk,m_date,m_path,m_scr,m_mescolor
public m_result
public array m_mis(12,2)
public m_pad
public patharh

patharh=[E:\VODA]

m_mis[1,1]=[ci祭�]
m_mis[2,1]=[��⨩]
m_mis[3,1]=[�epe����]
m_mis[4,1]=[��i⥭�]
m_mis[5,1]=[�pa����]
m_mis[6,1]=[�ep����]
m_mis[7,1]=[������]
m_mis[8,1]=[cep����]
m_mis[9,1]=[�epec���]
m_mis[10,1]=[���⥭�]
m_mis[11,1]=[���⮯��]
m_mis[12,1]=[��㤥��]

m_mis[1,2]=[ci��]
m_mis[2,2]=[���o�o]
m_mis[3,2]=[�epe���]
m_mis[4,2]=[��i��]
m_mis[4,2]=[�pa���]
m_mis[6,2]=[�ep���]
m_mis[7,2]=[�����]
m_mis[8,2]=[cep���]
m_mis[9,2]=[�epec��]
m_mis[10,2]=[�����]
m_mis[11,2]=[���⮯���]
m_mis[12,2]=[��㤭�]
m_mescolor=[n+/w]

use kp
m_direc=lookup(name,1,kodp)
m_mainb=lookup(name,2,kodp)
m_mainu=lookup(name,3,kodp)
use

****************************** Verify disk space

mnspace=50*1000000
mspace=diskspace()
if mspace<mnspace and .f.
	?[ �������� ����� �� ���� ]
	?
	?[ ���쭮�� ����� - ]
	?? mspace/1000000
	??[ Mb]
	?[ ���������      - ]
	?? mnspace/1000000
	??[ Mb]
	? chr(7)
	wait [ ������� ���-�� �������... ]
	quit
endif

if not file([setup.mem])
	_m_correct=.f.
	_m_printer=1
	save all like _m_* to setup
endif
	
restore from setup additive
if not _m_correct or not allcdx()
        do p_reindex
endif
do p_rcopy with .f.

_m_date=date()
do p_scr

*******************************************
*      MAIN MENU                          *
*******************************************
define menu m_menu bar at line 0
define pad file  of m_menu prompt [\<�����]
define pad dovid of m_menu prompt [\<���i�����]
define pad post  of m_menu prompt [\<����㯫����]
define pad lich  of m_menu prompt [\<�i稫쭨��]
define pad narax of m_menu prompt [\<H���㢠���]
define pad dryk  of m_menu prompt [\<�����㭪�]
define pad arh   of m_menu prompt [\<�����]

****************************** �����

on pad file of m_menu acti popup file
define popup file from 2,0 marg shad relat
define bar 1 of file prompt [\<������������]
define bar 2 of file prompt [\<������ ⠡����]
define bar 8 of file prompt [\<����ࢭ� ������� �����]
define bar 3 of file prompt [\<��ॢ�ઠ �����]
define bar 4 of file prompt [\<������ �� ����� ������]
define bar 5 of file prompt [\-]
define bar 6 of file prompt [����� � FoxPro   - Alt+\<X]
define bar 7 of file prompt [����� � ��       - Alt+\<Q]
on select bar 1 of file do p_reindex && in this file
on select bar 2 of file do p_open	 && in this file
on select bar 3 of file do datcheck
on select bar 4 of file do newmonth
on select bar 6 of file do p_end with [FOX] && in this file
on select bar 7 of file do p_end with [OS]  && in this file
on select bar 8 of file do p_rcopy with .t.

****************************** ���������

on pad dovid of m_menu acti popup dovid
defi popup dovid from 2,0 marg shad relat
define bar 7 of dovid prompt [�������� ���쭨��]
define bar 1 of dovid prompt [�������� ����]
define bar 2 of dovid prompt [�������� ��� ����� ����]
define bar 3 of dovid prompt [�������� �i��]
define bar 4 of dovid prompt [�������� �㫨��]
define bar 5 of dovid prompt [�������� ��稫쭨���]
define bar 6 of dovid prompt [\<�����㢠��� ���ଠ���]
on select bar 1 of dovid do dovad
on select bar 2 of dovid do dovnor
on select bar 3 of dovid do dovpil
on select bar 4 of dovid do dovvul
on select bar 5 of dovid do dovlich
on select bar 6 of dovid do info
on select bar 7 of dovid do dovdil

****************************** ����㯫����

on pad post of m_menu acti popup post
defi popup post from 2,0 marg shad
define bar 1 of post prompt [\<�����]
        on bar 1 of post activ popup post1
        define popup post1 marg shad
        define bar 1 of post1 prompt [\<��i� �����]
        define bar 2 of post1 prompt [\<����� � ��,���,���]
        define bar 3 of post1 prompt [�����㢠��� \<����]
        on select bar 1 of post1 do postv with [POST]
        on select bar 2 of post1 do postk
        on select bar 3 of post1 do postb with [POST]
define bar 2 of post prompt [�\<�ᨤi� ����祭�]
        on bar 2 of post activ popup post2
        define popup post2 marg shad
        define bar 1 of post2 prompt [��i� ��ᨤi�]
        define bar 2 of post2 prompt [�����㢠��� ����]
        on select bar 1 of post2 do postv with [SUBS]
        on select bar 2 of post2 do postb with [SUBS]
define bar 3 of post prompt [�\<�ᨤi� ������祭�]
        on bar 3 of post activ popup post3
        define popup post3 marg shad
        define bar 1 of post3 prompt [��i� ��ᨤi�]
        define bar 2 of post3 prompt [�����㢠��� ����]
        define bar 3 of post3 prompt [����� � 䠩��]
        on select bar 1 of post3 do postv with [SUBSN]
        on select bar 2 of post3 do postb with [SUBSN]
        on select bar 3 of post3 do posts_in
define bar 4 of post prompt [��१���� /�� �����. � ���./]
on select bar 4 of post do postsubs

****************************** �i稫쭨��

on pad lich of m_menu acti popup lich
define popup lich from 2,0 marg shad relat
define bar 1 of lich prompt [��⠭�������,��ॣ㢠���,����ઠ]
define bar 2 of lich prompt [���� ����������]
define bar 3 of lich prompt [��稫쭨�� �� �㤨���]
define bar 6 of lich prompt [��ॣ㢠��� �������� ����������]
define bar 4 of lich prompt [\-]
define bar 5 of lich prompt [��� �������]
define bar 7 of lich prompt [��� ����ப �� ������]
define bar 8 of lich prompt [��� ������७�� ��稫쭨���]
on select bar 1  of lich do lichv
on select bar 2  of lich do lichp
on select bar 3  of lich do lichb
on select bar 5  of lich do lich_blk
on select bar 6  of lich do lich_ed
on select bar 7  of lich do lich_p1
on select bar 8  of lich do lich_p2

****************************** H���㢠���

on pad narax of m_menu acti popup narax
defi popup narax from 2,0 marg shad relat
define bar 1 of narax prompt [��i� ����㢠���,஧�����㢠���]
define bar 3 of narax prompt [�����i ��i�� �/� �� ������]
define bar 10 of narax prompt [������ ����� �� �㫨��� ]
define bar 5 of narax prompt [������㢠���]
define bar 6 of narax prompt [�����.������ �����(鮬�����)]
define bar 7 of narax prompt [�����㭪� �� ����� ����]
define bar 4 of narax prompt [���������� �������]
define bar 9 of narax prompt [\-]
define bar 2 of narax prompt [���㢠��� ����㢠��]
define bar 11 of narax prompt [���죨 ��� ������� ��ᨤ��]
on select bar 1 of narax do naraxv
on select bar 2 of narax do naraxfor
on select bar 3 of narax do naraxraz
on select bar 4 of narax do naraxdel
on select bar 5 of narax do naraxopl
on select bar 6 of narax do naraxdop
on select bar 10 of narax do narraz2
on select bar 11 of narax do import

****************************** �����㭪�

on pad dryk of m_menu acti popup calc
defi popup calc from 2,0 marg shad relat
define bar 1  of calc prompt [��� ����� �� �i�죨]
define bar 2  of calc prompt [��� ᯨ�� ���죮�����]
define bar 21 of calc prompt [��� ��ᯮ��� �୮�������]
define bar 22 of calc prompt [��� ᯨ�� �୮�������]
define bar 4 of calc prompt [\-]
define bar 5 of calc prompt [��� �����㭪��]
define bar 6 of calc prompt [��� ����࣮������� ����.]
define bar 30 of calc prompt [��� ����࣮������� ����.ᯨ᪮�]
define bar 31 of calc prompt [��� �i������� i�����ਧ��ii]
define bar 20 of calc prompt [������ﭭ� ��ᨤ�� � ����㢠��]
define bar 8 of calc prompt [��� ����⪨ ��������]
define bar 9 of calc prompt [��� ஧��㭪� ��'����]
define bar 10 of calc prompt [\-]
define bar 11 of calc prompt [����⨪� �� ��⠭���. ��稫쭨���]
define bar 12 of calc prompt [����⨪� ����࣮������� �� ��稫쭨���]
define bar 41 of calc prompt [���ଠ��� �� ���. �ਡ���� ������]
define bar 17 of calc prompt [H���㢠��� ��� ������� ��ᨤ��]
define bar 60 of calc prompt [��� ��� �頤�����]
define bar 18 of calc prompt [C���⨪� �� ����࣮�������]
define bar 15 of calc prompt [\-]
define bar 13 of calc prompt [��� ���������� ����祭��]
define bar 19 of calc prompt [��� ���]
define bar 40 of calc prompt [��� "���� ������."]
define bar 50 of calc prompt [��������ਧ���� ����࣮�������]

on select bar 1 of calc do prn_pil
on select bar 2 of calc do prn_pill

on select bar 5 of calc do prn_per
on select bar 6 of calc do prn_borg
on select bar 30 of calc do prn_bors
on select bar 31 of calc do prn_inv
on select bar 8 of calc do prn_nar
on select bar 9 of calc do prn_all
on select bar 11 of calc do prn_stl
on select bar 12 of calc do prn_brgl
on select bar 13 of calc do prn_pldo

on select bar 17 of calc do narsubs
on select bar 60 of calc do b_bank

on select bar 18 of calc do prn_stat
on select bar 19 of calc do prn_pdv
on select bar 20 of calc do prn_rsn
on select bar 21 of calc do prn_pcho
on select bar 22 of calc do prn_lcho

on select bar 40 of calc do prn_opl
on select bar 41 of calc do prn_pro
on select bar 50 of calc do u_report

****************************** �����

on pad arh of m_menu acti popup arh relat
defi popup arh from 2,0 marg shad
define bar 1 of arh prompt [��ॣ�� ���ଠ���]
define bar 2 of arh prompt [���饭�� ���ଠ���]
define bar 3 of arh prompt [������������ ������]
define bar 4 of arh prompt [���]
on select bar 1 of arh do arhview
on select bar 2 of arh do arhdel
on select bar 3 of arh do arhreind
on select bar 4 of arh do arhprn

*******************************************************

mflag=[CONT]
do while .t.
    restore screen from m_scr
    do p_clear

	if type([m_pad])=[L]
		activ menu m_menu
	else
		acti menu m_menu pad &m_pad
	endif

    if mflag#[CONT]
         exit
    endif
enddo

set color to
clear
on key
set help on
do case
        case mflag==[FOX]
                clear memory
                set proc to stdproc
                return
        case mflag==[OS]
                quit
endcase

