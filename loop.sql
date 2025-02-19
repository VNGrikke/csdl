create database cursor_loop;
use cursor_loop;

create table students(
	stu_id int primary key auto_increment,
    stu_name varchar(100) not null,
    stu_age int,
	stu_status bit default(1)
);

create table student_log(
	stu_id int primary key auto_increment,
    stu_age int
);

-- create table tran 


/*
	1. demo su dung con tro (cursor) va vong lap (loop)
	viet procedure cho phep them tat ca sinh vien co trang thai la 1vao bang student_log
*/

delimiter //
create procedure pro_insert_student_log()
begin
	declare isFinish bit default(0);
    declare st_id int;
    declare st_age int;
    declare cursor_stds cursor for select stu_id, stu_age from students where stu_status = 1;
    declare continue handler for NOT FOUND set isFinish = 1;
    
    open cursor_stds;
		student_loop: loop
		fetch cursor_stds into st_id, st_age;
		if isFinish then
			leave student_loop;
		end if;
        insert into student_log(st_log_age)
        values(st_age);
    end loop student_loop;
end;
// delimiter ;

call pro_insert_student_log();