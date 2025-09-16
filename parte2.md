# Tutorial PL/SQL: Segunda Entrega 
## Cursores Explícitos y Manejo de Excepciones (60 minutos)

---

## Antes de Empezar: Lo que Necesitas Tener Listo

Tu base de datos debe estar funcionando con datos reales, y ya deberías tener claros los conceptos básicos de PL/SQL de la sesión anterior. Si tu RECORD y VARRAY de la primera entrega aún te dan problemas, mejor resuelve eso primero.

---

## Objetivos de Esta Sesión

**Objetivo 1: Dominar Cursores Explícitos Complejos**
Vamos a crear al menos 2 cursores que realmente hagan trabajo útil en tu negocio - no solo consultas simples.

**Objetivo 2: Implementar Manejo Robusto de Excepciones**
Aprenderás a manejar tanto errores que ya vienen definidos en Oracle como errores específicos de tu lógica de negocio.

Al final tendrás código que no solo funciona cuando todo sale bien, sino que también sabe qué hacer cuando las cosas se complican.

---

## Parte 1: Cursores Explícitos que Importan (25 minutos)

### ¿Por Qué Cursores Explícitos?

Un cursor explícito es tu manera de decirle a Oracle: "Oye, voy a necesitar procesar estos datos fila por fila, y quiero control total sobre cómo lo hago". Es como la diferencia entre tomar un taxi (cursor implícito) versus manejar tu propio carro (cursor explícito) - tienes más control, pero también más responsabilidad.

### Cursor con Parámetros: El Versátil

Este tipo de cursor es como una función que recibe argumentos. Muy útil cuando necesitas la misma consulta pero con diferentes filtros.

```sql
-- Cursor parametrizado para tu negocio
DECLARE
    -- Cursor que recibe parámetros para filtrar datos
    CURSOR c_datos_filtrados(p_fecha_desde DATE, p_estado VARCHAR2) IS
        SELECT id, nombre, fecha_registro, valor_importante
        FROM tu_tabla_principal
        WHERE fecha_registro >= p_fecha_desde
          AND estado = p_estado
          AND valor_importante IS NOT NULL
        ORDER BY valor_importante DESC;
    
    -- Variables para trabajar
    v_contador NUMBER := 0;
    v_total_procesado NUMBER := 0;
    
BEGIN
    -- Usar el cursor con diferentes parámetros
    DBMS_OUTPUT.PUT_LINE('=== Procesando Registros Activos ===');
    
    FOR registro IN c_datos_filtrados(SYSDATE - 30, 'ACTIVO') LOOP
        v_contador := v_contador + 1;
        v_total_procesado := v_total_procesado + registro.valor_importante;
        
        DBMS_OUTPUT.PUT_LINE(v_contador || ') ' || registro.nombre || 
                           ' - Valor: ' || registro.valor_importante);
        
        -- Aquí iría tu lógica específica de negocio
        IF registro.valor_importante > 1000 THEN
            DBMS_OUTPUT.PUT_LINE('   >>> Registro de alta prioridad');
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total procesado: ' || v_total_procesado);
    DBMS_OUTPUT.PUT_LINE('Registros encontrados: ' || v_contador);
END;
/
```

### Cursor con Lógica Compleja: El Trabajador

Este cursor hace más que solo consultar - procesa, valida, y toma decisiones.

```sql
-- Cursor con lógica de negocio compleja
DECLARE
    CURSOR c_procesamiento_complejo IS
        SELECT a.id, a.nombre, a.categoria,
               COUNT(b.id) as total_relacionados,
               AVG(b.valor) as promedio_valor
        FROM tu_tabla_principal a
        LEFT JOIN tu_tabla_secundaria b ON a.id = b.id_principal
        WHERE a.estado = 'PENDIENTE'
        GROUP BY a.id, a.nombre, a.categoria
        HAVING COUNT(b.id) > 0;
    
    -- Variables de control
    v_procesados_exitosos NUMBER := 0;
    v_procesados_fallidos NUMBER := 0;
    v_categoria_actual VARCHAR2(50) := '';
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Iniciando Procesamiento Complejo ===');
    
    FOR item IN c_procesamiento_complejo LOOP
        -- Lógica de agrupación por categoría
        IF v_categoria_actual != item.categoria THEN
            IF v_categoria_actual IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('--- Fin categoría: ' || v_categoria_actual);
            END IF;
            v_categoria_actual := item.categoria;
            DBMS_OUTPUT.PUT_LINE('>>> Procesando categoría: ' || v_categoria_actual);
        END IF;
        
        -- Lógica de procesamiento por item
        DBMS_OUTPUT.PUT_LINE('Procesando: ' || item.nombre);
        DBMS_OUTPUT.PUT_LINE('  Relacionados: ' || item.total_relacionados);
        DBMS_OUTPUT.PUT_LINE('  Promedio: ' || ROUND(item.promedio_valor, 2));
        
        -- Decisiones basadas en los datos
        IF item.promedio_valor > 500 THEN
            DBMS_OUTPUT.PUT_LINE('  >>> APROBADO para siguiente fase');
            v_procesados_exitosos := v_procesados_exitosos + 1;
            
            -- Aquí harías UPDATE o INSERT según tu lógica
            -- UPDATE tu_tabla_principal SET estado = 'APROBADO' WHERE id = item.id;
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('  >>> RECHAZADO - Valor insuficiente');
            v_procesados_fallidos := v_procesados_fallidos + 1;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('  ---');
    END LOOP;
    
    -- Resumen final
    DBMS_OUTPUT.PUT_LINE('=== Resumen del Procesamiento ===');
    DBMS_OUTPUT.PUT_LINE('Exitosos: ' || v_procesados_exitosos);
    DBMS_OUTPUT.PUT_LINE('Fallidos: ' || v_procesados_fallidos);
    DBMS_OUTPUT.PUT_LINE('Total: ' || (v_procesados_exitosos + v_procesados_fallidos));
END;
/
```

