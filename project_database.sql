create database db_insurance;
USE db_insurance;
CREATE TABLE PERSON (
    person_ID INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(50),
    dob DATE,
    email VARCHAR(50),
    phone VARCHAR(50),
    address_ID INT not null
);
Select * from person;
Select * from address;
DELETE FROM person WHERE person_id IS NULL;
delete from person where person_id = '';
drop table accident;
ALTER TABLE person
ADD FOREIGN KEY (address_ID) REFERENCES address(address_ID);
select * from claim;
CREATE TABLE ADDRESS(
	address_ID INT PRIMARY KEY,
    suite INT,
    street VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(50),
	zip VARCHAR(50),
    FOREIGN KEY (address_ID) REFERENCES Person (address_ID)
);
CREATE TABLE ADDRESS(
	address_ID INT,
    suite INT,
    street VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(50),
	zip VARCHAR(50)
);
select * from address;
ALTER TABLE ADDRESS
DROP COLUMN STATE;
ALTER TABLE ADDRESS
DROP COLUMN CITY;
ALTER TABLE ADDRESS
DROP COLUMN ZIP;
ALTER TABLE ADDRESS
ADD CITY VARCHAR(25);
ALTER TABLE ADDRESS
ADD STATE VARCHAR(25);
ALTER TABLE ADDRESS
ADD ZIP_CODE CHAR(4);
CREATE TABLE DRIVER(
	driver_ID INT PRIMARY KEY,
    license_no INT,
    FOREIGN KEY (driver_ID) REFERENCES Person (person_ID)
);
select * from driver;
CREATE TABLE OWNER(
	OWNER_ID int PRIMARY KEY,
    FOREIGN KEY (OWNER_ID) REFERENCES Person (person_ID)
);
select * from owner;
CREATE TABLE vehicle(
    registration_no VARCHAR(50) PRIMARY KEY,
	state  VARCHAR(50),
	brand VARCHAR(50),
	model VARCHAR(50),
	date_of_issue DATE,
	driver_id  INT,
	accident_id INT
);
SHOW TABLES;
SELECT * FROM INSURANCE_COMPANY;
SELECT * FROM VEHICLE;
SELECT * FROM DRIVER;
SELECT * FROM accident;
ALTER TABLE vehicle
ADD FOREIGN KEY (driver_id) REFERENCES Person (person_ID);
ALTER TABLE vehicle
ADD FOREIGN KEY (owner_id) REFERENCES Person (person_ID);
ALTER TABLE vehicle
ADD FOREIGN KEY (accident_id) REFERENCES ACCIDENT (accident_ID);
CREATE TABLE ACCIDENT(
	accident_ID VARCHAR(4) PRIMARY KEY,
    DATE DATE,
    TIME TIME,
    CITY VARCHAR(20),
    STATE VARCHAR(20),
    insurance_comp_ID CHAR(4)
);
CREATE TABLE INSURANCE(
	insurance_ID VARCHAR(4) PRIMARY KEY,
    premium_amount INT,
    status VARCHAR(10),
    issue_date DATE,
    expiration_date DATE,
    vehicle_reg_no VARCHAR(10),
    insurance_comp_ID CHAR(4)
);
ALTER TABLE INSURANCE
ADD FOREIGN KEY (vehicle_reg_no) REFERENCES vehicle (registration_no);
ALTER TABLE INSURANCE
ADD FOREIGN KEY (insurance_comp_ID) REFERENCES Insurance_Company (company_ID);
CREATE TABLE Insurance_Company(
	company_ID VARCHAR(4) PRIMARY KEY,
    name VARCHAR(25),
    CITY VARCHAR(10),
    STATE VARCHAR(10),
    phone VARCHAR(10)
);
CREATE TABLE CLAIM(
	CLAIM_ID VARCHAR(4) PRIMARY KEY,
    DATE DATE,
    TOTAL_AMOUNT INT,
    status VARCHAR(10),
    settlement_ID CHAR(4),
    insurance_comp_ID CHAR(4),
    person_ID CHAR(4),
    insurance_ID VARCHAR(10)
);
show tables;
drop table vehicle;
ALTER TABLE CLAIM
ADD FOREIGN KEY (insurance_ID) REFERENCES INSURANCE (insurance_ID);
ALTER TABLE CLAIM
ADD FOREIGN KEY (person_ID) REFERENCES Person (person_ID);
ALTER TABLE INSURANCE
ADD FOREIGN KEY (insurance_comp_ID) REFERENCES Insurance_Company (company_ID);
CREATE TABLE Settlement(
	settlement_ID VARCHAR(4) PRIMARY KEY,
    DATE DATE,
    final_amount INT,
    status VARCHAR(10),
    account_no BIGINT,
    insurance_comp_ID CHAR(4),
    person_ID CHAR(4)
);
ALTER TABLE Settlement
ADD FOREIGN KEY (insurance_comp_ID) REFERENCES Insurance_Company (company_ID);
ALTER TABLE Settlement
ADD FOREIGN KEY (person_ID) REFERENCES Person (person_ID);
SHOW TABLES;
select * from driver;
select * from vehicle;
drop table vehicle;
describe claim;
select * from settlement;
select * from insurance;
select * from claim;
select * from vehicle;
select * from insurance;
SELECT STATE, COUNT(REGISTRATION_NO) AS NUMBER_OF_VEHICLES 
FROM VEHICLE
GROUP BY STATE
ORDER BY COUNT(REGISTRATION_NO) DESC
LIMIT 10;
SELECT * FROM VEHICLE;
SELECT PERSON_ID, COUNT(ACCIDENT_ID) FROM VEHICLE
GROUP BY PERSON_ID
ORDER BY PERSON_ID;

