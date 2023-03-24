/* 요구사항 처리 
 * 1. 조건별 직원 리스트 추출
 * 2. 해당 직원 부서 변경 처리  
 */

/* 1. 조건별 직원 리스트 추출 */

---- 풀 1순위 : 부서 이동 희망 직원 / 관련 직무 수행 중 / 자격증 보유 ----
SELECT e.EMP_NUM as 직원번호
   , e.NAME as 성명
   , e.JOB_RANK as 직급
   , e.JOB as 담당직무
   , c.cert_title as 보유자격증
   , e.move_hope as 이동희망여부
FROM EMP e, CERTIFICATE c
WHERE (e.CERT_NUM = c.CERT_NUM)
   AND e.MOVE_HOPE = 'Y'
   AND e.JOB = '외환'
   AND e.CERT_NUM = '306'
ORDER BY job_RANK;

------------------ 풀 2순위 : 관련 직무 수행-------------------
SELECT e.EMP_NUM as 직원번호
   , e.NAME as 성명
   , e.JOB_RANK as 직급
   , e.JOB as 담당직무
   , c.cert_title as 보유자격증
   , e.move_hope as 이동희망여부
FROM EMP e
JOIN CERTIFICATE c ON e.CERT_NUM = c.CERT_NUM
WHERE e.JOB = '외환'
  AND e.EMP_NUM NOT IN (
    SELECT e.EMP_NUM
    FROM EMP e
    JOIN CERTIFICATE c ON e.CERT_NUM = c.CERT_NUM
    WHERE e.MOVE_HOPE = 'Y'
      AND e.JOB = '외환'
      AND e.CERT_NUM = '306'
  )
ORDER BY JOB_RANK;

----------------- 풀 3순위 자격증 보유 --------------------
SELECT e.EMP_NUM as 직원번호
   , e.NAME as 성명
   , e.JOB_RANK as 직급
   , e.JOB as 담당직무
   , c.cert_title as 보유자격증
   , e.move_hope as 이동희망여부
FROM EMP e, CERTIFICATE c
WHERE JOB != '외환'
AND c.CERT_NUM = '306'
MINUS
SELECT e.EMP_NUM as 직원번호
   , e.NAME as 성명
   , e.JOB_RANK as 직급
   , e.JOB as 담당직무
   , c.cert_title as 보유자격증
   , e.move_hope as 이동희망여부
FROM EMP e
JOIN CERTIFICATE c ON e.CERT_NUM = c.CERT_NUM
WHERE e.MOVE_HOPE = 'Y'

------------- 조회를 위한 View Table 생성 --------------
CREATE OR REPLACE VIEW KB_VW
AS SELECT e.EMP_NUM as 직원번호
   , e.NAME as 성명
   , e.JOB_RANK as 직급
   , e.JOB as 담당직무
   , c.cert_title as 보유자격증
   , e.move_hope as 이동희망여부
   , d.department_name as 현재부서
FROM EMP e, DEPT d, CERTIFICATE c
WHERE e.department_id = d.department_id
AND e.cert_num = c.cert_num

SELECT * FROM KB_VW

------------- 신규 직원 자기 신고 입력시 추가 데이터 생성 --------------
INSERT INTO EMP
    (emp_num
    , name
    , job_rank
    , job
    , move_hope
    , cert_num
    , department_id)
VALUES (1039,'이름', '직급', '직무', '이동희망여부', 100, 200);

/* 2. 해당 직원 부서 변경 처리   */

------------ 역공모 수락시 수락여부 추가 및 해당 직원 부서명 변경 -------------------
ALTER TABLE EMP ADD accept varchar(5) DEFAULT ('N');

UPDATE EMP
SET ACCEPT = 'Y', DEPARTMENT_ID = '206'
WHERE EMP_NUM = 1035;

------------ 역공모 수락시 현재 부서 확인 --------------------------------------
SELECT e.EMP_NUM as 직원번호
   , e.NAME as 성명
   , e.JOB_RANK as 직급
   , e.JOB as 담당직무
   , c.cert_title as 보유자격증
   , d.department_name as 현재부서
FROM EMP e, DEPT d, CERTIFICATE c
WHERE e.department_id = d.department_id
AND e.cert_num = c.cert_num
AND e.department_id = '206'

------------------------ 역공모시 직원이 수락하면 부서 공모 POOL 입력 --------------------
---- 추출한 1순위 명단 부서 POOL에 등재 ----
CREATE SEQUENCE seq START WITH 1 INCREMENT BY 1 MAXVALUE 100 CYCLE NOCACHE;

CREATE TABLE POOL (
   pool_num NUMBER PRIMARY KEY ,
   emp_num NUMBER,
   name VARCHAR2(20) NOT NULL,
   job_rank VARCHAR2(20) NOT NULL,
   cert_title VARCHAR2(20) NOT NULL,
   pool_grade VARCHAR2(20) NOT NULL
)

INSERT INTO POOL
(
   pool_num,
   emp_num,
   name,
   job_rank,
   cert_title,
   pool_grade
)
SELECT seq.NEXTVAL,
       e.EMP_NUM,
       e.NAME,
       e.JOB_RANK,
       c.cert_title,
       'A'
FROM EMP e, CERTIFICATE c
WHERE (e.CERT_NUM = c.CERT_NUM)
   AND e.MOVE_HOPE = 'Y'
   AND e.JOB = '외환'
   AND e.CERT_NUM = '306';


---- 추출한 2순위 명단 부서 POOL에 등재 ----
INSERT INTO POOL
(
   pool_num,
   emp_num,
   name,
   job_rank,
   cert_title,
   pool_grade
)
SELECT seq.NEXTVAL,
       e.EMP_NUM,
       e.NAME,
       e.JOB_RANK,
       c.cert_title,
       'B'
FROM EMP e
JOIN CERTIFICATE c ON e.CERT_NUM = c.CERT_NUM
WHERE e.JOB = '외환'
  AND e.EMP_NUM NOT IN (
    SELECT e.EMP_NUM
    FROM EMP e
    JOIN CERTIFICATE c ON e.CERT_NUM = c.CERT_NUM
    WHERE e.MOVE_HOPE = 'Y'
      AND e.JOB = '외환'
      AND e.CERT_NUM = '306'
)

---- 추출한 3순위 명단 부서 POOL에 등재(해결 못함) ----
CREATE SEQUENCE seq3 START WITH 11 INCREMENT BY 1 MAXVALUE 100 CYCLE NOCACHE;

INSERT INTO POOL
(
   pool_num,
   emp_num,
   name,
   job_rank,
   cert_title,
   pool_grade
)
SELECT seq3.NEXTVAL,
       e.EMP_NUM,
       e.NAME,
       e.JOB_RANK,
       c.cert_title,
       'C'
FROM EMP e, CERTIFICATE c
WHERE e.JOB != '외환'
  AND c.CERT_NUM = '306'
MINUS
SELECT e.EMP_NUM,
       e.NAME,
       e.JOB_RANK,
       e.JOB,
       c.cert_title,
       e.move_hope
FROM EMP e
JOIN CERTIFICATE c ON e.CERT_NUM = c.CERT_NUM
WHERE e.JOB = '외환'
  AND e.EMP_NUM NOT IN (
    SELECT e.EMP_NUM
    FROM EMP e
    JOIN CERTIFICATE c ON e.CERT_NUM = c.CERT_NUM
    WHERE e.MOVE_HOPE = 'Y'
      AND e.JOB = '외환'
      AND e.CERT_NUM = '306'
);

