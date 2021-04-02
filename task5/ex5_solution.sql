create or replace procedure tst_load is

v_loc       varchar2(30);
v_rez       number;
max_id      number;
tek_val_id  number;
max_row_count     constant pls_integer := 3;  -- 3 ��� �����, �� ���������� 10000
v_oper_id   number;
v_proc_count      number;

-- ������� ������� ������� (��������� ������ ������)
cursor c_string(p_oper number) is
select   s.rowid as r
        ,s.doc_num
        ,d.doc_date
        ,s.good_name
        ,s.unit_name
        ,s.quantity
        ,s.summ
        ,g.id as good_id
        ,u.id as unit_id
        ,case when
          u.id is not null and d.doc_date is not null and s.quantity is not null and s.summ is not null then 'NORMAL'
          else 'CRITICAL'
          end as status
        , decode(u.id,       null,'unit_id is null, ','')||
          decode(d.doc_date, null,'doc_date is null, ','')||
          decode(s.quantity, null,'quantity is null, ','')||
          decode(s.summ,     null,'summ is null, ','')
        as err_msg
  from tst_doc_strings s
      ,tst_goods g
      ,tst_units u
      ,tst_loading_docs d
   where upper(trim((s.good_name))) = upper(trim(g.name))
     and upper(trim((s.unit_name))) = upper(trim(u.name(+))) -- ����� ���� �������
     and s.doc_num = d.doc_num
     and d.oper_id = p_oper -- �������� ������ � ����������� �� ������� �������� ��������
     and rownum < max_row_count;

-- ������� ���� �������, � ������������ ������
cursor c_string_err(p_oper number) is
select   s.rowid as r
        ,s.doc_num
        ,d.doc_date
        ,s.good_name
        ,s.unit_name
        ,s.quantity
        ,s.summ
        ,g.id as good_id
        ,u.id as unit_id
        ,'ERROR' as  status
        , decode(g.id,       null,'good_id is null, ','')||
          decode(u.id,       null,'unit_id is null, ','')||
          decode(d.doc_date, null,'doc_date is null, ','')||
          decode(s.quantity, null,'quantity is null, ','')||
          decode(s.summ,     null,'summ is null, ','')||
          decode(s.doc_num,  null,'doc_num is null, ','')||
          decode(d.doc_num,  null,'tst_docs.doc_num is null, ','')||
          decode( substr(trim(s.good_name),501),null , '' , 'length(good_name) > 500, ')
        as err_msg
  from tst_doc_strings s
      ,tst_goods g
      ,tst_units u
      ,tst_loading_docs d
   where upper(trim((s.good_name))) = upper(trim(g.name(+)))
     and upper(trim((s.unit_name))) = upper(trim(u.name(+)))
     and s.doc_num = d.doc_num(+)
     and d.oper_id(+) = p_oper
     and rownum < max_row_count;

Type t_tab_string is table of c_string%rowtype index by binary_integer;

Tab_string      t_tab_string;
Tab_string_err  t_tab_string;

-- ������ ���� ������� �� tst_docs
cursor c_all_docs is 
 select doc_num
       ,doc_date
   from tst_docs;

Type t_all_docs is table of c_all_docs%rowtype index by binary_integer;
Tab_all_docs      t_all_docs;
tab_all_docs_err  t_all_docs;


Type t_number is table of number index by binary_integer;
Type t_string is table of varchar2(4000) index by binary_integer;
Type t_s8     is table of varchar2(8) index by binary_integer;


Tab_doc_id t_number;
Tab_err_id t_number;
Tab_err_msg t_string;

Tab_log_status   t_s8;
Tab_log_message  t_string;

