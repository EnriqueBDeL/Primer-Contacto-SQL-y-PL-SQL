-- BD cripto:


-- 1. Cuando se realiza una transacción se comprueba si el usuario tiene saldo/monedas para comprar/vender. En caso de realizarse la operación se actualiza el saldo.



CREATE OR REPLACE TRIGGER COMPROBADOR
BEFORE INSERT ON CR_TRANSACCION
FOR EACH ROW
DECLARE

    V_SALDO NUMBER; 

BEGIN

    SELECT SALDO INTO V_SALDO 
    FROM CR_USUARIO 
    WHERE ID_USUARIO = :NEW.ID_USUARIO;


    IF :NEW.TIPO = 0 THEN

        IF V_SALDO <= 0 OR V_SALDO < :NEW.PRECIO THEN

            RAISE_APPLICATION_ERROR(-34567, 'El usuario no tiene saldo suficiente para la compra.');

        END IF;

        UPDATE CR_USUARIO
        SET SALDO = SALDO - :NEW.PRECIO
        WHERE ID_USUARIO = :NEW.ID_USUARIO;

    ELSIF :NEW.TIPO = 1 THEN

        UPDATE CR_USUARIO
        SET SALDO = SALDO + :NEW.PRECIO
        WHERE ID_USUARIO = :NEW.ID_USUARIO;

    END IF;

END;








-- BD popotify:




-- 1. Asignar suscripción automáticamente como 'Gratis' si no se especifica.



CREATE OR REPLACE TRIGGER d_suscripcion_automatica
BEFORE INSERT ON SP_USERS
FOR EACH ROW
BEGIN

    IF :NEW.SUBSCRIPTION_TYPE IS NULL THEN

        :NEW.SUBSCRIPTION_TYPE := 'Gratis';

    END IF;
END;





-- 2. Evitar la inserción de una canción que ya está insertada en una playlist.



CREATE OR REPLACE TRIGGER d_cancion_duplicada
BEFORE INSERT ON SP_Playlist_Songs
FOR EACH ROW
DECLARE
    v_contador INT;
BEGIN

    SELECT COUNT(*) INTO v_contador
    FROM SP_Playlist_Songs
    WHERE playlist_id = :NEW.playlist_id
    AND song_id = :NEW.song_id;


    IF v_contador > 0 THEN

        RAISE_APPLICATION_ERROR(-20001, 'La canción ya está en esta playlist.');

    END IF;
END;





-- 3. Crear una registro de usuarios eliminados, guardar su información en la tabla SP_Auditoria_Usuarios.

/* 


CREATE TABLE SP_Auditoria_Usuarios (
    id_usuario INT,
    nombre VARCHAR2(100),
    email VARCHAR2(255),
    fecha_borrado DATE
);


*/


CREATE OR REPLACE TRIGGER d_usuarios_eliminados
AFTER DELETE ON SP_USERS
FOR EACH ROW
BEGIN

    INSERT INTO SP_Auditoria_Usuarios (id_usuario, nombre, email, fecha_borrado)
    VALUES (:OLD.user_id, :OLD.username, :OLD.email, SYSDATE);

END;




--  4. Crear un trigger que evite que una playlist tenga más de 50 canciones.


CREATE OR REPLACE TRIGGER d_limite_canciones
BEFORE INSERT ON SP_Playlist_Songs
FOR EACH ROW
DECLARE
    v_contador INT;
BEGIN

    SELECT COUNT(*) INTO v_contador
    FROM SP_Playlist_Songs
    WHERE playlist_id = :NEW.playlist_id;

    -- Verificar si hay más de 50 canciones
    IF v_contador >= 50 THEN
        -- Si ya hay 50 canciones, lanzar un error
        RAISE_APPLICATION_ERROR(-20001, 'Una lista de reproducción no puede tener más de 50 canciones.');
    END IF;
END;








