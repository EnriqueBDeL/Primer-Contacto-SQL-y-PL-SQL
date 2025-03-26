-- REPASO CURSOR:

-- Crear la tabla de departamentos
CREATE TABLE RE_departamentos (
    id_departamento NUMBER PRIMARY KEY,
    nombre_departamento VARCHAR2(100)
);

-- Crear la tabla de empleados
CREATE TABLE RE_empleados (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    salario NUMBER,
    id_departamento NUMBER,
    FOREIGN KEY (id_departamento) REFERENCES RE_departamentos(id_departamento)
);



-- Insertar datos en RE_departamentos
INSERT INTO RE_departamentos (id_departamento, nombre_departamento) VALUES (1, 'Ventas');
INSERT INTO RE_departamentos (id_departamento, nombre_departamento) VALUES (2, 'Recursos Humanos');
INSERT INTO RE_departamentos (id_departamento, nombre_departamento) VALUES (3, 'TI');

-- Insertar datos en RE_empleados
INSERT INTO RE_empleados (id_empleado, nombre, salario, id_departamento) VALUES (1, 'Juan Pérez', 3500, 1);
INSERT INTO RE_empleados (id_empleado, nombre, salario, id_departamento) VALUES (2, 'Ana López', 4000, 1);
INSERT INTO RE_empleados (id_empleado, nombre, salario, id_departamento) VALUES (3, 'Carlos García', 2900, 2);
INSERT INTO RE_empleados (id_empleado, nombre, salario, id_departamento) VALUES (4, 'Luis Martínez', 3100, 3);
INSERT INTO RE_empleados (id_empleado, nombre, salario, id_departamento) VALUES (5, 'María Sánchez', 2800, 3);



-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


-- EJERCICIO:

-- Crea un procedimiento almacenado en PL/SQL llamado mostrar_empleados_por_departamento que reciba como parámetro el nombre de un departamento y utilice un cursor explícito para listar el nombre y salario de los empleados que pertenecen a ese departamento.


-- SOLUCION:


CREATE OR REPLACE PROCEDURE mostrar_empleados_por_departamento (P_NOMBRE_DEPARTAMENTO VARCHAR2) IS

CURSOR BUSCAR IS 
SELECT e.nombre, e.salario
FROM RE_EMPLEADOS E
JOIN RE_DEPARTAMENTOS D ON E.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO 
WHERE D.NOMBRE_DEPARTAMENTO = P_NOMBRE_DEPARTAMENTO;


V_NOMBRE RE_EMPLEADOS.NOMBRE%TYPE;
V_SALARIO RE_EMPLEADOS.SALARIO%TYPE;

BEGIN

    OPEN BUSCAR;

    LOOP

    FETCH BUSCAR INTO V_NOMBRE, V_SALARIO;

    EXIT WHEN BUSCAR%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(V_NOMBRE || ' ' || V_SALARIO);

    END LOOP;

    CLOSE BUSCAR;


END;





-- EJECUCION:


BEGIN 

mostrar_empleados_por_departamento('TI');

END;