begin

  -- �������� �������� ����������
  dbms_lock.allocate_unique(lockname => 'tst_docs_loading',lockhandle => v_loc);
  v_rez := dbms_lock.release(v_loc);

  v_rez := dbms_lock.request(v_loc, dbms_lock.X_MODE, 0);

  if   v_rez <> 0 then
       dbms_output.put_line('�������� ������������� ������ ���������');
       return;
  end if;

  insert into tst_opers(id, LOAD_DATE) values (tst_seq.nextval, sysdate) returning id into v_oper_id;

  commit;

  -- ��� ����� �������� ������������������ � ������������ � �������� ���������� ������������
  select max(id) into max_id from
  (
  select max(NVL(id,1)) id from tst_goods
  union
  select max(NVL(id,1)) from tst_units
  union
  select max(NVL(id,1)) from tst_doc_goods
  union
  select max(NVL(id,1)) from tst_loading_log
  );

  -- �������� ������������������ ������������� �������� �� �����
  tek_val_id := tst_seq.nextval;
  if max_id > tek_val_id then
     for r in (select tst_seq.nextval from dual connect by level <= (max_id - tek_val_id +1)) loop
        null;
     end loop;
  end if;


 -- ��������� ���������� ������ ���������, �������� ��� ����� ������
 -- ������� ��� ������� �� ������� ���������� ������
 begin
    insert into tst_units(id, name)
    (select tst_seq.nextval, unit_name
      from(
           -- �������� �������� ������� ��� ��� � �����������           
	   select distinct  upper(trim(s.unit_name)) unit_name
             from tst_doc_strings s
                 ,tst_units  u
            where upper(trim(s.unit_name)) = upper(trim(u.name(+)))
             and upper(trim(s.unit_name)) is not null
             and u.id is null)
          );
     dbms_output.put_line('��������� � tst_units '||sql%rowcount);

    commit;
  exception
    when others then
     dbms_output.put_line('������ ��� ���������� ����������� ������ ��������� '||sqlerrm);
     -- �� ��������� �������� ����������� ������ ����� ��� ������� � tst_doc_goods
  end;

  -- ��������� ���������� ������������ �������
  -- �� ������ ���� ������� ����� ����� ������� ���� � �������� �� ���-��
  begin
    loop

     insert into tst_goods(id, name)
      (select tst_seq.nextval, good_name
         from(
             -- �������� �������� ������� ��� ��� � �����������
             select distinct  upper(trim(s.good_name)) good_name
               from tst_doc_strings s
                   ,tst_goods  g
              where upper(trim(s.good_name)) = upper(trim(g.name(+)))
               and length(trim(s.good_name)) <=500
               and trim(s.good_name) is not null
               and g.id is null
               and rownum < max_row_count
           )
       );

      dbms_output.put_line('��������� � tst_goods '||sql%rowcount);
      exit when sql%rowcount = 0;
      commit;
    end loop;
  exception
    when others then
     -- �� ��������� �������� ����������� ������ ����� ��� ������� � tst_doc_goods
     dbms_output.put_line('������ ��� ���������� ����������� ������������ ������� '||sqlerrm);
  end;

  -- ��������� �������� �� tst_docs
  -- ��� �������� � ���� ������������� ����������� �� ������� tst_loading_docs
  -- �������� ��� ����� ��������� �� ������ � ����������
  dbms_output.put_line('��������� �������� �� tst_docs');
  begin
    open c_all_docs;
    loop
         fetch c_all_docs bulk collect into tab_all_docs limit max_row_count;
         exit when c_all_docs%notfound;
         tab_err_id.delete;
         tab_err_msg.delete;
         tab_all_docs_err.delete;
         
         begin
           forall i in 1..tab_all_docs.count SAVE EXCEPTIONS
             insert into tst_loading_docs (id, doc_num, doc_date, oper_id) 
             values (tst_seq.nextval, tab_all_docs(i).doc_num, tab_all_docs(i).doc_date, v_oper_id);

         exception
         when others then
            
            -- �������� �������� �� �������
           for i in 1..SQL%BULK_EXCEPTIONS.COUNT loop
              tab_err_id(i) := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
              tab_all_docs_err(i) := tab_all_docs(tab_err_id(i));
              tab_err_msg(i) := sqlerrm( -SQL%BULK_EXCEPTIONS(i).ERROR_CODE);
           end loop;           
         end;       
         
        -- ���������� ������
        forall i in 1..tab_all_docs_err.count 
            insert into tst_docs_err(id, doc_num, doc_date, err_info, oper_id)
            values (tst_seq.nextval
                   ,tab_all_docs_err(i).doc_num
                   ,tab_all_docs_err(i).doc_date
                   ,Tab_err_msg(i)
                   ,v_oper_id
                   );        
        
        commit;
        
    end loop;
    close c_all_docs;
  -- ��������� ������ �� ������, ���� ��� �� ��������� �� ����� �������� ��� ��� ����� ����� � �����������   
  end;
  

  -- ����� ����� ������������ �������� ������
  
  begin
   dbms_output.put_line('�������� tst_doc_strings ...');
   v_proc_count := 0;
  loop
    
    -- ����� �������� ������� � ������� ��������� ��� ������� ������� ��������
    -- ����� ������ ��� ��������� ������ � ������� ������������ ������
    open c_string(v_oper_id);
    fetch c_string bulk collect into Tab_string;
    close c_string;
    
    v_proc_count := v_proc_count  + Tab_string.count;
    dbms_output.put_line('   ������� ������� '||v_proc_count);

    exit when Tab_string.count = 0;

    Tab_string_err.delete;
    tab_err_msg.delete;
    tab_err_id.delete;

    begin
    dbms_output.put_line('������� ������� � tst_doc_goods');
    forall i in 1..Tab_string.count SAVE EXCEPTIONS
      insert into tst_doc_goods(id
                               ,doc_date
                               ,doc_num
                               ,good_id
                               ,unit_id
                               ,quantity
                               ,summ)
         values(tst_seq.nextval
               ,Tab_string(i).doc_date
               ,Tab_string(i).doc_num
               ,Tab_string(i).good_id
               ,Tab_string(i).unit_id
               ,Tab_string(i).quantity
               ,Tab_string(i).summ)
        returning id, Tab_string(i).status, Tab_string(i).err_msg  BULK COLLECT INTO Tab_doc_id, Tab_log_status, Tab_log_message;


    exception
     when others then
        dbms_output.put_line('������ '||SQL%BULK_EXCEPTIONS.COUNT);
        -- �������� �������� �� �������
        for i in 1..SQL%BULK_EXCEPTIONS.COUNT loop
            tab_err_id(i) := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
            Tab_string_err(i) := Tab_string(tab_err_id(i));
            tab_err_msg(i) := sqlerrm( -SQL%BULK_EXCEPTIONS(i).ERROR_CODE);
        end loop;

     end;

     if Tab_string_err.count>0 then
         dbms_output.put_line('���������� ������');
     end if;  
        
     -- ���������� ������
     forall i in 1..Tab_string_err.count
            insert into tst_doc_strings_err(id, doc_num, good_name, unit_name, quantity, summ, err_info, oper_id
            )
            values (tst_seq.nextval
                   ,Tab_string_err(i).doc_num
                   ,Tab_string_err(i).good_name
                   ,Tab_string_err(i).unit_name
                   ,Tab_string_err(i).quantity
                   ,Tab_string_err(i).summ
                   ,Tab_err_msg(i)
                   ,v_oper_id
                   );


       dbms_output.put_line('������� ������������ ������ �� tst_doc_strings');

       -- ������� ������������ ������
       forall i in 1..Tab_string.count
         delete from tst_doc_strings s where s.rowid = Tab_string(i).r;


       dbms_output.put_line('��������� ������ �� ������� ����������� � tst_loading_log');
        -- ��������� ������ �� ������� �����������
        forall i in INDICES OF Tab_doc_id
           insert into tst_loading_log(id
                                      ,doc_str_id
                                      ,load_status
                                      ,log_message
                                      ,date_error
                                      ,oper_id
                                      )
                            values(tst_seq.nextval
                                  ,Tab_doc_id(i)
                                  ,Tab_log_status(i)
                                  ,Tab_log_message(i)
                                  ,sysdate
                                  ,v_oper_id
                                  );

    -- commit ����� ��������� ��������� ������
    commit;
  end loop;

  exception
     when others then
     rollback to sp1;
     dbms_output.put_line('������ ��� ��������� ������� tst_doc_strings : '||sqlerrm);
  end;

  -- ��� ������, ������� �������� � tst_doc_strings  ��������� � tst_doc_strings_err
  dbms_output.put_line('������������ ��������� ������ �� tst_doc_strings');
  loop

    open  c_string_err(v_oper_id);
    fetch c_string_err bulk collect into Tab_string;
    close c_string_err;

    exit when Tab_string.count = 0;

    -- ������� � tst_doc_strings_err
    forall i in 1..Tab_string.count
        insert into tst_doc_strings_err(id, doc_num, good_name, unit_name, quantity, summ, err_info, oper_id)
            values (tst_seq.nextval
                   ,Tab_string(i).doc_num
                   ,Tab_string(i).good_name
                   ,Tab_string(i).unit_name
                   ,Tab_string(i).quantity
                   ,Tab_string(i).summ
                   ,Tab_string(i).err_msg
                   ,v_oper_id
                   );

     -- ������� ������������ ������ �� tst_doc_strings
     forall i in 1..Tab_string.count
       delete from tst_doc_strings s where s.rowid = Tab_string(i).r;

     commit;
  end loop;

  -- �������� �������
  execute immediate 'truncate table tst_doc_strings';
  execute immediate 'truncate table tst_docs';


v_rez := dbms_lock.release(v_loc);
exception

when others then
  rollback; 
  dbms_output.put_line(sqlerrm);
  v_rez := dbms_lock.release(v_loc);
end;
/

