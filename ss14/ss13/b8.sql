create database Std;
use std;


CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    available_seats INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students (student_name) VALUES ('Nguyễn Văn An'), ('Trần Thị Ba');

INSERT INTO courses (course_name, available_seats) VALUES 
('Lập trình C', 25), 
('Cơ sở dữ liệu', 22);

create table enrollments_history (
	history_id int primary key auto_increment,
    student_id int,
    course_id int,
    action text,
    timestamp datetime default(current_timestamp),
    foreign key (student_id) references students(student_id),
    foreign key (course_id) references courses(course_id)
);


-- 2
create table student_status (
    student_id int primary key ,
    student_status enum('active','graduated','suspended'),
    foreign key(student_id) references students(student_id)
);


-- 3 
INSERT INTO student_status (student_id, student_status) VALUES
(1, 'ACTIVE'), -- Nguyễn Văn An có thể đăng ký
(2, 'GRADUATED'); -- Trần Thị Ba đã tốt nghiệp, không thể đăng ký


-- 4
delimiter //
create procedure enroll_student (
    in p_student_id int,
    in p_course_id int
)
begin
    declare v_student_status enum('active', 'graduated', 'suspended');
    declare v_available_seats int;
    declare exit handler for sqlexception
    begin
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'failed: student not eligible');
        signal sqlstate '45000' set message_text = 'student not eligible for enrollment';
    end;

    start transaction;

    if not exists (select 1 from students where student_id = p_student_id) then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'failed: student does not exist');
        signal sqlstate '45000' set message_text = 'student does not exist';
    end if;

    select available_seats into v_available_seats from courses where course_id = p_course_id;
    if v_available_seats is null then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'failed: course does not exist');
        signal sqlstate '45000' set message_text = 'course does not exist';
    end if;

    if exists (select 1 from enrollments where student_id = p_student_id and course_id = p_course_id) then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'failed: already enrolled');
        signal sqlstate '45000' set message_text = 'already enrolled';
    end if;

    select student_status into v_student_status from student_status where student_id = p_student_id;
    if v_student_status != 'active' then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'failed: student not eligible');
        signal sqlstate '45000' set message_text = 'student not eligible';
    end if;

    if v_available_seats <= 0 then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'failed: no available seats');
        signal sqlstate '45000' set message_text = 'no available seats';
    end if;
    insert into enrollments (student_id, course_id) values (p_student_id, p_course_id);
    update courses set available_seats = available_seats - 1 where course_id = p_course_id;
    insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'registered');
    commit;

end;
// delimiter ;

-- 5
call enroll_student(1, 1); 

call enroll_student(2, 2);


-- 6
select * from enrollments;
select * from courses;
select * from enrollments_history;



