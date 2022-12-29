-- STUDENT NAME
-- CSC 256, Fall 2022, Project 7

-- change the output of null values
\pset null '<null>'

------------------------------------------------------------------------------
-- Problem  1
select 'Problem 1' as problem;
--
-- Write a query to return the three films with the shortest length and include
-- ties. Order the results first by shortest to longest length and then by
-- title in alphabetical order. Note: using LIMIT is not correct because the
-- results are arbitrary.
--
-- Expected output:
--
--         title         | length | rating 
-- ----------------------+--------+--------
--  APOCALYPSE FLAMINGOS |      0 | R
--  ALIEN CENTER         |     46 | NC-17
--  IRON MOON            |     46 | PG
--  KWAI HOMEWARD        |     46 | PG-13
--  LABYRINTH LEAGUE     |     46 | PG-13
--  RIDGEMONT SUBMARINE  |     46 | PG-13
-- (6 rows)
------------------------------------------------------------------------------
with t as (
select
	title,
	length,
	rating,
	rank() over w 
from film
window w as (order by length)
)
select title, length, rating
from t 
where rank < 3;

------------------------------------------------------------------------------
-- Problem 2
select 'Problem 2' as problem;
--
-- Write a query to return the first four rentals that each customer rented.
-- Order the results first by customer_id and second by rental_date.
--
-- Expected Output:
--
--  rental_id | customer_id |     rental_date     
-- -----------+-------------+---------------------
--         76 |           1 | 2005-05-25 11:30:37
--        573 |           1 | 2005-05-28 10:35:23
--       1185 |           1 | 2005-06-15 00:54:12
--       1422 |           1 | 2005-06-15 18:02:53
-- ...
--(2396 rows)
------------------------------------------------------------------------------
with t as (
select 
	rental_id,
	customer_id,
	rental_date,
	row_number() over (partition by customer_id order by rental_date asc)
from rental)
select rental_id, customer_id, rental_date
from t
where row_number < 5;
------------------------------------------------------------------------------
-- Problem 3
select 'Problem 3' as problem;
--
-- Write a query to return the customer IDs who rented out the third most
-- popular film including ties if there is more than one film that could be
-- considered the third most popular. Order the results by customer_id.
--
-- Expected Output:
--
-- customer_id 
---------------
--           2
--           6
--           7
--...
--(141 rows)
------------------------------------------------------------------------------
with t1 as (
	select
		i.film_id,
		count(i.inventory_id)
	from rental
		inner join inventory as i
		using(inventory_id)
	group by i.film_id
), 
t2 as (
	select 
		film_id, 
		dense_rank() over (order by count desc)
	from t1
)
select distinct customer_id
from rental as r
    inner join inventory as inv
    on r.inventory_id = inv.inventory_id
where inv.film_id in (
select film_id
from t2
where dense_rank = 3)
order by customer_id;
;
------------------------------------------------------------------------------
-- Problem 4
select 'Problem 4' as problem;
--
-- Write a query to return all the distinct film lengths without using
-- the DISTINCT keyword. Order the results by length.
--
-- Expected Output:
--
--  length 
-- --------
--       0
--      46
--      47
-- ...
-- (141 rows)
------------------------------------------------------------------------------

-- select 
-- 	length
-- from film
-- where length is not null
-- group by length
-- order by length;


with t1 as ( 
    select length,
    row_number() over (partition by length order by length)
    from film
) select length from t1 where row_number = 1 and length is not null;


------------------------------------------------------------------------------
-- Problem 5
select 'Problem 5' as problem;
--
-- Write a query compute the deviation in film length by rating. The deviation
-- is the absolute value of the film length minus the average film length among
-- the films with the same rating. Order the results first by rating, then
-- by title.
--
-- Expected output:
--
--             title            | rating |      deviation       
-- -----------------------------+--------+----------------------
--  CAT CONEHEADS               | G      |   0.9494382022471910
--  JAWS HARRY                  | G      |   0.9494382022471910
--  WATERSHIP FRONTIER          | G      |   0.9494382022471910
-- ...
-- (1000 rows)
------------------------------------------------------------------------------

select 
	title,
	rating,
    abs(length - avg(length) over (partition by rating)) as deviation
from film
order by rating, deviation;

------------------------------------------------------------------------------
-- Problem 6
select 'Problem 6' as problem;
--
-- Write a query to return the average rental duration for each customer
-- without using GROUP BY. Order the results by customer_id.
--
-- Expected Output:
--
--  customer_id |          avg           
-- -------------+------------------------
--            1 | 4 days 11:18:07.5
--            2 | 5 days 12:36:06.666667
--            3 | 5 days 21:19:25.384616
-- ...
-- (599 rows)
------------------------------------------------------------------------------

