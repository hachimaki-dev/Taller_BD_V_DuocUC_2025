CREATE OR REPLACE PACKAGE pkg_estadisticas AS
    FUNCTION fn_total_ofertas RETURN NUMBER;
    FUNCTION fn_promedio_precios RETURN NUMBER;
    FUNCTION fn_usuario_mas_activo RETURN VARCHAR2;
    FUNCTION fn_usuario_con_mas_autos RETURN VARCHAR2;

    PROCEDURE pr_resumen_general;
END pkg_estadisticas;
/

CREATE OR REPLACE PACKAGE BODY pkg_estadisticas AS

    -- Total de ofertas registradas
    FUNCTION fn_total_ofertas RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM OFERTAS;
        RETURN v_total;
    END fn_total_ofertas;


    -- Promedio general de precios de las ofertas
    FUNCTION fn_promedio_precios RETURN NUMBER IS
        v_prom NUMBER;
    BEGIN
        SELECT AVG(precio) INTO v_prom FROM OFERTAS WHERE precio IS NOT NULL;
        RETURN NVL(v_prom, 0);
    END fn_promedio_precios;


    -- Usuario con más ofertas creadas (más activo)
    FUNCTION fn_usuario_mas_activo RETURN VARCHAR2 IS
        v_nombre VARCHAR2(100);
    BEGIN
        SELECT u.nombre_usuario
        INTO v_nombre
        FROM USUARIOS u
        JOIN COLECCION_USUARIOS c ON u.id_usuario = c.id_usuario
        JOIN OFERTAS o ON c.id_coleccion = o.id_coleccion
        GROUP BY u.nombre_usuario
        ORDER BY COUNT(o.id_oferta) DESC
        FETCH FIRST 1 ROWS ONLY;

        RETURN v_nombre;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Sin datos';
    END fn_usuario_mas_activo;


    -- Usuario con más autos en su colección
    FUNCTION fn_usuario_con_mas_autos RETURN VARCHAR2 IS
        v_nombre VARCHAR2(100);
    BEGIN
        SELECT u.nombre_usuario
        INTO v_nombre
        FROM USUARIOS u
        JOIN COLECCION_USUARIOS c ON u.id_usuario = c.id_usuario
        GROUP BY u.nombre_usuario
        ORDER BY COUNT(c.id_coleccion) DESC
        FETCH FIRST 1 ROWS ONLY;

        RETURN v_nombre;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Sin datos';
    END fn_usuario_con_mas_autos;


    -- Procedimiento principal: muestra y guarda el resumen general
    PROCEDURE pr_resumen_general IS
        v_total NUMBER;
        v_prom NUMBER;
        v_activo VARCHAR2(100);
        v_mas_autos VARCHAR2(100);
    BEGIN
        v_total := fn_total_ofertas;
        v_prom := fn_promedio_precios;
        v_activo := fn_usuario_mas_activo;
        v_mas_autos := fn_usuario_con_mas_autos;

        DBMS_OUTPUT.PUT_LINE('📊 RESUMEN GENERAL DEL SISTEMA');
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total de ofertas: ' || v_total);
        DBMS_OUTPUT.PUT_LINE('Promedio de precios: $' || v_prom);
        DBMS_OUTPUT.PUT_LINE('Usuario más activo: ' || v_activo);
        DBMS_OUTPUT.PUT_LINE('Usuario con más autos: ' || v_mas_autos);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');

        -- Guardar resumen en el historial
        INSERT INTO HISTORIAL_RESUMENES (
            total_ofertas,
            promedio_precios,
            usuario_mas_activo,
            usuario_mas_autos
        ) VALUES (
            v_total,
            v_prom,
            v_activo,
            v_mas_autos
        );

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('🕒 Resumen registrado en el historial.');
    END pr_resumen_general;

END pkg_estadisticas;
/


