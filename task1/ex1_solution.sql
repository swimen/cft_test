declare

  -- ����� ������ ��������
  cursor c_chapter is
    select c.chapid,
           c.par_chapid,
           c.subject,
           c.wpages,
           c.address,
           level as l
      from chapters c
    connect by prior c.chapid = c.par_chapid
     start with c.par_chapid is null
     order siblings BY c.address asc  -- ���������� �� ����� ������
     ;

  -- ���������� ������ ������� �� ������ � ������������
  cursor c_pages(p_str varchar2) is
    select regexp_substr(p_str, '[^,]+', 1, level) as tab_name
      from dual
    connect by regexp_substr(p_str, '[^,]+', 1, level) is not null;

  -- ������ ��� ������������ ������ �������
  v_ref_cursor_sql varchar2(1000);

  type t_subj_rec is record(
    subjectid     number,
    numberofviews number(10),
    name          varchar2(200));

  type t_header_rec is record(
    header  varchar2(1000),
    answers number,
    rank    number);

  v_rec_subj t_subj_rec;
  v_rec_header t_header_rec;

  TYPE t_subj_rc IS REF CURSOR;
  TYPE t_header_rc IS REF CURSOR;

  c_subj t_subj_rc;
  c_header t_header_rc;

  -- ��� �������������� ������
  left_margin varchar2(2000);
  tema_margin constant varchar2(100)   := '      ';
  page_margin constant varchar2(100)   := '      ';
  header_margin constant varchar2(100) := '      ';
 
  -- ������� ��� ������ � ������
  type t_tab_of_headers is table of t_header_rec index by binary_integer;
  tab_headers t_tab_of_headers;
  
  -- ��� ������ � ��������
  type t_tab_errors is table of varchar2(20000) index by binary_integer;
  tab_error t_tab_errors;
  err_count pls_integer;
  
begin
  
  err_count := 0;
  
  -- ������� ������� � ������ ��������
  for c in c_chapter loop
  
    -- ��������� ������ ����� ��� �������������� ������
    left_margin := lpad(' ', (c.l - 1) * 5, ' ');
  
    -- ����� �������
    dbms_output.put_line(left_margin || '������: ' || c.address);
  
    -- ���� ������� ������� ���
    if c.subject is not null then

      begin

        -- ���������� ������ � ������ �������� ������� ��� ������� ������� 
        v_ref_cursor_sql := 'select s.subjectid, s.numberofviews, s.name from ' ||c.subject || ' s';

        -- ���� ����� ������ ��� ������, �� ���������
        if c_subj%isopen then
          close c_subj;
        end if;
        
        -- ��������� ������ ��� ������ ���� ��� �������
        open c_subj for v_ref_cursor_sql;
        loop
          
          fetch c_subj into v_rec_subj;
                          
          -- ���� ������ ��� �� �������
          if c_subj%notfound then
            close c_subj;
            exit;
          else
            
            -- ���� ���� ��������                      
            if c.wpages is not null then

              -- ������� ����
              dbms_output.put_line(left_margin || tema_margin || '����: ' ||v_rec_subj.name);
            
              for p in c_pages(c.wpages) loop
              
                -- ������� ��������
                dbms_output.put_line(left_margin || tema_margin ||page_margin ||' ��������: '||p.tab_name);
                
                -- ������ ��� ������ ������ 5 ���������� �� �������� �������
                v_ref_cursor_sql := 'select t.header, t.answers, dr from (' ||
                                    ' select p.header   ' ||
                                    '        ,p.answers ' ||
                                    '        ,DENSE_RANK() over (order by answers desc) dr from ' ||
                                    p.tab_name || ' p ' ||
                                    ' where subject = ' || v_rec_subj.subjectid || ') t ' ||
                                    ' where dr <=5 order by dr';
                begin
                   
                  if c_header%isopen then
                    close c_header;
                  end if;
                
                  -- ������� �������� �� ������������ ���������
                  open c_header for v_ref_cursor_sql;
                  fetch c_header bulk collect into tab_headers;
                  close c_header;
                  
                  for  i in 1..tab_headers.count loop 
                      -- ������� ���������
                      dbms_output.put_line(left_margin || tema_margin ||  page_margin || header_margin||
                                           '��������� : ' ||
                                           tab_headers(i).rank || ' ' ||
                                           tab_headers(i).header || ' ' ||
                                           tab_headers(i).answers);
                  end loop;

                exception
                  when others then
                    err_count := err_count +1;
                    tab_error(err_count) := substr('������ ��� ��������� ��������, ������ chapid='||c.chapid||' ������� ��� ['|| c.subject||'] �������� ['|| p.tab_name||'] '||chr(10)||dbms_utility.format_error_backtrace(),1,2000);
                end;
              
              end loop;
            end if;
          
          end if;
        
        end loop;
      exception
        when others then
             err_count := err_count +1;
             tab_error(err_count) := substr('������ ��� ��������� ������ chapid='||c.chapid||' ������� ��� ['|| c.subject||'] '||chr(10)||dbms_utility.format_error_backtrace(),1,2000);
        
      end;
    end if;
  
  end loop;
  
  -- ������� ��� ������
  if tab_error.count > 0 then
     dbms_output.put_line('------------------------------');
     dbms_output.put_line('������');
     dbms_output.put_line('------------------------------');

     for i in 1..tab_error.count loop
          dbms_output.put_line(tab_error(i));
     end loop;

  end if;  
  
end;
/