create database pizzaShop;

-- create table orders(
-- 	order_id int not null,
--     order_date date not null,
--     order_time time not null,
--     primary key(order_id)
-- );

-- create table order_details( 
-- order_details_id int not null,
-- order_id int not null,
-- pizza_id text not null,
-- quantity int not null,
-- primary key(order_details_id) 
-- );

-- Questions

-- 1) Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- 2) Calculate the total revenue generated from pizza sales.
 select round(sum(order_details.quantity * pizzas.price),2) as total_revenue
 from order_details join pizzas
 on pizzas.pizza_id = order_details.pizza_id;
 
 -- 3)Identify the highest-priced pizza.
 select pizza_types.name ,pizzas.price  from pizza_types
 join pizzas
 on pizza_types.pizza_type_id=pizzas.pizza_type_id
 order by pizzas.price desc limit 1;
 
 
-- 4) Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) as total_orders
from pizzas 
join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size
order by total_orders desc limit 1 ;

-- 5)List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as order_quantites
from  pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on  order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by order_quantites desc limit 5 ;

-- Intermediate:
-- 1) Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category ,sum(order_details.quantity) as quantity
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id= pizzas.pizza_id
group by pizza_types.category;

-- 2) Determine the distribution of orders by hour of the day
select hour(order_time) as hours , count(order_id)
from orders 
group by hours;

-- 3) Join relevant tables to find the category-wise distribution of pizzas.
select category, count(pizza_type_id) as total
from pizza_types
group by category;

-- 4) Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(Average),0) from
(select orders.order_date as date , sum(order_details.quantity) as Average
from orders
join order_details
on orders.order_id = order_details.order_id
group by date) as order_quantity;

-- 5) Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name as name, sum(pizzas.price * order_details.quantity)  as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by name
order by revenue desc limit 3;

-- Advanced:
-- 1) Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category as category , round(sum(order_details.quantity * pizzas.price) /
(select round(sum(order_details.quantity * pizzas.price),2)
as total 
from order_details
join pizzas
on order_details.pizza_id = pizzas.pizza_id
)*100,2 )  as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by category;

-- 2) Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over(order by order_date) 
as cum_revenue
from
(select orders.order_date, sum(order_details.quantity * pizzas.price) as revenue
from order_details
join pizzas
on order_details.pizza_id= pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as sales;

-- 3) Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category ,name, revenue
from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as ranking
from
(select pizza_types.category, pizza_types.name as name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id= pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category, name) as a) as b
where ranking < 3;