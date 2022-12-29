-- STUDENT NAME
-- CSC 256, Fall 2022, Project 2

-- change the output of null values
\pset null '<null>'

------------------------------------------------------------------------------
-- Problem 1
--
-- Write a query to list all the customers that have an email address. Order
-- the customers by last name descending
--
-- Table: customer
--
-- Expected Output (only first row listed):
--
-- first_name |last_name   |
-- -----------|------------|
-- CYNTHIA    |YOUNG       |
-- ...
------------------------------------------------------------------------------

select first_name, last_name 
from customer 
where email is not null 
order by last_name desc;

------------------------------------------------------------------------------
-- Problem 2

-- Write a query to list the country ids and cities from the city table,
-- first ordered by country id ascending, then by city alphabetically.
--
-- Table: city
--
-- Expected Output (only first row listed):
--
-- country_id|city                      |
-- ----------|--------------------------|
--          1|Kabul                     |
-- ...
------------------------------------------------------------------------------

select country_id, city 
from city 
order by country_id, city asc;

------------------------------------------------------------------------------
-- Problem 3
--
-- Write a query to return the three most recent payments received.
-- 
-- Table: payment
-- 
-- Expected Output:
-- 
-- payment_id|payment_date       |
-- ----------|-------------------|
--      31918|2007-05-14 13:44:29|
--      31917|2007-05-14 13:44:29|
--      31919|2007-05-14 13:44:29|
------------------------------------------------------------------------------

select payment_id, payment_date 
from payment 
order by payment_date desc limit 3;

------------------------------------------------------------------------------
-- Problem 4
--
-- Write a query to return the four films with the shortest length that are not
-- R rated. For films with the same length, order them alphabetically
--
-- Table: film
--
-- Expected Output (only column headers listed):
--
-- title           |length|rating|
-- ----------------|------|------|
-- ...
------------------------------------------------------------------------------

select title, length, rating 
from film 
where rating <> 'R' 
order by length, title asc limit 4;

------------------------------------------------------------------------------
-- Problem  5
--
-- Write a query to return all the unique ratings films can have, ordered
-- alphabetically (not including NULL.)
--
-- Table: film
--
-- Expected Output (only column headers listed):
--
-- rating|
-- ------|
-- ...
------------------------------------------------------------------------------

select distinct rating
from film
where rating is not null
order by rating;


------------------------------------------------------------------------------
-- Problem 6
--
-- Write a return all unique (rental_duration, rental_rate) pairs.
--
-- Table: film
--
-- Expected Output (only first row listed):
--
-- rental_duration|rental_rate|
-- ---------------|-----------|
--               3|       4.99|
-- ...
------------------------------------------------------------------------------

select distinct rental_duration, rental_rate 
from film 
order by rental_duration asc, rental_rate desc;

------------------------------------------------------------------------------
-- Problem 7
--
-- Write a query to return an ordered list of distinct ratings for films
-- along with their descriptions. The descriptions are 'General',
-- 'Parental Guidance Recommended', 'Parents Strongly Cautioned', 'Restricted',
-- and 'Adults Only' for the ratings 'G', 'PG', 'PG-13', 'R', 'NC-17'
-- respectively.
--
-- Table: film
--
-- Expected Output (only first row listed):
--
-- rating|rating description           |
-- ------|-----------------------------|
-- G     |General                      |
-- ...
------------------------------------------------------------------------------

select distinct rating, case rating
    when 'G' then 'General'
    when 'PG' then 'Parental Guidance Recommended'
    when 'PG-13' then 'Parents Strongly Cautioned'
    when 'R' then 'Restricted'
    when 'NC-17' then 'Adults Only' end as "rating description"
from film order by rating asc;


------------------------------------------------------------------------------
-- Problem 8
--
-- Write a query to output 'Returned' for returned rentals and 'Not Returned'
-- for rentals that have not been returned. Order the output to show those not
-- returned first.
--
-- Table: rental
-- 
-- Expected Output (only first row listed):
-- 
-- rental_id|rental_date        |return_date        |return_status|
-- ---------|-------------------|-------------------|-------------|
--     14503|2006-02-14 15:16:03| <null>            |Not Returned |
-- ...
------------------------------------------------------------------------------

select rental_id, rental_date, return_date, case
    when return_date is not null then 'Returned'
    else 'Not Returned' end as "return_status"
from rental order by return_date nulls first;

------------------------------------------------------------------------------
-- Problem 9
--
-- Write a query to return the countries in alphabetical order, but also with
-- the constraint that the first three countries in the list must be 1) United
-- States 2) United Kingdom 3) Australia and then normal alphabetical order
-- after that. We might want this populate a "country picker" form and most of
-- our customers are from the first three countries listed.
--
-- Table: country
--
-- Expected Output (only first 4 rows listed):
--
-- country                              |
-- -------------------------------------|
-- United States                        |
-- United Kingdom                       |
-- Australia                            |
-- Afghanistan                          |
-- ...
------------------------------------------------------------------------------

select country from country order by case country_id
    when 103 then 0
    when 102 then 1
    when 8 then 2
    else 3 end, country;

------------------------------------------------------------------------------
-- Problem 10
--
-- Write a query to return the top five films according to their dollars per
-- minute of entertainment.
--
-- Table: film
--
-- Expected Output (only first row listed):
--
-- title              |rental_rate|length|per_minute            |
-- -------------------|-----------|------|----------------------|
-- IRON MOON          |       4.99|    46|0.10847826086956521739|
-- ...
------------------------------------------------------------------------------

--select title, rental_rate, length, (rental_rate/length) as per_minute from film;
select title, rental_rate, length, case length
    when 0 then null
    else rental_rate/length 
    end as "per_minute"
from film order by per_minute desc nulls last limit 5;