-- 6�� p.198
-- ��������
-- SELECT, FROM, WHERE
-- FROM ������ ���� ���� : INLINE ��
-- �����ϱ� ( ��������, �������� )
-- �������� : ��� ���̺����� ID, NAME ���
--            �м� ���̺����� �μ� ID, �μ�NAME ���
--            ��� ���̺��� �޿��� ��ȹ�μ��� ��ձ޿����� ���� ���
--            AND a. salary > d. avg_salary : ���ǽ�
-- �������� : ��ȹ�μ��� ��� �޿� ( �����ڵ� �м����� �������� ���ؾ� �Ѵ�. )

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

-- p.199 �ϴ�
-- 2000 �� ��Ż���� ��� �����(�� ���)���� ū ���� ��� ������� �����ϴ� ��.
-- ���� ���� 2 ��

-- SELECT a.* -- ��ü ���̺� ������
-- FROM ( ��������1) a, (��������2) b
-- WHERE a.month_avg > b. year_avg;

-- SELECT a.* -- ��ü ���̺� ������
-- FROM (���� ��� ����� ����) a, (�� ��� ����� ����) b
-- WHERE a.month_avg > b. year_avg;

-- ���� ���� ������� ���� �ڵ�.
-- ���� ��� ����� ����
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

-- ����� ����� ����
SELECT 
    ROUND(AVG(a.amount_sold)) AS year_avg
FROM 
    sales a
    , customers b
    , countries c
WHERE a.sales_month BETWEEN '20001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID 
    AND c.COUNTRY_NAME = 'Italy'; -- ��Ż����
    


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
                AND c.COUNTRY_NAME = 'Italy' -- ��Ż����
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







-- ## 7��. ������ ���� ����� ������ ���� ��� ���� �ٷ��

-- 1. ������ ����

-- p.208 �μ� ����

-- ������ ����

-- p.211
-- START WITH ���� & CONNECT BY ����
-- �̷� �͵��� �ִ�~ �� ������ �ϱ�.
-- parent == ���� �μ� ������ ������ ����.
-- CONNECT BY PRIOR department_id = parent_id 
-- PRIOR ��ġ�� parent ��ġ Ȯ���ϱ�. �� �̷�����.
-- ���� �μ��� �����ʿ� ����.

SELECT 
    department_id
    ,LPAD('',3*(LEVEL -1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- ���� �μ��� �����ʿ� ���� !!
-- LPAD = ���ʺ��� ä����

-- ��� ���̺� �ִ� manager_id, employee_id
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
-- NOCYCLE �߰���.
-- NOCYCLE == ��ĵ�� ��� ��������.

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
-- �� ���� ������
-- �ʹ� ���ð� ������ �ʿ� NO 



-- p.214
-- ������ ���� ��ȭ�н� 
-- ������ ����. ORDER BY ���� ����
-- ORDER BY SIBLINGS BY
-- 1> ������ ���� ����
SELECT department_id, LPAD(' ', 3*(LEVEL-1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER BY department_name;



-- 2> CONNECT_BY_ROOT
-- ������
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
-- �׳� ���� ��.

-- 4> SYS_CONNECT_BY_PATH(colm,char)
-- �̷��Ե� ������ �� �ִ�.

-- 5> CONNECT_ISCYCLE
-- �̰� �ٽ�. p.218,219 NoCYCLE
-- ,�������� LOOP

-- p.220
-- ������ ���� ����

-- 1> ���� ������ ����
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
-- ���Ⲩ ȥ�� �غ���?
-- '�ο� <--> Į�� ��ȯ�ϱ�' �б� or Ÿ���� �غ���.


-- p.216
-- 2. WITH ��
-- �ݺ��Ǵ� ������ ���ֱ� ���ؼ�
-- �����ϰ� �ڵ带 ¥�� ���ؼ�
-- ���������� ������ ���
-- ������, ����, ����

WITH b2 AS 
    ( SELECT period, region, sum(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region)

SELECT * FROM b2;
-- WITH�� �� ���� WITH�� ������� �ʱ� ������ ���� �����ؾ��Ѵ�.
 
-- p.231 
-- �м� �Լ��� window �Լ�
-- ����
-- �м��Լ� (�Ű�����) OVER (PARTITION BY .... )
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

-- WITH �� ����Ͽ� �غ� ��.
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
-- �� �̷��� �ֱ���

-- 3> CUM_DIST()
-- ����� ���� ��ȯ
-- 60�� �μ��� ���� CUM_DIST() &  CUM_DIST()���� ��ȸ�Ѵ�.

-- p.236
-- NTIME(����)�Լ�
-- 5���� ���� ���ڸ�ŭ ��´�.

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
-- LAG ����ο��� ���� ��ȯ�Ѵ�.
-- LEAD ����ο��� ���� ��ȯ�Ѵ�.

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

-- WINDOW ��
-- p. 240
-- ��ܿ� 8 ���� �̷� �͵��� �ֱ��� �ϱ�.
-- ������ �Ի����� ������ ó��.
-- �޿�, UNBOUNDED PRECEDING �μ��� �Ի� ���ڰ� ���� ���� ���
--       UNBOUNDED FOLLOWING �μ��� �Ի� ���ڰ� ���� ���� ���
-- �̷ν� ���� �հ踦 ���ϰ��� �ϴ°�.

-- �����հ�
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


-- p241 RANGE�� ����ѰŴϱ� �Ⱦ�⸸ ����.


-- WINDOW �Լ�





