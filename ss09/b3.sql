use classicmodels;

select * from customers where country = 'Germany';

explain analyze select * from customers where country = 'Germany';

create index idx_country on customers(country);

drop index idx_country on customers;