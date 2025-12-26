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





/*
12. discount calculation function#
write a scalar function named calculatebulkdiscount that determines discount percentage based on quantity:
1-2 items: 0% discount
3-5 items: 5% discount
6-9 items: 10% discount
10+ items: 15% discount
*/
create function calculatebulkdiscount (@quantity int)
returns decimal(5,2)
as
begin
    return case
        when @quantity between 1 and 2 then 0
        when @quantity between 3 and 5 then 0.05
        when @quantity between 6 and 9 then 0.10
        else 0.15
    end;
end;



/*
13. customer order history procedure#
create a stored procedure named sp_getcustomerorderhistory that accepts a customer id and optional start/end dates. return the customer's order history with order totals calculated.
*/
create procedure sp_getcustomerorderhistory
    @customer_id int,
    @start_date date = null,
    @end_date date = null
as
begin
    select 
        o.order_id,
        o.order_date,
        sum(oi.quantity * oi.list_price * (1 - oi.discount)) as order_total
    from sales.orders o
    join sales.order_items oi on o.order_id = oi.order_id
    where o.customer_id = @customer_id
    and (@start_date is null or o.order_date >= @start_date)
    and (@end_date is null or o.order_date <= @end_date)
    group by o.order_id, o.order_date;
end;



/*
14. inventory restock procedure#
write a stored procedure named sp_restockproduct with input parameters for store id, product id, and restock quantity. include output parameters for old quantity, new quantity, and success status.
*/
create procedure sp_restockproduct
    @store_id int,
    @product_id int,
    @restock_qty int,
    @old_qty int output,
    @new_qty int output,
    @success bit output
as
begin
    select @old_qty = quantity
    from production.stocks
    where store_id = @store_id and product_id = @product_id;

    update production.stocks
    set quantity = quantity + @restock_qty
    where store_id = @store_id and product_id = @product_id;

    select @new_qty = quantity
    from production.stocks
    where store_id = @store_id and product_id = @product_id;

    set @success = 1;
end;



/*
15. order processing procedure#
create a stored procedure named sp_processneworder that handles complete order creation with proper transaction control and error handling. include parameters for customer id, product id, quantity, and store id.
*/
create procedure sp_processneworder
    @customer_id int,
    @product_id int,
    @quantity int,
    @store_id int
as
begin
    begin try
        begin transaction;

        insert into sales.orders (customer_id, order_status, order_date, store_id, staff_id)
        values (@customer_id, 1, getdate(), @store_id, 1);

        declare @order_id int = scope_identity();

        insert into sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
        select @order_id, 1, product_id, @quantity, list_price, 0
        from production.products
        where product_id = @product_id;

        commit transaction;
    end try
    begin catch
        rollback transaction;
        throw;
    end catch
end;



/*
16. dynamic product search procedure#
write a stored procedure named sp_searchproducts that builds dynamic sql based on optional parameters: product name search term, category id, minimum price, maximum price, and sort column.
*/
create procedure sp_searchproducts
    @product_name varchar(255) = null,
    @category_id int = null,
    @min_price decimal(10,2) = null,
    @max_price decimal(10,2) = null,
    @sort_column varchar(50) = 'list_price'
as
begin
    declare @sql nvarchar(max) = '
    select * from production.products where 1=1';

    if @product_name is not null
        set @sql += ' and product_name like ''%' + @product_name + '%''';

    if @category_id is not null
        set @sql += ' and category_id = ' + cast(@category_id as varchar);

    if @min_price is not null
        set @sql += ' and list_price >= ' + cast(@min_price as varchar);

    if @max_price is not null
        set @sql += ' and list_price <= ' + cast(@max_price as varchar);

    set @sql += ' order by ' + @sort_column;

    exec sp_executesql @sql;
end;



/*
17. staff bonus calculation system#
create a complete solution that calculates quarterly bonuses for all staff members. use variables to store date ranges and bonus rates. apply different bonus percentages based on sales performance tiers.
*/
declare @q_start date = '2017-01-01';
declare @q_end date = '2017-03-31';

select 
    o.staff_id,
    sum(oi.quantity * oi.list_price) as total_sales,
    case 
        when sum(oi.quantity * oi.list_price) > 50000 then '15%'
        when sum(oi.quantity * oi.list_price) > 20000 then '10%'
        else '5%'
    end as bonus_rate
from sales.orders o
join sales.order_items oi on o.order_id = oi.order_id
where o.order_date between @q_start and @q_end
group by o.staff_id;



/*
18. smart inventory management#
write a complex query with nested if statements that manages inventory restocking. check current stock levels and apply different reorder quantities based on product categories and current stock levels.
*/
update s
set quantity = quantity + 
    case 
        when c.category_name = 'bikes' and s.quantity < 5 then 20
        when c.category_name = 'accessories' and s.quantity < 10 then 15
        else 5
    end
from production.stocks s
join production.products p on s.product_id = p.product_id
join production.categories c on p.category_id = c.category_id
where s.quantity < 10;



/*
19. customer loyalty tier assignment#
create a comprehensive solution that assigns loyalty tiers to customers based on their total spending. handle customers with no orders appropriately and use proper null checking.
*/
select 
    c.customer_id,
    isnull(sum(oi.quantity * oi.list_price),0) as total_spent,
    case 
        when isnull(sum(oi.quantity * oi.list_price),0) > 10000 then 'platinum'
        when isnull(sum(oi.quantity * oi.list_price),0) > 5000 then 'gold'
        when isnull(sum(oi.quantity * oi.list_price),0) > 1000 then 'silver'
        else 'bronze'
    end as loyalty_tier
from sales.customers c
left join sales.orders o on c.customer_id = o.customer_id
left join sales.order_items oi on o.order_id = oi.order_id
group by c.customer_id;



/*
20. product lifecycle management#
write a stored procedure that handles product discontinuation including checking for pending orders, optional product replacement in existing orders, clearing inventory, and providing detailed status messages.
*/
create procedure sp_discontinueproduct
    @product_id int
as
begin
    if exists (
        select 1 from sales.order_items oi
        join sales.orders o on oi.order_id = o.order_id
        where oi.product_id = @product_id and o.order_status = 1
    )
    begin
        print 'cannot discontinue product: pending orders exist';
        return;
    end

    delete from production.stocks where product_id = @product_id;

    print 'product discontinued successfully';
end;