-- Gabriel Leffew
-- CSC 256, Fall 2022, Project 3

-- change the output of null values
\pset null '<null>'

------------------------------------------------------------------------------
-- Problem 1
--
-- Write a query to return the total count of customers in the customer
-- table, the count of customers that provided an email address, and the
-- percentage of customers with an email address.
--
-- Table: customer
--
-- Expected Output:
--
-- total customers | customers with email | percent with email  
-------------------+----------------------+---------------------
--             599 |                  597 | 99.6661101836393990
--(1 row)
------------------------------------------------------------------------------

select 
count(customer_id) as "total customers",
count(email) as "customer with email",
count(email)::float/count(customer_id) * 100.00 as "percent with email"
from customer;

------------------------------------------------------------------------------
-- Problem 2
--
-- Write a query to return the number of distinct customers who have made
-- payments
--
-- Table: payment
--
-- Expected Output:
--
--  count 
-- -------
--    599
-- (1 row)
------------------------------------------------------------------------------

select count(distinct customer_id) from payment;

------------------------------------------------------------------------------
-- Problem 3
--
-- Write a query to return the average length of time films are rented out.
--
-- Table: rental
--
-- Expected Output:
--
--   avg rental duration   
-- ------------------------
--  4 days 24:36:28.541706
-- (1 row)
------------------------------------------------------------------------------

select avg(return_date - rental_date)
as "avg rental duration"
from rental;

------------------------------------------------------------------------------
-- Problem 4
--
-- Write a query to return the total of all payment amounts received.
--
-- Table: payment
--
-- Expected Output:
--
--   total   
-- ----------
--  67416.51
-- (1 row)
------------------------------------------------------------------------------

select sum(amount) as "total" from payment;

------------------------------------------------------------------------------
-- Problem 5
--
-- Write a query to list the number of films each actor has appeared in and
-- order the results from most popular to least.
--
-- Table: film_actor
--
-- Expected Output:
--
--  actor_id | num_films 
-- ----------+-----------
--       107 |        42
--       102 |        41
--       198 |        40
--       181 |        39
--        23 |        37
--        81 |        36
--       106 |        35
-- ...
-- (200 rows)
------------------------------------------------------------------------------

select actor_id, count(film_id) as "num_films"
from film_actor
group by actor_id 
order by num_films desc;

------------------------------------------------------------------------------
-- Problem 6
--
-- Write a query to list the customers who have made over 40 rentals.
--
-- Table: rental
--
-- Expected Output:
--
--  customer_id 
-- -------------
--          526
--          236
--          148
--           75
--          144
-- (5 rows)
------------------------------------------------------------------------------

select customer_id
from rental 
group by customer_id
having count(customer_id) > 40;

------------------------------------------------------------------------------
-- Problem 7
--
-- Suppose we want to compare how the staff are performing against each other
-- on a month to month basis. Write a query the returns the number of payments
-- they handled, the total amount of money accepted, and the average payment
-- amount for each month and year. Hint: separate calls to the date_part
-- function can get the year and the month.

-- Table: payment
--
-- Expected Output:
--
--  year | month | staff_id | num_payments | payment_total | avg_payment_amount 
-- ------+-------+----------+--------------+---------------+--------------------
--  2007 |     1 |        1 |          617 |       2621.83 | 4.2493192868719611
--  2007 |     1 |        2 |          540 |       2202.60 | 4.0788888888888889
--  2007 |     2 |        1 |         1164 |       4776.36 | 4.1034020618556701
--  2007 |     2 |        2 |         1148 |       4855.52 | 4.2295470383275261
--  2007 |     3 |        1 |         2817 |      11776.83 | 4.1806283280085197
--  2007 |     3 |        2 |         2827 |      12109.73 | 4.2835974531305271
--  2007 |     4 |        1 |         3364 |      14080.36 | 4.1856004756242568
--  2007 |     4 |        2 |         3390 |      14479.10 | 4.2711209439528024
--  2007 |     5 |        1 |           95 |        234.09 | 2.4641052631578947
--  2007 |     5 |        2 |           87 |        280.09 | 3.2194252873563218
-- (10 rows)
------------------------------------------------------------------------------

select distinct
date_part('year', payment_date) as "year",
date_part('month', payment_date) as "month",
staff_id,
count(payment_id) as "num_payments",
sum(amount) as "payment_total",
avg(amount) as "avg_payment_amount"
from payment 
group by staff_id, year, month
order by month asc;

------------------------------------------------------------------------------
-- Problem 8
--
-- Write a query to show the number of rentals that were returned within three
-- days, the number returned in three or more days, and the number never
-- returned. For the comparison you can use variations of the following: 
-- return_date - rental_date < interval '3 days'
--
-- Table: rental
--
-- Expected Output:
--
--  within 3 days | greater than 3 days | not returned 
-- ---------------+---------------------+--------------
--           4388 |               11473 |          183
-- (1 row)
------------------------------------------------------------------------------

select 
    count(
        case when date_part('days', return_date - rental_date) < 3 
        then 1 
        else null 
        end
    ) as "within 3 days",
    count(
        case when date_part('days', return_date - rental_date) >= 3 
        then 1 
        else null 
        end
    ) as "greater than 3 days",
    count(
        case when return_date is null then 1
        else null
        end 
    ) as "not returned"
    from rental;

------------------------------------------------------------------------------
-- Problem 9
--
-- Write a query to give counts of the films by their length in groups of
-- "0-1hrs", "1-2hrs", "2-3hrs", and "3hrs+".
--
-- Table: film
--
-- Expected Output:
--
--  len   | count 
----------+-------
-- 0-1hrs |    97
-- 1-2hrs |   436
-- 2-3hrs |   419
-- 3hrs+  |    48
--(4 rows)
------------------------------------------------------------------------------

select case 
    when length < 60 then '0-1hrs' 
    when length >= 60 and length < 120 then '1-2hrs' 
    when length >= 120 and length < 180 then '2-3hrs' 
    when length >= 180 then '3hrs+'
    else '3hrs+'
    end as len,
count(*)
from film
group by len
order by len;

--select * from film where length is null;

------------------------------------------------------------------------------
-- Problem 10
--
-- Write a query to return the average rental duration for each customer in
-- descending order.
--
-- Table: rental
--
-- Expected Output:
--
-- customer_id |   avg_rent_duration    
---------------+------------------------
--         315 | 6 days 14:13:22.5
--         187 | 5 days 34:58:38.571428
--         321 | 5 days 32:56:32.727273
--         539 | 5 days 31:39:57.272727
--         436 | 5 days 31:09:46
--         532 | 5 days 30:59:34.838709
--         427 | 5 days 29:27:05
--         555 | 5 days 26:48:35.294118
-- ...
-- (599 rows)
------------------------------------------------------------------------------

select customer_id, avg(return_date - rental_date) as avg_rental_duration
from rental
group by customer_id
order by avg_rental_duration desc;
