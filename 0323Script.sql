
/* 
 * transaction 테스트
 * 
 * 테이블 creste -> insert -> update -> delete
 */

CREATE TABLE dept_tcl
AS (SELECT * FROM dept)
;

SELECT *
FROM dept_tcl
;

INSERT INTO dept_tcl
VALUES (50, 'DATABASE', 'SEOUL')
;

UPDATE dept_tcl
SET loc = 'BUSAN'
WHERE deptno = 40
;

DELETE from dept_tcl
WHERE dname = 'RESEARCH'
;

SELECT *
FROM dept_ncl
;

ROLLBACK;


-- commit 실행하는 경우
INSERT INTO dept_tcl
VALUES (50, 'NETWORK', 'SEOUL')
;

UPDATE dept_tcl
SET loc = 'BUSAN'
WHERE deptno = 20
;

DELETE FROM dept_tcl
WHERE deptno = 40
;

SELECT *
FROM dept_tcl
;

COMMIT;

ROLLBACK;

SELECT *
FROM dept_tcl
;


-- UPDATE 


/* 
 * LOCK 테스트
 * 
 * 동일한 계정으로 DBeaver 세션과 SQL*Plus 세션을 열어
 * 데이터를 수정하는 동시 작업을 수행
 */

INSERT INTO dept_tcl
VALUES (30, 'NETWORK', 'SEOUL')
;

COMMIT;

UPDATE dept_tcl
SET loc = 'DAEGU'
WHERE deptno = 30 -- DBeaver 에서 수행
;

-- SQL*Plus 에서 실행중인 직원의 UPDATE 시도를 막고있는 상황을 모르고 있을 수도 있음

SELECT *
FROM dept_tcl 
;

-- DBeaver 세션에서는 수정 결과가 잘 보임
-- SQL*Plus 에서도 'DAEGU' UPDATE 결과가 안보임

COMMIT;



/* 
 * Tuning 기초 : 자동차 튜닝과 같이
 * DB 처리 속도(우선)와 안정성 제고 목적의 경우가 대부분 
 */

-- 튜닝 전과 후 비교
SELECT *
FROM test.emp
WHERE substr(empno,1,2) = 75 -- 암묵적 형변환 2번. SUBSTR  
	AND LENGTH (empno) = 4 -- 불필요한 비교
	;

SELECT * FROM test.EMP  
WHERE empno > 7499
	AND empno < 7600
;

-- 튜닝 전 후 비교
SELECT *
FROM test.EMP 
WHERE ename || ' ' || job = 'WARD SALESMAN'; 

SELECT *
FROM test.EMP 
WHERE ename = 'WARD'
	AND job = 'SALESMAN';


-- p/256 
-- union은 레코드를 합집합한 후 중복 제거
-- deptno 10과 20은 상호 독립적인 집합이므로 중복 제거는 불필요
SELECT * FROM test.emp 
WHERE deptno = '10'
UNION 
SELECT * FROM test.emp 
WHERE deptno = '20'
;

SELECT * FROM test.emp 
WHERE deptno = '10'
UNION ALL 
SELECT * FROM test.emp 
WHERE deptno = '20'
;


/* 
 * 튜닝 추기
 * 1. INDEX 활용 - group by 집계 함수
 * 2. 오라클 DATE 객체 함수 비교
 */

SELECT ename
	, empno
	, sum(sal)
FROM EMP 
GROUP BY ename, empno;


SELECT empno
	, ename
	, sum(sal)
FROM EMP 
GROUP BY empno, ename; -- 인덱스 설정된 empno 우선 순위 사용

-- index 확인 및 추가
SELECT *
FROM DBA_indexes
WHERE TABLE_name LIKE 'EMP';

CREATE INDEX idx_emp_job
	ON emp (job)
;

DROP INDEX idx_emp_job;

-- 집계 함수를 사용할 때, 최대한 인덱스가 설정된 컬럼을 우선 상..?
SELECT JOB, sum(sal) AS sum_of_sal
FROM EMP e 
GROUP BY JOB 
ORDER BY sum_of_sal DESC
;



SELECT job, sum(sal)
FROM EMP e 
GROUP BY JOB 
;


SELECT empno
	, ename
FROM EMP e 
WHERE to_char(hiredate, 'YYYYMMDD') LIKE '1981%' -- 동일한 datatype 'string'
	AND empno > 7700;

SELECT empno
	, ename
FROM EMP e 
WHERE EXTRACT(YEAR FROM hiredate) = 1981 -- 동일한 datatype 'integer4'
	AND empno > 7700;

/* 
 * VIEW 생성
 */
SELECT *
FROM HR.EMPLOYEES 
;

