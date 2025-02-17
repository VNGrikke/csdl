
-- 2
create table budget_warnings (
	warning_id int primary key auto_increment,
    project_id int not null,
    warning_message varchar(255) not null
);
-- 3
DELIMITER //
create trigger after_project_update
after update on projects
for each row
begin
    if new.total_salary > new.budget then
        if not exists (
            select 1 from budget_warnings 
            where project_id = new.project_id 
            and warning_message = 'Budget exceeded due to high salary'
        ) then
            insert into budget_warnings (project_id, warning_message) 
            values (new.project_id, 'Budget exceeded due to high salary');
        end if;
    end if;
end 
// DELIMITER ;
-- 	4
create view ProjectOverview 
as
select p.project_id,p.name as project_name,p.budget,p.total_salary,bw.warning_message
from projects p
left join budget_warnings bw on p.project_id = bw.project_id;
-- 5
insert into workers (name, project_id, salary) values ('Michael', 1, 6000.00);
insert into workers (name, project_id, salary) values ('Sarah', 2, 10000.00);
insert into workers (name, project_id, salary) values ('David', 3, 1000.00);

-- 6
select * from budget_warnings;
select * from ProjectOverview;