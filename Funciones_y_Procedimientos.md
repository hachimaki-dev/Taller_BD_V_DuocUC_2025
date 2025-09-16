# Guía Práctica: Procedimientos y Funciones en Oracle


## ANTES DE EMPEZAR: Conceptos Clave

### ¿Qué es un Procedimiento vs una Función?
**ANALOGÍA**: Imagina que son "recetas de cocina" que guardas en la base de datos:
- **Función**: Receta que SIEMPRE devuelve algo (como "hacer pan" devuelve pan)
- **Procedimiento**: Receta que HACE algo pero no necesariamente devuelve (como "limpiar cocina")

### Estructura Mental
```
FUNCIÓN = INPUT → PROCESO → OUTPUT (obligatorio)
PROCEDIMIENTO = INPUT → PROCESO → ACCIÓN (sin output obligatorio)
```

---

## Nivel 1: Fundamentos Básicos

### PASO A PASO: Tu Primera Función

**OBJETIVO**: Entender la estructura básica y cómo "traducir" una consulta SQL a función.

**PASO 1 - Consulta SQL normal:**
```sql
SELECT nombre FROM usuarios WHERE id_usuario = 1;
```

**PASO 2 - Convertir a función:**
```sql
CREATE OR REPLACE FUNCTION obtener_nombre_usuario(p_id_usuario IN NUMBER)
RETURN VARCHAR2
IS
    v_nombre VARCHAR2(50);  -- ESTO ES COMO EL "DECLARE"
BEGIN
    SELECT nombre INTO v_nombre   -- INTO guarda el resultado en variable
    FROM usuarios 
    WHERE id_usuario = p_id_usuario;
    
    RETURN v_nombre;  -- OBLIGATORIO en funciones
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Usuario no encontrado';
END;
/
```

**DESGLOSE LÍNEA POR LÍNEA:**
- `CREATE OR REPLACE FUNCTION`: "Crea o reemplaza una función llamada..."
- `(p_id_usuario IN NUMBER)`: "Que recibe un parámetro numérico llamado p_id_usuario"
- `RETURN VARCHAR2`: "Y que promete devolver texto"
- `IS`: "Las variables locales son:" (equivale a DECLARE)
- `v_nombre VARCHAR2(50)`: "Una variable de texto de máximo 50 caracteres"
- `BEGIN`: "El código ejecutable empieza aquí"
- `SELECT ... INTO v_nombre`: "Ejecuta SELECT pero guarda resultado en variable"
- `RETURN v_nombre`: "Devuelve el contenido de la variable"
- `EXCEPTION`: "Si algo sale mal..."
- `WHEN NO_DATA_FOUND`: "Si la consulta no encuentra datos..."

**CÓMO USARLA:**
```sql
-- Opción 1: Ver el resultado
SELECT obtener_nombre_usuario(1) FROM DUAL;

-- Opción 2: Usarla en otras consultas
SELECT id_usuario, obtener_nombre_usuario(id_usuario) as nombre_completo 
FROM compras;
```

**EJERCICIO MENTAL**: Antes de seguir, intenta crear una función que devuelva el precio de un juego dado su ID.

---

### PASO A PASO: Tu Primer Procedimiento

**OBJETIVO**: Entender la diferencia clave - los procedimientos HACEN cosas.

**PASO 1 - ¿Qué queremos hacer?**
Mostrar información bonita de un usuario en pantalla.

**PASO 2 - Estructura del procedimiento:**
```sql
CREATE OR REPLACE PROCEDURE mostrar_info_usuario(p_id_usuario IN NUMBER)
IS
    -- Variables para guardar los datos
    v_nombre VARCHAR2(50);
    v_email VARCHAR2(100);
    v_saldo NUMBER(10,2);
    v_fecha_registro DATE;
BEGIN
    -- PASO 1: Obtener todos los datos de una vez
    SELECT nombre, email, saldo, fecha_registro
    INTO v_nombre, v_email, v_saldo, v_fecha_registro
    FROM usuarios
    WHERE id_usuario = p_id_usuario;
    
    -- PASO 2: Mostrar información formateada
    DBMS_OUTPUT.PUT_LINE('=== INFORMACIÓN DEL USUARIO ===');
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Saldo: $' || v_saldo);
    DBMS_OUTPUT.PUT_LINE('Registro: ' || TO_CHAR(v_fecha_registro, 'DD/MM/YYYY'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Usuario no encontrado');
END;
/
```

