-- 1) Probar función fn_contar_ofertas
DECLARE
    v_total NUMBER;
BEGIN
    v_total := PKG_OFERTAS.fn_contar_ofertas('VENTA');
    DBMS_OUTPUT.PUT_LINE('Total ofertas de VENTA: ' || v_total);
END;
/

-- 2) Probar procedimiento pr_crear_oferta
BEGIN
    PKG_OFERTAS.pr_crear_oferta(1, 'VENTA', 99.99); -- Crear oferta para colección 1
END;
/

-- 3) Probar procedimiento pr_finalizar_oferta
BEGIN
    PKG_OFERTAS.pr_finalizar_oferta(1); -- Finaliza la oferta con ID 1
END;
/
