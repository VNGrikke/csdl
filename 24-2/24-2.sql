CREATE DATABASE 24_2;
USE 24_2;

CREATE TABLE Student (
    student_id CHAR(5) PRIMARY KEY,
    student_full_name VARCHAR(150) NOT NULL,
    student_email VARCHAR(255) UNIQUE NOT NULL,
    student_bod DATE NOT NULL,
    student_rank ENUM('Yếu', 'Trung Bình', 'Khá', 'Giỏi', 'Xuất sắc') NOT NULL,
    student_status ENUM('Đang học', 'Đã tốt nghiệp', 'Đình chỉ', 'Bảo lưu') DEFAULT 'Đang học'
);


CREATE TABLE Subject (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(200) UNIQUE NOT NULL,
    subject_credit INT NOT NULL,
    subject_status ENUM('Đang hoạt động', 'Không hoạt động') NOT NULL
);

CREATE TABLE Enrollment (
    enroll_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id CHAR(5) NOT NULL,
    subject_id INT NOT NULL,
    enroll_date DATE DEFAULT(CURRENT_DATE),
    registration_number INT DEFAULT 1,
    enroll_grade FLOAT,
    enroll_completion_date DATE,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

CREATE TABLE Grade (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enroll_id INT NOT NULL,
    grade_score FLOAT NOT NULL,
    grade_date DATE NOT NULL,
    FOREIGN KEY (enroll_id) REFERENCES Enrollment(enroll_id)
);



-- phan 2
-- 2
ALTER TABLE Grade ADD grade_type ENUM('mid', 'final', 'attendance');

-- 3
ALTER TABLE Student ADD student_phone CHAR(10) NOT NULL UNIQUE;

-- 4
ALTER TABLE Grade
ADD CONSTRAINT check_grade_score CHECK (grade_score >= 0 AND grade_score <= 100);


-- phan 3
INSERT INTO Student (student_id, student_full_name, student_email, student_bod, student_rank, student_status, student_phone)
VALUES
('S001', 'Nguyễn Minh An', 'nguyenminhan@example.com', '1998-10-12', 'Giỏi', 'Đang học', '0901122334'),
('S002', 'Trần Thị Hoa', 'tranthihoa@example.com', '1999-07-23', 'Khá', 'Đang học', '0912233445'),
('S003', 'Lê Văn Tuấn', 'levantuan@example.com', '2000-05-17', 'Xuất sắc', 'Đã tốt nghiệp', '0923344556'),
('S004', 'Phan Mai Linh', 'phanmailinh@example.com', '2001-01-04', 'Trung Bình', 'Đang học', '0934455667'),
('S005', 'Hoàng Thị Lan', 'hoangthilan@example.com', '1998-03-09', 'Yếu', 'Đang học', '0945566778'),
('S006', 'Nguyễn Thanh Tú', 'nguyenthantutu@example.com', '2000-11-25', 'Giỏi', 'Đang học', '0956677889'),
('S007', 'Vũ Quang Huy', 'vuquanghuy@example.com', '1997-02-12', 'Giỏi', 'Đã tốt nghiệp', '0967788990'),
('S008', 'Phạm Ngọc Minh', 'phamngocminh@example.com', '2001-08-30', 'Trung Bình', 'Đang học', '0978899001'),
('S009', 'Lê Thi Mai', 'lethimai@example.com', '1999-04-22', 'Khá', 'Đang học', '0989900112'),
('S010', 'Đặng Thi Hoàng', 'dangthihuong@example.com', '2000-06-18', 'Xuất sắc', 'Đang học', '0991001223');

INSERT INTO Subject (subject_name, subject_credit, subject_status)
VALUES
('Lập trình Scratch', 2, 'Đang hoạt động'),
('Lập trình C', 4, 'Đang hoạt động'),
('Frontend Fundamental', 5, 'Đang hoạt động'),
('ReactJS', 3, 'Không hoạt động'),
('Database', 4, 'Đang hoạt động');

INSERT INTO Enrollment (student_id, subject_id, enroll_date, registration_number, enroll_grade, enroll_completion_date)
VALUES
('S001', 1, '2025-01-15', 1, 45, NULL),
('S001', 1, '2025-02-01', 2, NULL, NULL),
('S002', 2, '2025-01-10', 1, 70, '2025-01-20'),
('S003', 3, '2025-01-20', 1, 30, NULL),
('S003', 3, '2025-02-05', 2, NULL, NULL),
('S004', 4, '2025-01-12', 1, 48, NULL),
('S004', 4, '2025-02-10', 2, NULL, NULL),
('S005', 5, '2025-01-15', 1, 80, '2025-01-25'),
('S006', 2, '2025-01-18', 1, 45, NULL),
('S006', 2, '2025-02-20', 2, NULL, NULL);

INSERT INTO Grade (enroll_id, grade_score, grade_date, grade_type)
VALUES
(1, 40, '2025-01-10', 'attendance'),
(1, 45, '2025-01-12', 'mid'),
(1, 50, '2025-01-14', 'final'),
(2, 55, '2025-02-02', 'attendance'),
(2, 60, '2025-02-04', 'mid'),
(2, 65, '2025-02-06', 'final'),
(3, 25, '2025-01-18', 'attendance'),
(3, 30, '2025-01-20', 'mid'),
(3, 35, '2025-01-22', 'final'),
(5, 50, '2025-02-07', 'attendance'),
(5, 55, '2025-02-09', 'mid'),
(5, 60, '2025-02-11', 'final'),
(6, 30, '2025-01-19', 'attendance'),
(6, 45, '2025-01-22', 'mid'),
(6, 50, '2025-01-23', 'final'),
(7, 60, '2025-01-15', 'attendance'),
(7, 70, '2025-01-17', 'mid'),
(7, 80, '2025-01-20', 'final'),
(2, 50, '2025-02-21', 'attendance'),
(2, 55, '2025-02-22', 'mid'),
(2, 60, '2025-02-23', 'final'),
(9, 55, '2025-02-21', 'attendance'),
(9, 60, '2025-02-22', 'mid'),
(9, 65, '2025-02-23', 'final');


-- 2
UPDATE Enrollment e
JOIN (
    SELECT enroll_id, 
           AVG(CASE WHEN grade_type IN ('mid', 'final', 'attendance') THEN grade_score END) AS average_grade
    FROM Grade
    GROUP BY enroll_id
) g ON e.enroll_id = g.enroll_id
SET e.enroll_grade = g.average_grade,
    e.enroll_completion_date = CASE WHEN g.average_grade >= 50 THEN CURRENT_DATE ELSE e.enroll_completion_date END;


-- 3
DELETE g
FROM Grade g
JOIN (
    SELECT enroll_id
    FROM Grade
    WHERE grade_type IN ('mid', 'final', 'attendance')
    GROUP BY enroll_id
    HAVING COUNT(grade_type) < 3
) incomplete_grades ON g.enroll_id = incomplete_grades.enroll_id;

SELECT * FROM Grade;

-- phan 4
-- 1
SELECT student_id, student_full_name, student_email, student_bod, student_rank, student_status
FROM Student
ORDER BY student_full_name ASC;

-- 2
SELECT subject_id, subject_name, subject_credit
FROM Subject
ORDER BY subject_credit DESC;

-- 3
SELECT s.student_id, s.student_full_name, sub.subject_name, e.enroll_grade
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Subject sub ON e.subject_id = sub.subject_id
WHERE e.enroll_grade < 50 AND e.enroll_completion_date IS NULL;


-- 4
SELECT e.enroll_id, e.student_id, e.subject_id, e.enroll_grade
FROM Enrollment e
JOIN Subject sub ON e.subject_id = sub.subject_id
WHERE sub.subject_name = 'Lập trình C'
ORDER BY e.enroll_grade DESC;

-- 5
SELECT student_id, student_full_name, student_email, student_bod, student_rank, student_status
FROM Student
ORDER BY student_rank
LIMIT 1 OFFSET 1;


-- 6
SELECT e.student_id, s.student_full_name, COUNT(e.subject_id) AS number_of_subjects
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
WHERE e.enroll_grade > 50
GROUP BY e.student_id, s.student_full_name
HAVING COUNT(e.subject_id) >= 2;


-- 7 
SELECT s.student_id, s.student_full_name, sub.subject_name, AVG(g.grade_score) AS average_grade
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Subject sub ON e.subject_id = sub.subject_id
JOIN Grade g ON e.enroll_id = g.enroll_id
GROUP BY s.student_id, s.student_full_name, sub.subject_name
HAVING AVG(g.grade_score) < 50 AND COUNT(e.student_id) >= 3;


-- 8
SELECT s.student_id, s.student_full_name, e.subject_id, AVG(e.enroll_grade) AS average_grade
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
GROUP BY s.student_id, s.student_full_name, e.subject_id
HAVING AVG(e.enroll_grade) > 70;


-- 9
SELECT sub.subject_id, sub.subject_name, COUNT(e.student_id) AS number_of_students
FROM Subject sub
JOIN Enrollment e ON sub.subject_id = e.subject_id
GROUP BY sub.subject_id, sub.subject_name
ORDER BY number_of_students DESC;


-- 10
SELECT s.student_id, s.student_full_name, sub.subject_name, e.enroll_grade
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Subject sub ON e.subject_id = sub.subject_id
WHERE e.enroll_grade > (
    SELECT AVG(enroll_grade)
    FROM Enrollment
    WHERE subject_id = e.subject_id
);


-- phan 5

-- 1
DELIMITER //
CREATE PROCEDURE AddNewStudent(
    IN p_student_id CHAR(5),
    IN p_student_full_name VARCHAR(150),
    IN p_student_email VARCHAR(255),
    IN p_student_bod DATE,
    IN p_student_status ENUM('Đang học', 'Đã tốt nghiệp', 'Đình chỉ', 'Bảo lưu'),
    IN p_student_phone CHAR(10)
)
BEGIN
    INSERT INTO Student (student_id, student_full_name, student_email, student_bod, student_status, student_phone)
    VALUES (p_student_id, p_student_full_name, p_student_email, p_student_bod, p_student_status, p_student_phone);
END 
// DELIMITER ;

CALL AddNewStudent('S027', 'Nguyen Van Vuong', 'V@gmail.com', '2005-11-15', 'Đang học', '0987654321');

-- 2
DELIMITER //
CREATE PROCEDURE UpdateAllStudentRanks()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE student_id CHAR(5);
    DECLARE avg_grade FLOAT;
    DECLARE student_cursor CURSOR FOR SELECT student_id FROM Student;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN student_cursor;

    read_loop: LOOP
        FETCH student_cursor INTO student_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT AVG(enroll_grade) INTO avg_grade
        FROM Enrollment
        WHERE student_id = student_id;

        UPDATE Student
        SET student_rank = 
            CASE 
                WHEN avg_grade <  50 THEN 'Yếu'
                WHEN avg_grade <  70 THEN 'Trung Bình'
                WHEN avg_grade <  80 THEN 'Khá'
                WHEN avg_grade <  90 THEN 'Giỏi'
                WHEN avg_grade <  100 THEN 'Xuất sắc'
            END
        WHERE student_id = student_id;
    END LOOP;

    CLOSE student_cursor;
END 
// DELIMITER ;


CALL UpdateAllStudentRanks();
SELECT * FROM Student;