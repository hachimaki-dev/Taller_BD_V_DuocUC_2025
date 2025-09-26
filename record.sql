-- RECORD: estructura que agrupa varios campos de un usuario
DECLARE
    TYPE usuario_rec IS RECORD (
        id_usuario   USUARIOS.ID_USUARIO%TYPE,     -- ID del usuario
        nombre       USUARIOS.NOMBRE_USUARIO%TYPE, -- Nombre
        email        USUARIOS.EMAIL%TYPE,          -- Email
        fecha_reg    USUARIOS.FECHA_REGISTRO%TYPE, -- Fecha de registro
        ciudad       USUARIOS.CIUDAD%TYPE          -- Ciudad
    );

    v_usuario usuario_rec; -- Variable del tipo RECORD

BEGIN
    -- Cargar un usuario de la tabla
    SELECT id_usuario, nombre_usuario, email, fecha_registro, ciudad
    INTO v_usuario
    FROM USUARIOS
    WHERE ID_USUARIO = 1;

    -- Mostrar la información obtenida
    DBMS_OUTPUT.PUT_LINE('Usuario: '||v_usuario.nombre||' - '||v_usuario.email);
END;
/