### Las Preguntas Inteligentes para los Cursores

**"¿Cómo optimizo mi cursor para que no sea lento con muchos datos?"**
Te ayudo a identificar qué índices necesitas, cómo estructurar mejor tu WHERE, y cuándo usar BULK COLLECT para mejorar el rendimiento.

**"¿Puedes convertir mi consulta compleja en un cursor útil para mi caso de negocio?"**
Tomo tu consulta SQL y la transformo en un cursor que realmente haga trabajo útil, no solo mostrar datos.

---

## Parte 2: Manejo de Excepciones Profesional (25 minutos)

### Por Qué Necesitas Manejar Excepciones

En el mundo real, las cosas fallan. Los datos vienen mal, las conexiones se cortan, los usuarios meten información rara. Un código profesional no explota - maneja estos problemas con elegancia.

### Excepciones Predefinidas: Los Errores Comunes

Oracle ya sabe qué errores son típicos y les puso nombres fáciles de recordar.

```sql
-- Manejo de excepciones predefinidas
DECLARE
    v_dividendo NUMBER := 100;
    v_divisor NUMBER := 0;
    v_resultado NUMBER;
    v_nombre VARCHAR2(10);
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Probando Manejo de Excepciones ===');
    
    -- Operación que puede fallar de varias maneras
    SELECT nombre INTO v_nombre 
    FROM tu_tabla_principal 
    WHERE valor_importante = 999999; -- Valor que probablemente no existe
    
    v_resultado := v_dividendo / v_divisor; -- División por cero
    
    DBMS_OUTPUT.PUT_LINE('Todo salió bien (esto no debería aparecer)');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No se encontraron registros con ese criterio');
        DBMS_OUTPUT.PUT_LINE('Solución: Verificar que el valor exista en la tabla');
        
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: La consulta devolvió más de un registro');
        DBMS_OUTPUT.PUT_LINE('Solución: Agregar más criterios para que sea único');
        
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Intento de división por cero');
        DBMS_OUTPUT.PUT_LINE('Divisor actual: ' || v_divisor);
        DBMS_OUTPUT.PUT_LINE('Solución: Validar que el divisor no sea cero');
        
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Problema con el tipo o tamaño de datos');
        DBMS_OUTPUT.PUT_LINE('Solución: Verificar que los datos sean compatibles');
        
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INESPERADO: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE);
END;
/
```

### Excepciones Personalizadas: Los Errores de Tu Negocio

Estas las defines tú para manejar situaciones específicas de tu lógica de negocio.

