-- Cursor con parámetro: trae ofertas según el tipo indicado
DECLARE
    CURSOR c_ofertas(p_tipo OFERTAS.TIPO_OFERTA%TYPE) IS
        SELECT id_oferta, tipo_oferta, precio
        FROM OFERTAS
        WHERE tipo_oferta = p_tipo;

BEGIN
    -- Ejemplo: recorrer todas las ofertas de tipo 'VENTA'
    FOR r IN c_ofertas('VENTA') LOOP
        DBMS_OUTPUT.PUT_LINE('Oferta ID: '||r.id_oferta||' |  Precio: $'||r.precio);
    END LOOP;
END;
/

-- Cursor con loop anidado: usuarios y sus colecciones (con nombre del modelo)
DECLARE
    CURSOR c_usuarios IS
        SELECT id_usuario, nombre_usuario FROM USUARIOS;

    CURSOR c_coleccion(p_id NUMBER) IS
        SELECT cu.id_modelo, m.nombre_modelo
        FROM COLECCION_USUARIOS cu
        JOIN MODELOS_AUTOS m ON cu.id_modelo = m.id_modelo
        WHERE cu.id_usuario = p_id;
BEGIN
    -- Recorrer todos los usuarios
    FOR u IN c_usuarios LOOP
        DBMS_OUTPUT.PUT_LINE('Usuario: ' || u.nombre_usuario);

        -- Para cada usuario, mostrar los modelos que tiene con nombre
        FOR c IN c_coleccion(u.id_usuario) LOOP
            DBMS_OUTPUT.PUT_LINE('   Tiene modelo: ' || c.nombre_modelo || ' (ID ' || c.id_modelo || ')');
        END LOOP;
    END LOOP;
END;
/
