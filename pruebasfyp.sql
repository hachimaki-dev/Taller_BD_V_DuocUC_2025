-- 1) Probar función fn_contar_ofertas
DECLARE
    v_total NUMBER;
BEGIN
    v_total := pkg_inicial.fn_contar_ofertas('VENTA');
    DBMS_OUTPUT.PUT_LINE('Total ofertas de VENTA: ' || v_total);
END;
/

-- 2) Probar función fn_tiene_auto
DECLARE
    v_tiene BOOLEAN;
BEGIN
    v_tiene := pkg_inicial.fn_tiene_auto(1, 2); -- Usuario 1 y modelo 2 (MUSTANG_GT)
    IF v_tiene THEN
        DBMS_OUTPUT.PUT_LINE('El usuario tiene el auto.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El usuario NO tiene el auto.');
    END IF;
END;
/

-- 3) Probar procedimiento pr_crear_oferta
BEGIN
    pkg_inicial.pr_crear_oferta(1, 'VENTA', 99.99); -- Crear oferta para colección 1
END;
/

-- 4) Probar procedimiento pr_finalizar_oferta
BEGIN
    pkg_inicial.pr_finalizar_oferta(1); -- Finaliza la oferta con ID 1
END;
/
