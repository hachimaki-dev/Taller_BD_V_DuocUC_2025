# Tutorial PL/SQL: Segunda Entrega - Cursores y Excepciones
## El Arte de Procesar Datos Sin Que Todo Explote (60 minutos)

---

## Antes de Que Te Metas en Problemas

¿Ya tienes tu base de datos funcionando? ¿Tus RECORDs y VARRAYs de la primera entrega ya no te dan pesadillas? Perfecto. Si dudaste, para aquí. Intentar hacer cursores complejos sin tener lo básico claro es como tratar de hacer malabares mientras aprendes a caminar - teóricamente posible, prácticamente desastroso.

**Checkpoint rápido:** Abre tu base de datos, ejecuta una consulta simple, confirma que tienes datos. Si algo falló, arregla eso primero. Los cursores sin datos son como autos sin gasolina.

---

## Lo que Vamos a Lograr Hoy

**Misión 1: Dominar Cursores Que Trabajen de Verdad**
Olvídate de esos cursores de tutorial que solo imprimen "Hola mundo". Vamos a crear cursores que procesen, validen, filtren y tomen decisiones reales. Como un empleado digital que sabe hacer su trabajo.

**Misión 2: Manejar Errores Como un Profesional**
Porque en el mundo real, Murphy's Law es una constante: todo lo que puede salir mal, saldrá mal. Tu código va a aprender a fallar con elegancia, no como una explosión nuclear.

**Misión 3: Combinar Ambos Sin Volverse Loco**
Al final tendrás cursores robustos que no solo procesan datos, sino que saben qué hacer cuando los datos vienen raros, incompletos o directamente imposibles.

---

## Parte 1: Cursores Explícitos - Los Trabajadores Inteligentes (25 minutos)

### ¿Por Qué Explícitos y No Implícitos?

Imagínate que necesitas procesar todas las órdenes pendientes de tu restaurante. Un cursor implícito es como mandar al mesero más nuevo: "Ve y trae las órdenes." Un cursor explícito es como darle instrucciones específicas: "Ve a la cocina, revisa cada orden pendiente, valida que tenemos todos los ingredientes, organízalas por prioridad, y tráeme un reporte detallado."

### Plantilla del Cursor Parametrizado (El Versátil)

```sql
-- El cursor que se adapta a lo que necesites
DECLARE
    -- Cursor que recibe parámetros como un jefe que da instrucciones claras
    CURSOR c_mis_datos_inteligentes(
        p_fecha_desde DATE,
        p_categoria VARCHAR2,
        p_limite_minimo NUMBER DEFAULT 0
    ) IS
        SELECT id, nombre, fecha_creacion, valor_critico, categoria,
               -- Cálculos útiles directamente en el cursor
               CASE 
                   WHEN valor_critico > 1000 THEN 'ALTA_PRIORIDAD'
                   WHEN valor_critico > 500 THEN 'MEDIA_PRIORIDAD'
                   ELSE 'BAJA_PRIORIDAD'
               END as prioridad_calculada
        FROM mi_tabla_principal
        WHERE fecha_creacion >= p_fecha_desde
          AND categoria LIKE '%' || p_categoria || '%'
          AND valor_critico > p_limite_minimo
          AND estado_activo = 'S'
        ORDER BY valor_critico DESC, fecha_creacion ASC;
    
    -- Variables de trabajo que realmente importan
    v_contador_procesados NUMBER := 0;
    v_total_valor NUMBER := 0;
    v_categoria_anterior VARCHAR2(50) := 'PRIMERA_VEZ';
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Procesamiento Inteligente de Datos ===');
    DBMS_OUTPUT.PUT_LINE('Fecha desde: ' || TO_CHAR(SYSDATE - 30, 'DD/MM/YYYY'));
    
    -- Usamos el cursor con parámetros reales de tu negocio
    FOR registro IN c_mis_datos_inteligentes(SYSDATE - 30, 'PREMIUM', 100) LOOP
        
        -- Detectar cambios de categoría para agrupar el procesamiento
        IF v_categoria_anterior != registro.categoria THEN
            IF v_categoria_anterior != 'PRIMERA_VEZ' THEN
                DBMS_OUTPUT.PUT_LINE('  [Subtotal categoría anterior: $' || v_total_valor || ']');
            END IF;
            DBMS_OUTPUT.PUT_LINE('>>> Categoría: ' || registro.categoria);
            v_categoria_anterior := registro.categoria;
            v_total_valor := 0; -- Reset para la nueva categoría
        END IF;
        
        -- Procesamiento específico por registro
        v_contador_procesados := v_contador_procesados + 1;
        v_total_valor := v_total_valor + registro.valor_critico;
        
        DBMS_OUTPUT.PUT_LINE(v_contador_procesados || ') ' || registro.nombre);
        DBMS_OUTPUT.PUT_LINE('    Valor: $' || registro.valor_critico || 
                           ' | Prioridad: ' || registro.prioridad_calculada);
        
        -- Lógica de negocio específica según la prioridad
        CASE registro.prioridad_calculada
            WHEN 'ALTA_PRIORIDAD' THEN
                DBMS_OUTPUT.PUT_LINE('    >>> ACCIÓN: Procesar inmediatamente');
                -- Aquí irían tus UPDATEs, INSERTs específicos
                
            WHEN 'MEDIA_PRIORIDAD' THEN
                DBMS_OUTPUT.PUT_LINE('    >>> ACCIÓN: Programar para mañana');
                
            ELSE
                DBMS_OUTPUT.PUT_LINE('    >>> ACCIÓN: Revisar la próxima semana');
        END CASE;
        
    END LOOP;
    
    -- Reporte final útil
    DBMS_OUTPUT.PUT_LINE('=== Resumen del Procesamiento ===');
    DBMS_OUTPUT.PUT_LINE('Total procesados: ' || v_contador_procesados);
    DBMS_OUTPUT.PUT_LINE('Valor total final: $' || v_total_valor);
    
    IF v_contador_procesados = 0 THEN
        DBMS_OUTPUT.PUT_LINE('⚠️  ADVERTENCIA: No se encontraron registros con los criterios dados');
    END IF;
    
END;
/
```

