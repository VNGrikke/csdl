create view view_customer_status as 
select customerNumber, customerName, creditLimit, 
case 
	when creditLimit>100000 then "High"
    when creditLimit>50000 and creditLimit<100000 then "Medium"
    else "Low"
end as status
from customers;

select customerNumber, customerName, creditLimit, status
from view_customer_status;

select status, count(customerNumber) as customer_count
from view_customer_status
group by status
order by customer_count desc;