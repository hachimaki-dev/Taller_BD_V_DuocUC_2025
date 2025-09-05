DECLARE
    CURSOR cur_juegos IS
        SELECT nombre, precio 
        FROM juegos ORDER BY precio DESC;

        var_precioMaximo NUMBER(9) := 0;
        var_precioMinimo NUMBER(9) := 9999.99;

        var_promedio NUMBER(9) := 0;
        var_contador NUMBER(9) := 0;

BEGIN
    FOR juego IN cur_juegos LOOP
        var_contador :=  var_contador + 1;
        var_promedio := var_promedio + juego.precio;
        

       IF juego.precio >= var_precioMaximo THEN
            var_precioMaximo := juego.precio;
        END IF;
        IF juego.precio < var_precioMinimo THEN
            var_precioMinimo := juego.precio;
        END IF;
    END LOOP;

    var_promedio := var_promedio / var_contador;


    DBMS_OUTPUT.PUT_LINE('El juego con precio máximo es: '|| var_precioMaximo);
    DBMS_OUTPUT.PUT_LINE('El juego con menor precio es: '|| var_precioMinimo);
    DBMS_OUTPUT.PUT_LINE('El promedion de los precios de los juegos es '|| var_promedio);
END;
/