TRUNCATE TABLE TEMP_MOBILE_SEARCH;
DROP TABLE TEMP_MOBILE_SEARCH CASCADE CONSTRAINTS;
CREATE GLOBAL TEMPORARY TABLE TEMP_MOBILE_SEARCH (
    CUSTNO NUMBER,
    MOBILENO VARCHAR2(10),
    SOURCE VARCHAR2(20)
) ON COMMIT PRESERVE ROWS;
---1.INSERT
INSERT INTO TEMP_MOBILE_SEARCH
--SELECT DISTINCT CUSTNO,NSB.get_valid_mobile(MOBILENO) AS MOBILENO,'UPI' AS SOURCE FROM ACBL.D897002@MIS WHERE NSB.get_valid_mobile(MOBILENO) = '9029918311';
SELECT DISTINCT CUSTNO,MOBILENO,'UPI' AS SOURCE FROM ACBL.D897002@MIS WHERE MOBILENO = '9029918311';
---2.INSERT
INSERT INTO TEMP_MOBILE_SEARCH
--SELECT CUSTNO, NSB.get_valid_mobile(MOBILENO) AS  MOBILENO,'MOBILE BANKING' AS SOURCE  FROM ACBL.D390094@MIS WHERE NSB.get_valid_mobile(MOBILENO) = '9029918311';
SELECT CUSTNO,MOBILENO,'MOBILE BANKING' AS SOURCE  FROM ACBL.D390094@MIS  WHERE MOBILENO = '9029918311';
---3.INSERT
INSERT INTO TEMP_MOBILE_SEARCH
--SELECT TO_NUMBER(CUSTNO) AS CUSTNO,NSB.get_valid_mobile(MOBILENO) AS MOBILIENO ,'SMS' AS SOURCE FROM ACBL.D350078@MIS WHERE NSB.get_valid_mobile(MOBILENO) = '9029918311';
SELECT TO_NUMBER(CUSTNO) AS CUSTNO, MOBILENO ,'SMS' AS SOURCE FROM ACBL.D350078@MIS  WHERE MOBILENO = '9029918311';
---4.INSERT
INSERT INTO TEMP_MOBILE_SEARCH
--SELECT CUSTNO,NSB.get_valid_mobile(PAGERNO) AS MOBILIENO,'CUST PG' AS SOURCE FROM ACBL.D009011@MIS WHERE NSB.get_valid_mobile(PAGERNO) = '9029918311';
SELECT CUSTNO,NSB.get_valid_mobile(PAGERNO) AS MOBILIENO,'CUST PG' AS SOURCE FROM ACBL.D009011@MIS WHERE NSB.get_valid_mobile(PAGERNO) = '9029918311';
---5.INSERT
INSERT INTO TEMP_MOBILE_SEARCH
SELECT CUSTNO,NSB.get_valid_mobile(PHONE) AS MOBILIENO,'CUST PH' AS SOURCE FROM ACBL.D009011@MIS WHERE NSB.get_valid_mobile(PHONE) = '9029918311';
-----
TRUNCATE TABLE TEMP_ACCOUNT_FOUND;
DROP TABLE TEMP_ACCOUNT_FOUND CASCADE CONSTRAINTS;
CREATE GLOBAL TEMPORARY TABLE TEMP_ACCOUNT_FOUND 
	(
	LBRCODE   NUMBER (6),
	PRDCD     VARCHAR2 (8),
	ACNO      NUMBER,
	PRDACCTID VARCHAR2 (32),
	NAMETITLE CHAR (4),
	LONGNAME  VARCHAR2 (50),
	DATEOPEN  DATE,
	STATUS    VARCHAR2 (4000)
	);
INSERT INTO TEMP_ACCOUNT_FOUND
SELECT LBRCODE,trim(substr(PRDACCTID,1,8)) AS PRDCD,TO_NUMBER(SUBSTR(PRDACCTID,17,8)) AS ACNO
, PRDACCTID, NAMETITLE, LONGNAME,DATEOPEN
--,GETACCOUNTSTATUS(LBRCODE,PRDACCTID) AS ACCOUNT_STATUS
,GET_ACCOUNT_STATUS_DESC(LBRCODE,PRDACCTID) STATUS
--,GETBAL(LBRCODE,PRDACCTID) AS BALANCE
FROM ACBL.D009022@MIS A
RIGHT JOIN (SELECT DISTINCT CUSTNO FROM TEMP_MOBILE_SEARCH)B ON A.CUSTNO = B.CUSTNO
WHERE GET_ACCOUNT_STATUS_DESC(LBRCODE,PRDACCTID)!='CLOSED';
-----------
SELECT X.* FROM (
--1.UPI
SELECT DISTINCT A.CUSTNO,NSB.get_valid_mobile(A.MOBILENO) AS MOBILENO,A.LBRCODE,A.PRDACCTID,'UPI' AS SOURCE 
FROM ACBL.D897002@MIS A
RIGHT JOIN TEMP_ACCOUNT_FOUND B ON A.LBRCODE = B.LBRCODE AND A.PRDACCTID = B.PRDACCTID
WHERE A.CUSTNO IS NOT NULL
UNION ALL
--2.MOBILEBANKING
SELECT DISTINCT A.CUSTNO, NSB.get_valid_mobile(A.MOBILENO) AS  MOBILENO,A.LBRCODE,A.PRDACCTID,'MOBILE BANKING' AS SOURCE  
FROM ACBL.D390094@MIS A
RIGHT JOIN TEMP_ACCOUNT_FOUND B ON A.LBRCODE = B.LBRCODE AND A.PRDACCTID = B.PRDACCTID
WHERE A.CUSTNO IS NOT NULL
UNION ALL
--3. SMS
SELECT A.* FROM 
(SELECT TO_NUMBER(A.CUSTNO) AS CUSTNO,NSB.get_valid_mobile(A.MOBILENO) AS MOBILIENO,BRCODE AS LBRCODE,ACCTNO AS PRDACCTID ,'SMS' AS SOURCE 
FROM ACBL.D350078@MIS A
LEFT JOIN ACBL.D350077@MIS X ON A.CUSTNO = X.CUSTNO)A
RIGHT JOIN TEMP_ACCOUNT_FOUND B ON B.LBRCODE = A.LBRCODE AND A.PRDACCTID = B.PRDACCTID
WHERE A.CUSTNO IS NOT NULL
) X ;
