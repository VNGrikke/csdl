create table departments (
    department_id int primary key,
    department_name varchar(255),
    location varchar(255)
);

create table employees (
    employee_id int primary key,
    name varchar(255),
    dob date,
    department_id int,
    salary decimal(10,2),
    foreign key (department_id) references departments(department_id) on delete set null
);

create table projects (
    project_id int primary key,
    project_name varchar(255),
    start_date date,
    end_date date
);

create table timesheets (
    timesheet_id int primary key,
    employee_id int,
    project_id int,
    work_date date,
    hours_worked decimal(5,2),
    foreign key (employee_id) references employees(employee_id) on delete cascade,
    foreign key (project_id) references projects(project_id) on delete cascade
);

create table workreports (
    report_id int primary key,
    employee_id int,
    report_date date,
    report_content text,
    foreign key (employee_id) references employees(employee_id) on delete cascade
);


-- thêm dữ liệu vào bảng departments
insert into departments values (1, 'phòng it', 'hà nội'), (2, 'phòng kinh doanh', 'tp hcm');

-- thêm dữ liệu vào bảng employees
insert into employees values (1, 'nguyễn văn a', '1990-05-20', 1, 1500.00), 
                             (2, 'trần thị b', '1992-08-15', 2, 1800.00);

-- thêm dữ liệu vào bảng projects
insert into projects values (1, 'dự án x', '2024-01-01', '2024-06-30'), 
                            (2, 'dự án y', '2024-02-15', '2024-08-20');

-- thêm dữ liệu vào bảng timesheets
insert into timesheets values (1, 1, 1, '2024-02-10', 8.5), 
                              (2, 2, 2, '2024-02-11', 7.0);

-- thêm dữ liệu vào bảng workreports
insert into workreports values (1, 1, '2024-02-10', 'hoàn thành module a'), 
                               (2, 2, '2024-02-11', 'nghiên cứu tài liệu dự án');



update projects 
set project_name = 'dự án x - giai đoạn 2' 
where project_id = 1;


delete from employees where employee_id = 2;
