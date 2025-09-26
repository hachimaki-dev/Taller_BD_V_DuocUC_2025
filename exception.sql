-- Excepciones predefinidas
DECLARE
    v_precio NUMBER;
    e_precio_invalido EXCEPTION; -- (para otro ejemplo abajo)
BEGIN
    -- Intentar seleccionar una oferta inexistente → dispara NO_DATA_FOUND
    SELECT precio INTO v_precio FROM OFERTAS WHERE id_oferta = 99; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Oferta no encontrada'); -- Captura NO_DATA_FOUND
END;
/

BEGIN
    -- Intentar insertar un usuario con un ID que ya existe
    INSERT INTO USUARIOS (
        ID_USUARIO, NOMBRE_USUARIO, EMAIL, PASSWORD_HASH, CIUDAD, PAIS, FECHA_REGISTRO
    )
    VALUES (
        1, 'TEST_USER', 'test@test.com', 'hash123', 'MADRID', 'ESPANA', SYSDATE
    );

EXCEPTION
    -- Captura la excepción predefinida cuando se intenta insertar un valor duplicado en una columna con restricción UNIQUE o PRIMARY KEY
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Excepción capturada: DUP_VAL_ON_INDEX -> ID de usuario duplicado.');
END;
/

DECLARE
    v_nombre VARCHAR2(50);
BEGIN
    -- Esto va a devolver más de una fila, provocando TOO_MANY_ROWS
    SELECT nombre_usuario INTO v_nombre
    FROM USUARIOS;  -- Hay 10 usuarios en la tabla

EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Excepción capturada: TOO_MANY_ROWS -> Más de una fila encontrada.');
END;
/


-- Excepciones personalizadas
DECLARE
    v_precio NUMBER := 10;
    v_cantidad NUMBER := 0; -- Simula colección vacía

    -- Excepciones propias definidas por el programador
    e_precio_invalido EXCEPTION;
    e_coleccion_vacia EXCEPTION;
BEGIN
    -- Validar que el precio no sea negativo
    IF v_precio < 0 THEN
        RAISE e_precio_invalido;
    END IF;

    -- Validar que haya al menos un elemento en la colección
    IF v_cantidad = 0 THEN
        RAISE e_coleccion_vacia;
    END IF;
EXCEPTION
    WHEN e_precio_invalido THEN
        DBMS_OUTPUT.PUT_LINE('Error: precio inválido ('||v_precio||')');
    WHEN e_coleccion_vacia THEN
        DBMS_OUTPUT.PUT_LINE('Error: colección vacía');
END;
/



