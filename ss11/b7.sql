create view view_track_details as
select 
    t.trackid,
    t.name as track_name,
    a.title as album_title,
    ar.name as artist_name,
    t.unitprice
from track t
join album a on t.albumid = a.albumid
join artist ar on a.artistid = ar.artistid
where t.unitprice > 0.99;

select * from view_track_details;



-- 3 
create view view_customer_invoice as
select 
    c.customerid,
    concat(c.lastname, ' ', c.firstname) as fullname,
    c.email,
    sum(i.total) as total_spending,
    concat(e.lastname, ' ', e.firstname) as support_rep
from customer c
join invoice i on c.customerid = i.customerid
join employee e on c.supportrepid = e.employeeid
group by c.customerid, c.lastname, c.firstname, c.email, e.lastname, e.firstname
having sum(i.total) > 50;

select * from view_customer_invoice;


-- 4
create view view_top_selling_tracks as
select 
    t.trackid,
    t.name as track_name,
    g.name as genre_name,
    sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
join genre g on t.genreid = g.genreid
group by t.trackid, t.name, g.name
having sum(il.quantity) > 10;

select * from view_top_selling_tracks;

-- 5
create index idx_track_name on track (name);
select * from track where name like '%love%';
explain select * from track where name like '%love%';


-- 6 
create index idx_invoice_total on invoice (total);
select * from invoice where total between 20 and 100;
explain select * from invoice where total between 20 and 100;

-- 7
delimiter //
create procedure getcustomerspending(in customer_id int, out total_spending decimal(10,2))
begin
    select coalesce(sum(total_spending), 0) into total_spending
    from view_customer_invoice
    where customerid = customer_id;
end;
// delimiter ;

call getcustomerspending(1, @total_spending);
select @total_spending as total_spending;


-- 8
delimiter //
create procedure searchtrackbykeyword(in p_keyword varchar(100))
begin
    select 
        trackid,
        name as track_name,
        albumid,
        mediatypeid,
        genreid,
        composer,
        milliseconds,
        bytes,
        unitprice
    from track
    where name like concat('%', p_keyword, '%');
end;
// delimiter ;

call searchtrackbykeyword('lo');

-- 9
delimiter //
create procedure gettopsellingtracks(in p_minsales int, in p_maxsales int)
begin
    select 
        trackid,
        track_name,
        genre_name,
        total_sales
    from view_top_selling_tracks
    where total_sales between p_minsales and p_maxsales;
end;
// delimiter ;

call gettopsellingtracks(10, 100);


-- 10
drop view if exists view_track_details;
drop view if exists view_customer_invoice;
drop view if exists view_top_selling_tracks;

drop procedure if exists getcustomerspending;
drop procedure if exists searchtrackbykeyword;
drop procedure if exists gettopsellingtracks;

drop index idx_track_name on track;
drop index idx_invoice_total on invoice;

