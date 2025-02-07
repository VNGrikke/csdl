select CustomerName, ProductName, sum(Quantity) as TotalQuantity 
from Orders
group by OrderID
having TotalQuantity > 1;

select CustomerName, OrderDate, Quantity 
from Orders
group by OrderID
having Quantity > 2;


select CustomerName, OrderDate, Quantity*Price as TotalSpent 
from Orders
group by OrderID
having TotalSpent > 20000000;