**DIFERENCIAS CLAVE CON FUNCIONES:**
1. NO tiene `RETURN tipo_dato`
2. NO necesita devolver nada
3. Usa `DBMS_OUTPUT.PUT_LINE` para mostrar cosas
4. Se ejecuta con `EXEC` o dentro de bloques BEGIN/END

**CÓMO USARLO:**
```sql
-- Asegúrate de tener esto activado primero
SET SERVEROUTPUT ON;

-- Ejecutar el procedimiento
EXEC mostrar_info_usuario(1);
```

**REFLEXIÓN**: ¿Por qué usarías un procedimiento en lugar de solo hacer SELECT? Respuesta: Para formatear, validar, hacer múltiples operaciones, etc.

---

## Nivel 2: Construyendo Lógica de Negocio

### METODOLOGÍA: De Problema a Solución

**PROBLEMA**: "Necesito saber cuánto dinero ha gastado un usuario en total"

**ANÁLISIS PASO A PASO:**
1. ¿Es una función o procedimiento? → Función (devuelve un número)
2. ¿Qué necesito de entrada? → ID del usuario
3. ¿Qué devuelvo? → El total gastado (número)
4. ¿Cómo lo calculo? → Sumar todos los precios pagados en compras

**SOLUCIÓN CONSTRUIDA:**
```sql
CREATE OR REPLACE FUNCTION calcular_total_gastado(p_id_usuario IN NUMBER)
RETURN NUMBER
IS
    v_total NUMBER(10,2) := 0;  -- INICIALIZO en 0 por seguridad
BEGIN
    SELECT NVL(SUM(precio_pagado), 0) INTO v_total
    FROM compras
    WHERE id_usuario = p_id_usuario;
    
    RETURN v_total;
END;
/
```

**PUNTOS DE APRENDIZAJE:**
- `NVL(SUM(precio_pagado), 0)`: Si no hay compras, devuelve 0 en lugar de NULL
- `:= 0`: Inicializar variable con valor por defecto
- Esta función es "reutilizable" - puedes usarla en muchos contextos

**VALIDACIÓN - ¿Funciona?**
```sql
-- Test 1: Usuario que sí tiene compras
SELECT calcular_total_gastado(1) FROM DUAL;  -- Debería dar 79.98

-- Test 2: Usuario sin compras  
SELECT calcular_total_gastado(999) FROM DUAL;  -- Debería dar 0

-- Test 3: Usar en contexto más amplio
SELECT u.nombre, 
       u.saldo as saldo_actual,
       calcular_total_gastado(u.id_usuario) as total_gastado
FROM usuarios u;
```

### PROBLEMA MÁS COMPLEJO: Validación de Compra

**PROBLEMA**: "Antes de que un usuario compre, quiero saber si puede hacerlo y por qué"

**ANÁLISIS:**
1. ¿Qué puede impedir una compra?
   - Ya tiene el juego
   - No tiene suficiente saldo
   - Usuario o juego no existen
2. ¿Qué devuelvo? → Un mensaje explicativo
3. ¿Es función o procedimiento? → Función (devuelve mensaje)

**CONSTRUCCIÓN POR PASOS:**

**PASO 1 - Estructura básica:**
```sql
CREATE OR REPLACE FUNCTION puede_comprar_juego(
    p_id_usuario IN NUMBER,
    p_id_juego IN NUMBER
) RETURN VARCHAR2
IS
    -- Variables que necesitaré
    v_saldo_usuario NUMBER(10,2);
    v_precio_juego NUMBER(8,2);
    v_ya_tiene NUMBER;
BEGIN
    -- Lógica aquí
    RETURN 'Resultado aquí';
END;
/
```

