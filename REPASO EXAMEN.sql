EJERCICIOS REPASO ANTES DE EXAMEN:


EJERCICIO 1:

Crea un bloque PL/SQL que declare un cursor para recorrer todos los empleados que ganan más de 2000, y muestre su nombre, departamento y salario con DBMS_OUTPUT.



CREATE TABLE EF_EMPLEADOS (
    ID            NUMBER PRIMARY KEY,
    NOMBRE        VARCHAR2(50),
    DEPARTAMENTO  VARCHAR2(30),
    SALARIO       NUMBER(10, 2)
);


INSERT INTO EF_EMPLEADOS VALUES (1, 'Ana López', 'Ventas', 1800);
INSERT INTO EF_EMPLEADOS VALUES (2, 'Luis García', 'Marketing', 2200);
INSERT INTO EF_EMPLEADOS VALUES (3, 'María Pérez', 'Ventas', 2500);
INSERT INTO EF_EMPLEADOS VALUES (4, 'Juan Torres', 'Contabilidad', 1700);
INSERT INTO EF_EMPLEADOS VALUES (5, 'Laura Ruiz', 'Marketing', 1900);



SOLUCIÓN:

DECLARE

CURSOR RICOS IS 
SELECT NOMBRE, DEPARTAMENTO, SALARIO
FROM EF_EMPLEADOS
WHERE SALARIO > 2000;



BEGIN


FOR C IN RICOS LOOP 

DBMS_OUTPUT.PUT_LINE('Empleado: ' || C.NOMBRE || ' | Departamento: ' || C.DEPARTAMENTO ||  ' | Salario: ' || C.SALARIO);
END LOOP;

END;


|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 2:

Crea un bloque PL/SQL que:

Declare un cursor que seleccione los empleados del departamento 'Marketing'.

Solo muestre aquellos cuyo salario sea menor o igual a 2000.


Imprima su nombre, salario y un mensaje:
-> 'Salario bajo' si gana menos de 2000.
-> 'Salario justo' si gana exactamente 2000.

SOLUCIÓN:

DECLARE
    CURSOR EMPLEADOS_DEPARTAMENTO IS
        SELECT NOMBRE, SALARIO
        FROM EF_EMPLEADOS
        WHERE DEPARTAMENTO = 'Marketing';

    V_MENSAJE VARCHAR2(100);
BEGIN
    FOR I IN EMPLEADOS_DEPARTAMENTO LOOP
        IF I.SALARIO < 2000 THEN
            V_MENSAJE := 'Salario bajo';
        ELSIF I.SALARIO = 2000 THEN
            V_MENSAJE := 'Salario JUSTO';
        END IF;

        DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || I.NOMBRE || ' | SALARIO: ' || I.SALARIO || ' => ' || V_MENSAJE);
    END LOOP;
END;


|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

EJERCICIO 3:


Crea un procedimiento almacenado en PL/SQL llamado REGISTRAR_EN_ACTIVIDAD que reciba dos parámetros: el ID de una persona y el ID de una actividad.

El procedimiento debe registrar a la persona en la actividad insertando un registro en la tabla CG_REGISTROS que tiene las columnas:

ID_PERSONA (número)

ID_ACTIVIDAD (número)

FECHA_REGISTRO (fecha)


Antes de insertar, el procedimiento debe verificar si esa persona ya está registrada en esa actividad.

Si ya existe el registro, debe lanzar una excepción con un mensaje que indique que el usuario ya está registrado en la actividad.

Si no existe, debe realizar la inserción con la fecha actual (SYSDATE).



SOLUCIÓN:


CREATE OR REPLACE PROCEDURE REGISTRAR_EN_ACTIVIDAD (P_ID_P NUMBER, P_ID_A NUMBER) IS

V_P CG_REGISTROS.ID_PERSONA%TYPE;
V_A CG_REGISTROS.ID_ACTIVIDAD%TYPE;

BEGIN

    SELECT ID_PERSONA, ID_ACTIVIDAD INTO V_P,V_A
    FROM CG_REGISTROS 
    WHERE ID_PERSONA = P_ID_P AND ID_ACTIVIDAD = P_ID_A;
   
    RAISE_APPLICATION_ERROR(-20444,'EL USUARIO YA ESTÁ REGISTRADO EN UNA ACTIVIDAD.');

EXCEPTION

    WHEN NO_DATA_FOUND THEN

    INSERT INTO CG_REGISTROS VALUES (P_ID_P,P_ID_A,SYSDATE);

END;




BEGIN

REGISTRAR_EN_ACTIVIDAD(2,102);


END;


|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 4:

Crea una función en PL/SQL llamada CALCULAR_TOTAL_PIEZAS que reciba como parámetro el ID del coche y devuelva el número total de piezas que tiene ese coche.

La información está distribuida en dos tablas:

CO_COCHE: almacena la información básica de los coches.

CO_PIEZA: almacena las piezas que pertenecen a cada coche.

La función debe sumar la cantidad de todas las piezas asociadas al coche.

Si el coche con el ID dado no existe, la función debe lanzar una excepción con un mensaje indicando que el coche no fue encontrado.



SOLUCIÓN:


CREATE OR REPLACE FUNCTION CALCULAR_TOTAL_PIEZAS (F_ID NUMBER) RETURN NUMBER IS

V_NOMBRE CO_COCHE.NOMBRE%TYPE;
V_TOTAL NUMBER := 0;

BEGIN

    SELECT NOMBRE INTO V_NOMBRE
    FROM CO_COCHE
    WHERE ID_COCHE = F_ID;

FOR I IN (SELECT CANTIDAD
           FROM CO_PIEZA
           WHERE ID_COCHE = F_ID) LOOP

    V_TOTAL := V_TOTAL + I.CANTIDAD;

END LOOP;

RETURN V_TOTAL;
   
EXCEPTION

    WHEN NO_DATA_FOUND THEN

    RAISE_APPLICATION_ERROR (-20444,'COCHE NO ENCONTRADO.');
    

END;






DECLARE

V_N NUMBER := CALCULAR_TOTAL_PIEZAS(1);

BEGIN

    DBMS_OUTPUT.PUT_LINE('EL COCHE TIENE: '||V_N || ' PIEZAS.');

END;



|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||





