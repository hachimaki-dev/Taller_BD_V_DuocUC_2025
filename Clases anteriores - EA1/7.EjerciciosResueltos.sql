-- =========================================

-- EJERCICIO 1: Lista de precios básica

-- =========================================

-- OBJETIVO: Trabajar con precios y operaciones estadísticas básicas



DECLARE

    -- Definimos un tipo VARRAY que puede almacenar hasta 1000 precios

    TYPE lista_precios IS VARRAY(1000) OF NUMBER(8,2);

    precios lista_precios := lista_precios(); -- Inicializamos vacío

    

    -- Variables para cálculos estadísticos

    precio_mayor NUMBER := 0;

    precio_menor NUMBER := 999999; -- Valor alto inicial para comparación

    suma_precios NUMBER := 0;

    promedio NUMBER := 0;

    

    -- Cursor para obtener todos los precios de juegos

    CURSOR c_precios IS

        SELECT precio

        FROM juegos

        WHERE precio IS NOT NULL; -- Evitamos precios nulos

BEGIN

    DBMS_OUTPUT.PUT_LINE('=== ANÁLISIS DE PRECIOS DE JUEGOS ===');

    

    -- Llenamos el VARRAY con los precios de la base de datos

    FOR precio IN c_precios LOOP

        precios.EXTEND; -- Expandimos el array para agregar un elemento

        precios(precios.COUNT) := precio.precio; -- Asignamos al último índice

        

        -- Actualizamos estadísticas mientras recorremos

        suma_precios := suma_precios + precio.precio;

        

        -- Verificamos si es el mayor precio encontrado

        IF precio.precio > precio_mayor THEN

            precio_mayor := precio.precio;

        END IF;

        

        -- Verificamos si es el menor precio encontrado

        IF precio.precio < precio_menor THEN

            precio_menor := precio.precio;

        END IF;

    END LOOP;

    

    -- Calculamos el promedio solo si hay elementos

    IF precios.COUNT > 0 THEN

        promedio := suma_precios / precios.COUNT;

    END IF;

    

    -- Mostramos los resultados

    DBMS_OUTPUT.PUT_LINE('Total de juegos analizados: ' || precios.COUNT);

    DBMS_OUTPUT.PUT_LINE('Precio más alto: $' || precio_mayor);

    DBMS_OUTPUT.PUT_LINE('Precio más bajo: $' || precio_menor);

    DBMS_OUTPUT.PUT_LINE('Precio promedio: $' || ROUND(promedio, 2));

    

    -- Bonus: Mostramos cuántos juegos están por encima del promedio

    DECLARE

        juegos_caros NUMBER := 0;

    BEGIN

        FOR i IN 1..precios.COUNT LOOP

            IF precios(i) > promedio THEN

                juegos_caros := juegos_caros + 1;

            END IF;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Juegos por encima del promedio: ' || juegos_caros);

    END;

END;

/



-- =========================================

-- EJERCICIO 2: Nombres de usuarios

-- =========================================

-- OBJETIVO: Trabajar con strings y mostrar posiciones



DECLARE

    -- VARRAY para almacenar nombres de usuarios (máximo 500)

    TYPE lista_nombres IS VARRAY(500) OF VARCHAR2(100);

    nombres_usuarios lista_nombres := lista_nombres(); -- Inicialización vacía

    

    -- Cursor para obtener todos los nombres de usuarios

    CURSOR c_usuarios IS

        SELECT nombre

        FROM usuarios

        ORDER BY nombre; -- Ordenamos alfabéticamente para mejor presentación

BEGIN

    DBMS_OUTPUT.PUT_LINE('=== LISTA DE USUARIOS REGISTRADOS ===');

    

    -- Llenamos el VARRAY con nombres de usuarios

    FOR usuario IN c_usuarios LOOP

        nombres_usuarios.EXTEND; -- Expandimos el array

        nombres_usuarios(nombres_usuarios.COUNT) := usuario.nombre; -- Asignamos nombre

    END LOOP;

    

    -- Mostramos cada nombre con su posición

    DBMS_OUTPUT.PUT_LINE('Total de usuarios: ' || nombres_usuarios.COUNT);

    DBMS_OUTPUT.PUT_LINE('--- LISTA DETALLADA ---');

    

    FOR i IN 1..nombres_usuarios.COUNT LOOP

        DBMS_OUTPUT.PUT_LINE('Posición ' || LPAD(i, 3, '0') || ': ' || nombres_usuarios(i));

    END LOOP;

    

    -- Información adicional del array

    DBMS_OUTPUT.PUT_LINE('--- INFORMACIÓN DEL VARRAY ---');

    DBMS_OUTPUT.PUT_LINE('Primer índice (FIRST): ' || nombres_usuarios.FIRST);

    DBMS_OUTPUT.PUT_LINE('Último índice (LAST): ' || nombres_usuarios.LAST);

    DBMS_OUTPUT.PUT_LINE('Límite máximo (LIMIT): ' || nombres_usuarios.LIMIT);

    DBMS_OUTPUT.PUT_LINE('Elementos actuales (COUNT): ' || nombres_usuarios.COUNT);

