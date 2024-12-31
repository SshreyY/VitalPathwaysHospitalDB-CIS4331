--Group Project Part 3
--Team Number: 3
--Team Members: Andrew Coffman, Shrey Patel, Michael Colbert (lead)
--Database System Name: Vital Pathways Hospital Database

--SQL Script below to create our database's tables

--Creating the relevant indexes
CREATE INDEX index_primary_doctor_phone on PRIMARY_DOCTOR(Phone);
CREATE INDEX index_appointment_room_number on APPOINTMENT(RoomNumber);
CREATE INDEX index_treatment_cost ON TREATMENT(Cost);

--Drop Sequences if they were already created
DROP SEQUENCE nurse_id_seq;
DROP SEQUENCE dept_id_seq;
DROP SEQUENCE primary_doc_id_seq;
DROP SEQUENCE doctor_id_seq;
DROP SEQUENCE appt_id_seq;
DROP SEQUENCE patient_id_seq;
DROP SEQUENCE invoice_id_seq;
DROP SEQUENCE treatment_id_seq;

--Drop Tables if they were already created
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'NURSE';
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DEPARTMENT_proj';
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'PRIMARY_DOCTOR';
----SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DOCTOR';
----SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'PATIENT';
----SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'APPOINTMENT';
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'ATTENDS_APPT';
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'SCHEDULED_APPT';
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'INVOICE_proj';
--SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'ASSIGNED_TREATMENT';


--ALTER TABLE INVOICE_proj DROP CONSTRAINT FK_APPT_INVOICE_PROJ;
--ALTER TABLE PATIENT DROP CONSTRAINT FK_PRIMARY_DOC_PATIENT;--
--ALTER TABLE DOCTOR DROP CONSTRAINT FK_DEPT_DOC;--
--ALTER TABLE ATTENDS_APPT DROP CONSTRAINT FK_NURSE_ATTENDS_APPT;--
--ALTER TABLE ATTENDS_APPT DROP CONSTRAINT FK_APPT_ATTENDS_APPT;--
--ALTER TABLE ASSIGNED_TREATMENT DROP CONSTRAINT FK_TREATMENT_ASSIGNED;--
--ALTER TABLE ASSIGNED_TREATMENT DROP CONSTRAINT FK_APPT_TREATMENT_ASSIGNED;--
--ALTER TABLE APPOINTMENT DROP CONSTRAINT FK_PATIENT_APPOINTMENT;
--ALTER TABLE SCHEDULED_APPT DROP CONSTRAINT FK_DOCTOR_SCHEDULED_APPT;
--ALTER TABLE SCHEDULED_APPT DROP CONSTRAINT FK_APPT_SCHEDULED_APPT;
--ALTER TABLE PATIENT_PHONE DROP CONSTRAINT FK_PATIENT_ID_PAT_PHONE;



DROP TABLE ATTENDS_APPT;
DROP TABLE SCHEDULED_APPT;
DROP TABLE ASSIGNED_TREATMENT;
DROP TABLE INVOICE_proj;
DROP TABLE TREATMENT;
DROP TABLE NURSE;
DROP TABLE DOCTOR;
DROP TABLE DEPARTMENT_proj;
DROP TABLE PATIENT_PHONE;
DROP TABLE APPOINTMENT;
DROP TABLE PATIENT; 
DROP TABLE PRIMARY_DOCTOR;




--create sequences for each of the primary key or id's
CREATE SEQUENCE nurse_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE dept_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE primary_doc_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE doctor_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE appt_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE patient_id_seq START WITH 1 INCREMENT BY 1;
--CREATE SEQUENCE patient_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE invoice_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE treatment_id_seq START WITH 1 INCREMENT BY 1;

--Create NURSE table
CREATE TABLE NURSE(
	NurseID INT PRIMARY KEY,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30) NOT NULL,
	PersonalPhone VARCHAR2(15) NOT NULL,
	OfficePhone VARCHAR2(15)
);

--Create DEPARTMENT table
CREATE TABLE DEPARTMENT_proj(
	DeptID INT PRIMARY KEY,
	DeptName VARCHAR2(50),
	Location VARCHAR2(50) NOT NULL
);

--Create PRIMARY_DOCTOR Table
CREATE TABLE PRIMARY_DOCTOR(
	PrimaryDocID INT PRIMARY KEY,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30) NOT NULL,
	Phone VARCHAR2(15) NOT NULL
);

--Create DOCTOR table
CREATE TABLE DOCTOR(
	DoctorID INT PRIMARY KEY,
	PersonalPhone VARCHAR2(15) NOT NULL,
	OfficePhone VARCHAR2(15)NOT NULL,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30)NOT NULL,
	DeptID INT,
	CONSTRAINT fk_dept_doc FOREIGN KEY (DeptID) REFERENCES DEPARTMENT_proj(DeptID) --added _proj to name of table
);

