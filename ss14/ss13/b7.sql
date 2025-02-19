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

-- 3
insert into banks (bank_id, bank_name, status) values 
(1, 'vietinbank', 'active'),   
(2, 'sacombank', 'error'),    
(3, 'agribank', 'active');


-- 4
alter table company_funds add column bank_id int;
alter table company_funds add constraint fk_bank foreign key (bank_id) references banks(bank_id);


-- 5
set sql_safe_updates = 0;
update company_funds set bank_id = 1 where balance = 50000.00;
insert into company_funds (balance, bank_id) values (45000.00, 2);
set sql_safe_updates = 1;


-- 6
delimiter //
create trigger checkbankstatus
before insert on payroll
for each row
begin
    declare bank_status varchar(10);
    select status into bank_status from banks
    inner join company_funds on banks.bank_id = company_funds.bank_id
    where company_funds.fund_id = new.emp_id;

    if bank_status = 'error' then
        signal sqlstate '45000'
        set message_text = 'cannot process payroll, bank is in error status.';
    end if;
end;
// delimiter ;

-- 7
delimiter //
create procedure transfersalary(in p_emp_id int)
begin
    declare v_balance decimal(15,2);
    declare v_salary decimal(10,2);
    declare v_bank_status varchar(10);

    start transaction;
    select balance into v_balance from company_funds where bank_id = 1;
    select salary into v_salary from employees where emp_id = p_emp_id;

    if v_salary is null then
        rollback;
        insert into transaction_log (log_message) values ('employee does not exist.');
    end if;

    select status into v_bank_status from banks
    inner join company_funds on banks.bank_id = company_funds.bank_id
    where company_funds.fund_id = p_emp_id;

    if v_bank_status = 'error' then
        rollback;
        insert into transaction_log (log_message) values ('bank is in error status.');
    end if;

    if v_balance < v_salary then
        rollback;
        insert into transaction_log (log_message) values ('insufficient fund.');
    end if;

    update company_funds set balance = balance - v_salary where bank_id = 1;
    insert into payroll (emp_id, salary, pay_date) values (p_emp_id, v_salary, curdate());
    update employees set last_pay_date = curdate() where emp_id = p_emp_id;

    commit;
    insert into transaction_log (log_message) values ('salary transferred successfully.');

end;
// delimiter ;

-- 8
call transfersalary(1);


