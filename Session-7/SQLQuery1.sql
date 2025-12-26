/* 
required tables for trigger questions#
before starting the trigger questions, create these additional tables:
*/

-- customer activity log
create table sales.customer_log (
    log_id int identity(1,1) primary key,
    customer_id int,
    action varchar(50),
    log_date datetime default getdate()
);

-- price history tracking
create table production.price_history (
    history_id int identity(1,1) primary key,
    product_id int,
    old_price decimal(10,2),
    new_price decimal(10,2),
    change_date datetime default getdate(),
    changed_by varchar(100)
);

-- order audit trail
create table sales.order_audit (
    audit_id int identity(1,1) primary key,
    order_id int,
    customer_id int,
    store_id int,
    staff_id int,
    order_date date,
    audit_timestamp datetime default getdate()
);



/*
1.create a non-clustered index on the email column in the sales.customers table to improve search performance when looking up customers by email.
*/
create nonclustered index ix_customers_email
on sales.customers (email);



/*
2.create a composite index on the production.products table that includes category_id and brand_id columns to optimize searches that filter by both category and brand.
*/
create nonclustered index ix_products_category_brand
on production.products (category_id, brand_id);



/*
3.create an index on sales.orders table for the order_date column and include customer_id, store_id, and order_status as included columns to improve reporting queries.
*/
create nonclustered index ix_orders_order_date
on sales.orders (order_date)
include (customer_id, store_id, order_status);



/*
4.create a trigger that automatically inserts a welcome record into a customer_log table whenever a new customer is added to sales.customers. (first create the log table, then the trigger)
*/
create trigger trg_customers_welcome_log
on sales.customers
after insert
as
begin
    insert into sales.customer_log (customer_id, action)
    select customer_id, 'welcome customer'
    from inserted;
end;



/*
5.create a trigger on production.products that logs any changes 
to the list_price column into a price_history table, storing the old price, new price, and change date.
*/
create trigger trg_products_price_change
on production.products
after update
as
begin
    if update(list_price)
    begin
        insert into production.price_history (product_id, old_price, new_price, changed_by)
        select 
            d.product_id,
            d.list_price,
            i.list_price,
            suser_name()
        from deleted d
        join inserted i on d.product_id = i.product_id
        where d.list_price <> i.list_price;
    end
end;



/*
6.create an instead of delete trigger on production.categories that prevents deletion of categories that have associated products. display an appropriate error message.
*/
create trigger trg_categories_prevent_delete
on production.categories
instead of delete
as
begin
    if exists (
        select 1
        from production.products p
        join deleted d on p.category_id = d.category_id
    )
    begin
        raiserror ('cannot delete category because associated products exist', 16, 1);
        rollback transaction;
        return;
    end

    delete from production.categories
    where category_id in (select category_id from deleted);
end;



/*
7.create a trigger on sales.order_items that automatically reduces the quantity in production.stocks when a new order item is inserted.
*/
create trigger trg_order_items_reduce_stock
on sales.order_items
after insert
as
begin
    update s
    set s.quantity = s.quantity - i.quantity
    from production.stocks s
    join inserted i on s.product_id = i.product_id;
end;



/*
8.create a trigger that logs all new orders into an order_audit table, capturing order details and the date/time when the record was created.
*/
create trigger trg_orders_audit
on sales.orders
after insert
as
begin
    insert into sales.order_audit (
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_date
    )
    select 
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_date
    from inserted;
end;
