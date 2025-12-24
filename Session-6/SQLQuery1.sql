/* 
1. customer spending analysis#
write a query that uses variables to find the total amount spent by customer id 1. display a message showing whether they are a vip customer (spent > $5000) or regular customer.
*/
declare @customer_id int = 1;
declare @total_spent decimal(18,2);

select @total_spent = sum(oi.quantity * oi.list_price * (1 - oi.discount))
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where o.customer_id = @customer_id;

if @total_spent > 5000
    print 'customer id ' + cast(@customer_id as varchar) + ' is a vip customer. total spent = ' + cast(@total_spent as varchar);
else
    print 'customer id ' + cast(@customer_id as varchar) + ' is a regular customer. total spent = ' + cast(isnull(@total_spent,0) as varchar);



/*
2. product price threshold report#
create a query using variables to count how many products cost more than $1500. store the threshold price in a variable and display both the threshold and count in a formatted message.
*/
declare @price_threshold decimal(10,2) = 1500;
declare @product_count int;

select @product_count = count(*)
from production.products
where list_price > @price_threshold;

print 'price threshold: $' + cast(@price_threshold as varchar) + 
      ', product count: ' + cast(@product_count as varchar);



/*
3. staff performance calculator#
write a query that calculates the total sales for staff member id 2 in the year 2017. use variables to store the staff id, year, and calculated total. display the results with appropriate labels.
*/
declare @staff_id int = 3;
declare @sales_year int = 2022;
declare @staff_total_sales decimal(18,2);

select @staff_total_sales = sum(oi.quantity * oi.list_price * (1 - oi.discount))
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where o.staff_id = @staff_id
and year(o.order_date) = @sales_year;

print 'staff id: ' + cast(@staff_id as varchar) +
      ', year: ' + cast(@sales_year as varchar) +
      ', total sales: ' + cast(isnull(@staff_total_sales,0) as varchar);



/*
4. global variables information#
create a query that displays the current server name, sql server version, and the number of rows affected by the last statement. use appropriate global variables.
*/
select 
    @@servername as server_name,
    @@version as sql_server_version,
    @@rowcount as last_rows_affected;



/*
5.write a query that checks the inventory level for product id 1 in store id 1. use if statements to display different messages based on stock levels:#
if quantity > 20: well stocked
if quantity 10-20: moderate stock
if quantity < 10: low stock - reorder needed
*/
declare @quantity int;

select @quantity = quantity
from production.stocks
where product_id = 1 and store_id = 1;

if @quantity > 20
    print 'well stocked';
else if @quantity between 10 and 20
    print 'moderate stock';
else
    print 'low stock - reorder needed';



/*
6.create a while loop that updates low-stock items (quantity < 5) in batches of 3 products at a time. add 10 units to each product and display progress messages after each batch.#
*/
declare @batch_count int = 1;

while exists (select 1 from production.stocks where quantity < 5)
begin
    update top (3) production.stocks
    set quantity = quantity + 10
    where quantity < 5;

    print 'batch ' + cast(@batch_count as varchar) + ' processed';
    set @batch_count += 1;
end



/*
7. product price categorization#
write a query that categorizes all products using case when based on their list price:
under $300: budget
$300-$800: mid-range
$801-$2000: premium
over $2000: luxury
*/
select 
    product_name,
    list_price,
    case 
        when list_price < 300 then 'budget'
        when list_price between 300 and 800 then 'mid-range'
        when list_price between 801 and 2000 then 'premium'
        else 'luxury'
    end as price_category
from production.products;



/*
8. customer order validation#
create a query that checks if customer id 5 exists in the database. if they exist, show their order count. if not, display an appropriate message.
*/
if exists (select 1 from sales.customers where customer_id = 5)
begin
    select count(*) as order_count
    from sales.orders
    where customer_id = 5;
end
else
    print 'customer id 5 does not exist';



/*
9. shipping cost calculator function#
create a scalar function named calculateshipping that takes an order total as input and returns shipping cost:
orders over $100: free shipping ($0)
orders $50-$99: reduced shipping ($5.99)
orders under $50: standard shipping ($12.99)
*/
create function calculateshipping (@order_total decimal(10,2))
returns decimal(10,2)
as
begin
    return case 
        when @order_total > 100 then 0
        when @order_total between 50 and 99 then 5.99
        else 12.99
    end;
end;

print(dbo.calculateshipping(40))

/*
10. product category function#
create an inline table-valued function named getproductsbypricerange that accepts minimum and maximum price parameters and returns all products within that price range with their brand and category information.
*/
create function getproductsbypricerange
(
    @min_price decimal(10,2),
    @max_price decimal(10,2)
)
returns table
as
return
(
    select 
        p.product_name,
        p.list_price,
        b.brand_name,
        c.category_name
    from production.products p
    join production.brands b on p.brand_id = b.brand_id
    join production.categories c on p.category_id = c.category_id
    where p.list_price between @min_price and @max_price
);

select * from dbo.GetProductsByPriceRange(10, 100);

/*
11. customer sales summary function#
create a multi-statement function named getcustomeryearlysummary that takes a customer id and returns a table with yearly sales data including total orders, total spent, and average order value for each year.
*/
create function getcustomeryearlysummary (@customer_id int)
returns @summary table
(
    sales_year int,
    total_orders int,
    total_spent decimal(18,2),
    avg_order_value decimal(18,2)
)
as
begin
    insert into @summary
    select 
        year(o.order_date),
        count(distinct o.order_id),
        sum(oi.quantity * oi.list_price * (1 - oi.discount)),
        avg(oi.quantity * oi.list_price * (1 - oi.discount))
    from sales.orders o
    join sales.order_items oi on o.order_id = oi.order_id
    where o.customer_id = @customer_id
    group by year(o.order_date);

    return;
end;

select * from dbo.getcustomeryearlysummary(10);

