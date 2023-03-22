/* 
 * P.212 CREATE TABLE 
 */

CREATE TABLE dept_temp 
	AS (SELECT * FROM dept);
	
/* 
 * CREATE ... AS (SELECT ... FROM ... ) 구문
 */

SELECT *
FROM DEPT_TEMP dt
;

/* 
 * P.213 INSERT 데이터를 입력하는 방식
 * 
 * -- 기본 구문
 * INSERT INTO 테이블명 (컬럼명1, 컬럼명2, ...)
 *  VALUES (데이터1, 데이터2, ...)
 * 
 * -- 단순한 형태
 */
INSERT INTO dept_temp (deptno, dname, loc)
 VALUES (50, 'DATABASE', 'SEOUL')
 ;
 
INSERT INTO dept_temp (deptno, dname, loc)
 VALUES (50, 'WEB', null)
 ;

INSERT INTO dept_temp (deptno, dname, loc)
 VALUES (70, 'WEB', null)
 ;

INSERT INTO dept_temp (deptno, dname, loc)
 VALUES (80, 'MOBILE', '')
 ;

INSERT INTO dept_temp (deptno, loc)
 VALUES (90, 'INCHEON')
 ;

COMMIT;

SELECT * FROM DEPT_TEMP;

/* 
 * P.214
 * 컬럼값만 복사해서 새로운 테이블 생성
 * 
 * WHERE 조건절에 1 <> 1
 */
CREATE TABLE emp_temp 
	AS SELECT * FROM emp
		WHERE 1 <> 1
;

COMMIT;

SELECT * FROM emp_temp;

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (9999, '홍길동', 'PRESIDENT', NULL, to_date('2001/01/01', 'YYYY/MM/DD'), 6000, 500, 10)
;

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (2111, '이순신', 'MANAGER', 9999, to_date('07/30/1999', 'MM/DD/YYYY'), 4000, null, 20)
;

INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (3111, '심청이', 'MANAGER', 9999, sysdate, 4000, null, 30)
;

-- P.216
INSERT INTO emp_temp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT e.empno
	, e.ename
	, e.job
	, e.mgr
	, e.hiredate
	, e.sal
	, e.comm
	, e.deptno
FROM emp e, SALGRADE s  
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL 
	AND s.GRADE = 1
;

/* 
 * P.217
 * UPDATE문 : 필터링 데이터에 대해서 레코드 값을 수정
 */
CREATE TABLE dept_temp2 -- 테스트 개발을 위한 임시 테이블 생성
AS (SELECT * FROM dept)
;

SELECT *
FROM DEPT_TEMP2 -- 테스트 개발을 위한 임시 테이블 확인
;

/* 
 * P.217
 * UPDATE ... SET ... 구문
 * where 반드시 필요
 */

UPDATE dept_temp2
SET loc = 'SEOUL'
WHERE deptno = 40;
;

ROLLBACK; -- UPDATE 이전으로 되돌리기 

/* 
 * P.218
 * 서브쿼리를 사용하여 UPDATE
 */

UPDATE DEPT_TEMP2 
set(dname, loc) = (SELECT dname, Loc 
					FROM dept
					WHERE deptno = 40)
WHERE deptno = 40
;

/*
 * P.220
 * DELETE 구문으로 테이블에서 값을 제거
 * 
 * 대부분의 경우(또는 반드시) WHERE 조건이 필요
 * 
 * 보통의 경우, DELETE 구문보다는 UPDATE 구문으로 상태 값을 변경
 * ex. 근무, 휴직 등
 * 
 */

SELECT *
FROM emp_temp2
;

CREATE TABLE emp_temp2
	AS (SELECT * FROM emp)
;

DELETE FROM emp_temp2
WHERE job='manager'
; -- 인사팀에서 명령 실행 요청

ROLLBACK; -- 사장 승인? 취소?
COMMIT;

/* 
 * WHERE 조건을 좀 더 복잡하게 주고
 * DELETE 실행
 */
DELETE FROM emp_temp2 -- HR 개발 테스트를 위한 임시 테이블
WHERE empno IN (SELECT empno 
					FROM emp_temp2 e, SALGRADE s 
					WHERE e.sal BETWEEN s.LOSAL AND s.HISAL 
						AND s.GRADE = 3
						AND depno = 30)
