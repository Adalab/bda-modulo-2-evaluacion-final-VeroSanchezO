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

