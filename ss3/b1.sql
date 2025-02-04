create database ss3;
use ss3;

create table Student(
	student_id int primary key not null,
    student_name varchar(225) not null,
    student_age int check(student_age>=18) not null,
    student_gender varchar(10) check(student_gender in ('male', 'female','other')) not null,
    registration_date datetime default current_timestamp not null
);

select * from ss3.student;
       
insert into ss3.student (student_id, student_name, student_age, student_gender)
values
  (1, 'Vuong', 18, 'male'),
  (2, 'Vy', 19, 'female'),
  (3, 'Son', 20, 'other');
