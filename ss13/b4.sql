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

delimiter //
set autocommit = 0;
create procedure register_course(p_student_id int, p_course_id int )
begin
    start transaction;
    
    if (select available_seats from courses where course_id = p_course_id) <= 0 then
        rollback;
    else
        update courses
        set available_seats = available_seats - 1
        where course_id = p_course_id;
        
        insert into enrollments (student_id, course_id)
        values (p_student_id, p_course_id);
        
        commit;
    end if;
end
// delimiter ;

call register_course(1,1);
