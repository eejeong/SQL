-- 0321 class

/*
 * 레코드 그룹별 집계 : GROUP BY
 * 
 * 집계 조건 : HAVING
 */

SELECT SUM(e.SAL) AS sum_of_sal -- 합계
	, AVG(E.sal) AS avg_of_sal  -- 평균
FROM EMP e 
;

SELECT DISTINCT e.DEPTNO  -- DISTINCT  중복제거
	, e.SAL
FROM emp E
;

SELECT DISTINCT deptno -- DISTINCT 키워드 (unique)
FROM EMP 
;

SELECT DISTINCT sal -- DISTINCT 키워드 (unique)
FROM EMP 
;

SELECT SUM(DISTINCT e.SAL) AS sum_of_distinct
	, SUM(ALL e.SAL) AS sum_of_all
	, SUM(e.SAL) AS normal_sum 
FROM emp e
;

SELECT MAX(sal) AS max_sal
	, MIN(sal) AS min_sal
	, round( MAX(sal) / MIN(sal), 1) AS max_min_ti 
FROM EMP 
WHERE deptno = 20
;

/*
 *  count 집계 함수
 */

SELECT count(empno)
	, count(comm)
FROM EMP 
;

SELECT COUNT(*)
FROM EMP e 
WHERE deptno = 30;

SELECT COUNT(DISTINCT sal) 
	, COUNT(ALL sal)
	, COUNT(sal)
FROM EMP e;

SELECT COUNT(ename) 
	FROM EMP e 
	WHERE nvl(comm, 0) > 0
	;

/*
 * 부서별 UNION ALL -> 중복 허용
 */

SELECT avg(sal), '10' AS dno
FROM EMP e 
WHERE deptno = 10;
UNION ALL
SELECT avg(sal), '20' AS dno
FROM EMP e 
WHERE deptno = 20;
UNION ALL
SELECT avg(sal), '30' AS dno
FROM EMP e 
WHERE deptno = 30;

/*
 * group by 키워드 사용하여 스마트하게 집계
 */
SELECT deptno
	, count(sal)
	, avg(sal)
	, MAX(sal)
	, min(sal)
	, sum(sal)
FROM EMP 
GROUP BY DEPTNO 
ORDER BY deptno
;

SELECT deptno, job
	, count(sal)
	, avg(sal + nvl(comm, 0)) AS avg_pay
	, MAX(sal + nvl(comm, 0)) AS max_pay
	, min(sal + nvl(comm, 0)) AS min_pay
	, sum(sal + nvl(comm, 0)) AS sum_pay
FROM EMP 
GROUP BY DEPTNO, job
ORDER BY deptno, job
;

/*
 * JOIN 키워드 : 테이블 정규화로 분할된 테이블 컬럼을 다시 합치는 작업
 * 
 * 
 */

SELECT * 
FROM emp, DEPT  -- 잘못된 JOIN 사용 : cartesian product
ORDER BY empno
;

SELECT *
FROM emp E, dept D -- 잘못된 JOIN 사용 
WHERE E.ENAME = 'SMITH' 
ORDER BY e.EMPNO 
;

SELECT E.deptno
	, D.deptno
FROM emp E, dept D -- 잘못된 JOIN 사용 
WHERE E.ENAME = 'SMITH' 
ORDER BY e.EMPNO 
;

/*
 * INNER-JOIN 교집합 컬럼 연결
*/

SELECT *
FROM emp, DEPT 
WHERE emp.DEPTNO = dept.DEPTNO 
ORDER BY EMPNO 
;

SELECT E.EMPNO 
		, e.HIREDATE 
		, d.DNAME 
		, e.JOB 
		, e.sal
FROM emp E JOIN dept D
	ON E.DEPTNO = D.DEPTNO 
;


SELECT E.EMPNO 
		, e.HIREDATE 
		, d.DNAME 
		, e.JOB 
		, e.sal
FROM emp e JOIN dept d
			USING (deptno) -- USING 키워드 하나로 동일 컬럼 사용
;

/*
 * 자바, C/C++ 등 프로그램에서 SQL 쿼리문 사용하는 경우
 * 쿼리문을 문자열로 사용 가능
 */

var_deptno;
var_sql = "SELECT E.EMPNO 
		, e.HIREDATE 
		, d.DNAME 
		, e.JOB 
		, e.sal
FROM emp e JOIN dept d
			USING (($var_deptno)) -- USING 키워드 하나로 동일 컬럼 사용
;
"


