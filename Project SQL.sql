--create table
 CREATE TABLE employee (
	id int UNIQUE, 
  	name text, 
  	department text,
  	position text,
  	salary real)

--Insert Data
INSERT INTO employee VALUES
	(1, 'David', 'Marketing', 'CEO', 100000),
	(2,'John','Marketing', 'VP',50000),
    (3,'Marry','Sales','Manager', 60000)
    
INSERT INTO employee VALUES
	(4, 'Max', 'Database', 'IT', 30000)

--select data
select 
	id,
    name, 
    salary
from employee

SELECT * from employee

--Transform Column
SELECT 
	name,
    salary,
    salary * 1.5 as newSalary,
    name || '@gmail.com' as email,
    lower(name) || '@gmail.com' as email,
    upper(name) || '@gmail.com' as email
from employee

--Filter data 
SELECT * from employee 
where department = 'Marketing' 
and salary > 30000

SELECT * from employee 
where department in ('Marketing', 'IT') 

SELECT * from employee 
where salary >= 50000

-- update data 
UPDATE employee 
set salary = 200000
where id = 2

--delete data 
DELETE from employee
where name = 'Max'
 
DELETE FROM employee
where id = 1

--SELECT * FROM MyEmployee
ALTER TABLE employee RENAME to myEmployee

alter table myEmployee
add email text 

UPDATE myEmployee 
set email = 'admin@company.com'

SELECT * from myEmployee

-- Copy and Drop Table
CREATE table myEmployee_backup as 
	SELECT * from myEmployee

drop TABLE myEmployee_backup

/* Filter  */
select 
	contactFirstName,
    addressLine1,
    city,
    country
from customers 
where country IN ('Norway', 'USA', 'Spain')

select 
	contactFirstName,
    addressLine1,
    city,
    country
from customers 
where country NOT IN ('Norway', 'USA', 'Spain')

select *
from customers
where customerNumber >= 100 and customerNumber <=130
order by customerNumber 

select *
from orders 
where orderDate between '2003-01-01' and '2003-12-31'

/*  Null  */
select *
from customers
where state is null

select *
from customers
where state is not null

/*  parttern matching  */
select 
	contactFirstName,
    contactLastName,
    phone
from customers
where contactFirstName like 'P%'

select 
	contactFirstName,
    contactLastName,
    phone
from customers
where phone like '%6'

/*  missing values  */
select
	state,
    coalesce(state, 'No State') as stateClean
from customers

select
	state,
    case when state is null then 'No State'
		else 'State'
	end as 'state_clean'
from customers

/*Aggregate Functions */
select 
    SUM(buyPrice) sum_price,
    AVG(buyPrice) avg_price,
    MIN(buyPrice) min_price,
    MAX(buyPrice) max_price
from products

/* นับจำนวน record*/
select 
   count(*),
   count(quantityInStock)
from products

/* นับจำนวน  distinct แบบไม่ซ้ำ*/
select 
   count(distinct customerNumber)
from customers

/*  group by  */
select 
	productName,
    count(*)
from products
group by productLine

select 
	country,
    count(*) as count_country
from customers
group by country

select 
	country,
    count(*) as count_country,
    city,
    count(*)
from customers
group by country, city

/*  having  */
select 
	a.productLine,
    count(*)
from productlines a, products b 
where a.productLine = b.productLine 
and a.productLine <> 'Motorcycles'
group by a.productLine
having count(*) > 10
order by count(*) desc

/*  order by  */
select 
	contactFirstName,
    addressLine1,
    city
from customers
order by city

/*  join  */
select 
	a.employeeNumber,
    a.firstName,
    a.officeCode,
	b.city,
	b.country
from employees a
join offices b
on a.officeCode = b.officeCode

select
	a.orderNumber,
    a.quantityOrdered,
    b.orderDate,
    c.amount
from orderdetails a, orders b, payments c
where a.orderNumber = b.orderNumber
and b.customerNumber = c.customerNumber
having a.orderNumber IN (10100, 10104)

select 
	a.employeeNumber,
    a.firstName,
    b.city 