**PASO 2 - Primera validación (ya tiene el juego):**
```sql
-- Verificar si ya tiene el juego
SELECT COUNT(*) INTO v_ya_tiene
FROM biblioteca
WHERE id_usuario = p_id_usuario AND id_juego = p_id_juego;

IF v_ya_tiene > 0 THEN
    RETURN 'ERROR: Ya tienes este juego';
END IF;
```

**PASO 3 - Segunda validación (saldo suficiente):**
```sql
-- Obtener saldo del usuario y precio del juego
SELECT saldo INTO v_saldo_usuario 
FROM usuarios WHERE id_usuario = p_id_usuario;

SELECT precio INTO v_precio_juego 
FROM juegos WHERE id_juego = p_id_juego;

IF v_saldo_usuario >= v_precio_juego THEN
    RETURN 'OK: Puedes comprarlo';
ELSE
    RETURN 'ERROR: Saldo insuficiente (falta $' || 
           (v_precio_juego - v_saldo_usuario) || ')';
END IF;
```

**FUNCIÓN COMPLETA:**
```sql
CREATE OR REPLACE FUNCTION puede_comprar_juego(
    p_id_usuario IN NUMBER,
    p_id_juego IN NUMBER
) RETURN VARCHAR2
IS
    v_saldo_usuario NUMBER(10,2);
    v_precio_juego NUMBER(8,2);
    v_ya_tiene NUMBER;
BEGIN
    -- Validación 1: ¿Ya tiene el juego?
    SELECT COUNT(*) INTO v_ya_tiene
    FROM biblioteca
    WHERE id_usuario = p_id_usuario AND id_juego = p_id_juego;
    
    IF v_ya_tiene > 0 THEN
        RETURN 'ERROR: Ya tienes este juego';
    END IF;
    
    -- Validación 2: ¿Tiene saldo suficiente?
    SELECT saldo INTO v_saldo_usuario 
    FROM usuarios WHERE id_usuario = p_id_usuario;
    
    SELECT precio INTO v_precio_juego 
    FROM juegos WHERE id_juego = p_id_juego;
    
    IF v_saldo_usuario >= v_precio_juego THEN
        RETURN 'OK: Puedes comprarlo';
    ELSE
        RETURN 'ERROR: Saldo insuficiente (falta $' || 
               (v_precio_juego - v_saldo_usuario) || ')';
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'ERROR: Usuario o juego no encontrado';
END;
/
```

**TESTING SISTEMÁTICO:**
```sql
-- Test casos positivos y negativos
SELECT 'Usuario 1, Juego 102' as caso, puede_comprar_juego(1, 102) as resultado FROM DUAL
UNION ALL
SELECT 'Usuario 1, Juego 101' as caso, puede_comprar_juego(1, 101) as resultado FROM DUAL
UNION ALL
SELECT 'Usuario 999, Juego 101' as caso, puede_comprar_juego(999, 101) as resultado FROM DUAL;
```

---

## Nivel 3: Transacciones y Procedimientos Complejos

### CONCEPTO CLAVE: Transacciones
**DEFINICIÓN SIMPLE**: Una transacción es "todo o nada". O se hacen TODAS las operaciones o NO se hace ninguna.

**EJEMPLO DE LA VIDA REAL**: Comprar un juego implica:
1. Registrar la compra
2. Agregarlo a la biblioteca
3. Descontar el dinero del saldo

Si CUALQUIERA de estos pasos falla, NINGUNO debe ejecutarse.

### CONSTRUCCIÓN DE PROCEDIMIENTO TRANSACCIONAL

**METODOLOGÍA - Los 5 Pasos:**
1. **VALIDAR** antes de hacer cambios
2. **PREPARAR** los datos necesarios
3. **EJECUTAR** todas las operaciones
4. **CONFIRMAR** con COMMIT
5. **MANEJAR ERRORES** con ROLLBACK

