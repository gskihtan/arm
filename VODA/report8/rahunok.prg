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
m_mis[1,1]=[ci����]
m_mis[2,1]=[�����]
m_mis[3,1]=[�epe����]
m_mis[4,1]=[��i����]
m_mis[5,1]=[�pa����]
m_mis[6,1]=[�ep����]
m_mis[7,1]=[������]
m_mis[8,1]=[cep����]
m_mis[9,1]=[�epec���]
m_mis[10,1]=[�������]
m_mis[11,1]=[��������]
m_mis[12,1]=[�������]
m_mis[1,2]=[ci���]
m_mis[2,2]=[���o�o]
m_mis[3,2]=[�epe���]
m_mis[4,2]=[��i���]
m_mis[5,2]=[�pa���]
m_mis[6,2]=[�ep���]
m_mis[7,2]=[�����]
m_mis[8,2]=[cep���]
m_mis[9,2]=[�epec��]
m_mis[10,2]=[������]
m_mis[11,2]=[���������]
m_mis[12,2]=[������]
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
m_text = [�������� �� 30 ] + m_mis[VAL(m_month),2] + [.] + CHR(13)
m_text = m_text + [�����! ������� ������������� ��� ���������� ������� �� <������ �����>]
*
*****************************
FUNCTION print_correct
*****************************
PARAMETERS _str
RETURN CHRTRAN(_str,[������],[������])