SELECT e.EMPNO 
	-- , e.HIREDATE 
	, TO_CHAR(e.HIREDATE, 'YYYY-MM-DD') AS hireDt
	, e.ENAME 
	, d.DEPTNO 
	, d.LOC 
FROM emp e
	, dept d
WHERE e.DEPTNO = d.DEPTNO 
ORDER BY d.DEPTNO, e.DEPTNO 
;

SELECT d.DNAME AS dname, e.job AS job
	, round(avg(e.sal),0) AS avg_sal
	, sum(e.sal) AS sum_sal
	, max(e.sal) AS max_sal
	, min(e.sal) AS min_sal
	, count(e.sal) AS count_sal
FROM emp e
	, dept d
WHERE e.DEPTNO = d.DEPTNO AND e.sal < 2000
GROUP BY d.DNAME, e.job 
;


SELECT e.ENAME 
	, s.GRADE
	, e.DEPTNO 
	, e.SAL 
	, e.JOB 
	, e.HIREDATE 
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL 
;


SELECT E.ENAME 
	, E.DEPTNO 
	, E.JOB 
	, s.GRADE 
	, E.SAL 
	, S.LOSAL AS low_rng
	, S.HISAL AS high_rng
FROM emp E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL 

/*
 * JOIN 함수로 SALGRADE 부여 후, grade로 그룹별 직원 수
 */
SELECT s.grade
	, count( e.ENAME ) AS emp_cnt  -- 임직원수 집계
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL 
GROUP BY s.grade          -- grade 기준으로 그룹
ORDER BY emp_cnt DESC     -- 임직원수가 많은 수부터
;

SELECT *
FROM emp E, dept D -- 내가 필요한 테이블과 별칭 지정 
WHERE E.EMPNO = D.DEPTNO -- INNER JOIN
;

/*
 * self-join 자기 자신의 릴레이션을 이용해서 테이블 컬럼을 조작
 */

SELECT e1.EMPNO AS emp_no	
	, e1.ENAME AS emp_name
	, e1.MGR AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1, emp e2        -- SELF-JOIN 목적으로 테이블 사용 
WHERE e1.EMPNO = e2.MGR 
;

SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1, emp e2
WHERE e1.MGR = e2.EMPNO 
;


/*
 * LEFT-JOIN 왼쪽 테이블 값을 모두 가져오고
 * JOIN 하는 테이블에서 해당되는 값 일부만 가져오기
 * 
 * 
 * 오라클 SQL : 매니저와 담당 직원 정보를 출력
 */

SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1, emp e2
WHERE e1.mgr = e2.EMPNO(+)
;

/* 
 * LEFT-JOIN : 표준 SQL을 활용하여 매니저와 담당 직원 정보를 출력
 */

SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1 LEFT OUTER JOIN emp e2
			ON e1.MGR = e2.EMPNO 
;

/* 
 * RIGHT-JOIN : 오라클 SQL을 활용하여 매니저와 담당 직원 정보를 출력
 */

SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1, emp e2 
WHERE e1.mgr(+) = e2.EMPNO 
;

/* 
 * 표준 SQL로 right-join 출력
 */
SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1 RIGHT OUTER JOIN emp e2
			ON e1.mgr = e2.EMPNO 
;


/* 
 * 양측 조인 full-outer-join
 */
SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1 FULL OUTER JOIN emp e2
			ON e1.mgr = e2.EMPNO 
;

SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1 FULL OUTER JOIN emp e2
			ON e1.mgr = e2.EMPNO 
ORDER BY e1.EMPNO 
;


/* 
 * EMP, DEPT, SALGRADE, self-join EMP
 * 4개 테이블을 활용하여 값을 출력
 */
SELECT d.DEPTNO 
	, d.DNAME 
	, e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e1.SAL 
	, s.LOSAL 
	, s.HISAL 
	, s.GRADE 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1
	, DEPT d 
	, SALGRADE s 
	, EMP e2
WHERE e1.DEPTNO(+) = d.DEPTNO 
	AND e1.sal BETWEEN s.LOSAL(+) AND s.HISAL(+)
	AND e1.mgr = e2.EMPNO (+)
;


/* 
 * EMP, DEPT, SALGRADE, self-join EMP
 * 2씩 연관 테이블의 일부를 오라클 SQL로 값을 출력
 */

SELECT d.DEPTNO 
	, d.DNAME 
	, e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e1.SAL 
FROM emp e1, dept d
WHERE e1.DEPTNO (+) = d.DEPTNO 
;


SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e1.SAL 
	, s.LOSAL 
	, s.HISAL 
	, s.GRADE 
FROM emp e1, SALGRADE s 
WHERE e1.sal BETWEEN s.LOSAL (+) AND s.HISAL (+)
;


SELECT e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e1.SAL 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM emp e1
	, EMP e2
WHERE e1.mgr = e2.EMPNO (+)
;

/* 
 * 표준 SQL 출력
 * 
 * EMP e1, DEPT d, SALGRADE s, EMP e2
 */
SELECT d.DEPTNO 
	, d.DNAME 
	, e1.EMPNO 
	, e1.ENAME 
	, e1.MGR 
	, e1.SAL 
	, s.LOSAL 
	, s.HISAL 
	, s.GRADE 
	, e2.EMPNO AS mgr_no
	, e2.ENAME AS mgr_name
FROM EMP e1 RIGHT JOIN dept d
		ON e1.DEPTNO = d.DEPTNO 
	LEFT OUTER JOIN SALGRADE s 
		ON (e1.sal >= s.LOSAL AND e1.sal <= s.HISAL)
	LEFT OUTER JOIN EMP e2
		ON (e1.mgr = e2.EMPNO)
;
		
		
/* 
 * 단일행 서브 쿼리 - 쿼리 안에 쿼리 문장을 사용
 * 
 * SELECT 쿼리의 결과는 -> 2차원 테이블에 불과
 */		
		
SELECT sal FROM EMP 
WHERE ENAME = 'BLAKE';
		
SELECT *
FROM emp e, dept d
WHERE e.DEPTNO = d.DEPTNO 
	AND e.DEPTNO = 20
	AND e.SAL > (SELECT avg(sal) FROM emp);


/* 
 * 다중행 서브 쿼리 - 쿼리 안에 쿼리 문장을 사용
 * 
 * SELECT 쿼리의 결과는 -> 2개 이상의 값으로 된 테이블
 */

SELECT DEPTNO, ENAME, SAL
FROM EMP  
WHERE SAL IN (SELECT MAX(SAL)
				FROM EMP
				GROUP BY DEPTNO)
;

SELECT DEPTNO, ENAME, SAL  -- 처리 불가
FROM EMP  
WHERE SAL IN (SELECT MAX(avg)
				FROM EMP
				GROUP BY DEPTNO)
;


SELECT *
FROM EMP  
WHERE SAL = ANY (SELECT MAX(SAL)
				FROM EMP
				GROUP BY DEPTNO)
				
				
SELECT DEPTNO, max(sal)
FROM EMP 
GROUP BY DEPTNO   -- 그룹별 최고 sal 조회
ORDER BY DEPTNO;
				
SELECT *
FROM EMP 
WHERE sal = ANY (sub_query);

SELECT sal
FROM EMP 
WHERE DEPTNO = 30;

SELECT min(sal), max(sal) -- sub-query2
FROM EMP 
WHERE DEPTNO = 30;

SELECT *
FROM EMP 
WHERE sal < any(SELECT sal
FROM EMP 
WHERE DEPTNO = 30);

/* 
 * 다중열 서브 쿼리
 * 
 * 서브 쿼리 결과가 두 개 이상의 컬럼으로 구성된 테이블 값
 */

SELECT DEPTNO , SAL, EMPNO, ENAME 
FROM EMP 
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, max(SAL)
						FROM EMP
						GROUP BY DEPTNO);

/* 
 * FROM 절에 사용되는 서브 쿼리
 */
SELECT A.ename
	, A.sal
	, B.DNAME 
	, B.LOC 
FROM (SELECT * FROM emp WHERE deptno=30) A	
	,(SELECT * FROM dept) B
WHERE A.deptno = B.DEPTNO;


/* 
 * WITH 절(구문) 사용 - 편리한 가상 테이블로 활용
 */
WITH E AS (SELECT * FROM emp WHERE deptno = 20)
	, D AS (SELECT * FROM dept)
	, S AS (SELECT * FROM salgrade)
SELECT E.ename
	, D.dname
	, E.sal
	, D.loc
	, S.grade
FROM E, D, S
WHERE E.deptno = D.deptno
	AND E.sal BETWEEN S.losal AND S.hisal
;

/* 
 * CREATE TABLE
 */

CREATE TABLE dept_temp 
	AS (SELECT * FROM dept);

-- COMMIT; -- TO confirm IF ANY changes ON DB IS 











