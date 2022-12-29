-- STUDENT NAME
-- CSC 256, Fall 2022, Project 8

-- change the output of null values
\pset null '<null>'

-- Note: you must use set operations for each query.

------------------------------------------------------------------------------
-- Problem  1
select 'Problem 1' as problem;
--
-- Write a query to return all the names from any tables that have names. Order
-- the results by first_name, last_name.
------------------------------------------------------------------------------

(select first_name, last_name
from actor)
union 
(select first_name, last_name
from customer)
order by first_name, last_name;


------------------------------------------------------------------------------
-- Problem  2
select 'Problem 2' as problem;
--
-- Write a query to list out all the distinct dates where there was a customer
-- interaction event (a rental or a payment). Order the results by date.
------------------------------------------------------------------------------
--rental date and return date

(select distinct rental_date::DATE as date
from rental)
union
(select distinct payment_date::DATE
from payment)
order by date;


------------------------------------------------------------------------------
-- Problem  3
select 'Problem 3' as problem;
--
-- Write a query to return the actors that have the same name as customers.
-- Order the results by first_name, last_name.
------------------------------------------------------------------------------

(select first_name, last_name
from customer)
intersect 
(select first_name, last_name
from actor)
order by first_name, last_name;

------------------------------------------------------------------------------
-- Problem  4
select 'Problem 4' as problem;
--
-- Write a query to return the film titles that have the actors JAMES PITT,
-- MARY KEITEL, and UMA WOOD in the film. Order the results by title.
------------------------------------------------------------------------------

(select title
from film 
   inner join film_actor using(film_id)
   inner join actor as a 
   on a.actor_id = film_actor.actor_id
   and concat(first_name, ' ', last_name) = 'JAMES PITT')
intersect
(select title
from film 
   inner join film_actor using(film_id)
   inner join actor as a 
   on a.actor_id = film_actor.actor_id
   and concat(first_name, ' ', last_name) = 'MARY KEITEL')
intersect
(select title
from film 
   inner join film_actor using(film_id)
   inner join actor as a 
   on a.actor_id = film_actor.actor_id
   and concat(first_name, ' ', last_name) = 'UMA WOOD')
order by title;



-- (select film_id
-- from film)
-- intersect 
-- (select film_id
-- from film 
--    inner join film_actor using(film_id)
--    inner join actor as a 
--    on a.actor_id = film_actor.actor_id
--    and concat(first_name, ' ', last_name) = 'JAMES PITT'
--    and concat(first_name, ' ', last_name) = 'MARY KEITEL')
--    ;

------------------------------------------------------------------------------
-- Problem  5
select 'Problem 5' as problem;
--
-- Write a query to list all film_id values from films that have never been
-- rented out. Order the results by film_id.
------------------------------------------------------------------------------

--rental,inventory,film 

-- (select film_id
--    from inventory)
-- except 
-- (select film_id
--    from inventory
--       inner join rental as r 
--       using(inventory_id)
--    group by count(r.rental)
-- ;
with t1 as (select film_id, count(rental_id) as count
   from inventory
   inner join rental using(inventory_id)
group by film_id
order by count)
(select film_id
from film)
except
(select film_id
from t1)
order by film_id;

------------------------------------------------------------------------------
-- Problem  6
select 'Problem 6' as problem;
--
-- Write a query to find the missing rental_id values under the assumption that
-- rental_id values are supposed to be assigned in sequential order. You must
-- use the generate_series function and EXCEPT. Order the results by rental_id.
------------------------------------------------------------------------------


(select generate_series(min(rental_id), max(rental_id)) as missing_id
from rental)
except
(select rental_id
from rental)
order by missing_id;

------------------------------------------------------------------------------
-- Problem  7
select 'Problem 7' as problem;
--
-- Write a query to return the customer names who have rented out a film on a
-- weekend day, but never on a week day. Order the customers by first_name,
-- last_name.
------------------------------------------------------------------------------


(select first_name, last_name
from rental 
   inner join customer 
   using(customer_id)
where extract(dow from rental_date) in (0, 6))
except
(select first_name, last_name
from rental 
   inner join customer 
   using(customer_id)
where extract(dow from rental_date) in (1, 2, 3, 4, 5))
order by first_name, last_name;
--hope this is right


------------------------------------------------------------------------------
-- Problem  8
select 'Problem 8' as problem;
--
-- Write a query to list out all the distinct dates where there was a customer
-- interaction event (a rental or a payment). Include the customer_id and the
-- type of the event in the output where the type is "rental" or "payment".
-- Order the results by date, customer_id. Note that this is an extension of
-- Problem 1.
------------------------------------------------------------------------------

(select distinct rental_date::DATE as date,
first_value(customer_id) over () as customer_id,
'rental' as interaction_type
from rental)
union
(select distinct payment_date::DATE,
first_value(customer_id) over () as customer_id,
'payment' 
from payment)
order by date, customer_id;

-- (select distinct rental_date::DATE as date,
-- customer_id,
-- 'rental' as interaction_type
-- from rental)
-- union
-- (select distinct payment_date::DATE,
-- customer_id,
-- 'payment' 
-- from payment)
-- order by date, customer_id;

------------------------------------------------------------------------------
-- Problem  9
select 'Problem 9' as problem;
--
-- Write a query to return the country names where there are both customers and
-- staff.
------------------------------------------------------------------------------

(select country
from staff 
   inner join address using(address_id)
   inner join city using(city_id)
   inner join country using(country_id))
intersect
(select country
from customer
   inner join address using(address_id)
   inner join city using(city_id)
   inner join country using(country_id));

------------------------------------------------------------------------------
-- Problem  10
select 'Problem 10' as problem;
--
-- Given the following CTEs, A and B. Write a query to return the rows that
-- are in A or B, but not both. Order the results by n.
------------------------------------------------------------------------------

with A as (
   select n
   from (values (1), (2), (3), (4)) as v(n)
),
B as (
   select n
   from (values (3), (4), (5), (6)) as v(n)
)
((select n from A)
except
(select n from B))
union
((select n from B)
except
(select n from A))
order by n; 