SELECT P.PERSON_ID, P.FIRST_NAME, P.GENDER, P.PHONE, D.LICENSE_NO, COUNT(V.ACCIDENT_ID) AS TOTAL_NO_ACCIDENTS, A.SUITE, A.STREET, A.CITY,A.STATE, A.ZIP
FROM VEHICLE V, DRIVER D, PERSON P, ADDRESS A
WHERE P.PERSON_ID = V.PERSON_ID
AND V.PERSON_ID = D.DRIVER_ID 
AND P.ADDRESS_ID = A.ADDRESS_ID
GROUP BY P.PERSON_ID
ORDER BY COUNT(V.ACCIDENT_ID) DESC
LIMIT 10;

SELECT IC.COMPANY_ID, IC.NAME, MIN(I.PREMIUM_AMOUNT), MAX(I.PREMIUM_AMOUNT), AVG(I.PREMIUM_AMOUNT), SUM(I.PREMIUM_AMOUNT)
FROM INSURANCE I, INSURANCE_COMPANY IC
WHERE I.INSURANCE_COMP_ID = IC.COMPANY_ID
GROUP BY IC.COMPANY_ID;

SELECT I.INSURANCE_COMP_ID, IC.NAME, SUM(S.FINAL_AMOUNT) AS TOTAL_SETTLEMENT
FROM INSURANCE I, SETTLEMENT S, INSURANCE_COMPANY IC, CLAIM C
WHERE I.INSURANCE_COMP_ID = IC.COMPANY_ID
AND S.SETTLEMENT_ID = C.SETTLEMENT_ID
AND C.INSURANCE_ID = I.INSURANCE_ID
GROUP BY I.INSURANCE_COMP_ID
LIMIT 10;

SELECT BRAND, COUNT(ACCIDENT_ID)
FROM VEHICLE
GROUP BY BRAND
ORDER BY COUNT(ACCIDENT_ID) DESC
LIMIT 10;

SELECT V.STATE, IC.NAME, COUNT(I.INSURANCE_ID) AS NO_OF_INSURANCES
FROM INSURANCE I, INSURANCE_COMPANY IC, VEHICLE V
WHERE I.VEHICLE_REG_NO = V.REGISTRATION_NO
AND I.INSURANCE_COMP_ID = IC.COMPANY_ID
GROUP BY V.STATE
ORDER BY COUNT(I.INSURANCE_ID) DESC
LIMIT 10;

