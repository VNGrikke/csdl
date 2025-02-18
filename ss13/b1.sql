create table accounts (
    account_id int primary key auto_increment,
    account_name varchar(50),
    balance decimal
);

insert into accounts (account_name, balance) values 
('nguyễn văn an', 1000.00),
('trần thị bảy', 500.00);

delimiter //
set autocommit = 0;
create procedure transfermoney(from_account int, to_account int, amount decimal)
begin
    declare sender_balance decimal;
    start transaction;
    
    if (select count(account_id) from accounts where account_id = from_account) = 0 
       or (select count(account_id) from accounts where account_id = to_account) = 0 then
        rollback;
    else
        select balance into sender_balance from accounts where account_id = from_account;
        if sender_balance < amount then
            rollback;
        else
            update accounts set balance = balance - amount where account_id = from_account;
            update accounts set balance = balance + amount where account_id = to_account;
            commit;
        end if;
    end if;
end
// delimiter ;

call transfermoney(1, 2, 200);
select * from accounts;
