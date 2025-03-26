-- TABLA

CREATE TABLE empleados (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    salario NUMBER
);


-- INSERCCIONES

INSERT INTO empleados (id_empleado, nombre, salario) VALUES (1, 'Juan Pérez', 3500);
INSERT INTO empleados (id_empleado, nombre, salario) VALUES (2, 'Ana López', 4000);
INSERT INTO empleados (id_empleado, nombre, salario) VALUES (3, 'Carlos García', 2900);
INSERT INTO empleados (id_empleado, nombre, salario) VALUES (4, 'Luis Martínez', 3100);
INSERT INTO empleados (id_empleado, nombre, salario) VALUES (5, 'María Sánchez', 2800);


-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

--  Crea un cursor que recorra una tabla de empleados y muestra los nombres y salarios de aquellos cuyo salario sea mayor a 3000. 
-- Además, se agregan algunos controles básicos, como el manejo de excepciones.



DECLARE

    CURSOR C_EMPLEADOS IS 
    SELECT NOMBRE, SALARIO
    FROM EMPLEADOS
    WHERE SALARIO > 3000;

V_NOMBRE VARCHAR2(100);
V_SALARIO NUMBER;

BEGIN

    OPEN C_EMPLEADOS;

    LOOP

    FETCH C_EMPLEADOS INTO V_NOMBRE, V_SALARIO;

       EXIT WHEN C_EMPLEADOS%NOTFOUND;

       DBMS_OUTPUT.PUT_LINE('Nombre: ' || V_NOMBRE || ', Salario: ' || V_SALARIO);

    END LOOP;

     CLOSE C_EMPLEADOS;

 EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);

        IF C_EMPLEADOS%ISOPEN THEN

            CLOSE C_EMPLEADOS;  

        END IF;

END;