--Create PATIENT table
CREATE TABLE PATIENT(
	PatientID INT PRIMARY KEY,
	FirstName VARCHAR2(30) NOT NULL,
	LastName VARCHAR2(30) NOT NULL,
	Address VARCHAR2(100) NOT NULL,
	DOB DATE NOT NULL,
	PrimaryDocID INT,
	CONSTRAINT fk_primary_doc_patient FOREIGN KEY (PrimaryDocID) REFERENCES PRIMARY_DOCTOR(PrimaryDocID)
);

--Create APPOINTMENT table
CREATE TABLE APPOINTMENT(
	ApptID INT PRIMARY KEY,
	RoomNumber VARCHAR2(10),
	TimeofVisit TIMESTAMP(2) NOT NULL,
	DateofVisit DATE NOT NULL,
	PatientID INT,
	CONSTRAINT fk_patient_appointment FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID)
);


--Create ATTENDS_APPT Table
CREATE TABLE ATTENDS_APPT(
	NurseID INT,
	ApptID INT,
	PRIMARY KEY (NurseID, ApptID),
	CONSTRAINT fk_nurse_attends_appt FOREIGN KEY (NurseID) REFERENCES NURSE(NurseID),
	CONSTRAINT fk_appt_attends_appt FOREIGN KEY (ApptID) REFERENCES APPOINTMENT(ApptID)
);

--Create SCHEDULED_APPT table
CREATE TABLE SCHEDULED_APPT(
	DoctorID INT,
	ApptID INT,
	PRIMARY KEY (DoctorID, ApptID),
	CONSTRAINT fk_doctor_scheduled_appt FOREIGN KEY (DoctorID) REFERENCES DOCTOR(DoctorID),
	CONSTRAINT fk_appt_scheduled_appt FOREIGN KEY (ApptID) REFERENCES APPOINTMENT(ApptID)
);

--Create INVOiCE table
CREATE TABLE INVOICE_proj(
	InvoiceID INT PRIMARY KEY,
	ApptID INT,
	CONSTRAINT fk_appt_invoice_proj FOREIGN KEY (ApptID) REFERENCES APPOINTMENT(ApptID)
);

--Create Treatment table
CREATE TABLE TREATMENT(
	TreatmentID INT PRIMARY KEY,
	Name VARCHAR2(100) NOT NULL,
	Cost Number (10,2) NOT NULL
);

--Create ASSIGNED_TREATMENT table
CREATE TABLE ASSIGNED_TREATMENT(
	TreatmentID INT,
	ApptID INT,
	PRIMARY KEY (TreatmentID, ApptID),
	CONSTRAINT fk_treatment_assigned FOREIGN KEY (TreatmentID) REFERENCES TREATMENT(TreatmentID),
	CONSTRAINT fk_appt_treatment_assigned FOREIGN KEY (ApptID) REFERENCES APPOINTMENT(ApptID)
);

CREATE TABLE PATIENT_PHONE(
    PhoneNumber VARCHAR2(15),
    PatientID INT,
    PRIMARY KEY (PhoneNumber, PatientID),
    CONSTRAINT FK_PATIENT_ID_PAT_PHONE FOREIGN KEY (PatientID) REFERENCES PATIENT(PatientID)
    );


--------------------------------------------------------------------------------------


--Now Inserting data into the tables created above

INSERT INTO NURSE(NurseID, FirstName, LastName, PersonalPhone, OfficePhone)
VALUES (nurse_id_seq.NEXTVAL, 'Alice', 'Johnson', '215-555-1010', '267-555-2020');
INSERT INTO NURSE(NurseID, FirstName, LastName, PersonalPhone, OfficePhone)
VALUES (nurse_id_seq.NEXTVAL, 'Bob', 'Smith', '215-555-3030', '267-555-2040');
INSERT INTO NURSE(NurseID, FirstName, LastName, PersonalPhone, OfficePhone)
VALUES (nurse_id_seq.NEXTVAL, 'Michelle', 'Russo','215-555-5050', '267-555-6060');

INSERT INTO DEPARTMENT_proj(DeptID, DeptName, Location)
VALUES (dept_id_seq.NEXTVAL, 'Internal Medicine', 'Building A, Floor 2');
INSERT INTO DEPARTMENT_proj(DeptID, DeptName, Location)
VALUES (dept_id_seq.NEXTVAL, 'Cardiology', 'Building B, Floor 1');
INSERT INTO DEPARTMENT_proj(DeptID, DeptName, Location)
VALUES (dept_id_seq.NEXTVAL, 'Nephrology', 'Building B, Floor 3');

INSERT INTO PRIMARY_DOCTOR(PrimaryDocId, FirstName, LastName, Phone)
VALUES (primary_doc_id_seq.NEXTVAL, 'Dr. Emma', 'Williams', '267-555-7070');
INSERT INTO PRIMARY_DOCTOR(PrimaryDocID, FirstName, LastName, Phone)
VALUES (primary_doc_id_seq.NEXTVAL, 'Dr. Liam', 'Brown', '267-555-8080');
INSERT INTO PRIMARY_DOCTOR(PrimaryDocID, FirstName, LastName, Phone)
VALUES (primary_doc_id_seq.NEXTVAL, 'Dr. Jennifer', 'Olson', '267-555-9090');