### Plantilla del Cursor Complejo (El Analista)

```sql
-- Cursor que hace análisis serio, no solo consultas básicas
DECLARE
    CURSOR c_analisis_complejo IS
        SELECT 
            p.id, p.nombre, p.categoria,
            COUNT(s.id) as total_movimientos,
            SUM(s.monto) as suma_total,
            AVG(s.monto) as promedio_monto,
            MAX(s.fecha_movimiento) as ultimo_movimiento,
            -- Análisis inteligente en el mismo cursor
            CASE 
                WHEN COUNT(s.id) > 10 AND AVG(s.monto) > 500 THEN 'CLIENTE_VIP'
                WHEN COUNT(s.id) > 5 THEN 'CLIENTE_FRECUENTE'
                WHEN COUNT(s.id) > 0 THEN 'CLIENTE_OCASIONAL'
                ELSE 'CLIENTE_INACTIVO'
            END as tipo_cliente,
            -- Tendencia (comparar últimos movimientos vs anteriores)
            CASE 
                WHEN MAX(s.fecha_movimiento) > SYSDATE - 30 THEN 'ACTIVO_RECIENTE'
                WHEN MAX(s.fecha_movimiento) > SYSDATE - 90 THEN 'ACTIVO_MODERADO'
                ELSE 'INACTIVO'
            END as tendencia
        FROM mi_tabla_principal p
        LEFT JOIN mi_tabla_movimientos s ON p.id = s.id_principal
        WHERE p.estado = 'ACTIVO'
        GROUP BY p.id, p.nombre, p.categoria
        HAVING COUNT(s.id) >= 1  -- Solo los que tienen al menos un movimiento
        ORDER BY suma_total DESC, total_movimientos DESC;
    
    -- Variables para estadísticas avanzadas
    v_vips NUMBER := 0;
    v_frecuentes NUMBER := 0;
    v_ocasionales NUMBER := 0;
    v_total_ingresos NUMBER := 0;
    v_mejor_cliente VARCHAR2(100);
    v_mejor_valor NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Análisis Avanzado de Clientes ===');
    
    FOR cliente IN c_analisis_complejo LOOP
        
        -- Tracking del mejor cliente
        IF cliente.suma_total > v_mejor_valor THEN
            v_mejor_cliente := cliente.nombre;
            v_mejor_valor := cliente.suma_total;
        END IF;
        
        -- Contadores por tipo
        CASE cliente.tipo_cliente
            WHEN 'CLIENTE_VIP' THEN v_vips := v_vips + 1;
            WHEN 'CLIENTE_FRECUENTE' THEN v_frecuentes := v_frecuentes + 1;
            WHEN 'CLIENTE_OCASIONAL' THEN v_ocasionales := v_ocasionales + 1;
        END CASE;
        
        v_total_ingresos := v_total_ingresos + cliente.suma_total;
        
        -- Reporte por cliente con insights útiles
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || cliente.nombre || ' (' || cliente.tipo_cliente || ')');
        DBMS_OUTPUT.PUT_LINE('  Movimientos: ' || cliente.total_movimientos || 
                           ' | Total: $' || ROUND(cliente.suma_total, 2) ||
                           ' | Promedio: $' || ROUND(cliente.promedio_monto, 2));
        DBMS_OUTPUT.PUT_LINE('  Último movimiento: ' || TO_CHAR(cliente.ultimo_movimiento, 'DD/MM/YYYY') ||
                           ' | Tendencia: ' || cliente.tendencia);
        
        -- Recomendaciones automáticas basadas en el análisis
        IF cliente.tipo_cliente = 'CLIENTE_VIP' AND cliente.tendencia = 'ACTIVO_RECIENTE' THEN
            DBMS_OUTPUT.PUT_LINE('  🌟 ACCIÓN: Ofrecer descuento premium');
        ELSIF cliente.tipo_cliente = 'CLIENTE_FRECUENTE' AND cliente.tendencia != 'ACTIVO_RECIENTE' THEN
            DBMS_OUTPUT.PUT_LINE('  📞 ACCIÓN: Contactar para reactivación');
        ELSIF cliente.tipo_cliente = 'CLIENTE_OCASIONAL' AND cliente.tendencia = 'ACTIVO_RECIENTE' THEN
            DBMS_OUTPUT.PUT_LINE('  📈 ACCIÓN: Campaña para volverlo frecuente');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('  ---');
    END LOOP;
    
    -- Estadísticas finales súper útiles
    DBMS_OUTPUT.PUT_LINE('=== Estadísticas del Negocio ===');
    DBMS_OUTPUT.PUT_LINE('🏆 Mejor cliente: ' || v_mejor_cliente || ' ($' || v_mejor_valor || ')');
    DBMS_OUTPUT.PUT_LINE('👑 Clientes VIP: ' || v_vips);
    DBMS_OUTPUT.PUT_LINE('⭐ Clientes frecuentes: ' || v_frecuentes);
    DBMS_OUTPUT.PUT_LINE('🤝 Clientes ocasionales: ' || v_ocasionales);
    DBMS_OUTPUT.PUT_LINE('💰 Ingresos totales: $' || ROUND(v_total_ingresos, 2));
    
    IF v_vips > 0 THEN
        DBMS_OUTPUT.PUT_LINE('📊 Concentración VIP: ' || 
                           ROUND((v_mejor_valor / v_total_ingresos) * 100, 1) || '% del total');
    END IF;
    
END;
/
```

