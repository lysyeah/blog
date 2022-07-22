-- 6장 p.198
-- 서브쿼리
-- SELECT, FROM, WHERE
-- FROM 절에서 쓰기 위해 : INLINE 뷰
-- 구분하기 ( 메인쿼리, 서브쿼리 )
-- 메인쿼리 : 사원 테이블에서는 ID, NAME 출력
--            분석 테이블에서는 부서 ID, 부서NAME 출력
--            사원 테이블의 급여가 기획부서의 평균급여보다 높은 사람
--            AND a. salary > d. avg_salary : 조건식
-- 서브쿼리 : 기획부서의 평균 급여 ( 개발자든 분석가든 서브쿼리 잘해야 한다. )

SELECT 
    a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM employees a
    ,departments b
    ,(SELECT AVG(c.salary)AS avg_salary 
    FROM departments b
            , employees c
            WHERE b.parent_id = 90
            AND b.department_id = c. department_id) d
WHERE a.department_id = b. department_id
AND a. salary > d. avg_salary;

-- p.199 하단
-- 2000 년 이탈리아 평균 매출액(연 평균)보다 큰 월의 평균 매출액을 구분하는 것.
-- 서브 쿼리 2 개

-- SELECT a.* -- 전체 테이블 가져와
-- FROM ( 서브쿼리1) a, (서브쿼리2) b
-- WHERE a.month_avg > b. year_avg;

-- SELECT a.* -- 전체 테이블 가져와
-- FROM (월별 평균 매출액 쿼리) a, (연 평균 매출액 쿼리) b
-- WHERE a.month_avg > b. year_avg;

-- 에러 났던 사람들을 위한 코드.
-- 월별 평균 매출액 쿼리
SELECT a.sales_month    
        ,ROUND(AVG(a.amount_sold))AS month_avg
FROM sales a
    ,customers b
    ,countries c
    
WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_id = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy'
GROUP BY a.sales_month;

-- 연평균 매출액 쿼리
SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy'; -- 이탈리아
    


