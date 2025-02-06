SELECT MaSV, Phai, MaKhoa, 
       CASE 
           WHEN HocBong > 500000 THEN 'Học bổng cao' 
           ELSE 'Mức trung bình' 
       END AS MucHocBong 
FROM DMSV;
