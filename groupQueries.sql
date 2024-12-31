SELECT
    *
FROM
    appointment;

SELECT
    *
FROM
    patient;

SELECT
    *
FROM
    nurse;

SELECT
    *
FROM
    primary_doctor;

SELECT
    *
FROM
    doctor;

SELECT
    *
FROM
    attends_appt;

SELECT
    *
FROM
    scheduled_appt;

SELECT
    *
FROM
    treatment;

SELECT
    *
FROM
    assigned_treatment;

SELECT
    *
FROM
    invoice_proj;

SELECT
    *
FROM
    department_proj;


--displays all appointments for each patient if they have one
SELECT
    firstname,
    lastname,
    TO_CHAR(timeofvisit, 'HH24:MI:SS') AS timeofvisit,
    dateofvisit,
    roomnumber
FROM
         patient p
    JOIN appointment a ON ( p.patientid = a.patientid );

--gets the cost of stay for each patient 
SELECT
    i.invoiceid,
    p.firstname,
    p.lastname,
    SUM(t.cost) AS costofstay
FROM
         patient p
    JOIN appointment        a ON ( p.patientid = a.patientid )
    JOIN invoice_proj       i ON ( a.apptid = i.apptid )
    JOIN assigned_treatment at ON ( at.apptid = a.apptid )
    JOIN treatment          t ON ( t.treatmentid = at.treatmentid )
GROUP BY
    i.invoiceid,
    p.firstname,
    p.lastname;
    
    
    
--gets the department that each doctor is from
SELECT
    firstname,
    lastname,
    deptname,
    location
FROM
         doctor d
    JOIN department_proj dept ON ( d.deptid = dept.deptid );
    
--patient appt with doctors phone number
select d.lastname, d.officephone, 
From doctor