### Las Preguntas Que Te Harán Brillar

**"¿Puedes optimizar mi cursor para que no se cuelgue con 50,000 registros?"**

Aquí hablamos en serio. Te ayudo a identificar qué índices faltan, cómo usar BULK COLLECT cuando necesites velocidad, y cuándo dividir un cursor grande en varios más pequeños. Es la diferencia entre código de estudiante y código de producción.

**"Convierte mi reporte de Excel manual en un cursor automatizado"**

Esta es oro puro. Tomamos esas consultas que haces a mano cada semana/mes y las convertimos en cursores que generen el mismo análisis automáticamente. Con mejores cálculos y validaciones incluidas.

---

## Parte 2: Excepciones - El Arte de Fallar con Elegancia (25 minutos)

### ¿Por Qué Es Crítico Manejar Excepciones?

En el mundo real, los usuarios meten letras donde van números, las conexiones de red se caen, las tablas están vacías cuando no deberían estarlo, y los servidores se quedan sin espacio. Tu código debe ser como un buen piloto: preparado para turbulencia.

### Plantilla de Excepciones Predefinidas (Los Clásicos)

```sql
-- Manejo robusto de los errores más comunes
DECLARE
    v_usuario_id NUMBER := 999999; -- ID que probablemente no existe
    v_nombre_usuario VARCHAR2(50);
    v_contador_registros NUMBER;
    v_fecha_proceso DATE;
    
    -- Variables para operaciones matemáticas riesgosas
    v_dividendo NUMBER := 100;
    v_divisor NUMBER := 0;
    v_resultado NUMBER;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Probando Escenarios Reales de Error ===');
    
    -- Operación 1: Buscar un usuario específico
    BEGIN
        SELECT nombre INTO v_nombre_usuario 
        FROM usuarios 
        WHERE id_usuario = v_usuario_id;
        
        DBMS_OUTPUT.PUT_LINE('Usuario encontrado: ' || v_nombre_usuario);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('❌ ERROR: Usuario ID ' || v_usuario_id || ' no existe');
            DBMS_OUTPUT.PUT_LINE('💡 SOLUCIÓN: Verificar ID en la tabla usuarios');
            DBMS_OUTPUT.PUT_LINE('🔧 ACCIÓN: Usar usuario por defecto o solicitar ID válido');
            v_nombre_usuario := 'USUARIO_DEFECTO';
    END;
    
    -- Operación 2: Contar registros (puede devolver múltiples filas por error en consulta)
    BEGIN
        SELECT nombre INTO v_nombre_usuario
        FROM usuarios 
        WHERE categoria = 'ADMIN'; -- Puede haber varios ADMIN
        
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('❌ ERROR: Múltiples administradores encontrados');
            DBMS_OUTPUT.PUT_LINE('💡 SOLUCIÓN: Agregar criterio adicional (ej: AND activo = ''S'')');
            
            -- Solucionamos el problema automáticamente
            SELECT COUNT(*) INTO v_contador_registros
            FROM usuarios WHERE categoria = 'ADMIN';
            DBMS_OUTPUT.PUT_LINE('🔧 INFO: Total administradores: ' || v_contador_registros);
    END;
    
    -- Operación 3: Conversiones y cálculos peligrosos
    BEGIN
        -- Esto fallará por división por cero
        v_resultado := v_dividendo / v_divisor;
        
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('❌ ERROR: División por cero detectada');
            DBMS_OUTPUT.PUT_LINE('📊 DATOS: Dividendo=' || v_dividendo || ', Divisor=' || v_divisor);
            DBMS_OUTPUT.PUT_LINE('🔧 ACCIÓN: Usando valor por defecto (0)');
            v_resultado := 0;
    END;
    
    -- Operación 4: Problemas de formato/tamaño
    DECLARE
        v_texto_pequeno VARCHAR2(5);
    BEGIN
        v_texto_pequeno := 'Este texto es demasiado largo para la variable';
        
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('❌ ERROR: Problema de tipo o tamaño de datos');
            DBMS_OUTPUT.PUT_LINE('🔧 ACCIÓN: Truncando texto para que quepa');
            v_texto_pequeno := 'Texto';
    END;
    
    -- Operación 5: Fechas problemáticas
    BEGIN
        v_fecha_proceso := TO_DATE('32/13/2024', 'DD/MM/YYYY'); -- Fecha inválida
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('❌ ERROR GENERAL: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('🔧 ACCIÓN: Usando fecha actual como fallback');
            v_fecha_proceso := SYSDATE;
    END;
    
    DBMS_OUTPUT.PUT_LINE('✅ Procesamiento completado con manejo robusto de errores');
    DBMS_OUTPUT.PUT_LINE('📋 Usuario final: ' || v_nombre_usuario);
    DBMS_OUTPUT.PUT_LINE('📋 Resultado cálculo: ' || v_resultado);
    DBMS_OUTPUT.PUT_LINE('📋 Fecha proceso: ' || TO_CHAR(v_fecha_proceso, 'DD/MM/YYYY'));
    
END;
/
```