**IMPLEMENTACIÓN PASO A PASO:**

```sql
CREATE OR REPLACE PROCEDURE comprar_juego(
    p_id_usuario IN NUMBER,
    p_id_juego IN NUMBER,
    p_mensaje OUT VARCHAR2  -- PARÁMETRO OUT para devolver resultado
)
IS
    -- Variables para validaciones
    v_saldo NUMBER(10,2);
    v_precio NUMBER(8,2);
    v_nombre_juego VARCHAR2(100);
    v_nombre_usuario VARCHAR2(50);
    v_ya_tiene NUMBER;
    v_nuevo_id_compra NUMBER;
BEGIN
    -- PASO 1: VALIDACIONES (sin modificar datos aún)
    
    -- ¿Ya tiene el juego?
    SELECT COUNT(*) INTO v_ya_tiene
    FROM biblioteca
    WHERE id_usuario = p_id_usuario AND id_juego = p_id_juego;
    
    IF v_ya_tiene > 0 THEN
        p_mensaje := 'ERROR: El usuario ya posee este juego';
        RETURN;  -- Salir sin hacer nada
    END IF;
    
    -- PASO 2: OBTENER DATOS NECESARIOS
    SELECT u.saldo, u.nombre, j.precio, j.nombre
    INTO v_saldo, v_nombre_usuario, v_precio, v_nombre_juego
    FROM usuarios u, juegos j
    WHERE u.id_usuario = p_id_usuario AND j.id_juego = p_id_juego;
    
    -- ¿Tiene saldo suficiente?
    IF v_saldo < v_precio THEN
        p_mensaje := 'ERROR: Saldo insuficiente. Necesitas $' || (v_precio - v_saldo) || ' más';
        RETURN;
    END IF;
    
    -- PASO 3: PREPARAR DATOS
    SELECT NVL(MAX(id_compra), 0) + 1 INTO v_nuevo_id_compra FROM compras;
    
    -- PASO 4: EJECUTAR TRANSACCIÓN COMPLETA
    
    -- Operación 1: Registrar compra
    INSERT INTO compras (id_compra, id_usuario, id_juego, fecha_compra, precio_pagado)
    VALUES (v_nuevo_id_compra, p_id_usuario, p_id_juego, SYSDATE, v_precio);
    
    -- Operación 2: Agregar a biblioteca
    INSERT INTO biblioteca (id_usuario, id_juego, horas_jugadas, fecha_agregado)
    VALUES (p_id_usuario, p_id_juego, 0, SYSDATE);
    
    -- Operación 3: Descontar saldo
    UPDATE usuarios 
    SET saldo = saldo - v_precio 
    WHERE id_usuario = p_id_usuario;
    
    -- PASO 5: CONFIRMAR TODO
    COMMIT;
    
    p_mensaje := 'ÉXITO: ' || v_nombre_usuario || 
                 ' adquirió "' || v_nombre_juego || '" por $' || v_precio;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;  -- Deshacer cualquier cambio parcial
        p_mensaje := 'ERROR: Usuario o juego no encontrado';
    WHEN OTHERS THEN
        ROLLBACK;  -- Deshacer cualquier cambio parcial
        p_mensaje := 'ERROR: Fallo en la compra: ' || SQLERRM;
END;
/
```

**CÓMO USAR PARÁMETROS OUT:**
```sql
DECLARE
    v_resultado VARCHAR2(200);
BEGIN
    comprar_juego(3, 102, v_resultado);  -- Carlos compra Racing Legends
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/
```

**VERIFICAR QUE FUNCIONÓ:**
```sql
-- Verificar saldo actualizado
SELECT nombre, saldo FROM usuarios WHERE id_usuario = 3;

-- Verificar que está en biblioteca  
SELECT * FROM biblioteca WHERE id_usuario = 3 AND id_juego = 102;

-- Verificar registro de compra
SELECT * FROM compras WHERE id_usuario = 3 AND id_juego = 102;
```

