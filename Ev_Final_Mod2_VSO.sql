USE sakila;

/* TABLAS: film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías) */ 

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT *
	FROM film;

	-- Acá uso DISTINCT porq se utiliza para seleccionar valores únicos de la columna específicada
SELECT DISTINCT title AS películas
	FROM film;  

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT *
	FROM film;

	-- Filtré la condición específicada en un WHERE
SELECT title AS películas, rating AS clasificación
	FROM film
	WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT *
	FROM film;
    
	-- Usé Like, porqué necesitaba buscar un patrón específico en una cadena de texto
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

SELECT first_name AS nombre, last_name AS apellido
	FROM actor
	WHERE last_name LIKE "Gibson";

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
    
    -- Agrupé la clasificación, y que me contara (count) el número total de filas, en este caso: películas
SELECT rating AS clasificación, COUNT(*) AS total_peliculas
	FROM film
	GROUP BY rating;
 
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
	-- tabla customer: customer_id, first_name y last_name
	-- tabla rental: rental_id, customer_id
/* El count: para contar cuántas películas (alquileres) hay asociadas con cada cliente 
INNER JOIN para unir customer y rental y asegurarme que solo me incluya los clientes que tienen al menos un alquiler en la tabla rental
Agrupo por el ID del cliente, ya que este es único para cada cliente */

SELECT c.customer_id AS id_cliente, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS "T. películas alquiladas"
	FROM customer AS c
	INNER JOIN rental AS r 
		USING (customer_id)
	GROUP BY c.customer_id, c.first_name, c.last_name;
    
-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
	-- tabla category: name, category_id
    -- tabla film_category: category_id, film_id
    -- tabla inventory: film_id, inventory_id
    -- tabla rental: rental_id, inventory_id
    
	-- INNER JOIN 1: category se une a film_category para obtener qué categorías están asociadas con qué películas
	-- INNER JOIN 2: film_category con inventory, usando film_id, para acceder a las copias de esas películas en el inventario.
	-- INNER JOIN 3: inventory se une a rental para contar cuántas veces se han alquilado esas películas.
    -- Group By: Agrupé por "nombre categoria" para poder usar COUNT y poder contar cuántos alquileres hay en cada grupo.
	-- Count me está contando el número total de alquileres para cada categoría de película

SELECT c.name AS "nombre categoria", COUNT(r.rental_id) AS "recuento alquileres"
	FROM category AS c
		INNER JOIN film_category AS fc
			USING(category_id)
		INNER JOIN inventory AS i
			USING(film_id)
		INNER JOIN rental AS r
			USING(inventory_id)
GROUP BY name;

/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la 
clasificación junto con el promedio de duración. */

SELECT *
	FROM film;
    
SELECT rating AS clasificación, AVG(length) AS "promedio duración"
	FROM film
	GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
	-- tabla actor: first_name, last_name, actor_id
    -- tabla film_actor: actor_id, film_id
	-- tabla film: title, flim_id
	
    -- INNER 1: actor y film_actor para que me de una lista de actores que están en cualquier película.
	-- INNER 2: film_actor con film para acceder a la información de las películas en las que aparecen esos actores.
    -- La tabla film_actor es clave porque actúa como un vínculo entre actores y películas.
    
SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
	INNER JOIN film_actor AS fa 
		USING (actor_id)
	INNER JOIN film AS f
		USING (film_id)
	WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
	-- con REGEXP 'dog|cat', estoy indcando que quiero encontrar cualquier texto que contenga "dog" o "cat".
SELECT *
	FROM film;
    
SELECT title
	FROM film
	WHERE description REGEXP 'dog|cat';

-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
	-- tabla actor: first_name, last_name, actor_id
	-- tabla film_actor: title, film_id, actor_id
    
    /* El LEFT JOIN me muestra todos los registros de la tabla actor (la tabla de la izquierda), incluso si no hay coincidencias en la tabla 
    film_actor (la tabla de la derecha). Esto es por si un actor no ha aparecido en ninguna película, aún así aparecerá en el resultado de la consulta */
    
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
	-- tabla film: title, film_id
    -- tabla film_category: film_id, category_id
    -- tabla category: name, category_id
    
    -- Acá el nombre de la categoría "Family" está en "category"
