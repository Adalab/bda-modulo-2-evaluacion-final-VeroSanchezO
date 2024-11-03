## Proyecto: 
Evaluación Final Módulo 2

## Descripción
Esta evaluación tiene como objetivo demostrar la comprensión y aplicación de las técnicas y conceptos abordados en el módulo, implementando consultas en MySQL y llevando a cabo un análisis de datos para extarer información relevante de la base de datos "Sakila".

## Requisitos Previos
   - MySQL Server instalado.
   - Base de datos Sakila 
   - Crear un repositorio desde GitHub Classroom usando el enlace proporsionado por el evaluador. Una vez creado, hay que clonar en nuestro ordenador y en la carpeta creada empezaremos a trabajar en el ejercicio.

## Heramientoas usadas
   - Material de estudio proporcionado por Adalab "Módulo 2: Domina el Arte de Extraer Información Valiosa"
   - Herramienta de administración de bases de datos (MySQL Workbench).
   - Base de datos Sakila (importada en una de las clases del módulo)
   - Chat GPT

# Desarrollo 

- Descargar la evaluación, la cual consta de 25 preguntas (2 bonus), las cuales evalúan la comprensión y habilidades en relación con SQL.
- Acceder a la base de datos "Sakila" importada previamente en una de la clases del módulo. 
- Observar y analizar cada una de las tablas que contiene esta base de datos. Algunas de ellas son: film (películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre otras.
- Observar y analizar la representación gráfica que muestra la estructura de la una base de datos (el ER diagram).
- Realizar las consultas, para extraer la información (solicitada en las preguntas) y posterior análisis de datos en el entorno una tienda de alquiler de películas (Base de datos Sakila).

- ## Resultados: 

A continuación se presentan algunas de las consultas desarrolladas:

- Consulta para mostrar el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
    Usé REGEX, ya que es un operador que permite utilizar expresiones regulares para realizar búsquedas más complejas en el texto. En este caso, busca coincidencias dentro del campo description.

SELECT title
	FROM film
	WHERE description REGEXP 'dog|cat';

- Consulta para encuentrar el nombre y apellido de los actores que aparecen en la película con title "Indian Love"
    Usé INNER JOIN, YA QUE me permite obtener datos de múltiples tablas en una sola consulta. Éste solo seleccionan las filas que tienen coincidencias en ambas tablas, según una columna común.

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
	INNER JOIN film_actor AS fa 
    USING (actor_id)
	INNER JOIN film AS f
    USING (film_id)
	WHERE f.title = 'Indian Love';

- Consulta para saber si hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
    Usé LEFT JOIN, ya que El LEFT JOIN este me asegura que todos los actores sean incluidos en el resultado, independientemente de si han actuado en alguna película o no. Al buscar NULL en fa.film_id, el código se asegura de identificar específicamente aquellos actores que no tienen registros en film_actor, es decir, aquellos que no han aparecido en ninguna película.

SELECT a.first_name AS nombre, a.last_name AS apellido
	FROM actor AS a
	LEFT JOIN film_actor AS fa 
    USING (actor_id)
	WHERE fa.film_id IS NULL;