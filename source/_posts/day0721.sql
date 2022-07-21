-- 5�� p.152

-- ## �⺻ ���� �Լ� 

-- 1. count

--COUNT�� ���� ��� �Ǽ�, �� ��ü �ο� ���� ��ȯ�ϴ� ���� �Լ��̴�.
-- ���̺� ��ü �ο�� ���� WHERE �������� �ɷ��� �ο� ���� ��ȯ�Ѵ�.

SELECT COUNT(*)
FROM employees;

----

SELECT COUNT(employee_id)
FROM employees;

SELECT COUNT(department_id)
FROM employees;
-- = count�� null ���� ���� �ʴ´�.

-- --- ������ ���� ��ȸ��

SELECT COUNT(DISTINCT department_id)
FROM employees;

-- ---

SELECT DISTINCT department_id
FROM employees
ORDER BY 1;

-- --

-- ���� ��跮
-- p.154 
-- �հ�, ���, �ּ�, �ִ�, �λ�, ǥ������
-- SQL --> ��Ե���, �ӽŷ���, ������ ���� ������ �̿� ���� �ǰ� �ִ�.
-- Ŭ����(�������� �� �ٷ��� �ʴ´�.)
-- ex) AWS(50%), Azure(30%), GCP(20%) �� �ִµ�
-- AWS �Ｚ���� �� ���� ����.
-- AWS �����.


-- 2. SUM

SELECT SUM(salary)
FROM employees;

-- --

SELECT SUM(salary), SUM(DISTINCT salary)
FROM employees;


-- 3. AVG 
-- ��հ� ��ȯ 

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

-- ## 2. GROUP BY ���� HAVING ��



SELECT department_id
    , SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- -- 

SELECT * FROM kor_loan_status; -- ���� ���� ������ �ʾ�

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
-- SELECT�� region�� ����簡, �׷���̿� region�� �߰��ϵ簡.


-- ----- ---

SELECT 
    period, region
    , SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY region, period 
HAVING SUM(loan_jan_amt) > 100000
ORDER BY region;


-- ## 3.ROLLUP �� & CUBE ��

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

-- ##  4. ���� ������

-- UNION

CREATE TABLE exp_goods_asia (
           country VARCHAR2(10),
           seq     NUMBER,
           goods   VARCHAR2(80));

    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 1, '�������� ������');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 2, '�ڵ���');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 3, '��������ȸ��');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 4, '����');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 5,  'LCD');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 6,  '�ڵ�����ǰ');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 7,  '�޴���ȭ');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 8,  'ȯ��źȭ����');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 9,  '�����۽ű� ���÷��� �μ�ǰ');
    INSERT INTO exp_goods_asia VALUES ('�ѱ�', 10,  'ö �Ǵ� ���ձݰ�');

    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 1, '�ڵ���');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 3, '��������ȸ��');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 4, '����');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 5, '�ݵ�ü������');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 6, 'ȭ����');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 7, '�������� ������');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 8, '�Ǽ����');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
    INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 10, '����');
commit;


SELECT * FROM exp_goods_asia;

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
ORDER BY seq;


-- �� ������ ��ġ�� ����ǰ���� �� ���� ��ȸ�� �ǵ��� �Ѵ�.
-- UNION (������) 


SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION 
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION ALL 
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';
--UNION �� ����ѵ� �ߺ��� �׸� ��� ��ȸ�Ǵ� �������� �ִ�.


-- INTERSECT(������)

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';


-- MINUS(������)

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';
-- �� ������ �ѱ����� ������ �Ϻ����� ���� ����ǰ ����� ��Ÿ�´�.


SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�';
-- �� ������ �Ϻ����� ������ �ѱ����� ���� ����ǰ ����� ��Ÿ�´�.



-- p.168 ���� �������� ���ѻ���

-- ������ ���� ���丸 �˸� ���� �������� �⺻ ������ �����ϴ� ���� ������� ���� ���̴�.
-- ������ ���� �����ڸ� ����� �� �����ؾ� �� ������ �ֵ�, �����ϸ� ������ ����.

-- 1> ���� �����ڷ� ����Ǵ� �� SELECT ���� SELECT ����Ʈ�� ������
-- ������ Ÿ���� ��ġ�ؾ��Ѵ�.

SELECT goods
FRom exp_goods_asia
WHERE country= '�ѱ�'
UNION
SELECT seq,goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

-- ---

SELECT seq, goods
FRom exp_goods_asia
WHERE country= '�ѱ�'
UNION
SELECT seq, goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

-- --- 

SELECT seq,goods
FRom exp_goods_asia
WHERE country= '�ѱ�'
INTERSECT
SELECT seq,goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT seq
FRom exp_goods_asia
WHERE country= '�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

