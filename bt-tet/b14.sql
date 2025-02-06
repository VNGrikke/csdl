SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, TenKhoa, Phai FROM DMSV 
JOIN DMKhoa ON DMSV.MaKhoa = DMKhoa.MaKhoa 
WHERE Phai = 'Nam' AND DMSV.MaKhoa IN ('AV', 'TH');
