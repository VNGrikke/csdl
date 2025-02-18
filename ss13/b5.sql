create table transaction_log (
	log_id int auto_increment primary key,
    log_message text not null,
    log_time timestamp default current_timestamp
);

alter table transaction_log
add column last_pay_date date default(current_date);

delimiter //
create procedure pay_salary2(p_emp_id int)
begin
    declare com_balance decimal(15,2);
    declare emp_salary decimal(10,2);
    declare emp_exists int;
    
    start transaction;
    
    select count(*) into emp_exists from employees where emp_id = p_emp_id;
    if emp_exists = 0 then
        insert into transaction_log (log_message) values ('nhân viên không tồn tại');
        rollback;
    end if;
    
    select balance into com_balance from company_funds where fund_id = 1;
    select salary into emp_salary from employees where emp_id = p_emp_id;
    
    if com_balance < emp_salary then
        insert into transaction_log (log_message) values ('quỹ không đủ tiền');
        rollback;
    else
        update company_funds
        set balance = balance - emp_salary
        where fund_id = 1;
        
        insert into payroll (emp_id, salary, pay_date)
        values (p_emp_id, emp_salary, curdate());
        
        insert into transaction_log (log_message, last_pay_date) 
        values ('chuyển lương cho nhân viên thành công', curdate());
        
        commit;
    end if;
end;
// delimiter ;
 
call pay_salary2(1);

select * from transaction_log;