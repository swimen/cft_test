drop table chapters;

drop table wpage1#1;
drop table wpage1#2;
drop table wpage2_1#1;
drop table wpage2_1#2;
drop table wpage2_3#1;
drop table wpage2_3#2;
drop table wpage2_3#3;
drop table wpage3#1;
drop table wpage3_2#1;
drop table wpage3_2_1#1;


drop table subject1;
drop table subject2_1;
drop table subject2_2;
drop table subject2_3;
drop table subject3;
drop table subject3_1;
drop table subject3_2;
drop table subject3_2_1;



create table chapters (chapid number primary key, -- идентификатор раздела
 par_chapid number references chapters, -- ссылка на родительский раздел
 subject varchar2(200), -- имя таблицы тем данного раздела
 wpages varchar2(4000), -- таблицы страниц для таблицы раздела через запятую (пример: 'wpage1,wpage2')
 address varchar2(400) -- адрес расположения
 );
create index chapind_id on chapters (chapid,subject) compute statistics;

create index chapind_adr on chapters (address) compute statistics;


create table subject1 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);



create table subject2_1 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);


create table subject2_2 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);

create table subject2_3 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);


create table subject3 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);

create table subject3_1 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);

create table subject3_2 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);

create table subject3_2_1 (subjectid number primary key,--  ключ
 numberofviews number(10), -- количество просмотров
    name varchar2(200) -- наименование
);

create table wpage1#1 (subject references subject1, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage1#2 (subject references subject1, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage2_1#1 (subject references subject2_1, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage2_1#2 (subject references subject2_1, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage2_3#1 (subject references subject2_3, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage2_3#2 (subject references subject2_3, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage2_3#3 (subject references subject2_3, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage3#1 (subject references subject3, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage3_2#1 (subject references subject3_2, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

create table wpage3_2_1#1 (subject references subject3_2_1, -- ссылка на тему
header varchar2(1000), -- заголовок сообщения
answers number -- количество ответов 
);

prompt create chapters

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (1,null, 'subject1', 'wpage1#1,wpage1#2', '99chapter1');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (2,null, null, null, 'chapter2');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (3, 2, 'subject2_1', 'wpage2_1#1,wpage2_1#2', 'chapter2.1');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (4, 2, 'subject2_2', '', 'chapter2.2');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (5, 2, 'subject2_3', 'wpage2_3#1,wpage2_3#2,wpage2_3#3', 'chapter2.3');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (6, null, 'subject3', 'wpage3#1', '11chapter3');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (7, 6, 'subject3_1', '', 'chapter3.1');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (8, 6, 'subject3_2', 'wpage3_2#1', 'chapter3.2');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (9, 8, 'subject3_2_1', 'wpage3_2_1#1,err_page', 'chapter3.2.1');

insert into chapters (chapid, par_chapid, subject, wpages, address) values
 (10, 6, 'err_subj', '', 'chapter3.1');

prompt create subjects

insert into subject1(subjectid, numberofviews, name ) values (1, 1, 'S1 Тема_1'); 
insert into subject1(subjectid, numberofviews, name ) values (2, 1, 'S1 Тема_2'); 
insert into subject1(subjectid, numberofviews, name ) values (3, 1, 'S1 Тема_3'); 

insert into subject2_1(subjectid, numberofviews, name ) values (4, 1, 'S2_1 Тема_1'); 

insert into subject2_2(subjectid, numberofviews, name ) values (5, 1, 'S2_2 Тема_1'); 
insert into subject2_2(subjectid, numberofviews, name ) values (6, 1, 'S2_2 Тема_2'); 

insert into subject2_3(subjectid, numberofviews, name ) values (7, 1, 'S2_3 Тема_1'); 

insert into subject3(subjectid, numberofviews, name ) values (8, 1, 'S3 Тема_1'); 

insert into subject3_1(subjectid, numberofviews, name ) values (9, 1, 'S3_1 Тема_1'); 
insert into subject3_1(subjectid, numberofviews, name ) values (10, 1, 'S3_1 Тема_2'); 

insert into subject3_2(subjectid, numberofviews, name ) values (11, 1, 'S3_2 Тема_1'); 
insert into subject3_2(subjectid, numberofviews, name ) values (12, 1, 'S3_2 Тема_2'); 
insert into subject3_2(subjectid, numberofviews, name ) values (13, 1, 'S3_2 Тема_3'); 

insert into subject3_2_1(subjectid, numberofviews, name ) values (14, 1, 'S3_2_1 Тема_1'); 

prompt create pages

insert into wpage1#1 (subject, header, answers) values (2, 'Заголовок_1', 3);
insert into wpage1#1 (subject, header, answers) values (2, 'Заголовок_2', 7);
insert into wpage1#1 (subject, header, answers) values (2, 'Заголовок_3', 17);
insert into wpage1#1 (subject, header, answers) values (2, 'Заголовок_4', 27);
insert into wpage1#1 (subject, header, answers) values (2, 'Заголовок_5', 9);
insert into wpage1#1 (subject, header, answers) values (2, 'Заголовок_6', 98);

insert into wpage1#2 (subject, header, answers) values (3, 'Заголовок_1', 3);
insert into wpage1#2 (subject, header, answers) values (3, 'Заголовок_2', 7);
insert into wpage1#2 (subject, header, answers) values (3, 'Заголовок_3', 17);


insert into wpage2_1#1 (subject, header, answers) values (4, 'Заголовок_1', 13);
insert into wpage2_1#2 (subject, header, answers) values (4, 'Заголовок_2', 43);

insert into wpage2_3#1 (subject, header, answers) values (7, 'Заголовок_1', 33);
insert into wpage2_3#1 (subject, header, answers) values (7, 'Заголовок_2', 3);
insert into wpage2_3#2 (subject, header, answers) values (7, 'Заголовок_3', 8);
insert into wpage2_3#2 (subject, header, answers) values (7, 'Заголовок_4', 9);
insert into wpage2_3#2 (subject, header, answers) values (7, 'Заголовок_5', 78);
insert into wpage2_3#3 (subject, header, answers) values (7, 'Заголовок_6', 878);


insert into wpage3#1 (subject, header, answers) values (8, 'Заголовок_1', 4);
insert into wpage3#1 (subject, header, answers) values (8, 'Заголовок_2', 8);

insert into wpage3_2#1 (subject, header, answers) values (11, 'Заголовок_1', 4);
insert into wpage3_2#1 (subject, header, answers) values (11, 'Заголовок_2', 14);
insert into wpage3_2#1 (subject, header, answers) values (11, 'Заголовок_3', 24);

insert into wpage3_2#1 (subject, header, answers) values (12, 'Заголовок_1', 44);
insert into wpage3_2#1 (subject, header, answers) values (12, 'Заголовок_2', 45);

insert into wpage3_2#1 (subject, header, answers) values (13, 'Заголовок_1', 35);
insert into wpage3_2#1 (subject, header, answers) values (13, 'Заголовок_2', 43);
insert into wpage3_2#1 (subject, header, answers) values (13, 'Заголовок_3', 74);
insert into wpage3_2#1 (subject, header, answers) values (13, 'Заголовок_4', 49);


insert into wpage3_2_1#1 (subject, header, answers) values (14, 'Заголовок_1', 49);

commit;