INSERT INTO DOCTOR(DoctorID, PersonalPhone, OfficePhone, FirstName, LastName, DeptID)
VALUES (doctor_id_seq.NEXTVAL, '215-555-1515', '267-555-2525', 'Michael', 'Colbert', 1);
INSERT INTO DOCTOR(DoctorID, PersonalPhone, OfficePhone, FirstName, LastName, DeptID)
VALUES (doctor_id_seq.NEXTVAL, '215-555-3535', '267-555-4545', 'Andrew', 'Coffman', 2);
INSERT INTO DOCTOR(DoctorID, PersonalPhone, OfficePhone, FirstName, LastName, DeptID)
VALUES (doctor_id_seq.NEXTVAL, '215-555-5555', '267-555-6565', 'Shrey', 'Patel', 3);

INSERT INTO PATIENT(PatientID, FirstName, LastName, Address, DOB, PrimaryDocID)
VALUES (patient_id_seq.NEXTVAL, 'John', 'Doe', '123 Maple St, Philadelphia, PA', TO_DATE('05-15-1990', 'MM-DD-YYYY'), 1);
INSERT INTO PATIENT(PatientID, FirstName, LastName, Address, DOB, PrimaryDocID)
VALUES (patient_id_seq.NEXTVAL, 'Jane', 'Smith', '456 Oak Ave, Philadelphia, PA', TO_DATE('11-16-1985', 'MM-DD-YYYY'), 2);
INSERT INTO PATIENT(PatientID, FirstName, LastName, Address, DOB, PrimaryDocID)
VALUES (patient_id_seq.NEXTVAL, 'Daniel', 'Gafford', '78 North Street, Philadelphia, PA', TO_DATE('03-21-1997', 'MM-DD-YYYY'), 3);

INSERT INTO APPOINTMENT(ApptID, RoomNumber, TimeofVIsit, DateofVIsit, PatientID)
VALUES (appt_id_seq.NEXTVAL, '424', to_timestamp('2024-10-29 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('10-29-2024', 'MM-DD-YYYY'), 1);
INSERT INTO APPOINTMENT(ApptID, RoomNumber, TimeofVIsit, DateofVIsit, PatientID)
VALUES (appt_id_seq.NEXTVAL, '420', to_timestamp('2024-10-30 10:30:00','YYYY-MM-DD HH24:MI:SS'), TO_DATE('10-30-2024', 'MM-DD-YYYY'), 2);
INSERT INTO APPOINTMENT(ApptID, RoomNumber, TimeofVIsit, DateofVIsit, PatientID)
VALUES (appt_id_seq.NEXTVAL, '451', to_timestamp('2024-10-31 10:30:00','YYYY-MM-DD HH24:MI:SS'), TO_DATE('10-31-2024', 'MM-DD-YYYY'), 3);


INSERT INTO INVOICE_proj(InvoiceID, ApptID)
VALUES (invoice_id_seq.NEXTVAL, 1);
INSERT INTO INVOICE_proj(InvoiceID, ApptID)
VALUES (invoice_id_seq.NEXTVAL, 2);
INSERT INTO INVOICE_proj(InvoiceID, ApptID)
VALUES (invoice_id_seq.NEXTVAL, 3);

INSERT INTO TREATMENT(TreatmentID, Name, Cost)
VALUES (treatment_id_seq.NEXTVAL, 'ChemoTherapy', 500.00);
INSERT INTO TREATMENT(TreatmentID, Name, Cost)
VALUES (treatment_id_seq.NEXTVAL, 'Physical Therapy', 150.00);
INSERT INTO TREATMENT(TreatmentID, Name, Cost)
VALUES (treatment_id_seq.NEXTVAL, 'Cardiac Monitoring', 1000.00);

INSERT INTO ATTENDS_APPT(NurseID, ApptID)
VALUES (1,3);
INSERT INTO ATTENDS_APPT(NurseID, ApptID)
VALUES (2,2);
INSERT INTO ATTENDS_APPT(NurseID, ApptID)
VALUES (1,1);

INSERT INTO SCHEDULED_APPT(DoctorID, ApptID)
VALUES (1,3);
INSERT INTO SCHEDULED_APPT(DoctorID, ApptID)
VALUES (2,2);
INSERT INTO SCHEDULED_APPT(DoctorID, ApptID)
VALUES (1,1);

INSERT INTO ASSIGNED_TREATMENT(TreatmentID, ApptID)
VALUES (1,1);
INSERT INTO ASSIGNED_TREATMENT(TreatmentID, ApptID)
VALUES (3,1);
INSERT INTO ASSIGNED_TREATMENT(TreatmentID, ApptID)
VALUES (3,2);
INSERT INTO ASSIGNED_TREATMENT(TreatmentID, ApptID)
VALUES (2,3);

INSERT INTO PATIENT_PHONE(PhoneNumber, PatientID)
VALUES ('610-555-9123', 1);
INSERT INTO PATIENT_PHONE(PhoneNumber, PatientID)
VALUES ('484-555-6978', 1);
INSERT INTO PATIENT_PHONE(PhoneNumber, PatientID)
VALUES ('215-555-4203', 2);
