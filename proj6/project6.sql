-- Gabriel Leffew
-- CSC 256, Fall 2022, Project 6

-- change the output of null values
\pset null '<null>'

------------------------------------------------------------------------------
-- Problem 1
--
-- Write a query to return all the customers who made a rental on the first
-- day the rental was available.
--
-- Tables: rental, customer
--
-- Expected Output:
--
--  first_name |  last_name  
-- ------------+-------------
--  DELORES    | HANSEN
--  MANUEL     | MURRELL
--  CASSANDRA  | WALTERS
--  TOMMY      | COLLAZO
--  MINNIE     | ROMERO
--  CHARLOTTE  | HUNTER
--  NELSON     | CHRISTENSON
--  ANDREW     | PURDY
-- (8 rows)
------------------------------------------------------------------------------
select c.first_name, c.last_name
from rental 
    left join customer as c 
    using(customer_id)
where rental_date::date = (select min(rental_date::date) 
from rental);

------------------------------------------------------------------------------
-- Problem 2
--
-- Write a query to return the films that do not have any actors two different
-- ways, first using a subquery and then using a left join. In a comment,
-- write down which solution you find easier to read.
--
-- Tables: film, film_actor
-- 
-- Expected Output:
--
--  film_id |      title       
-- ---------+------------------
--      257 | DRUMLINE CYCLONE
--      323 | FLIGHT LIES
--      803 | SLACKER LIAISONS
-- (3 rows)
------------------------------------------------------------------------------

--subquery
select film_id, title
from film 
where film_id not in 
(select film_id 
from film_actor
 where actor_id is not null);

--join
select f.film_id, f.title 
from film as f
    left join film_actor as fa 
    using(film_id)
where fa.actor_id is null;


------------------------------------------------------------------------------
-- Problem 3
--
-- Write a query to return the customers who rented out the least popular film
-- (that is, the film least rented out - if there is more than one, pick the
-- one with the lowest film ID.)
--
-- Tables: rental, inventory, customer
--
-- Expected Output:
--
--  customer_id | first_name | last_name 
-- -------------+------------+-----------
--          257 | MARSHA     | DOUGLAS
--          142 | APRIL      | BURNS
--          564 | BOB        | PFEIFFER
--           89 | JULIA      | FLORES
-- (4 rows)
------------------------------------------------------------------------------

select c.customer_id, first_name, last_name
from customer as c
    inner join rental as r
    on c.customer_id = r.customer_id
    inner join inventory as inv
    on r.inventory_id = inv.inventory_id
where inv.film_id = (
    select film_id
    from rental
        inner join inventory as i 
        using(inventory_id)
    group by i.film_id
    order by count(i.inventory_id), i.film_id
    limit 1
);


------------------------------------------------------------------------------
-- Problem 4
--
-- Write a query to return the countries in our database that have more than 15
-- cities.
--
-- Tables: country, city
--
-- Expected Output:
--
--       country       
-- --------------------
--  Brazil
--  China
--  India
--  Japan
--  Mexico
--  Philippines
--  Russian Federation
--  United States
-- (8 rows)
------------------------------------------------------------------------------

select country 
from country 
where country_id in 
    (select country_id 
    from city 
    group by country_id 
    having count(city) > 15)
order by country asc;

------------------------------------------------------------------------------
-- Problem 5
--
-- Write a query to return for each customer the store they most commonly rent
-- from.
--
-- Tables: customer, rental, inventory
--
-- Expected Output:
--
--  customer_id | first_name  |  last_name   | favorite_store 
-- -------------+-------------+--------------+----------------
--            1 | MARY        | SMITH        |              1
--            2 | PATRICIA    | JOHNSON      |              1
--            3 | LINDA       | WILLIAMS     |              1
--            4 | BARBARA     | JONES        |              2
--            5 | ELIZABETH   | BROWN        |              2
--            6 | JENNIFER    | DAVIS        |              1
--            7 | MARIA       | MILLER       |              1
--            8 | SUSAN       | WILSON       |              2
-- ...
-- (599 rows)
------------------------------------------------------------------------------

select 
    c.customer_id,
    first_name,
    last_name,
    (select i.store_id
    from rental as r 
	    inner join inventory as i
	    using(inventory_id)
	where customer_id = c.customer_id
    group by i.store_id
    order by count(*) desc
    limit 1) as favorite_store
from customer as c;


------------------------------------------------------------------------------
-- Problem 6
--
-- Write a query to list for each customer whether they have ever rented a film
-- from a different store than that one they originally registered at.
-- registered at. Return 'Yes' if they have, and 'No' if they have not. Note:
-- the customer table has the store ID where a customer registered at.
--
-- Tables: rental, inventory, customer
--
-- Expected Output:
--
--  first_name  |  last_name   | rented_from_other_store 
-- -------------+--------------+-------------------------
--  MARY        | SMITH        | Yes
--  PATRICIA    | JOHNSON      | Yes
--  LINDA       | WILLIAMS     | Yes
-- ...
-- (599 rows)
------------------------------------------------------------------------------


