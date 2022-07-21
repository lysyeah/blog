-- 5장 p.152

-- ## 기본 집계 함수 

-- 1. count

--COUNT는 쿼리 결과 건수, 즉 전체 로우 수를 반환하는 집계 함수이다.
-- 테이블 전체 로우는 물론 WHERE 조건으로 걸러진 로우 수를 반환한다.

SELECT COUNT(*)
FROM employees;

----

SELECT COUNT(employee_id)
FROM employees;

SELECT COUNT(department_id)
FROM employees;
-- = count는 null 값을 세지 않는다.

-- --- 유일한 값만 조회됨

SELECT COUNT(DISTINCT department_id)
FROM employees;

-- ---

SELECT DISTINCT department_id
FROM employees
ORDER BY 1;

-- --

-- 기초 통계량
-- p.154 
-- 합계, 평균, 최소, 최대, 부산, 표준편차
-- SQL --> 통게도구, 머신러닝, 데이터 과학 도구로 이용 많이 되고 있다.
-- 클라우드(수업에서 잘 다루지 않는다.)
-- ex) AWS(50%), Azure(30%), GCP(20%) 가 있는데
-- AWS 삼성에서 돈 많이 낸다.
-- AWS 배우자.


-- 2. SUM

SELECT SUM(salary)
FROM employees;

-- --

SELECT SUM(salary), SUM(DISTINCT salary)
FROM employees;


-- 3. AVG 
-- 평균값 반환 

SELECT AVG(salary), AVG(DISTINCT salary)
FROM employees;

-- 4. MIN (expr), MAX(expr)

SELECT MAX(salary), MIN(salary)
FROM employees;

-- --

SELECT MIN(DISTINCT salary), MAX(DISTINCT salary)
FROM employees;

-- 5. VARIANCE, STDDEV

SELECT VARIANCE(salary), STDDEV(salary)
FROM employees;

-- ## 2. GROUP BY 절과 HAVING 절



SELECT department_id
    , SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- -- 

SELECT * FROM kor_loan_status; -- 가계 대출 단위는 십억

-- ---

SELECT period, region, SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, region
ORDER BY period, region;

-- - 

SELECT period, region, SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY region
ORDER BY region;
-- SELECT에 region을 지우든가, 그룹바이에 region을 추가하든가.


-- ----- ---

SELECT 
    period, region
    , SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY region, period 
HAVING SUM(loan_jan_amt) > 100000
ORDER BY region;


-- ## 3.ROLLUP 절 & CUBE 절

-- ROLLUP

SELECT period, gubun, SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period LIKE  '2013%'
GROUP BY period, gubun
ORDER BY period;

-- -
SELECT period, gubun, SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period LIKE  '2013%'
GROUP BY ROLLUP(period, gubun);

-- --- ---

SELECT 

-- -- 

SELECT 

-- ----

-- CUBE 

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY CUBE (period, gubun);

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, CUBE(gubun);

-- ##  4. 집합 연산자

-- UNION

CREATE TABLE exp_goods_asia (
           country VARCHAR2(10),
           seq     NUMBER,
           goods   VARCHAR2(80));

    INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
    INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
    INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
    INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
    INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
    INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

    INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
    INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
    INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
    INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
    INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
    INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
    INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
    INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
    INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
    INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');
commit;


SELECT * FROM exp_goods_asia;

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq;


-- 두 국가가 겹치는 수출품목은 한 번만 조회가 되도록 한다.
-- UNION (합집합) 


SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION 
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL 
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';
--UNION 과 비슷한데 중복된 항목도 모두 조회되는 차이점이 있다.


-- INTERSECT(교집합)

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';


-- MINUS(차집합)

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';
-- 위 쿼리는 한국에는 있지만 일본에는 없는 수출품 목록을 나타냈다.


SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '한국';
-- 위 쿼리는 일본에는 있지만 한국에는 없는 수출품 목록을 나타냈다.



-- p.168 집합 연산자의 제한사항

-- 수학의 집합 개념만 알면 집합 연산자의 기본 개념을 이해하는 데별 어려움이 없을 것이다.
-- 하지만 집합 연산자를 사용할 때 주의해야 할 내용이 있데, 정리하면 다음과 같다.

-- 1> 집합 연산자로 연결되는 각 SELECT 문의 SELECT 리스트의 개수와
-- 데이터 타입은 일치해야한다.

SELECT goods
FRom exp_goods_asia
WHERE country= '한국'
UNION
SELECT seq,goods
FROM exp_goods_asia
WHERE country = '일본';

-- ---

SELECT seq, goods
FRom exp_goods_asia
WHERE country= '한국'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '일본';

-- --- 

SELECT seq,goods
FRom exp_goods_asia
WHERE country= '한국'
INTERSECT
SELECT seq,goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT seq
FRom exp_goods_asia
WHERE country= '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

-- --
-- 1>
SELECT goods
FRom exp_goods_asia
WHERE country= '한국'
ORDER BY goods
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';
-- 2>
SELECT goods
FRom exp_goods_asia
WHERE country= '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';
-- 3>
-- 4>

