
SELECT 100 + 5, 10 - 3, 30*2, 10 / 3;

SELECT 100 + 5, 10 -3, 30 * 2, 10 / 3 FROM dual;

SELECT dbms_random.value() * 100  AS "RANDOM NUM" FROM dual;

SELECT ENAME FROM EMP AS employee;

SELECT ENAME AS "employee name" FROM EMP employee;

SELECT * FROM EMP ORDER BY SAL;  -- 오름차순 정렬



SELECT * FROM NLS_DATABASE_PARAMETERS;