select 
    concat(p.fullname, ' (', YEAR(a.appointmentdate) - YEAR(p.dateofbirth), ') - ', d.fullname) as PatientDoctor,
    a.appointmentdate,
    m.diagnosis
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords m on a.patientid = m.patientid and a.doctorid = m.doctorid
order by a.appointmentdate;


select 
    p.fullname as PatientName,
    YEAR(a.appointmentdate) - YEAR(p.dateofbirth) as AgeAtAppointment,
    a.appointmentdate,
    case 
        when YEAR(a.appointmentdate) - YEAR(p.dateofbirth) > 50 then 'Nguy cơ cao'
        when YEAR(a.appointmentdate) - YEAR(p.dateofbirth) between 30 and 50 then 'Nguy cơ trung bình'
        else 'Nguy cơ thấp'
    end as RiskLevel
from appointments a
join patients p on a.patientid = p.patientid
order by a.appointmentdate;


-- Xóa các lịch hẹn của bệnh nhân có tuổi lớn hơn 30 và bác sĩ thuộc chuyên khoa "Noi Tong Quat" hoặc "Chan Thuong Chinh Hinh"
delete from appointments
where patientid in (
    select a.patientid
    from appointments a
    join patients p on a.patientid = p.patientid
    join doctors d on a.doctorid = d.doctorid
    where (YEAR(a.appointmentdate) - YEAR(p.dateofbirth)) > 30
    and d.specialization in ('Noi Tong Quat', 'Chan Thuong Chinh Hinh')
);

-- Hiển thị danh sách lịch hẹn còn lại
select 
    p.fullname as PatientName,
    d.specialization,
    YEAR(a.appointmentdate) - YEAR(p.dateofbirth) as AgeAtAppointment
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
order by a.appointmentdate;