-- p.171 GROUPING SETS절

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period,gubun);

-- --


SELECT period, gubun,region, SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
AND region IN ('서울','경기')
GROUP BY GROUPING SETS(period,(gubun,region));

-- --- 

-- 이 책으로 SQL 실력이 향상되는 지름길


-- p.175 6장 테이블 사이를 연결해 주는 조인과 서브 쿼리 알아보기

-- ## 1. 조인의 종류

-- ## 2. 내부 조인과 외부 조인

-- 동등 조인
SELECT 
    a.employee_id
    ,a.emp_name, a.department_id
    ,b.department_name
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id;

-- -----

-- 세미 조인 
-- 1> EXIST 사용
SELECT department_id, department_name
FROM departments a
WHERE EXISTS ( SELECT *FROM employees b
    WHERE a.department_id = b.department_id
    AND b.salary>3000)
ORDER BY a.department_name;

-- 2> IN 사용
SELECT department_id, department_name
FROM departments a
WHERE a.department_id IN (SELECT b.department_id
    FROM employees b
    WHERE b.salary >3000)
ORDER BY department_name;

-- --------

SELECT a.department_id, a.department_name
FROM departments a, employees b
WHERE a.department_id = b.department_id
AND b.salary>3000
ORDER BY a.department_name;

-- 안티조인

SELECT 
    a.employee_id, a.emp_name
    ,a.department_id, b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
AND a.department_id NOT IN (SELECT department_id
    FROM departments
    WHERE manager_id IS NULL);
    
-- --- -

SELECT count(*)
FROm employees a
WHERE NOT EXISTS ( SELECT 1
    FROM departments c
    WHERE a.department_id = c.department_id
    AND manager_id IS NULL);
    
-- ----------------

-- 셀프 조인
-- 조인을 하려면, 두 개의 테이블
-- 테이블을 자기자신과 연결
-- 같은 부서번호를 가진 사원 중 A사원번호가 B사원보다 작은 건 조회

SELECT 
    a.employee_id, a.emp_name
    ,b.employee_id, b.emp_name, a.department_id
FROM employees a,
    employees b
WHERE a.employee_id < b.employee_id
AND a.department_id = b.department_id
AND a.department_id =20;
-- "아, 셀프조인은 이런식으로 거는구나."

-- 외부 조인

-- 1> 일반 조인
SELECT 
    a.department_id, a.department_name
    ,b.job_id, b.department_id
FROM departments a,
    job_history b
WHERE a.department_id = b.department_id;

-- 2> 외부조인
SELECT 
    a.department_id, a.department_name
    ,b.job_id, b.department_id
FROM departments a,
    job_history b
WHERE a.department_id = b.department_id(+);
-- a테이블을 기준으로 b를 덧붙이는거.


-- ----

SELECT 
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id;

-- --- 

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);

-- 외보 조인 시 알아야 할 내용을 정리해보자.
-- 1. 조인 대상 테이블 중 데이터가 없는 테이블 조인 조건에 (+)를 붙인다.
-- 2. 외부 조인의 조이니 조건이 여러 개일 떄 모든 조건에 (+)를 붙인다.
-- 3. 한 번에 한 테이블에만 외부 조인을 ㅎ라 수 있다.
-- 예를 들면 조인 대상 테이블이 A,B,C 3개이고, 
-- A를 기준으로 B 테이블을 외부 조인으로 연결했다면, 
-- 동시에 C를 기준으로 B테이블에 외부 조인을 걸 수는 없다.
-- 4. (+)연산자가 붙은 조건과 OR를 같이 사용할 수 없다.
-- 5. (+)연산자가 붙은 조건에는 IN연산자를 같이 사용할 수 없다.
-- (단, IN절에 포함되는 값이 1개인 때는 사용가능하다.)

-- 카타시안 조인 (쓸일이 없다. 왜냐하면 데이터를 늘리는 일이기 때문이다.)

SELECT a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a,
    departments b;
    
-- --

-- ## 3. ANSI 조인

-- ANSI 내부 조인
-- <기존 문법>
--SELECT A.컬럼1, A.컬럼2, B.컬럼1, B.컬럼2 ...
--FROM 테이블A, 테이블B
--WHERE A.컬럼1 = B.컬럼1 - > 조인 조건
--...;

-- <ANSI 문법>
--SELECT A.컬럼1, A.컬럼2, B.컬럼1, B.컬럼2...
--FROM 테이블A
--INNER JOIN 테이블B
-- ON (A.컬럼1 = B.컬럼1)-> 조인 조건
-- WHERE ...;


-- <기존 문법>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b. department_id
AND a.hire_date>= TO_DATE('2003-01-01','YYYY-MM-DD');


-- <ANSI 문법>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a
INNER JOIN departments b
ON (a.department_id = b.department_id)
WHERE a.hire_date >= TO_DATE ('2003-01-01','YYYY-MM-DD');

-- ---- 

-- p.186 
-- <잘된못 경우>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a
INNER JOIN departments b
USING (department_id)
WHERE a.hire_date>=TO_DATE('2003-01-01','YYYY-MM-DD');

