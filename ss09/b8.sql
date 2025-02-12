create index idx_productLine on products(productLine);

create view view_highest_priced_products as
select 
    p.productLine, 
    p.productName, 
    p.MSRP
from products p
where p.MSRP = (
    select max(MSRP)
    from products
    where productLine = p.productLine
);

select productLine, productName, MSRP
from view_highest_priced_products;

select v.productLine, v.productName, v.MSRP, pl.textDescription
from view_highest_priced_products v
join productlines pl on v.productLine = pl.productLine
order by v.MSRP desc
limit 10;