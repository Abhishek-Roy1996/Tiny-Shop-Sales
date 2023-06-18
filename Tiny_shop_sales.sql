create database tiny_shop_sales;

use tiny_shop_sales;

CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);

CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);

INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);

/*1. Which product has the highest price? Only return a single row.
2. Which customer has made the most orders?
3. What’s the total revenue per product?
4. Find the day with the highest revenue.
5. Find the first order (by date) for each customer.
6. Find the top 3 customers who have ordered the most distinct products
7. Which product has been bought the least in terms of quantity?
8. What is the median order total?
9. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
10. Find customers who have ordered the product with the highest price.*/

-- 1. Which product has the highest price? Only return a single row.

   select product_name,price
   from products
   order by price desc
   limit 1;
   
-- 2. Which customer has made the most orders?

   with cte as (
   select c.customer_id,count(*) as TotalOrders
   from customers c inner join orders o using(customer_id)
   group by 1)
   
   select cte.customer_id,concat(c.first_name," ",c.last_name) as CustomerName,cte.TotalOrders
   from cte
   inner join customers c using(customer_id)
   where TotalOrders in (select max(TotalOrders) from cte);
   
   select c.customer_id,count(*) as TotalOrders
   from customers c inner join orders o using(customer_id)
   group by 1
   having Totalorders>1;
   
-- 3. What’s the total revenue per product?

   select p.product_id,p.product_name,sum(p.price*oi.quantity) as TotalRevenue
   from products p inner join order_items oi using(product_id)
   group by p.product_id,p.product_name
   order by TotalRevenue desc;
   
-- 4. Find the day with the highest revenue.

   select dayname(order_date) as DayofWeek,o.order_date,sum(oi.quantity*p.price) as Revenue
   from order_items oi inner join orders o using(order_id)
   inner join products p using(product_id)
   group by 2
   order by Revenue desc
   limit 1;
   
-- 5. Find the first order (by date) for each customer.

   select concat(c.first_name," ",c.last_name) as CustomerName,Min(o.order_date) as First_Order
   from orders o inner join order_items oi using(order_id)
   inner join customers c using(customer_id)
   group by c.customer_id;
   
-- 6. Find the top 3 customers who have ordered the most distinct products

   select concat(c.first_name," ",c.last_name) as CustomerName, count(distinct product_id) as TotalDistinctProducts
   from customers c inner join orders o using(customer_id)
   inner join order_items oi using(order_id)
   group by 1
   order by 2 desc
   limit 3;
   
-- 7. Which product has been bought the least in terms of quantity?

    with lb as (
    select p.product_id, p.product_name, sum(oi.quantity) as TotalQuantity,
    dense_rank() over (order by sum(oi.quantity) asc) as rnk
    from order_items oi inner join products p using(product_id)
    group by 1,2
    )
    
    select product_id,product_name,TotalQuantity
    from lb
    where rnk=1;
   
-- 8. What is the median order total?

    with TotalOrders as
    (
    select o.order_id,SUM(oi.quantity*p.price) as TotalRevenue
    from order_items oi inner join products p using(product_id)
    inner join orders o using(order_id)
    group by o.order_id)
    select avg(totalrevenue) as median_order_total
    from ( select totalrevenue, Ntile(2) over (partition by totalrevenue) as quartile
    from totalorders) median_query where quartile =1 or quartile=2;


-- 9. For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.

	with cte as (
    select oi.order_id, sum(oi.quantity*p.price) as Total
    from order_items oi inner join products p using(product_id)
    group by 1
    order by 2)
    
    select order_id,Total,
    case when Total>300 then 'Expensive'
    when Total<300 and Total>100 then 'Affordable'
    else 'cheap'
    end as Order_status
    from cte;
    
-- 10. Find customers who have ordered the product with the highest price.

    select product_name, max(price) as Max
    from products
    group by 1
    order by 2 desc
    limit 1;
    