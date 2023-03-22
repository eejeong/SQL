/* 
 * 이론 과제
 * Q2-1
 * (1) 테이블
 * (2) 외래키(FK, Foreign Key)
 * (3) 널(NULL)
 * Q2-2
 * (1) 문자셋(CharacterSet) 
 * (2) 문자셋(CharSet)
 * Q2-3
 * (1) VARCHAR2
 * (2) CHAR
 * Q2-4
 * (1) 제약 조건
 * (2) 기본키(Primary Key, PK)
 * (3) 외래키(Foreign Key, FK)
 * Q2-5
 * (1) 무결성(Integrity)
 * (2) 무결성
 * (3) 무결성
 * Q2-6
 * (1) Unique
 * (2) Not Null
 * (3) Index
 */

/* 
 * EMP 테이블을 사용하여 다음과 같이 출력하는 SQL문을 작성하세요
 * 
 * 1. EMP 테이블에서 부서번호, 평균 급여, 최고 급여, 최저 급여, 사원수를 출력
 * 단, 평균 급여 출력 시 소수점을 제외하고 각 부서번호별로 출력(그룹화)
 * 
 * 2. 같은 직책에 있는 사원이 3명 이상인 경우 직책과 인원수를 출력(JOB으로 그룹화)
 * 
 * 3. 사원들의 입사년도를 기준으로 부서별로 몇 명이 입사했는지 출력
 */

-- 1번
SELECT DEPTNO
	, TRUNC(AVG(SAL)) AS AVG_SAL
	, MAX(SAL) AS MAX_SAL
	, MIN(SAL) AS MIN_SAL
	, COUNT(*) AS CNT
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO DESC;

-- 2번
SELECT JOB
	, COUNT(*) AS CNT
FROM EMP
GROUP BY JOB
HAVING COUNT(*) >= 3;

-- 3번
SELECT TO_CHAR(HIREDATE, 'YYYY') AS HIRE_DATE
	, DEPTNO
	, COUNT(*) AS CNT
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY'), DEPTNO;

/* 
 * EMP 테이블을 사용하여 다음과 같이 출력하는 SQL문을 작성하세요
 * 
 * 4. 추가 수당(COMM)을 받는 사원수와 받지 않는 사원수를 출력
 * 
 * 5. 각 부서의 입사 연도별 사원수, 최고급여, 급여합, 평균 급여를 출력하고
 * 각 부서별 소계와 총계를 함께 출력(ROLLUP 함수로 그룹화)
 */

-- 4번
SELECT NVL2(COMM, 'Y', 'N') AS COMM 
	, COUNT(*) AS CNT
FROM EMP
GROUP BY NVL2(COMM, 'Y', 'N');

-- 5번 
SELECT DEPTNO
	, TO_CHAR(HIREDATE, 'YYYY') AS HIRE_DATE
	, COUNT(*) AS CNT
	, MAX(SAL) AS MAX_SAL
	, SUM(SAL) AS SUM_SAL
	, AVG(SAL) AS AVG_SAL
FROM EMP
GROUP BY ROLLUP (DEPTNO, TO_CHAR(HIREDATE, 'YYYY'));

/* 
 * EMP와 DEPT 테이블을 사용하여 다음과 같이 출력하는 SQL문을 작성하세요.
 * 
 * 1. inner-join 방식으로 급여(SAL)이 2000 초과인 사원들의 부서 정보, 사원정보를 출력
 * (1) 오라클 SQL (2) 표준 SQL
 * 
 * 2. Natural-join 각 부서별 평균 급여, 최대 급여, 최소 급여, 사원수를 출력
 */

-- 1-(1)
SELECT D.DEPTNO
    , D.DNAME
    , E.EMPNO
    , E.ENAME
    , E.SAL
FROM EMP E, DEPT D
WHERE e.DEPTNO = d.DEPTNO 
and E.SAL > 2000
ORDER BY D.DEPTNO, E.JOB ASC;

-- 1-(2)
SELECT D.DEPTNO
    , D.DNAME
    , E.EMPNO
    , E.ENAME
    , E.SAL
FROM EMP E JOIN DEPT D ON (e.DEPTNO = d.DEPTNO and E.SAL > 2000)
ORDER BY D.DEPTNO, E.JOB ASC;

-- 2번
SELECT E.DEPTNO
    , D.DNAME
    , FLOOR(AVG(E.SAL)) AS AVG_SAL
    , MAX(E.SAL) AS MAX_SAL
    , MIN(E.SAL) AS MIN_SAL
    , COUNT(E.DEPTNO) AS CNT
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO
GROUP BY E.DEPTNO, D.DNAME
ORDER BY E.DEPTNO, D.DNAME;

