create database ss12;
use ss12;

create table tbl_users(
	user_id int auto_increment primary key,
    user_name varchar(100) not null unique,
    user_password varchar(100) not null,
    user_email varchar(100) not null unique,
    user_created date default(current_date),
	user_status enum('active', 'blocked', 'delete')
);

create table tbl_users_log(
	log_id int auto_increment primary key,
	user_name varchar(100) not null unique,
    user_password varchar(100) not null,
    user_email varchar(100) not null unique,
    user_log_created date default(current_date),
    user_action enum('deleted', 'updated', 'created')
);

-- cai dat ghi log vao bang tbl_users_log

delimiter // 
create trigger trg_after_insert 
after insert on tbl_users for each row
begin
	insert into tbl_users_log(user_name, user_password, user_email, user_action)
    values( new.user_name, new.user_password, new.user_email, 'created')
end
delimiter // ;


insert into tbl_users(user_name, user_password, user_email, user_status)
values('vuong', 'Vuong1511', 'v@gmail.com', 'active');

select * from tbl_users;


-- chan cap nhat email tren bang tbl_users

delimiter // 
create trigger trg_before_update 
before update on tbl_users for each row
begin
	declare email varchar(100);
    select new.user_email into email;
    if email <> null then
		signal sqlstate '45000'
		set message_text = 'khong the nhap email'
	end if;
end
delimiter // ;


update tbl_users
set user_status = 'blocked'
where user_id = 1;    