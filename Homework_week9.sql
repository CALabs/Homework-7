USE sakila;

#1a. Display the first and last names of all actors from the table actor.
SELECT
first_name,
last_name
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT
CONCAT(first_name," ",last_name) AS Actor_Name
FROM actor
ORDER BY 1 ASC

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT
actor_id,
first_name,
last_name
FROM actor
WHERE first_name LIKE '%JOE%'

#2b. Find all actors whose last name contain the letters GEN:
SELECT
actor_id,
first_name,
last_name
FROM actor
WHERE last_name LIKE '%GEN%'

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT
last_name,
first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY 1,2 ASC

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT
country_id,
country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
ORDER BY 1,2

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD 
description BLOB 

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor 
DROP COLUMN description

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT
last_name,
COUNT(last_name) AS registros 
FROM actor
GROUP BY last_name
ORDER BY registros DESC

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT
last_name,
COUNT(last_name) AS registros 
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1
ORDER BY registros DESC

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS'

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS'

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#n.a.

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT 
a.first_name,
a.last_name,
b.address
FROM staff AS a
LEFT JOIN address AS b
ON a.address_id = b.address_id 
GROUP BY 1,2,3

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT 
a.first_name,
a.last_name,
SUM(b.amount) AS total_amount
FROM staff AS a
LEFT JOIN payment AS b
ON a.staff_id = b.staff_id
WHERE b.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY 1,2

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join. 
SELECT
a.title,
COUNT(b.film_id) AS Num_actors
FROM film AS a
LEFT JOIN film_actor AS b
ON a.film_id = b.film_id
GROUP BY title ASC

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT
a.title,
COUNT(b.film_id) AS num_copies
FROM film AS a
LEFT JOIN inventory AS b
ON a.film_id = b.film_id
WHERE a.title = 'Hunchback Impossible'
GROUP BY 1

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT
a.first_name,
a.last_name,
SUM(b.amount) AS total_paid
FROM customer AS a
LEFT JOIN payment AS b
ON a.customer_id = b.customer_id
GROUP BY 1,2
ORDER BY 2 ASC

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT
title
FROM film AS a
LEFT JOIN language AS b
ON a.language_id = b.language_id
WHERE title LIKE 'Q%'
UNION ALL
SELECT
title
FROM film AS a
LEFT JOIN language AS b
ON a.language_id = b.language_id
WHERE title LIKE 'K%'
GROUP BY title

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT
first_name,
last_name
FROM actor AS a
LEFT JOIN film_actor AS b
ON a.actor_id = b.actor_id
LEFT JOIN film AS c
ON b.film_id = c.film_id
WHERE c.title = 'Alone Trip'
GROUP BY 1,2

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT
a.email
FROM customer AS a
LEFT JOIN address AS b
ON a.address_id = b.address_id
LEFT JOIN city AS c
ON b.city_id = c.city_id
LEFT JOIN country AS d
ON c.country_id = c.country_id
WHERE country = 'Canada'
GROUP BY 1

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films. 
SELECT
a.title
FROM film AS a
LEFT JOIN film_category AS b
ON a.film_id = b.film_id
LEFT JOIN category AS c
ON b.category_id = c.category_id
WHERE c.name = 'Family'

#7e. Display the most frequently rented movies in descending order.
SELECT
a.title,
COUNT(rental_id) AS Total_Rent
FROM film AS a
LEFT JOIN inventory AS b
ON a.film_id = b.film_id
LEFT JOIN rental AS c
ON b.inventory_id = c.inventory_id
GROUP BY 1
ORDER BY Total_Rent DESC

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT
a.store_id,
COUNT(d.rental_id) * d.amount AS Total_rent
FROM store AS a
JOIN inventory AS b
ON a.store_id = b.store_id
JOIN rental AS c
ON b.inventory_id = c.inventory_id
JOIN payment AS d
ON c.rental_id = d.rental_id
GROUP BY 1

#7g. Write a query to display for each store its store ID, city, and country.
SELECT 
a.store_id,
b.city_id,
c.country_id
FROM store AS a
LEFT JOIN address AS b
ON a.address_id = b.address_id
LEFT JOIN city AS c
ON b.city_id = c.city_id
AND country_id
GROUP BY 1,2,3

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT
a.name,
COUNT(d.rental_id) * e.amount AS Total_rent
FROM category AS a
JOIN film_category AS b
ON a.category_id = b.category_id
JOIN inventory AS c
ON b.film_id = c.film_id
JOIN rental AS d
ON c.inventory_id = d.inventory_id
JOIN payment AS e
ON d.rental_id = e.rental_id
GROUP BY 1
ORDER BY Total_rent DESC
LIMIT 10

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW 'top generes' as
SELECT  x.name, SUM(x.FrequencyofRent) as TotalRents
FROM    (SELECT tb4.film_id, tb4.title,  tb4.FrequencyofRent, ct.category_id, ct.name
                FROM(SELECT tb3.film_id, tb3.title, SUM(tb3.TotalRents) AS FrequencyofRent
                      FROM    (SELECT tb2.film_id, tb2.title, tb2.inventory_id, COUNT(tb2.rental_id) as TotalRents
                                FROM    (SELECT tb1.film_id, tb1.title, tb1.inventory_id, tb1.rental_id
                                        FROM    (SELECT fm.film_id, fm.title, tb.inventory_id, tb.rental_id
                                                FROM film fm    
                                                    LEFT JOIN (SELECT inv.inventory_id, inv.film_id, rt.rental_id
                                                                FROM  inventory inv
                                                                    LEFT JOIN rental rt ON inv.inventory_id=rt.inventory_id) tb
                                                        ON fm.film_id=tb.film_id) tb1
                                        WHERE tb1.rental_id is NOT NULL)tb2
                                GROUP BY tb2.inventory_id) tb3
                       GROUP BY tb3.film_id)tb4,
                       film_category fc,
                       category ct
                WHERE  fc.film_id=tb4.film_id  AND
                       fc.category_id=ct.category_id)x
GROUP BY x.name
ORDER BY TotalRents DESC
LIMIT 10

#8b. How would you display the view that you created in 8a?
SELECT * FROM 'top generes'

# 8.c Drop a view for the top 5 categories 
DROP VIEW 'top generes';