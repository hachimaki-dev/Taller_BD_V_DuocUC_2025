CREATE OR REPLACE PACKAGE pkg_gestion_usuario IS
    g_contador_inicio_sesion NUMBER:= 0;
    PROCEDURE contador_inicio_sesion(p_nombre_usuario VARCHAR2);

    FUNCTION total_sesiones_activas RETURN NUMBER;

    PROCEDURE log_usuario(p_id NUMBER,  p_nombre_usuario VARCHAR2);

END pkg_gestion_usuario;
/

CREATE OR REPLACE  PACKAGE BODY pkg_gestion_usuario IS
    
    PROCEDURE contador_inicio_sesion(p_nombre_usuario VARCHAR2) IS
    BEGIN
        g_contador_inicio_sesion := g_contador_inicio_sesion + 1;
        DBMS_OUTPUT.PUT_LINE('El usuario ' || p_nombre_usuario || ' inicio sesión correctamente el ' || SYSDATE);
    END;

    FUNCTION total_sesiones_activas RETURN NUMBER IS
    BEGIN
        RETURN g_contador_inicio_sesion;
    END;

    PROCEDURE log_usuario(p_id NUMBER, p_nombre_usuario VARCHAR2) IS
    BEGIN
        INSERT INTO LOGS_INICIO_SESION(id, nombre) VALUES (p_id, p_nombre_usuario);
    END;

END pkg_gestion_usuario;


BEGIN
    PKG_GESTION_USUARIO.CONTADOR_INICIO_SESION('ERIC');
    PKG_GESTION_USUARIO.LOG_USUARIO(2, 'ERIC');
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('La cantidad de sesiones activas es:' || PKG_GESTION_USUARIO.TOTAL_SESIONES_ACTIVAS);
END;
/


SELECT * FROM LOGS_INICIO_SESION;