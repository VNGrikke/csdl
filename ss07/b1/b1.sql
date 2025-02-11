create database ss7;
use ss7;

create table Categories (
	category_id int primary key auto_increment,
    category_name varchar(255)
);

create table Books (
	book_id int primary key auto_increment,
    title varchar(255),
    author varchar(255),
    publication_year int,
    available_quantity int check(available_quantity >= 0),
    category_id int,
    foreign key (category_id) references Categories(category_id)
);


create table Readers (
	reader_id int primary key auto_increment,
    name varchar(255) not null,
    phone_number varchar(15) unique not null,
    email varchar(255) unique not null
);

create table Borrowing (
	borrow_id int primary key auto_increment,
    reader_id int,
    book_id int,
    borrow_date date,
    due_date date,
    foreign key (reader_id) references Readers(reader_id),
    foreign key (book_id) references Books(book_id)
);


create table Returning (
	return_id int primary key auto_increment,
    borrow_id int,
    return_date date,
    foreign key (borrow_id) references Borrowing(borrow_id)
);

create table Fines (
	fine_id int primary key auto_increment,
    return_id int,
    fine_amount decimal(10,2),
    foreign key (return_id) references Returning(return_id)
);


-- Thêm dữ liệu vào bảng Categories
INSERT INTO Categories (category_name) VALUES
('Fiction'),
('Science');

-- Thêm dữ liệu vào bảng Books
INSERT INTO Books (title, author, publication_year, available_quantity, category_id) VALUES
('To Kill a Mockingbird', 'Harper Lee', 1960, 5, 1),
('A Brief History of Time', 'Stephen Hawking', 1988, 3, 2);

-- Thêm dữ liệu vào bảng Readers
INSERT INTO Readers (name, phone_number, email) VALUES
('Nguyen Van A', '0123456789', 'nguyenvana@example.com'),
('Tran Thi B', '0987654321', 'tranthib@example.com');

-- Thêm dữ liệu vào bảng Borrowing
INSERT INTO Borrowing (reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, '2024-02-01', '2024-02-15'),
(2, 2, '2024-02-02', '2024-02-16');

-- Thêm dữ liệu vào bảng Returning
INSERT INTO Returning (borrow_id, return_date) VALUES
(1, '2024-02-14'),
(2, '2024-02-17');

-- Thêm dữ liệu vào bảng Fines
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 1, 0.00),  -- Không bị phạt vì trả đúng hạn
(2, 2, 5000.00); -- Bị phạt do trả trễ 1 ngày


update Readers
set name = 'nguyen Van V', phone_number = '0123987654', email = 'NguyenVanV@gmail.com'
where reader_id = 1;

delete from fines where return_id in (
	select return_id from returning where borrow_id in (
		select borrow_id from borrowing where book_id = 1
	)
);
delete from returning where borrow_id in (
	select borrow_id from borrowing where book_id = 1
);
delete from borrowing where book_id = 1;
delete from books where book_id = 1;

