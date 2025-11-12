CREATE OR REPLACE PACKAGE pkg_ofertas AS
    
    FUNCTION fn_contar_ofertas(p_tipo VARCHAR2) RETURN NUMBER;

    PROCEDURE pr_crear_oferta(
        p_id_coleccion   NUMBER,
        p_tipo           VARCHAR2,
        p_precio         NUMBER,
        p_autos_deseados VARCHAR2 DEFAULT NULL
    );

    PROCEDURE pr_finalizar_oferta(p_id_oferta NUMBER);

END pkg_ofertas;
/

CREATE OR REPLACE PACKAGE BODY pkg_ofertas AS

    FUNCTION fn_contar_ofertas(p_tipo VARCHAR2) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM OFERTAS
        WHERE tipo_oferta = p_tipo;

        RETURN v_count;
    END fn_contar_ofertas;


    PROCEDURE pr_crear_oferta(
        p_id_coleccion   NUMBER,
        p_tipo           VARCHAR2,
        p_precio         NUMBER,
        p_autos_deseados VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        -- Validaciones usando pkg_validacion
        IF NOT pkg_validacion.fn_validar_tipo_oferta(p_tipo) THEN
            RAISE_APPLICATION_ERROR(-20010, '❌ Tipo de oferta inválido.');
        END IF;

        IF p_tipo = 'VENTA' AND NOT pkg_validacion.fn_validar_precio(p_precio) THEN
            RAISE_APPLICATION_ERROR(-20011, '❌ Precio obligatorio y mayor a 0 para ofertas de venta.');
        END IF;

        INSERT INTO OFERTAS(
            id_oferta, id_coleccion, tipo_oferta, precio, autos_deseados, 
            estado_oferta, fecha_creacion
        )
        VALUES(
            SEQ_OFERTAS.NEXTVAL, p_id_coleccion, p_tipo, p_precio, p_autos_deseados,
            'ACTIVA', SYSDATE
        );

        DBMS_OUTPUT.PUT_LINE('✅ Oferta creada correctamente.');
    END pr_crear_oferta;


    PROCEDURE pr_finalizar_oferta(p_id_oferta NUMBER) IS
    BEGIN
        UPDATE OFERTAS
        SET estado_oferta = 'COMPLETADA'
        WHERE id_oferta = p_id_oferta;

        DBMS_OUTPUT.PUT_LINE('✅ Oferta finalizada.');
    END pr_finalizar_oferta;

END pkg_ofertas;
/