---

## Nivel 4: Análisis y Reportes

### CONCEPTO: Cursores
**DEFINICIÓN**: Un cursor es como un "puntero" que recorre registros de una consulta uno por uno.

**CUÁNDO USARLOS**: Cuando necesitas procesar cada registro individualmente en lugar de toda la consulta de una vez.

### PROCEDIMIENTO CON CURSOR - Reporte de Ventas

**CONSTRUCCIÓN MENTAL:**
1. Necesito agrupar ventas por categoría
2. Para cada categoría, mostrar estadísticas
3. Al final, mostrar un total general

```sql
CREATE OR REPLACE PROCEDURE generar_reporte_ventas
IS
    -- CURSOR: Define la consulta que quiero recorrer
    CURSOR c_ventas IS
        SELECT j.categoria, 
               COUNT(*) as total_ventas,
               SUM(c.precio_pagado) as ingresos_totales,
               AVG(c.precio_pagado) as precio_promedio
        FROM compras c
        JOIN juegos j ON c.id_juego = j.id_juego
        GROUP BY j.categoria
        ORDER BY ingresos_totales DESC;
    
    v_total_general NUMBER(10,2) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('REPORTE DE VENTAS POR CATEGORÍA');
    DBMS_OUTPUT.PUT_LINE('=====================================');
    
    -- FOR LOOP automático con cursor
    FOR registro IN c_ventas LOOP
        DBMS_OUTPUT.PUT_LINE('Categoría: ' || registro.categoria);
        DBMS_OUTPUT.PUT_LINE('  Juegos vendidos: ' || registro.total_ventas);
        DBMS_OUTPUT.PUT_LINE('  Ingresos: $' || registro.ingresos_totales);
        DBMS_OUTPUT.PUT_LINE('  Precio promedio: $' || ROUND(registro.precio_promedio, 2));
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        
        v_total_general := v_total_general + registro.ingresos_totales;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('TOTAL GENERAL: $' || v_total_general);
END;
/
```

**EJECUCIÓN:**
```sql
SET SERVEROUTPUT ON;
EXEC generar_reporte_ventas;
```

**EXPLICACIÓN DEL CURSOR:**
- `CURSOR c_ventas IS`: Define qué consulta quiero recorrer
- `FOR registro IN c_ventas LOOP`: Automáticamente abre cursor, recorre cada fila, cierra cursor
- `registro.campo`: Accede a cada campo de la fila actual
- Oracle maneja automáticamente la apertura/cierre del cursor

---

## Nivel 5: Técnicas Avanzadas

### VALIDACIONES ROBUSTAS

**PRINCIPIO**: Validar SIEMPRE antes de ejecutar, dar mensajes claros de error.

