-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:

 select * from Books where genre in('Fiction');

-- 2) Find books published after the year 1950:

 select * from books where published_year>1950;

-- 3) List all customers from the Canada:

 select * from customers where country in('Canada');

-- 4) Show orders placed in November 2023:
 select * from orders where order_date  between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
 select sum(stock) as total_books from books;

-- 6) Find the details of the most expensive book:
  select * from books order by price desc limit 1;

  -- with subquery:-
  select* from books where price=(
        select max(price) from books
  );

-- 7) Show all customers who ordered more than 1 quantity of a book:
   select c.customer_id , c.name, c.email, c.phone, c.city, c.country, o.quantity from customers as c
    join orders as o on c.customer_id=o.customer_id 
   where o.quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
 select * from orders where total_amount>20;

-- 9) List all genres available in the Books table:
   select  genre from books group by genre;
   
   -- with DISTINCT:-
   SELECT DISTINCT genre from books;
   
-- 10) Find the book with the lowest stock:
   select * from books where stock=(
      select min(stock) from books
   ) ;

-- 11) Calculate the total revenue generated from all orders:
   select sum(total_amount) as total_revenue from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

  select b.genre, sum(o.quantity) from books as b
  join orders as o on b.book_id=o.book_id 
  group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:

  select round(avg(price),2) 
  from books 
  where genre in('Fantasy');

-- 3) List customers who have placed at least 2 orders:
  select c.customer_id, c.name , count(o.order_id) as total_orders from customers as c join
  orders as o on c.customer_id=o.customer_id 
  group by c.customer_id, c.name having count(o.order_id)>=2;

-- 4) Find the most frequently ordered book:
  select b.book_id, b.title, sum(o.quantity) as frequent_book from books as b
  join orders as o on b.book_id=o.book_id
  group by b.book_id, b.title
  order by frequent_book desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
	  select  * from books
	  where genre='Fantasy'
	  order by price 
	  desc limit 3;
 

-- 6) Retrieve the total quantity of books sold by each author:
    select b.author, sum(o.quantity) as total_quantity from books as b
	join orders as o on b.book_id=o.book_id
	group by b.author;
	
select* from books;
-- 7) List the cities where customers who spent over $30 are located:
    SELECT DISTINCT c.city , o.total_amount
	FROM customers AS c
	JOIN orders AS o
	ON c.customer_id = o.customer_id
	WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:
   select c.name , sum(o.total_amount) as most_orders from customers as c
   join orders as o on c.customer_id=o.customer_id
   group by c.name order by most_orders desc limit 1;

--9) Calculate the stock remaining after fulfilling all orders:
   SELECT b.title,
       b.stock - SUM(o.quantity) as remaining_stocks
	   from books as b join orders as o 
	   on b.book_id=o.book_id 
	   group by b.title, b.stock;
  