END;

/



-- =========================================

-- EJERCICIO 3: Fechas de lanzamiento

-- =========================================

-- OBJETIVO: Trabajar con fechas y filtrado por año



DECLARE

    -- VARRAY para almacenar fechas de lanzamiento

    TYPE lista_fechas IS VARRAY(1000) OF DATE;

    fechas_lanzamiento lista_fechas := lista_fechas(); -- Inicialización vacía

    

    -- Contadores para análisis

    juegos_2023 NUMBER := 0;

    total_juegos NUMBER := 0;

    

    -- Cursor para obtener fechas de lanzamiento

    CURSOR c_fechas IS

        SELECT fecha_lanzamiento, nombre

        FROM juegos

        WHERE fecha_lanzamiento IS NOT NULL -- Solo fechas válidas

        ORDER BY fecha_lanzamiento DESC; -- Más recientes primero

BEGIN

    DBMS_OUTPUT.PUT_LINE('=== ANÁLISIS DE FECHAS DE LANZAMIENTO ===');

    

    -- Llenamos el VARRAY con fechas

    FOR juego IN c_fechas LOOP

        fechas_lanzamiento.EXTEND; -- Expandimos el array

        fechas_lanzamiento(fechas_lanzamiento.COUNT) := juego.fecha_lanzamiento;

        

        -- Contamos juegos de 2023 mientras llenamos el array

        IF EXTRACT(YEAR FROM juego.fecha_lanzamiento) = 2023 THEN

            juegos_2023 := juegos_2023 + 1;

            DBMS_OUTPUT.PUT_LINE('Juego 2023: ' || juego.nombre ||

                               ' (Lanzado: ' || TO_CHAR(juego.fecha_lanzamiento, 'DD/MM/YYYY') || ')');

        END IF;

    END LOOP;

    

    total_juegos := fechas_lanzamiento.COUNT;

    

    -- Análisis de distribución por año

    DECLARE

        TYPE contadores_año IS VARRAY(50) OF NUMBER; -- Para diferentes años

        TYPE lista_años IS VARRAY(50) OF NUMBER;

        

        años lista_años := lista_años();

        conteos contadores_año := contadores_año();

        año_actual NUMBER;

        encontrado BOOLEAN;

        indice_año NUMBER;

    BEGIN

        -- Contamos juegos por año

        FOR i IN 1..fechas_lanzamiento.COUNT LOOP

            año_actual := EXTRACT(YEAR FROM fechas_lanzamiento(i));

            encontrado := FALSE;

            

            -- Buscamos si ya tenemos este año registrado

            FOR j IN 1..años.COUNT LOOP

                IF años(j) = año_actual THEN

                    conteos(j) := conteos(j) + 1;

                    encontrado := TRUE;

                    EXIT;

                END IF;

            END LOOP;

            

            -- Si es un año nuevo, lo agregamos

            IF NOT encontrado THEN

                años.EXTEND;

                conteos.EXTEND;

                años(años.COUNT) := año_actual;

                conteos(conteos.COUNT) := 1;

            END IF;

        END LOOP;

        

        -- Mostramos resultados

        DBMS_OUTPUT.PUT_LINE('--- RESUMEN ---');

        DBMS_OUTPUT.PUT_LINE('Total de juegos con fecha: ' || total_juegos);

        DBMS_OUTPUT.PUT_LINE('Juegos lanzados en 2023: ' || juegos_2023);

        

        DBMS_OUTPUT.PUT_LINE('--- DISTRIBUCIÓN POR AÑO ---');

        FOR i IN 1..años.COUNT LOOP

            DBMS_OUTPUT.PUT_LINE('Año ' || años(i) || ': ' || conteos(i) || ' juegos');

        END LOOP;

    END;

END;

/