-- --
-- 1>
SELECT goods
FRom exp_goods_asia
WHERE country= '�ѱ�'
ORDER BY goods
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';
-- 2>
SELECT goods
FRom exp_goods_asia
WHERE country= '�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';
-- 3>
-- 4>

-- p.171 GROUPING SETS��

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period,gubun);

-- --


SELECT period, gubun,region, SUM(loan_jan_amt) AS totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
AND region IN ('����','���')
GROUP BY GROUPING SETS(period,(gubun,region));

-- --- 

-- �� å���� SQL �Ƿ��� ���Ǵ� ������


-- p.175 6�� ���̺� ���̸� ������ �ִ� ���ΰ� ���� ���� �˾ƺ���

-- ## 1. ������ ����

-- ## 2. ���� ���ΰ� �ܺ� ����

-- ���� ����
SELECT 
    a.employee_id
    ,a.emp_name, a.department_id
    ,b.department_name
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id;

-- -----

-- ���� ���� 
-- 1> EXIST ���
SELECT department_id, department_name
FROM departments a
WHERE EXISTS ( SELECT *FROM employees b
    WHERE a.department_id = b.department_id
    AND b.salary>3000)
ORDER BY a.department_name;

-- 2> IN ���
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

-- ��Ƽ����

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

-- ���� ����
-- ������ �Ϸ���, �� ���� ���̺�
-- ���̺��� �ڱ��ڽŰ� ����
-- ���� �μ���ȣ�� ���� ��� �� A�����ȣ�� B������� ���� �� ��ȸ

SELECT 
    a.employee_id, a.emp_name
    ,b.employee_id, b.emp_name, a.department_id
FROM employees a,
    employees b
WHERE a.employee_id < b.employee_id
AND a.department_id = b.department_id
AND a.department_id =20;
-- "��, ���������� �̷������� �Ŵ±���."

-- �ܺ� ����

-- 1> �Ϲ� ����
SELECT 
    a.department_id, a.department_name
    ,b.job_id, b.department_id
FROM departments a,
    job_history b
WHERE a.department_id = b.department_id;

-- 2> �ܺ�����
SELECT 
    a.department_id, a.department_name
    ,b.job_id, b.department_id
FROM departments a,
    job_history b
WHERE a.department_id = b.department_id(+);
-- a���̺��� �������� b�� �����̴°�.


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

-- �ܺ� ���� �� �˾ƾ� �� ������ �����غ���.
-- 1. ���� ��� ���̺� �� �����Ͱ� ���� ���̺� ���� ���ǿ� (+)�� ���δ�.
-- 2. �ܺ� ������ ���̴� ������ ���� ���� �� ��� ���ǿ� (+)�� ���δ�.
-- 3. �� ���� �� ���̺��� �ܺ� ������ ���� �� �ִ�.
-- ���� ��� ���� ��� ���̺��� A,B,C 3���̰�, 
-- A�� �������� B ���̺��� �ܺ� �������� �����ߴٸ�, 
-- ���ÿ� C�� �������� B���̺� �ܺ� ������ �� ���� ����.
-- 4. (+)�����ڰ� ���� ���ǰ� OR�� ���� ����� �� ����.
-- 5. (+)�����ڰ� ���� ���ǿ��� IN�����ڸ� ���� ����� �� ����.
-- (��, IN���� ���ԵǴ� ���� 1���� ���� ��밡���ϴ�.)

-- īŸ�þ� ���� (������ ����. �ֳ��ϸ� �����͸� �ø��� ���̱� �����̴�.)

SELECT a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a,
    departments b;
    
-- --

-- ## 3. ANSI ����

-- ANSI ���� ����
-- <���� ����>
--SELECT A.�÷�1, A.�÷�2, B.�÷�1, B.�÷�2 ...
--FROM ���̺�A, ���̺�B
--WHERE A.�÷�1 = B.�÷�1 - > ���� ����
--...;

-- <ANSI ����>
--SELECT A.�÷�1, A.�÷�2, B.�÷�1, B.�÷�2...
--FROM ���̺�A
--INNER JOIN ���̺�B
-- ON (A.�÷�1 = B.�÷�1)-> ���� ����
-- WHERE ...;


-- <���� ����>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a,
    departments b
WHERE a.department_id = b. department_id
AND a.hire_date>= TO_DATE('2003-01-01','YYYY-MM-DD');


-- <ANSI ����>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a
INNER JOIN departments b
ON (a.department_id = b.department_id)
WHERE a.hire_date >= TO_DATE ('2003-01-01','YYYY-MM-DD');

-- ---- 

-- p.186 
-- <�ߵȸ� ���>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a
INNER JOIN departments b
USING (department_id)
WHERE a.hire_date>=TO_DATE('2003-01-01','YYYY-MM-DD');

-- <�� �� ���>
SELECT 
    a.employee_id, a.emp_name
    ,department_id, b.department_name
