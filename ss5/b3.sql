-- Tạo bảng customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY, -- Khóa chính
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255)
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY, -- Khóa chính
    customer_id INT, -- Khóa ngoại
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) -- Liên kết với bảng customers
);

-- Thêm bản ghi vào bảng customers
INSERT INTO customers (name, email, phone, address)
VALUES
('Nguyen Van An', 'nguyenvanan@example.com', '0901234567', '123 Le Loi, TP.HCM'),
('Tran Thi Bich', 'tranthibich@example.com', '0912345678', '456 Nguyen Hue, TP.HCM'),
('Le Van Cuong', 'levancuong@example.com', '0923456789', '789 Dien Bien Phu, Ha Noi');

-- Thêm bản ghi vào bảng orders
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES
(1, '2025-01-10', 500000, 'Pending'),
(1, '2025-01-12', 325000, 'Completed'),
(NULL, '2025-01-13', 450000, 'Cancelled'),
(3, '2025-01-14', 270000, 'Pending'),
(2, '2025-01-16', 850000, NULL);



select 
    c.name, 
    c.phone, 
    o.order_id, 
    o.total_amount
from customers c
join orders o on c.customer_id = o.customer_id
where o.status = 'Pending' and o.total_amount > 300000;


select 
    c.name, 
    c.email, 
    o.order_id
from customers c
join orders o on c.customer_id = o.customer_id
where o.status = 'Completed' or o.status is null;

select 
    c.name, 
    c.address, 
    o.order_id, 
    o.status
from customers c
join orders o on c.customer_id = o.customer_id
where o.status = 'Pending' or o.status = 'Cancelled';


select 
    c.name, 
    c.phone, 
    o.order_id, 
    o.total_amount
from customers c
join orders o on c.customer_id = o.customer_id
where o.total_amount between 300000 and 600000;