### Plantilla de Excepciones Personalizadas (Los Errores de Tu Negocio)

```sql
-- Excepciones que importan en tu negocio específico
DECLARE
    -- Definir excepciones específicas de tu dominio
    ex_inventario_insuficiente EXCEPTION;
    ex_cliente_moroso EXCEPTION;
    ex_limite_credito_excedido EXCEPTION;
    ex_horario_no_permitido EXCEPTION;
    ex_producto_descontinuado EXCEPTION;
    
    -- Variables del negocio para validaciones
    v_stock_disponible NUMBER := 3;
    v_cantidad_pedida NUMBER := 10;
    v_limite_credito NUMBER := 5000;
    v_compra_actual NUMBER := 7500;
    v_dias_mora NUMBER := 45;
    v_hora_actual NUMBER := EXTRACT(HOUR FROM SYSDATE);
    v_producto_estado VARCHAR2(20) := 'DESCONTINUADO';
    
    -- Variables de control
    v_transaccion_aprobada BOOLEAN := FALSE;
    v_requiere_autorizacion BOOLEAN := FALSE;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Sistema de Validaciones de Negocio ===');
    DBMS_OUTPUT.PUT_LINE('Iniciando validaciones para transacción...');
    
    -- Validación 1: Horario de operación
    IF v_hora_actual < 8 OR v_hora_actual > 20 THEN
        RAISE ex_horario_no_permitido;
    END IF;
    
    -- Validación 2: Estado del producto
    IF v_producto_estado = 'DESCONTINUADO' THEN
        RAISE ex_producto_descontinuado;
    END IF;
    
    -- Validación 3: Inventario suficiente
    IF v_cantidad_pedida > v_stock_disponible THEN
        RAISE ex_inventario_insuficiente;
    END IF;
    
    -- Validación 4: Estado crediticio del cliente
    IF v_dias_mora > 30 THEN
        RAISE ex_cliente_moroso;
    END IF;
    
    -- Validación 5: Límite de crédito
    IF v_compra_actual > v_limite_credito THEN
        RAISE ex_limite_credito_excedido;
    END IF;
    
    -- Si llegamos aquí, todo está perfecto
    v_transaccion_aprobada := TRUE;
    DBMS_OUTPUT.PUT_LINE('✅ Todas las validaciones pasaron correctamente');
    DBMS_OUTPUT.PUT_LINE('🚀 Transacción APROBADA automáticamente');
    
EXCEPTION
    WHEN ex_horario_no_permitido THEN
        DBMS_OUTPUT.PUT_LINE('🕐 ERROR DE NEGOCIO: Fuera del horario de atención');
        DBMS_OUTPUT.PUT_LINE('   Hora actual: ' || v_hora_actual || ':00');
        DBMS_OUTPUT.PUT_LINE('   Horario permitido: 08:00 - 20:00');
        DBMS_OUTPUT.PUT_LINE('💼 ACCIÓN: Programar transacción para mañana o contactar supervisor');
        
    WHEN ex_producto_descontinuado THEN
        DBMS_OUTPUT.PUT_LINE('📦 ERROR DE NEGOCIO: Producto ya no disponible');
        DBMS_OUTPUT.PUT_LINE('   Estado actual: ' || v_producto_estado);
        DBMS_OUTPUT.PUT_LINE('💼 ACCIÓN: Ofrecer producto alternativo o reembolso');
        
    WHEN ex_inventario_insuficiente THEN
        DBMS_OUTPUT.PUT_LINE('📊 ERROR DE NEGOCIO: Stock insuficiente');
        DBMS_OUTPUT.PUT_LINE('   Stock disponible: ' || v_stock_disponible || ' unidades');
        DBMS_OUTPUT.PUT_LINE('   Cantidad solicitada: ' || v_cantidad_pedida || ' unidades');
        DBMS_OUTPUT.PUT_LINE('   Déficit: ' || (v_cantidad_pedida - v_stock_disponible) || ' unidades');
        DBMS_OUTPUT.PUT_LINE('💼 ACCIÓN: Contactar proveedor o ajustar pedido');
        
    WHEN ex_cliente_moroso THEN
        DBMS_OUTPUT.PUT_LINE('💳 ERROR DE NEGOCIO: Cliente con pagos pendientes');
        DBMS_OUTPUT.PUT_LINE('   Días en mora: ' || v_dias_mora);
        DBMS_OUTPUT.PUT_LINE('   Límite permitido: 30 días');
        DBMS_OUTPUT.PUT_LINE('💼 ACCIÓN: Resolver pagos pendientes antes de nueva compra');
        
    WHEN ex_limite_credito_excedido THEN
        DBMS_OUTPUT.PUT_LINE('💰 ERROR DE NEGOCIO: Límite de crédito excedido');
        DBMS_OUTPUT.PUT_LINE('   Límite autorizado: $' || TO_CHAR(v_limite_credito, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('   Monto solicitado: $' || TO_CHAR(v_compra_actual, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('   Exceso: $' || TO_CHAR(v_compra_actual - v_limite_credito, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('💼 ACCIÓN: Solicitar autorización especial o reducir monto');
        v_requiere_autorizacion := TRUE;
        
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ ERROR TÉCNICO INESPERADO: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('🔧 Código de error: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('💼 ACCIÓN: Contactar soporte técnico con este código');
        
    -- El bloque final siempre se ejecuta
    IF NOT v_transaccion_aprobada THEN
        DBMS_OUTPUT.PUT_LINE('📋 ESTADO FINAL: Transacción RECHAZADA');
        IF v_requiere_autorizacion THEN
            DBMS_OUTPUT.PUT_LINE('📞 Escalando a supervisor para autorización manual');
        END IF;
    END IF;
        
END;
/
```

