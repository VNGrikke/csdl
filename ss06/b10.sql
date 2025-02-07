INSERT INTO Patients (FullName, DateOfBirth, Gender, PhoneNumber)
VALUES
    ('Nguyen Van An', '1985-05-15', 'Nam', '0901234567'),
    ('Tran Thi Binh', '1990-09-12', 'Nu', '0912345678'),
    ('Pham Van Cuong', '1978-03-20', 'Nam', '0923456789'),
    ('Le Thi Dung', '2000-11-25', 'Nu', '0934567890'),
    ('Vo Van Em', '1982-07-08', 'Nam', '0945678901'),
    ('Hoang Thi Phuong', '1995-01-18', 'Nu', '0956789012'),
    ('Ngo Van Giang', '1988-12-30', 'Nam', '0967890123'),
    ('Dang Thi Hanh', '1992-06-10', 'Nu', '0978901234'),
    ('Bui Van Hoa', '1975-10-22', 'Nam', '0989012345');

-- Insert dữ liệu vào bảng Doctors (Thông tin bác sĩ)
INSERT INTO Doctors (FullName, Specialization, PhoneNumber, Email)
VALUES
    ('Le Minh', 'Noi Tong Quat', '0908765432', 'leminh@hospital.vn'),
    ('Phan Huong', 'Nhi Khoa', '0918765432', 'phanhuong@hospital.vn'),
    ('Nguyen Tuan', 'Tim Mach', '0928765432', 'nguyentuan@hospital.vn'),
    ('Dang Quang', 'Than Kinh', '0938765432', 'dangquang@hospital.vn'),
    ('Hoang Dung', 'Da Lieu', '0948765432', 'hoangdung@hospital.vn'),
    ('Vu Hanh', 'Phu San', '0958765432', 'vuhanh@hospital.vn'),
    ('Tran An', 'Noi Tiet', '0968765432', 'tranan@hospital.vn'),
    ('Lam Phong', 'Ho Hap', '0978765432', 'lamphong@hospital.vn'),
    ('Pham Ha', 'Chan Thuong Chinh Hinh', '0988765432', 'phamha@hospital.vn');

-- Insert dữ liệu vào bảng Appointments (Lịch hẹn khám)
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status)
VALUES
    (1, 2, '2025-02-01 09:00:00', 'Da Dat'), 
    (1, 2, '2025-02-15 14:00:00', 'Da Dat'), 
    (3, 1, '2025-01-29 10:30:00', 'Da Dat'), 
    (3, 1, '2025-01-30 10:50:00', 'Da Dat'), 
    (3, 1, '2025-02-30 12:30:00', 'Da Dat'), 
    (5, 3, '2025-01-30 08:00:00', 'Da Dat'), 
    (2, 4, '2025-02-03 16:00:00', 'Da Dat'), 
    (6, 6, '2025-02-10 10:00:00', 'Da Dat'), 
    (7, 7, '2025-02-15 11:30:00', 'Da Dat'), 
    (8, 8, '2025-02-20 09:00:00', 'Da Dat'), 
    (9, 9, '2025-02-25 14:30:00', 'Da Dat'); 

-- Insert dữ liệu vào bảng MedicalRecords (Hồ sơ y tế)
INSERT INTO MedicalRecords (PatientID, DoctorID, Diagnosis, TreatmentPlan)
VALUES
    (1, 2, 'Cam Cum', 'Nghi ngoi, uong nhieu nuoc, su dung paracetamol 500mg khi sot.'),
    (3, 1, 'Dau Dau Man Tinh', 'Kiem tra huyet ap dinh ky, giam cang thang, su dung thuoc giam dau khi can.'),
    (5, 3, 'Roi Loan Nhip Tim', 'Theo doi tim mach 1 tuan/lan, dung thuoc dieu hoa nhip tim.'),
    (2, 4, 'Dau Cot Song', 'Vat ly tri lieu, giam van dong manh.'),
    (4, 5, 'Viêm Da Tiep Xuc', 'Su dung kem boi da, tranh tiep xuc voi chat gay di ung.'),
    (6, 6, 'Thieu Mau', 'Tang cuong thuc pham giau sat, bo sung vitamin.'),
    (7, 7, 'Tieu Duong Type 2', 'Duy tri che do an lanh manh, kiem tra duong huyet thuong xuyen.'),
    (8, 8, 'Hen Suyen', 'Su dung thuoc xit hen hang ngay, tranh tiep xuc bui ban.'),
    (9, 9, 'Gay Xuong', 'Bo bot, kiem tra xuong dinh ky, vat ly tri lieu sau khi thao bot.');



delete from appointments 
where doctorid = (select doctorid from doctors where fullname = 'phan huong')
and appointmentdate < curdate();

select 
    a.appointmentid, 
    p.fullname as patientname, 
    d.fullname as doctorname, 
    a.appointmentdate, 
    a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid;



select 
    p.fullname as patientname,
    d.fullname as doctorname,
    a.appointmentdate,
    mr.diagnosis
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords mr on a.patientid = mr.patientid and a.doctorid = mr.doctorid
where (p.patientid, d.doctorid) in (
    select patientid, doctorid 
    from appointments 
    group by patientid, doctorid
    having count(*) >= 2
);



select 
    upper(concat('bệnh nhân: ', p.fullname, ' - bác sĩ: ', d.fullname)) as info,
    a.appointmentdate,
    mr.diagnosis,
    a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords mr on a.patientid = mr.patientid and a.doctorid = mr.doctorid
order by a.appointmentdate asc;



select 
    upper(concat('bệnh nhân: ', p.fullname, ' - bác sĩ: ', d.fullname)) as info,
    a.appointmentdate,
    mr.diagnosis,
    a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords mr on a.patientid = mr.patientid and a.doctorid = mr.doctorid
order by a.appointmentdate asc;
