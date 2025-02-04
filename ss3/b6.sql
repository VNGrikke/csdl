create table Books(
	book_id int primary key auto_increment,
    title varchar(255) not null,
	price decimal(10,2) null,
    stock int not null
);

INSERT INTO Books (title, price, stock)
VALUES
('To Kill a Mockingbird', 120.00, 10),

('1984', 90.00, 3),

('The Great Gatsby', 150.00, 20),

('Moby Dick', 200.00, 5),

('Pride and Prejudice', 50.00, 8);

select * from books where price > 100;

set SQL_SAFE_UPDATES = 0;

delete from books where title like ('Pride%');

set SQL_SAFE_UPDATES = 1;

select * from books;

drop table books;