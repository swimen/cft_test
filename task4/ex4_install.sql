drop table journal;
drop table records;
drop table products;
drop table catalog;

drop table persons;
drop table units;

create table catalog (cid number primary key, -- id раздела
 par_cid number references catalog, -- ссылка на родительский раздел
 rname varchar2(400), -- наименование раздела
 rdescr varchar2(4000), -- описание
 rcdate date -- дата создания
 );
 
create table persons (pid number primary key, pname varchar2(400));

create table units (id number primary key, uname varchar2(500));
 
create table products (pid number primary key, -- id продукта
rcid number references catalog, -- ссылка на каталог
pname varchar2(500), -- наименование продукта
pdescr varchar2(4000), -- спецификация
punit number references units, -- единица измерения
pper number references persons -- ответственный
);


create table records (rpid number references products, -- продукт
 rdate date, -- дата операции
 incoming varchar2(2) default '1', -- поступление '1', расход '0'
 quantity number, -- количество
 rate number -- цена в рублях
 );


insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )  values(1, null, 'Раздел 1', 'Описание раздела 1',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(2, null, 'Раздел 2', 'Описание раздела 2',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(3, null, 'Раздел 3', 'Описание раздела 3',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(4, 1, 'Раздел 1.1', 'Описание раздела 1.1',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(5, 1, 'Раздел 1.2', 'Описание раздела 1.2',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(6, 1, 'Раздел 1.3', 'Описание раздела 1.3',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(7, 5, 'Раздел 1.2.1', 'Описание раздела 1.2.1',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(8, 5, 'Раздел 1.2.2', 'Описание раздела 1.2.2',sysdate);
insert into catalog(cid , par_cid ,  rname ,  rdescr , rcdate )   values(9, 7, 'Раздел 1.2.1.1', 'Описание раздела 1.2.1.1',sysdate);


insert into units(id , uname) values(1, 'Штук');
insert into units(id , uname) values(2, 'Кг');

insert into persons(Pid , pname) values(1, 'Петров');
insert into persons(Pid , pname) values(2, 'Иванов');

insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (1, 2, 'Лапша','описание лапши',1,1);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (2, 6, 'Арбузы','зеленые',2,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (3, 6, 'Яблоки','красные',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (4, 4, 'Краска','новая',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (5, 4, 'Бензин','новая',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (6, 8, 'Спирт','новая',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper)  values (7, 8, 'Туфли','новая',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (8, 9, 'Сапоги','новая',1,2);
insert into products (pid, rcid, pname, pdescr, punit, pper) 
values (9, 9, 'Зонт','новая',1,2);


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
