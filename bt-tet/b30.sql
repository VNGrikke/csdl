SELECT YEAR(NgaySinh) AS NamSinh, COUNT(*) AS SoSinhVien FROM DMSV
GROUP BY NamSinh
HAVING SoSinhVien = 2;