### El Combo Definitivo: Cursores + Excepciones

```sql
-- Procesamiento masivo robusto - El código que nunca falla
DECLARE
    CURSOR c_procesamiento_masivo IS
        SELECT id, nombre, categoria, valor, estado, fecha_registro
        FROM mi_tabla_procesamiento
        WHERE estado IN ('PENDIENTE', 'REVISION')
        ORDER BY fecha_registro ASC;
    
    -- Excepciones del negocio
    ex_valor_fuera_rango EXCEPTION;
    ex_categoria_no_valida EXCEPTION;
    ex_registro_muy_antiguo EXCEPTION;
    
    -- Contadores y estadísticas
    v_total_procesados NUMBER := 0;
    v_exitosos NUMBER := 0;
    v_errores_negocio NUMBER := 0;
    v_errores_tecnicos NUMBER := 0;
    v_requieren_revision NUMBER := 0;
    
    -- Variables de trabajo
    v_fecha_limite DATE := SYSDATE - 365; -- No procesar registros de más de 1 año
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Procesamiento Masivo Robusto ===');
    DBMS_OUTPUT.PUT_LINE('Iniciado: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    
    FOR registro IN c_procesamiento_masivo LOOP
        BEGIN -- Bloque interno: cada registro se maneja independientemente
            v_total_procesados := v_total_procesados + 1;
            
            DBMS_OUTPUT.PUT_LINE('Procesando #' || v_total_procesados || ': ' || registro.nombre);
            
            -- Validación 1: Antigüedad del registro
            IF registro.fecha_registro < v_fecha_limite THEN
                RAISE ex_registro_muy_antiguo;
            END IF;
            
            -- Validación 2: Rango de valores
            IF registro.valor < 0 OR registro.valor > 999999 THEN
                RAISE ex_valor_fuera_rango;
            END IF;
            
            -- Validación 3: Categorías válidas
            IF registro.categoria NOT IN ('A', 'B', 'C', 'PREMIUM', 'ESPECIAL') THEN
                RAISE ex_categoria_no_valida;
            END IF;
            
            -- Procesamiento exitoso - aquí van las operaciones reales
            DBMS_OUTPUT.PUT_LINE('  ✅ Validaciones OK - Procesando...');
            
            -- Simular diferentes tipos de procesamiento según categoría
            CASE registro.categoria
                WHEN 'PREMIUM' THEN
                    DBMS_OUTPUT.PUT_LINE('  🌟 Procesamiento VIP aplicado');
                WHEN 'ESPECIAL' THEN
                    DBMS_OUTPUT.PUT_LINE('  ⭐ Procesamiento especial aplicado');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  📝 Procesamiento estándar aplicado');
            END CASE;
            
            -- Aquí irían tus UPDATEs reales
            -- UPDATE mi_tabla_procesamiento SET estado = 'PROCESADO' WHERE id = registro.id;
            
            v_exitosos := v_exitosos + 1;
            
        EXCEPTION
            WHEN ex_registro_muy_antiguo THEN
                DBMS_OUTPUT.PUT_LINE('  ⏰ ERROR: Registro demasiado antiguo');
                DBMS_OUTPUT.PUT_LINE('    Fecha: ' || TO_CHAR(registro.fecha_registro, 'DD/MM/YYYY'));
                DBMS_OUTPUT.PUT_LINE('    Acción: Marcar para archivo histórico');
                v_errores_negocio := v_errores_negocio + 1;
                
            WHEN ex_valor_fuera_rango THEN
                DBMS_OUTPUT.PUT_LINE('  📊 ERROR: Valor fuera de rango permitido');
                DBMS_OUTPUT.PUT_LINE('    Valor actual: ' || registro.valor);
                DBMS_OUTPUT.PUT_LINE('    Rango válido: 0 - 999,999');
                DBMS_OUTPUT.PUT_LINE('    Acción: Enviar a revisión manual');
                v_requieren_revision := v_requieren_revision + 1;
                
            WHEN ex_categoria_no_valida THEN
                DBMS_OUTPUT.PUT_LINE('  📂 ERROR: Categoría no válida');
                DBMS_OUTPUT.PUT_LINE('    Categoría actual: ''' || registro.categoria || '''');
                DBMS_OUTPUT.PUT_LINE('    Categorías válidas: A, B, C, PREMIUM, ESPECIAL');
                DBMS_OUTPUT.PUT_LINE('    Acción: Asignar categoría por defecto');
                v_errores_negocio := v_errores_negocio + 1;
                
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ⚠️ ERROR TÉCNICO: ' || SQLERRM);
                DBMS_OUTPUT.PUT_LINE('    ID registro: ' || registro.id);
                DBMS_OUTPUT.PUT_LINE('    Acción: Escalado a soporte técnico');
                v_errores_tecnicos := v_errores_tecnicos + 1;
        END;
        
        -- Separador visual entre registros
        IF MOD(v_total_procesados, 10) = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  --- Checkpoint: ' || v_total_procesados || ' registros procesados ---');
        END IF;
        
    END LOOP;
    
    -- Reporte final súper detallado
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== REPORTE FINAL DE PROCESAMIENTO ===');
    DBMS_OUTPUT.PUT_LINE('Finalizado: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('📊 ESTADÍSTICAS:');
    DBMS_OUTPUT.PUT_LINE('  Total procesados: ' || v_total_procesados);
    DBMS_OUTPUT.PUT_LINE('  ✅ Exitosos: ' || v_exitosos || ' (' || ROUND((v_exitosos/v_total_procesados)*100, 1) || '%)');
    DBMS_OUTPUT.PUT_LINE('  ⚠️ Errores de negocio: ' || v_errores_negocio);
    DBMS_OUTPUT.PUT_LINE('  🔧 Errores técnicos: ' || v_errores_tecnicos);
    DBMS_OUTPUT.PUT_LINE('  📋 Requieren revisión: ' || v_requieren_revision);
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Análisis de calidad
    IF v_exitosos = v_total_procesados THEN
        DBMS_OUTPUT.PUT_LINE('🎉 EXCELENTE: 100% de éxito en el procesamiento');
    ELSIF (v_exitosos/v_total_procesados) > 0.8 THEN
        DBMS_OUTPUT.PUT_LINE('👍 BUENO: Más del 80% procesado exitosamente');
    ELSIF (v_exitosos/v_total_procesados) > 0.5 THEN
        DBMS_OUTPUT.PUT_LINE('⚠️ REGULAR: Revisar calidad de datos de entrada');
    ELSE
        DBMS_OUTPUT.PUT_LINE('🚨 CRÍTICO: Menos del 50% de éxito - Investigar urgente');
    END IF;
    
    -- Recomendaciones automáticas
    IF v_errores_tecnicos > 0 THEN
        DBMS_OUTPUT.PUT_LINE('💡 RECOMENDACIÓN: Revisar logs técnicos y conexiones');
    END IF;
    
    IF v_requieren_revision > (v_total_procesados * 0.1) THEN
        DBMS_OUTPUT.PUT_LINE('💡 RECOMENDACIÓN: Revisar criterios de validación');
    END IF;
    
END;
/
```

