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
create trigger check_stock_before_insert
before insert on order_items
for each row 
begin 
    declare stock int;
    select stock_quantity into stock 
    from inventory 
    where product_id = new.product_id;
    
    if stock < new.quantity then 
        signal sqlstate '45000' 
        set message_text = 'Không đủ hàng trong kho!';
    end if;
end;
// delimiter ;

-- delimiter //
-- // delimiter ;

-- 3
delimiter //
create trigger update_total_after_insert 
after insert on order_items 
for each row 
begin 
    update orders 
    set total_amount = total_amount + (new.price * new.quantity) 
    where order_id = new.order_id;
end;
// delimiter ;

-- 4
delimiter //
create trigger check_stock_before_update 
before update on order_items 
for each row 
begin 
    declare stock int;
    select stock_quantity into stock 
    from inventory 
    where product_id = new.product_id;
    
    if stock < new.quantity then 
        signal sqlstate '45000' 
        set message_text = 'Không đủ hàng trong kho để cập nhật số lượng!';
    end if;
end;
// delimiter ;


-- 5
delimiter //
create trigger update_total_after_update 
after update on order_items 
for each row 
begin 
    update orders 
    set total_amount = total_amount - (old.price * old.quantity) + (new.price * new.quantity) 
    where order_id = new.order_id;
end;
// delimiter ;


-- 6
delimiter //
create trigger prevent_delete_completed_order 
before delete on orders 
for each row 
begin 
    if old.status = 'Completed' then 
        signal sqlstate '45000' 
        set message_text = 'Không thể xóa đơn hàng đã thanh toán!';
    end if;
end;

// delimiter ;

-- 7
delimiter //
create trigger return_stock_after_delete 
after delete on order_items 
for each row 
begin 
    update inventory 
    set stock_quantity = stock_quantity + old.quantity 
    where product_id = old.product_id;
end;
// delimiter ;

-- 8
drop trigger if exists check_stock_before_insert;
drop trigger if exists update_total_after_insert;
drop trigger if exists check_stock_before_update;
drop trigger if exists update_total_after_update;
drop trigger if exists prevent_delete_completed_order;
drop trigger if exists return_stock_after_delete;
