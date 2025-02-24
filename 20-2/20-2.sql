DROP DATABASE if EXISTS demo_20_2;
create database demo_20_2;
use demo_20_2;

create table Customers(
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);

create table Products(
	product_id int AUTO_INCREMENT PRIMARY KEY,
	product_name varchar(100) not null unique,
	price decimal(10,2) not null,
	quantity int not null check(quantity>=0),
	category varchar(50) not null
);

create table Employees(
    employee_id int AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    birthday DATE,
	employee_position VARCHAR(50) NOT NULL,
	salary DECIMAL(10,2) NOT NULL,
	revenue DECIMAL(10,2) DEFAULT 0
);

CREATE Table Orders(
	order_id int AUTO_INCREMENT PRIMARY KEY,
	customer_id int,
	employee_id int,
	order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	total_amount DECIMAL(10,2) DEFAULT 0,
	Foreign Key (customer_id) REFERENCES Customers(customer_id),
	Foreign Key (employee_id) REFERENCES Employees(employee_id)
);

CREATE TABLE OrderDetails(
	order_detail_id int AUTO_INCREMENT PRIMARY KEY,
	order_id INT,
	product_id INT,
	quantity INT NOT NULL CHECK(quantity > 0),
	unit_price DECIMAL(10,2) NOT NULL,
	Foreign Key (order_id) REFERENCES Orders(order_id),
	Foreign Key (product_id) REFERENCES Products(product_id)
);


-- 3
-- 3.1
ALTER TABLE Customers ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE;

-- 3.2
ALTER TABLE Employees DROP COLUMN birthday;


-- 4
INSERT INTO Customers (customer_name, email, phone, address) VALUES
('Nguyễn Văn A','A@gmail.com', '0901234567', '123 Đường ABC, Hà Nội'),
('Trần Thị B','B@gmail.com', '0912345678', '456 Đường XYZ, TP HCM'),
('Lê Văn C','C@gmail.com', '0923456789', '789 Đường DEF, Đà Nẵng'),
('Phạm Thị D','D@gmail.com', '0934567890', '111 Đường GHI, Hải Phòng'),
('Hoàng Văn E','E@gmail.com', '0945678901', '222 Đường JKL, Cần Thơ'),
('Đặng Thị F','F@gmail.com', '0956789012', '333 Đường MNO, Nha Trang'),
('Ngo Thị x','x@gmail.com', '0951782012', '333 Đường xml, tien giang');


INSERT INTO Products ( product_name, price, quantity, category) VALUES
('Sản phẩm A', 100.00, 50, 'Loại 1'),
('Sản phẩm B', 150.00, 30, 'Loại 2'),
('Sản phẩm C', 200.00, 20, 'Loại 3'),
('Sản phẩm D', 250.00, 10, 'Loại 4'),
('Sản phẩm E', 300.00, 5, 'Loại 5'),
('Sản phẩm F', 350.00, 15, 'Loại 6');

INSERT INTO Employees (employee_name, employee_position, salary, revenue) VALUES
('Nguyễn Văn G', 'Quản lý', 2000.00, 5000.00),
('Trần Thị H', 'Nhân viên bán hàng', 1500.00, 3000.00),
('Lê Văn I', 'Nhân viên kế toán', 1800.00, 4000.00),
('Phạm Thị J', 'Nhân viên kho', 1400.00, 2500.00),
('Hoàng Văn K', 'Nhân viên bảo vệ', 1200.00, 1000.00),
('Đặng Thị L', 'Nhân viên IT', 1600.00, 3500.00);

INSERT INTO Orders (customer_id, employee_id, total_amount) VALUES
(2, 1, 500.00),
(5, 2, 750.00),
(2, 3, 300.00),
(1, 4, 450.00),
(5, 5, 600.00),
(6, 6, 800.00);


INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 110, 100.00),
(2, 2, 50, 150.00),
(3, 3, 221, 200.00),
(4, 4, 96, 250.00),
(5, 5, 300, 300.00),
(6, 6, 4, 350.00);

-- 5
-- 5.1
SELECT * FROM Customers;

-- 5.2
UPDATE  Products SET product_name = 'Laptop Dell XPS', price = 99.99 WHERE product_id = 1;

-- 5.3
SELECT 
	(SELECT customer_name FROM demo_20_2.customers WHERE demo_20_2.customers.customer_id = demo_20_2.orders.customer_id ) as 'customer name',
	(SELECT employee_name FROM demo_20_2.employees WHERE demo_20_2.employees.employee_id = demo_20_2.orders.employee_id ) as 'employee name',
	order_date,
	total_amount
FROM demo_20_2.orders;



-- 6
SELECT 
	o.customer_id,
	c.customer_name,
	COUNT(o.customer_id) as 'don hang'
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY customer_id;


