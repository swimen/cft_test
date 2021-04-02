drop sequence tst_seq;
drop table tst_loading_log;
drop table tst_doc_goods;
drop table tst_goods;
drop table tst_units;                          
drop table tst_docs;
drop table tst_doc_strings;
drop table tst_loading_docs;
                          
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

                          

create table tst_docs(doc_num number, doc_date date);

create table tst_doc_strings(doc_num number, good_name varchar2(4000), 
                             unit_name varchar2(10), quantity number, summ number);



create sequence tst_seq START WITH 1  MAXVALUE 999999999999999999999999999  MINVALUE 1 CACHE 100;

create index tst_units_uname_idx on tst_units(UPPER(trim(name)));
create index tst_goods_uname_idx on tst_goods(UPPER(trim(name)));

create index TDS_unit_uname_idx on TST_DOC_STRINGS(UPPER(trim(unit_name)));
create index TDS_good_uname_idx on TST_DOC_STRINGS(UPPER(trim(good_name)));
create index TDS_doc_num_idx on TST_DOC_STRINGS(doc_num);



drop table tst_docs_err;
drop table tst_doc_strings_err;
drop table tst_opers;

create table tst_opers (id number primary key, load_date date);
alter table tst_loading_log add oper_id number;
alter table tst_loading_log add constraint fk_tst_log_oper_id foreign key (oper_id) references tst_opers (id);

create table tst_docs_err(id number primary key, doc_num number, doc_date date, err_info varchar2(4000),oper_id number);
alter table tst_docs_err add constraint fk_tstd_err_oper_id foreign key (oper_id) references tst_opers (id);

create table tst_doc_strings_err(id number primary key,
                                 doc_num number, good_name varchar2(4000), 
                                 unit_name varchar2(10), quantity number, summ number, err_info varchar2(4000), oper_id number);
alter table tst_doc_strings_err add constraint fk_tsts_err_oper_id foreign key (oper_id) references tst_opers (id);

create table tst_loading_docs (id number primary key, doc_num number not null, doc_date date, oper_id number);
create unique index tst_ldocs_num_idx on tst_loading_docs (doc_num);
alter table tst_loading_docs add constraint fk_tst_ldocs_oper_id foreign key (oper_id) references tst_opers (id);


create or replace view v_tst_doc_goods_n as
select d.doc_date, d.doc_num, g.name as good_name, u.name as unit_name,  d.quantity, d.summ
from tst_doc_goods d, 
     tst_loading_log l,
     tst_units u,
     tst_goods g
     where d.id = l.doc_str_id
        and l.load_status = 'NORMAL'
        and d.unit_id = u.id(+)
        and d.good_id = g.id;


create or replace view v_tst_doc_goods_c as
select d.doc_date, d.doc_num, g.name as good_name, u.name as unit_name,  d.quantity, d.summ
from tst_doc_goods d, 
     tst_loading_log l,
     tst_units u,
     tst_goods g
     where d.id = l.doc_str_id
        and l.load_status = 'CRITICAL'
        and d.unit_id = u.id(+)
        and d.good_id = g.id;

-- заполнение исходных данных
delete tst_docs;
delete tst_doc_strings;
insert into tst_docs (doc_num, doc_date)
select 1, sysdate+1 from dual
union all
select 2, sysdate+1 from dual
union all
select null, sysdate+1 from dual
union all
select 2, sysdate+1 from dual
union all
select 2, sysdate+1 from dual
union all
select 2, sysdate+1 from dual
union all
select 2, sysdate+1 from dual
union  all
select 3, sysdate+2 from dual
union  all
select 4, null from dual
union  all
select 5, sysdate+3 from dual
union  all
select 4, null from dual
union  all
select 4, null from dual
union  all
select 7, sysdate+3 from dual
union all
select null, sysdate+5 from dual
union all
select null, sysdate+7 from dual
;

insert into tst_doc_strings(doc_num, good_name, unit_name, quantity, summ)
select 1, 'Товар 1', 'шт', 25.4, 100  from dual
union
select 1, 'Товар 2', 'Шт', 2.4, 111  from dual
union
select 1, '  Товар 2', 'Шт', 2.4, 111  from dual
union
select 2, 'Товар 3', 'Кор', .4, 10  from dual
union
select 2, 'Товар 3.1 ', '', .4, 10  from dual
union
select 3, 'Товар 4', 'ччч', 2, 400  from dual
union
select 3, null, 'ччч', 2, 400  from dual
union
select 12, 'Товар 94', 'ччч', 2, 400  from dual
union
select 4, 'Товар 5', 'Тонна', 5, 10  from dual
union
select null, 'Товар 5', 'Тонна', 5, 10  from dual
union
select 6, 'Товар 6', 'шт', 205, 5600  from dual
union
select 6, 'Товар 6', 'шт', 40, 0  from dual
union
select 2, rpad('Товар 6',1000,'*'), 'шт', 40, 0  from dual;
commit;
/