-- <잘 된 경우>
SELECT 
    a.employee_id, a.emp_name
    ,department_id, b.department_name
FROM employees a
INNER JOIN departments b
USING (department_id)
WHERE a.hire_date>=TO_DATE('2003-01-01','YYYY-MM-DD');

-- ANSI 외부 조인

-- <기존 문법>

SELECT 
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);


--<ANSI 문법>

-- 오른쪽이 기준인거.
SELECT 
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM employees a
RIGHT OUTER JOIN job_history b
-- b가 기준이라는 건가?
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
-- --

-- 기준이 왼쪽인거
SELECT
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM job_history b
RIGHT OUTER JOIN employees a
-- a가 기준이라는 건가?
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);

-- 또한 외부 조인은 OUTER 라는 키워드를 붙이는데, 이는 생략이 가능하다.
-- 즉, LEFT JOIN 혹은 RIGHT JOIN 이라고 명시해도 이는 외부 조인을 의미한다.

SELECT
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM employees a
LEFT JOIN job_history b
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);

-- CROSS 조인(이거 안해돼. 안써)

-- <기존 문법>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a,
    departments b;

-- <ANSI 문법>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a
CROSS JOIN departments b;

-- p.189

-- FULL OUTER 조인 (이거도 잘 안쓰인다네 하... )

CREATE TABLE HONG_A (EMP_ID INT);
CREATE TABLE HONG_B (EMP_ID INT);

INSERT INTO HONG_A VALUES (10);
INSERT INTO HONG_A VALUES (20);
INSERT INTO HONG_A VALUES (40);

INSERT INTO HONG_B VALUES (10);
INSERT INTO HONG_B VALUES (20);
INSERT INTO HONG_B VALUES (30);

COMMIT;

-- 외부 조인을 해야하는데, 지금까지 배운 내용으로는 한 문장으로 처리할 수 없다.
-- (이전 장에서 배우는 집한 연산자를 사용하면 가능하디.)
-- 외부 조인을 할 때, A 테이블을 기준으로 하면 30이, 
-- B 테이블을 기준으로 하면 40이 빠진다. 
-- 그렇다고 해서 다음과 같이 하면 오류가 발생한다.

SELECT a.emp_id, b.emp_id
FROM hong_a a, hong_b b
WHERE a.emp_id(+) = b.emp_id(+);
-- 당연히 에러가 뜬가.

SELECT a.emp_id, b.emp_id
FROM hong_a a
FULL OUTER JOIN hong_b b
ON (a.emp_id = b.emp_id);


-- 현장에서는 기존 오라클 문법과
-- ANSI 문법 중, 어떤 것을 많이 사용할까??
-- 당연히 안시를 많이 쓰지.


-- p.191 서브쿼리 ****
-- SQL 수업의 하이트라이트!
-- 서브쿼리
-- SELECT, FROM, WHERE에 쓰인다.

SELECT AVG(salary)  FROM (employees);


-- 유형1
-- 단일행
SELECT count(*)
FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees) ;


-- 유형2    
-- IN (복수 결과값을 넣을 수 있다.)
SELECT count(*)
FROM employees
WHERE department_id IN 
    (SELECT department_id
    FROM departments
    WHERE parent_id IS NULL);
    
--유형3
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
    FROM job_history);
    
 
(SELECT employee_id, job_id FROM job_history);
-- --- -



-- 서브 쿼리 SELECT뿐 아니라 UPDATE, DELETE에도 쓸 수 있다.
-- commit 금지
-- 연관성 있는 서브쿼리

-- <전 사원의 급여를 평균 금액으로 갱신>
UPDATE employees
SET salary = (SELECT AVG(salary)
                FROM employees);

-- <평균 급여보다 많이 받는 사원 삭제>
DELETE employees
WHERE salary >= (SELECT AVG(salary)
                FROM employees);
-- 왜 107개가 다 삭제되지??    
    
    
ROLLBACK;

-- 연관성 있는 서브 쿼리
-- p194 하단 SELECT절에 서브쿼리

SELECT 
    a.employee_id
    ,(SELECT b. emp_name 
      FROM employees b 
      WHERE a.employee_id = b.employee_id) 
      AS emp_name, a.department_id,
    (SELECT b.department_name
     FROM departments b
     WHERE a.department_id = b.department_id) AS dep_name
FROM job_history a;

-- -----

-- 메인쿼리
-- SELECT
-- FROM
-- WHERE(서브쿼리(서브쿼리2))
-- 메인쿼리: 부서테이블에서 부서ID와 부서name출력하기
-- 서브쿼리 : 특정 조건
-- p.195
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS 
    (SELECT 1
    FROM employees b
    WHERE a.department_id = department_id
    AND b.salary > (SELECT AVG(salary)
                    FROM employees));


-- --- -- 


-- 메인 쿼리 : 사원 테이블의 사원들의 부서별 평균 급여를 조회
-- 서브 쿼리 : 상위 부서가 기획부 (부서 번호가 90)에속함
SELECT department_id, AVG(salary)
FROM employees a
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE parent_id = 90)
GROUP BY department_id;

                    
-- 6장은 여기서 끝인 걸로. 남은 내용은 하지 않는다.
