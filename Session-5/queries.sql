/*
1.Write a query that classifies all products into price categories:

Products under $300: "Economy"
Products $300-$999: "Standard"
Products $1000-$2499: "Premium"
Products $2500 and above: "Luxury"
*/
select product_name, list_price, case when list_price < 300 then 'economy'
when list_price between 300 and 999 then 'standard'
when list_price between 1000 and 2499 then 'premium'
else 'luxury' end as price_category
from production.products

/*
2.Create a query that shows order processing information with user-friendly status descriptions:

Status 1: "Order Received"
Status 2: "In Preparation"
Status 3: "Order Cancelled"
Status 4: "Order Delivered"
Also add a priority level:

Orders with status 1 older than 5 days: "URGENT"
Orders with status 2 older than 3 days: "HIGH"
All other orders: "NORMAL"
*/
select order_id, order_status, 
case order_status 
when 1 then 'Order Received'
when 2 then 'In Preparation'
when 3 then 'Order Cancelled'
when 4 then 'Order Delivered'
end as status_descriptions,
case 
when order_status = 1 AND DATEDIFF(day, order_date, GETDATE()) > 5 then 'Urgent'
when order_status = 2 AND DATEDIFF(day, order_date, GETDATE()) > 3 then 'High'
else 'Normal'
end as priority_level
from sales.orders


/*3.Write a query that categorizes staff based on the number of orders they've handled:
staff - order
I need to show all staff -> left join

0 orders: "New Staff"
1-10 orders: "Junior Staff"
11-25 orders: "Senior Staff"
26+ orders: "Expert Staff"*/

select s.staff_id,
case
when count(o.order_id) = 0 then 'new staff'
when count(o.order_id) between 1 and 10 then 'junior staff' 
when count(o.order_id) between 11 and 25 then 'senior staff'
else 'expert staff' end as staff_level
from sales.staffs s left join sales.orders o on s.staff_id = o.staff_id group by s.staff_id
-- Is there a way instead of calculating coutn function multiple times?! :D

/*4.Create a query that handles missing customer contact information:

Use ISNULL to replace missing phone numbers with "Phone Not Available"
Use COALESCE to create a preferred_contact field (phone first, then email, then "No Contact Method")
Show complete customer information */


select customer_id, first_name + ' ' +last_name as full_name,
isnull(phone,'phone not available') as phone, email,
coalesce(phone,email,'no contact method') as preferred_contact from sales.customers


/*5.Write a query that safely calculates price per unit in stock:

Use NULLIF to prevent division by zero when quantity is 0
Use ISNULL to show 0 when no stock exists
Include stock status using CASE WHEN
Only show products from store_id = 1*/

select p.product_name, p.list_price, s.quantity,
isnull(p.list_price / nullif(s.quantity,0),0) as price_per_unit,
case when s.quantity = 0 then 'out of stock' 
when s.quantity < 10 then 'low stock' else 'in stock' end as stock_status
from production.products p join production.stocks s
on p.product_id = s.product_id where s.store_id = 1



/*6.Create a query that formats complete addresses safely:

Use COALESCE for each address component
Create a formatted_address field that combines all components
Handle missing ZIP codes gracefully

*/
select customer_id, coalesce(street,'') + ', ' + coalesce(city,'') + ', ' + coalesce(state,'') + ' ' + coalesce(zip_code,'none') as formatted_address
from sales.customers

/*
7.Use a CTE to find customers who have spent more than $1,500 total:

Create a CTE that calculates total spending per customer
Join with customer information
Show customer details and spending
Order by total_spent descending*/

-- calculate total spend foreach customer
with CustomerSpending as (
    select 
        o.customer_id,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_spend
    from sales.orders o
    join sales.order_items oi
        on o.order_id = oi.order_id
    group by  o.customer_id
)

select 
    c.customer_id,
    c.first_name,
    c.last_name,
    cs.total_spend
from CustomerSpending cs
join sales.customers c
    on cs.customer_id = c.customer_id
where cs.total_spend > 1500
order by  cs.total_spend desc;
