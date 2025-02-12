create index idx_productLine on products(productLine);

create view view_total_sales as
select productLine, sum(quantityOrdered * priceEach) as total_sales, sum(quantityOrdered) as total_quantity
from orderdetails
join products p on orderdetails.productCode = p.productCode
group by productLine;

select productLine, total_sales, total_quantity
from view_total_sales;

select v.productLine, pl.textDescription, v.total_sales, v.total_quantity,
    case
        when v.total_quantity > 1000 then concat(substr(pl.textDescription, 1, 30), '...') 
        else substr(pl.textDescription, 1, 30)
    end as description_snippet,
    case
        when v.total_quantity > 1000 then v.total_sales / v.total_quantity * 1.1
        when v.total_quantity > 500 then v.total_sales / v.total_quantity
        else v.total_sales / v.total_quantity * 0.9
    end as sales_per_product
from view_total_sales v
join productlines pl on v.productLine = pl.productLine
where v.total_sales > 2000000
order by v.total_sales desc;