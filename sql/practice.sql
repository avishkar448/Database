select * from invoices
where  client_id >3
order by client_id;

select invoice_id,client_id,payment_date from invoices i
where i.payment_date in (
select date from payments);

select * from customers where state in("MA","GA","TN");

select * from customers where points between 1000 and 3000;

select first_name,last_name from customers
where first_name like "%a";

select first_name,last_name from customers
where last_name like "b_________";

select * from customers
where phone regexp "^8" and "56$";

select * from customers
where phone IS not null;

select * from customers
where customer_id limit 3,6;

select  oi.product_id, p.name,oi.order_id,p.unit_price
from order_items oi
join products p 
on  oi.product_id=p.product_id ;

select  oi.product_id, p.name,oi.order_id,p.unit_price
from order_items oi
join sql_inventory.products p
on  oi.product_id=p.product_id ;

select  o.customer_id,c.first_name,c.last_name,o.status,oi.unit_price from orders o
join customers c
on o.customer_id=c.customer_id
join order_items oi
on o.order_id=oi.order_id
order by  o.customer_id;

select c.order_id,c.customer_id from orders c
join orders o
on c.customer_id=o.order_id;

select e.employee_id,e.first_name,e.last_name from sql_hr.employees e
join sql_hr.employees r
on e.reports_to=r.employee_id ;

select * from order_items oi,orders o
where oi.order_id=o.order_id;

select * from customers c
right join orders o
on c.customer_id=o.customer_id;

select * from customers 
join orders
using(customer_id) ;

select * from customers
natural join orders;

select * from customers
cross join orders;

select customer_id from customers
union 
select customer_id from orders; 


Insert into avishkar.student(First_Name,Last_Name,course,fees) values("Allu","Arjun","Mtech","97000");
select * from avishkar.student;
delete from avishkar.student
where Id=16;

update avishkar.student
set First_Name="Abhay"
where id=1;
 
 select max(Age) from avishkar.student;
 select min(fees) from avishkar.student;
 select count(distinct course) from avishkar.student;
 
 update avishkar.student
 set fees=100000
where Id in (select invoice_id from sql_invoicing.invoices
where due_date="2019-01-27");

select invoice_id from sql_invoicing.invoices
where due_date="2019-01-27";
 
create table student_copy as
select * from avishkar.student;

select * from student_copy;

Truncate table student_copy;
drop table student_copy;

select * from avishkar.student;
select course,sum(fees) as Total_fees from avishkar.student
group by course with rollup
having Total_fees >50000
order by Total_fees;

select * from avishkar.student ax
where exists(
select client_id from invoices
where client_id=ax.Id
);

select Id,First_Name,Last_Name,(select avg(fees) from avishkar.student) as average from avishkar.student;

select * from avishkar.student
where fees<all(
select fees from avishkar.student
where Id=4);


select current_time();

select time_format(now(),"%s");

select date_add("2024-02-12",interval 4 month);
select date_sub("2024-02-12",interval 4 month);
select datediff("2034-01-01","2024-01-01");
select time_to_sec("12:00:00");

select *  ,isnull("Not assign") from avishkar.student;
select *  ,coalesce(Age,Address,"Not assign") from avishkar.student;

update avishkar.student 
set Address="England"
where isnull();

select * ,
case
when Age<"21" then "Small"
when Age="21" then "mid"
when Age>21 then "big"
end as Result
from avishkar.student;

create or replace view fees_detail as
(select * ,
case
when fees<70000 then "Less fees"
when fees=70000 then "Mid fees"
when fees>70000 then "High fees"
else "Error"
end as Fees_Criteria
from avishkar.student);

drop view fees_detail;

update avi
set fees="2000"
where Id=12;

/* select * from avishkar.student
where not fees > 100000;
*/

select course,sum(fees) as total from student
group by 1
order by total desc
limit 2;

select * from student;

select * ,
case 
when course in("MSC","Mtech") then "Master" 
when course in ("BSC","BCA","Btech") then "Bachelor"
else "error"
end as Result
from student;

select count(distinct course) from student;

select * from avishkar.student
where Id > any(
select invoice_id from invoices
where invoice_id >10
);

select Id,First_Name,Last_Name,Address,ifnull(Address,"Null") as result from avishkar.student;

select max(age) from avishkar.student
where age not in (select max(age) from avishkar.student);

alter table avishkar.student
add xyz varchar(20);

alter table avishkar.student
drop column xyz;

select * from avishkar.student;

select * from student;

select * 
from student
where First_Name regexp 'a[bs]';student


