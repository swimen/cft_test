select p.id, p.name, 
       -- Если ниразу не выходил, то опозданий 0      
       DECODE(t.PER_ID, null, 0, COUNT(*)) as kol
from
(-- Выбираем дату входа за день, когда сотрудник был на работе 
 select j.per_id
        ,min(j.dtime) as min_for_day
    from journal j 
   where 
     -- Анализируем только вход    
         j.type = '0'
     -- Условие для выбора периода 
     and j.dtime between TO_DATE('01.03.2018','dd.mm.yyyy') and TO_DATE('31.03.2018 23:59:59','dd.mm.yyyy hh24:mi:ss')
     -- Исключаем выходные дни
     and  TRIM(TO_CHAR (j.dtime,'DAY', 'NLS_DATE_LANGUAGE = RUSSIAN')) not in ('СУББОТА','ВОСКРЕСЕНЬЕ')     
 group by j.per_id, TRUNC(j.dtime) 
 ) t,
 persons p
where 
    -- Считаем что рабочий день начинается в 07:00
    t.min_for_day(+) > TRUNC(t.min_for_day(+))+7*1/24
and p.id = t.per_id(+) -- Сотрудник может ни разу не выйти за весь период
GROUP BY p.id, p.name, t.PER_ID
Order by DECODE(t.PER_ID,null,0, COUNT(*)) desc, p.name
/


