create index idx_creditLimit on customers(creditLimit);

select c.customerNumber, c.customerName, c.city, c.creditLimit, o.country
from customers c
left join employees e on c.salesRepEmployeeNumber = e.employeeNumber
left join offices o on e.officeCode = o.officeCode
where c.creditLimit between 50000 and 100000
order by c.creditLimit desc
limit 5;

explain analyze 
select c.customerNumber, c.customerName, c.city, c.creditLimit, o.country
from customers c
left join employees e on c.salesRepEmployeeNumber = e.employeeNumber
left join offices o on e.officeCode = o.officeCode
where c.creditLimit between 50000 and 100000
order by c.creditLimit desc
limit 5;

create index idx_creditLimit_sorted on customers(creditLimit desc);