/* 
 * EMP와 DEPT 테이블을 사용하여 다음과 같이 출력하는 SQL문을 작성하세요.
 * 
 * 3. 모든 부서 정보와 사원 정보를 부서 기준으로 조인 (right-join)
 * 
 * 4. 부서정보, 사원정보, 급여 등급 정보를 JOIN하여 각 사원의 직속 상관의 정보를
 * 부서번호, 사원번호 순으로 정렬하여 출력 (right-join) 
 */

-- 3번
SELECT D.DEPTNO
    , D.DNAME
    , E.EMPNO
    , E.ENAME
    , E.JOB
    , E.SAL
FROM EMP E RIGHT OUTER JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
ORDER BY D.DEPTNO, D.DNAME;


-- 4번
SELECT D.DEPTNO 
    , D.DNAME
    , E.EMPNO
    , E.ENAME
    , E.MGR
    , E.SAL
    , E.DEPTNO 
    , S.LOSAL
    , S.HISAL
    , S.GRADE
    , E2.EMPNO AS MGR_EMPNO
    , E2.ENAME AS MGR_ENAME
FROM EMP E RIGHT JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
LEFT OUTER JOIN SALGRADE S ON (E.SAL >= S.LOSAL AND E.SAL <= S.HISAL)
LEFT OUTER JOIN EMP E2 ON (E.MGR = E2.EMPNO)
ORDER BY D.DEPTNO, E.EMPNO;

/* 
 * EMP와 DEPT 테이블을 사용하여 다음과 같이 출력하는 SQL문을 작성하세요.
 * 
 * 1. 'ALLEN'과 같은 직책(JOB)인 직원들의 사원명, 사원 정보, 부서 정보를 출력
 * 
 * 2. 전체 사원의 평균 급여(SAL) 보다 높은 급여를 받는 사원 정보, 부서 정보, 급여를 출력
 */

-- 1번
SELECT DISTINCT E.JOB
    , E.EMPNO
    , e.ENAME
    , E.SAL
    , E.DEPTNO
    , D.DNAME
FROM DEPT D, EMP E
WHERE E.JOB = (SELECT JOB FROM EMP WHERE ENAME = 'ALLEN')
	AND e.DEPTNO = d.DEPTNO ;

-- 2번
SELECT E.EMPNO
    , E.ENAME
    , D.DNAME
    , E.HIREDATE
    , D.LOC
    , E.SAL
    , S.GRADE
FROM EMP E LEFT JOIN DEPT D ON (E.DEPTNO = D.DEPTNO)
INNER JOIN SALGRADE S ON (E.SAL >= S.LOSAL AND E.SAL <= S.HISAL)
AND E.SAL > (SELECT AVG(SAL) FROM EMP)
ORDER BY sal DESC, EMPNO asc;

/* 
 * EMP와 DEPT 테이블을 사용하여 다음과 같이 출력하는 SQL문을 작성하세요.
 * 
 * 3. 부서코드 10인 부서에 근무하는 사원 중 부서코드 30번 부서에 존재하지 않는 직책을 
 * 가진 사원들의 정보를 출력
 * 
 * 4. 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 정보를 출력
 * 다중행 함수를 사용한 경우 MAX() 사용
 * 
 * 5. 위의 4번을 다중행 함수를 사용하지 않고 ALL 키워드를 사용하여 결과를 출력
 */

-- 3번
SELECT E.EMPNO
    , E.ENAME
    , E.JOB
    , E.DEPTNO
    , D.DNAME
    , D.LOC
FROM EMP E, DEPT D
WHERE E.ENAME IN (SELECT ENAME FROM EMP WHERE DEPTNO = '10')
	AND E.JOB NOT IN (SELECT JOB FROM EMP WHERE DEPTNO = '30')
	AND e.DEPTNO = d.DEPTNO ;

-- 4번
SELECT E.EMPNO 
    , E.ENAME
    , E.SAL 
    , S.GRADE 
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL 
	AND E.SAL > (SELECT MAX(SAL) FROM EMP WHERE JOB = 'SALESMAN');

-- 5번
SELECT DISTINCT E.EMPNO
	, E.ENAME
    , E.SAL 
    , S.GRADE 
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL 
	AND E.SAL > ALL (SELECT SAL FROM EMP WHERE JOB = 'SALESMAN');

