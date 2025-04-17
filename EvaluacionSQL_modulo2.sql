USE sakila;

-- 1. Selecciona todos los nombres de las peliculas sin que aparezcan duplicados.

SELECT DISTINCT
title
FROM film;

-- 2. Muestra los nombres de todas las peliculas que tengan una clasificacion de "PG-13".
-- *Añado AS clasificación para que quede más visualmente claro los datos en el output*
SELECT
title,
rating AS clasificacion
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el titulo y la descripcion de todas las peliculas que contengan la palabra "amazing" en su descripcion. 
SELECT
title,
description
FROM film
WHERE description LIKE '%amazing%';

-- 4.Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT
title,
length
FROM film
WHERE length >= '120';

-- 5. Recupera los nombres de todos los actores.
-- *Añado ORDER BY del apellido para que quede mucho más claro y con un orden alfabetico el output.*
SELECT DISTINCT
last_name,
first_name
FROM actor
ORDER BY last_name;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT
last_name,
first_name
FROM actor
WHERE last_name = 'Gibson';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT
actor_id,
last_name,
first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8.Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT
title,
rating AS clasificacion
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
-- * He contado desde el film_id porque es unicom, por ello no meto el distinct. Creo esta cantidad como otra colunma 'cantidad_total_peliculas' que nos da la informacion.
SELECT 
rating AS clasificacion,
COUNT(film_id) AS cantidad_total_peliculas
FROM film
GROUP BY
rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- *Utilizo en este caso LEFT JOIN porque me pide la cantidad total de peliculas alquiladas por cada cliente, incluidos aquellos que no hayan alquilado, apareceria como NULL. Con el INNER JOIN me apareceria unicamente aquellos que han alquilado.
SELECT
c.customer_id,
c.last_name,
c.first_name,
COUNT(r.rental_id) AS Q_total_peliculas
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY
c.customer_id,
c.last_name,
c.first_name;


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT
c.name AS categoria,
COUNT(r.rental_id)  AS Q_total_alquileres
FROM film_category AS fcatg
INNER JOIN category AS c
ON fcatg.category_id = c.category_id
INNER JOIN inventory AS i
ON i.film_id = fcatg.film_id
INNER JOIN rental AS r
ON r.inventory_id = i.inventory_id
GROUP BY
c.name;




-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duracion.
USE sakila;

SELECT
rating AS clasificacion,
ROUND(AVG(length),2) AS promedio_duracion
FROM film
GROUP BY
rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT
act.first_name AS nombre,
act.last_name AS apellido,
film.title AS titulo
FROM actor AS act
INNER JOIN film_actor AS fact
ON act.actor_id = fact.actor_id
INNER JOIN film
ON fact.film_id = film.film_id
WHERE film.title= 'Indian Love';

    
-- 14.Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.alter
    -- *Incluyo en el select la descripcion para poder comprobar que se cumple las condiciones dadas solicitadas*
    SELECT
    title,
    description
    FROM film
    WHERE description LIKE '%dog%'OR '%cat%';
    
-- 15. Encuentra a el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
    SELECT
    title,
    release_year
    FROM film
    WHERE release_year BETWEEN 2005 and 2010;
    
-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT
film.title,
category.name
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE category.name= 'Family';


-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
USE sakila;
SELECT
title,
length,
rating
FROM film
WHERE rating= 'R' AND length>= 120;


-- BONUS --
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT
  a.first_name,
  a.last_name,
  COUNT(fa.film_id) AS Q_peliculas
FROM actor AS a
INNER JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
GROUP BY
a.actor_id,
a.first_name,
a.last_name
HAVING COUNT(fa.film_id) > 10;

-- 19. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.

SELECT 
a.actor_id,
a.first_name,
a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- 20.Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT
c.name AS categoria,
ROUND(AVG(f.length),2) AS promedio_duracion
FROM category AS c
INNER JOIN film_category AS fc
ON c.category_id = fc.category_id
INNER JOIN film AS f
ON fc.film_id = f.film_id
GROUP BY
c.name
HAVING AVG(f.length)> 120;

-- 21.Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT
a.first_name AS nombre,
a.last_name AS apellido,
COUNT(fa.film_id) AS Q_peliculas
FROM actor AS a
INNER JOIN film_actor AS fa
ON fa.actor_id = a.actor_id
GROUP BY
a.first_name,
a.last_name
HAVING COUNT(fa.film_id) >=5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT
f.title
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
INNER JOIN rental AS r
ON r.inventory_id = i.inventory_id
WHERE r.rental_id IN (
	SELECT
    rental_id
    FROM rental
    WHERE (return_date - rental_date) > 5);
    
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
-- *Empecé primero por la subconsulta, me dio menos errores haciendolo así.
SELECT
a.first_name,
a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
	SELECT
    a.actor_id
    FROM actor AS a
    INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
    INNER JOIN film_category AS fc
    ON fa.film_id = fc.film_id
    INNER JOIN category AS c
    ON c.category_id = fc.category_id
    WHERE c.name = 'Horror');

-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT
f.title AS titulo,
c.name AS categoria
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id = fc.film_id
INNER JOIN category AS c
ON c.category_id = fc.category_id
WHERE f.length > 180 AND c.name= 'Comedy';

-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

SELECT 
a1.first_name AS actor1_nombre,   -- añado dos grupos, actor 1 y actor 2 para hacer la busqueda de ambos para ver coincidencias.
a1.last_name AS actor1_apellido,
a2.first_name AS actor2_nombre,
a2.last_name AS actor2_apellido,
COUNT(*) AS Q_peliculas_juntos
FROM film_actor AS fa1
JOIN film_actor AS fa2 
ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id  -- *(evita que se repitan)
JOIN actor AS a1
ON fa1.actor_id = a1.actor_id
JOIN actor AS a2
ON fa2.actor_id = a2.actor_id
GROUP BY
fa1.actor_id,
fa2.actor_id,
a1.first_name,
a1.last_name,
a2.first_name,
a2.last_name
HAVING COUNT(*) >= 1;