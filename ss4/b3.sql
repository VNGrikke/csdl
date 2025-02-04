CREATE TABLE Customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL,
    sex BIT NOT NULL,
	job VARCHAR(50) ,
    phone_number CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
	address VARCHAR(255) NOT NULL
);

INSERT INTO Customers (customer_name, birthday, sex, job, phone_number, email, address) 
VALUES
('Trần Văn A', '1998-05-15', 1, 'Kỹ sư', '0987654321', 'tranvana@gmail.com', 'Hà Nội'),
('Nguyễn Thị B', '2001-09-20', 0, 'Giáo viên', '0978123456', 'nguyenthb@yahoo.com', 'TP.HCM'),
('Lê Văn C', '2003-12-10', 1, 'Bác sĩ', '0968456789', 'levanc@gmail.com', 'Đà Nẵng'),
('Phạm Thị D', '1995-07-05', 0, 'Kế toán', '0954671234', 'phamthid@gmail.com', 'Hải Phòng'),
('Hoàng Văn E', '2000-03-22', 1, 'Lập trình viên', '0945789123', 'hoangvane@outlook.com', 'Cần Thơ'),
('Võ Thị F', '1997-08-08', 0, 'Nhân viên bán hàng', '0934567891', 'vothif@gmail.com', 'Bắc Ninh'),
('Đỗ Văn G', '2002-10-17', 1, NULL, '0923456789', 'dovang@gmail.com', 'Nghệ An'),
('Trương Thị H', '1999-06-25', 0, 'Luật sư', '0912345678', 'truongthh@hotmail.com', 'Bình Dương'),
('Bùi Văn I', '2004-02-13', 1, NULL, '0909876543', 'buivani@gmail.com', 'Thanh Hóa'),
('Ngô Thị K', '1996-08-30', 0, 'Nhà báo', '0898765432', 'ngothik@gmail.com', 'Hà Nam');

UPDATE Customers SET customer_name = 'Nguyễn Quang Nhật', birthday = '2004-01-11' WHERE customer_id = 1;

DELETE FROM Customers WHERE MONTH(birthday) = 8;

SELECT customer_id, customer_name, birthday, 
       CASE 
           WHEN sex = 1 THEN 'Nam' 
           ELSE 'Nữ' 
       END AS gender, phone_number
FROM Customers
WHERE birthday > '2000-01-01';

SELECT * FROM Customers WHERE job IS NULL;


