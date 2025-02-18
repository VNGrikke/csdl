create table enrollments_history (
	history_id int primary key auto_increment,
    student_id int,
    course_id int,
    action varchar(50),
    timestamp datetime default(current_timestamp)
);


delimiter //
create procedure register_course2(p_student_id int, p_course_id int )
begin
	start transaction;    
    if (select available_seats from courses where course_id = p_course_id) <= 0 then
		insert into enrollments_history(student_id, course_id, action)
        values(p_student_id,p_course_id, 'falied');
        rollback;
    else
        update courses
        set available_seats = available_seats - 1
        where course_id = p_course_id;
        
        insert into enrollments (student_id, course_id)
        values (p_student_id, p_course_id);
        
        insert into enrollments_history(student_id, course_id, action)
        values(p_student_id,p_course_id, 'registered');
        
        commit;
    end if;
end
// delimiter ;

call register_course2(2,1);


SELECT * FROM ss13.courses;
SELECT * FROM ss13.students;
SELECT * FROM ss13.enrollments;
select * from enrollments_history;