SELECT a.*
FROM (SELECT a.sales_month
     , ROUND(AVG(a.amount_sold)) AS month_avg 
            FROM 
                sales a 
                , customers b
                , countries c
            WHERE a.sales_month BETWEEN '200001' AND '200012'
                AND a.cust_id = b.CUST_ID 
                AND b.COUNTRY_ID = c.COUNTRY_ID
                AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
                GROUP BY a.sales_month) a
                , (SELECT 
                    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy') b
WHERE a.month_avg > b.year_avg;







-- ## 7장. 복잡한 연산 결과를 추출해 내는 고급 쿼리 다루기

-- 1. 계층형 쿼리

-- p.208 부서 정보

-- 계층형 구조

-- p.211
-- START WITH 조건 & CONNECT BY 조건
-- 이런 것들이 있다~ 이 정도만 하기.
-- parent == 상위 부서 정보를 가지고 있음.
-- CONNECT BY PRIOR department_id = parent_id 
-- PRIOR 위치랑 parent 위치 확인하기. 아 이렇구나.
-- 상위 부서를 오른쪽에 쓴다.

SELECT 
    department_id
    ,LPAD('',3*(LEVEL -1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- 상위 부서를 오른쪽에 쓴다 !!
-- LPAD = 왼쪽부터 채워라

-- 사원 테이블에 있는 manager_id, employee_id
SELECT 
    a.employee_id
    , LPAD(' ', 3* (LEVEL-1))|| a.emp_name
    ,LEVEL
    , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH  a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id;


SELECT 
    a.employee_id
    , LPAD(' ', 3* (LEVEL-1))|| a.emp_name
    ,LEVEL
    , b.department_name
FROM employees a, departments b
WHERE a.department_id = b.department_id
START WITH  a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id;
-- NOCYCLE 추가함.
-- NOCYCLE == 스캔을 계속 하지마라.

SELECT * FROM employees;


-- p.213

SELECT 
    a.employee_id
    , LPAD(' ', 3* (LEVEL-1))|| a.emp_name
    , LEVEL
    , b.department_name
    , a.DEPARTMENT_ID
FROM employees a, departments b
WHERE a.department_id = b.department_id
AND a.department_id = 30
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id;

SELECT 
    a.employee_id
    , LPAD(' ', 3* (LEVEL-1))|| a.emp_name
    , LEVEL
    , b.department_name
    , a.DEPARTMENT_ID
FROM employees a, departments b
WHERE a.department_id = b.department_id
--AND a.department_id = 30
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id
AND a.department_id = 30;
-- 두 가지 차이점
-- 너무 빡시게 리뷰할 필요 NO 



-- p.214
-- 계층형 쿼리 심화학습 
-- 쿼리가 나옴. ORDER BY 정렬 가능
-- ORDER BY SIBLINGS BY
-- 1> 계층형 쿼리 정렬
SELECT department_id, LPAD(' ', 3*(LEVEL-1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER BY department_name;



-- 2> CONNECT_BY_ROOT
-- 연산자
SELECT 
    department_id
    , LPAD(' ', 3*(LEVEL-1)) || department_name
    , LEVEL
    , CONNECT_BY_ROOT department_name AS root_name
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;
    

-- p.216
-- 3> CONNECT_BY_ISLEAF
-- 그냥 보면 됨.

-- 4> SYS_CONNECT_BY_PATH(colm,char)
-- 이렇게도 추출할 수 있다.

-- 5> CONNECT_ISCYCLE
-- 이게 핵심. p.218,219 NoCYCLE
-- ,계층형은 LOOP

-- p.220
-- 계층형 쿼리 응용

-- 1> 샘플 데이터 생성
CREATE TABLE ex7_1 AS
SELECT ROWNUM seq,
    '2014' || LPAD(CEIL(ROWNUM/1000), 2,'0') month,
    ROUND(DBMS_RANDOM.VALUE(100,1000)) amt
FROM DUAL
CONNECT BY LEVEL <= 12000;

SELECT * FROM ex7_1;

SELECT month, SUM(amt)
FROM ex7_1
GROUP BY month
ORDER BY month;


-- CONNECT BY LEVEL <= 12000 
-- 여기꺼 혼자 해보기?
-- '로우 <--> 칼럼 변환하기' 읽기 or 타이핑 해보기.


-- p.216
-- 2. WITH 절
-- 반복되는 쿼리를 없애기 위해서
-- 간단하게 코드를 짜기 위해서
-- 서브쿼리의 가독성 향상
-- 연도별, 최종, 월별

WITH b2 AS 
    ( SELECT period, region, sum(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region)

SELECT * FROM b2;
-- WITH를 쓸 때는 WITH가 저장되지 않기 때문에 같이 실행해야한다.
 
-- p.231 
-- 분석 함수와 window 함수
-- 문법
-- 분석함수 (매개변수) OVER (PARTITION BY .... )
-- ROW_ NUMBER() / ROWNUM

-- 1> ROW_NUMBER()
SELECT department_id, emp_name,
    ROW_NUMBER() OVER (PARTITION BY department_id
        ORDER BY department_id, emp_name) dep_rows
FROM employees;

-- 2> RANK(), DENSE_RANK()
SELECT 
    department_id
    , emp_name
    , salary
    , RANK() OVER
    (PARTITION BY department_id ORDER BY salary) dep_rank
FROM employees;
    
-- p234

-- WITH 를 사용하여 해본 것.
WITH q2 AS 

( SELECT 
    department_id
    , emp_name
    , salary
--      RANK() OVER (PARTITION BY department_id ORDER BY salary) dep_rank

FROM employees )

SELECT * 
FROM (SELECT 
    department_id
    , emp_name
    , salary
    -- , RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
    , DENSE_RANK () OVER (PARTITION BY department_id ORDER BY salary) dep_rank
FROM employees)
WHERE dep_rank <= 3;

-- 3> CUM_DIST()
-- 아 이런게 있구나

-- 3> CUM_DIST()
-- 백분위 순위 반환
-- 60번 부서에 대한 CUM_DIST() &  CUM_DIST()값을 조회한다.

-- p.236
-- NTIME(숫자)함수
-- 5개의 행을 숫자만큼 담는다.

SELECT 
    department_id
    , emp_name,salary
    , rank() OVER (PARTITION BY department_id
        ORDER BY salary ) ranking
    , CUME_DIST() OVER (PARTITION BY department_id
        ORDER BY salary ) cume_dist_value
    , PERCENT_RANK() OVER (PARTITION BY department_id
        ORDER BY salary ) percentile
    FROM employees
    WHERE department_id = 60;


-- p.237
SELECT department_id, emp_name,
    salary,
    NTILE(4) OVER (PARTITION BY department_id
        ORDER BY salary ) NTILES
    FROM employees
    WHERE department_id IN (30,60);


-- LAD, LEAD ***
-- LAG 선행로우의 값을 반환한다.
-- LEAD 후행로우의 값을 반환한다.

SELECT emp_name, hire_date, salary,
    LAG(Salary,1,0) OVER (ORDER BY hire_date) AS prev_sal,
    LEAD(Salary,1,0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;

SELECT emp_name, hire_date, salary,
    LAG(Salary,2,0) OVER (ORDER BY hire_date) AS prev_sal,
    LEAD(Salary,2,0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;

-- WINDOW 절
-- p. 240
-- 상단에 8 가지 이런 것들이 있구나 하기.
-- 정렬은 입사일자 순으로 처리.
-- 급여, UNBOUNDED PRECEDING 부서별 입사 일자가 가장 빠른 사원
--       UNBOUNDED FOLLOWING 부서별 입사 일자가 가장 늦은 사원
-- 이로써 누적 합계를 구하고자 하는것.

-- 누적합계
SELECT
    department_id
    , emp_name
    , hire_date
    , salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_current_sal
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
       ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_end_sal
FROM employees
WHERE department_id IN (30,90);


-- p241 RANGE도 비슷한거니까 훑어보기만 하자.


-- WINDOW 함수





