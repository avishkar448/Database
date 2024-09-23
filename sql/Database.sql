-- show databases;
-- ctrl /- sakfjkdsjl
 -- Select * from clients;
-- SELECT * FROM sql_store.customers;
 
SELECT * FROM sql_store.customers;

SELECT customer_id,first_name,last_name from customers;

select * from customers where customer_id=1;

select customer_id,first_name,last_name,points,points+100 as upadetPoints from customers;
select customer_id,
		first_name,
        last_name,
        points,
        points * 100 +10 as upadetPoints 
        from customers;

select distinct state from customers;

select * from customers where points >3000;

select * from customers where birth_date > '1990-01-01';
select * from customers 
where state ='CA';

select * from customers 
where points > 1000 and state= "TN";

select * from customers
where (birth_date > '1990-01-01' or points > 3000 )and state="FL";

select * from customers
where NOT(birth_date > '1990-01-01' or points > 900);

select * from customers
where (birth_date < '1990-01-01' AND points < 900);

select * from customers 
where state in('FL','VA','GA');

select * from customers 
where state not in('FL','VA','GA');

select * from customers 
where points > 1000 and points < 3000;

select * from customers 
where points between 1000 and 3000;

-- Like 
select * from customers
where last_name like '%y';

select * from customers
where last_name like 'bo%';

select * from customers
where last_name like '%ag%';

select * from customers
where last_name like '_____y';

select * from customers 
where phone  like '%9';

-- Regular expression 

select * from customers
where last_name regexp 'field$';

select * from customers
where phone regexp '^8|^9';

select * from customers
where last_name regexp '[gim]e';

select * from customers
where last_name regexp 'b[a-h]';

select * from customers
where phone is null;

-- Order by
select * from customers 
order by last_name ;

select * from customers
order by points desc;

-- Limit 
select * from customers
limit 3;

select * from customers
limit 6,3;

select * from customers
order by points desc
Limit 3;

-- Join 
select  first_name,last_name,order_id from customers c
join orders o
on c.customer_id =o.customer_id;

select order_id, quantity,name,quantity_in_stock from sql_store.order_items oi
join sql_inventory.products p
on oi.product_id = p.product_id
order by order_id;

select first_name,last_name, c.customer_id from customers c
join orders o
on c.customer_id=o.customer_id
join shippers sh
on o.shipper_id=sh.shipper_id
order by customer_id;

select e.first_name,e.last_name,e.employee_id from sql_hr.employees e
join sql_hr.employees m
on e.reports_to = m.employee_id;

-- left join
select * from customers c
 left join orders o
on c.customer_id=o.customer_id;

-- right join
select * from customers c
join orders o
on c.customer_id=o.customer_id
order by c.customer_id;

-- full join 
select * from customers
full join orders;

-- Using 
select * from customers c
join orders o
using (customer_id);

-- natural join
select * from customers c
natural join orders o;

-- Cross join 
select c.first_name,name 
from customers c
cross join products p
order by c.first_name;

-- Union 
select customer_id, first_name ,points, 'Active' as status
from customers 
where points >=2000
union
select customer_id ,first_name , points, 'Not_Active' as status
from customers
where points < 2000
order by status;

select c.customer_id,first_name,order_date , 'Active' as status 
from customers c
join orders o
on c.customer_id=o.customer_id
where order_date >='2018-05-01'
union
select  c.customer_id,first_name,order_date, 'Not-Active' as status 
from customers c
join orders o
on c.customer_id=o.customer_id
where order_date < '2018-05-01'
order by customer_id;

-- Create table 
Create table Avi(
p_id int not null auto_increment ,
name varchar(20),
phone varchar(10),
state varchar(20),
primary key(p_id));

-- Inserstion 
Insert into Avi 
values
(default,"Avishkar","9730328530","MH"),
(default,"Abhay","9730853214","TN"),
(default,"Akshay","9730853214","WI"),
(default,"Omkar","9730758421","AK");

Insert into avi (name,phone,state) 
values
("Rohit","8754958574","AP"),
("Virat","8754958778","PB"),
("Thala","7854125962","UP");

-- inserting into heirarchical rows
Insert into orders(customer_id,order_date,status) 
values(1,'2003-01-12',2);

select last_insert_id();

insert into order_items 
values (last_insert_id(),9,9,9.0);

-- update 
update avi
set state="MH"
where p_id=2;

update invoices
set payment_total=500, payment_date=null
where invoice_id=6;

update invoices
set payment_total=500 ,payment_date="2040-02-12"
where invoice_id in (3,6);

-- update using subqueries

update invoices
set payment_total=500 ,payment_date="2040-02-12"
where invoice_id in (
select client_id from clients
where name="vinte" 
);

select * from invoices
where payment_date is null;

-- delete
delete from invoices
where invoice_id=5;

-- restoring databases

