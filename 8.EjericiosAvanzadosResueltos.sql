SET SERVEROUTPUT ON;

-- =============================================================================
-- EJERCICIO 4: Análisis de compras por usuario
-- =============================================================================

CREATE OR REPLACE PROCEDURE analisis_compras_usuario(p_id_usuario NUMBER) AS
    -- VARRAY para almacenar precios de compras
    TYPE t_precios IS VARRAY(100) OF NUMBER(8,2);
    v_precios t_precios := t_precios();
    
    -- Variables auxiliares
    v_total_gastado NUMBER(10,2) := 0;
    v_precio_max NUMBER(8,2) := 0;
    v_juego_mas_caro VARCHAR2(100);
    v_contador NUMBER := 0;
    v_nombre_usuario VARCHAR2(50);
    
    -- Cursor para obtener compras del usuario
    CURSOR c_compras IS
        SELECT c.precio_pagado, j.nombre
        FROM compras c
        JOIN juegos j ON c.id_juego = j.id_juego
        WHERE c.id_usuario = p_id_usuario
        ORDER BY c.precio_pagado DESC;
        
BEGIN
    -- Verificar si el usuario existe
    BEGIN
        SELECT nombre INTO v_nombre_usuario
        FROM usuarios
        WHERE id_usuario = p_id_usuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Usuario con ID ' || p_id_usuario || ' no encontrado.');
            RETURN;
    END;
    
    DBMS_OUTPUT.PUT_LINE('=== ANÁLISIS DE COMPRAS PARA: ' || v_nombre_usuario || ' ===');
    
    -- Llenar el VARRAY con precios de compras
    FOR rec IN c_compras LOOP
        v_contador := v_contador + 1;
        v_precios.EXTEND;
        v_precios(v_contador) := rec.precio_pagado;
        
        -- Calcular total gastado
        v_total_gastado := v_total_gastado + rec.precio_pagado;
        
        -- Encontrar juego más caro (el primero por el ORDER BY DESC)
        IF v_contador = 1 THEN
            v_precio_max := rec.precio_pagado;
            v_juego_mas_caro := rec.nombre;
        END IF;
    END LOOP;
    
    -- Mostrar resultados
    IF v_contador = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El usuario no ha realizado compras.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Número de compras: ' || v_contador);
        DBMS_OUTPUT.PUT_LINE('Total gastado: $' || v_total_gastado);
        DBMS_OUTPUT.PUT_LINE('Juego más caro: ' || v_juego_mas_caro || ' ($' || v_precio_max || ')');
        
        -- Mostrar todos los precios del VARRAY
        DBMS_OUTPUT.PUT_LINE('Precios de todas las compras:');
        FOR i IN 1..v_precios.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('  Compra ' || i || ': $' || v_precios(i));
        END LOOP;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('=== FIN ANÁLISIS ===');
END;
/

-- =============================================================================
-- EJERCICIO 5: Top 3 juegos más caros
-- =============================================================================

CREATE OR REPLACE PROCEDURE top_3_juegos_caros AS
    -- Record para almacenar información del juego
    TYPE t_juego_record IS RECORD (
        nombre VARCHAR2(100),
        precio NUMBER(8,2),
        categoria VARCHAR2(30)
    );
    
    -- VARRAY de records para los juegos
    TYPE t_juegos_array IS VARRAY(3) OF t_juego_record;
    v_top_juegos t_juegos_array := t_juegos_array();
    
    -- Cursor para obtener los 3 juegos más caros
    CURSOR c_juegos_caros IS
        SELECT nombre, precio, categoria
        FROM juegos
        ORDER BY precio DESC
        FETCH FIRST 3 ROWS ONLY;
        
    v_contador NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TOP 3 JUEGOS MÁS CAROS ===');
    
    -- Llenar el VARRAY con los 3 juegos más caros
    FOR rec IN c_juegos_caros LOOP
        v_contador := v_contador + 1;
        v_top_juegos.EXTEND;
        
        v_top_juegos(v_contador).nombre := rec.nombre;
        v_top_juegos(v_contador).precio := rec.precio;
        v_top_juegos(v_contador).categoria := rec.categoria;
    END LOOP;
    
    -- Mostrar los resultados
    FOR i IN 1..v_top_juegos.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || v_top_juegos(i).nombre || 
                            ' - $' || v_top_juegos(i).precio || 
                            ' (' || v_top_juegos(i).categoria || ')');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('=== FIN TOP 3 ===');
END;
/

-- =============================================================================
-- EJERCICIO 6: Sistema de recomendaciones
-- =============================================================================

