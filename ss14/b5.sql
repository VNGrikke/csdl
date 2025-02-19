CREATE DATABASE ss14_first;

USE ss14_first;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);


-- 2
delimiter //
create trigger before_insert_check_payment
before insert on payments
for each row
begin
    declare v_total_amount decimal(10,2);
    select total_amount into v_total_amount
    from orders
    where order_id = new.order_id;
    if new.amount < v_total_amount then
        signal sqlstate '45000' set message_text = 'Số tiền thanh toán không khớp với tổng đơn hàng!';
    end if;
end //
delimiter ;

-- 3
create table order_logs (
    log_id int primary key auto_increment,
    order_id int not null,
    old_status enum('Pending', 'Completed', 'Cancelled'),
    new_status enum('Pending', 'Completed', 'Cancelled'),
    log_date timestamp default current_timestamp,
    foreign key (order_id) references orders(order_id) on delete cascade
);

-- 4
delimiter //
create trigger after_update_order_status
after update on orders
for each row
begin
    if old.status != new.status then
        insert into order_logs (order_id, old_status, new_status, log_date)
        values (new.order_id, old.status, new.status, now());
    end if;
end //
delimiter ;

-- 5
delimiter //
create procedure sp_update_order_status_with_payment(
    in p_order_id int,
    in p_new_status enum('Pending', 'Completed', 'Cancelled'),
    in p_payment_method varchar(20),
    in p_amount decimal(10,2)
)
begin
    declare v_current_status enum('Pending', 'Completed', 'Cancelled');
    declare v_total_amount decimal(10,2);

    start transaction;
    select status, total_amount into v_current_status, v_total_amount
    from orders
    where order_id = p_order_id;

    if v_current_status = p_new_status then
        rollback;
        signal sqlstate '45000' set message_text = 'Đơn hàng đã có trạng thái này!';
    end if;

    if p_new_status = 'Completed' then
        insert into payments (order_id, payment_date, amount, payment_method, status)
        values (p_order_id, now(), p_amount, p_payment_method, 'Completed');
    end if;

    update orders
    set status = p_new_status
    where order_id = p_order_id;
    commit;
end //
delimiter ;

-- 6
insert into customers (name, email, phone, address)
values ('Nguyen Van A', 'nguyenvana@example.com', '0123456789', 'Hanoi');

select customer_id from customers where email = 'nguyenvana@example.com';

insert into orders (customer_id, order_date, total_amount, status)
values (1, now(), 200.00, 'Pending');

insert into products (name, price, description)
values ('Product A', 50.00, 'Description of Product A');

select product_id from products where name = 'Product A';

insert into inventory (product_id, stock_quantity)
values (1, 100);

insert into order_items (order_id, product_id, quantity, price)
values (1, 1, 4, 50.00);

call sp_update_order_status_with_payment(1, 'Completed', 'Credit Card', 200.00);

-- 7
select * from order_logs;

-- 8 
drop trigger if exists before_insert_check_payment;
drop trigger if exists after_update_order_status;
drop procedure if exists sp_create_order;
drop procedure if exists sp_process_payment;
drop procedure if exists sp_cancel_order;
drop procedure if exists sp_update_order_status_with_payment;
