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



create table chapters (chapid number primary key, -- ������������� �������
 par_chapid number references chapters, -- ������ �� ������������ ������
 subject varchar2(200), -- ��� ������� ��� ������� �������
 wpages varchar2(4000), -- ������� ������� ��� ������� ������� ����� ������� (������: 'wpage1,wpage2')
 address varchar2(400) -- ����� ������������
 );
create index chapind_id on chapters (chapid,subject) compute statistics;

create index chapind_adr on chapters (address) compute statistics;


create table subject1 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);



create table subject2_1 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);


create table subject2_2 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);

create table subject2_3 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);


create table subject3 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);

create table subject3_1 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);

create table subject3_2 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);

create table subject3_2_1 (subjectid number primary key,--  ����
 numberofviews number(10), -- ���������� ����������
    name varchar2(200) -- ������������
);

create table wpage1#1 (subject references subject1, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage1#2 (subject references subject1, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage2_1#1 (subject references subject2_1, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage2_1#2 (subject references subject2_1, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage2_3#1 (subject references subject2_3, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage2_3#2 (subject references subject2_3, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage2_3#3 (subject references subject2_3, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage3#1 (subject references subject3, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage3_2#1 (subject references subject3_2, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
);

create table wpage3_2_1#1 (subject references subject3_2_1, -- ������ �� ����
header varchar2(1000), -- ��������� ���������
answers number -- ���������� ������� 
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

insert into subject1(subjectid, numberofviews, name ) values (1, 1, 'S1 ����_1'); 
insert into subject1(subjectid, numberofviews, name ) values (2, 1, 'S1 ����_2'); 
insert into subject1(subjectid, numberofviews, name ) values (3, 1, 'S1 ����_3'); 

insert into subject2_1(subjectid, numberofviews, name ) values (4, 1, 'S2_1 ����_1'); 

insert into subject2_2(subjectid, numberofviews, name ) values (5, 1, 'S2_2 ����_1'); 
insert into subject2_2(subjectid, numberofviews, name ) values (6, 1, 'S2_2 ����_2'); 

insert into subject2_3(subjectid, numberofviews, name ) values (7, 1, 'S2_3 ����_1'); 

insert into subject3(subjectid, numberofviews, name ) values (8, 1, 'S3 ����_1'); 

insert into subject3_1(subjectid, numberofviews, name ) values (9, 1, 'S3_1 ����_1'); 
insert into subject3_1(subjectid, numberofviews, name ) values (10, 1, 'S3_1 ����_2'); 

insert into subject3_2(subjectid, numberofviews, name ) values (11, 1, 'S3_2 ����_1'); 
insert into subject3_2(subjectid, numberofviews, name ) values (12, 1, 'S3_2 ����_2'); 
insert into subject3_2(subjectid, numberofviews, name ) values (13, 1, 'S3_2 ����_3'); 

insert into subject3_2_1(subjectid, numberofviews, name ) values (14, 1, 'S3_2_1 ����_1'); 

prompt create pages

insert into wpage1#1 (subject, header, answers) values (2, '���������_1', 3);
insert into wpage1#1 (subject, header, answers) values (2, '���������_2', 7);
insert into wpage1#1 (subject, header, answers) values (2, '���������_3', 17);
insert into wpage1#1 (subject, header, answers) values (2, '���������_4', 27);
insert into wpage1#1 (subject, header, answers) values (2, '���������_5', 9);
insert into wpage1#1 (subject, header, answers) values (2, '���������_6', 98);

insert into wpage1#2 (subject, header, answers) values (3, '���������_1', 3);
insert into wpage1#2 (subject, header, answers) values (3, '���������_2', 7);
insert into wpage1#2 (subject, header, answers) values (3, '���������_3', 17);


insert into wpage2_1#1 (subject, header, answers) values (4, '���������_1', 13);
insert into wpage2_1#2 (subject, header, answers) values (4, '���������_2', 43);

insert into wpage2_3#1 (subject, header, answers) values (7, '���������_1', 33);
insert into wpage2_3#1 (subject, header, answers) values (7, '���������_2', 3);
insert into wpage2_3#2 (subject, header, answers) values (7, '���������_3', 8);
insert into wpage2_3#2 (subject, header, answers) values (7, '���������_4', 9);
insert into wpage2_3#2 (subject, header, answers) values (7, '���������_5', 78);
insert into wpage2_3#3 (subject, header, answers) values (7, '���������_6', 878);


insert into wpage3#1 (subject, header, answers) values (8, '���������_1', 4);
insert into wpage3#1 (subject, header, answers) values (8, '���������_2', 8);

insert into wpage3_2#1 (subject, header, answers) values (11, '���������_1', 4);
insert into wpage3_2#1 (subject, header, answers) values (11, '���������_2', 14);
insert into wpage3_2#1 (subject, header, answers) values (11, '���������_3', 24);

insert into wpage3_2#1 (subject, header, answers) values (12, '���������_1', 44);
insert into wpage3_2#1 (subject, header, answers) values (12, '���������_2', 45);

insert into wpage3_2#1 (subject, header, answers) values (13, '���������_1', 35);
insert into wpage3_2#1 (subject, header, answers) values (13, '���������_2', 43);
insert into wpage3_2#1 (subject, header, answers) values (13, '���������_3', 74);
insert into wpage3_2#1 (subject, header, answers) values (13, '���������_4', 49);


insert into wpage3_2_1#1 (subject, header, answers) values (14, '���������_1', 49);

commit;
