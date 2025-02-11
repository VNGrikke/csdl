select e.name, d.department_name
from employees e
left join departments d on e.department_id = d.department_id
order by e.name;

select name, salary
from employees
where salary > 5000
order by salary desc;

select e.name, sum(t.hours_worked) as total_hours
from employees e
left join timesheets t on e.employee_id = t.employee_id
group by e.name;

select d.department_name, avg(e.salary) as average_salary
from employees e
join departments d on e.department_id = d.department_id
group by d.department_name;

select p.project_name, sum(t.hours_worked) as total_hours
from projects p
join timesheets t on p.project_id = t.project_id
join workreports w on t.employee_id = w.employee_id
where w.report_date between '2025-02-01' and '2025-02-28'
group by p.project_name;

select e.name, p.project_name, sum(t.hours_worked) as total_hours
from employees e
join timesheets t on e.employee_id = t.employee_id
join projects p on t.project_id = p.project_id
group by e.name, p.project_name;

select d.department_name, count(e.employee_id) as employee_count
from departments d
join employees e on d.department_id = e.department_id
group by d.department_name
having count(e.employee_id) > 1;

select w.report_date, e.name, w.report_content
from workreports w
join employees e on w.employee_id = e.employee_id
order by w.report_date desc
limit 2 offset 1;

select w.report_date, e.name, count(w.report_id) as report_count
from workreports w
join employees e on w.employee_id = e.employee_id
where w.report_content is not null
and w.report_date between '2025-01-01' and '2025-02-01'
group by w.report_date, e.name;

select e.name, p.project_name, sum(t.hours_worked) as total_hours, round(sum(t.hours_worked * e.salary), 2) as total_salary
from employees e
join timesheets t on e.employee_id = t.employee_id
join projects p on t.project_id = p.project_id
group by e.name, p.project_name
having sum(t.hours_worked) > 5
order by total_salary;
