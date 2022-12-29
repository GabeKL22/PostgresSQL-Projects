-- STUDENT NAME
-- CSC 256, Fall 2022, Project 1

-- change the output of null values
\pset null '<null>'


------------------------------------------------------------------------------
-- Problem 1
--
-- Write a query to return the actor's first names and last names only (with
-- the column headings "First Name" and "Last Name").
-- 
-- Table: actor
-- Output columns: "First Name", "Last Name"
------------------------------------------------------------------------------

select first_name as "First Name", last_name as "Last Name" from actor; 

------------------------------------------------------------------------------
-- Problem 2
-- 
-- Each film has a rental_rate, which is how much money it costs for a customer
-- to rent out the film. Each film also has a replacement_cost, which is how
-- much money the film costs to replace. Write a query to figure out how many
-- times each film must be rented out to cover its replacement cost. Note that
-- the break even amount should be an integer; you can use the ceil function
-- to round a fractional number up.
-- 
-- Table: film
-- Output columns: title, rental_rate, replacement_cost, break_even
------------------------------------------------------------------------------

select title, rental_rate, replacement_cost, ceil(replacement_cost/rental_rate) as "break_even" from film;


------------------------------------------------------------------------------
-- Problem 3
-- 
-- List all the films longer than 2 hours. Note that each film has a length in
-- minutes.
--
-- Table: film
-- Output columns: title, length
------------------------------------------------------------------------------

select title, length from film where (length > 120);


------------------------------------------------------------------------------
-- Problem 4
--
-- Write a query that returns all films with a length of an hour or less.
-- Use the NOT keyword as part of your query.
--
-- Table: film
-- Output columns: title, rental_duration, length
-- We’re trying to list all films with a length of an hour or less. Show two
------------------------------------------------------------------------------

select title, rental_duration, length from film where not (length > 60); 


------------------------------------------------------------------------------
-- Problem 5
-- 
-- Write a single query to return all rentals that have been out for more than
-- 7 days. Note that dates can be operated on with arithmetic operators. Also,
-- the "date_part" function can extract components of date/time information.
-- Example: date_part('day', <date-time>) will extract the day part; this is
-- what you need for part of this query.
--
-- Table: rental
-- Output columns: rental_id, time_out
------------------------------------------------------------------------------

select rental_id, return_date-rental_date as "time_out" from rental where date_part('days', return_date-rental_date) > 7;


------------------------------------------------------------------------------
-- Problem 6
--
-- Write a query to list the rentals that have not been returned.
--
-- Table: rental
-- Output columns: rental_id, return_date
------------------------------------------------------------------------------

select rental_id, return_date from rental where return_date is null;


------------------------------------------------------------------------------
-- Problem 7
--
-- Write a query to list the films that have a rating that is not 'G' or 'PG'
--
-- Table: film
-- Output columns: title, rating
------------------------------------------------------------------------------

select title, rating from film where not (rating = 'G') and not (rating = 'PG');


------------------------------------------------------------------------------
-- Problem 8
--
-- Write a query to return the films with a rating of 'PG', 'G', or 'PG-13'.
-- Use the IN keyword as part of your query.
--
-- Table: film
-- Output columns: title, rating
------------------------------------------------------------------------------

select title, rating from film where rating in ('PG', 'G', 'PG-13');


------------------------------------------------------------------------------
-- Problem 9
--
-- Write a query to return films that have a length greater than or equal to
-- 90 minutes and less than or equal to 120 minutes. Use the BETWEEN keyword
-- as part of your query.
--
-- Table: film
-- Output columns: title, length
------------------------------------------------------------------------------

select title, length from film where length between 90 and 120; 


------------------------------------------------------------------------------
-- Problem 10
-- Write a query to return all film titles that end with the word "GRAFFITI".
--
-- Table: film
-- Output columns: title
------------------------------------------------------------------------------

select title from film where title like '%GRAFFITI';
