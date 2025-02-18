use session_11;
select * from accounts;
/*
	xay dung procedure tranfermoney
    input: acc_sender, acc_reciever, money
	process: - kiem tra tai khoan gui, nhan
			 - kiem tra so du
             - tru tai khoan gui
             - cong tai khoan nhan
    output: result_code
			- sai tai khoan
            - so du khong du
            - chuyen khoan thanh cong
            
*/


DELIMITER &&
drop procedure if exists pro_tranfer;
set autocommit = 0;
create procedure pro_tranfer(
	acc_sender int, 
    acc_receive int, 
    money decimal(10, 2), 
    out result_code int
)
begin
	start transaction;
    -- 1. Ktra tk gửi, nhận
    if(select count(accountid) from accounts where AccountID = acc_sender) = 0
		or (select count(accountid) from accounts where AccountID = acc_receive) = 0 then
			set result_code = 1;
            rollback;
	else
		-- 2. Trừ tiền tk gửi
        update accounts
			set balance = balance - money
            where accountid = acc_sender;
		-- 3. Ktra số dư tk gửi
        if(select balance from accounts where AccountID = acc_sender) < money then
			set result_code = 2;
            rollback;
		else
			-- 4. Cộng tiền tk nhận
            update accounts
				set balance = balance + money
                where accountid = acc_receive;
		end if;
    end if;
end &&
DELIMITER ;

call pro_tranfer(1, 2, 200000, @result_code);
select @result_code;