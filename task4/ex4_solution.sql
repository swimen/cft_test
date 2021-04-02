WITH s0 as 
(select c.cid 
       ,c.par_cid
       ,c.rname -- ������ �������� ��� ������������ ��������
       ,null as pid
       ,DECODE (d.l, 1, 'open', 'close') as tag
       ,null as inc
       ,null as out
       ,null as incm
       ,null as outm  
  from catalog c, 
       -- ��� ���� ����� ������������ ����������� ������ �� ������ ��������
       (select level l from dual connect by level <=2) d 
 union all
   select null 
         ,p.rcid -- ������ �� ��������
         ,p.pname
         ,p.pid 
         ,'' as tag,
        sum(nvl(r.quantity*r.incoming,0)) as inc, 
        sum(nvl(r.quantity*(r.incoming-1),0)) as out,
        sum(nvl(r.rate*r.quantity*r.incoming,0)) as incm,
        sum(nvl(r.quantity*(r.incoming-1),0)) as outm
    from products  p, records r 
    where r.rpid(+)=p.pid -- ����� �������, ��� ������ �������� �� ��������
    group by p.rcid, p.pid, p.pname
 ) 
 select lpad(' ',level*5,' ')||'<'||s.rname||'>'||
 ' || ����������� ���. '||DECODE(s.cid, null, s.incm, 
                                 -- ��������� ����� �� ���� �������� �������
                                (select nvl(sum(ss.incm),0) from s0 ss connect by ss.par_cid = prior ss.cid and prior ss.tag = 'open' start with ss.cid=s.cid)
                            )||
 ' || ������ ���. '||DECODE(s.cid, null, s.outm, 
                                (select nvl(sum(ss.outm),0) from s0 ss connect by ss.par_cid = prior ss.cid and prior ss.tag = 'open' start with ss.cid=s.cid)
                    )||
 DECODE(s.cid,null, ' || ����������� '||s.inc||' || ������ '||s.out||'|| ������� '||TO_CHAR(s.inc + s.out),'') as out_rez
-- , s.cid, s.pid, s.par_cid, s.tag, 
-- (select nvl(sum(ss.incm),0) from s0 ss connect by ss.par_cid = prior ss.cid and prior ss.tag = 'open' start with ss.cid=s.cid)    as sum_inc,
-- (select nvl(sum(ss.outm),0) from s0 ss connect by ss.par_cid = prior ss.cid and prior ss.tag = 'open' start with ss.cid=s.cid)    as sum_out,
-- s.inc, 
-- s.out, 
-- s.incm,
-- s.outm
 from s0 s
 connect by s.par_cid = prior s.cid and prior s.tag = 'open' start with s.par_cid is null
 ORDER siblings BY cid,  DECODE(s.tag,'open',1,2)
/