;

SELECT e.empno
FROM emp_temp2 e, SALGRADE s 
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL 
		AND s.GRADE =3
		AND deptno = 30
;

/* P.224
 * create 문을 정의 : 기존에 없는 테이블 구조를 생성
 * 
 * 데이터는 없고, 테이블의 컬럼과 데이터타입, 제약 조건 등의 구조를 생성 
 */

CREATE TABLE emp_new
(
	empno		number(4)
	, ename		varchar(10)
	, job		varchar(9)
	, mgr		number(4)
	, hiredate	DATE
	, sal 		number(7,2)
	, comm 		number(7,2)
	, deptno	number(2)
)
;

SELECT *
FROM EMP_new
;

/* 
 * p.225
 */
ALTER TABLE EMP_NEW 
ADD hp varchar(20)
;

ALTER TABLE EMP_NEW 
RENAME COLUMN tel TO TEL_NO; -- 잘못된 컬럼명을 수정

ALTER TABLE EMP_NEW -- 새로 인수한 회사 직원 관리 테이블
MODIFY emono number(5); -- 직원수가 많아 기존 4자리에서 5자리로 수정

ALTER TABLE EMP_NEW
DROP COLUMN tel_no;

/* 
 * p.229
 * SEQUENCE 일련번호를 생성하여 테이블 관리를 편리하게 하고자 함
 * 
 */
CREATE SEQUENCE seq_deptno
	INCREMENT BY 1
	START WITH 1
	MAXVALUE 999
	MINVALUE 1
	nocycle  -- 최대값에서 중단
	nocache;

INSERT INTO dept_temp2(deptno, dname, loc)
values(seq_deptno.nextval, 'DATABASE', 'SEOUL');

INSERT INTO dept_temp2(deptno, dname, loc)
values(seq_deptno.nextval, 'WEB', 'BUSAN');

INSERT INTO dept_temp2(deptno, dname, loc)
values(seq_deptno.nextval, 'MOBILE' , 'DAEGU');

SELECT *
FROM dept_temp2


/* 
 * p.230
 * 제약 조건(constraints) 지정
 * 
 * 테이블을 생성할 때, 테이블 컬럼별 제약 조건을 설정
 * 
 * 자주 사용되는 중요한 제약 조건 유형
 * Not Null
 * Unique
 * PK
 * FK 
 */
CREATE TABLE login 
(
	log_id		VARCHAR(20) NOT NULL
	, log_pwd	VARCHAR(20) NOT NULL
	, tel 		VARCHAR(20) 
);

create table information (
    LOGIN_ID varchar2(20) not null
    , LOGIN_PASSWORD varchar2(20) not null
    , TEL varchar2(20)
)

INSERT INTO login(log_id, log_pwd, tel)
VALUES ('test01', '1234', '010-1234-4321')
;

INSERT INTO login(log_id, log_pwd)
VALUES ('test02', '1234')
;

SELECT *
FROM login;

/* 
 * p.231
 * TEL 컬럼의 중요성을 나중에 인지하고, Not Null 제약조건을 설정 -> tel값이 null 데이터가 있는 경우 변경 불가
 */

ALTER TABLE login
MODIFY tel NOT NULL
;

/* 
 * TEL 없는 고객이 발견되어 전화번호를 구함
 */
UPDATE login
SET tel = '010-7777-1332'
WHERE log_id = 'test02';

/*
 * 오라클 DBMS가 사용자를 위해 만들어 놓은 제약조건 설정값 테이블
 */
SELECT owner
	, CONSTRAINT_name
	, CONSTRAINT_type
	, table_name
FROM DBA_CONSTRAINTS 
WHERE table_name = 'LOGIN';


ALTER TABLE login
DROP CONSTRAINT SYS_C007108  -- 제약조건 이름이 없어 주어진 이름 사용


/* 
 * UNIQUE 키워드 사용
 */

CREATE TABLE log_unique
(
	log_id		VARCHAR(20) Unique
	, log_pwd	VARCHAR(20) NOT NULL
	, tel 		VARCHAR(20) 
);

SELECT *
FROM USER_CONSTRAINTS 
WHERE table_name = 'LOG_UNIQUE'
;

