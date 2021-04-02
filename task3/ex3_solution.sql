declare
  v_file_path   varchar2(100) := '.'; -- 'receive\' для тестрования
  v_file_name   varchar2(100) := 'test_file.txt';

  v_file  utl_file.file_type;
  v_buf   varchar2(32767);
  v_code_page varchar2(1000);
  
  Type t_rec is record
  (fio varchar2(250)
  ,dt1 date
  ,dt2 date
  ,tip varchar2(6)  -- отпуск / отгул
  ,kol_day pls_integer -- кол-во дней
  );
  
  type t_tab is table of t_rec index by varchar2(20);
  
  v_tab t_tab;
  v_rec t_rec;
  v_idx varchar2(20);
  
  v_dt date;
  
  v_pos pls_integer;
  v_num_line pls_integer;
  v_fio varchar2(250);
  v_kol_day  varchar2(3);
begin
   v_num_line := 0;

   -- Посмотрим кодировку базы
   SELECT p.value into v_code_page FROM NLS_DATABASE_PARAMETERS p where p.parameter = 'NLS_CHARACTERSET';

   -- Открываем файл
   begin
      v_file := utl_file.fopen(v_file_path, v_file_name,'r');
   exception    
        when utl_file.invalid_path then
            dbms_output.put_line('Ошибка открытия файла, файл не найден '||v_file_path||v_file_name);     
            return;        
        when others then  
        dbms_output.put_line('Ошибка открытия файла '||v_file_path||v_file_name);     
        dbms_output.put_line(sqlerrm);     
        return;

   end;
      
   loop
      v_num_line:= v_num_line +1;
      
      begin
        utl_file.GET_LINE(v_file, v_buf);
          exception
            when no_data_found then
              exit;
      end;
      
      v_buf := convert(v_buf, v_code_page, 'CL8MSWIN1251');
      v_buf := replace(v_buf,chr(10),' ');
      v_buf := replace(v_buf,chr(13),' ');
      v_buf := replace(v_buf,chr(9),' ');
      v_buf := trim(v_buf);
      
      -- Пропускаем пустые строки      
      if v_buf is null then
         continue;
      end if;  
      
--      dbms_output.put_line('v_buf='||v_buf);
      
      v_rec := null;
      
      if regexp_like(v_buf,'^\d{2}\.\d{2}\.\d{4} +\d{2}\.\d{2}\.\d{4} +') then
             -- dbms_output.put_line('Отпуск');
               v_rec.dt1 := TO_DATE(substr(v_buf,1,10),'dd.mm.yyyy');
               
               v_pos := instr(v_buf,' ');
               v_buf := trim(substr(v_buf, v_pos+1));
               v_rec.dt2 := TO_DATE(substr(v_buf,1,10),'dd.mm.yyyy');

               v_pos := instr(v_buf,' ');
               v_rec.fio := trim(substr(v_buf, v_pos+1));
                     
               -- Поменяем даты если они перепутаны
               if v_rec.dt1 > v_rec.dt2 then
                 v_dt := v_rec.dt1;
                 v_rec.dt1 := v_rec.dt2;
                 v_rec.dt2 := v_dt;
               end if;  
               
               v_rec.tip := 'Отпуск';
               v_rec.kol_day := v_rec.dt2 - v_rec.dt1;
      elsif regexp_like(v_buf,'^\d{2}\.\d{2}\.\d{4} +') then
          -- dbms_output.put_line('Отгул');
          v_rec.dt1 := TO_DATE(substr(v_buf,1,10),'dd.mm.yyyy');
          v_pos := instr(v_buf,' ');
          v_rec.fio := trim(substr(v_buf, v_pos+1));
          v_rec.tip := 'Отгул';     
          v_rec.kol_day := 0;
      else
          -- Пропускаем строки не соответствующие формату
          continue;    
      end if;
      
      -- Соберем индекс с нужной сортировкой
      v_kol_day := LPAD(9999-v_rec.kol_day,3,'0');    -- Считаем, что отпуск не может быть больше 9999 дней (27 лет?)

      -- Дата само по себе даст сортировку по возростанию
      -- v_num_line  добавляем для уникальности
      v_idx := TO_CHAR(v_rec.dt1,'yyyymmdd')||v_kol_day||v_num_line;

      -- Добавляем в таблицу
      v_tab(v_idx) := v_rec;    
   end loop;
   
   utl_file.fclose(v_file);
   
   -- Собственно сам вывод списка в нужном порядке
   dbms_output.put_line('Дата                  Дней    Тип ФИО');
   
   v_idx := v_tab.first;
   while v_idx is not null loop
      dbms_output.put_line(TO_CHAR(v_tab(v_idx).dt1,'dd.mm.yyyy')||' '||
                           LPAD(NVL(TO_CHAR(v_tab(v_idx).dt2,'dd.mm.yyyy'),' '),10,' ')||' '||
                           LPAD(v_tab(v_idx).kol_day,4,' ')||' '||
                           LPAD(v_tab(v_idx).tip,6,' ')||' '||
                           v_tab(v_idx).fio
                           );
      v_idx  := v_tab.next(v_idx);
   end loop;  
   
end;