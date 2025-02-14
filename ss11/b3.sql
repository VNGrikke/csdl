delimiter //
create procedure GetCustomerByPhone(in phone_number varchar(15))
begin
    select
        c.CustomerID,
        c.FullName,
        c.DateOfBirth,
        c.Address,
        c.Email
    from Customers c where c.PhoneNumber = phone_number;
end;
// delimiter ;




delimiter //
create procedure GetTotalBalance(in Customer_ID int, out total_balance decimal(15,2))
begin
    select
        sum(a.Balance) into total_balance
    from Accounts a where a.CustomerID = Customer_ID;
end;
// delimiter ;




delimiter //
create procedure IncreaseEmployeeSalary(out sal decimal(10,2), in employee_id int)
begin
    update Employees
    set Salary = Salary * 1.1
    where EmployeeID = employee_id;
    
    select Salary into sal
    from Employees
    where EmployeeID = employee_id;
end;
// delimiter ;


-- 5
call GetCustomerByPhone('0912345678');

call GetTotalBalance(1, @total_balance);
select @total_balance;

call IncreaseEmployeeSalary(@sal, 1);
select @sal as new_salary;

-- 6 
drop procedure GetTotalBalance;
drop procedure GetCustomerByPhone;
drop procedure IncreaseEmployeeSalary;