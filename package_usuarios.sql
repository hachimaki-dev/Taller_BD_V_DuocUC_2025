create or replace PACKAGE pkg_usuario AS
    PROCEDURE pr_crear_usuario(p_nombre VARCHAR2, p_email VARCHAR2);
    FUNCTION fn_usuario_existe_por_email(p_email VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_obtener_id_usuario_por_email(p_email VARCHAR2) RETURN NUMBER;
END pkg_usuario;
/

CREATE OR REPLACE PACKAGE BODY pkg_usuario AS

    FUNCTION fn_usuario_existe_por_email(p_email VARCHAR2) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count 
        FROM USUARIOS 
        WHERE LOWER(email) = LOWER(TRIM(p_email));
        RETURN v_count > 0;
    END fn_usuario_existe_por_email;


    FUNCTION fn_obtener_id_usuario_por_email(p_email VARCHAR2) RETURN NUMBER IS
        v_id USUARIOS.id_usuario%TYPE;
    BEGIN
        SELECT id_usuario INTO v_id 
        FROM USUARIOS 
        WHERE LOWER(email) = LOWER(TRIM(p_email));
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END fn_obtener_id_usuario_por_email;


    PROCEDURE pr_crear_usuario(p_nombre VARCHAR2, p_email VARCHAR2) IS
        v_email_clean VARCHAR2(200) := LOWER(TRIM(p_email));
    BEGIN
        IF NOT pkg_validacion.fn_no_es_nulo_ni_vacio(p_nombre) THEN
            RAISE_APPLICATION_ERROR(-20050, 'Nombre inválido.');
        ELSIF NOT pkg_validacion.fn_no_es_nulo_ni_vacio(p_email) THEN
            RAISE_APPLICATION_ERROR(-20051, 'Email inválido.');
        ELSIF fn_usuario_existe_por_email(v_email_clean) THEN
            RAISE_APPLICATION_ERROR(-20052, 'Email ya registrado.');
        ELSE
            INSERT INTO USUARIOS (id_usuario, nombre_usuario, email, fecha_registro)
            VALUES (SEQ_USUARIOS.NEXTVAL, p_nombre, v_email_clean, SYSDATE);

            DBMS_OUTPUT.PUT_LINE('✅ Usuario creado correctamente.');
        END IF;
    END pr_crear_usuario;

END pkg_usuario;
/
