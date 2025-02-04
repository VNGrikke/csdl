create table Products(
	product_id int primary key auto_increment,
    product_name varchar(255) not null,
    price decimal(10,2) not null check(price>0),
    stock int not null check(stock>=0),
    category varchar(255)
);


INSERT INTO Products (product_name, price, stock, category)
VALUES
('iPhone 14', 999.99, 20, 'Electronics'),
('Samsung Galaxy S23', 849.99, 15, 'Electronics'),
('Sony Headphones', 199.99, 30, 'Electronics'),
('Wooden Table', 120.50, 10, 'Furniture'),
('Office Chair', 89.99, 25, 'Furniture'),
('Running Shoes', 49.99, 50, 'Sports'),
('Basketball', 29.99, 100, 'Sports'),
('T-Shirt', 19.99, 200, 'Clothing'),
('Laptop Bag', 39.99, 40, 'Accessories'),
('Desk Lamp', 25.00, 35, 'Electronics');

SELECT * FROM ss3.products;

SELECT * FROM Products WHERE category = 'Electronics' AND price > 200;

SELECT * FROM Products WHERE stock < 20;

SELECT product_name, price FROM Products WHERE category IN ('Sports', 'Accessories');

UPDATE Products SET stock = 100 WHERE product_name LIKE 'S%';

UPDATE Products SET category = 'Premium Electronics' WHERE price > 500;

DELETE FROM Products WHERE stock = 0;

DELETE FROM Products WHERE category = 'Clothing' AND price < 30;

