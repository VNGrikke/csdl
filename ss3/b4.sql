create table Student(
	student_id int primary key auto_increment,
    student_name varchar(225) not null,
    student_email varchar(225) not null unique,
    student_age int check(student_age > 0)
);

insert into ss3.student (student_name, student_email, student_age) 
values 	('Nguyen Van A', 'nguyenvana@example.com', 22), 
		('Le Thi B', 'lethib@example.com', 20), 
		('Tran Van C', 'tranvanc@example.com', 23), 
		('Pham Thi D', 'phamthid@example.com', 21);
        

select * from ss3.student;

select * from ss3.student where student_id = 3;

drop table student;
