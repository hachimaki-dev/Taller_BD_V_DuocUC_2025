-- VARRAY: lista de autos deseados por un usuario
DECLARE
    TYPE autos_deseados_arr IS VARRAY(5) OF VARCHAR2(50); -- Máximo 5 elementos
    v_deseados autos_deseados_arr := autos_deseados_arr('Mustang','Camaro','Civic');
BEGIN
    -- Recorrer el array y mostrar su contenido
    FOR i IN 1..v_deseados.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Deseado: '||v_deseados(i));
    END LOOP;
END;
/