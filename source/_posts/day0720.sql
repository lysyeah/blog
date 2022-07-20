-- p92 3��  SQL ���� ���캸��

SELECT * FROM employees; -- 107 ���� ������ 
-- SELECT ��
-- p.92
-- �޿��� 5000�� �Ѵ� �����ȣ�� ����� ��ȸ


SELECT 
    employee_id
    , emp_name
    , salary

FROM employees
WHERE salary > 5000
ORDER BY employee_id;

-- �޿��� 5000 �̻�, job_id, IT_PROG ��� ��ȸ

SELECT employee_id, emp_name, job_id, salary
FROM employees
WHERE salary > 5000
AND job_id = 'IT_PROG'
ORDER BY employee_id;

-- ���̺� ��Ī �� �� ����.

SELECT 
-- a ���̺��� ��(=employees)
    a.employee_id
    ,a.emp_name
    ,a.department_id
-- b ���̺��� �� (=departments)
    ,b.department_name
FROM 
    employees a
    ,departments b
WHERE a.department_id = b.department_id;

SELECT * FROM departments;

-- INSERT �� & UPDATE �� ȥ���غ���.

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

-- �÷��� ��� ���� ����

INSERT INTO ex3_1
VALUES ('GHI',10,SYSDATE);

INSERT INTO ex3_1 (col1,col2)
VALUES('GHI',20);

INSERT INTO ex3_1
VALUES ('GHI',20);

-- INSERT ~ SELECT ����

CREATE TABLE ex3_2(
    emp_id NUMBER,
    emp_name VARCHAR2(100)
);


INSERT INTO ex3_2 (emp_id,emp_name)
SELECT employee_id, emp_name
FROM employees
WHERE salary >5000;
-- ���⼭�� �÷������� ������ Ÿ���� ���߾���Ѵ�. 
-- �׷��� ������ Ÿ���� ������ �ʾƵ� INSER �� �����ϴ� ��찡 �ִ�.
-- �ٷ� �ؿ��� Ȯ���غ���

INSERT INTO ex3_1 (col1,col2,col3)
VALUES (10,'10','2014-01-01');

-- UPDATE��

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


-- MERGE �� p.101
-- �����͸� ��ġ�� �Ǵ� �߰��ϴ�
-- ������ ���ؼ� ���̺� 
-- �ش� ���ǿ� �´� ������ ������ �߰�
-- ������ UPDATE ���� �����Ѵ�.
-- �� �����̳�
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
-- ���� ���� subquary

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

-- MERGE �� ���ؼ� �ۼ�
-- ������ ��� 146 �߿��� ex3_3 ���̺� ����
-- ����� ���, ������ ���, �޿�, �޿� * 0.001 
-- ex3_3 table�� 160�� ����� ���ʽ� �ݾ��� 7.5�� �ű� �Է�

SELECT * FROM ex3_3;

-- �������� ���� : ���� ���� �ȿ� �߰��� ����
-- UPDATE & INSERT ����
-- �� ���� ���̺� ����

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
-- ���̺� ����

DELETE ex3_3; 
-- DROP �� ���̺� ��ü�� ���ִ°Ű�, 
-- DELETE �� ��鸸 �� ������Ű�� ���̴�.
SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.107
-- commit & rollback
-- commit�� ������ �����͸� �����ͺ��̽��� ���������� �ݿ�
-- rollback�� �� �ݴ�� ������ �����͸� �����ϱ� ���� ���·� �ǵ����� ����

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

-- ROWID, �ּ� ��
-- DBA, DB �𵨸�(�����ӵ� ���� --> Ư¡)
SELECT 
    ROWNUM
    , employee_id
    ,ROWID
FROM employees
WHERE ROWNUM <5;

-- ������
-- OPERATOR ���� ����
-- ���� ������ & ���� ������
-- '||' �� ���ڸ� ���̴� ���� ������
-- AS : = Alias�� ��� 

SELECT 
    employee_id ||'-'|| emp_name AS employee_info
FROM employees
WHERE ROWNUM <5;

-- p.113
-- ǥ����
-- ���ǹ�, if ���ǹ� (PL/SQL)
-- CASE ǥ����
SELECT 
    employee_id
    ,salary
    ,CASE WHEN salary <= 5000 THEN 'C���'
         WHEN salary > 5000 AND salary <= 15000 THEN 'B���'
         ELSE 'A���'
    END AS salary_grade
FROM employees;

-- ���ǽ�
-- TRUE, FALSE, UNKNOWN �� ���� Ÿ������ ��ȯ 
-- �� ���ǽ�
-- �м���, DB���� �����͸� �����Ҷ� ���������� ����.

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

-- �� ���ǽ� 
SELECT 
    employee_id
    ,salary
FROM employees
WHERE NOT (salary >= 2500)
ORDER BY employee_id;
    
-- NULL ���ǽ�, BETWEEN AND ���ǽ� ȥ���غ���


-- IN ���ǽ�
-- �������� ����� ���� ���Ե� ���� ��ȯ�ϴ� �� �տ��� ����� ANY
SELECT 
    employee_id
    , salary
FROM employees
WHERE salary IN ( 2000,3000,4000)
ORDER BY employee_id;


-- NOT IN 

-- EXISTS ���ǽ�
-- ���� ������ �� �� ����.
-- "" �̹� �� ���������� �߽����� ���θ� �ϸ� �ȴ�. ""
-- "������"(��ī���������..)
--    �ڵ��׽�Ʈ ��(�˰���) / �������(����) / �ӿ� ����
-- "�м���" = 'SQL / ����' �� ������ ����.


