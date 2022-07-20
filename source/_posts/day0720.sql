-- p92 3장  SQL 문장 살펴보기

SELECT * FROM employees; -- 107 개의 데이터 
-- SELECT 문
-- p.92
-- 급여가 5000이 넘는 사원번호와 사원명 조회


SELECT 
    employee_id
    , emp_name
    , salary

FROM employees
WHERE salary > 5000
ORDER BY employee_id;

-- 급여가 5000 이상, job_id, IT_PROG 사원 조회

SELECT employee_id, emp_name, job_id, salary
FROM employees
WHERE salary > 5000
AND job_id = 'IT_PROG'
ORDER BY employee_id;

-- 테이블에 별칭 줄 수 있음.

SELECT 
-- a 테이블에서 옴(=employees)
    a.employee_id
    ,a.emp_name
    ,a.department_id
-- b 테이블에서 옴 (=departments)
    ,b.department_name
FROM 
    employees a
    ,departments b
WHERE a.department_id = b.department_id;

SELECT * FROM departments;

-- INSERT 문 & UPDATE 문 혼자해보기.

CREATE TABLE ex3_1 (
    col1 VARCHAR2(10),
    col2 NUMBER,
    col3 DATE
);

INSERT INTO ex3_1 (col1, col2, col3)
VALUES (('ABC'), 10, SYSDATE);

INSERT INTO ex3_1(col3,col2,col1)
VALUES (SYSDATE, 10, ('ABC'));


INSERT INTO ex3_1 (col1, col2, col3)
VALUES (('ABC'), 10, 30);

-- 컬럼명 기술 생략 형태

INSERT INTO ex3_1
VALUES ('GHI',10,SYSDATE);

INSERT INTO ex3_1 (col1,col2)
VALUES('GHI',20);

INSERT INTO ex3_1
VALUES ('GHI',20);

-- INSERT ~ SELECT 형태

CREATE TABLE ex3_2(
    emp_id NUMBER,
    emp_name VARCHAR2(100)
);


INSERT INTO ex3_2 (emp_id,emp_name)
SELECT employee_id, emp_name
FROM employees
WHERE salary >5000;
-- 여기서도 컬럼순서와 데이터 타이을 맞추어야한다. 
-- 그런데 데이터 타입을 맞추지 않아도 INSER 가 성공하는 경우가 있다.
-- 바로 밑에서 확인해보자

INSERT INTO ex3_1 (col1,col2,col3)
VALUES (10,'10','2014-01-01');

-- UPDATE문

SELECT * FROM ex3_1;

UPDATE ex3_1
SET col2 = 50;

SELECT * FROM ex3_1;

UPDATE ex3_1
SET col3 = SYSDATE
WHERE col3 = '';

SELECT * FROM ex3_1;


UPDATE ex3_1
SET col3 = SYSDATE
WHERE col3 IS NULL;

SELECT * FROM ex3_1;


-- MERGE 문 p.101
-- 데이터를 합치다 또는 추가하다
-- 조건을 비교해서 테이블에 
-- 해당 조건에 맞는 데이터 없으면 추가
-- 있으면 UPDATE 문을 수행한다.
-- 와 개꿀이네
DROP TABLE ex3_3;

CREATE TABLE ex3_3(
    employee_id NUMBER
    ,bonus_amt NUMBER DEFAULT 0  
);

INSERT INTO ex3_3 (employee_id)
SELECT 
    e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.103
-- 서브 쿼리 subquary

SELECT 
    employee_id
    ,manager_id
    ,salary
    ,salary*0.01
FROM employees
WHERE employee_id IN (SELECT employee_id FROM ex3_3);


SELECT 
    employee_id
    ,manager_id
    ,salary
    ,salary * 0.001
FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3 )
AND manager_id = 146;

-- MERGE 를 통해서 작성
-- 관리자 사번 146 중에서 ex3_3 테이블에 없는
-- 사원의 사번, 관리자 사번, 급여, 급여 * 0.001 
-- ex3_3 table의 160번 사원의 보너스 금액은 7.5로 신규 입력

SELECT * FROM ex3_3;

-- 서브쿼리 개념 : 메인 쿼리 안에 추가된 쿼리
-- UPDATE & INSERT 구문
-- 두 개의 테이블 조인

MERGE INTO ex3_3 d 
    USING (SELECT employee_id, salary, manager_id
                  FROM employees 
                  WHERE manager_id = 146) b
    ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
    
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * .001)
    WHERE (b.salary < 8000);
    
SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.106
-- 테이블 삭제

DELETE ex3_3; 
-- DROP 은 테이블 자체를 없애는거고, 
-- DELETE 는 행들만 다 삭제시키는 것이다.
SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.107
-- commit & rollback
-- commit은 변경한 데이터를 데이터베이스에 마지막으로 반영
-- rollback은 그 반대로 변경한 데이터를 변경하기 이전 상태로 되돌리는 역할

