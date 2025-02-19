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
create procedure sp_create_order(
    in p_customer_id int,
    in p_product_id int,
    in p_quantity int,
    in p_price decimal(10,2)
)
begin
    declare v_stock int;
    declare v_order_id int;

    start transaction;

    select stock_quantity into v_stock_quantity
    from inventory
    where product_id = p_product_id;

    if v_stock_quantity < p_quantity then
        rollback;
        signal sqlstate '45000' set message_text = 'không đủ hàng trong kho!';
    else
        insert into orders (customer_id, order_date, total_amount, status)
        values (p_customer_id, now(), 0, 'pending');
        set v_order_id = last_insert_id();

        insert into order_items (order_id, product_id, quantity, price)
        values (v_order_id, p_product_id, p_quantity, p_price);

        update inventory
        set stock_quantity = stock_quantity - p_quantity
        where product_id = p_product_id;

        update orders
        set total_amount = p_quantity * p_price
        where order_id = v_order_id;

        commit;
    end if;
end //
delimiter ;


-- 3

delimiter //
create procedure sp_process_payment(
    in p_order_id int,
    in p_payment_method varchar(20)
)
begin
    declare v_total_amount decimal(10,2);
    declare v_status enum('pending', 'completed', 'cancelled');

    start transaction;

    select total_amount, status into v_total_amount, v_status
    from orders
    where order_id = p_order_id;

    if v_status != 'pending' then
        rollback;
        signal sqlstate '45000' set message_text = 'chỉ có thể thanh toán đơn hàng ở trạng thái pending!';
    else
        insert into payments (order_id, payment_date, amount, payment_method, status)
        values (p_order_id, now(), v_total_amount, p_payment_method, 'completed');

        update orders
        set status = 'completed'
        where order_id = p_order_id;

        commit;
    end if;
end ;
// delimiter ;

-- 4
delimiter //
create procedure sp_cancel_order(
    in p_order_id int
)
begin
    declare v_status enum('pending', 'completed', 'cancelled');

    start transaction;
    select status into v_status
    from orders
    where order_id = p_order_id;

    if v_status != 'pending' then
        rollback;
        signal sqlstate '45000' set message_text = 'chỉ có thể hủy đơn hàng ở trạng thái pending!';
    else
        update inventory i
        join order_items oi on i.product_id = oi.product_id
        set i.stock_quantity = i.stock_quantity + oi.quantity
        where oi.order_id = p_order_id;

        delete from order_items
        where order_id = p_order_id;

        update orders
        set status = 'cancelled'
        where order_id = p_order_id;

        commit;
    end if;
end ;
// delimiter ;

-- 5
drop procedure if exists sp_create_order;
drop procedure if exists sp_process_payment;
drop procedure if exists sp_cancel_order;

