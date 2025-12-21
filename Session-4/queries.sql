-- 1count total products
select count(*) as total_products from production.products;

--2- average min and max price
select avg(list_price) as avg_price, min(list_price) as min_price,
max(list_price) as max_price from production.products;

--3 count products per category
select c.category_name, count(p.product_id) as product_count 
from production.categories c join production.products p 
on c.category_id = p.category_id group by c.category_name;

-- 4total orders per store ( we need left join here because we need to show all stores and their total orders IF found :D)
select s.store_name, count(o.order_id) as total_orders from sales.stores s 
left join sales.orders o on s.store_id = o.store_id group by s.store_name;

--5-uppercase first name lowercase last name
select upper(first_name) as first_name, lower(last_name) as last_name from sales.customers;

--6length of product names
select product_name, len(product_name) as name_length from production.products;

-- 7 area code only from phone
select customer_id, substring(phone,1,4) as area_code from sales.customers
where customer_id between 1 and 15;

--8- current date and year month from order date
--select "now()?"  as today, extract(year from order_date) as order_year, extract(month from order_date) as order_month from sales.orders;

--9.join products with categories
select p.product_name, c.category_name from production.products p 
join production.categories c on p.category_id = c.category_id;

-- 10 join customers with orders
select c.first_name + ' '+ c.last_name as customerfull_name, o.order_date from sales.customers c
join sales.orders o on c.customer_id = o.customer_id;
