select table_name from user_tables;

-- SQL VS   PL/SQL
-- ������ ���� SQL ���� ( �м���90%, ������30% )
-- PL/SQL �м��� + ������ + DBA ( �м��� 10%, ������70%, DBA ) �̰� �߹���߰ڳ�
-- ���� �������� PL/SQL����ٰ� �����ϱ�

-- �Թ� : SQL ���̺�, �� --> PL/SQL �Լ�, ���ν��� 

-- ���̺� ����


-- create table ���̺��(
-- �÷�1 �÷�1_������Ÿ�� ����ġ �������,
-- )


-- p50.
-- ������ ����
create table ex2_1(
 column1 char(10),
 column2 varchar2(10),
 column3 varchar2(10),
 column4 number
);

-- ������ �߰� 
insert into ex2_1 (column1, column2) values ('abc','abc');
-- ������ ��ȸ
select column1, length(column1) as len1,
       column2, length(column2) as len2
    from ex2_1;

-- p53.
-- ����� �� ���ڴ� 1 byte
-- �ѱۿ��� �� ���ڴ� 2 byte

-- ������ ����
create table ex2_2(
    column1 varchar2(3), --> ����Ʈ ���� byte ����
    column2 varchar2(3 byte),
    column3 varchar2(3 char)
);

-- ������ �߰�
insert into ex2_2 values('abc','abc','abc');

-- ������ ��ȸ

select column1
        , length(column1) as len1
        , column2
        , length(column2) as len2
        , column3
        , length(column3) as len3
    from ex2_2;
    
-- �����ڴ� ũ�Ⱑ ��� 3byte�̴�. ������ �ѱ��� �Է��� ����.
insert into ex2_2 values ( '�̿��','���ΰ�','ȫ�±�');

-- p.54
insert into ex2_2 (column3) values ('�̿��');

select column3
     ,length (column3) as len3
     ,lengthb ( column3) as bytelen
from ex2_2;

-- ���� ������ Ÿ��
create  table ex2_3(
    col_int integer,
    col_dec decimal,
    col_num number
);

select column_id, column_name, data_type, data_length
from user_tab_cols
where table_name = 'ex2_3'
order by column_id;

-- select �÷���
-- from ���̺��
-- where ���ǽ�
-- order by ����

select * from user_tab_cols;

-- float ������ ���� ���� - ȥ�� �غ���.

-- ��¥ ������ Ÿ��
create table ex2_5(
    col_date date,
    col_timestamp timestamp
);

insert into ex2_5 values (sysdate, systimestamp);
select * from ex2_5


-- LOB ������ Ÿ��

-- null : ���� ����
-- �ش� �÷��� null
-- ����ġ ��� x : Not null

-- p.60
create table ex2_6 (
    col_null  varchar2(10), -- ����ġ ��� o
    col_not_null  varchar2(10) not null -- ����ġ ��� x

);
-- ���� �߻�
insert into ex2_6 values ('AA','');
--���������� ���Ե�
insert into ex2_6 values ('','BB');

select * from ex2_6;    

insert into ex2_6 values ('AA','BB');
select * from ex2_6;

-- p.61

select constraint_name
    , constraint_type
    , table_name
    , search_condition
from user_constraints
where table_name = 'EX2_6';

-- unique
-- �ߺ� �� ��� X

CREATE TABLE ex2_7(
    col_unique_null       VARCHAR2(10) UNIQUE
    , col_unique_nnul    VARCHAR2(10) UNIQUE NOT NULL
    , col_unique          VARCHAR2(10)
    , CONSTRAINTS unique_nm1 UNIQUE (col_unique)
);

SELECT constraint_name
       , constraint_type
       , table_name
       , search_condition
FROM user_constraints
WHERE table_name = 'EX2_7';

INSERT INTO ex2_7 VALUES ('AA','AA','AA');

INSERT INTO ex2_7 VALUES ('','BB','CC');


-- �⺻Ű
-- Primary key 
-- UNIQUE(�ߺ� ���ȵ�) , NOT NULL(����ġ ��� �ȵ�)
-- ���̺� �� 1���� �⺻Ű�� ���� ���� 


CREATE TABLE ex2_8(
    COL1 VARCHAR2 (10) PRIMARY KEY
    , COL2 VARCHAR2 (10)
);
-- INSERT INTO ex2_8 VALUES ('','AA');
INSERT INTO ex2_8 VALUES ('AA','AA');

-- DROP table ex2_8 = ora_user ���� table ���ִ� ���.

-- �ܷ�Ű : ���̺� ���� ���� ������ ���Ἲ ���� ���� ���� 
-- ���� ���Ἲ�� �����Ѵ�.
-- �߸��� ������ �ԷµǴ� ���� �����Ѵ�.

-- check
-- �÷��� �ԷµǴ� �����͸� üũ�� Ư�� ���ǿ� �´� �����͸� �Է�

CREATE TABLE ex2_9(
    num1 NUMBER
    ,CONSTRAINTS check1 CHECK (num1 BETWEEN 1 AND 9)
    ,gender  VARCHAR2(10)
    ,CONSTRAINTS check2 CHECK (gender IN ('MALE','fEMALE'))
);

SELECT constraint_name
       , constraint_type
       , table_name
       , search_condition
FROM user_constraints
WHERE table_name = 'EX2_9';

INSERT INTO ex2_9 VALUES(10,'MAN');
INSERT INTO ex2_9 VALUES(10,'FEMAIE');
INSERT INTO ex2_9 VALUES(5,'FDMALE');


-- Default
alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';
DROP TABLE ex2_10
CREATE TABLE ex2_10(
    col1 VARCHAR2 (10) NOT NULL
    ,col2 VARCHAR2 (10) NULL
    ,create_date DATE DEFAULT SYSDATE
    ,create_timestamp DATE DEFAULT SYSTIMESTAMP
);

INSERT INTO ex2_10 (col1,col2) VALUES('AA','BB');
SELECT * FROM ex2_10

-- ���̺� ����
-- ALTER TABLE

ALTER TABLE ex2_10 RENAME COLUMN col1 TO col11;
SELECT * TABLE ex2_10;

DESC ex2_10;

-- �÷� Ÿ�� ����

ALTER TABLE ex2_10 MODIFY col2  VARCHAR2(30)
DESC ex2_10; 
-- DESC = discribe 

-- �ű� �÷� �߰��ϱ�
ALTER TABLE ex2_10 ADD col3 NUMBER;
DESC ex2_10;

-- Į�� �����ϱ�
ALTER TABLE ex2_10 DROP COLUMN col3;
DESC ex2_10;

-- ���� ���� �߰�
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY('col11') ;
DESC ex2_10;

SELECT CONSTRAINT_NAME
    , CONSTRAINT_TYPE
    , table_name
    , search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- ���� ���� �����ϱ� : col 11 ���� �⺻Ű �����ϱ�
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;

SELECT constraint_name
       , constraint_type
       , table_name
       , search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- ���̺� ����
CREATE TABLE ex2_9_1 AS
SELECT * FROM ex2_9;

DESC ex2_9_1;

-- �� �����ϱ� 
CREATE OR REPLACE VIEW emp_dept_v1 AS
SELECT a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM employees a
    , departments b
WHERE a.department_id = b.dpartment_id

-- DROP VIEW emp_dept_v1 �ϸ� �� �����ȴ�.


