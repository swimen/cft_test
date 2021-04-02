/*
Условия задачи
1. Заполнить таблицы tst_doc_goods, tst_loading_log, tst_goods, tst_units 
   данными, используя входные данные таблиц tst_docs и tst_doc_strings
2. Таблицы tst_docs и tst_doc_strings не должны содержать никаких данных
   после каждой выгрузки из них.
3. Процедура выгрузки может выполняться многократно, при этом загруженные
   ранее данные теряться не должны.
4. Определить предполагаемый список ошибок загрузки исходя из исходной
   структуры описанной ниже и личного опыта
5. Создать два представления 
5.1 Список загруженных строк без ошибок  
     v_tst_doc_goods_n (дата документа, номер документа, наименование товара,
	                    единица измерения, количество, сумма)
5.2 Список загруженных строк с ошибками.  
     v_tst_doc_goods_c (дата документа, номер документа, наименование товара, 
	                    единица измерения, количество, сумма)
6. Обработка должна быть максимально производительной.
7. Обработка должна быть максимально устойчива и ВСЕГДА должна корректно
   завершиться, если сервер работоспособен.
8. Обязательно прокомментировать код обработки и цель доработки структуры и
   создания новых объектов
9. Остальные условия и ограничения заданы исходной структурой описанной
   ниже

Ограничения и допуски:
1. Структуру, описанную ниже изменять нельзя. 
2. В структуру, описанную ниже можно только добавлять колоники, индексы и
   триггеры.
3. Можно добавлять и использовать любые объекты Oracle, но учитывая пункт 1.
*/
 
-- Структура таблиц для загрузки
drop table tst_loading_log;
drop table tst_doc_goods;
drop table tst_goods;
drop table tst_units;                          
                          
create table tst_goods (id number primary key, name varchar2(500));
create unique index goods_uni on tst_goods (name);
                          
create table tst_units (id number primary key, name varchar2(500));                          
create unique index units_uni on tst_units (name);

create table tst_doc_goods(id number primary key,
                           doc_date date, doc_num number not null, 
                           good_id number not null, unit_id number, 
                           quantity number, summ number);
alter table tst_doc_goods add constraint fk_good_id foreign key (good_id) references tst_goods (id);
alter table tst_doc_goods add constraint fk_unit_id foreign key (unit_id) references tst_units (id);

create table tst_loading_log (id number primary key, 
                          doc_str_id number, 
                          load_status varchar2(8) check (load_status in ('NORMAL', 'CRITICAL')), 
                          log_message varchar2(4000), date_error date);
alter table tst_loading_log add constraint fk_doc_goods_id foreign key (doc_str_id) references tst_doc_goods (id);

                          
-- Исходные данные
drop table tst_docs;
create table tst_docs(doc_num number, doc_date date);
drop table tst_doc_strings;
create table tst_doc_strings(doc_num number, good_name varchar2(4000), 
                             unit_name varchar2(10), quantity number, summ number);
-- заполнение исходных данных
delete tst_docs;
delete tst_doc_strings;
insert into tst_docs (doc_num, doc_date)
select 1, sysdate+1 from dual
union
select 2, sysdate+1 from dual
union
select 3, sysdate+2 from dual
union
select 4, sysdate+3 from dual;
insert into tst_doc_strings(doc_num, good_name, unit_name, quantity, summ)
select 1, 'Товар 1', 'шт', 25.4, 100  from dual
union
select 1, 'Товар 2', 'Шт', 2.4, 111  from dual
union
select 2, 'Товар 3', 'Кор', .4, 10  from dual
union
select 3, 'Товар 4', 'ччч', 2, 400  from dual
union
select 4, 'Товар 5', 'Тонна', 5, 10  from dual
union
select 6, 'Товар 6', 'шт', 205, 5600  from dual
union
select 6, 'Товар 6', 'шт', 40, 0  from dual;
commit;