CREATE OR REPLACE PROCEDURE sistema_recomendaciones(p_id_usuario NUMBER) AS
    -- VARRAY para categorías del usuario actual
    TYPE t_categorias IS VARRAY(20) OF VARCHAR2(30);
    v_mis_categorias t_categorias := t_categorias();
    
    -- VARRAY para usuarios similares
    TYPE t_usuarios_similares IS VARRAY(50) OF NUMBER;
    v_usuarios_similares t_usuarios_similares := t_usuarios_similares();
    
    -- VARRAY para juegos recomendados
    TYPE t_juego_recomendado IS RECORD (
        id_juego NUMBER,
        nombre VARCHAR2(100),
        precio NUMBER(8,2),
        categoria VARCHAR2(30)
    );
    TYPE t_recomendaciones IS VARRAY(50) OF t_juego_recomendado;
    v_recomendaciones t_recomendaciones := t_recomendaciones();
    
    -- Variables auxiliares
    v_contador_cat NUMBER := 0;
    v_contador_usuarios NUMBER := 0;
    v_contador_recom NUMBER := 0;
    v_nombre_usuario VARCHAR2(50);
    v_ya_tiene_juego NUMBER;
    v_ya_recomendado NUMBER;
    
    -- Cursor para categorías del usuario actual
    CURSOR c_mis_categorias IS
        SELECT DISTINCT j.categoria
        FROM compras c
        JOIN juegos j ON c.id_juego = j.id_juego
        WHERE c.id_usuario = p_id_usuario;
    
    -- Cursor para encontrar usuarios con gustos similares
    CURSOR c_usuarios_similares IS
        SELECT DISTINCT c.id_usuario
        FROM compras c
        JOIN juegos j ON c.id_juego = j.id_juego
        WHERE j.categoria IN (
            SELECT DISTINCT j2.categoria
            FROM compras c2
            JOIN juegos j2 ON c2.id_juego = j2.id_juego
            WHERE c2.id_usuario = p_id_usuario
        )
        AND c.id_usuario != p_id_usuario;
    
BEGIN
    -- Verificar si el usuario existe
    BEGIN
        SELECT nombre INTO v_nombre_usuario
        FROM usuarios
        WHERE id_usuario = p_id_usuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Usuario con ID ' || p_id_usuario || ' no encontrado.');
            RETURN;
    END;
    
    DBMS_OUTPUT.PUT_LINE('=== SISTEMA DE RECOMENDACIONES PARA: ' || v_nombre_usuario || ' ===');
    
    -- 1. Obtener categorías que le gustan al usuario actual
    FOR rec IN c_mis_categorias LOOP
        v_contador_cat := v_contador_cat + 1;
        v_mis_categorias.EXTEND;
        v_mis_categorias(v_contador_cat) := rec.categoria;
    END LOOP;
    
    IF v_contador_cat = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El usuario no ha comprado ningún juego. No se pueden hacer recomendaciones.');
        RETURN;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Categorías de interés del usuario:');
    FOR i IN 1..v_mis_categorias.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('  - ' || v_mis_categorias(i));
    END LOOP;
    
    -- 2. Encontrar usuarios con gustos similares
    FOR rec IN c_usuarios_similares LOOP
        v_contador_usuarios := v_contador_usuarios + 1;
        v_usuarios_similares.EXTEND;
        v_usuarios_similares(v_contador_usuarios) := rec.id_usuario;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Usuarios con gustos similares encontrados: ' || v_contador_usuarios);
    
    -- 3. Obtener recomendaciones de juegos
    FOR i IN 1..v_usuarios_similares.COUNT LOOP
        FOR rec_juego IN (
            SELECT DISTINCT j.id_juego, j.nombre, j.precio, j.categoria
            FROM compras c
            JOIN juegos j ON c.id_juego = j.id_juego
            WHERE c.id_usuario = v_usuarios_similares(i)
        ) LOOP
            -- Verificar que el usuario actual no tenga este juego
            SELECT COUNT(*) INTO v_ya_tiene_juego
            FROM compras
            WHERE id_usuario = p_id_usuario AND id_juego = rec_juego.id_juego;
            
            -- Verificar que no esté ya en la lista de recomendaciones
            v_ya_recomendado := 0;
            FOR j IN 1..v_recomendaciones.COUNT LOOP
                IF v_recomendaciones(j).id_juego = rec_juego.id_juego THEN
                    v_ya_recomendado := 1;
                    EXIT;
                END IF;
            END LOOP;
            
            -- Si no lo tiene y no está recomendado, agregarlo
            IF v_ya_tiene_juego = 0 AND v_ya_recomendado = 0 THEN
                v_contador_recom := v_contador_recom + 1;
                v_recomendaciones.EXTEND;
                v_recomendaciones(v_contador_recom).id_juego := rec_juego.id_juego;
                v_recomendaciones(v_contador_recom).nombre := rec_juego.nombre;
                v_recomendaciones(v_contador_recom).precio := rec_juego.precio;
                v_recomendaciones(v_contador_recom).categoria := rec_juego.categoria;
                
                -- Limitar a 10 recomendaciones para no sobrecargar
                EXIT WHEN v_contador_recom >= 10;
            END IF;
        END LOOP;
        
        EXIT WHEN v_contador_recom >= 10;
    END LOOP;
    
    -- 4. Mostrar recomendaciones
    IF v_contador_recom = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron juegos para recomendar.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('=== JUEGOS RECOMENDADOS ===');
        FOR i IN 1..v_recomendaciones.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(i || '. ' || v_recomendaciones(i).nombre || 
                                ' - $' || v_recomendaciones(i).precio || 
                                ' (' || v_recomendaciones(i).categoria || ')');
        END LOOP;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('=== FIN RECOMENDACIONES ===');
END;
/

-- =============================================================================
-- EJEMPLOS DE USO
-- =============================================================================

-- Probar Ejercicio 4: Análisis de compras por usuario
EXEC analisis_compras_usuario(1);

DBMS_OUTPUT.PUT_LINE(CHR(10)); -- Línea en blanco

-- Probar Ejercicio 5: Top 3 juegos más caros  
EXEC top_3_juegos_caros;

DBMS_OUTPUT.PUT_LINE(CHR(10)); -- Línea en blanco

-- Probar Ejercicio 6: Sistema de recomendaciones
EXEC sistema_recomendaciones(1);

DBMS_OUTPUT.PUT_LINE(CHR(10)); -- Línea en blanco

-- Probar con otro usuario
EXEC sistema_recomendaciones(7);