CREATE OR REPLACE PACKAGE pkg_validacion AS
    FUNCTION fn_validar_precio(p_precio NUMBER) RETURN BOOLEAN;
    FUNCTION fn_validar_tipo_oferta(p_tipo VARCHAR2) RETURN BOOLEAN;
    FUNCTION fn_no_es_nulo_ni_vacio(p_valor VARCHAR2) RETURN BOOLEAN;
END pkg_validacion;
/

CREATE OR REPLACE PACKAGE BODY pkg_validacion AS

    FUNCTION fn_validar_precio(p_precio NUMBER) RETURN BOOLEAN IS
    BEGIN
        RETURN p_precio > 0;
    END fn_validar_precio;

    FUNCTION fn_validar_tipo_oferta(p_tipo VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN UPPER(TRIM(p_tipo)) IN ('VENTA','TRUEQUE');
    END fn_validar_tipo_oferta;

    FUNCTION fn_no_es_nulo_ni_vacio(p_valor VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN TRIM(p_valor) IS NOT NULL AND TRIM(p_valor) <> '';
    END fn_no_es_nulo_ni_vacio;

END pkg_validacion;
/
