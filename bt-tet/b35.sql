SELECT kq.MaSV, CONCAT(sv.HoSV, ' ', sv.TenSV) AS HoTen, COUNT(*) AS SoMonRot
FROM KetQua kq
JOIN DMSV sv ON kq.MaSV = sv.MaSV
WHERE kq.LanThi = 1 AND kq.Diem < 5
GROUP BY kq.MaSV, HoTen
HAVING SoMonRot > 2;
