select max(Price) as MaxPrice, min(Price) as MinPrice
from Orders;


select CustomerName, count(CustomerName) as OrderCount 
from Orders 
group by CustomerName;

select max(OrderDate) as LatestDate, min(OrderDate) as EarliestDate
from Orders;