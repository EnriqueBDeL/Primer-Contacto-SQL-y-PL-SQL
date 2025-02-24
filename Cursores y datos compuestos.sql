-- 1. Crear una matriz asociativa para almacenar películas por año.


DECLARE


    TYPE MATRIZ_PELICULAS IS TABLE OF VARCHAR2(50);

    TYPE MATRIZ_PELICULAS_POR_ANO IS TABLE OF MATRIZ_PELICULAS INDEX BY BINARY_INTEGER;

    MATRIZ MATRIZ_PELICULAS_POR_ANO;

    V_ANO NUMBER;
    V_LISTA MATRIZ_PELICULAS;

BEGIN

    FOR REC IN (SELECT DISTINCT ANO FROM PELICULAS ORDER BY ANO) LOOP
        V_ANO := REC.ANO;

        SELECT TITULO BULK COLLECT INTO V_LISTA
        FROM PELICULAS
        WHERE ANO = V_ANO;

        MATRIZ(V_ANO) := V_LISTA;


    END LOOP;
    
    V_ANO := MATRIZ.FIRST;

    WHILE V_ANO IS NOT NULL LOOP

        IF MATRIZ.EXISTS(V_ANO) THEN

            DBMS_OUTPUT.PUT_LINE('Películas del año ' || V_ANO || ':');


            FOR I IN 1 .. MATRIZ(V_ANO).COUNT LOOP

                DBMS_OUTPUT.PUT_LINE(' - ' || MATRIZ(V_ANO)(I));

            END LOOP;

        END IF;

        V_ANO := MATRIZ.NEXT(V_ANO);

    END LOOP;

END;



-- 2. Crear una matriz asociativa para almacenar los directores y sus películas.


DECLARE

    TYPE PELICULAS IS TABLE OF VARCHAR2(50);

    TYPE DIRECTORES_PELICULAS IS TABLE OF PELICULAS INDEX BY BINARY_INTEGER;
    
    MATRIZ DIRECTORES_PELICULAS;

    V_DIRECTOR NUMBER;
    V_LISTA PELICULAS;


BEGIN

    FOR REC IN (SELECT DISTINCT DIRECTOR FROM PELICULAS ORDER BY DIRECTOR) LOOP

        V_DIRECTOR := REC.DIRECTOR;

        SELECT TITULO BULK COLLECT INTO V_LISTA
        FROM PELICULAS
        WHERE DIRECTOR = V_DIRECTOR;

        MATRIZ(V_DIRECTOR) := V_LISTA;

    END LOOP;
    

    V_DIRECTOR := MATRIZ.FIRST;

    WHILE V_DIRECTOR IS NOT NULL LOOP

        DBMS_OUTPUT.PUT_LINE('Directores id ' || V_DIRECTOR || ':');

        FOR I IN 1 .. MATRIZ(V_DIRECTOR).COUNT LOOP

            DBMS_OUTPUT.PUT_LINE(' - ' || MATRIZ(V_DIRECTOR)(I));

        END LOOP;

        V_DIRECTOR := MATRIZ.NEXT(V_DIRECTOR);

    END LOOP;

END;




-- 3. Crear un procedimiento que lista las películas dirigidas por un director específico.


CREATE OR REPLACE PROCEDURE LISTAR_PELICULAS_DIRECTOR (P_DIRECTOR_ID IN NUMBER) IS

BEGIN

    FOR REC IN (SELECT TITULO FROM PELICULAS WHERE DIRECTOR = P_DIRECTOR_ID ORDER BY TITULO) LOOP

        DBMS_OUTPUT.PUT_LINE(REC.TITULO);

    END LOOP;



END;




BEGIN

    LISTAR_PELICULAS_DIRECTOR(3);

END;



-- 4. Crear un procedimiento que mostrará una "X" en la intersección si un actor ha participado en una película, y dejará el espacio vacío si no ha participado.



DECLARE


    TYPE MATRIZ_ESQUEMA IS TABLE OF VARCHAR2(1) INDEX BY VARCHAR2(100);

    TYPE FILA_ESQUEMA IS TABLE OF MATRIZ_ESQUEMA INDEX BY VARCHAR2(100);

    MATRIZ FILA_ESQUEMA;
    V_ACTOR VARCHAR2(100);
    V_PELICULA VARCHAR2(100);
    TITULOS VARCHAR2(4000);
    LINEA_SEPARADORA VARCHAR2(4000);
    FILA VARCHAR2(4000);

BEGIN


    FOR ACT IN (SELECT ID, NOMBRE FROM ACTORES) LOOP

        FOR PEL IN (SELECT ID, TITULO FROM PELICULAS) LOOP

            SELECT COUNT(*) INTO V_ACTOR
            FROM PARTICIPAR_PELICULA
            WHERE ACTOR_ID = ACT.ID AND PELICULA_ID = PEL.ID;

            IF V_ACTOR > 0 THEN

                MATRIZ(ACT.NOMBRE)(PEL.TITULO) := 'X';
            ELSE
                MATRIZ(ACT.NOMBRE)(PEL.TITULO) := ' ';

            END IF;

        END LOOP;

    END LOOP;

    TITULOS := '|';
    LINEA_SEPARADORA := '|';
    

    FOR PEL IN (SELECT TITULO FROM PELICULAS) LOOP

        TITULOS := TITULOS || ' ' || PEL.TITULO || ' |';

        LINEA_SEPARADORA := '-----------------------------------------------------------------------------------------------------------------------------------';

    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(TITULOS);
    DBMS_OUTPUT.PUT_LINE(LINEA_SEPARADORA);


    FOR ACT IN (SELECT NOMBRE FROM ACTORES) LOOP

        FILA := ACT.NOMBRE || '|';
        

        FOR PEL IN (SELECT TITULO FROM PELICULAS) LOOP

            FILA := FILA || ' ' || NVL(MATRIZ(ACT.NOMBRE)(PEL.TITULO), ' ') || ' |';

        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(FILA);

    END LOOP;
    
END;



