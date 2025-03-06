CREATE OR REPLACE PROCEDURE MANAGE_TABLES AS
    v_count NUMBER;
BEGIN
    -- Verificar y eliminar tablas si existen
    FOR table_rec IN (SELECT table_name FROM user_tables
                      WHERE table_name IN ('CR_MONEDA', 'CR_TIEMPO',
                                            'CR_TRANSACCION', 'CR_USUARIO')) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || table_rec.table_name || ' CASCADE CONSTRAINTS PURGE';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('No se pudo eliminar la tabla ' ||
                                      table_rec.table_name || ': ' || SQLERRM);
        END;
    END LOOP;

    -- Crear tablas nuevamente
    EXECUTE IMMEDIATE 'CREATE TABLE CR_MONEDA (
        ID_MONEDA NUMBER PRIMARY KEY,
        NOMBRE VARCHAR2(100),
        FOTO BLOB,
        MIME VARCHAR2(20),
        NOMBRE_ARCHIVO VARCHAR2(100)
    )';
    
    EXECUTE IMMEDIATE 'CREATE TABLE CR_TIEMPO (
        ID_TIEMPO NUMBER PRIMARY KEY,
        DIA NUMBER,
        MES NUMBER,
        ANIO NUMBER
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE CR_USUARIO (
        ID_USUARIO NUMBER PRIMARY KEY,
        NOMBRE VARCHAR2(100),
        SALDO NUMBER
    )';

    EXECUTE IMMEDIATE 'CREATE TABLE CR_TRANSACCION (
        ID_MONEDA NUMBER,
        ID_TIEMPO NUMBER,
        ID_USUARIO NUMBER,
        TIPO NUMBER CONSTRAINT CHK_TIPO CHECK (TIPO IN (0,1)),
        NUMERO NUMBER,
        PRECIO NUMBER,
        PRIMARY KEY (ID_MONEDA, ID_TIEMPO, ID_USUARIO, TIPO),
        CONSTRAINT FK_TRANSACCION_MONEDA FOREIGN KEY (ID_MONEDA) REFERENCES CR_MONEDA(ID_MONEDA),
        CONSTRAINT FK_TRANSACCION_TIEMPO FOREIGN KEY (ID_TIEMPO) REFERENCES CR_TIEMPO(ID_TIEMPO),
        CONSTRAINT FK_TRANSACCION_USUARIO FOREIGN KEY (ID_USUARIO) REFERENCES CR_USUARIO(ID_USUARIO)
    )';

    -- Inserción de datos de prueba
    EXECUTE IMMEDIATE 'INSERT INTO CR_MONEDA (ID_MONEDA, NOMBRE, MIME, NOMBRE_ARCHIVO) VALUES (1, ''Bitcochin'', ''image/png'', ''Bitcochin.png'')';
    EXECUTE IMMEDIATE 'INSERT INTO CR_MONEDA (ID_MONEDA, NOMBRE, MIME, NOMBRE_ARCHIVO) VALUES (2, ''Tethereum'', ''image/png'', ''Tethereum.png'')';
    EXECUTE IMMEDIATE 'INSERT INTO CR_MONEDA (ID_MONEDA, NOMBRE, MIME, NOMBRE_ARCHIVO) VALUES (3, ''YaoMingCoin'', ''image/png'', ''YaoMingCoin.png'')';
    EXECUTE IMMEDIATE 'INSERT INTO CR_TIEMPO (ID_TIEMPO, DIA, MES, ANIO) VALUES (1032025, 1, 3, 2025)';
    EXECUTE IMMEDIATE 'INSERT INTO CR_TIEMPO (ID_TIEMPO, DIA, MES, ANIO) VALUES (2032025, 2, 3, 2025)';
    EXECUTE IMMEDIATE 'INSERT INTO CR_USUARIO (ID_USUARIO, NOMBRE, SALDO) VALUES (1, ''Armando Guerra Segura'', 1000)';
    EXECUTE IMMEDIATE 'INSERT INTO CR_USUARIO (ID_USUARIO, NOMBRE, SALDO) VALUES (2, ''Dolores Fuertes de Barriga'', 2000)';
    EXECUTE IMMEDIATE 'INSERT INTO CR_USUARIO (ID_USUARIO, NOMBRE, SALDO) VALUES (3, ''Emiliano Salido del Pozo'', 10000)';

    DBMS_OUTPUT.PUT_LINE('Tablas recreadas y datos insertados correctamente.');
END MANAGE_TABLES;






--EJERCICIO EXCEPCIONES:

