CREATE DATABASE ss14_second;
USE ss14_second;
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    total_hours DECIMAL(5,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

CREATE TABLE salaries (
    employee_id INT PRIMARY KEY,
    base_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

CREATE TABLE salary_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- 2
delimiter //
create procedure increasesalary(
    in emp_id int,
    in new_salary decimal(10,2),
    in reason text
)
begin
    declare old_salary decimal(10,2);
    declare emp_exists int;

    start transaction;
    select count(*)
    into emp_exists
    from salaries
    where employee_id = emp_id;

    if emp_exists = 0 then
        rollback;
        signal sqlstate '45000' set message_text = 'Nhân viên không tồn tại!';
    else
        select base_salary
        into old_salary
        from salaries
        where employee_id = emp_id;

        insert into salary_history (employee_id, old_salary, new_salary, reason)
        values (emp_id, old_salary, new_salary, reason);

        update salaries
        set base_salary = new_salary
        where employee_id = emp_id;

        commit;
    end if;
end //
delimiter ;

-- 3
call increasesalary(1, 5000.00, 'Tăng lương định kỳ');

-- 4
delimiter //
create procedure deleteemployee(
    in emp_id int
)
begin
    declare emp_exists int;

    start transaction;
    select count(*)
    into emp_exists
    from employees
    where employee_id = emp_id;

    if emp_exists = 0 then
        rollback;
        signal sqlstate '45000' set message_text = 'Nhân viên không tồn tại!';
    else
        delete from salaries
        where employee_id = emp_id;

        delete from employees
        where employee_id = emp_id;
        commit;
    end if;
end //
delimiter ;

-- 5
call deleteemployee(2);
 