from employees a 
join offices b 
on a.officeCode = b.officeCode 
where b.city LIKE '%P%'

/*   Convert WHERE to INNER JOIN  */
select 
	a.employeeNumber,
    a.firstName,
    b.city 
from employees a , offices b 
where a.officeCode = b.officeCode 
and b.city LIKE '%P%'

select 
	a.employeeNumber,
    a.firstName,
    b.city 
from employees a 
join offices b 
on a.officeCode = b.officeCode 
where b.city LIKE '%P%'

/*   Left Join  */
select *
from customers a 
left join employees b 
on a.salesRepEmployeeNumber = b.employeeNumber

/*   cross join  */
select * from customers 
cross join employees 
order by customerNumber

/*   Union  */
create TABLE movie (
  	id INT,
  	name TEXT,
 	release_year INT
  );

INSERT INTO movie_new VALUES
  (1, 'King Richard', 2021),
  (2, 'Eternals', 2021),
  (3, 'Spider-Man: No Way Home', 2021),
  (4, 'Dune', 2021),
  (5, "Don't Look Up", 2021)

create TABLE movie_new (
  	id INT,
  	name TEXT,
 	release_year INT
  );

INSERT INTO movie_new VALUES
  (6, 'The Batman', 2022),
  (7, 'Fantastic Beasts: The Secrets of Dumbledore', 2022),
  (8, 'Sonic the Hedgehog 2', 2022);

select * from movie
union
select * from movie_new


/* self join */
CREATE table employee (
	id int,
 	fullname text,
  	salary int,
  	managerid int
)

INSERT into employee VALUES 
(1, 'John Smith', 10000, 3),
(2, 'Jane Anderson', 15000, 3),
(3, 'Tom Lanon', 35000, 4),
(4, 'Anne Connor', 25000, 1),
(5, 'Jeremy York', 50000, 1)

/* subquery */
--WHERE clause
select * from products 
where buyPrice = (select max(buyPrice) from products)

select * 
from employees
where employeeNumber IN (
	select salesRepEmployeeNumber
    from customers
    where country IN ('France', 'USA') 
)

select 
	productName,
    buyPrice
from products
where buyPrice > (
	select avg(buyPrice)
    from products
)

select 
	productLine
from productlines
where productLine IN (
	select distinct productLine
    from products
)
order by buyPrice DESC

--FROM clause
select customerName, addressLine1, city from
(select * 
from customers
where country = 'USA')

select 
	max(oNumber),
	min(oNumber),
    round(avg(oNumber),0)
from
(
	select 
		orderNumber,
        count(orderNumber) as oNumber
	from orderdetails
	group by orderNumber
) as lineitems

-- join
select 
	a.customerNumber,
    a.customerName,
    a.contactFirstName,
    b.total
from customers a
join (
	select 
		customerNumber,
        sum(amount) as total
	from payments 
    group by customerNumber) b
on a.customerNumber = b.customerNumber
order by b.total desc

-- SELECT clause
select 
	customerNumber,
    customerName,
    (select sum(amount) from payments b
    where a.customerNumber = b.customerNumber) totalAmount
from customers a
order by totalAmount desc
-- correlated subquery
select 
	productName,
    buyPrice,
    (select count(*) from orderdetails a
    where a.productCode = b.productCode) Numberorder
from products b 
order by 3 desc

/* window functions */
-- ROW_NUMBER()
select 
	customerName,
    row_number() over() as rowNumber
from customers

-- row_number partition by country
select 
	customerName,
    country,
    row_number() over(partition by country) as rowNumber
from customers

select 
	customerName,
    country,
    row_number() over(partition by country order by customerName) as rowNumber
from customers 
where country = 'Germany'

-- RANK()
select 
	buyPrice,
	rank() over(order by buyPrice) rankbuyPrice
from products

--NTILE()
select 
	productName,
    productLine,
    ntile(5) over(order by productLine) as segment
from products

-- SUM() OVER()
select 
	orderNumber,
    priceEach,
    sum(priceEach) over(order by orderNumber) as Running_Total
from orderdetails
group by orderNumber




