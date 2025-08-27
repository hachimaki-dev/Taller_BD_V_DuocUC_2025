DECLARE
    TYPE tipo_juegos IS RECORD(
        nombre JUEGOS.NOMBRE%TYPE,
        precio JUEGOS.PRECIO%TYPE,
        categoria JUEGOS.CATEGORIA%TYPE,
        fecha_lanzamiento JUEGOS.FECHA_LANZAMIENTO%TYPE
    );

    v_juego tipo_juegos;

BEGIN
    SELECT NOMBRE, PRECIO, CATEGORIA, FECHA_LANZAMIENTO 
    into v_juego.nombre, v_juego.precio, v_juego.categoria, v_juego.fecha_lanzamiento 
    WHERE id_juego=1;
    DBMS_OUTPUT.PUT_LINE('There are ' || in_stock || ' items in stock.');

END;
/