CREATE TABLE ex3_4 ( employee_id NUMBER);
INSERT INTO ex3_4 VALUES (100);
SELECT * FROM ex3_4;
COMMIT;

-- p.109
TRUNCATE TABLE ex3_4;

-- p 110

SELECT 
    ROWNUM, employee_id
FROM employees
WHERE ROWNUM <=5;

-- ROWID, 주소 값
-- DBA, DB 모델링(쿼리속도 측정 --> 특징)
SELECT 
    ROWNUM
    , employee_id
    ,ROWID
FROM employees
WHERE ROWNUM <5;

-- 연산자
-- OPERATOR 연산 수행
-- 수식 연산자 & 문자 연산자
-- '||' 두 문자를 붙이는 연결 연산자
-- AS : = Alias의 약어 

SELECT 
    employee_id ||'-'|| emp_name AS employee_info
FROM employees
WHERE ROWNUM <5;

-- p.113
-- 표현식
-- 조건문, if 조건문 (PL/SQL)
-- CASE 표현식
SELECT 
    employee_id
    ,salary
    ,CASE WHEN salary <= 5000 THEN 'C등급'
         WHEN salary > 5000 AND salary <= 15000 THEN 'B등급'
         ELSE 'A등급'
    END AS salary_grade
FROM employees;

-- 조건식
-- TRUE, FALSE, UNKNOWN 세 가지 타입으로 반환 
-- 비교 조건식
-- 분석가, DB에서 데이터를 추출할때 서브쿼리를 쓴다.

SELECT 
    employee_id
    ,salary
FROM employees
WHERE salary = ANY(2000,3000,4000)
ORDER BY employee_id;


SELECT 
    employee_id
    ,salary
FROM employees
WHERE salary = SOME(2000,3000,4000)
ORDER BY employee_id;

-- 논리 조건식 
SELECT 
    employee_id
    ,salary
FROM employees
WHERE NOT (salary >= 2500)
ORDER BY employee_id;
    
-- NULL 조건식, BETWEEN AND 조건식 혼자해보기


-- IN 조건식
-- 조건절에 명시한 값이 포함된 건을 반환하는 데 앞에서 배웠던 ANY
SELECT 
    employee_id
    , salary
FROM employees
WHERE salary IN ( 2000,3000,4000)
ORDER BY employee_id;


-- NOT IN 

-- EXISTS 조건식
-- 서브 쿼리만 올 수 있음.
-- "" 이번 주 서브쿼리를 중심으로 공부를 하면 된다. ""
-- "개발자"(네카라쿠배토당야..)
--    코딩테스트 후(알고리즘) / 기술면접(연봉) / 임원 면접
-- "분석가" = 'SQL / 과제' 로 시험을 본다.


-- Like 조건식
-- 문자열의 패턴을 검색해서 사용하는 조건식

SELECT
    emp_name
FROM employees
WHERE emp_name LIKE '%_A_%'
ORDER BY emp_name;

CREATE TABLE ex3_5(
names VARCHAR2(30)
);

INSERT INTO ex3_5 VALUES ('홍길동');
INSERT INTO ex3_5 VALUES ('홍길용');
INSERT INTO ex3_5 VALUES ('홍길상');
INSERT INTO ex3_5 VALUES ('홍길상동');



SELECT * FROM ex3_5
WHERE names LIKE '홍길%';


SELECT * FROM ex3_5
WHERE names LIKe '홍길_';


-- 4장 숫자함수
--p.126
SELECT ABS(10), ABS(-10), ABS(-10.123)
    FROM DUAL;

-- 정수 반환
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001)
    FROM DUAL;
    
-- 내림
SELECT FLOOR(10.123),FLOOR(10.541),FLOOR(11.001)
    FROM DUAL;

-- ROUND     
SELECT ROUND (10.154), ROUND(10.541), ROUND(11.001)
    FROM DUAL;

-- 밑에 거 다 하기

-- TRUNC
-- 반올림 안함. 소수점 절삭, 자리수 지정 가능
SELECT TRUNC (115.155), TRUNC(115.115,1), TRUNC(115.155, 2), TRUNC(115.155,-2)
    FROM DUAL;
    
-- POWER
-- POWER 함수, SQRT(제곱근,루트)
SELECT POWER(3,2),POWER(3,3),POWER(3,3.001)
    FROM DUAL;
    
SELECT POWER(-3,3.0001)
    FROM DUAL;

SELECT SQRT(2), SQRT(5)
    FROM DUAL;

-- 과거 : SQL, DB에서 자료를 조회하는 용도
-- 현재 : SQL --> 수학, 통계 도구처럼 진화
-- 오라클 19C 