### Preguntas que debes hacerte

**"¿Cómo hago que mi código siga funcionando aunque fallen algunos registros?"**

Esta pregunta vale oro porque demuestra que entiendes el mundo real. Te enseño a usar bloques internos de excepción para que un error en el registro 247 no mate todo el procesamiento de 10,000 registros.

**"¿Puedes diseñar excepciones específicas para los errores típicos de mi industria?"**

Aquí me convierto en consultor de tu negocio. Si es un hospital, hablamos de pacientes duplicados y historiales incompletos. Si es retail, hablamos de inventarios negativos y precios inconsistentes. Súper específico y súper útil.

---

## Parte 3: Integración y Mejores Prácticas (10 minutos)

### El Checklist del Código Profesional

**✅ Manejo de Casos Extremos**
- ¿Qué pasa si la tabla está vacía?
- ¿Qué pasa si tiene 1 millón de registros?
- ¿Qué pasa si los datos tienen caracteres raros?

**✅ Mensajes de Error Útiles**
- No digas solo "Error". Di "Error en cliente ID 1234: límite de crédito excedido por $500"
- Incluye qué hacer para solucionarlo
- Proporciona contexto para debugging

**✅ Logging y Auditoria**
- Registra cuándo empezó y terminó
- Cuenta exitosos, fallidos, y por qué fallaron
- Guarda suficiente info para reproducir problemas

