-- Gabriel Leffew
-- CSC 256, Fall 2022, Project 5

-- change the output of null values
\pset null '<null>'

------------------------------------------------------------------------------
-- Problem 1
--
-- Write a query to return a list of all the films rented by PETER MENARD
-- ordered by the most recent first. (inner join)
--
-- Tables: rental, customer, inventory, film
--
-- Expected Output:
--
--      rental_date     |         title         
-- ---------------------+-----------------------
--  2005-08-23 18:43:31 | OCTOBER SUBMARINE
--  2005-08-22 09:10:21 | PRIDE ALAMO
--  2005-08-21 08:40:56 | FUGITIVE MAGUIRE
--  2005-08-20 12:53:46 | BRIGHT ENCOUNTERS
--  2005-08-19 10:06:53 | REDEMPTION COMFORTS
-- ...
-- (23 rows)
------------------------------------------------------------------------------

select r.rental_date, f.title
from rental as r 
    inner join customer as c
    on r.customer_id = c.customer_id
    and c.first_name = 'PETER'
    and c.last_name = 'MENARD'
    inner join inventory as inv
    on r.inventory_id = inv.inventory_id
    inner join film as f
    on inv.film_id = f.film_id
order by r.rental_date desc;


------------------------------------------------------------------------------
-- Problem 2
--
-- Write a query to list the full names and email addresses for the manager of
-- each store. (inner join)
--
-- Tables: store, staff
--
-- Expected Output:
--
--  store_id |   Manager    |            email             
-- ----------+--------------+------------------------------
--         1 | Mike Hillyer | Mike.Hillyer@sakilastaff.com
--         2 | Jon Stephens | Jon.Stephens@sakilastaff.com
-- (2 rows)
------------------------------------------------------------------------------

select store.store_id, 
    first_name|| ' ' || staff.last_name as "Manager",
    staff.email as email
from store
    inner join staff
    on store.store_id = staff.store_id
group by store.store_id, staff.first_name, staff.last_name, staff.email;

------------------------------------------------------------------------------
-- Problem 3
--
-- Write a query to return the top three most rented out films and how many
-- times they have been rented out. (inner join)
-- 
-- Table(s) to use: rental, inventory, film
-- 
-- Expected Output:
-- 
--  film_id |       title        | count 
-- ---------+--------------------+-------
--      103 | BUCKET BROTHERHOOD |    34
--      738 | ROCKETEER MOTHER   |    33
--      489 | JUGGLER HARDLY     |    32
-- (3 rows)
------------------------------------------------------------------------------

select inv.film_id, f.title, count(r.rental_id)
from rental as r 
    inner join inventory as inv
    on r.inventory_id = inv.inventory_id
    inner join film as f 
    on inv.film_id = f.film_id
group by inv.film_id, f.title
order by count desc
limit 3;



------------------------------------------------------------------------------
-- Problem 4
--
-- Write a query to show for each customer how many distinct films
-- they have rented and how many distinct actors they have seen in the films
-- that they have rented. (inner joins)
-- 
-- Tables: rental, inventory, film, film_actor
--
-- Expected Output:
--
--  customer_id | num_films | num_actors 
-- -------------+-----------+------------
--            1 |        30 |        108
--            2 |        27 |        118
--            3 |        26 |        103
--            4 |        22 |         89
--            5 |        38 |        119
-- (599 rows)
------------------------------------------------------------------------------

select r.customer_id, count(distinct inv.film_id) as num_films, count(distinct fa.actor_id)
from rental as r 
    inner join inventory as inv
    on r.inventory_id = inv.inventory_id
    inner join film as f 
    on inv.film_id = f.film_id
    inner join film_actor as fa 
    on f.film_id = fa.film_id
group by customer_id;



------------------------------------------------------------------------------
-- Problem 5
--
-- When you search for information about joins, you will still find references
-- using the older style of inner joins. Rewrite the following query that
-- is written in the older style into the modern style.
--
-- select film.title, language.name as "language"
-- from film, language
-- where film.language_id = language.language_id;
--
-- Tables: film, language
--
-- Expected Output:
--
--             title            |       language       
-- -----------------------------+----------------------
--  ACADEMY DINOSAUR            | English             
--  ACE GOLDFINGER              | English             
--  ADAPTATION HOLES            | English             
--  AFFAIR PREJUDICE            | English             
--  AFRICAN EGG                 | English             
-- ...
-- (1000 rows)
------------------------------------------------------------------------------

select f.title, l.name as language
from film as f 
    inner join language as l 
    on f.language_id = l.language_id
group by f.title, l.name
order by f.title asc;

------------------------------------------------------------------------------
-- Problem 6
--
-- Write a query to return the films that are not in stock in any of the
-- stores. (outer join)
--
-- Tables: film, inventory
--
-- Expected Output:
--
--          title          
-- ------------------------
--  SKY MIRACLE
--  KILL BROTHERHOOD
--  SISTER FREDDY
--  GLADIATOR WESTWARD
--  FLOATS GARDEN
-- ...
-- (42 rows)
------------------------------------------------------------------------------