SELECT 
	o.employee_id,
	e.employee_name ,	
	SUM(o.total_amount) as 'doanh thu'
FROM orders o
JOIN employees e ON e.employee_id = o.employee_id 
WHERE (SELECT YEAR(order_date)) = (SELECT YEAR(CURRENT_DATE))
GROUP BY employee_id;


SELECT 
	p.product_id,
	p.product_name,
	SUM(od.quantity) AS so_luong
FROM orderdetails od
JOIN products p ON p.product_id = od.product_id
GROUP BY product_id
HAVING so_luong > 100
ORDER BY so_luong DESC;



-- 7

SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) = 0;



SELECT
	p.product_id,
	p.product_name,
	p.price
FROM products p 
WHERE p.price > (SELECT AVG(price) FROM products);


SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS tong_chi_tieu
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_amount)=(SELECT
								SUM(total_amount)
							FROM orders
							GROUP BY customer_id
							ORDER BY SUM(total_amount) 
							DESC LIMIT 1
							);

-- 8
CREATE VIEW view_order_list
AS
SELECT 
	o.order_id,
	c.customer_name,
	e.employee_name,
	o.order_date,
	o.total_amount
FROM orders o
JOIN customers c ON c.customer_id = o.order_id
JOIN employees e ON e.employee_id = o.employee_id
ORDER BY o.order_date DESC;

SELECT * FROM view_order_list;


CREATE VIEW view_order_detail_product
AS
SELECT
	od.order_detail_id,
	p.product_name,
	od.quantity,
	od.unit_price
FROM orderdetails od
JOIN products p ON p.product_id = od.product_id
ORDER BY od.quantity DESC;

SELECT * FROM view_order_detail_product;

-- 9
DELIMITER //
CREATE PROCEDURE proc_insert_employee(
    p_employee_name VARCHAR(255),
    p_employee_position VARCHAR(255),
    p_salary DECIMAL(10, 2),
    OUT p_employee_id INT
)
BEGIN
    INSERT INTO employees(employee_name, employee_position, salary)
    VALUES (p_employee_name, p_employee_position, p_salary);
    SELECT LAST_INSERT_ID() INTO p_employee_id;
END 
// DELIMITER ;
CALL proc_insert_employee('Vuong', 'sale', 5000, @p_employee_id);
SELECT @p_employee_id;



DELIMITER //
CREATE PROCEDURE proc_get_orderdetails(p_order_id int)
BEGIN
	SELECT 
		od.order_id,
		od.order_detail_id,
		p.product_name,
		od.unit_price,
		od.quantity
	FROM orderdetails od
	JOIN products p ON p.product_id = od.product_id
	WHERE od.order_id = p_order_id;
END;
// DELIMITER ;
CALL proc_get_orderdetails(1);


DELIMITER //
CREATE PROCEDURE proc_cal_total_amount_by_order(p_order_id INT, OUT total INT)
BEGIN
    SELECT COUNT(DISTINCT product_id) INTO total
    FROM orderdetails
    WHERE order_id = p_order_id;
END 
// DELIMITER ;
CALL proc_cal_total_amount_by_order(1, @total);
SELECT @total;



-- 10

DELIMITER //
CREATE TRIGGER trigger_after_insert_order_details
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE product_qty INT;
    DECLARE out_of_stock CONDITION FOR SQLSTATE '45000';
    SELECT quantity INTO product_qty
    FROM Products
    WHERE product_id = NEW.product_id;
    IF product_qty < NEW.quantity THEN
        SIGNAL out_of_stock SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        UPDATE Products
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END 
// DELIMITER ;
INSERT INTO Products (product_name, price, quantity, category) VALUES ('Product l', 100, 50, 'Category 1');
INSERT INTO Orders (customer_id, employee_id) VALUES (1, 1);
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES (1, 1, 60, 100);



-- 11
DELIMITER //
CREATE PROCEDURE proc_insert_order_details(
    p_order_id INT,
    p_product_id INT,
    p_quantity INT,
    p_unit_price DECIMAL(10, 2),
    OUT p_total_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE total_amount DECIMAL(10, 2);
    DECLARE order_exists INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION

    START TRANSACTION;

    SELECT COUNT(*) INTO order_exists
    FROM Orders
    WHERE order_id = p_order_id;

    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không tồn tại mã hóa đơn';
		ROLLBACK;
    END IF;

    INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price)
    VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);

    SELECT SUM(quantity * unit_price) INTO total_amount
    FROM OrderDetails
    WHERE order_id = p_order_id;

    UPDATE Orders
    SET total_amount = total_amount + total_amount
    WHERE order_id = p_order_id;

    SET p_total_amount = total_amount;
    COMMIT;
END 
// DELIMITER ;


CALL proc_insert_order_details(1, 1, 10, 100, @total_amount);
SELECT @total_amount