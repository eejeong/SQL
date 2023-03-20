Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
REM    UTLSAMPL.SQL
Rem  FUNCTION
Rem  NOTES
Rem  MODIFIED
Rem	gdudey	   06/28/95 -  Modified for desktop seed database
Rem	glumpkin   10/21/92 -  Renamed from SQLBLD.SQL
Rem	blinden   07/27/92 -  Added primary and foreign keys to EMP and DEPT
Rem	rlim	   04/29/91 -	      change char to varchar2
Rem	mmoore	   04/08/91 -	      use unlimited tablespace priv
Rem	pritto	   04/04/91 -	      change SYSDATE to 13-JUL-87
REM MENDELS 12/07/90 - BUG 30123;
ADD TO_DATE CALLS SO LANGUAGE INDEPENDENT

Rem
Rem $Header: utlsampl.sql 7020100.1 94/09/23 22:14:24 cli Generic<base> $ sqlbld.sql
Rem
SET TERMOUT OFF
SET ECHO OFF

Rem CONGDON    Invoked in RDBMS at build time.	 29-DEC-1988
Rem OATES:     Created: 16-Feb-83

/*
 * SCOTT 계정 생성 및 암호 TIGER 지정
 */

-- GRANT (CONNECT, RESOURCE, UNLIMITED TABLESPACE) TO TEST IDENTIFIED BY 111111;

ALTER USER TEST DEFAULT TABLESPACE USERS;
ALTER USER TEST TEMPORARY TABLESPACE TEMP;
ALTER USER  TEST ACCOUNT unlock;
GRANT unlimited tablespace TO test;
--CONNECT TEST/111111;


--DROP TABLE DEPT;

CREATE TABLE DEPT (
	DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14),
	LOC VARCHAR2(13)
);

INSERT INTO DEPT VALUES (
	10,
	'ACCOUNTING',
	'NEW YORK'
);

INSERT INTO DEPT VALUES (
	20,
	'RESEARCH',
	'DALLAS'
);

INSERT INTO DEPT VALUES (
	30,
	'SALES',
	'CHICAGO'
);

INSERT INTO DEPT VALUES (
	40,
	'OPERATIONS',
	'BOSTON'
);




--DROP TABLE EMP;

CREATE TABLE EMP (
	EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7, 2),
	COMM NUMBER(7, 2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT
);

INSERT INTO EMP VALUES (
	7369,
	'SMITH',
	'CLERK',
	7902,
	TO_DATE('17-12-1980', 'dd-mm-yyyy'),
	800,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7499,
	'ALLEN',
	'SALESMAN',
	7698,
	TO_DATE('20-2-1981', 'dd-mm-yyyy'),
	1600,
	300,
	30
);

INSERT INTO EMP VALUES (
	7521,
	'WARD',
	'SALESMAN',
	7698,
	TO_DATE('22-2-1981', 'dd-mm-yyyy'),
	1250,
	500,
	30
);

INSERT INTO EMP VALUES (
	7566,
	'JONES',
	'MANAGER',
	7839,
	TO_DATE('2-4-1981', 'dd-mm-yyyy'),
	2975,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7654,
	'MARTIN',
	'SALESMAN',
	7698,
	TO_DATE('28-9-1981', 'dd-mm-yyyy'),
	1250,
	1400,
	30
);

INSERT INTO EMP VALUES (
	7698,
	'BLAKE',
	'MANAGER',
	7839,
	TO_DATE('1-5-1981', 'dd-mm-yyyy'),
	2850,
	NULL,
	30
);

INSERT INTO EMP VALUES (
	7782,
	'CLARK',
	'MANAGER',
	7839,
	TO_DATE('9-6-1981', 'dd-mm-yyyy'),
	2450,
	NULL,
	10
);

INSERT INTO EMP VALUES (
	7788,
	'SCOTT',
	'ANALYST',
	7566,
	TO_DATE('13-7-1987', 'dd-mm-yyyy')-85,
	3000,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7839,
	'KING',
	'PRESIDENT',
	NULL,
	TO_DATE('17-11-1981', 'dd-mm-yyyy'),
	5000,
	NULL,
	10
);

INSERT INTO EMP VALUES (
	7844,
	'TURNER',
	'SALESMAN',
	7698,
	TO_DATE('8-9-1981', 'dd-mm-yyyy'),
	1500,
	0,
	30
);

INSERT INTO EMP VALUES (
	7876,
	'ADAMS',
	'CLERK',
	7788,
	TO_DATE('13-7-1987', 'dd-mm-yyyy')-51,
	1100,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7900,
	'JAMES',
	'CLERK',
	7698,
	TO_DATE('3-12-1981', 'dd-mm-yyyy'),
	950,
	NULL,
	30
);

INSERT INTO EMP VALUES (
	7902,
	'FORD',
	'ANALYST',
	7566,
	TO_DATE('3-12-1981', 'dd-mm-yyyy'),
	3000,
	NULL,
	20
);

INSERT INTO EMP VALUES (
	7934,
	'MILLER',
	'CLERK',
	7782,
	TO_DATE('23-1-1982', 'dd-mm-yyyy'),
	1300,
	NULL,
	10
);




--DROP TABLE BONUS;

CREATE TABLE BONUS (
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	SAL NUMBER,
	COMM NUMBER
);



--DROP TABLE SALGRADE;

CREATE TABLE SALGRADE (
	GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER
);

INSERT INTO SALGRADE VALUES (
	1,
	700,
	1200
);

