use ss4;

CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(255) NOT NULL,
    manager_name VARCHAR(255) NOT NULL
);

CREATE TABLE Computers (
    computer_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    cpu_speed VARCHAR(50) NOT NULL,
    ram_size VARCHAR(50) NOT NULL,
    hard_drive_size VARCHAR(50) NOT NULL,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE SET NULL
);

CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    course_duration INT NOT NULL
);

CREATE TABLE Room_Course (
    room_id INT,
    course_id INT,
    registration_date DATE NOT NULL,
    PRIMARY KEY (room_id, course_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);
