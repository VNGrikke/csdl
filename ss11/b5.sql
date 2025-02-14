-- 3
create view view_album_artist as
select 
    a.albumid as albumid,
    a.title as album_title,
    ar.name as artist_name
from album a
join artist ar on a.artistid = ar.artistid;


-- 4
create view view_customer_spending as
select 
    c.customerid,
    c.firstname,
    c.lastname,
    c.email,
    sum(i.total) as total_spending
from customer c
join invoice i on c.customerid = i.customerid
group by c.customerid, c.firstname, c.lastname, c.email;

-- 5
create index idx_employee_lastname on employee (lastname);
explain select * from employee where lastname = 'king';

-- 6
delimiter //
create procedure gettracksbygenre(in genre_id int)
begin
    select 
        t.trackid,
        t.name as track_name,
        a.title as album_title,
        ar.name as artist_name
    from track t
    join album a on t.albumid = a.albumid
    join artist ar on a.artistid = ar.artistid
    where t.genreid = genre_id;
end;
// delimiter ;

call gettracksbygenre(1);

-- 7
delimiter //

create procedure gettrackcountbyalbum(in p_albumid int, out total_tracks int)
begin
    select count(*) into total_tracks
    from track 
    where albumid = p_albumid;
end;

// delimiter ;

call gettrackcountbyalbum(1, @total_tracks);
select @total_tracks as total_tracks;

-- 8
drop view if exists view_album_artist;
drop view if exists view_customer_spending;

drop procedure if exists gettracksbygenre;
drop procedure if exists gettrackcountbyalbum;

drop index idx_employee_lastname on employee;
