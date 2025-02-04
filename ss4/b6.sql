CREATE TABLE Department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    address VARCHAR(50) NOT NULL
);

ALTER TABLE Employee 
ADD COLUMN department_id INT NOT NULL,
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (department_id) REFERENCES Department(department_id);

INSERT INTO Department (department_name, address) VALUES
('Phòng Kế Toán', 'Tầng 1, Tòa Nhà A'),
('Phòng Nhân Sự', 'Tầng 2, Tòa Nhà A'),
('Phòng IT', 'Tầng 3, Tòa Nhà A'),
('Phòng Marketing', 'Tầng 4, Tòa Nhà B'),
('Phòng Kinh Doanh', 'Tầng 5, Tòa Nhà B');


INSERT INTO Employee (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number, department_id) VALUES
('E001', 'Nguyễn Minh Nhật', '2004-12-11', 1, 4000000, '0987836473', 1),
('E002', 'Đỗ Đức Long', '2004-01-12', 1, 3500000, '0982378673', 2),
('E003', 'Mai Tiến Linh', '2004-02-03', 1, 3500000, '0976734562', 3),
('E004', 'Nguyễn Ngọc Ánh', '2003-10-04', 0, 5000000, '0987352772', 4),
('E005', 'Phạm Minh Sơn', '2003-03-12', 1, 4000000, '0987236568', 5),
('E006', 'Nguyễn Ngọc Minh', '2003-11-11', 0, 5000000, '0928864736', 1),
('E007', 'Trần Hữu Phúc', '2005-06-15', 1, 4500000, '0978451236', 2),
('E008', 'Lê Thị Thu', '2002-09-24', 0, 4800000, '0912367845', 3),
('E009', 'Vũ Anh Tuấn', '2001-08-18', 1, 5200000, '0964785123', 4),
('E010', 'Bùi Minh Hoàng', '2000-05-30', 1, 5500000, '0934785123', 5);

-- cach 1
ALTER TABLE Employee DROP FOREIGN KEY fk_employee_department;
DELETE FROM Department WHERE department_id = 1;

-- cach 2
ALTER TABLE Employee DROP FOREIGN KEY fk_employee_department;
ALTER TABLE Employee ADD CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE CASCADE;
DELETE FROM Department WHERE department_id = 1;


UPDATE Department SET department_name = 'Phòng Tài Chính' WHERE department_id = 1;

SELECT * FROM Employee;
SELECT * FROM Department;




