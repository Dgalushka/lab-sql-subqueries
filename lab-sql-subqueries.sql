-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;

SELECT count(*) Hunchback_Impossible_Copies FROM film f
JOIN inventory i
ON f.film_id = i.film_id AND f.title = "Hunchback Impossible"; -- 6 copies

-- 2. List all films whose length is longer than the average of all the films.
SELECT title Films_Longer_Ahan_Averave FROM sakila.film
WHERE length > (SELECT avg(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
-- first step
SELECT film_id FROM FILM  
WHERE title = 'Alone Trip';

-- second step
SELECT actor_id FROM film_actor
WHERE film_id = (
	SELECT film_id FROM FILM WHERE title = 'Alone Trip'); 

-- final answer
SELECT concat(first_name, ' ', last_name) Actors_Alone_Trip FROM actor a
WHERE a.actor_id IN  ( 
	SELECT actor_id FROM film_actor 
    WHERE film_id = (
		SELECT film_id FROM FILM 
        WHERE title = 'Alone Trip')); -- final result

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT category_id FROM category -- step 1
WHERE name = 'Family';

SELECT film_id FROM film_category -- step 2
WHERE category_id = (
	SELECT category_id FROM category 
	WHERE name = 'Family');

SELECT title Family_Movies FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category -- step 2
    WHERE category_id = (
		SELECT category_id FROM category 
		WHERE name = 'Family'));  --  final result
        
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

-- Using subquery:
SELECT country_id FROM country
WHERE country = 'Canada'; -- step 1

SELECT city_id FROM city
WHERE country_id = (
	SELECT country_id FROM country
	WHERE country = 'Canada'); -- step 2
    
SELECT address_id FROM address
WHERE city_id IN (
	SELECT city_id FROM city
    WHERE country_id = (
		SELECT country_id FROM country
		WHERE country = 'Canada')); -- step 3
	
SELECT concat(first_name, ' ', last_name) Customer_From_Canada, email FROM customer
	WHERE address_id IN (
		SELECT address_id FROM address
		WHERE city_id IN (
			SELECT city_id FROM city
			WHERE country_id = (
				SELECT country_id FROM country
				WHERE country = 'Canada'))); -- final result using subqueries 
                
-- now, using JOIN:
SELECT concat(first_name, ' ', last_name) Customer_From_Canada, email FROM customer c
JOIN address a USING(address_id)
JOIN city cty USING(city_id)
JOIN country ctr USING (country_id)
WHERE country = 'CANADA'; -- WOW, Thata is so much more efficient :D 

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT count(distinct film_id)  FROM film_actor
GROUP BY actor_id; -- step 1
    
SELECT max(film_count) FROM (
	SELECT count(distinct film_id) film_count FROM film_actor
	GROUP BY actor_id) max_films; -- step 2, query to access the highest count of films per actor
     

SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING COUNT(DISTINCT film_id) = (
    SELECT MAX(actor_count)
    FROM (
        SELECT actor_id, COUNT(DISTINCT film_id) AS actor_count
        FROM film_actor
        GROUP BY actor_id
    ) AS subquery
    );
        
        

	











