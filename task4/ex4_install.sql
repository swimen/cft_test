drop table journal;
drop table records;
drop table products;
drop table catalog;

drop table persons;
drop table units;

create table catalog (cid number primary key, -- id �������
 par_cid number references catalog, -- ������ �� ������������ ������
 rname varchar2(400), -- ������������ �������
 rdescr varchar2(4000), -- ��������
 rcdate date -- ���� ��������
 );
 
create table persons (pid number primary key, pname varchar2(400));

create table units (id number primary key, uname varchar2(500));
 
create table products (pid number primary key, -- id ��������
rcid number references catalog, -- ������ �� �������
pname varchar2(500), -- ������������ ��������
pdescr varchar2(4000), -- ������������
punit number references units, -- ������� ���������
pper number references persons -- �������������
);


create table records (rpid number references products, -- �������
 rdate date, -- ���� ��������
 incoming varchar2(2) default '1', -- ����������� '1', ������ '0'
 quantity number, -- ����������
 rate number -- ���� � ������
 );


insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )  values(1, null, '������ 1', '�������� ������� 1',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(2, null, '������ 2', '�������� ������� 2',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(3, null, '������ 3', '�������� ������� 3',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(4, 1, '������ 1.1', '�������� ������� 1.1',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(5, 1, '������ 1.2', '�������� ������� 1.2',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(6, 1, '������ 1.3', '�������� ������� 1.3',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(7, 5, '������ 1.2.1', '�������� ������� 1.2.1',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(8, 5, '������ 1.2.2', '�������� ������� 1.2.2',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(9, 7, '������ 1.2.1.1', '�������� ������� 1.2.1.1',sysdate);


insert into units(id , uname) values(1, '����');
insert into units(id , uname) values(2, '��');

insert into persons(Pid , pname) values(1, '������');
insert into persons(Pid , pname) values(2, '������');

insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (1, 2, '�����','�������� �����',1,1);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (2, 6, '������','�������',2,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (3, 6, '������','�������',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (4, 4, '������','�����',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (5, 4, '������','�����',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (6, 8, '�����','�����',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper)  values (7, 8, '�����','�����',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (8, 9, '������','�����',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (9, 9, '����','�����',1,2);


insert into records (rpid, rdate, incoming, quantity, rate) values (1, sysdate-1, '1', 10, 7); 
insert into records (rpid, rdate, incoming, quantity, rate) values (1, sysdate,    '0', 5, 15); 
insert into records (rpid, rdate, incoming, quantity, rate) values (2, sysdate-1, '1', 10, 4); 
insert into records (rpid, rdate, incoming, quantity, rate) values (2, sysdate,    '0', 5, 8); 
insert into records (rpid, rdate, incoming, quantity, rate) values (3, sysdate-1, '1', 10, 4); 
insert into records (rpid, rdate, incoming, quantity, rate) values (3, sysdate,    '0', 5, 8); 
insert into records (rpid, rdate, incoming, quantity, rate) values (4, sysdate-1, '1', 110, 4); 
insert into records (rpid, rdate, incoming, quantity, rate) values (4, sysdate,    '0', 52, 6); 
insert into records (rpid, rdate, incoming, quantity, rate) values (5, sysdate-1, '1', 10, 44); 
insert into records (rpid, rdate, incoming, quantity, rate) values (5, sysdate,    '0', 2, 62); 
insert into records (rpid, rdate, incoming, quantity, rate) values (6, sysdate-1, '1', 10, 44); 
insert into records (rpid, rdate, incoming, quantity, rate) values (6, sysdate,    '0', 2, 62); 
insert into records (rpid, rdate, incoming, quantity, rate) values (7, sysdate-1, '1', 10, 14); 
insert into records (rpid, rdate, incoming, quantity, rate) values (7, sysdate,    '0', 2, 22); 
insert into records (rpid, rdate, incoming, quantity, rate) values (8, sysdate-1, '1', 7, 13); 
insert into records (rpid, rdate, incoming, quantity, rate) values (8, sysdate,    '0', 3, 26); 
COMMIT;
/