select 
	distinct customer_id,
	avg(return_date - rental_date) over (partition by customer_id)
from rental
order by customer_id;

------------------------------------------------------------------------------
-- Problem 7
select 'Problem 7' as problem;
--
-- Write a query to that lists for each day the date, the total amount of money
-- received that day, and a running total of all payments received up to and
-- including that day. Start the results at the first day payments were
-- received and end the results at the last day payments were received.
--
-- Expected Output:
--
--           day           | amount  | running_total 
-- ------------------------+---------+---------------
--  2007-01-24 00:00:00-05 |   86.81 |         86.81
--  2007-01-25 00:00:00-05 |  568.61 |        655.42
--  2007-01-26 00:00:00-05 |  743.30 |       1398.72
--  2007-01-27 00:00:00-05 |  708.27 |       2106.99
--  2007-01-28 00:00:00-05 |  793.10 |       2900.09
--  2007-01-29 00:00:00-05 |  655.42 |       3555.51
--  2007-01-30 00:00:00-05 |  622.41 |       4177.92
--  2007-01-31 00:00:00-05 |  646.51 |       4824.43
--  2007-02-01 00:00:00-05 |       0 |       4824.43
--  2007-02-02 00:00:00-05 |       0 |       4824.43
-- ...
-- (111 rows)
------------------------------------------------------------------------------

-- select
--   title,
--   rating,
--   length,
--   sum(length) over (partition by rating 
--                     order by length
--                     rows between unbounded preceding and unbounded following
--                     )
-- from film;

-- with t1 as (
-- 	select generate_series(
-- 		min(payment_date), max(payment_date), '1 day'
-- 	) as series
-- from payment
-- group by amount
-- )
-- select 
-- 	series as day
-- from t1;
------------------------------------------------------------------------------
-- Problem 8
select 'Problem 8' as problem;
--
-- Write a query to return the two lowest earning films in each category
-- including ties. To calculate the income for a film, multiply the rental rate
-- by the total number of times it was rented out.
--
-- Expected Output:
--
--         title        | rating | income 
-- ---------------------+--------+--------
--  JAPANESE RUN        | G      |   5.94
--  WATERSHIP FRONTIER  | G      |   5.94
--  OKLAHOMA JUMANJI    | PG     |   5.94
-- ...
-- (17 rows)
------------------------------------------------------------------------------

with t1 as (select
	i.film_id,
	count(*)
from rental
	inner join inventory as i 
	using(inventory_id)
group by i.film_id
order by count
),
t2 as (select film_id, 
	f.title, 
	f.rating, 
	count*rental_rate as cnt,
	rank() over (partition by f.rating order by (count*rental_rate)) 
from t1
	inner join film as f
	using(film_id)
)
select title, rating, cnt as income
from t2
where rank < 3;
;

-- need to solve case of ties

------------------------------------------------------------------------------
-- Problem 9
select 'Problem 9' as problem;
--
-- Write a query to find the missing rental_id values under the assumption that
-- rental_id values are supposed to be assigned in sequential order. Order the
-- results by rental_id.
--
-- Expected Output:
--
--  rental_id 
-- -----------
--        321
--       2247
--       6579
--       9426
--      15592
-- (5 rows)
------------------------------------------------------------------------------

with t1 as (select 
	rental_id,
	rental_id - lag(rental_id, 1) over (order by rental_id) as missing
from rental)
select rental_id - 1 as rental_id
from t1 
where missing > 1;

------------------------------------------------------------------------------
-- Problem 10
select 'Problem 10' as problem;
--
-- Write a query to calculate the minimum time between rentals for each
-- customer. Order the results first from longest time to shortest time, then
-- by customer_id.
--
-- Expected Output:
--
--  customer_id | min_time_between_rentals 
-- -------------+--------------------------
--          310 | 07:56:59
--          525 | 07:11:38
--          505 | 07:03:35
-- ...
-- (599 rows)
------------------------------------------------------------------------------

with t1 as (select
	r1.customer_id,
	r2.rental_date-
	r1.rental_date as min_time_between_rentals
from rental as r1
	inner join rental as r2 
	on r1.customer_id = r2.customer_id
	and r1.rental_date < r2.rental_date)
select 
	distinct customer_id,
	min(min_time_between_rentals) over (partition by customer_id) as min_time_between_rentals
from t1
order by min_time_between_rentals desc, customer_id;