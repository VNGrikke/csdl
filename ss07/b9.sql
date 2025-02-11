create table phim (
    phimid int primary key auto_increment,
    ten_phim varchar(30),
    loai_phim nvarchar(25),
    thoi_gian int
);

create table phong (
    phongid int primary key auto_increment,
    ten_phong nvarchar(20),
    trang_thai tinyint
);

create table ghe (
    gheid int primary key auto_increment,
    phongid int,
    so_ghe varchar(10),
    foreign key (phongid) references phong(phongid)
);

create table ve (
    phimid int,
    gheid int,
    ngay_chieu datetime,
    trang_thai nvarchar(20),
    foreign key (phimid) references phim(phimid),
    foreign key (gheid) references ghe(gheid)
);

insert into phim (ten_phim, loai_phim, thoi_gian) values
('em bé hà nội', 'tâm lý', 90),
('nhiệm vụ bất khả thi', 'hành động', 100),
('dị nhân', 'viễn tưởng', 90),
('cuốn theo chiều gió', 'tình cảm', 120);

insert into phong (ten_phong, trang_thai) values
('phòng chiếu 1', 1),
('phòng chiếu 2', 1),
('phòng chiếu 3', 0);

insert into ghe (phongid, so_ghe) values
(1, 'a3'), (1, 'b5'), (1, 'a7'), (2, 'd1'), (3, 't2');

insert into ve (phimid, gheid, ngay_chieu, trang_thai) values
(1, 1, '2008-10-20', 'đã bán'),
(1, 3, '2008-11-20', 'đã bán'),
(1, 4, '2008-12-23', 'đã bán'),
(2, 2, '2009-02-14', 'đã bán'),
(2, 5, '2009-03-08', 'chưa bán'),
(3, 3, '2009-03-08', 'chưa bán');

-- truy vấn danh sách phim sắp xếp theo thời gian chiếu
select * from phim order by thoi_gian;

-- phim có thời gian chiếu dài nhất
select ten_phim from phim order by thoi_gian desc limit 1;

-- phim có thời gian chiếu ngắn nhất
select ten_phim from phim order by thoi_gian limit 1;

-- ghế bắt đầu bằng 'a'
select so_ghe from ghe where so_ghe like 'a%';

-- sửa cột trạng thái của bảng phong
alter table phong modify column trang_thai varchar(25);

-- cập nhật trạng thái phòng
update phong set trang_thai = case 
    when trang_thai = 1 then 'đang sửa'
    when trang_thai = 0 then 'đang sử dụng'
    else 'unknown'
end;

-- danh sách tên phim có độ dài >15 và <25 ký tự
select ten_phim from phim where length(ten_phim) > 15 and length(ten_phim) < 25;

-- gộp trạng thái phòng vào 1 cột
select ten_phong, concat('trạng thái phòng chiếu: ', trang_thai) as trang_thai_phong from phong;

-- tạo view tblRank
create view tblRank as 
select row_number() over (order by ten_phim) as stt, ten_phim, thoi_gian from phim;

-- thêm mô tả phim
-- alter table phim add column mo_ta nvarchar(max);
-- update phim set mo_ta = concat('đây là bộ phim thể loại ', loai_phim);

-- cập nhật thay thế từ 'phim' thành 'film'
update phim set mo_ta = replace(mo_ta, 'phim', 'film');

-- xóa khóa ngoại\alter table ve drop foreign key ve_ibfk_1;
alter table ve drop foreign key ve_ibfk_2;
alter table ghe drop foreign key ghe_ibfk_1;

-- xóa dữ liệu bảng ghế
delete from ghe;

-- cập nhật ngày chiếu tăng 5000 phút
update ve set ngay_chieu = date_add(ngay_chieu, interval 5000 minute);
