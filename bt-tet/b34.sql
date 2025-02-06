SELECT kq.MaSV, CONCAT(sv.HoSV, ' ', sv.TenSV) AS HoTen, AVG(kq.Diem) AS DiemTrungBinh FROM KetQua kq
JOIN DMSV sv ON kq.MaSV = sv.MaSV
WHERE sv.Phai = 'Nam' AND kq.LanThi = 1
GROUP BY kq.MaSV, HoTen
HAVING DiemTrungBinh > 7.0;
