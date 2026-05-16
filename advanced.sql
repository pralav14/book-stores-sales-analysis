SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Find the top 3 customers who spent the highest 
-- total amount in each country.
select * from (select c.customer_id, c.name, c.country, o.total_amount,
  dense_rank () over (partition by c.country order by o.total_amount desc) as top
  from customers as c join orders as o
 on c.customer_id=o.customer_id ) as ranked_data
 where top <=3;

-- Show each book title along with its total 
-- sales amount and the previous book’s sales amount.

select b.book_id, b.title, b.author, o.total_amount,
coalesce(lag(o.total_amount) over(order by o.order_date),0) as prev_data
from books as b join orders as o
on b.book_id=o.book_id;

-- Find customers whose total purchase amount is 
-- greater than the average purchase amount of their country.

SELECT 
    c.customer_id, c.name,
    SUM(o.total_amount) AS total_spent FROM Customers c JOIN Orders o
ON c.customer_id = o.customer_id

GROUP BY c.customer_id, c.name HAVING SUM(o.total_amount) > 
(
    SELECT AVG(total_amount)
    FROM Orders
);

-- Display the running total of sales 
-- (Total_Amount) ordered by Order_Date.

select total_amount, sum(total_amount) over(order by order_date) as running_sum
from orders;

-- Find the most ordered book in 
-- each genre.

select* from(select b.book_id, b.title, b.author , b.genre , o.order_date
, row_number() over(partition by b.genre order by o.quantity desc) as row_num
from books b join orders o on
b.book_id=o.book_id) as top_data
 where row_num=1;

-- Show customer name, book title, quantity ordered, 
-- and rank customers based on quantity purchased.

select * from orders;
select c.name, b.title, o.quantity, rank() over(order by o.quantity desc) as rnk
from orders as o join books as b on o.book_id=b.book_id
join customers as c on o.customer_id=c.customer_id;


-- Find the second highest selling 
-- book overall .

SELECT *
FROM (  SELECT   b.book_id,  b.title,  b.author,  b.genre,
        SUM(o.quantity) AS total_sold,
        DENSE_RANK() OVER(
            ORDER BY SUM(o.quantity) DESC
        ) AS den_rnk
   FROM Books b  JOIN Orders o  ON b.book_id = o.book_id
   GROUP BY  b.book_id, b.title, b.author, b.genre
) AS top_books 
where den_rnk = 2;

-- Show the difference between current order amount 
-- and next order amount for each customer.

select total_amount, total_amount-coalesce(lead(total_amount) over (partition by customer_id 
order by order_date),0) 
as diffrence from orders;

-- Find customers who ordered more books than the average
-- quantity ordered overall .

select c.customer_id, c.name, sum(o.quantity) as total_books
from customers as c join
orders as o on c.customer_id=o.customer_id
group by c.customer_id,c.name
having sum(o.quantity)> (select avg(quantity) from orders);

-- Display monthly sales along with previous 
-- month sales and sales growth .
select* from orders;
select monthly, monthly_sales, coalesce(lag(monthly_sales) over(order by  monthly),0) as previous_monthly
, monthly_sales-coalesce(lag(monthly_sales) over(order by  monthly),0) as sales_growth
from
(select EXTRACT(MONTH FROM order_date) as monthly , sum(total_amount) as monthly_sales
from orders
group by EXTRACT(MONTH FROM order_date)) as monthly_data;





-- Example concepts used:
-- INNER JOIN
-- LEFT JOIN
-- RANK()
-- DENSE_RANK()
-- ROW_NUMBER()
-- LAG()
-- LEAD()
-- SUM() OVER()
-- Aggregate functions (AVG, SUM, COUNT)