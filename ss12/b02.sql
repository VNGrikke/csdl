-- 2 
create table price_changes(
	change_id int primary key auto_increment,
    product varchar(100) not null,
    old_price decimal(10,2) not null,
    new_price decimal(10,2) not null
);
-- 3
DELIMITER //
create trigger after_update_order 
after update on orders
for each row
begin
	insert into price_changes(product, old_price, new_price)	
    value(new.product,old.price,new.price);
end 
DELIMITER // ;	
-- 4
update orders 
set price =  1400.00
where product = 'Laptop';
update orders
set price = 800.00 
where product = 'Smartphone';
 --  5
 select * from price_changes;

 