INSERT INTO log_unique(log_id, log_pwd, tel)
VALUES ('test01', 'pwd1234', '010-1234-4321')
;
INSERT INTO log_unique(log_id, log_pwd, tel)
VALUES ('test02', 'pwd1211134', '010-4321-4321')
;
INSERT INTO  log_unique(log_id, log_pwd, tel)
VALUES ('test03', 'pwdfgfdgd', '010-5678-0987')
;
INSERT INTO log_unique(log_id, log_pwd, tel)
VALUES (null, 'pwdqwer', '010-0000-0000')
;


SELECT *
FROM LOG_UNIQUE;


/* 
 * p.236
 * PK : 테이블을 설명하는 가장 중요한 키
 * Not Null + Unique + Index
 */
 CREATE TABLE log_pk
 (
 	log_id		VARCHAR(20) PRIMARY key
	, log_pwd	VARCHAR(20) NOT NULL
	, tel 		VARCHAR(20) 
 );
 
INSERT INTO log_pk(log_id, log_pwd, tel)
VALUES ('pk01', 'pwd01', '010-1234-4321')
;

-- 기존 고객의 ID와 동일한 ID 입력하는 경우
-- log_id (PK 제약조건 위반)
INSERT INTO log_pk(log_id, log_pwd, tel)
VALUES ('pk01', 'pwd02', '010-4321-4321')
;

INSERT INTO log_pk(log_id, log_pwd, tel)
VALUES (NULL, 'pwd02', '010-4321-4321')
; 
 
/* 
 * p.238
 * FK
 */ 
 
 SELECT *
 FROM EMP_TEMP 
 ;

/* 
 * 존재하지 않는 부서번호를 emp_temp 테이블에 입력 시도 -> FK 제약 조건이 없어서 등록됨
 */
INSERT INTO EMP_TEMP (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (3333, '장덕배', 'CLERK', 9999, sysdate, 1200, NULL, 50)
;

-- 존재하지 않는 부서번호를 emp_temp 테이블에 입력 시도 -> FK 제약 조건이 있어서 처리 불가 
INSERT INTO EMP (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (3333, '장덕배', 'CLERK', 9999, sysdate, 1200, NULL, 50)
;

/* 
 * p.245 
 * index 빠른 검색을 위한 색인
 * 
 * 장점 : 순식간에 원하는 값 찾아준다
 * 단점 : 입력과 출력이 잦은 경우, 인덱스가 설정된 테이블의 속도가 저하된다
 */


-- 특정 직군에 해당하는 직원을 빠르게 찾기 위한 색인 지정
CREATE INDEX idx_emp_job
ON emp(job)
;

-- 설정한 인덱스 리스트 출력
SELECT *
FROM DBA_INDEXES
WHERE table_name IN ('EMP', 'DEPT')
;

/* 
 * VIEW : 테이블을 편리하게 사용하기 위한 목적으로 생성하는 가상 테이블
 */
CREATE VIEW vw_emp 
	AS (SELECT empno, ename, job, deptno
			FROM EMP 
			WHERE deptno = 10)
;

SELECT *
FROM VW_EMP 
;

SELECT *
FROM DBA_VIEWS 
WHERE view_name = 'VW_EMP' -- 테이블명은 대문자로 표기
;


/* 
 * ROWNUM 사용 : 상위 N개를 출력하기 위해 사용하며
 * 컬럼에 ROWNUM 순번을 입력하여 사용할 수 있음
 */

-- sal desc 순서와 무관하게 emp 테이블에서 가져오는 순번을 출력
SELECT rownum
	, e.*
FROM emp e
ORDER BY sal DESC;

-- sal desc 순서에 따라 오름차순으로 rownum  순번을 출력
SELECT rownum
	, A.*
FROM (SELECT *
	FROM EMP 
	ORDER BY sal DESC) A 
;

SELECT rownum
	, A.*
FROM (SELECT *
	FROM EMP 
	ORDER BY sal DESC) A 
WHERE rownum <= 5
;


/* 
 * 오라클 DBMS에서 관리하는 관리 테이블 리스트 출력
 */
SELECT *
FROM DICT
WHERE table_name like 'USER_%' -- % 와일드카드
;

SELECT *
FROM DBA_TABLES
WHERE table_name LIKE 'EMP%'
;

SELECT *
FROM DBA_users
WHERE username = 'SCOTT'
;








 
