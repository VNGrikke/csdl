select b.title, b.author, c.category_name 
from books b
join categories c on b.category_id = c.category_id
order by b.title;

select r.name as reader_name, count(b.borrow_id) as borrowed_books
from readers r
left join borrowing b on r.reader_id = b.reader_id
group by r.name;

select avg(f.fine_amount) as average_fine
from fines f;

select title, available_quantity
from books
where available_quantity = (select max(available_quantity) from books);

select r.name as reader_name, f.fine_amount
from fines f
join returning ret on f.return_id = ret.return_id
join borrowing b on ret.borrow_id = b.borrow_id
join readers r on b.reader_id = r.reader_id
where f.fine_amount > 0;

select b.title, count(br.borrow_id) as borrow_count
from borrowing br
join books b on br.book_id = b.book_id
group by b.title
having count(br.borrow_id) = (select max(borrow_count)
from (select count(borrow_id) as borrow_count from borrowing group by book_id) as temp);

select b.title, r.name as reader_name, br.borrow_date
from borrowing br
join books b on br.book_id = b.book_id
join readers r on br.reader_id = r.reader_id
left join returning ret on br.borrow_id = ret.borrow_id
where ret.return_id is null
order by br.borrow_date;

select r.name as reader_name, b.title
from returning ret
join borrowing br on ret.borrow_id = br.borrow_id
join books b on br.book_id = b.book_id
join readers r on br.reader_id = r.reader_id
where ret.return_date <= br.due_date;

select b.title, b.publication_year
from books b
join borrowing br on b.book_id = br.book_id
group by b.book_id, b.title, b.publication_year
having count(br.borrow_id) = (
    select max(borrow_count)
    from (select count(borrow_id) as borrow_count from borrowing group by book_id) as temp
);
