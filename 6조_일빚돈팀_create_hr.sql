/*
 * Table 생성
 */

/* CERTIFICATE Table 생성 */
CREATE TABLE CERTIFICATE (
    cert_num NUMBER Primary Key,
    cert_title VARCHAR2(25)
)

select * from CERTIFICATE

/* DEPT Table 생성 */
CREATE TABLE DEPT (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(30) NOT NULL,
    job VARCHAR2(20) NOT NULL,
    workload VARCHAR2(20) NOT NULL,
    worktime VARCHAR2(20) NOT NULL,
    related_cert NUMBER NOT NULL unique,
    FOREIGN KEY (related_cert) REFERENCES CERTIFICATE(cert_num)
)
/* EMP Table 생성 */
CREATE TABLE EMP (
   emp_num NUMBER PRIMARY KEY,
   name VARCHAR2(20) NOT NULL,
   job_rank VARCHAR2(20) NOT NULL,
   job VARCHAR2(20) NOT NULL,
   move_hope VARCHAR2(10) NOT NULL,
   cert_num NUMBER NOT NULL,
   department_id NUMBER NOT NULL,
   FOREIGN KEY (department_id) REFERENCES DEPT(department_id),
   FOREIGN KEY (cert_num) REFERENCES CERTIFICATE(cert_num)
)

/*
 * SAMPLE DATA 입력
 */

/* CERTIFICATE Table SAMPLE DATA 입력 */
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (100,'미보유');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (301,'여신심사역');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (302,'신용분석사');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (303,'구글 애널리틱스');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (304,'산업안전기사');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (305,'은퇴설계자격증');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (306,'CDCS');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (307,'노무사');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (308,'정보처리기사');
INSERT INTO CERTIFICATE(cert_num, cert_title) VALUES (309,'ESG 전문가');

/* DEPT Table SAMPLE DATA 입력
 * worktime 8시간 - workload 하, worktime 9시간 - workload 중, worktime 10시간 이상 - workload 상 
 */
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (200,'영업점', '-', '-', 100, 12);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (201,'개인여신부', '개인여신', '상', 301, 10);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (202,'기업상품부', '기업여신', '상', 302, 11);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (203,'브랜드전략부', '개인', '중', 303, 9);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (204,'안전관리부', '개인', '하', 304, 8);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (205,'연금기획부', '퇴직연금', '상', 305, 10);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (206,'외환업무부', '외환', '상', 306, 11);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (207,'직원만족부', '개인', '중', 307, 9);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (208,'코어뱅킹플랫폼부', 'IT', '상', 308, 10);
INSERT INTO DEPT(department_id, department_name, job, workload, related_cert, worktime) VALUES (209,'ESG기획부', '개인', '하', 309, 8);

/* EMP Table SAMPLE DATA 입력 */
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1000,'지소연', 'L0', '개인', 'N', 100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1001,'조소현', 'L0', 'IT', 'N', 305, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1002,'김민지', 'L0', '개인여신', 'N', 301, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1003,'김혜리', 'L0', '개인여신', 'Y', 100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1004,'권하늘', 'L1', '개인여신', 'Y', 301, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1005,'임선주', 'L1', '외환', 'N', 302, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1006,'김승규', 'L1', '개인여신', 'Y', 304, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1007,'이강인', 'L1', '개인여신', 'Y', 100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1008,'황희찬', 'L1', '기업여신', 'N', 100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1009,'김민재', 'L1', '외환', 'Y', 306, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1010,'김진수', 'L1', '퇴직연금', 'Y', 305, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1011,'지창민', 'L1', '외환', 'N', 306, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1012,'이진만', 'L1', 'IT', 'Y', 308, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1013,'김태연', 'L1', 'IT', 'Y', 303, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1014,'나루아', 'L1', 'IT', 'N', 100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1015,'김태환', 'L1', 'IT', 'Y', 305, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1016,'조유민', 'L1', '기업여신', 'Y', 306, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1017,'이재성', 'L1', '기업여신','Y', 307, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1018,'홍철', 'L1', '외환', 'Y', 308, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1019,'권경원', 'L2', 'IT', 'Y',309, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1020,'송민규', 'L2', '개인여신', 'N',307, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1021,'전가을', 'L2', '기업여신', 'Y',305, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1022,'이은미', 'L2', '외환', 'Y',100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1023,'유영아', 'L2', '퇴직연금', 'N',301, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1024,'장슬기', 'L3', 'IT', 'Y',302, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1025,'김도연', 'L3', '개인여신', 'Y',304, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1026,'정설빈', 'L3', '기업여신', 'N',100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1027,'여민지', 'L3', '외환', 'N',308, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1028,'김선우', 'L3', '퇴직연금', 'N',305, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1029,'최찬희', 'L2', '개인여신', 'Y',301, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1030,'허윤진', 'L2', '외환', 'Y' ,306, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1031,'김채원', 'L1', '기업여신', 'Y',100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1032,'홍은채', 'L1', '퇴직연금', 'N', 100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1033,'장덕배', 'L1', '외환', 'Y',306, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1034,'변다윗', 'L3', '외환', 'Y',100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1035,'장은정', 'L1', '외환', 'Y',306, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1036,'문대호', 'L2', '개인여신', 'N',301, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1037,'이여진', 'L1', '개인여신', 'N',100, 200);
INSERT INTO EMP(emp_num, name, job_rank, job, move_hope , cert_num, department_id) VALUES (1038,'이재현', 'L3', 'IT', 'Y', 100, 200);