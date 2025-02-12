explain analyze 
select orderNumber, orderDate, status 
from orders 
where year(orderDate) = 2003 and status = 'Shipped';
create index idx_orderDate_status on orders(orderDate, status);
explain analyze select orderNumber, orderDate, status 
from orders 
where year(orderDate) = 2003 and status = 'Shipped';

explain analyze 
select customerNumber, customerName, phone 
from customers 
where phone = '2035552570';
create unique index idx_customerNumber on customers(customerNumber);
create unique index idx_phone on customers(phone);
explain analyze select customerNumber, customerName, phone 
from customers 
where phone = '2035552570';

drop index idx_orderDate_status on orders;
drop index idx_customerNumber on customers;
drop index idx_phone on customers;