SELECT STATE, COUNT(ACCIDENT_ID)
FROM ACCIDENT
GROUP BY STATE
ORDER BY COUNT(ACCIDENT_ID) DESC
LIMIT 10;

SELECT P.PERSON_ID, P.FIRST_NAME, P.LAST_NAME, P.GENDER, P.EMAIL, C.DATE, C.TOTAL_AMOUNT
FROM PERSON P, CLAIM C, INSURANCE I, VEHICLE V
WHERE C.INSURANCE_ID = I.INSURANCE_ID
AND I.VEHICLE_REG_NO = V.registration_no
AND V.PERSON_ID = P.PERSON_ID
AND C.TOTAL_AMOUNT > 5000
GROUP BY P.PERSON_ID
LIMIT 10;
SELECT * FROM VEHICLE;
SELECT C.CLAIM_ID, C.INSURANCE_ID, I.VEHICLE_REG_NO, P.FIRST_NAME, P.LAST_NAME, P.GENDER, P.PHONE
FROM CLAIM C, INSURANCE I, PERSON P, VEHICLE V
WHERE C.INSURANCE_ID = I.INSURANCE_ID
AND I.VEHICLE_REG_NO = V.REGISTRATION_NO
AND V.PERSON_ID = P.PERSON_ID
AND C.CLAIM_ID IN (
SELECT CLAIM_ID
FROM CLAIM
WHERE CLAIM_ID NOT IN(
SELECT CLAIM_ID
FROM CLAIM C, SETTLEMENT S 
WHERE  C.SETTLEMENT_ID = S.SETTLEMENT_ID
));
SELECT * FROM CLAIM;
SELECT IC.NAME, MAX(S.FINAL_AMOUNT)
FROM INSURANCE_COMPANY IC, SETTLEMENT S, CLAIM C, INSURANCE I
WHERE S.SETTLEMENT_ID = C.SETTLEMENT_ID
AND C.INSURANCE_ID = I.INSURANCE_ID
AND I.INSURANCE_COMP_ID = IC.COMPANY_ID;
SELECT * FROM SETTLEMENT
ORDER BY FINAL_AMOUNT DESC;

select * from claim;
describe claim;
describe settlement;
ALTER TABLE claim
MODIFY COLUMN insurance_id int not null;
ALTER TABLE claim
ADD FOREIGN KEY (settlement_id) REFERENCES settlement (settlement_id);
select * from accident;
select year(date),count(accident_id) from accident group by year(date);
select year(c.date), count(c.claim_id), count(s.settlement_id) 
from claim c
left join settlement s
on  c.settlement_id = s.settlement_id
group by year(c.date)
order by year(c.date); 
select * from person; 
select p.gender, count(person_id) 
from person p, driver d
where p.person_id = d.driver_id
group by p.gender;
select * from person;
UPDATE person 
SET 
    gender = 'Female'
WHERE
    person_id = 17;
    
select * from claim;
select * from settlement;
select c.claim_ID, c.date as Claim_Date, s.date as Settlement_Date, DATEDIFF(s.date, c.date) as Time_taken_for_Settlement, c.total_amount, s.final_amount, c.total_amount-s.final_amount as Difference
from claim c, settlement s
where c.settlement_id = s.settlement_id 
order by Time_taken_for_Settlement desc
limit 10; 
    
select c.claim_ID, c.date as Claim_Date, s.date as Settlement_Date, DATEDIFF(s.date, c.date) as Time_taken_for_Settlement, c.total_amount as Claim_Amt, s.final_amount as Settlement_Amt, c.total_amount-s.final_amount as Difference
from claim c, settlement s
where c.settlement_id = s.settlement_id
and c.claim_ID = 40;    
    
update settlement
set final_amount = 4000
where settlement_id  = 36;