-- MOD,REMAINDER
SELECT MOD(19,4), MOD(19.123,4.2)
    FROM DUAL;
    
SELECT REMAINDER(19,4), REMAINDER(19.123,4.2)
    FROM DUAL;
    
-- EXP , LN, LOG
SELECT EXP(2), LN(2.713), LOG(10,100)
    FROM DUAL;

-- 문자열 데이터 전처리
-- 게임사,
-- 채팅 --> 문자데이터 
-- 텍스트 마이닝(빈도,워드클라우드)

SELECT INITCAP('never say goodbye'), INITCAP('never6say*good가bye')
    FROM DUAL;

SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say good bye')
    FROM DUAL;

-- CONCAT SUBSTR, SUBSTRB

SELECT CONCAT('I HAVE', 'A DREAM'), 'I HAVE' || 'A DREAM'
    FROM DUAL;

SELECT SUBSTR('ABCDEFG', 1,4), SUBSTR('ABCDEFG', -1,4)
    FROM DUAL;
    
SELECT SUBSTRB ('ABCDEFG',1,4), SUBSTRB('가나다라마바사',1,4)
    FROm DUAL;

-- LTRIM(char,set), RTRIM(char,set)

SELECT LTRIM('ABCDEFGABC','ABC'),
       LTRIM('가나다라','가'),
       RTRIM('ABCDEFGABC','ABC'),
       RTRIM('가나다라','가')
    FROM DUAL;

-- LPAD, RPAD (채우다)

CREATE TABLE ex4_1(
    phone_num VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES ('111-1111');
INSERT INTO ex4_1 VALUES ('111-2222');
INSERT INTO ex4_1 VALUES ('111-3333');

SELECT * FROM ex4_1;

SELECT LPAD(phone_num, 12,'(02)')
    FROM ex4_1;

SELECT RPAD(phone_num, 12,'(02)')
    FROM ex4_1;

-- REPLACE, TRANSLATE
SELECT REPLACE ('나는 너를 모르는데 너는 나를 알겠는가?','나','너')
    FROM DUAL;
..... 쭉 하기


-- p.138 날짜 함수
-- SYSDATE, SYSTIMESTAMP

SELECT SYSDATE, SYSTIMESTAMP
    FROM DUAL;
    
-- ADD_MONTH
SELECT ADD_MONTHS(SYSDATE, 1), ADD_MONTHS(SYSDATE, -1)
    FROM DUAL;

-- MONTHS_BETWEEN
SELECT MONTHS_BETWEEN(SYSDATE,ADD_MONTHS(SYSDATE,1)) mon1,
       MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1),SYSDATE) mon2
        FROM DUAL;
        
-- LAST_DAY
SELECT LAST_DAY(SYSDATE)
    FROM DUAL;
    
-- ROUND, TRUNC
SELECT SYSDATE, ROUND(SYSDATE,'month'),TRUNC(SYSDATE, 'month')
    FROM DUAL;
    
-- NEXT_DAY
SELECT NEXT_DAY(SYSDATE,'금요일')
    FROM DUAL;

--p.140 변환함수

-- TO_CHAR
SELECT TO_CHAR(123456789,'999,999,999')
    FROM DUAL;

SELECT TO_CHAR(SYSDATE,'AM')
    FROM DUAL;

-- TO_NUMBER 문자를 숫자로 변환
SELECT TO_NUMBER('12345')
    FROM DUAL;
    
-- p.143 NULL
SELECT manager_id, employee_id FROM employees;

-- NVL : 표현식1이 NULL 일 때, 표현식2를 반환한다.
SELECT NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;

-- NVL2 : 표현식1이 NULL이 아니면 표현식2를 출력
--          표현식2가 NULL이면 표현식3을 출력

SELECT employee_id
     , salary
     , commission_pct
     , NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees
WHERE employee_id IN (118, 179);

-- COALESCE 
-- 매개변수로 들어오는 표현식에서 NULL이 아닌 첫 번째 표현식 반환
SELECT employee_id, salary, commission_pct,
    COALESCE (salary * commission_pct, salary) AS salary2
    FROM employees;

-- LNNVL조건식





-- p147
-- GREATEST, LEAST
SELECT GREATEST(1,2,3,1),
    LEAST (1,2,3,1)
FROM DUAL;

SELECT GREATEST('이순신', '강감찬','세종대왕','이용수'),
    LEAST ('이순신','강감찬','세종대왕','이용수')
FROM DUAL;

-- DECODE
-- IF-ELIF-ELIF-ELIF-ELSE 같은 느낌

SELECT prod_id,
    DECODE(channel_id,3,'Direct',
                      9,'Direct',
                      5,'Indirect',
                      4,'Indirect',
                         'Others')decodes
FROM sales
WHERE rownum < 10;
