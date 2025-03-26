-- Crear la tabla RE_cargos
CREATE TABLE RE_cargos (
    id_cargo NUMBER PRIMARY KEY,
    nombre_cargo VARCHAR2(100),
    nivel NUMBER CHECK (nivel BETWEEN 1 AND 5) -- Nivel del cargo (1 = Junior, 5 = Director)
);

-- Crear la tabla RE_personal
CREATE TABLE RE_personal (
    id_personal NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    salario_mensual NUMBER,
    id_cargo NUMBER,
    FOREIGN KEY (id_cargo) REFERENCES RE_cargos(id_cargo)
);


-- Insertar datos en RE_cargos
INSERT INTO RE_cargos (id_cargo, nombre_cargo, nivel) VALUES (1, 'Junior Developer', 1);
INSERT INTO RE_cargos (id_cargo, nombre_cargo, nivel) VALUES (2, 'Senior Developer', 3);
INSERT INTO RE_cargos (id_cargo, nombre_cargo, nivel) VALUES (3, 'Project Manager', 4);
INSERT INTO RE_cargos (id_cargo, nombre_cargo, nivel) VALUES (4, 'Director', 5);

-- Insertar datos en RE_personal
INSERT INTO RE_personal (id_personal, nombre, salario_mensual, id_cargo) VALUES (1, 'Pedro Gómez', 2000, 1);
INSERT INTO RE_personal (id_personal, nombre, salario_mensual, id_cargo) VALUES (2, 'Ana Torres', 3500, 2);
INSERT INTO RE_personal (id_personal, nombre, salario_mensual, id_cargo) VALUES (3, 'Carlos Ruiz', 5000, 3);
INSERT INTO RE_personal (id_personal, nombre, salario_mensual, id_cargo) VALUES (4, 'Marta López', 7000, 4);


-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


-- EJERCICO:

Crea una función almacenada en PL/SQL llamada calcular_salario_anual que reciba como parámetro el ID de un empleado del personal y devuelva el salario anual de ese empleado.


-- SOLUCION:



CREATE OR REPLACE FUNCTION calcular_salario_anual  (F_ID_PERSONAL NUMBER) RETURN NUMBER IS

V_SALARIO_ANUAL NUMBER;

BEGIN

    SELECT SALARIO_MENSUAL * 12 INTO V_SALARIO_ANUAL
    FROM RE_PERSONAL
    WHERE ID_PERSONAL = F_ID_PERSONAL;

    RETURN V_SALARIO_ANUAL;

EXCEPTION 

    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR( -20025,'EL EMPLEADO NO EXISTE');
    RETURN NULL;


END;



-- EJECUCION:

BEGIN 

DBMS_OUTPUT.PUT_LINE('EL EMPLEADO GANA: '|| calcular_salario_anual(10));

END;



-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- EJERCICIO II:


-- Se requiere crear una función en PL/SQL que, dado el nombre de un cargo, devuelva una cadena de texto con los nombres y salarios mensuales de todos los empleados que trabajan en ese cargo.


-- SOLUCION:


CREATE OR REPLACE FUNCTION obtener_personal_por_cargo (F_NOMBRE_CARGO VARCHAR2) RETURN VARCHAR2 IS

    V_CADENA_RESULTADO VARCHAR2(4000);

BEGIN


    FOR I IN (
        SELECT P.NOMBRE, P.SALARIO_MENSUAL
        FROM RE_PERSONAL P
        JOIN RE_CARGOS C ON P.ID_CARGO = C.ID_CARGO
        WHERE C.NOMBRE_CARGO = F_NOMBRE_CARGO
    ) LOOP

        V_CADENA_RESULTADO := V_CADENA_RESULTADO || 'Nombre: ' || I.NOMBRE || ', Salario: ' || I.SALARIO_MENSUAL || CHR(10);
    
    END LOOP;

    IF V_CADENA_RESULTADO IS NULL OR V_CADENA_RESULTADO = '' THEN
        RETURN 'No hay empleados con el cargo: ' || F_NOMBRE_CARGO;
    END IF;

    RETURN V_CADENA_RESULTADO;

END;




-- EJECUCION:


DECLARE

V_VARIABLE VARCHAR2(4000);

BEGIN

V_VARIABLE:=  obtener_personal_por_cargo('Director');

DBMS_OUTPUT.PUT_LINE(V_VARIABLE);

END;

