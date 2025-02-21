create database CursorDemo_db;
use CursorDemo_db;

create table students(
	std_id int primary key auto_increment,
    std_name varchar(50) not null,
    physical_score float,
    math_score float,
    chemistry_score float,
    rate enum('yeu', 'tb', 'kha', 'gioi', 'xuat xac')
);

insert into students (std_name, physical_score, math_score, chemistry_score) values
('Nguyen Van A', 5.7, 6.9, 8.5),
('Nguyen Van B', 8.7, 7.9, 8.5),
('Nguyen Van C', 2.7, 1.9, 2.5),
('Nguyen Van D', 9.7, 9.9, 8.5),
('Nguyen Van E', 4.7, 6.9, 8.5);


delimiter //
create procedure rating_student()
begin
	declare isFinish bit default(0);
    declare st_id int;
	declare st_math int;
    declare st_physical int;
    declare st_chemistry int;
    declare cursor_stds cursor for select std_id, physical_score, math_score, chemistry_score from students;
    declare continue handler for not found set isFinish = 1;
    
    open cursor_stds;
		student_loop: loop
        fetch cursor_stds into st_id, st_math, st_physical, st_chemistry;
		if isFinish then
			leave student_loop;
		end if;
        update students
        set rate = case
			when (st_math + st_physical + st_chemistry)/3 < 5 then 'yeu'
            when (st_math + st_physical + st_chemistry)/3 < 7 then 'tb'
			when (st_math + st_physical + st_chemistry)/3 < 8 then 'kha' 
            when (st_math + st_physical + st_chemistry)/3 < 9 then 'gioi'
            else 'xuat xac'
		end
		where std_id = st_id;
		end loop;
	close cursor_stds;
end;
// delimiter ;

select * from students;
call rating_student();