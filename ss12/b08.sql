-- 2
create table salary_history (
    history_id int auto_increment primary key,
    emp_id int not null,
    old_salary decimal(10, 2) not null,
    new_salary decimal(10, 2) not null,
    change_date datetime not null,
    foreign key (emp_id) references employees(emp_id)
);

-- 3
create table salary_warnings (
    warning_id int auto_increment primary key,
    emp_id int not null,
    warning_message varchar(255) not null,
    warning_date datetime not null,
    foreign key (emp_id) references employees(emp_id)
);

-- 4
DELIMITER //
create trigger after_salary_update
after update on employees
for each row
begin
    insert into salary_history (emp_id, old_salary, new_salary, change_date)
    values (old.emp_id, old.salary, new.salary, now());
    if new.salary < old.salary * 0.7 then
        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'Salary decreased by more than 30%', now());
    end if;
    if new.salary > old.salary * 1.5 then
        set new.salary = old.salary * 1.5;
        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'Salary increased above allowed threshold (adjusted to 150% of previous salary)', now());
    end if;
end //
DELIMITER ;

-- 5
DELIMITER //
create trigger after_project_insert
after insert on projects
for each row
begin
    declare active_project_count int;
    select count(*) into active_project_count
    from projects
    where emp_id = new.emp_id and status = 'in progress';
    if active_project_count > 3 then
        signal sqlstate '45000'
        set message_text = 'nhân viên đã tham gia hơn 3 dự án đang hoạt động';
    end if;
    if new.status = 'in progress' and new.start_date > now() then
        signal sqlstate '45000'
        set message_text = 'ngày bắt đầu của dự án là trong tương lai, nhưng trạng thái là "in progress"';
    end if;
end //
DELIMITER ;

-- 6
create view PerformanceOverview 
as
select p.project_id, p.name as project_name, count(e.emp_id) as employee_count, datediff(p.end_date, p.start_date) as total_days, p.status
from projects p
left join employees e on p.emp_id = e.emp_id
group by p.project_id, p.name, p.end_date, p.start_date, p.status;

-- 7
update employees set salary = salary * 0.5 where emp_id = 1; 

update employees
set salary = salary * 2
where emp_id = 2; 

-- 8
INSERT INTO projects (name, emp_id, start_date, status) 

VALUES ('New Project 1', 1, CURDATE(), 'In Progress');

INSERT INTO projects (name, emp_id, start_date, status) 

VALUES ('New Project 2', 1, CURDATE(), 'In Progress');

INSERT INTO projects (name, emp_id, start_date, status) 

VALUES ('New Project 3', 1, CURDATE(), 'In Progress');

INSERT INTO projects (name, emp_id, start_date, status) 

VALUES ('New Project 4', 1, CURDATE(), 'In Progress'); 

-- Trường hợp 2: Ngày bắt đầu dự án không hợp lệ

INSERT INTO projects (name, emp_id, start_date, status) 

VALUES ('Future Project', 2, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'In Progress');

-- 9
select * from PerformanceOverview;