--1.-Crear un procedimiento para insertar una transacción de compra REALIZAR_TRANSACCION().
-- -Si es de tipo compra:
-- -En el procedimiento se comprueba si el usuario tiene saldo. Si no tiene saldo se lanza una excepción ex_saldo_insuficiente.
-- SI es de tipo venta:
-- Se comprueba si tiene monedas. Si no las tiene se lanza una excepción ex_monedas_insuficientes.
-- Si las tiene, se actualiza el saldo del usuario
--Si no existe el usuario crear una excepcion con el codigo error (20001 y el mensaje El usuario no existe)
--Si no existe la moneda manejar la excepción con el codigo error (20002 y el mensaje La moneda no existe)
--Si no existe el id_tiempo manejar la excepción con el codigo error (20003 y el mensaje 'El tiempo con ID ' || p_id_tiempo || ' no existe)





--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



CREATE OR REPLACE PROCEDURE REALIZAR_TRANSACCION(
    P_ID_USUARIO IN NUMBER,
    P_ID_TIEMPO IN NUMBER,
    P_ID_MONEDA IN NUMBER,
    P_TIPO IN NUMBER,
    P_NUMERO IN NUMBER,
    P_PRECIO IN NUMBER
) IS

    EX_SALDO_INSUFICIENTE EXCEPTION;
    EX_MONEDAS_INSUFICIENTES EXCEPTION;
    EX_USUARIO_NO_EXISTE EXCEPTION;
    EX_MONEDA_NO_EXISTE EXCEPTION;
    EX_TIEMPO_NO_EXISTE EXCEPTION;

    V_SALDO NUMBER;
    V_MONEDAS NUMBER;

BEGIN

    BEGIN
        SELECT SALDO INTO V_SALDO
        FROM CR_USUARIO
        WHERE ID_USUARIO = P_ID_USUARIO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE EX_USUARIO_NO_EXISTE;
    END;

    BEGIN
        SELECT COUNT(*) INTO V_MONEDAS
        FROM CR_MONEDA
        WHERE ID_MONEDA = P_ID_MONEDA;
        IF V_MONEDAS = 0 THEN
            RAISE EX_MONEDA_NO_EXISTE;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE EX_MONEDA_NO_EXISTE;
    END;

    BEGIN
        SELECT COUNT(*) INTO V_MONEDAS
        FROM CR_TIEMPO
        WHERE ID_TIEMPO = P_ID_TIEMPO;
        IF V_MONEDAS = 0 THEN
            RAISE EX_TIEMPO_NO_EXISTE;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE EX_TIEMPO_NO_EXISTE;
    END;

    IF P_TIPO = 1 THEN
        IF V_SALDO < (P_NUMERO * P_PRECIO) THEN
            RAISE EX_SALDO_INSUFICIENTE;
        ELSE
            UPDATE CR_USUARIO
            SET SALDO = SALDO - (P_NUMERO * P_PRECIO)
            WHERE ID_USUARIO = P_ID_USUARIO;

            DBMS_OUTPUT.PUT_LINE('Compra realizada.');
        END IF;

    ELSIF P_TIPO = 0 THEN
        SELECT COUNT(*) INTO V_MONEDAS
        FROM CR_TRANSACCION
        WHERE ID_USUARIO = P_ID_USUARIO AND ID_MONEDA = P_ID_MONEDA AND ID_TIEMPO = P_ID_TIEMPO;

        IF V_MONEDAS < P_NUMERO THEN
            RAISE EX_MONEDAS_INSUFICIENTES;
        ELSE
            UPDATE CR_USUARIO
            SET SALDO = SALDO + (P_NUMERO * P_PRECIO)
            WHERE ID_USUARIO = P_ID_USUARIO;

            DBMS_OUTPUT.PUT_LINE('Venta realizada.');
        END IF;

    ELSE
        RAISE_APPLICATION_ERROR(-20004, 'Transacción no válida.');
    END IF;

EXCEPTION

    WHEN EX_SALDO_INSUFICIENTE THEN
        DBMS_OUTPUT.PUT_LINE('No tiene saldo suficiente para realizar la compra.');
    
    WHEN EX_MONEDAS_INSUFICIENTES THEN
        DBMS_OUTPUT.PUT_LINE('No tiene suficientes monedas para realizar la venta.');
    
    WHEN EX_USUARIO_NO_EXISTE THEN
        DBMS_OUTPUT.PUT_LINE('El usuario no existe.');
    
    WHEN EX_MONEDA_NO_EXISTE THEN
        DBMS_OUTPUT.PUT_LINE('La moneda no existe.');
    
    WHEN EX_TIEMPO_NO_EXISTE THEN
        DBMS_OUTPUT.PUT_LINE('El tiempo con ID ' || P_ID_TIEMPO || ' no existe.');
    
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);

END REALIZAR_TRANSACCION;


--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


BEGIN
DBMS_OUTPUT.PUT_LINE('LLAMADA 1');
REALIZAR_TRANSACCION(1, 1032025, 1, 1, 10, 100); --CORRECTA
DBMS_OUTPUT.PUT_LINE('LLAMADA 2');
REALIZAR_TRANSACCION(1, 1032025, 1, 0, 5, 120); --CORRECTA
DBMS_OUTPUT.PUT_LINE('LLAMADA 3');
REALIZAR_TRANSACCION(1, 1032025, 1, 1, 20, 200); -- NO TIENE SALDO
DBMS_OUTPUT.PUT_LINE('LLAMADA 4');
REALIZAR_TRANSACCION(1, 1032025, 1, 0, 100, 150); -- NO TIENE CRIPTOS
DBMS_OUTPUT.PUT_LINE('LLAMADA 5');
REALIZAR_TRANSACCION(999, 1032025, 1, 1, 5, 50); -- NO EXISTE MONEDA
DBMS_OUTPUT.PUT_LINE('LLAMADA 6');
REALIZAR_TRANSACCION(1, 1032025, 999, 1, 5, 50); -- NO EXISTE USUARIO
DBMS_OUTPUT.PUT_LINE('LLAMADA 7');
REALIZAR_TRANSACCION(2, 1032025, 2, 1, 5, 150);
DBMS_OUTPUT.PUT_LINE('LLAMADA 8');
REALIZAR_TRANSACCION(2, 1032025, 2, 1, 20, 200); -- ERROR SALDO INSUFICIENTE
END;