-- Like ���ǽ�
-- ���ڿ��� ������ �˻��ؼ� ����ϴ� ���ǽ�

SELECT
    emp_name
FROM employees
WHERE emp_name LIKE '%_A_%'
ORDER BY emp_name;

CREATE TABLE ex3_5(
names VARCHAR2(30)
);

INSERT INTO ex3_5 VALUES ('ȫ�浿');
INSERT INTO ex3_5 VALUES ('ȫ���');
INSERT INTO ex3_5 VALUES ('ȫ���');
INSERT INTO ex3_5 VALUES ('ȫ���');



SELECT * FROM ex3_5
WHERE names LIKE 'ȫ��%';


SELECT * FROM ex3_5
WHERE names LIKe 'ȫ��_';


-- 4�� �����Լ�
--p.126
SELECT ABS(10), ABS(-10), ABS(-10.123)
    FROM DUAL;

-- ���� ��ȯ
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001)
    FROM DUAL;
    
-- ����
SELECT FLOOR(10.123),FLOOR(10.541),FLOOR(11.001)
    FROM DUAL;

-- ROUND     
SELECT ROUND (10.154), ROUND(10.541), ROUND(11.001)
    FROM DUAL;

-- �ؿ� �� �� �ϱ�

-- TRUNC
-- �ݿø� ����. �Ҽ��� ����, �ڸ��� ���� ����
SELECT TRUNC (115.155), TRUNC(115.115,1), TRUNC(115.155, 2), TRUNC(115.155,-2)
    FROM DUAL;
    
-- POWER
-- POWER �Լ�, SQRT(������,��Ʈ)
SELECT POWER(3,2),POWER(3,3),POWER(3,3.001)
    FROM DUAL;
    
SELECT POWER(-3,3.0001)
    FROM DUAL;

SELECT SQRT(2), SQRT(5)
    FROM DUAL;

-- ���� : SQL, DB���� �ڷḦ ��ȸ�ϴ� �뵵
-- ���� : SQL --> ����, ��� ����ó�� ��ȭ
-- ����Ŭ 19C 

-- MOD,REMAINDER
SELECT MOD(19,4), MOD(19.123,4.2)
    FROM DUAL;
    
SELECT REMAINDER(19,4), REMAINDER(19.123,4.2)
    FROM DUAL;
    
-- EXP , LN, LOG
SELECT EXP(2), LN(2.713), LOG(10,100)
    FROM DUAL;

-- ���ڿ� ������ ��ó��
-- ���ӻ�,
-- ä�� --> ���ڵ����� 
-- �ؽ�Ʈ ���̴�(��,����Ŭ����)

SELECT INITCAP('never say goodbye'), INITCAP('never6say*good��bye')
    FROM DUAL;

SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say good bye')
    FROM DUAL;

-- CONCAT SUBSTR, SUBSTRB

SELECT CONCAT('I HAVE', 'A DREAM'), 'I HAVE' || 'A DREAM'
    FROM DUAL;

SELECT SUBSTR('ABCDEFG', 1,4), SUBSTR('ABCDEFG', -1,4)
    FROM DUAL;
    
SELECT SUBSTRB ('ABCDEFG',1,4), SUBSTRB('�����ٶ󸶹ٻ�',1,4)
    FROm DUAL;

-- LTRIM(char,set), RTRIM(char,set)

SELECT LTRIM('ABCDEFGABC','ABC'),
       LTRIM('�����ٶ�','��'),
       RTRIM('ABCDEFGABC','ABC'),
       RTRIM('�����ٶ�','��')
    FROM DUAL;

-- LPAD, RPAD (ä���)

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
SELECT REPLACE ('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?','��','��')
    FROM DUAL;
..... �� �ϱ�


-- p.138 ��¥ �Լ�
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
SELECT NEXT_DAY(SYSDATE,'�ݿ���')
    FROM DUAL;

--p.140 ��ȯ�Լ�

-- TO_CHAR
SELECT TO_CHAR(123456789,'999,999,999')
    FROM DUAL;

SELECT TO_CHAR(SYSDATE,'AM')
    FROM DUAL;

-- TO_NUMBER ���ڸ� ���ڷ� ��ȯ
SELECT TO_NUMBER('12345')
    FROM DUAL;
    
-- p.143 NULL
SELECT manager_id, employee_id FROM employees;

-- NVL : ǥ����1�� NULL �� ��, ǥ����2�� ��ȯ�Ѵ�.
SELECT NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;

-- NVL2 : ǥ����1�� NULL�� �ƴϸ� ǥ����2�� ���
--          ǥ����2�� NULL�̸� ǥ����3�� ���

SELECT employee_id
     , salary
     , commission_pct
     , NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees
WHERE employee_id IN (118, 179);

-- COALESCE 
-- �Ű������� ������ ǥ���Ŀ��� NULL�� �ƴ� ù ��° ǥ���� ��ȯ
SELECT employee_id, salary, commission_pct,
    COALESCE (salary * commission_pct, salary) AS salary2
    FROM employees;

-- LNNVL���ǽ�





-- p147
-- GREATEST, LEAST
SELECT GREATEST(1,2,3,1),
    LEAST (1,2,3,1)
FROM DUAL;

SELECT GREATEST('�̼���', '������','�������','�̿��'),
    LEAST ('�̼���','������','�������','�̿��')
FROM DUAL;

-- DECODE
-- IF-ELIF-ELIF-ELIF-ELSE ���� ����

SELECT prod_id,
    DECODE(channel_id,3,'Direct',
                      9,'Direct',
                      5,'Indirect',
                      4,'Indirect',
                         'Others')decodes
FROM sales
WHERE rownum < 10;
