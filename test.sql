create database hackathon;
use hackathon;

create table tbl_users(
    user_id int auto_increment primary key,
    user_name varchar(50) not null unique,
    user_fullname varchar(100) not null,
    email varchar(100) not null unique,
    user_address text,
    user_phone varchar(20) not null unique
);

create table tbl_employees(
    emp_id char(5) primary key,
    user_id int,
    emp_position varchar(50),
    emp_hire_date date,
    salary decimal(10,2) not null check(salary>0),
    emp_status enum('dang lam', 'dang nghi') default('dang lam'),
    foreign key(user_id) references tbl_users(user_id)
);

create table tbl_orders(
    order_id int auto_increment primary key,
    user_id int,
    order_date date,
    order_tatal_amount decimal(10,2),
    foreign key(user_id) references tbl_users(user_id)
);

create table tbl_products(
    pro_id char(5) primary key,
    pro_name varchar(100) unique not null,
    pro_price decimal(10,2) not null check(pro_price>0),
    pro_quantity int not null check(pro_quantity>=0),
    pro_status enum('con hang', 'het hang') default('con hang')
);

create table tbl_order_detail(
    order_detail_id int auto_increment primary key,
    order_id int,
    pro_id char(5),
    order_detail_quantity int check(order_detail_quantity > 0),
    order_detail_price decimal(10,2),
    foreign key(order_id) references tbl_orders(order_id),
    foreign key(pro_id) references tbl_products(pro_id)
);

alter table tbl_orders
add column orders_status enum('pending', 'processing', 'completed', 'cancelled');

alter table tbl_users
modify column user_phone varchar(11);

insert into tbl_users (user_name, user_fullname, email, user_address, user_phone)
values 
('johndoe', 'john doe', 'johndoe@example.com', '123 main st', '01234567890'),
('janedoe', 'jane doe', 'janedoe@example.com', '456 oak st', '09876543210'),
('bobsmith', 'bob smith', 'bobsmith@example.com', '789 pine st', '02345678901'),
('alicesmith', 'alice smith', 'alicesmith@example.com', '321 elm st', '07891234567'),
('michaeljohnson', 'michael johnson', 'michaeljohnson@example.com', '654 willow ave', '04321098765'),
('emilydavis', 'emily davis', 'emilydavis@example.com', '987 birch rd', '03219876543'),
('davidmartin', 'david martin', 'davidmartin@example.com', '111 maple st', '05432987651'),
('sarahlee', 'sarah lee', 'sarahlee@example.com', '222 cedar blvd', '06754321987'),
('chrisbrown', 'chris brown', 'chrisbrown@example.com', '333 walnut st', '09871234567'),
('angelawhite', 'angela white', 'angelawhite@example.com', '444 poplar st', '07654329871');


insert into tbl_employees (emp_id, user_id, emp_position, emp_hire_date, salary, emp_status)
values 
('e001', 1, 'manager', '2023-01-01', 5000.00, 'dang lam'),
('e002', 2, 'sales', '2023-02-01', 3000.00, 'dang lam'),
('e003', 3, 'it', '2023-03-01', 4000.00, 'dang lam'),
('e004', 4, 'hr', '2023-04-01', 3500.00, 'dang lam'),
('e005', 5, 'accounting', '2023-05-01', 4500.00, 'dang lam'),
('e006', 6, 'marketing', '2023-06-01', 3200.00, 'dang lam'),
('e007', 7, 'support', '2023-07-01', 2800.00, 'dang lam'),
('e008', 8, 'logistics', '2023-08-01', 3700.00, 'dang lam'),
('e009', 9, 'design', '2023-09-01', 4200.00, 'dang lam'),
('e010', 10, 'development', '2023-10-01', 4900.00, 'dang lam');


insert into tbl_orders (user_id, order_date, order_tatal_amount, orders_status)
values 
(1, '2025-02-20', 185.00, 'pending'),
(2, '2025-02-21', 235.00, 'processing'),
(3, '2025-02-22', 285.00, 'completed'),
(4, '2025-02-23', 135.00, 'cancelled'),
(5, '2025-02-24', 190.00, 'pending'),
(6, '2025-02-25', 240.00, 'processing'),
(7, '2025-02-26', 290.00, 'completed'),
(8, '2025-02-27', 140.00, 'cancelled'),
(9, '2025-02-28', 195.00, 'pending'),
(10, '2025-03-01', 245.00, 'processing'),
(1, '2025-03-02', 255.00, 'completed'),
(2, '2025-03-03', 145.00, 'cancelled'),
(3, '2025-03-04', 160.00, 'pending'),
(4, '2025-03-05', 220.00, 'processing'),
(5, '2025-03-06', 280.00, 'completed');



insert into tbl_products (pro_id, pro_name, pro_price, pro_quantity, pro_status)
values 
('p001', 'product a', 50.00, 10, 'con hang'),
('p002', 'product b', 30.00, 20, 'con hang'),
('p003', 'product c', 20.00, 15, 'con hang'),
('p004', 'product d', 25.00, 5, 'con hang'),
('p005', 'product e', 60.00, 8, 'con hang'),
('p006', 'product f', 45.00, 12, 'con hang'),
('p007', 'product g', 35.00, 7, 'con hang'),
('p008', 'product h', 55.00, 9, 'con hang'),
('p009', 'product i', 40.00, 11, 'con hang'),
('p010', 'product j', 50.00, 10, 'con hang');



insert into tbl_order_detail (order_id, pro_id, order_detail_quantity, order_detail_price)
values 
(1, 'p001', 2, 50.00),
(2, 'p002', 3, 30.00),
(3, 'p003', 1, 20.00),
(4, 'p004', 2, 25.00),
(5, 'p005', 1, 60.00),
(6, 'p006', 2, 45.00),
(7, 'p007', 3, 35.00),
(8, 'p008', 4, 55.00),
(9, 'p009', 2, 40.00),
(10, 'p010', 3, 50.00);



-- 4
select 
	order_id,
    order_date,
    order_tatal_amount,
    orders_status
from tbl_orders;


select distinct u.user_fullname
from tbl_orders o
join tbl_users u on o.user_id = u.user_id;


-- 5
select 
	p.pro_name,
    sum(od.order_detail_quantity) as quantity
from tbl_order_detail od
join tbl_products p on p.pro_id = od.pro_id
group by p.pro_name;

select 
	p.pro_name,
    sum(od.order_detail_quantity * od.order_detail_price) as revenue
from tbl_order_detail od
join tbl_products p on p.pro_id = od.pro_id
group by p.pro_name
order by revenue desc;

-- 6
select
	u.user_name,
    count(o.user_id) as amount
from tbl_orders o
join tbl_users u on u.user_id = o.user_id
group by user_name;
 
 
select
	u.user_name,
    count(o.user_id) as amount
from tbl_orders o
join tbl_users u on u.user_id = o.user_id
group by user_name
having amount >=2;

-- 7
select 
	u.user_name,
    sum(o.order_tatal_amount) as spend
from tbl_orders o
join tbl_users u on u.user_id = o.user_id
group by u.user_id
order by spend desc
limit 5;

-- 8


-- 9




