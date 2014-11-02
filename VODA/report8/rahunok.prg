CLOSE ALL
CLEAR ALL
SET DATE GERMAN
SET CENTURY on
SET PROCEDURE TO ..\stdproc.prg
SET COLOR TO w+/w
SET SAFETY OFF
SET TALK OFF
SET STATUS OFF
SET STATUS BAR OFF
CLEAR
SET COLOR to
*
DECLARE m_mis(12,2)
m_mis[1,1]=[ciчень]
m_mis[2,1]=[лютий]
m_mis[3,1]=[бepeзень]
m_mis[4,1]=[квiтень]
m_mis[5,1]=[тpaвень]
m_mis[6,1]=[чepвень]
m_mis[7,1]=[липень]
m_mis[8,1]=[cepпень]
m_mis[9,1]=[вepecень]
m_mis[10,1]=[жовтень]
m_mis[11,1]=[листопад]
m_mis[12,1]=[грудень]
m_mis[1,2]=[ciчня]
m_mis[2,2]=[лютoгo]
m_mis[3,2]=[бepeзня]
m_mis[4,2]=[квiтня]
m_mis[5,2]=[тpaвня]
m_mis[6,2]=[чepвня]
m_mis[7,2]=[липня]
m_mis[8,2]=[cepпня]
m_mis[9,2]=[вepecня]
m_mis[10,2]=[жовтня]
m_mis[11,2]=[листопада]
m_mis[12,2]=[грудня]
*
c_date = DTOC(GOMONTH(DATE(),-1))
c_month = SUBSTR(c_date,4,2)
c_year = SUBSTR(c_date,7,4)
m_period = CTOD([01.]+c_month+[.]+c_year)
*
m_text = []
*
SET DEFAULT TO d:\arm\voda\report8
SET PATH TO d:\arm\voda\report8
*
USE ..\dovvul IN 0 ALIAS dovvul NOUPDATE ORDER vul
USE ..\dovad IN 0 ALIAS dovad  NOUPDATE ORDER kodbk
*
DO FORM rahunok
READ events
CLOSE ALL
CLEAR ALL
*************************
PROCEDURE set_m_text
*************************
m_month = SUBSTR(DTOC(DATE()),4,2)
m_text = [Оплатити до 30 ] + m_mis[VAL(m_month),2] + [.] + CHR(13)
m_text = m_text + [Увага! Вказано заборгованість без врахування субсидій за <вкажіть місяць>]
*
*****************************
FUNCTION print_correct
*****************************
PARAMETERS _str
RETURN CHRTRAN(_str,[ўЎ··їЇ],[іІїЇєЄ])