select f.title
from film as f
    left outer join inventory as inv
    on f.film_id = inv.film_id
where inv.inventory_id is null;


------------------------------------------------------------------------------
-- Problem 7
--
-- Write a query to return a count of how many of each film we have in our
-- inventory (include all films). Order the output from lowest in-stock
-- to highest in-stock. (outer join)
--
-- Tables: film, inventory
--
-- Expected Output:
--
-- title                      |count|
-- ---------------------------|-----|
-- CHOCOLATE DUCK             |    0|
-- FRANKENSTEIN STRANGER      |    0|
-- APOLLO TEEN                |    0|
-- HOCUS FRIDA                |    0|
-- WAKE JAWS                  |    0|
-- SUICIDES SILENCE           |    0|
-- GUMP DATE                  |    0|
-- BUTCH PANTHER              |    0|
-- ...
--
-- 1000 rows
------------------------------------------------------------------------------

select f.title, count(inv.film_id)
from film as f
    left outer join inventory as inv 
    on f.film_id = inv.film_id
group by f.film_id
order by count;

------------------------------------------------------------------------------
-- Problem 8
--
-- Write a query to return a count of the number of films rented by every
-- customer on the 24th May, 2005. Order the results by number of films rented
-- descending. (outer join) Hint: you need more than one join condition.
-- 
-- Table: customer, rental
-- 
-- Expected Output:
--
--  customer_id | num_rented 
-- -------------+------------
--          130 |          1
--          222 |          1
--          239 |          1
--          269 |          1
--          333 |          1
-- ...
-- (599 rows)
------------------------------------------------------------------------------

select c.customer_id, count(r.rental_date) as num_rented
from customer as c
    left outer join rental as r 
    on c.customer_id = r.customer_id
    and r.rental_date::date = timestamp '2005-05-24'
group by c.customer_id
order by num_rented desc, customer_id;

------------------------------------------------------------------------------
-- Problem 9
--
-- Write a query to return how many copies of each film are available in
-- each store, including zero counts if there are none. Order by count
-- ascending. (cross join, outer join)
--
-- Tables: film, store, inventory
--
-- Expected Output:
--
--  film_id | store_id | stock 
-- ---------+----------+-------
--        2 |        1 |     0
--        3 |        1 |     0
--        5 |        1 |     0
--        8 |        1 |     0
--       13 |        1 |     0
-- (2000 rows)
------------------------------------------------------------------------------
/*
select f.film_id, s.store_id, 
count(*) as stock
from film as f
    cross join store as s
    left outer join inventory as inv
    on f.film_id = inv.film_id
group by f.film_id, s.store_id
order by store_id, stock;
*/
select 
	f.film_id,
	s.store_id,
	count(i.inventory_id) as stock
from film as f
	cross join store as s
	left join inventory as i
	on f.film_id = i.film_id
	and s.store_id = i.store_id
group by f.film_id, s.store_id
order by stock;
-- I give up

------------------------------------------------------------------------------
-- Problem 10
--
-- Write a query using the generate_series function to return the number
-- of rentals for each month in 2005. Note that we can join on the result of
-- generate_series function.
--
-- Table: rental
--
-- Expected Output:
--
--           t          | count 
-- ---------------------+-------
--  2005-01-01 00:00:00 |     0
--  2005-02-01 00:00:00 |     0
--  2005-03-01 00:00:00 |     0
--  2005-04-01 00:00:00 |     0
--  2005-05-01 00:00:00 |  1156
--  2005-06-01 00:00:00 |  2311
--  2005-07-01 00:00:00 |  6709
--  2005-08-01 00:00:00 |  5686
--  2005-09-01 00:00:00 |     0
--  2005-10-01 00:00:00 |     0
--  2005-11-01 00:00:00 |     0
--  2005-12-01 00:00:00 |     0
-- (12 rows)
------------------------------------------------------------------------------

select series as t, 
count(
    case when extract('year' from rental_date) = 2005
    then 1
    end
)
from generate_series(
    timestamp '2005-01-01', timestamp '2005-12-31',
    interval '1 month'
) as series 
left outer join rental as r
on extract(month from series) = extract(month from r.rental_date::date)
group by 1
order by 1;

------------------------------------------------------------------------------
-- Bonus Problem
--
-- Write a query to list the customers who rented out the film with ID 97 and
-- then at some later date rented out the film with ID 841. This is a tricky
-- problem that requires a self-join with an additional inner join.
--
-- Tables: rental, inventory
--
-- Expected Output:
--
--  customer_id 
-- -------------
--          459
--           25
-- (2 rows)
------------------------------------------------------------------------------

select r1.customer_id
from rental as r1 
	inner join inventory as i1 
		using(inventory_id)
	inner join rental as r2 
		on r1.customer_id = r2.customer_id
		and r2.rental_date > r1.rental_date
	inner join inventory as i2
		on r2.inventory_id = i2.inventory_id
where i1.film_id = 97 and i2.film_id = 841;
