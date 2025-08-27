DECLARE
    TYPE tipo_juego is RECORD(
        nombre JUEGOS.NOMBRE%TYPE,
        precio JUEGOS.PRECIO%TYPE,
        categoria JUEGOS.CATEGORIA%TYPE,
        fecha_lanzamiento JUEGOS.FECHA_LANZAMIENTO%TYPE
    );
    v_juego tipo_juego;
BEGIN
    Select 
    nombre, precio, categoria, fecha_lanzamiento into v_juego.nombre,
    v_juego.precio,v_juego.categoria,v_juego.fecha_lanzamiento where ID_JUEGO = 1;


END;
/