```sql
-- Excepciones personalizadas para tu negocio
DECLARE
    -- Definir tus propias excepciones
    ex_stock_insuficiente EXCEPTION;
    ex_limite_credito_excedido EXCEPTION;
    
    -- Variables de trabajo
    v_stock_disponible NUMBER := 5;
    v_cantidad_solicitada NUMBER := 10;
    v_limite_credito NUMBER := 1000;
    v_monto_operacion NUMBER := 1500;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Validaciones de Negocio ===');
    
    -- Validación 1: Stock suficiente
    IF v_cantidad_solicitada > v_stock_disponible THEN
        RAISE ex_stock_insuficiente;
    END IF;
    
    -- Validación 2: Límite de crédito
    IF v_monto_operacion > v_limite_credito THEN
        RAISE ex_limite_credito_excedido;
    END IF;
    
    -- Si llegamos aquí, todo está bien
    DBMS_OUTPUT.PUT_LINE('Operación aprobada - Procesando...');
    
EXCEPTION
    WHEN ex_stock_insuficiente THEN
        DBMS_OUTPUT.PUT_LINE('NEGOCIO ERROR: Stock insuficiente');
        DBMS_OUTPUT.PUT_LINE('Disponible: ' || v_stock_disponible);
        DBMS_OUTPUT.PUT_LINE('Solicitado: ' || v_cantidad_solicitada);
        DBMS_OUTPUT.PUT_LINE('Acción: Contactar al proveedor o reducir cantidad');
        
    WHEN ex_limite_credito_excedido THEN
        DBMS_OUTPUT.PUT_LINE('NEGOCIO ERROR: Límite de crédito excedido');
        DBMS_OUTPUT.PUT_LINE('Límite: $' || v_limite_credito);
        DBMS_OUTPUT.PUT_LINE('Monto solicitado: $' || v_monto_operacion);
        DBMS_OUTPUT.PUT_LINE('Acción: Solicitar autorización especial');
        
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR TÉCNICO: ' || SQLERRM);
END;
/
```

### Ejemplo Completo: Cursores con Excepciones

```sql
-- Combinando cursores y excepciones en código real
DECLARE
    CURSOR c_procesamiento_seguro IS
        SELECT id, nombre, valor, categoria
        FROM tu_tabla_principal
        WHERE estado = 'PENDIENTE';
    
    -- Excepciones personalizadas
    ex_valor_negativo EXCEPTION;
    ex_categoria_invalida EXCEPTION;
    
    -- Contadores
    v_exitosos NUMBER := 0;
    v_errores NUMBER := 0;
    
BEGIN
    FOR registro IN c_procesamiento_seguro LOOP
        BEGIN -- Bloque interno para manejar errores por registro
            
            -- Validaciones de negocio
            IF registro.valor < 0 THEN
                RAISE ex_valor_negativo;
            END IF;
            
            IF registro.categoria NOT IN ('A', 'B', 'C') THEN
                RAISE ex_categoria_invalida;
            END IF;
            
            -- Procesamiento normal
            DBMS_OUTPUT.PUT_LINE('Procesando: ' || registro.nombre);
            
            -- Aquí harías tus operaciones reales
            -- UPDATE, INSERT, cálculos, etc.
            
            v_exitosos := v_exitosos + 1;
            
        EXCEPTION
            WHEN ex_valor_negativo THEN
                DBMS_OUTPUT.PUT_LINE('  ERROR en ' || registro.nombre || 
                                   ': Valor negativo (' || registro.valor || ')');
                v_errores := v_errores + 1;
                
            WHEN ex_categoria_invalida THEN
                DBMS_OUTPUT.PUT_LINE('  ERROR en ' || registro.nombre || 
                                   ': Categoría inválida (' || registro.categoria || ')');
                v_errores := v_errores + 1;
                
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ERROR TÉCNICO en ' || registro.nombre || 
                                   ': ' || SQLERRM);
                v_errores := v_errores + 1;
        END;
    END LOOP;
    
    -- Reporte final
    DBMS_OUTPUT.PUT_LINE('=== Reporte Final ===');
    DBMS_OUTPUT.PUT_LINE('Procesados exitosamente: ' || v_exitosos);
    DBMS_OUTPUT.PUT_LINE('Errores encontrados: ' || v_errores);
    
END;
/
```

### Las Preguntas Clave para Excepciones

**"¿Qué excepciones específicas debería manejar para mi tipo de negocio?"**
Te ayudo a identificar qué puede salir mal en tu dominio específico y cómo manejar cada situación de manera profesional.

**"¿Cómo hago que mis mensajes de error sean útiles para debuggear?"**
Te enseño a crear mensajes que realmente ayuden a entender qué pasó y cómo solucionarlo.

---

## Últimos 10 Minutos: Revisión y Entregables

### Qué Debes Tener al Final

**Al menos 2 cursores explícitos que:**
- Tengan parámetros o lógica compleja
- Hagan trabajo real relacionado con tu negocio
- Estén bien comentados

**Manejo de excepciones que incluya:**
- Al menos 3 excepciones predefinidas manejadas apropiadamente
- Al menos 2 excepciones personalizadas para tu lógica de negocio
- Mensajes de error útiles

**Código que demuestre:**
- Entendimiento de cuándo usar cursores explícitos
- Capacidad de anticipar y manejar errores
- Lógica de negocio implementada correctamente

### Cronómetro Sugerido

**0-25 min:** Implementa y prueba tus 2 cursores explícitos
**25-50 min:** Desarrolla el manejo de excepciones completo
**50-60 min:** Integra todo, prueba escenarios de error, documenta
