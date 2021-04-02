declare

  -- Выбор списка разделов
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
     order siblings BY c.address asc  -- Сортировка на одном уровне
     ;

  -- Построение списка страниц из строки с разделителем
  cursor c_pages(p_str varchar2) is
    select regexp_substr(p_str, '[^,]+', 1, level) as tab_name
      from dual
    connect by regexp_substr(p_str, '[^,]+', 1, level) is not null;

  -- Строка для формирования текста запроса
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

  -- Для форматирования вывода
  left_margin varchar2(2000);
  tema_margin constant varchar2(100)   := '      ';
  page_margin constant varchar2(100)   := '      ';
  header_margin constant varchar2(100) := '      ';
 
  -- Таблица для работы с темами
  type t_tab_of_headers is table of t_header_rec index by binary_integer;
  tab_headers t_tab_of_headers;
  
  -- Для работы с ошибками
  type t_tab_errors is table of varchar2(20000) index by binary_integer;
  tab_error t_tab_errors;
  err_count pls_integer;
  
begin
  
  err_count := 0;
  
  -- Обходим разделы с учетом иерерхии
  for c in c_chapter loop
  
    -- Формируем отступ слева для форматирования вывода
    left_margin := lpad(' ', (c.l - 1) * 5, ' ');
  
    -- Вывод раздела
    dbms_output.put_line(left_margin || 'Раздел: ' || c.address);
  
    -- Если указана таблица тем
    if c.subject is not null then

      begin

        -- определяем запрос с учетом названия таблицы тем данного раздела 
        v_ref_cursor_sql := 'select s.subjectid, s.numberofviews, s.name from ' ||c.subject || ' s';

        -- Если вдруг курсор уже открыт, то закрываем
        if c_subj%isopen then
          close c_subj;
        end if;
        
        -- Открываем курсор для обхода всех тем раздела
        open c_subj for v_ref_cursor_sql;
        loop
          
          fetch c_subj into v_rec_subj;
                          
          -- Если обошли все то выходим
          if c_subj%notfound then
            close c_subj;
            exit;
          else
            
            -- Если есть страницы                      
            if c.wpages is not null then

              -- Выводим тему
              dbms_output.put_line(left_margin || tema_margin || 'Тема: ' ||v_rec_subj.name);
            
              for p in c_pages(c.wpages) loop
              
                -- Выводим страницу
                dbms_output.put_line(left_margin || tema_margin ||page_margin ||' Страница: '||p.tab_name);
                
                -- Запрос для выбора первых 5 заголовков по убыванию ответов
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
                
                  -- Немного экономим на переключении контекста
                  open c_header for v_ref_cursor_sql;
                  fetch c_header bulk collect into tab_headers;
                  close c_header;
                  
                  for  i in 1..tab_headers.count loop 
                      -- Выводим заголовки
                      dbms_output.put_line(left_margin || tema_margin ||  page_margin || header_margin||
                                           'Заголовок : ' ||
                                           tab_headers(i).rank || ' ' ||
                                           tab_headers(i).header || ' ' ||
                                           tab_headers(i).answers);
                  end loop;

                exception
                  when others then
                    err_count := err_count +1;
                    tab_error(err_count) := substr('Ошибка при обработке страницы, раздел chapid='||c.chapid||' таблица тем ['|| c.subject||'] страница ['|| p.tab_name||'] '||chr(10)||dbms_utility.format_error_backtrace(),1,2000);
                end;
              
              end loop;
            end if;
          
          end if;
        
        end loop;
      exception
        when others then
             err_count := err_count +1;
             tab_error(err_count) := substr('Ошибка при обработке раздел chapid='||c.chapid||' таблица тем ['|| c.subject||'] '||chr(10)||dbms_utility.format_error_backtrace(),1,2000);
        
      end;
    end if;
  
  end loop;
  
  -- Выводим все ошибки
  if tab_error.count > 0 then
     dbms_output.put_line('------------------------------');
     dbms_output.put_line('Ошибки');
     dbms_output.put_line('------------------------------');

     for i in 1..tab_error.count loop
          dbms_output.put_line(tab_error(i));
     end loop;

  end if;  
  
end;
/