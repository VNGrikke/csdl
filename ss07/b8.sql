create table customer (
    cid int primary key,
    name varchar(25),
    cage tinyint
);

create table orders (
    oid int primary key,
    cid int,
    odate datetime,
    ototalprice int,
    foreign key (cid) references customer(cid)
);

create table product (
    pid int primary key,
    pname varchar(25),
    pprice int
);

create table orderdetail (
    oid int,
    pid int,
    odqty int,
    foreign key (oid) references orders(oid),
    foreign key (pid) references product(pid)
);


insert into customer (cid, name, cage) values
(1, 'minh quan', 10),
(2, 'ngoc oanh', 20),
(3, 'hong ha', 50);

insert into orders (oid, cid, odate, ototalprice) values
(1, 1, '2006-03-21', null),
(2, 1, '2006-03-23', null),
(3, 1, '2006-03-16', null);

insert into product (pid, pname, pprice) values
(1, 'may giat', 3),
(2, 'tu lanh', 5),
(3, 'dieu hoa', 7),
(4, 'quat', 1),
(5, 'bep dien', 2);

insert into orderdetail (oid, pid, odqty) values
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(1, 5, 1),
(2, 3, 8),
(2, 4, 4),
(2, 3, 3);





-- 2  
select oid, cid, odate, ototalprice
from orders
order by odate desc;

-- 3
select pname, pprice
from product
where pprice = (select max(pprice) from product);

-- 4
select c.name as cname, p.pname as pname
from customer c
join orders o on c.cid = o.cid
join orderdetail od on o.oid = od.oid
join product p on od.pid = p.pid;

-- 5 
select name as cname
from customer
where cid not in (select distinct cid from orders);

-- 6 
select o.oid, o.cid, o.odate, od.odqty, p.pname, p.pprice
from orders o
join orderdetail od on o.oid = od.oid
join product p on od.pid = p.pid
order by o.odate desc;

-- 7
select o.oid, o.odate, sum(od.odqty * p.pprice) as total
from orders o
join orderdetail od on o.oid = od.oid
join product p on od.pid = p.pid
group by o.oid, o.odate
order by o.odate desc;

-- 8
alter table orderdetail drop foreign key orderdetail_ibfk_1;
alter table orderdetail drop foreign key orderdetail_ibfk_2;
alter table orders drop foreign key orders_ibfk_1;

alter table customer drop primary key;
alter table orders drop primary key;
alter table product drop primary key;
alter table orderdetail drop primary key;

