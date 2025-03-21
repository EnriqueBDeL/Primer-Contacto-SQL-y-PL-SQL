-- Tablas y Datos:

-- 1º  Ejecución
DECLARE
TYPE array_t IS VARRAY(5) OF VARCHAR2(20);
table_names array_t := array_t('ACTORES', 'DIRECTORES', 'PELICULAS',
'PARTICIPAR_PELICULA');
existe NUMBER := 0;
BEGIN
FOR i IN 1..table_names.COUNT LOOP
BEGIN
BEGIN
SELECT 1 into existe FROM user_tables WHERE table_name =
table_names(i) AND ROWNUM = 1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
existe := 0;
END;
CASE
WHEN existe = 0 THEN
DBMS_OUTPUT.PUT_LINE('La tabla ' || table_names(i) || ' no
existe.');
WHEN existe = 1 THEN
EXECUTE IMMEDIATE 'DROP TABLE ' || table_names(i) || ' CASCADE
CONSTRAINTS';
DBMS_OUTPUT.PUT_LINE('La tabla ' || table_names(i) || ' ha sido
eliminada.');
END CASE;
END;
END LOOP;
END;



-- 2º  Ejecución
DECLARE
v_sql1 VARCHAR2(1000);
v_sql2 VARCHAR2(1000);
v_sql3 VARCHAR2(1000);
v_sql4 VARCHAR2(1000);
BEGIN
v_sql1 := 'CREATE TABLE ACTORES (
id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
nombre VARCHAR2(100) NOT NULL,
fecha_nacimiento DATE,
nacionalidad VARCHAR2(50)
)';
v_sql2 := 'CREATE TABLE DIRECTORES (
id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
nombre VARCHAR2(100) NOT NULL,
fecha_nacimiento DATE,
nacionalidad VARCHAR2(50)
)';
v_sql3 := 'CREATE TABLE PELICULAS (
id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
titulo VARCHAR2(200) NOT NULL,
año NUMBER,
director_id NUMBER,
CONSTRAINT fk_PELICULAS_director FOREIGN KEY (director_id)
REFERENCES DIRECTORES(id) ON DELETE SET NULL
)';
v_sql4 := 'CREATE TABLE PARTICIPAR_PELICULA (
actor_id NUMBER,
pelicula_id NUMBER,
personaje VARCHAR2(100),
PRIMARY KEY (actor_id, pelicula_id),
CONSTRAINT fk_PARTICIPAR_PELICULA_actor FOREIGN KEY
(actor_id) REFERENCES ACTORES(id) ON DELETE CASCADE,
CONSTRAINT fk_PARTICIPAR_PELICULA_pelicula FOREIGN KEY
(pelicula_id) REFERENCES PELICULAS(id) ON DELETE CASCADE
)';
EXECUTE IMMEDIATE v_sql1;
EXECUTE IMMEDIATE v_sql2;
EXECUTE IMMEDIATE v_sql3;
EXECUTE IMMEDIATE v_sql4;
END;



