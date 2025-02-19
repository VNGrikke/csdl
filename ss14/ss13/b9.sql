create database ss13;
use ss13;

CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL 
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,  
    salary DECIMAL(10,2) NOT NULL   
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    salary DECIMAL(10,2) NOT NULL,
    pay_date DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

create table transaction_log (
    log_id int primary key auto_increment,
    log_message varchar(255) not null,
    log_date datetime default current_timestamp
);

INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);


alter table employees add column last_pay_date date;


create table banks (
    bank_id int primary key,
    bank_name varchar(50) not null,
    status enum('active', 'error')
);

insert into banks (bank_id, bank_name, status) values 
(1, 'vietinbank', 'active'),   
(2, 'sacombank', 'error'),    
(3, 'agribank', 'active');


alter table company_funds add column bank_id int;
alter table company_funds add constraint fk_bank foreign key (bank_id) references banks(bank_id);


set sql_safe_updates = 0;
update company_funds set bank_id = 1 where balance = 50000.00;
insert into company_funds (balance, bank_id) values (45000.00, 2);
set sql_safe_updates = 1;

-- 2
create table accounts(
	acc_id int primary key auto_increment,
    emp_id int,
    bank_id int,
    amount_add decimal(15,2),
    total_amount decimal(15,2),
    foreign key(emp_id) references employees(emp_id),
    foreign key(bank_id) references banks(bank_id)
);

-- 3
INSERT INTO accounts (emp_id, bank_id, amount_add, total_amount) VALUES
(1, 1, 0.00, 12500.00),  
(2, 1, 0.00, 8900.00),   
(3, 1, 0.00, 10200.00),  
(4, 1, 0.00, 15000.00),  
(5, 1, 0.00, 7600.00);

-- 4
delimiter //
create procedure transfersalaryall()
begin
    declare v_balance decimal(15,2);
    declare v_salary decimal(10,2);
    declare v_bank_status enum('active', 'error');
    declare v_emp_id int;
    declare v_total_employees int;
    declare is_done bit default 0;
    declare emp_cursor cursor for select emp_id, salary from employees;
    declare continue handler for not found set is_done = 1;

    start transaction;

    select balance into v_balance from company_funds where bank_id = 1;
    select status into v_bank_status from banks where bank_id = 1;

    if v_bank_status = 'error' then
        rollback;
        insert into transaction_log (log_message) values ('failed: bank is in error status');
    end if;

    open emp_cursor;

    emp_loop: loop
        fetch emp_cursor into v_emp_id, v_salary;

        if is_done then
            leave emp_loop;
        end if;

        if v_balance < v_salary then
            rollback;
            insert into transaction_log (log_message) values ('failed: insufficient fund');
            close emp_cursor;
        end if;

        update company_funds set balance = balance - v_salary where bank_id = 1;
        insert into payroll (emp_id, salary, pay_date) values (v_emp_id, v_salary, curdate());
        update employees set last_pay_date = curdate() where emp_id = v_emp_id;
        update accounts set total_amount = total_amount + v_salary, amount_add = v_salary where emp_id = v_emp_id;
        select balance into v_balance from company_funds where bank_id = 1;
    end loop;
    close emp_cursor;
    commit;
    select count(*) into v_total_employees from employees;
    insert into transaction_log (log_message) values (concat('salary transferred successfully to ', v_total_employees, ' employees'));
end;
// delimiter ;


-- 5
call transfersalaryall();


-- 6
select * from company_funds;
select * from payroll;
select * from accounts;
select * from transaction_log;