INSERT INTO SALGRADE VALUES (
	2,
	1201,
	1400
);

INSERT INTO SALGRADE VALUES (
	3,
	1401,
	2000
);

INSERT INTO SALGRADE VALUES (
	4,
	2001,
	3000
);

INSERT INTO SALGRADE VALUES (
	5,
	3001,
	9999
);

--COMMIT;
--
--SET TERMOUT ON
--
--SET ECHO ON




SELECT lpad('ORA_1234_XE', 20) AS lpad_20
	, rpad('ORA_1234_XE', 20) AS rpad_20
FROM dual;

/* 
 * NUMBER 숫자를 다루는 함수들
 * 
 * 정수(INTEGER), 부동소수(FLOAT) - 소수점이 있는 숫자
 * 부동소수의 경우, 소수점 이하 정밀도(precision) 차이가 발생
*/

SELECT round(3.1428, 3) AS round0
	, round(123.456789, 3) AS round1
	, trunc(123.4567, 2) AS trunc0
	, trunc(-123.4567, 2) AS trunc1
FROM dual;

SELECT ceil(3.14) AS ceil0
	, floor(3.14) AS floor0
	, mod(15, 6) AS mod0
	, mod(11, 1) AS mod1
FROM dual;

SELECT REMAINDER(15, 2) AS r1
	, REMAINDER(-11, 4) AS r2
	FROM dual;


/*
 * date 날짜 함수
 * 날짜를 표현하는 일련번호 숫자가 존재 
 */

SELECT sysdate AS now
	, sysdate - 1 AS yesterday
	, sysdate + 10 AS ten_days_from_today
	FROM dual;

-- :month : 입력 변수를 받아 월수 계산
SELECT add_months(sysdate, :month)
FROM dual;

-- month_between(날짜1, 날짜2)
SELECT ename
	, hiredate
	, MONTHS_BETWEEN(SYSDATE, hiredate)/12 AS y1
FROM emp;

SELECT SYSDATE 
	, NEXT_DAY(sysdate, 'monday') AS n_date
	, LAST_DAY(sysdate) AS l_date
FROM dual;


SELECT SYSDATE, ROUND(SYSDATE, 'CC') AS FORMAT_CC
	, ROUND(SYSDATE, 'YYYY') AS FORMAT_YYYY
	, ROUND(SYSDATE, 'Q') AS FORMAT_Q
	, ROUND(SYSDATE, 'DDD') AS FORMAT_DDD
	, ROUND(SYSDATE, 'HH') AS FORMAT_HH
	FROM dual;


/*
 * 형 변환 (cast, up-cast, down-cast)
 * 
 * down-cast : 큰 수를 담는 데이터형에서 작은 수를 담는 데이터 형으로 명시적 변환
 * 예시 : 1234.3456 -> 234.3 (데이터가 잘림)
 */

SELECT TO_CHAR(sysdate, 'YYYY/MM/DD HH24') -- 24시간 표시
FROM dual;

SELECT TO_CHAR(sysdate, 'DD HH24:MI:SS') -- 시분초까지 표시
FROM dual;

SELECT SYSDATE 
	, TO_CHAR(SYSDATE, 'MM') AS mm1
	, TO_CHAR(sysdate, 'mon', 'NLS_DATE_LANGUAGE = ENGLISH') AS mon_ENG 
	FROM dual;
	
SELECT SYSDATE 	
	, to_char(SYSDATE, 'HH24:MI:SS') AS tm
	FROM dual;
	
SELECT TO_NUMBER('100,000', '999,999,999') AS currency -- '999,999,999' 초과시 에러 발생
FROM dual;

SELECT TO_DATE('2023/03/20','YYYY/MM/DD') AS ymd
FROM dual;

/*
 * TO DATE(입력날짜, 'RR-,MM-DD')
 * TO DATE(입력날짜, 'YY-,MM-DD')
 * 날짜 포맷 RR과 YY 값 비교
 */

SELECT * FROM EMP 
WHERE HIREDATE > TO_DATE('1981/02/01', 'YYYY/MM/DD');

SELECT TO_DATE('49/12/10', 'YY/MM/DD') AS YY_YEAR_49
		, TO_DATE('49/12/10', 'RR/MM/DD') AS RR_YEAR_49
		, TO_DATE('50/12/10', 'YY/MM/DD') AS YY_YEAR_50
		, TO_DATE('50/12/10', 'RR/MM/DD') AS RR_YEAR_50 
	FROM dual;
-- YY는 현재년도, RR는 지난 세기 (49년까지는 RR도 현재년도)


/*
 * NULL 값 : 알 수 없는 값, 계산이 불가능한 값
 * NULL 값 비교는 IS NULL <> IS NOT NULL
 * 
 * NVL(입력값, NULL인 경우 대체할 값)
 * NVL2(입력값, NULL이 아닌 경우, NULL인 경우)
*/

SELECT empno
	, sal * 12 + nvl(comm,0) AS sal12
	, job
	, to_char(HIREDATE, 'YYYY-MM-DD') AS ymd
FROM EMP 
ORDER BY sal12 DESC
;

/*
 * DECODE(입력 컬럼값,
 * 			'값1', 처리1,
 *			'값2', 처리2,
 * 			'...', 처리...,) AS 별칭
 * 
 * CASE 컬럼값
 * 		WHEN '값1' THEN 처리1
 * 		WHEN '값2' THEN 처리2
 * 		ELSE 처리...
 * 		END AS 별칭
 */




