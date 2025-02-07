select 
    s.student_id, 
    s.name as student_name, 
    s.email, 
    c.course_name, 
    e.enrollment_date
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where s.student_id in (
    select student_id 
    from enrollments 
    group by student_id 
    having count(course_id) > 1
)
order by s.student_id, e.enrollment_date;


select 
    s.name as student_name, 
    s.email, 
    e.enrollment_date, 
    c.course_name, 
    c.fee
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where c.course_id in (
    select course_id 
    from enrollments 
    where student_id = (select student_id from students where name = 'Nguyen Van An')
)
and s.name <> 'Nguyen Van An'
order by e.enrollment_date;


select 
    c.course_name, 
    c.duration, 
    c.fee, 
    count(e.student_id) as total_students
from courses c
join enrollments e on c.course_id = e.course_id
group by c.course_id, c.course_name, c.duration, c.fee
having count(e.student_id) > 2
order by total_students desc;
