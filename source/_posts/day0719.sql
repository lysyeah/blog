select table_name from user_tables;

-- SQL VS   PL/SQL
-- 일주일 동안 SQL 배운다 ( 분석가90%, 개발자30% )
-- PL/SQL 분석가 + 개발자 + DBA ( 분석가 10%, 개발자70%, DBA ) 이거 잘배워야겠네
-- 취직 면접에서 PL/SQL배웠다고 어필하기

-- 입문 : SQL 테이블, 뷰 --> PL/SQL 함수, 프로시저 

-- 테이블 생성


-- create table 테이블명(
-- 컬럼1 컬럼1_데이터타입 결측치 허용유무,
-- )


-- p50.
-- 데이터 생성
create table ex2_1(
 column1 char(10),
 column2 varchar2(10),
 column3 varchar2(10),
 column4 number
);

-- 데이터 추가 
insert into ex2_1 (column1, column2) values ('abc','abc');
-- 데이터 조회
select column1, length(column1) as len1,
       column2, length(column2) as len2
    from ex2_1;

-- p53.
-- 영어에서 한 문자는 1 byte
-- 한글에서 한 문자는 2 byte

-- 데이터 생성
create table ex2_2(
    column1 varchar2(3), --> 디폴트 값인 byte 적용
    column2 varchar2(3 byte),
    column3 varchar2(3 char)
);

-- 데이터 추가
insert into ex2_2 values('abc','abc','abc');

-- 데이터 조회

select column1
        , length(column1) as len1
        , column2
        , length(column2) as len2
        , column3
        , length(column3) as len3
    from ex2_2;
    
-- 영문자는 크기가 모두 3byte이다. 이제는 한글을 입력해 보자.
insert into ex2_2 values ( '이용수','정민경','홍승기');

-- p.54
insert into ex2_2 (column3) values ('이용수');

select column3
     ,length (column3) as len3
     ,lengthb ( column3) as bytelen
from ex2_2;

-- 숫자 데이터 타입
create  table ex2_3(
    col_int integer,
    col_dec decimal,
    col_num number
);

select column_id, column_name, data_type, data_length
from user_tab_cols
where table_name = 'ex2_3'
order by column_id;

-- select 컬럼명
-- from 테이블명
-- where 조건식
-- order by 정렬

select * from user_tab_cols;

-- float 형으로 인한 오류 - 혼자 해보기.

-- 날짜 데이터 타입
create table ex2_5(
    col_date date,
    col_timestamp timestamp
);

insert into ex2_5 values (sysdate, systimestamp);
select * from ex2_5


-- LOB 데이터 타입

-- null : 값이 없음
-- 해당 컬럼은 null
-- 결측치 허용 x : Not null

-- p.60
create table ex2_6 (
    col_null  varchar2(10), -- 결측치 허용 o
    col_not_null  varchar2(10) not null -- 결측치 허용 x

);
-- 에러 발생
insert into ex2_6 values ('AA','');
--정상적으로 삽입됨
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
-- 중복 값 허용 X

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


-- 기본키
-- Primary key 
-- UNIQUE(중복 허용안됨) , NOT NULL(결측치 허용 안됨)
-- 테이블 당 1개의 기본키만 설정 가능 


CREATE TABLE ex2_8(
    COL1 VARCHAR2 (10) PRIMARY KEY
    , COL2 VARCHAR2 (10)
);
-- INSERT INTO ex2_8 VALUES ('','AA');
INSERT INTO ex2_8 VALUES ('AA','AA');

-- DROP table ex2_8 = ora_user 에서 table 없애는 기능.

-- 외래키 : 테이블 간의 참조 데이터 무결성 위한 제약 조건 
-- 참조 무결성을 보장한다.
-- 잘못된 정보가 입력되는 것을 방지한다.

-- check
-- 컬럼에 입력되는 데이터를 체크해 특정 조건에 맞는 데이터만 입력

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

-- 테이블 변경
-- ALTER TABLE

ALTER TABLE ex2_10 RENAME COLUMN col1 TO col11;
SELECT * TABLE ex2_10;

DESC ex2_10;

-- 컬럼 타입 변경

ALTER TABLE ex2_10 MODIFY col2  VARCHAR2(30)
DESC ex2_10; 
-- DESC = discribe 

-- 신규 컬럼 추가하기
ALTER TABLE ex2_10 ADD col3 NUMBER;
DESC ex2_10;

-- 칼럼 삭제하기
ALTER TABLE ex2_10 DROP COLUMN col3;
DESC ex2_10;

-- 제약 조건 추가
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY('col11') ;
DESC ex2_10;

SELECT CONSTRAINT_NAME
    , CONSTRAINT_TYPE
    , table_name
    , search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- 제약 조건 삭제하기 : col 11 에서 기본키 삭제하기
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;

SELECT constraint_name
       , constraint_type
       , table_name
       , search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- 테이블 복사
CREATE TABLE ex2_9_1 AS
SELECT * FROM ex2_9;

DESC ex2_9_1;

-- 뷰 생성하기 
CREATE OR REPLACE VIEW emp_dept_v1 AS
SELECT a.employee_id
    , a.emp_name
    , a.department_id
    , b.department_name
FROM employees a
    , departments b
WHERE a.department_id = b.dpartment_id

-- DROP VIEW emp_dept_v1 하면 뷰 삭제된다.


