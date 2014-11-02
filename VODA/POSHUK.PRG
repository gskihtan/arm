push key
on key
private msel
msel=str(select(),1)
select dovvul
set order to tag kodv
mi_dovvul=order()
select dovad

mi_dovad=order()
define popup pvul scroll prom field dovvul.vul;
        from 0,10 to 10,35 shad ;
        color n/w,n/w,n/w
on select popup pvul deact popup

define popup p_find scroll prom field;
        dovad.kodbk+[│]+left(dovad.fio,15)+[│];
                +padr(dovvul.vul,17)+[│]+padl(dovad.bud,4)+[│]+padl(dovad.kvar,3);
                +[│]+dovad.kodrax ;
        from 7,1 to 17,61;
        color n/w,n/w,n/w,w/n
on select popup p_find do the_end

DEFINE WINDOW wposh ;
                FROM 3, 6 ;
                TO 22,70 ;
                TITLE " Пошук " ;
                FOOTER " <ESC> - Вихўд " ;
                FLOAT ;
                NOCLOSE ;
                SHADOW ;
                DOUBLE ;
                COLOR /w,w+/b,n/w,b/w,n/w,n/w,n/w,n/w

ACTIVATE WINDOW wposh

@ 2,5 SAY "Вул."
@ 2,37 SAY "Буд."
@ 2,48 SAY "Квар."
@ 6,3 SAY "Особовий рахунок"
@ 6,37 SAY "Їдиний рахунок"
@ 4,3 SAY "Прўзвище"
@ 1,2 TO 3,59 color n+/w
@ 7,1 TO 17,61 color n+/w
@ 0,3 SAY "Адреса"
@ 2,42 say [    ] color w+/b
@ 2,54 say [   ] color w+/b

publ mkodv,mvul,mbud,mkvar,mfio,mkodbk,mkodrax

mkodv   = space(4)
mvul    = space(25)
mbud    = space(4)
mkvar   = space(3)
mfio    = space(25)
mkodbk  = space(7)
mkodrax = space(8)
m_result=.f.

@ 2,10 GET mvul valid _vul() error [ Введўть вулицю ]
@ 4,20 GET mfio DISABLE valid _fio()
@ 6,20 GET mkodbk DISABLE valid _kodbk()
@ 6,52 GET mkodrax DISABLE valid _kodrax()

READ CYCLE MODAL NOMOUSE

DEACT WIND wposh
RELEASE WINDOW wposh

select dovad
m_kodbk=dovad.kodbk
set order to mi_dovad
select dovvul
set order to mi_dovvul
select &msel
pop key

*********************
func _vul
*********************
if last()==13
        select dovvul
        set order to vul
        if not seek(mvul)
                mvul=chrtran(mvul,[йцукенгшщзхєфивапролджїячсмўтьбю∙],;
                        [ЙЦУКЕНГШЩЗХЄФИВАПРОЛДЖЇЯЧСМЎТЬБЮ°])
                seek mvul
                activ popup pvul rest
                if last()=27
                        set order to kodv
                        select dovad
                        return .f.
                endif
        endif
        mkodv=dovvul.kodv
        mvul=dovvul.vul
        set order to kodv
        select dovad
        show gets
        @ 2,42 GET mbud
        @ 2,54 GET mkvar
        READ MODAL NOMOUSE
        if last()#27
                =_adr()
        endif
        return .t.
endif
if last()=24
        show object 1 disable
        show object 2 enable
endif
return .t.

************************
func _adr
************************
set order to adr
seek mkodv+padr(allt(mbud),4)+padr(allt(mkvar),3)
activ popup p_find rest

************************
func _fio
************************
if last()=24
                show object 2 disable
                show object 3 enable
                return .t.
endif
if last()=5
                show object 2 disable
                show object 1 enable
                return .t.
endif
if last()=13
        select dovad
        set order to tag fio
        seek mfio
        activ popup p_find rest
endif

************************
func _kodbk
************************
if last()=24
                show object 3 disable
                show object 4 enable
                return .t.
endif
if last()=5
                show object 3 disable
                show object 2 enable
                return .t.
endif
if last()=13
        select dovad
        if len(allt(mkodbk))=7
        	mkod=val(subs(mkodbk,2))
        else
        	mkod=val(mkodbk)
        endif
        set order to tag kod
        seek mkod
        set order to kodbk
        activ popup p_find rest
endif

************************
func _kodrax
************************
if last()=5
        show object 4 disable
        show object 3 enable
        return .t.
endif
if last()=13
        select dovad
        set order to tag kodrax
        seek mkodrax
        activ popup p_find rest
endif

**************************
proc the_end
**************************
m_result=.t.
clear read
deact popup