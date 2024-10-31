USE sakila;

/* TABLAS: film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías) */ 

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT *
	FROM film;

	--  NOTA: Acá uso DISTINCT porq se utiliza para seleccionar valores únicos de la columna específicada
SELECT DISTINCT title AS películas
	FROM film;  

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT *
	FROM film;

	-- NOTA: Filtré la condición específicada en un WHERE
SELECT title AS películas, rating AS clasificación
	FROM film
	WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT *
	FROM film;

SELECT title AS películas, description AS descripción
	FROM film 
	WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT *
	FROM film;

SELECT title AS películas, length AS duración
	FROM film
	WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.
SELECT *
	FROM actor;

SELECT first_name AS "nombres de actores"
	FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT *
	FROM actor;

SELECT CONCAT(first_name," ", last_name) AS "nombre y apellido"
	FROM actor
    WHERE first_name LIKE "Gibson";

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT *
	FROM actor;

SELECT first_name AS nombre, actor_id
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT *
	FROM film;
    
SELECT title AS películas, rating AS clasificación
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT *
	FROM film;
    
    -- NOTA: acá el count me permite contar las filas de la agrupación que hice con rating
SELECT rating AS clasificación, COUNT(*) AS total_peliculas
	FROM film
	GROUP BY rating;
 
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
	-- tabla customer: id_customer, first_name y last_name
	-- tabla rental: rental_id
/* NOTA: El count lo utilizo para contar solo las filas donde hay un alquiler. 
INNER JOIN para unir customer y rental y asegurarme que solo me incluya los clientes que tienen al menos un alquiler en la tabla rental*/

SELECT c.customer_id AS id_cliente, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS "T. películas alquiladas"
	FROM customer AS c
	INNER JOIN rental AS r 
		USING (customer_id)
	GROUP BY c.customer_id, c.first_name, c.last_name;
    
-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
	-- tabla category: name, category_id
    -- tabla rental: rental_id, inventory_id
    -- Tabla film_category: category_id, film_id
    -- Tabla inventory: film_id, inventory_id

SELECT c.name AS nombre_categoria, COUNT(r.rental_id) AS "recuento_alquileres"
	FROM category AS c
		INNER JOIN film_category AS fc
			USING(category_id)
		INNER JOIN inventory AS i
			USING(film_id)
		INNER JOIN rental AS r
			USING(inventory_id)
GROUP BY name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT *
	FROM film;
    
SELECT rating AS clasificación, AVG(length) AS "promedio duración"
	FROM film
	GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
	-- tabla actor: first_name, last_name, actor_id
	-- tabla film: title, flim_id
	-- Tabla film_actor: actor_id, film_id

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
	INNER JOIN film_actor AS fa 
    USING (actor_id)
	INNER JOIN film AS f
    USING (film_id)
	WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT *
	FROM film;
    
SELECT title
	FROM film
	WHERE description REGEXP 'dog|cat';

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
	-- tabla actor: first_name, last_name
	-- tabla film: title, flim_id
    
SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
	LEFT JOIN film_actor AS fa 
    USING (actor_id)
	WHERE fa.film_id IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT *
	FROM film;
    
SELECT title AS películas
	FROM film
	WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
	-- Tabla film: title, film_id
    -- Tabla film_category: film_id, category_id
    -- Tabla category: name, category_id
    
SELECT f.title AS películas
	FROM film AS f
	INNER JOIN film_category fc 
		USING (film_id)
	INNER JOIN category AS c 
		USING (category_id)
	WHERE c.name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
	-- Tabla actor: first_name, last_name, actor_id 
    -- Tabla film_actor: actor_id

SELECT first_name AS nombre, last_name AS apellido
	FROM actor
	WHERE actor_id IN (SELECT actor_id
						FROM film_actor
						GROUP BY actor_id
						HAVING COUNT(film_id) > 10);

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT *
FROM film;

SELECT title AS películas, length AS duración
FROM film
WHERE rating = 'R' AND length > 120; 

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