select c.first_name, c.last_name, case
    when c.store_id not in (select store_id from inventory)
    then 'No'
    else 'Yes'
    end as rented_from_other_store
from rental
    inner join inventory as inv using(inventory_id)
    inner join customer as c using(customer_id)
group by c.customer_id
order by c.customer_id;


------------------------------------------------------------------------------
-- Problem 7
--
-- Write a query to return the number of rentals the business gets on average
-- on each day of the week. Order the results to show the days of the week with
-- the highest average number of rentals first (rounded to the nearest
-- integer.) For simplicity, do not worry about days in which there were no
-- rentals.
--
-- Table: rental
--
-- Expected Output:
--
--  day_name  | average 
-- -----------+---------
--  Sunday    |     464
--  Saturday  |     462
--  Friday    |     454
--  Monday    |     449
--  Wednesday |     446
--  Thursday  |     440
--  Tuesday   |     224
-- (7 rows)
------------------------------------------------------------------------------


-- correct?
/*
select day_name, 
round(avg(count)/5) as average from (
    select to_char(rental_date, 'Day') as day_name,
    count(*) 
    from rental 
    group by to_char(rental_date, 'Day')
) as r 
group by day_name
order by average desc;
*/

-- answer 
select 
	to_char(rent_day, 'Day') as day_name,
	round(avg(count)) as average
from (select 
		date_trunc('day', rental_date) as rent_day,
		count(*)
	from rental
	group by rent_day) as f
group by day_name
order by average desc;

------------------------------------------------------------------------------
-- Problem 8
--
-- Write a query to list the customers who rented out the film with title
-- "BRIDE INTRIGUE" and then at some later date rented out the film with title
-- "STAR OPERATION". Use a CTE to simplify your code if possible.
--
-- Tables: rental, inventory, film
--
-- Expected Output:
--
--  customer_id 
-- -------------
--          459
--           25
-- (2 rows)
------------------------------------------------------------------------------
/*
with CTE as (
    select r1.customer_id
    from rental as r1
        inner join inventory as i1
            using(inventory_id)
        inner join rental as r2
            on r1.customer_id = r2.customer_id
            and r2.rental_date > r1.rental_date
        inner join inventory as i2
		    on r2.inventory_id = i2.inventory_id
        inner join film as f1
            on i1.film_id = f1.film_id
        inner join film as f2 
            on i2.film_id = f2.film_id
where f1.title = 'BRIDE INTRIGUE' and f2.title = 'STAR OPERATION'
) 
select customer_id from CTE;
*/

--correct answer
with t as (
	select r.customer_id, r.rental_date, f.title
	from rental as r 
		inner join inventory using(inventory_id)
		inner join film as f using(film_id)
)
select t1.customer_id
from t as t1
	inner join t as t2
		on t1.customer_id = t2.customer_id
		and t2.rental_date > t1.rental_date
		and t1.title = 'BRIDE INTRIGUE'
		and t2.title = 'STAR OPERATION'
;

------------------------------------------------------------------------------
-- Problem 9
--
-- Write a query to calculate the amount of income received each month and
-- compare that against the previous month's income, showing the change.
--
-- Table: payment
--
-- Expected Output:
--
--         month        |  income  | prev month income |  change   
-- ---------------------+----------+-------------------+-----------
--  2007-01-01 00:00:00 |  4824.43 |                   |          
--  2007-02-01 00:00:00 |  9631.88 |           4824.43 |   4807.45
--  2007-03-01 00:00:00 | 23886.56 |           9631.88 |  14254.68
--  2007-04-01 00:00:00 | 28559.46 |          23886.56 |   4672.90
--  2007-05-01 00:00:00 |   514.18 |          28559.46 | -28045.28
-- (5 rows)
------------------------------------------------------------------------------

--correct answer 
with t as (
	select 
		date_trunc('month', payment_date) as month,
		sum(amount) as income
	from payment 
	group by month
)
select 
	curr.month as month,
	curr.income as income,
	prev.income "prev month income",
	curr.income - prev.income  as change
from t as curr 
	left outer join t as prev
	on curr.month = prev.month + '1 month';

------------------------------------------------------------------------------
-- Problem 10
--
-- Write a query to list the top three countries that customers are from.
-- Show the number of customers and the percentage of customers (rounded to
-- the nearest integer.)
--
-- Tables: customer, address, city, country
--
-- Expected Output:
--
--     country    | num_customers | percent 
-- ---------------+---------------+---------
--  India         |            60 |      10
--  China         |            53 |       9
--  United States |            36 |       6
-- (3 rows)
------------------------------------------------------------------------------

-- get count for each country 

select c.country, 
count(customer_id) as num_customers,
round(count(customer_id)::FLOAT/(select count(*) from customer)::FLOAT*100) as percent
from customer   
    inner join address using(address_id)
    inner join city using(city_id)
    inner join country as c using(country_id)
group by country_id
order by num_customers desc
limit 3;



    
--select count diff query 