FROM employees a
INNER JOIN departments b
USING (department_id)
WHERE a.hire_date>=TO_DATE('2003-01-01','YYYY-MM-DD');

-- ANSI �ܺ� ����

-- <���� ����>

SELECT 
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM employees a,
    job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);


--<ANSI ����>

-- �������� �����ΰ�.
SELECT 
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM employees a
RIGHT OUTER JOIN job_history b
-- b�� �����̶�� �ǰ�?
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);
    
-- --

-- ������ �����ΰ�
SELECT
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM job_history b
RIGHT OUTER JOIN employees a
-- a�� �����̶�� �ǰ�?
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);

-- ���� �ܺ� ������ OUTER ��� Ű���带 ���̴µ�, �̴� ������ �����ϴ�.
-- ��, LEFT JOIN Ȥ�� RIGHT JOIN �̶�� ����ص� �̴� �ܺ� ������ �ǹ��Ѵ�.

SELECT
    a.employee_id, a.emp_name
    ,b.job_id, b.department_id
FROM employees a
LEFT JOIN job_history b
ON (a.employee_id = b.employee_id
    and a.department_id = b.department_id);

-- CROSS ����(�̰� ���ص�. �Ƚ�)

-- <���� ����>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a,
    departments b;

-- <ANSI ����>
SELECT 
    a.employee_id, a.emp_name
    ,b.department_id, b.department_name
FROM employees a
CROSS JOIN departments b;

-- p.189

-- FULL OUTER ���� (�̰ŵ� �� �Ⱦ��δٳ� ��... )

CREATE TABLE HONG_A (EMP_ID INT);
CREATE TABLE HONG_B (EMP_ID INT);

INSERT INTO HONG_A VALUES (10);
INSERT INTO HONG_A VALUES (20);
INSERT INTO HONG_A VALUES (40);

INSERT INTO HONG_B VALUES (10);
INSERT INTO HONG_B VALUES (20);
INSERT INTO HONG_B VALUES (30);

COMMIT;

-- �ܺ� ������ �ؾ��ϴµ�, ���ݱ��� ��� �������δ� �� �������� ó���� �� ����.
-- (���� �忡�� ���� ���� �����ڸ� ����ϸ� �����ϵ�.)
-- �ܺ� ������ �� ��, A ���̺��� �������� �ϸ� 30��, 
-- B ���̺��� �������� �ϸ� 40�� ������. 
-- �׷��ٰ� �ؼ� ������ ���� �ϸ� ������ �߻��Ѵ�.

SELECT a.emp_id, b.emp_id
FROM hong_a a, hong_b b
WHERE a.emp_id(+) = b.emp_id(+);
-- �翬�� ������ �ᰡ.

SELECT a.emp_id, b.emp_id
FROM hong_a a
FULL OUTER JOIN hong_b b
ON (a.emp_id = b.emp_id);


-- ���忡���� ���� ����Ŭ ������
-- ANSI ���� ��, � ���� ���� ����ұ�??
-- �翬�� �Ƚø� ���� ����.


-- p.191 �������� ****
-- SQL ������ ����Ʈ����Ʈ!
-- ��������
-- SELECT, FROM, WHERE�� ���δ�.

SELECT AVG(salary)  FROM (employees);


-- ����1
-- ������
SELECT count(*)
FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees) ;


-- ����2    
-- IN (���� ������� ���� �� �ִ�.)
SELECT count(*)
FROM employees
WHERE department_id IN 
    (SELECT department_id
    FROM departments
    WHERE parent_id IS NULL);
    
--����3
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
    FROM job_history);
    
 
(SELECT employee_id, job_id FROM job_history);
-- --- -



-- ���� ���� SELECT�� �ƴ϶� UPDATE, DELETE���� �� �� �ִ�.
-- commit ����
-- ������ �ִ� ��������

-- <�� ����� �޿��� ��� �ݾ����� ����>
UPDATE employees
SET salary = (SELECT AVG(salary)
                FROM employees);

-- <��� �޿����� ���� �޴� ��� ����>
DELETE employees
WHERE salary >= (SELECT AVG(salary)
                FROM employees);
-- �� 107���� �� ��������??    
    
    
ROLLBACK;

-- ������ �ִ� ���� ����
-- p194 �ϴ� SELECT���� ��������

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

-- ��������
-- SELECT
-- FROM
-- WHERE(��������(��������2))
-- ��������: �μ����̺��� �μ�ID�� �μ�name����ϱ�
-- �������� : Ư�� ����
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


-- ���� ���� : ��� ���̺��� ������� �μ��� ��� �޿��� ��ȸ
-- ���� ���� : ���� �μ��� ��ȹ�� (�μ� ��ȣ�� 90)������
SELECT department_id, AVG(salary)
FROM employees a
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE parent_id = 90)
GROUP BY department_id;

                    
-- 6���� ���⼭ ���� �ɷ�. ���� ������ ���� �ʴ´�.
