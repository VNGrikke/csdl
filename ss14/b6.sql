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
create trigger before_update_phone
before update on employees
for each row
begin
    if char_length(new.phone) != 10 then
        signal sqlstate '45000' set message_text = 'Số điện thoại phải có đúng 10 chữ số!';
    end if;
end //
delimiter ;

-- 3
create table notifications (
    notification_id int primary key auto_increment,
    employee_id int not null,
    message text not null,
    created_at timestamp default current_timestamp,
    foreign key (employee_id) references employees(employee_id) on delete cascade
);

-- 4
delimiter //
create trigger after_insert_employee
after insert on employees
for each row
begin
    insert into notifications (employee_id, message)
    values (new.employee_id, concat('Chào mừng ', new.name));
end //
delimiter ;

-- 5
delimiter //
create procedure addnewemployeewithphone(
    in emp_name varchar(255),
    in emp_email varchar(255),
    in emp_phone varchar(20),
    in emp_hire_date date,
    in emp_department_id int
)
begin
    declare emp_exists int;
    start transaction;
    if char_length(emp_phone) != 10 then
        rollback;
        signal sqlstate '45000' set message_text = 'Số điện thoại không hợp lệ!';
    end if;

    select count(*)
    into emp_exists
    from employees
    where email = emp_email;

    if emp_exists > 0 then
        rollback;
        signal sqlstate '45000' set message_text = 'Email đã tồn tại!';
    end if;
    insert into employees (name, email, phone, hire_date, department_id)
    values (emp_name, emp_email, emp_phone, emp_hire_date, emp_department_id);
    commit;
end //
delimiter ;

insert into departments (department_name) values ('mkt');
call addnewemployeewithphone('Nguyễn Văn A', 'nguyenvana@example.com', '0123456789', '2025-02-19', 1);