-- Aggregate function 
select max(invoice_total) as total, 
	   min(invoice_total) as min,
	   avg(invoice_total) as Average,
       count(invoice_id) as id,
       sum(invoice_total) as sum,
       count(*) as total_count,
       count( distinct client_id) as total_client
from invoices;

-- copy table
create table clients_copy as 
select * from clients;

-- truncate - delete all row 
-- drop - delete whole table

-- group by
select client_id,sum(invoice_total) as total
from invoices
group by client_id;


-- having 
select client_id,sum(invoice_total) as total
from invoices
group by client_id
having total > 500
order by total desc;

-- rollup
select client_id,sum(invoice_total) as total
from invoices
group by client_id with rollup;

-- find the product that have been never ordered ?
select * from products 
where product_id not in(
select distinct product_id from order_items);

-- all
-- select invoices larger than all invoices of client id 3
select * from invoices
where invoice_total > (
select max(invoice_total) from invoices
where client_id=3);

select * from invoices
where invoice_total > all(
select invoice_total from invoices
where client_id=3);

-- exsits
-- select client that have an invoices
select * from clients
where client_id in(
select distinct client_id from invoices);

select * from clients c
where exists(
select client_id
from invoices
where client_id=c.client_id);

-- subqueries in select statement
select invoice_id ,invoice_total ,
(select avg(invoice_total) from invoices) as average,
(select average - invoice_total) as difference
from invoices;

-- build in function 
-- Numeric Function

-- round()
select round(invoice_total) from invoices;

-- truncate
select truncate(12.343,2);
select truncate(invoice_total,1) from invoices;

-- celling
select ceiling(5.1);

-- floor
select floor(5.3);

-- abs
select abs(123.434);

-- rand
select rand();

-- String
-- length 
select name,length(name) as length from clients;

-- upper
select upper("avishkar");

-- lower
select lower("AVISHKAR");

-- ltrim
select ltrim("        Avishkar   Gawali");

-- rtrim
select rtrim("        Avishkar   Gawali");

-- trim
select trim("        Avishkar   Gawali");

-- left 
select left("Avishkar",3);

-- right
select right("Avishar",3);

-- substring
select substring("Avishkar",3,5);

-- locate
select locate("a","Avishkar");

-- replace
select replace("Avishkar","A","s");

-- concate
select first_name,last_name,concat(first_name," ",last_name) as full_name from sql_store.customers;

-- Date function
-- now ()
select now();

-- curdate
select curdate();

-- curtime
select current_time();

-- month
select month("2023-05-12");

-- day
select day("2023-05-12");

-- year
select year("2023-05-12");

-- hour
select hour("14:42");

--  minute
select minute("14:42");

-- dayname
select dayname("2023-05-12");

-- monthname
select monthname("2023-05-12");

-- extract
select extract(month from "2023-05-12");

select now();

-- formatting date and time
-- Date formate
select date_format(Now(),"%m");
select date_format(Now(),"%M");

select date_format(now(),"%y");
select date_format(now(),"%Y");

select date_format(now(),"%d");
select date_format(now(),"%D");

select date_format(now(),"%D %M %Y");
select date_format(now(),"%d/%m/%y");

-- Time formate 
select time_format(now(),"%h");
select time_format(now(),"%H");

select time_format(now(),"%i");
select time_format(now(),"%s");

select time_format(now(),"%h:%i:%s");

-- calculating date and time
select date_add(now(),Interval -1 year);
select date_add(date("2034-12-21"),Interval 1 year);
select date_sub(date("2034-12-21"),Interval 1 year);

select datediff("2024-12-31","2025-12-31");

select time_to_sec("00:02:00");

-- If null 
select order_id,shipper_id,
ifnull (shipper_id,"Not assign")
from orders;

-- coalesce
select order_id,shipper_id,comments,
coalesce(shipper_id,comments,"Not assign") as result
from orders;

-- If function
select order_id,order_date,
if(
year(order_date)=year(now()),
"Active","Archived")
from orders;

select * ,
if(points>1500,"power","Non Power") as result
from customers;

select * from orders;
-- Case
select *,
case
when year(order_date) < year("2017-01-01") then "less"
when year(order_date) = year("2018-01-01") then "mid"
when year(order_date) > year("2018-01-01") then "trend"
else "xyz"
end as result
from orders;

-- views
create view xyz as
select * from customers where state in("MA","GA","TN");

-- replace
create or replace view xyz as
select * from products where product_id between 1 and 5;

create or replace view xyz as
select * from invoices where invoice_id between 1 and 5;

-- drop
drop view xyz;

select * from xyz;

-- delete
delete from xyz
where invoice_id=1;


-- update 
update xyz
set payment_total=5000
where invoice_id=3;

-- commit and rollback
select * from avishkar.student;
commit;

update avishkar.student
set fees="123"
where Id=4;
commit;
rollback;