SELECT *
FROM HR.EMPLOYEES e
	, HR.DEPARTMENTS d
	, HR.JOBS j
	, HR.LOCATIONS l
	, HR.COUNTRIES c
	, HR.REGIONS r
WHERE  e.DEPARTMENT_ID = d.DEPARTMENT_ID 
	AND d.LOCATION_ID = l.LOCATION_ID 
	AND l.COUNTRY_ID = c.COUNTRY_ID 
	AND c.REGION_ID = r.REGION_ID 
	AND j.JOB_ID = e.JOB_ID 
;
	
/* 
 * [복습] GROUP BY, JOIN 테이블을 중심으로 반복 연습
 * - ROLLUP, CUBE, GROUPINGSET 등 집계 함수 사용 방법
 * 
 * GROUP BY 구문 : 집계 함수를 사용하여 값을 표시
 */

SELECT DEPTNO, FLOOR(AVG(SAL)) AS AVG_SAL
FROM EMP 
GROUP BY DEPTNO
;

SELECT DEPTNO
	, JOB 
	, FLOOR(AVG(SAL)) AS AVG_SAL
FROM EMP 
GROUP BY DEPTNO, JOB  -- 튜닝을 고려
ORDER BY DEPTNO, JOB  -- INDEX가 있는 JOB 컬럼부터 검색
;

SELECT *
FROM DBA_INDEXES 
WHERE TABLE_NAME = 'EMP';

-- GROUP BY 집계를 사용할 때 에러가 발생하는 경우
SELECT ename, deptno
	, FLOOR(AVG(SAL)) AS AVG_SAL
--	-------------------

-- HAVING 구문 사용
-- GROUP BY 결과에 대한 조건 설정
SELECT DEPTNO
	, JOB 
	, FLOOR(AVG(SAL)) AS AVG_SAL
FROM EMP 
GROUP BY job, deptno
HAVING avg(sal) >= 2000
ORDER BY job, DEPTNO  -- INDEX가 있는 JOB 컬럼부터 검색
;



SELECT DEPTNO
	, JOB 
	, FLOOR(AVG(SAL)) AS AVG_SAL
	, max(sal) AS max_sal
	, min(sal) AS min_sal
FROM EMP 
GROUP BY job, deptno
HAVING max(sal) >= 2000
ORDER BY job, DEPTNO  -- INDEX가 있는 JOB 컬럼부터 검색
;


/* 
 * LISTAGG, PIVOT, ROLLUP, CUBE, GROUPING SET
 */

SELECT deptno
	, LISTAGG(ename, ',')
		WITHin group(ORDER BY sal DESC) AS ename_list
FROM EMP e 
GROUP BY deptno;


SELECT deptno, job, max(sal)
FROM EMP 
GROUP BY deptno, job
ORDER BY deptno, job
;

SELECT *
FROM (SELECT deptno, job, sal FROM EMP)
pivot (max(sal) FOR deptno IN (10, 20, 30))
ORDER job;

SELECT deptno
	, max(DECODE(job, 'CLERK', sal)) AS "clerk"
	, max(DECODE(job, 'SALESMAN', sal)) AS "sales"
	, max(DECODE(job, 'PRESIDENT', sal)) AS "presi"
	, max(DECODE(job, 'MANAGER', sal)) AS "mgr"
	, max(DECODE(job, 'ANALYST', sal)) AS "ana"
FROM EMP e 
GROUP BY deptno
ORDER BY deptno
;


SELECT *
FROM (SELECT deptno
			, max(DECODE(job, 'CLERK', sal)) AS "clerk"
			, max(DECODE(job, 'SALESMAN', sal)) AS "sales"
			, max(DECODE(job, 'PRESIDENT', sal)) AS "presi"
			, max(DECODE(job, 'MANAGER', sal)) AS "mgr"
			, max(DECODE(job, 'ANALYST', sal)) AS "ana"
		FROM EMP e 
		GROUP BY deptno
		ORDER BY deptno)
unpivot(sal FOR job IN ('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));


SELECT deptno
	, job
	, count(empno)
	, max(sal)
	, min(sal)
	, avg(sal)
FROM EMP e 
GROUP BY CUBE(deptno, job)
ORDER BY DEPTNO, job;


SELECT deptno
	, job
	, count(empno)
FROM EMP e 
GROUP BY GROUPING SETS(DEPTNO, job)
ORDER BY DEPTNO, job;


SELECT deptno
	, job
	, count(empno)
	, max(sal)
	, min(sal)
	, avg(sal)
	, GROUPING(deptno)
	, GROUPING(job)
FROM EMP e 
GROUP BY CUBE(deptno, job)
HAVING GROUPING(DEPTNO) = 1
ORDER BY DEPTNO, job;



