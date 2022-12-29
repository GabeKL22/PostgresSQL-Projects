-- Gabriel Leffew
-- CSC 256, Fall 2022, Project 4

-- change the output of null values
\pset null '<null>'


------------------------------------------------------------------------------
-- Problem 1
--
-- Write a query to list actors ordered by the length of their full name
-- descending.
--
-- Table: actor
--
-- Expected Output:
--
--      full_name       | len 
------------------------+-----
-- MICHELLE MCCONAUGHEY |  20
-- JOHNNY LOLLOBRIGIDA  |  19
--...
-- (200 rows)
------------------------------------------------------------------------------

select first_name ||' '|| last_name
as full_name,
length(first_name ||' '|| last_name)
as "len"
from actor
order by len desc;

------------------------------------------------------------------------------
-- Problem 2
--
-- Write a query to list the customer ids where all payments corresponding to
-- the customer id are over two dollars. Hint: look up the bool_and
-- aggregate function.
--
-- Table: payment
--
-- Expected Output:
--
--  customer_id 
-- -------------
--          363
--           59
-- (2 rows)
------------------------------------------------------------------------------

select customer_id
from payment
group by customer_id
having bool_and(amount > 2);

------------------------------------------------------------------------------
-- Problem 3
--
-- Write a query to print a description of each film's length as shown in
-- the output below. When a film does not have a length, print: [title] is
-- unknown length
--
-- Table: film
--
-- Expected Output:
--
--                 length_desc                 
-- --------------------------------------------
--  ACADEMY DINOSAUR is 86 minutes
--  ACE GOLDFINGER is 48 minutes
-- ...
-- (1000 rows)
------------------------------------------------------------------------------

select case 
when length::VARCHAR is not null then title || ' is ' || length || ' minutes'
else title || ' is unknown length'
end as length_desc
from film;

------------------------------------------------------------------------------
-- Problem 4
--
-- Write a query to print the first three letters of each film title and then
-- '*' for the rest. Hint: look up the repeat function.
--
-- Table: film
--
-- Expected Output:
--
--            blanked           
-- -----------------------------
--  ACA*************
--  ACE***********
-- ...
-- (1000 rows)
------------------------------------------------------------------------------

select substring(title, 1, 3) || repeat('*', length(title)-3) as blanked 
from film;

------------------------------------------------------------------------------
-- Problem 5
--
-- The rental duration in the film table is stored as an integer, representing
-- the number of days. Write a query to return this as an interval instead and
-- then add one day to the duration
--
-- Table: film
--
-- Expected Output:
--
--            title            | duration | duration+1 
-------------------------------+----------+------------
-- ACADEMY DINOSAUR            | 6 days   | 7 days
-- ACE GOLDFINGER              | 3 days   | 4 days
--...
--(1000 rows)
------------------------------------------------------------------------------

select title, 
rental_duration || ' days' as duration,
rental_duration + 1 || ' days' as "duration+1"
from film;

------------------------------------------------------------------------------
-- Problem 6
--
-- Write a query to return total number of rentals made during each hour of the
-- day.
--
-- Table: rental
--
-- Expected Output:
--
--  hr | count 
-- ----+-------
--   0 |   694
--   1 |   649
-- (24 rows)
------------------------------------------------------------------------------
select date_part('hour', rental_date) as hr,
count(*)
from rental
group by hr;


------------------------------------------------------------------------------
-- Problem 7
--
-- Write a query to return the number of films that were rented out on the last
-- day of a month.
--
-- Table: rental
--
-- Expected Output:
--
--  End of month rentals 
-- ----------------------
--                   842
-- (1 row)
------------------------------------------------------------------------------

select count(
    case when rental_date::date = (date_trunc('month', rental_date) + interval '1 month - 1 day')::date
    then 1
    else null
    end 
) as "End of month rentals"
from rental; 

/*
select count (*) as "End of month rentals" 
from rental
group by return_date
having date_trunc('day'::TEXT, max(date_part('day', return_date)::TEXT)); 
*/
------------------------------------------------------------------------------
-- Problem 8
--
-- Write a query to sum up, for each customer, the total number of hours they
-- have had films rented out for. Return the top three customers with the most
-- hours.
--
-- Table: rental
--
-- Expected Output:
--
-- customer_id | hrs_rented 
---------------+------------
--         526 |       6340
--         148 |       5834
--         144 |       5641
--(3 rows)
-- https://stackoverflow.com/questions/952493/how-do-i-convert-an-interval-into-a-number-of-hours-with-postgres
------------------------------------------------------------------------------


select customer_id,
sum(extract(epoch from return_date-rental_date)/3600)::int as hrs_rented
from rental
group by customer_id
order by hrs_rented desc
limit 3;


------------------------------------------------------------------------------
-- Problem 9
--
-- Write a query to return the number of occurrences of the letter 'A' in each
-- customer's first name; order the output by the count descending.
--
-- Table: customer
--
-- Expected Output:
--
--  first_name  | count 
-- -------------+-------
--  CASSANDRA   |     3
--  BARBARA     |     3
--  SAMANTHA    |     3
-- ...
-- (599 rows)
------------------------------------------------------------------------------

select first_name,
length(first_name) - length(replace(first_name, 'A', '')) as count
from customer
order by count desc;

------------------------------------------------------------------------------
-- Problem 10
--
-- Write a query to return the total amount of money made on weekends (Saturday
-- and Sunday.)
--
-- Table: payment
--
-- Expected Output:
--
--   total   
-- ----------
--  19036.04
-- (1 row)
------------------------------------------------------------------------------

select sum(amount)
from payment
where extract(dow from payment_date) in (0, 6);