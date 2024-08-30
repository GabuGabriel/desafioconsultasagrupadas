A continuación, una empresa que dicta cursos de inglés nos hace entrega de un set de datos
que contiene información de inscritos. Estas inscripciones se realizan a través de dos vías,
por página web y por el blog de la institución.
Con el set de datos, nos solicitan que realicemos un conjunto de consultas que serán
utilizadas para saber cuál es el medio que más utilizan los/as futuros estudiantes y cuál
tiene más impacto en las redes sociales.
El set de datos es el siguiente:

--------------------------------------------------
-- Crear la tabla INSCRITOS
CREATE TABLE INSCRITOS(cantidad INT, fecha DATE, fuente VARCHAR);

-- Insertar los datos
INSERT INTO INSCRITOS(cantidad, fecha, fuente) VALUES
( 44, '01/01/2021', 'Blog' ),
( 56, '01/01/2021', 'Pagina' ),
( 39, '01/02/2021', 'Blog' ),
( 81, '01/02/2021', 'Pagina' ),
( 12, '01/03/2021', 'Blog' ),
( 91, '01/03/2021', 'Pagina' ),
( 48, '01/04/2021', 'Blog' ),
( 45, '01/04/2021', 'Pagina' ),
( 55, '01/05/2021', 'Blog' ),
( 33, '01/05/2021', 'Pagina' ),
( 18, '01/06/2021', 'Blog' ),
( 12, '01/06/2021', 'Pagina' ),
( 34, '01/07/2021', 'Blog' ),
( 24, '01/07/2021', 'Pagina' ),
( 83, '01/08/2021', 'Blog' ),
( 99, '01/08/2021', 'Pagina' );

-- 1. ¿Cuántos registros hay?
SELECT COUNT(*) AS total_registros FROM INSCRITOS;
 total_registros
-----------------
              16
(1 row)


-- 2. ¿Cuántos inscritos hay en total?
SELECT SUM(cantidad) AS total_inscritos FROM INSCRITOS;
 total_inscritos
-----------------
             774
(1 row)


-- 3. ¿Cuál o cuáles son los registros de mayor antigüedad?
SELECT * FROM INSCRITOS 
WHERE fecha = (SELECT MIN(fecha) FROM INSCRITOS);
 cantidad |   fecha    | fuente
----------+------------+--------
       44 | 2021-01-01 | Blog
       56 | 2021-01-01 | Pagina
(2 rows)


-- 4. ¿Cuántos inscritos hay por día?
SELECT fecha, SUM(cantidad) AS inscritos_por_dia
FROM INSCRITOS
GROUP BY fecha
ORDER BY fecha;
   fecha    | inscritos_por_dia
------------+-------------------
 2021-01-01 |               100
 2021-01-02 |               120
 2021-01-03 |               103
 2021-01-04 |                93
 2021-01-05 |                88
 2021-01-06 |                30
 2021-01-07 |                58
 2021-01-08 |               182
(8 rows)

-- 5. ¿Cuántos inscritos hay por fuente?
SELECT fuente, SUM(cantidad) AS inscritos_por_fuente
FROM INSCRITOS
GROUP BY fuente;
 fuente | inscritos_por_fuente
--------+----------------------
 Blog   |                  333
 Pagina |                  441
(2 rows)


-- 6. ¿Qué día se inscribió la mayor cantidad de personas y cuántas?
SELECT fecha, SUM(cantidad) AS total_inscritos
FROM INSCRITOS
GROUP BY fecha
ORDER BY total_inscritos DESC
LIMIT 1;
   fecha    | total_inscritos
------------+-----------------
 2021-01-08 |             182
(1 row)


-- 7. ¿Qué días se inscribieron la mayor cantidad de personas utilizando el blog y cuántas fueron?
SELECT fecha, cantidad AS inscritos_blog
FROM INSCRITOS
WHERE fuente = 'Blog' AND cantidad = (
    SELECT MAX(cantidad)
    FROM INSCRITOS
    WHERE fuente = 'Blog'
);
   fecha    | inscritos_blog
------------+----------------
 2021-01-08 |             83
(1 row)


-- 8. ¿Cuál es el promedio de personas inscritas por día?
Toma en consideración que la
base de datos tiene un registro de 8 días, es decir, se obtendrán 8 promedios.
SELECT fecha, AVG(cantidad) AS promedio_diario
FROM INSCRITOS
GROUP BY fecha
ORDER BY fecha;
   fecha    |   promedio_diario
------------+---------------------
 2021-01-01 | 50.0000000000000000
 2021-01-02 | 60.0000000000000000
 2021-01-03 | 51.5000000000000000
 2021-01-04 | 46.5000000000000000
 2021-01-05 | 44.0000000000000000
 2021-01-06 | 15.0000000000000000
 2021-01-07 | 29.0000000000000000
 2021-01-08 | 91.0000000000000000
(8 rows)


-- 9. ¿Qué días se inscribieron más de 50 personas?
SELECT fecha, SUM(cantidad) AS total_inscritos
FROM INSCRITOS
GROUP BY fecha
HAVING SUM(cantidad) > 50
ORDER BY fecha;
   fecha    | total_inscritos
------------+-----------------
 2021-01-01 |             100
 2021-01-02 |             120
 2021-01-03 |             103
 2021-01-04 |              93
 2021-01-05 |              88
 2021-01-07 |              58
 2021-01-08 |             182
(7 rows)


-- 10. ¿Cuál es el promedio por día de personas inscritas considerando sólo calcular desde el tercer día?
SELECT fecha, AVG(cantidad) AS promedio_diario
FROM INSCRITOS
WHERE fecha IN (
    SELECT fecha
    FROM INSCRITOS
    GROUP BY fecha
    ORDER BY fecha
    LIMIT (SELECT COUNT(DISTINCT fecha) FROM INSCRITOS) - 2
)
GROUP BY fecha
ORDER BY fecha;
   fecha    |   promedio_diario
------------+---------------------
 2021-01-01 | 50.0000000000000000
 2021-01-02 | 60.0000000000000000
 2021-01-03 | 51.5000000000000000
 2021-01-04 | 46.5000000000000000
 2021-01-05 | 44.0000000000000000
 2021-01-06 | 15.0000000000000000
(6 rows)

