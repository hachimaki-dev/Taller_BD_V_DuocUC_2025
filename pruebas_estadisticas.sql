BEGIN
    pkg_estadisticas.pr_resumen_general;
END;
/


SELECT 
    ID_RESUMEN,
    TO_CHAR(fecha_generacion, 'DD/MM/YYYY HH24:MI:SS') AS fecha_hora_registro,
    TOTAL_OFERTAS, PROMEDIO_PRECIOS, USUARIO_MAS_ACTIVO, USUARIO_MAS_AUTOS
FROM HISTORIAL_RESUMENES
ORDER BY fecha_generacion DESC;
