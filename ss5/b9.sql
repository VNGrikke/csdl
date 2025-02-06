create table patients (
  patientid int primary key,
  fullname varchar(100),
  dateofbirth date,
  gender varchar(10),
  phonenumber varchar(15)
);

create table doctors (
  doctorid int primary key,
  fullname varchar(100),
  specialization varchar(50),
  phonenumber varchar(15),
  email varchar(100)
);

create table appointments (
  appointmentid int primary key,
  patientid int,
  doctorid int,
  appointmentdate datetime,
  status varchar(20),
  foreign key (patientid) references patients(patientid),
  foreign key (doctorid) references doctors(doctorid)
);

create table medicalrecords (
  recordid int primary key,
  patientid int,
  doctorid int,
  diagnosis text,
  treatmentplan text,
  foreign key (patientid) references patients(patientid),
  foreign key (doctorid) references doctors(doctorid)
);


select 
    p.fullname as PatientName, 
    d.fullname as DoctorName, 
    a.appointmentdate, 
    d.specialization, 
    a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
where a.appointmentdate between '2025-01-20' and '2025-01-25'
order by a.appointmentdate
limit 3;


select 
    p.fullname as PatientName, 
    p.dateofbirth as DateOfBirth, 
    d.fullname as DoctorName, 
    d.specialization, 
    m.diagnosis
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords m on p.patientid = m.patientid and d.doctorid = m.doctorid
where a.appointmentdate between '2025-01-20' and '2025-01-25'
order by a.appointmentdate
limit 5;


select 
    p.fullname as PatientName,
    p.dateofbirth as DateOfBirth,
    datediff(a.appointmentdate, p.dateofbirth) div 365 as AgeAtAppointment,
    a.appointmentdate,
    m.diagnosisdate as DiagnosisDate,
    datediff(a.appointmentdate, m.diagnosisdate) as DaysDifference
from appointments a
join patients p on a.patientid = p.patientid
join medicalrecords m on p.patientid = m.patientid
where m.diagnosisdate is not null
order by a.appointmentdate;