-- 3º  Ejecución
BEGIN
-- Insertar actores
INSERT INTO ACTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (1,
'Leonardo DeCabrios', TO_DATE('1974-11-11', 'YYYY-MM-DD'), 'Estadounidense');
INSERT INTO ACTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (2,
'Paco Tigretón', TO_DATE('1978-01-11', 'YYYY-MM-DD'), 'Española');
INSERT INTO ACTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (3,
'Vin Gasoil', TO_DATE('1978-02-23', 'YYYY-MM-DD'), 'Estadounidense');
INSERT INTO ACTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (4,
'Scarlata HijadeJuan', TO_DATE('1984-11-22', 'YYYY-MM-DD'), 'Estadounidense');
INSERT INTO ACTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (5,
'Mario Pastas', TO_DATE('1986-05-12', 'YYYY-MM-DD'), 'Española');
-- Insertar directores
INSERT INTO DIRECTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (1,
'Steven Spilbero', TO_DATE('1974-11-11', 'YYYY-MM-DD'), 'Estadounidense');
INSERT INTO DIRECTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (2,
'Paco Tigretón', TO_DATE('1978-01-11', 'YYYY-MM-DD'), 'Española');
INSERT INTO DIRECTORES (id, nombre, fecha_nacimiento, nacionalidad) VALUES (3,
'Pato Lucas', TO_DATE('1978-02-23', 'YYYY-MM-DD'), 'Estadounidense');
-- Insertar películas
INSERT INTO PELICULAS (id, titulo, año, director_id) VALUES (1, 'Piratas del
río Segura', 2010, 1);
INSERT INTO PELICULAS (id, titulo, año, director_id) VALUES (2, 'Paparajote
Wars', 1978, 3);
INSERT INTO PELICULAS (id, titulo, año, director_id) VALUES (3, 'Paquita
Salsas', 2020, 2);
INSERT INTO PELICULAS (id, titulo, año, director_id) VALUES (4, 'Slow and Quiet
10', 2024, 1);
INSERT INTO PELICULAS (id, titulo, año, director_id) VALUES (5, 'Como matar a
tu profe 2', 2023, 1);
-- Insertar participaciones en películas
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (1,
1, 'Capitán Despistado');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (3,
1, 'Grumete Tontín');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (5,
1, 'Palmera');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (2,
2, 'Maestro Limoncillo');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (4,
2, 'Hank Acompañado');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (5,
2, 'Darth Pimiento');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (2,
3, 'Paquita Salsas');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (3,
3, 'La verdulera');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (4,
3, 'Maese Champiñon');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (3,
4, 'Dominic Tortuga');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (1,
4, 'Brian Relento');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (5,
4, 'Rueda derecha');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (1,
5, 'Alumno Vengador');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (4,
5, 'Antonio Llanes');
INSERT INTO PARTICIPAR_PELICULA (actor_id, pelicula_id, personaje) VALUES (2,
5, 'Chico sin camisa');
END;


-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

-- 1. Haz un bloque anónimo que muestre el siguiente mensaje: '"El actor Vin Gasoil es de nacionalidad estadounidense"



DECLARE 

    V_NACIONALIDAD VARCHAR2(50);

BEGIN


    SELECT NACIONALIDAD INTO V_NACIONALIDAD
    FROM ACTORES
    WHERE NOMBRE = 'Vin Gasoil';


    DBMS_OUTPUT.PUT_LINE('El actor Vin Gasoil es de nacionalidad ' || V_NACIONALIDAD || '.');

END;








-- 2. Haz un bloque anónimo que muestre  el siguiente mensaje: "La edad de Mario Pastas es 39 años"


DECLARE 

    V_EDAD NUMBER(4);

BEGIN


    SELECT MONTHS_BETWEEN(SYSDATE,FECHA_NACIMIENTO)/12 INTO V_EDAD
    FROM ACTORES
    WHERE NOMBRE = 'Mario Pastas';


    DBMS_OUTPUT.PUT_LINE('La edad de Mario Pastas es ' || V_EDAD || ' años');

END;








-- 3. Haz un bloque anónimo que muestre  el siguiente mensaje: "El total de actores españoles en la base de datos es 2"


DECLARE 

    V_NUMERONACIONALIDADES NUMBER(4);

BEGIN


    SELECT COUNT(NOMBRE) INTO V_NUMERONACIONALIDADES
    FROM ACTORES
    WHERE NACIONALIDAD = 'Española';


    DBMS_OUTPUT.PUT_LINE('El total de actores españoles en la base de datos es ' || V_NUMERONACIONALIDADES );

END;









-- 4. Haz un bloque anónimo que inserte al actor Ricardo Machín que nació el 15-03-1956 y es argentino y muestre el mensaje: "Actor Ricardo Machín insertado".



DECLARE 

    V_ID NUMBER(4);
    V_NOMBRE VARCHAR(50) := 'Ricardo Machín';
    V_FECHANACIMIENTO DATE := TO_DATE('15-03-1956','DD-MM-YYYY');
    V_NACIONALIDAD VARCHAR(50) := 'Argentino';

BEGIN

    SELECT MAX(ID) INTO V_ID
    FROM ACTORES;

    V_ID := V_ID + 1;

    INSERT INTO ACTORES VALUES (V_ID, V_NOMBRE, V_FECHANACIMIENTO, V_NACIONALIDAD); 


    DBMS_OUTPUT.PUT_LINE('Actor ' || V_NOMBRE || ' insertado.' );

END;






-- 5. Haz un bloque anónimo que actualice la nacionalidad de Steven Spilbero a mexicana.



DECLARE 


    V_NACIONALIDAD VARCHAR(50) := 'Mexicana';

BEGIN

 
    UPDATE DIRECTORES SET NACIONALIDAD = V_NACIONALIDAD
    WHERE NOMBRE = 'Steven Spilbero';



END;




-- 6. Haz un bloque anónimo que muestre la diferencia de años entre la publicación de 'Como matar a tu profe 2' y 'Paparajote Wars'



DECLARE 

 V_FECHA1 NUMBER;
 V_FECHA2 NUMBER;
 RESULTADO NUMBER;
  

BEGIN

 
    SELECT ANO INTO V_FECHA1
    FROM PELICULAS
    WHERE TITULO ='Como matar a tu profe 2';

    SELECT ANO INTO V_FECHA2
    FROM PELICULAS
    WHERE TITULO ='Paparajote Wars';


    RESULTADO := V_FECHA1 - V_FECHA2;


    DBMS_OUTPUT.PUT_LINE('La diferencia de años entre la publicación es: ' || RESULTADO);


END;