```sql
CREATE OR REPLACE PROCEDURE actualizar_horas_juego(
    p_id_usuario IN NUMBER,
    p_id_juego IN NUMBER,
    p_horas_adicionales IN NUMBER
)
IS
    v_existe_en_biblioteca NUMBER;
    v_horas_actuales NUMBER;
    v_nombre_usuario VARCHAR2(50);
    v_nombre_juego VARCHAR2(100);
BEGIN
    -- VALIDACIÓN 1: Parámetros básicos
    IF p_horas_adicionales < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Las horas no pueden ser negativas');
    END IF;
    
    IF p_horas_adicionales > 1000 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: Demasiadas horas de una vez (máximo 1000)');
    END IF;
    
    -- VALIDACIÓN 2: ¿Existe el juego en la biblioteca?
    SELECT COUNT(*), NVL(MAX(horas_jugadas), 0)
    INTO v_existe_en_biblioteca, v_horas_actuales
    FROM biblioteca
    WHERE id_usuario = p_id_usuario AND id_juego = p_id_juego;
    
    IF v_existe_en_biblioteca = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: El usuario no posee este juego en su biblioteca');
    END IF;
    
    -- VALIDACIÓN 3: ¿Existen el usuario y juego?
    BEGIN
        SELECT u.nombre, j.nombre
        INTO v_nombre_usuario, v_nombre_juego
        FROM usuarios u, juegos j
        WHERE u.id_usuario = p_id_usuario AND j.id_juego = p_id_juego;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'ERROR: Usuario o juego no encontrado');
    END;
    
    -- ACTUALIZACIÓN SEGURA
    UPDATE biblioteca
    SET horas_jugadas = horas_jugadas + p_horas_adicionales
    WHERE id_usuario = p_id_usuario AND id_juego = p_id_juego;
    
    COMMIT;
    
    -- CONFIRMACIÓN AMIGABLE
    DBMS_OUTPUT.PUT_LINE('ACTUALIZACIÓN EXITOSA:');
    DBMS_OUTPUT.PUT_LINE('  Usuario: ' || v_nombre_usuario);
    DBMS_OUTPUT.PUT_LINE('  Juego: "' || v_nombre_juego || '"');
    DBMS_OUTPUT.PUT_LINE('  Horas anteriores: ' || v_horas_actuales);
    DBMS_OUTPUT.PUT_LINE('  Horas agregadas: ' || p_horas_adicionales);
    DBMS_OUTPUT.PUT_LINE('  Total actual: ' || (v_horas_actuales + p_horas_adicionales));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE; -- Re-lanza la excepción para que el usuario la vea
END;
/
```

---

## METODOLOGÍA DE DEBUGGING

### Cuando tu código no funciona:

**PASO 1 - Ver errores de compilación:**
```sql
SELECT * FROM USER_ERRORS WHERE NAME = 'NOMBRE_TU_PROCEDIMIENTO';
```

**PASO 2 - Ver el código fuente:**
```sql
SELECT TEXT FROM USER_SOURCE WHERE NAME = 'NOMBRE_TU_PROCEDIMIENTO' ORDER BY LINE;
```

**PASO 3 - Testing paso a paso:**
```sql
-- En lugar de probar todo junto, prueba por partes
BEGIN
    DBMS_OUTPUT.PUT_LINE('Prueba 1: ' || obtener_nombre_usuario(1));
    DBMS_OUTPUT.PUT_LINE('Prueba 2: ' || puede_comprar_juego(1, 102));
END;
/
```

---

## BUENAS PRÁCTICAS - RESUMEN

### 1. NOMENCLATURA CONSISTENTE
- `p_` para parámetros
- `v_` para variables locales  
- `c_` para cursores
- Nombres descriptivos: `v_total_gastado` mejor que `v_total`

### 2. VALIDACIÓN SIEMPRE PRIMERO
- Validar parámetros de entrada
- Verificar que existan los registros necesarios
- Dar mensajes de error claros

### 3. TRANSACCIONES CONTROLADAS
- COMMIT solo cuando todo esté bien
- ROLLBACK inmediato en errores
- Agrupar operaciones relacionadas

### 4. MANEJO DE ERRORES ESPECÍFICO
```sql
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Error específico con mensaje claro
    WHEN TOO_MANY_ROWS THEN  
        -- Error específico con mensaje claro
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE; -- Re-lanza para debugging
```

### 5. TESTING SISTEMÁTICO
- Casos normales
- Casos límite
- Casos de error
- Verificar efectos secundarios

---

## EJERCICIOS PROGRESIVOS

### EJERCICIO NIVEL 1
Crear una función que devuelva la categoría de un juego dado su ID.

### EJERCICIO NIVEL 2  
Crear una función que calcule el promedio de horas jugadas por un usuario.

### EJERCICIO NIVEL 3
Crear un procedimiento que permita a un usuario regalar un juego a otro usuario.

### EJERCICIO NIVEL 4
Crear un procedimiento que genere un reporte de los usuarios más activos.

### EJERCICIO NIVEL 5
Crear un sistema completo de descuentos con validaciones y logging.
