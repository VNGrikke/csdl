create index idx_customerNumber on payments(customerNumber);

create view view_customer_payments as
select 
    customerNumber, 
    sum(amount) as total_payments, 
    count(paymentDate) as payment_count
from payments
group by customerNumber;

select customerNumber, total_payments, payment_count
from view_customer_payments;

select c.customerNumber, c.customerName, v.total_payments, v.payment_count, creditLimit
from view_customer_payments v
join customers c on v.customerNumber = c.customerNumber
where v.total_payments > 150000 and v.payment_count > 3
order by v.total_payments desc
limit 5;