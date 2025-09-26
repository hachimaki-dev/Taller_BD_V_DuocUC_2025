CREATE OR REPLACE PACKAGE pkg_inicial AS
    -- Funciones
    FUNCTION fn_contar_ofertas(p_tipo VARCHAR2) RETURN NUMBER;
    FUNCTION fn_tiene_auto(p_id_usuario NUMBER, p_id_modelo NUMBER) RETURN BOOLEAN;

    -- Procedimientos
    PROCEDURE pr_crear_oferta(p_id_coleccion NUMBER, p_tipo VARCHAR2, p_precio NUMBER);
    PROCEDURE pr_finalizar_oferta(p_id_oferta NUMBER);
END pkg_inicial;
/

-- Implementación del paquete
CREATE OR REPLACE PACKAGE BODY pkg_inicial AS
    -- Función: contar cuántas ofertas existen de un tipo
    FUNCTION fn_contar_ofertas(p_tipo VARCHAR2) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM OFERTAS WHERE tipo_oferta = p_tipo;
        RETURN v_count;
    END;

    -- Función: verificar si un usuario tiene cierto modelo en su colección
    FUNCTION fn_tiene_auto(p_id_usuario NUMBER, p_id_modelo NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count 
        FROM COLECCION_USUARIOS 
        WHERE id_usuario = p_id_usuario AND id_modelo = p_id_modelo;
        RETURN v_count > 0; -- Retorna TRUE si lo tiene
    END;

    -- Procedimiento: crear una nueva oferta
    PROCEDURE pr_crear_oferta(p_id_coleccion NUMBER, p_tipo VARCHAR2, p_precio NUMBER) IS
    BEGIN
        INSERT INTO OFERTAS(id_oferta, id_coleccion, tipo_oferta, precio, estado_oferta, fecha_creacion)
        VALUES(SEQ_OFERTAS.NEXTVAL, p_id_coleccion, p_tipo, p_precio, 'ACTIVA', SYSDATE);
        DBMS_OUTPUT.PUT_LINE('Oferta creada');
    END;

    -- Procedimiento: finalizar una oferta (cambia estado a COMPLETADA)
    PROCEDURE pr_finalizar_oferta(p_id_oferta NUMBER) IS
    BEGIN
        UPDATE OFERTAS SET estado_oferta = 'COMPLETADA' WHERE id_oferta = p_id_oferta;
        DBMS_OUTPUT.PUT_LINE('Oferta finalizada');
    END;
END pkg_inicial;
/



