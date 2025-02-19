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

create table student_status (
    student_id int primary key ,
    student_status enum('active','graduated','suspended'),
    foreign key(student_id) references students(student_id)
);

INSERT INTO student_status (student_id, student_status) VALUES
(1, 'ACTIVE'), -- Nguyễn Văn An có thể đăng ký
(2, 'GRADUATED'); -- Trần Thị Ba đã tốt nghiệp, không thể đăng ký


-- 2
CREATE TABLE course_fees (
    course_id INT PRIMARY KEY,
    fee DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE student_wallets (
    student_id INT PRIMARY KEY,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE

);


-- 3
INSERT INTO course_fees (course_id, fee) VALUES
(1, 100.00), -- Lập trình C: 100$
(2, 150.00); -- Cơ sở dữ liệu: 150$

INSERT INTO student_wallets (student_id, balance) VALUES
(1, 200.00), -- Nguyễn Văn An có 200$
(2, 50.00);  -- Trần Thị Ba chỉ có 50$


-- 4
delimiter //
create procedure enroll_course (
    in p_student_id int,
    in p_course_id int
)
begin
    declare student_exists int;
    declare course_exists int;
    declare already_enrolled int;
    declare available_seats int;
    declare student_balance decimal(10,2);
    declare course_fee decimal(10,2);

    start transaction;
    select count(*) into student_exists from students where student_id = p_student_id;
    if student_exists = 0 then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'FAILED: Student does not exist');
        signal sqlstate '45000' set message_text = 'Student does not exist';
    end if;

    select count(*) into course_exists from courses where course_id = p_course_id;
    if course_exists = 0 then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'FAILED: Course does not exist');
        signal sqlstate '45000' set message_text = 'Course does not exist';
    end if;

    select count(*) into already_enrolled from enrollments where student_id = p_student_id and course_id = p_course_id;
    if already_enrolled > 0 then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'FAILED: Already enrolled');
        signal sqlstate '45000' set message_text = 'Already enrolled';
    end if;

    select available_seats into available_seats from courses where course_id = p_course_id;
    if available_seats <= 0 then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'FAILED: No available seats');
        signal sqlstate '45000' set message_text = 'No available seats';
    end if;

    select balance into student_balance from student_wallets where student_id = p_student_id;
    select fee into course_fee from course_fees where course_id = p_course_id;
    if student_balance < course_fee then
        rollback;
        insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'FAILED: Insufficient balance');
        signal sqlstate '45000' set message_text = 'Insufficient balance';
    end if;
    insert into enrollments (student_id, course_id) values (p_student_id, p_course_id);
    update student_wallets set balance = balance - course_fee where student_id = p_student_id;
    update courses set available_seats = available_seats - 1 where course_id = p_course_id;
    insert into enrollments_history (student_id, course_id, action) values (p_student_id, p_course_id, 'REGISTERED');
    commit;

end;
//
delimiter ;


-- 5
call enroll_course(1, 1);  
call enroll_course(2, 2);


-- 6
select * from student_wallets;
select * from enrollments;
select * from courses;
select * from enrollments_history;

