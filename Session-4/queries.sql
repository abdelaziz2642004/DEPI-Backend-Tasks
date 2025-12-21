-- 1 Count the total number of products in the database.
select count(*) as total_products from production.products

--2. Find the average, minimum, and maximum price of all products.
select avg(list_price) as avg_price, min(list_price) as min_price,
max(list_price) as max_price from production.products

--3. Count how many products are in each category.
select c.category_name, count(p.product_id) as product_count 
from production.categories c join production.products p 
on c.category_id = p.category_id group by c.category_name

-- 4total orders per store ( we need left join here because we need to show all stores and their total orders IF found :D)
select s.store_name, count(o.order_id) as total_orders from sales.stores s 
left join sales.orders o on s.store_id = o.store_id group by s.store_name

--5-Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.
select TOP 10 upper(first_name) as first_name, lower(last_name) as last_name from sales.customers

--6. Get the length of each product name. Show product name and its length for the first 10 products.
select TOP 10 product_name, len(product_name) as name_length from production.products

-- 7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.
select TOP 15 customer_id, substring(phone,1,3) as area_code from sales.customers

--8. Show the current date and extract the year and month from order dates for orders 1-10.
select TOP 10 GETDATE()  as today, YEAR(order_date) as order_year,
MONTH(order_date) as order_month from sales.orders


--9. Join products with their categories. Show product name and category name for first 10 products.
select TOP 10 p.product_name, c.category_name from production.products p 
join production.categories c on p.category_id = c.category_id

--10. Join customers with their orders. Show customer name and order date for first 10 orders.
select TOP 10 c.first_name + ' '+ c.last_name as customerfull_name, o.order_date from sales.customers c
join sales.orders o on c.customer_id = o.customer_id


--11. Show all products with their brand names, even if some products don't have brands. Include product name, brand name (show 'No Brand' if null). ( lazem kol el products -> left join )
select p.product_name,  ISNULL(b.brand_name, 'No Brand') as brand_name from production.products p left join production.brands b on p.brand_id = b.brand_id;

--12. Find products that cost more than the average product price. Show product name and price.
select product_name, list_price from production.products
where list_price > (select avg(list_price) from production.products)

-- 13. Find customers who have placed at least one order. Use a subquery with IN. Show customer_id and customer_name.
select first_name+' '+last_name as customer_name ,customer_id from sales.customers
where customer_id in (select distinct customer_id from sales.orders)

--14. For each customer, show their name and total number of orders using a subquery in the SELECT clause.
select first_name+' '+last_name as customer_name, (select count(*) from sales.orders o where o.customer_id = c.customer_id)
as total_orders from sales.customers c



--15. Create a simple view called easy_product_list that shows product name, category name, and price. Then write a query to select all products from this view where price > 100.
create view easy_product_list as
select p.product_name, c.category_name, p.list_price 
from production.products p join production.categories c
on p.category_id = c.category_id;

select *
from easy_product_list
where list_price > 100;



-- 16. Create a view called customer_info that shows customer ID, full name (first + last), email, and city and state combined. Then use this view to find all customers from California (CA).
create view customer_info as select customer_id, first_name + ' '+ last_name as full_name,
email, city + ', ' + state as location from sales.customers;

select * from customer_info where location like '%ca'

--17. Find all products that cost between $50 and $200. Show product name and price, ordered by price from lowest to highest.
select product_name, list_price from production.products where list_price between 50 and 200 order by list_price asc

--18. Count how many customers live in each state. Show state and customer count, ordered by count from highest to lowest.
select state, count(*) as total_customers from sales.customers group by state order by total_customers desc

-- 19. Find the most expensive product in each category. Show category name, product name, and price.

select c.category_name, p.product_name, p.list_price
from production.products p
join production.categories c
on p.category_id = c.category_id
where p.list_price =
(select max(p2.list_price) from production.products p2 where p2.category_id = p.category_id);

--20- 20. Show all stores and their cities, including the total number of orders from each store. Show store name, city, and order count.
-- ( lazem store - total_order ) -> left join
select s.store_name, s.city ,count(o.order_id) as order_count
from sales.stores s left join sales.orders o on s.store_id = o.store_id group by s.store_name, s.city;