SELECT f.title AS películas, c.name AS categoría
	FROM film AS f
	INNER JOIN film_category fc 
		USING (film_id)
	INNER JOIN category AS c 
		USING (category_id)
	WHERE c.name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
	-- tabla actor: first_name, last_name, actor_id 
    -- tabla film_actor: actor_id
    
    -- En la consulta busco los nombres y apellidos de los actores que cumplen una condición basada en su actor_id
    -- En la subconsulta busco identificar a los actores que han aparecido en más de 10 películas.

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

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos 
y muestra el nombre de la categoría junto con el promedio de duración. */
	-- tabla category: name, category_id
    -- tabla film_category: category_id, film_id
    -- tabla film: duration, film_id

-- Tabla category: Contiene información de las categorías de películas, el nombre de la categoría (name) y su identificador único (category_id).
-- Tabla film_category: Relaciona las películas con sus categorías. Contiene category_id (vincula con la tabla category) y film_id (que vincula con la tabla film).
-- Tabla film: Contiene duración (length) y su identificador (film_id).	
-- El Having me está filtrando las categorías para mostrar únicamente las que el promedio de duración, de las películas, es superior a 120 minutos

SELECT c.name AS categoría, AVG(f.length) AS promedio_duración
	FROM category AS c
	INNER JOIN film_category AS fc 
		USING (category_id)
	INNER JOIN film AS f 
		USING (film_id)
	GROUP BY c.name
	HAVING AVG(f.length) > 120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad 
de películas en las que han actuado. */
	-- tabla actor: firts_name, actor_id
	-- tabla film_actor: film_id, actor_id

	-- Esta unión conecta la tabla actor con la tabla film_actor usando el actor_id, para acceder a todas las películas en las que ha actuado cada actor
    -- Agrupo porque quiero contar cuántas películas ha actuado cada actor, y sin la agrupación, el conteo incluiría todas las filas en la tabla
    
SELECT a.first_name AS nombre, COUNT(fa.film_id) AS "T. películas"
	FROM actor AS a
	INNER JOIN film_actor AS fa 
		USING (actor_id)
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) >= 5;

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para 
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */
    -- tabla film: title, film_id
    -- tabla inventory: film_id, inventory_id
	-- tabla rental: inventory_id, return_date

	-- En la consulta estoy buscando el título de todas las películas de la tabla film.
    -- En la subconsulta busco los film_id de las películas que han sido alquiladas durante más de 5 días.
    -- En la condición WHERE verifico que la diferencia entre la fecha de devolución (return_date) y la fecha de alquiler (rental_date) sea mayor a 5 días
    -- Resto las fechas: calculo cuántos días han pasado entre la fecha en que se alquiló una película (r.rental_date) y la fecha en que se devolvió (r.return_date).
    -- Solo los inventory_id de los alquileres que cumplen esta condición serán seleccionados.
    
SELECT f.title AS Películas
	FROM film AS f
	WHERE f.film_id IN (SELECT i.film_id
							FROM rental AS r
							INNER JOIN inventory AS i 
								USING (inventory_id)
							WHERE r.return_date - r.rental_date > 5);

/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos 
de la lista de actores. */
	-- tabla actor: first_name, last_name, actor_id 
    -- tabla film_actor: actor_id, film_id
	-- tabla film_category: film_id, category_id
    -- tabla category: category_id
    
    -- En la consulta principal busco el nombre y apellido de los actores en la tabla actor.
    -- La cláusula WHERE actor_id NOT IN (subconsulta) me filtra los resultados para incluir solo aquellos actores que su actor_id no está en el conjunto que me devuelve la subconsulta
    -- Subconsulta 1: Busco los actor_id de los actores que han actuado en películas de la categoría "Horror"
    -- Subconsulta 2: Busco el category_id que corresponde al nombre "Horror". Es necesario porq en la tabla film_category se utiliza el category_id para identificar las categorías
    
SELECT first_name AS nombre, last_name AS apellido
	FROM actor
	WHERE actor_id NOT IN (SELECT fa.actor_id
							FROM film_actor AS fa
							JOIN film_category AS fc
                            USING (film_id)
							WHERE fc.category_id = (SELECT category_id
														FROM category
														WHERE name = 'Horror'));


