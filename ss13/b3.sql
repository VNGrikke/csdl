create database ss13;
use ss13;

CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

delimiter //
create procedure pay_salary(p_emp_id int, cmp_id int)
begin
    declare com_balance decimal(15,2);
    declare emp_salary decimal(10,2);

    start transaction;
    
    if (select count(fund_id) from company_funds where fund_id = cmp_id) = 0
    or (select count(emp_id) from employees where emp_id = p_emp_id) = 0 then
        rollback;
    else
        select balance into com_balance from company_funds where fund_id = cmp_id;
        select salary into emp_salary from employees where emp_id = p_emp_id;
        
        if com_balance >= emp_salary then
            update company_funds
            set balance = balance - emp_salary
            where fund_id = cmp_id;
            
            insert into payroll (emp_id, salary, pay_date)
            values (p_emp_id, emp_salary, curdate());
            
            commit;
        else
            rollback;
        end if;
    end if;
end;
// delimiter ;

call pay_salary(1,1);
select * from company_funds;
select * from employees;
select * from payroll;