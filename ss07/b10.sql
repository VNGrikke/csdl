create table students (
    studentid int primary key,
    studentname varchar(50),
    age int,
    email varchar(100)
);

insert into students values
(1, 'Nguyen Quang An', 18, 'an@yahoo.com'),
(2, 'Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
(3, 'Nguyen Van Quyen', 19, 'quyen'),
(4, 'Phan Thanh Binh', 25, 'binh@com'),
(5, 'Nguyen Van Tai', 30, 'tai@msport.vn');

create table class (
    classid int primary key,
    classname varchar(50)
);

insert into class values
(1, 'C0701L'),
(2, 'C0708G');

create table classstudent (
    studentid int,
    classid int,
    foreign key (studentid) references students(studentid),
    foreign key (classid) references class(classid)
);

insert into classstudent values
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 1);

create table subjects (
    subjectid int primary key,
    subjectname varchar(50)
);

insert into subjects values
(1, 'SQL'),
(2, 'Java'),
(3, 'C'),
(4, 'Visual Basic');

create table mark (
    mark int,
    subjectid int,
    studentid int,
    foreign key (subjectid) references subjects(subjectid),
    foreign key (studentid) references students(studentid)
);

insert into mark values
(8, 1, 1),
(4, 1, 2),
(3, 1, 3),
(7, 2, 1),
(9, 2, 2),
(3, 3, 2),
(3, 3, 3);


-- 1.
select * from students;

-- 2. 
select * from subjects;

-- 3.
select studentid, avg(mark) as avg_mark from mark group by studentid;

-- 4. 
select distinct s.subjectname 
from mark m 
join subjects s on m.subjectid = s.subjectid 
where m.mark = 9;

-- 5. 
select studentid, avg(mark) as avg_mark 
from mark 
group by studentid 
order by avg_mark desc;

-- 6. 
update subjects 
set subjectname = concat('Day la mon hoc ', subjectname);

-- 7.
delimiter //
create trigger check_age_before_insert 
before insert on students
for each row
begin
    if new.age < 15 or new.age > 50 then
        signal sqlstate '45000'
        set message_text = 'Age must be between 15 and 50';
    end if;
end;
//
delimiter ;

-- 8.
alter table classstudent drop foreign key classstudent_ibfk_1;
alter table classstudent drop foreign key classstudent_ibfk_2;
alter table mark drop foreign key mark_ibfk_1;
alter table mark drop foreign key mark_ibfk_2;

-- 9. 
delete from students where studentid = 1;

-- 10. 
alter table students add column status bit default 1;

-- 11. 
update students set status = 0;
