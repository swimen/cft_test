/*
������� ������
1. ��������� ������� tst_doc_goods, tst_loading_log, tst_goods, tst_units 
   �������, ��������� ������� ������ ������ tst_docs � tst_doc_strings
2. ������� tst_docs � tst_doc_strings �� ������ ��������� ������� ������
   ����� ������ �������� �� ���.
3. ��������� �������� ����� ����������� �����������, ��� ���� �����������
   ����� ������ �������� �� ������.
4. ���������� �������������� ������ ������ �������� ������ �� ��������
   ��������� ��������� ���� � ������� �����
5. ������� ��� ������������� 
5.1 ������ ����������� ����� ��� ������  
     v_tst_doc_goods_n (���� ���������, ����� ���������, ������������ ������,
	                    ������� ���������, ����������, �����)
5.2 ������ ����������� ����� � ��������.  
     v_tst_doc_goods_c (���� ���������, ����� ���������, ������������ ������, 
	                    ������� ���������, ����������, �����)
6. ��������� ������ ���� ����������� ����������������.
7. ��������� ������ ���� ����������� ��������� � ������ ������ ���������
   �����������, ���� ������ ��������������.
8. ����������� ����������������� ��� ��������� � ���� ��������� ��������� �
   �������� ����� ��������
9. ��������� ������� � ����������� ������ �������� ���������� ���������
   ����

����������� � �������:
1. ���������, ��������� ���� �������� ������. 
2. � ���������, ��������� ���� ����� ������ ��������� ��������, ������� �
   ��������.
3. ����� ��������� � ������������ ����� ������� Oracle, �� �������� ����� 1.
*/
 
-- ��������� ������ ��� ��������
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

                          
-- �������� ������
drop table tst_docs;
create table tst_docs(doc_num number, doc_date date);
drop table tst_doc_strings;
create table tst_doc_strings(doc_num number, good_name varchar2(4000), 
                             unit_name varchar2(10), quantity number, summ number);
-- ���������� �������� ������
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
select 1, '����� 1', '��', 25.4, 100  from dual
union
select 1, '����� 2', '��', 2.4, 111  from dual
union
select 2, '����� 3', '���', .4, 10  from dual
union
select 3, '����� 4', '���', 2, 400  from dual
union
select 4, '����� 5', '�����', 5, 10  from dual
union
select 6, '����� 6', '��', 205, 5600  from dual
union
select 6, '����� 6', '��', 40, 0  from dual;
commit;