### Plantilla de Código Completo y Robusto

```sql
-- El template que puedes reusar para cualquier proyecto serio
DECLARE
    -- Cursores bien diseñados
    CURSOR c_mi_procesamiento(p_parametro1 VARCHAR2, p_parametro2 DATE) IS
        SELECT * FROM mi_tabla WHERE mi_campo = p_parametro1 AND fecha >= p_parametro2;
    
    -- Excepciones del dominio
    ex_mi_error_negocio EXCEPTION;
    
    -- Variables de control y estadísticas
    v_inicio_proceso TIMESTAMP := SYSTIMESTAMP;
    v_total_procesados NUMBER := 0;
    v_exitosos NUMBER := 0;
    v_errores NUMBER := 0;
    
    -- Función interna para logging consistente
    PROCEDURE log_mensaje(p_tipo VARCHAR2, p_mensaje VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SYSDATE, 'HH24:MI:SS') || '] ' || 
                           p_tipo || ': ' || p_mensaje);
    END;
    
BEGIN
    log_mensaje('INFO', 'Iniciando procesamiento con parámetros específicos');
    
    -- Tu lógica principal aquí
    FOR registro IN c_mi_procesamiento('PARAM1', SYSDATE-30) LOOP
        BEGIN
            v_total_procesados := v_total_procesados + 1;
            
            -- Tus validaciones y procesamiento
            -- ...
            
            v_exitosos := v_exitosos + 1;
            
        EXCEPTION
            WHEN OTHERS THEN
                v_errores := v_errores + 1;
                log_mensaje('ERROR', 'Falla en registro ID ' || registro.id || ': ' || SQLERRM);
        END;
    END LOOP;
    
    -- Reporte final
    log_mensaje('INFO', 'Procesamiento completado');
    log_mensaje('STATS', 'Total: ' || v_total_procesados || 
               ', Exitosos: ' || v_exitosos || 
               ', Errores: ' || v_errores);
    log_mensaje('PERFORMANCE', 'Tiempo total: ' || 
               TO_CHAR(SYSTIMESTAMP - v_inicio_proceso));
               
EXCEPTION
    WHEN OTHERS THEN
        log_mensaje('FATAL', 'Error crítico del sistema: ' || SQLERRM);
        RAISE; -- Re-lanza el error para que no pase desapercibido
END;
/
```

