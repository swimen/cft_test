select p.id, p.name, 
       -- ���� ������ �� �������, �� ��������� 0      
       DECODE(t.PER_ID, null, 0, COUNT(*)) as kol
from
(-- �������� ���� ����� �� ����, ����� ��������� ��� �� ������ 
 select j.per_id
        ,min(j.dtime) as min_for_day
    from journal j 
   where 
     -- ����������� ������ ����    
         j.type = '0'
     -- ������� ��� ������ ������� 
     and j.dtime between TO_DATE('01.03.2018','dd.mm.yyyy') and TO_DATE('31.03.2018 23:59:59','dd.mm.yyyy hh24:mi:ss')
     -- ��������� �������� ���
     and  TRIM(TO_CHAR (j.dtime,'DAY', 'NLS_DATE_LANGUAGE = RUSSIAN')) not in ('�������','�����������')     
 group by j.per_id, TRUNC(j.dtime) 
 ) t,
 persons p
where 
    -- ������� ��� ������� ���� ���������� � 07:00
    t.min_for_day(+) > TRUNC(t.min_for_day(+))+7*1/24
and p.id = t.per_id(+) -- ��������� ����� �� ���� �� ����� �� ���� ������
GROUP BY p.id, p.name, t.PER_ID
Order by DECODE(t.PER_ID,null,0, COUNT(*)) desc, p.name
/


