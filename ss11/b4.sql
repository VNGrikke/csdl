-- 2
delimiter //
create procedure UpdateSalaryByID(employee_id int, inout current_salary decimal)
begin
	select Salary into current_salary from employees
    where EmployeeID = employee_id;
    if current_salary > 20000000 then
		set current_salary = current_salary * 1.05;
    else
		set current_salary = current_salary * 1.1;
	end if;
    
    update employees
    set Salary = current_salary where EmployeeID = employee_id;
    
    select FullName, Salary from employees where EmployeeID = employee_id;
end
// delimiter ;


-- 3
delimiter //
create procedure GetLoanAmountByCustomerID(out total_loan_amount decimal(15,2), in Customer_ID int)
begin
    select ifnull(sum(LoanAmount), 0) into total_loan_amount
    from loans 
    where CustomerID = Customer_ID;
end;
// delimiter ;


-- 4
delimiter //
create procedure deleteaccountiflowbalance(in account_id int)
begin
    declare account_balance decimal(15,2);

    select balance into account_balance
    from accounts
    where accountid = account_id;

    if account_balance < 1000000 then
        delete from accounts
        where accountid = account_id;
        select 'xoa thanh cong' as message;
    else
        select 'khong the xoa tai khoan co so du tren 1000000' as message;
    end if;
end;
// delimiter ;



-- 5
delimiter //
create procedure TransferMoney(from_account int, to_account int, inout transfer_amount decimal(10, 2))
begin
	declare is_exist bit default(0);
    declare is_more_than bit default(0);
    if (select count(AccountID) from accounts where AccountID = from_account) > 0
		and (select count(AccountID) from accounts where AccountID = to_account) > 0
		then set is_exist = 1;
	end if;
    if is_exist = 1 then
		if (select Balance from accounts where AccountID = from_account) > transfer_amount
			then set is_more_than = 1;
		end if;
	end if;
    if is_more_than = 1 then
		update accounts
        set Balance = Balance + transfer_amount where AccountID = to_account;
        update accounts
        set Balance = Balance - transfer_amount where AccountID = from_account;
	end if;
    select AccountID, Balance from accounts where AccountID = to_account or AccountID = from_account;
end 
// delimiter ;

-- 6
set @current_salary = 15000000;
call UpdateSalaryByID(3, @current_salary);
select @current_salary as new_salary;

call GetLoanAmountByCustomerID(@total_loan_amount, 1);
select @total_loan_amount;

call deleteaccountiflowbalance(1);

set @transfer_amount = 2000000;
call transfermoney(1, 3, @transfer_amount);
select @transfer_amount as final_transferred_amount;


-- 7 
drop procedure UpdateSalaryByID;
drop procedure GetLoanAmountByCustomerID;
drop procedure TransferMoney;
drop procedure DeleteAccountIfLowBalance;
