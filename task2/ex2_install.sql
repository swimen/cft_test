drop table Journal;
drop table Persons;


create table Persons (id number primary key, Name varchar2(150));

create table Journal
(id number primary key
,Per_id number references Persons
,Dtime date
,Type varchar2(1)
);

Insert into Persons (id, name) values (1, 'Иванов');
Insert into Persons (id, name) values (2, 'Петров');
Insert into Persons (id, name) values (3, 'Сидоров');
Insert into Persons (id, name) values (4, 'Орлов');
Insert into Persons (id, name) values (5, 'Скворцов');
Insert into Persons (id, name) values (6, 'Грачев');

Insert into Journal (id, per_id, Dtime , Type)  values (1,1, TO_DATE('17.03.2018 12:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (2,1, TO_DATE('17.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');
Insert into Journal (id, per_id, Dtime , Type)  values (3,1, TO_DATE('18.03.2018 07:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (4,1, TO_DATE('18.03.2018 08:00:00','dd.mm.yyyy hh24:mi:ss'),'1');
Insert into Journal (id, per_id, Dtime , Type)  values (5,1, TO_DATE('18.03.2018 11:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (6,1, TO_DATE('18.03.2018 20:00:00','dd.mm.yyyy hh24:mi:ss'),'1');

Insert into Journal (id, per_id, Dtime , Type)  values (7,1, TO_DATE('15.03.2018 07:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (8,1, TO_DATE('15.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');
Insert into Journal (id, per_id, Dtime , Type)  values (9,1, TO_DATE('15.03.2018 15:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (10,1, TO_DATE('15.03.2018 18:00:00','dd.mm.yyyy hh24:mi:ss'),'1');

Insert into Journal (id, per_id, Dtime , Type)  values (11,1, TO_DATE('13.03.2018 05:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (12,1, TO_DATE('13.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');


Insert into Journal (id, per_id, Dtime , Type)  values (19,2, TO_DATE('15.03.2018 10:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (20,2, TO_DATE('15.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');
Insert into Journal (id, per_id, Dtime , Type)  values (21,2, TO_DATE('15.03.2018 15:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (22,2, TO_DATE('15.03.2018 18:00:00','dd.mm.yyyy hh24:mi:ss'),'1');
Insert into Journal (id, per_id, Dtime , Type)  values (23,2, TO_DATE('13.03.2018 12:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (24,2, TO_DATE('13.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');



Insert into Journal (id, per_id, Dtime , Type)  values (25,3, TO_DATE('15.03.2018 05:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (26,3, TO_DATE('15.03.2018 06:00:00','dd.mm.yyyy hh24:mi:ss'),'1');
Insert into Journal (id, per_id, Dtime , Type)  values (27,3, TO_DATE('15.03.2018 09:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (28,3, TO_DATE('15.03.2018 18:00:00','dd.mm.yyyy hh24:mi:ss'),'1');

Insert into Journal (id, per_id, Dtime , Type)  values (29,3, TO_DATE('13.03.2018 07:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (30,3, TO_DATE('13.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');

Insert into Journal (id, per_id, Dtime , Type)  values (31,3, TO_DATE('12.03.2018 10:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (32,3, TO_DATE('12.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');

Insert into Journal (id, per_id, Dtime , Type)  values (33,5, TO_DATE('12.03.2018 07:00:00','dd.mm.yyyy hh24:mi:ss'),'0');
Insert into Journal (id, per_id, Dtime , Type)  values (34,5, TO_DATE('12.03.2018 14:00:00','dd.mm.yyyy hh24:mi:ss'),'1');

commit;
/
