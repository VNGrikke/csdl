create table Employees (
	employee_id int primary key auto_increment,
    employee_name varchar(255) not null,
    employee_email varchar(255) not null unique,
    department varchar(100)  not null,
    employee_salary decimal(10,2) check(employee_salary > 0)
);

INSERT INTO Employees (employee_name, employee_email, department, employee_salary) 
VALUES 	('Nguyen Van A', 'nguyenvana@example.com', 'Sales', 50000.00), 
		('Le Thi B', 'lethib@example.com', 'IT', 60000.00), 
		('Tran Van C', 'tranvanc@example.com', 'HR', 45000.00), 
		('Pham Thi D', 'phamthid@example.com', 'Marketing', 55000.00);
        
select * from employees;

-- set SQL_SAFE_UPDATES = 0;

update employees
set employee_salary = employee_salary * 1.1
where department = 'Marketing';

set SQL_SAFE_UPDATES = 1;  

drop table employees;