### Cómo Trabajar Conmigo Como un Profesional

**Para Optimización de Performance:**
"Mi cursor procesa 50,000 registros y tarda 20 minutos. ¿Cómo lo optimizo sin perder funcionalidad?" - Te ayudo con BULK COLLECT, índices, y reestructuración de consultas.

**Para Debugging Inteligente:**
"Mi código falla en el registro 1,247 de 10,000 pero no sé por qué" - Te enseño técnicas de logging y debugging que te permitan identificar exactamente qué registro y por qué está fallando.

**Para Casos Edge Complejos:**
"¿Qué pasa si dos cursores intentan procesar el mismo registro simultáneamente?" - Hablamos de locks, transacciones, y cómo hacer código concurrente seguro.

---

## Tu Entrega Final: El Checklist Profesional

### Lo Que DEBE Estar en Tu Código

**🎯 Cursores que Demuestren Dominio:**
- Al menos 2 cursores con parámetros útiles
- Uno que haga análisis/cálculos complejos
- Lógica de negocio real, no solo SELECT e imprimir

**🛡️ Manejo de Excepciones Robusto:**
- Mínimo 4 excepciones predefinidas manejadas apropiadamente
- Al menos 3 excepciones personalizadas específicas de tu negocio
- Mensajes de error que incluyan contexto y soluciones

**📊 Código de Producción:**
- Logging de inicio/fin y estadísticas
- Manejo de casos extremos (tablas vacías, datos raros)
- Comentarios que expliquen el "por qué", no solo el "qué"

### Lo Que Te Hará Destacar

**🚀 Optimización:**
- Cursores que muestren consideración por performance
- Uso eficiente de índices y WHERE clauses
- Bulk operations donde sea apropiado

**🧠 Lógica de Negocio:**
- Validaciones que realmente importan en tu dominio
- Procesamiento que agrega valor, no solo mueve datos
- Decisiones automáticas basadas en análisis

**📈 Monitoreo:**
- Métricas útiles (tiempo, throughput, tasas de error)
- Reportes que un manager podría usar
- Alertas automáticas para casos críticos

