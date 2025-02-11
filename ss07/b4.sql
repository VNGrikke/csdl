INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);


select * from projects;

select employees.name as employee_name, departments.department_name 
from employees
left join departments on employees.department_id = departments.department_id;

select employees.name as employee_name, workreports.report_content 
from workreports
join employees on workreports.employee_id = employees.employee_id;

select employees.name as employee_name, projects.project_name, timesheets.hours_worked
from timesheets
join employees on timesheets.employee_id = employees.employee_id
join projects on timesheets.project_id = projects.project_id;

select employees.name as employee_name, timesheets.hours_worked
from timesheets
join employees on timesheets.employee_id = employees.employee_id
join projects on timesheets.project_id = projects.project_id
where projects.project_name = 'Project A';



update employees 
set salary = 6500.00 
where name like '%Alice%';

delete from workreports 
where employee_id in (select employee_id from employees where name like '%Brown%');

insert into employees (employee_id, name, dob, department_id, salary) 
values (5, 'James Lee', '1996-05-20', 1, 5000.00);

