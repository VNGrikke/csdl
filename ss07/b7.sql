create table student (
    rn int primary key, 
    name varchar(20), 
    age tinyint
);

create table test (
    testid int primary key, 
    name varchar(20)
);

create table studenttest (
    rn int, 
    testid int, 
    date datetime, 
    mark float,
    foreign key (rn) references student(rn),
    foreign key (testid) references test(testid)
);


insert into student (rn, name, age) values
(1, 'Nguyen Hong Ha', 20),
(2, 'Truong Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

insert into test (testid, name) values
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

insert into studenttest (rn, testid, date, mark) values
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);


-- 1
select s.name as studentname, t.name as testname, st.mark, st.date
from student s
join studenttest st on s.rn = st.rn
join test t on st.testid = t.testid;

-- 2
select s.name as studentname
from student s
left join studenttest st on s.rn = st.rn
where st.rn is null;

-- 3
select s.name as studentname, t.name as testname, st.mark
from student s
join studenttest st on s.rn = st.rn
join test t on st.testid = t.testid
where st.mark < 5;

-- 4
select s.name as studentname, avg(st.mark) as avgmark
from student s
join studenttest st on s.rn = st.rn
group by s.name
order by avgmark desc;

-- 5
select s.name as studentname, avg(st.mark) as avgmark
from student s
join studenttest st on s.rn = st.rn
group by s.name
order by avgmark desc
limit 1;

-- 6
select t.name as testname, max(st.mark) as highestmark
from test t
join studenttest st on t.testid = st.testid
group by t.name
order by t.name;

-- 7
select s.name as studentname, t.name as testname
from student s
left join studenttest st on s.rn = st.rn
left join test t on st.testid = t.testid;

-- 8
update student set age = age + 1;
alter table student add column status varchar(10);

-- 9
update student 
set status = case 
    when age < 30 then 'young'
    else 'old' 
end;

-- 10
select s.name as studentname, t.name as testname, st.mark, st.date
from student s
join studenttest st on s.rn = st.rn
join test t on st.testid = t.testid
order by st.date asc;

-- 11
select s.name, s.age, avg(st.mark) as avgmark
from student s
join studenttest st on s.rn = st.rn
where s.name like 't%'
group by s.name, s.age
having avgmark > 4.5;

-- 12
select s.rn, s.name, s.age, avg(st.mark) as avgmark,
       rank() over (order by avg(st.mark) desc) as ranking
from student s
join studenttest st on s.rn = st.rn
group by s.rn, s.name, s.age;

-- 13
-- alter table student modify column name nvarchar(max);

-- 14
update student
set name = case 
    when age > 20 then 'old ' || name
    else 'young ' || name
end;

-- 15
delete from test
where testid not in (select distinct testid from studenttest);

-- 16
delete from studenttest
where mark < 5;
