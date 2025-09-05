# Guía Completa de VARRAY en PL/SQL 

## Índice
1. [¿Qué es un VARRAY?](#que-es-un-varray)
2. [Conceptos Básicos](#conceptos-basicos)
3. [Sintaxis y Declaración](#sintaxis-y-declaracion)
4. [Checkpoints de Validación](#checkpoints-de-validacion)
5. [Operaciones Básicas](#operaciones-basicas)
6. [Tabla Completa de Métodos VARRAY](#tabla-completa-metodos)
7. [Errores Comunes y Soluciones](#errores-comunes)
8. [Cursores - Recordatorio Necesario](#cursores-recordatorio)
9. [Comparación con Otros Lenguajes](#comparacion-con-otros-lenguajes)
10. [Plantillas Copia-Modifica-Ejecuta](#plantillas-codigo)
11. [Referencias Visuales](#referencias-visuales)
12. [Ejemplos Prácticos con BD STEAM](#ejemplos-practicos)
13. [Casos de Uso Avanzados](#casos-de-uso-avanzados)
14. [Ejercicios Progresivos con Feedback](#ejercicios-progresivos)
15. [Manual de Referencia Rápida](#manual-de-referencia)

---

## ¿Qué es un VARRAY?

Un **VARRAY** (Variable-Size Array) es un tipo de colección en Oracle PL/SQL que permite almacenar múltiples valores del mismo tipo de datos en una sola variable. Es similar a un array o lista en otros lenguajes de programación, pero con ciertas características específicas de Oracle.

### Características principales:
- **Tamaño máximo fijo**: Se define un límite máximo de elementos
- **Tamaño actual variable**: Puede contener desde 0 hasta el máximo definido
- **Elementos del mismo tipo**: Todos los elementos deben ser del mismo tipo de dato
- **Indexación secuencial**: Los elementos se acceden por índice numérico (1, 2, 3...)
- **Almacenamiento contiguo**: Los elementos se almacenan en posiciones consecutivas

---

## Conceptos Básicos

### Diferencia entre otros tipos de colecciones Oracle:

1. **VARRAY**: Tamaño máximo fijo, elementos contiguos
2. **NESTED TABLE**: Sin límite de tamaño, elementos pueden tener "huecos"
3. **ASSOCIATIVE ARRAY (TABLE)**: Índices pueden ser números o strings

### Cuándo usar VARRAY:
- Cuando conoces el número máximo de elementos
- Para listas pequeñas a medianas
- Cuando necesitas mantener el orden de inserción
- Para procesar datos relacionados en conjunto

---

## Sintaxis y Declaración

### 1. Declaración de tipo VARRAY:

```sql
-- Sintaxis básica
TYPE nombre_tipo IS VARRAY(tamaño_maximo) OF tipo_dato;

-- Ejemplos
TYPE lista_precios IS VARRAY(10) OF NUMBER(8,2);
TYPE lista_nombres IS VARRAY(5) OF VARCHAR2(50);
TYPE lista_fechas IS VARRAY(100) OF DATE;
```

### 2. Declaración de variable VARRAY:

```sql
DECLARE
    TYPE lista_ids IS VARRAY(10) OF NUMBER;
    mis_ids lista_ids;
BEGIN
    -- La variable está declarada pero no inicializada (es NULL)
    NULL;
END;
```

### 3. Inicialización de VARRAY:

```sql
DECLARE
    TYPE lista_numeros IS VARRAY(5) OF NUMBER;
    mis_numeros lista_numeros;
BEGIN
    -- Inicialización vacía
    mis_numeros := lista_numeros();
    
    -- Inicialización con valores
    mis_numeros := lista_numeros(1, 2, 3, 4, 5);
    
    -- Inicialización parcial
    mis_numeros := lista_numeros(10, 20);
END;
```

---

## Operaciones Básicas

### 1. Métodos principales de VARRAY:

```sql
DECLARE
    TYPE lista_numeros IS VARRAY(5) OF NUMBER;
    mis_numeros lista_numeros := lista_numeros(1, 2, 3);
BEGIN
    -- COUNT: Número actual de elementos
    DBMS_OUTPUT.PUT_LINE('Elementos: ' || mis_numeros.COUNT);
    
    -- LIMIT: Tamaño máximo del VARRAY
    DBMS_OUTPUT.PUT_LINE('Límite máximo: ' || mis_numeros.LIMIT);
    
    -- FIRST: Primer índice (siempre 1)
    DBMS_OUTPUT.PUT_LINE('Primer índice: ' || mis_numeros.FIRST);
    
    -- LAST: Último índice usado
    DBMS_OUTPUT.PUT_LINE('Último índice: ' || mis_numeros.LAST);
    
    -- EXISTS: Verifica si existe un índice
    IF mis_numeros.EXISTS(2) THEN
        DBMS_OUTPUT.PUT_LINE('Índice 2 existe');
    END IF;
END;
```

### 2. Agregar y modificar elementos:

```sql
DECLARE
    TYPE lista_precios IS VARRAY(10) OF NUMBER(8,2);
    precios lista_precios := lista_precios();
BEGIN
    -- EXTEND: Agregar espacio para nuevos elementos
    precios.EXTEND(3);  -- Agrega 3 espacios (valores NULL)
    
    -- Asignar valores
    precios(1) := 59.99;
    precios(2) := 39.99;
    precios(3) := 49.99;
    
    -- EXTEND con valor por defecto
    precios.EXTEND(2, 1);  -- Agrega 2 elementos copiando el valor del índice 1
    
    DBMS_OUTPUT.PUT_LINE('Total elementos: ' || precios.COUNT);
END;
```

### 3. Eliminar elementos:

```sql
DECLARE
    TYPE lista_numeros IS VARRAY(5) OF NUMBER;
    nums lista_numeros := lista_numeros(1, 2, 3, 4, 5);
BEGIN
    -- TRIM: Eliminar elementos del final
    nums.TRIM;      -- Elimina 1 elemento del final
    nums.TRIM(2);   -- Elimina 2 elementos del final
    
    -- DELETE: Elimina todos los elementos (pero mantiene la estructura)
    nums.DELETE;
    
    DBMS_OUTPUT.PUT_LINE('Elementos después de DELETE: ' || NVL(nums.COUNT, 0));
END;
```

---

## Cursores - Recordatorio Necesario

Los cursores son fundamentales para trabajar con VARRAY cuando necesitamos procesar datos de la base de datos:

### Cursor básico:

```sql
DECLARE
    CURSOR c_juegos IS
        SELECT id_juego, nombre, precio
        FROM juegos
        WHERE categoria = 'RPG';
    
    TYPE lista_juegos IS VARRAY(100) OF NUMBER;
    ids_juegos lista_juegos := lista_juegos();
    
    contador NUMBER := 0;
BEGIN
    -- Recorrer cursor y llenar VARRAY
    FOR registro IN c_juegos LOOP
        contador := contador + 1;
        ids_juegos.EXTEND;
        ids_juegos(contador) := registro.id_juego;
        
        DBMS_OUTPUT.PUT_LINE('Juego: ' || registro.nombre || 
                           ' - Precio: ' || registro.precio);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total juegos RPG: ' || ids_juegos.COUNT);
END;
```

### Cursor con parámetros:

```sql
DECLARE
    CURSOR c_juegos_categoria(p_categoria VARCHAR2) IS
        SELECT nombre, precio
        FROM juegos
        WHERE categoria = p_categoria
        ORDER BY precio DESC;
    
    TYPE lista_precios IS VARRAY(50) OF NUMBER(8,2);
    precios_categoria lista_precios;
BEGIN
    precios_categoria := lista_precios();
    
    FOR juego IN c_juegos_categoria('Strategy') LOOP
        precios_categoria.EXTEND;
        precios_categoria(precios_categoria.COUNT) := juego.precio;
    END LOOP;
END;
```

---

## Comparación con Otros Lenguajes

### Python - Lista:
```python
# Python
precios = [59.99, 39.99, 49.99]
precios.append(19.99)
print(f"Total elementos: {len(precios)}")
for precio in precios:
    print(precio)
```

### Java - ArrayList:
```java
// Java
ArrayList<Double> precios = new ArrayList<>();
precios.add(59.99);
precios.add(39.99);
System.out.println("Total: " + precios.size());
```

### PL/SQL - VARRAY:
```sql
-- PL/SQL
DECLARE
    TYPE lista_precios IS VARRAY(10) OF NUMBER(8,2);
    precios lista_precios := lista_precios(59.99, 39.99, 49.99);
BEGIN
    precios.EXTEND;
    precios(4) := 19.99;
    DBMS_OUTPUT.PUT_LINE('Total elementos: ' || precios.COUNT);
    
    FOR i IN 1..precios.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(precios(i));
    END LOOP;
END;
```

### Principales diferencias:
- **PL/SQL VARRAY**: Tamaño máximo fijo, necesita EXTEND para crecer
- **Python List**: Tamaño dinámico ilimitado
- **Java ArrayList**: Tamaño dinámico con capacidad inicial

---

## Ejemplos Prácticos con BD STEAM

### Ejemplo 1: Procesar compras de un usuario

```sql
DECLARE
    TYPE lista_precios IS VARRAY(100) OF NUMBER(8,2);
    TYPE lista_nombres IS VARRAY(100) OF VARCHAR2(100);
    
    precios_usuario lista_precios := lista_precios();
    nombres_juegos lista_nombres := lista_nombres();
    
    CURSOR c_compras_usuario(p_usuario NUMBER) IS
        SELECT c.precio_pagado, j.nombre
        FROM compras c
        JOIN juegos j ON c.id_juego = j.id_juego
        WHERE c.id_usuario = p_usuario
        ORDER BY c.fecha_compra;
    
    total_gastado NUMBER := 0;
BEGIN
    -- Llenar arrays con datos del usuario 1
    FOR compra IN c_compras_usuario(1) LOOP
        precios_usuario.EXTEND;
        nombres_juegos.EXTEND;
        
        precios_usuario(precios_usuario.COUNT) := compra.precio_pagado;
        nombres_juegos(nombres_juegos.COUNT) := compra.nombre;
    END LOOP;
    
    -- Procesar datos del array
    DBMS_OUTPUT.PUT_LINE('=== COMPRAS DEL USUARIO ===');
    FOR i IN 1..precios_usuario.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(nombres_juegos(i) || ': $' || precios_usuario(i));
        total_gastado := total_gastado + precios_usuario(i);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total gastado: $' || total_gastado);
END;
```

### Ejemplo 2: Análisis de categorías populares

```sql
DECLARE
    TYPE lista_categorias IS VARRAY(20) OF VARCHAR2(30);
    TYPE lista_conteos IS VARRAY(20) OF NUMBER;
    
    categorias lista_categorias := lista_categorias();
    conteos lista_conteos := lista_conteos();
    
    CURSOR c_cat_populares IS
        SELECT j.categoria, COUNT(*) as total_compras
        FROM compras c
        JOIN juegos j ON c.id_juego = j.id_juego
        GROUP BY j.categoria
        ORDER BY COUNT(*) DESC;
    
    indice_mayor NUMBER := 1;
    mayor_compras NUMBER := 0;
BEGIN
    -- Llenar arrays con estadísticas
    FOR cat IN c_cat_populares LOOP
        categorias.EXTEND;
        conteos.EXTEND;
        
        categorias(categorias.COUNT) := cat.categoria;
        conteos(conteos.COUNT) := cat.total_compras;
    END LOOP;
    
    -- Encontrar categoría más popular
    FOR i IN 1..conteos.COUNT LOOP
        IF conteos(i) > mayor_compras THEN
            mayor_compras := conteos(i);
            indice_mayor := i;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('=== CATEGORÍAS POR POPULARIDAD ===');
    FOR i IN 1..categorias.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(categorias(i) || ': ' || conteos(i) || ' compras');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Categoría más popular: ' || categorias(indice_mayor));
END;
```

### Ejemplo 3: Reporte de usuarios activos

```sql
DECLARE
    TYPE lista_usuarios IS VARRAY(50) OF VARCHAR2(50);
    TYPE lista_horas IS VARRAY(50) OF NUMBER;
    
    usuarios_activos lista_usuarios := lista_usuarios();
    horas_jugadas lista_horas := lista_horas();
    
    CURSOR c_usuarios_activos IS
        SELECT u.nombre, SUM(b.horas_jugadas) as total_horas
        FROM usuarios u
        JOIN biblioteca b ON u.id_usuario = b.id_usuario
        GROUP BY u.id_usuario, u.nombre
        HAVING SUM(b.horas_jugadas) > 10
        ORDER BY SUM(b.horas_jugadas) DESC;
    
    promedio_horas NUMBER := 0;
BEGIN
    -- Recopilar datos de usuarios activos
    FOR usuario IN c_usuarios_activos LOOP
        usuarios_activos.EXTEND;
        horas_jugadas.EXTEND;
        
        usuarios_activos(usuarios_activos.COUNT) := usuario.nombre;
        horas_jugadas(horas_jugadas.COUNT) := usuario.total_horas;
    END LOOP;
    
    -- Calcular promedio
    IF horas_jugadas.COUNT > 0 THEN
        FOR i IN 1..horas_jugadas.COUNT LOOP
            promedio_horas := promedio_horas + horas_jugadas(i);
        END LOOP;
        promedio_horas := promedio_horas / horas_jugadas.COUNT;
    END IF;
    
    -- Mostrar reporte
    DBMS_OUTPUT.PUT_LINE('=== USUARIOS ACTIVOS (>10 horas) ===');
    FOR i IN 1..usuarios_activos.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(usuarios_activos(i) || ': ' || horas_jugadas(i) || ' horas');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Promedio de horas: ' || ROUND(promedio_horas, 2));
END;
```

---

## Casos de Uso Avanzados

### 1. VARRAY de tipos complejos (Records)

```sql
DECLARE
    TYPE t_juego_info IS RECORD (
        id NUMBER,
        nombre VARCHAR2(100),
        precio NUMBER(8,2),
        categoria VARCHAR2(30)
    );
    
    TYPE lista_juegos_info IS VARRAY(100) OF t_juego_info;
    juegos_info lista_juegos_info := lista_juegos_info();
    
    CURSOR c_todos_juegos IS
        SELECT id_juego, nombre, precio, categoria
        FROM juegos;
BEGIN
    -- Llenar array con records
    FOR juego IN c_todos_juegos LOOP
        juegos_info.EXTEND;
        juegos_info(juegos_info.COUNT).id := juego.id_juego;
        juegos_info(juegos_info.COUNT).nombre := juego.nombre;
        juegos_info(juegos_info.COUNT).precio := juego.precio;
        juegos_info(juegos_info.COUNT).categoria := juego.categoria;
    END LOOP;
    
    -- Procesar información compleja
    FOR i IN 1..juegos_info.COUNT LOOP
        IF juegos_info(i).precio > 50 THEN
            DBMS_OUTPUT.PUT_LINE('PREMIUM: ' || juegos_info(i).nombre || 
                               ' (' || juegos_info(i).categoria || ') - $' || 
                               juegos_info(i).precio);
        END IF;
    END LOOP;
END;
```

### 2. Función que retorna VARRAY

```sql
CREATE OR REPLACE FUNCTION obtener_juegos_categoria(p_categoria VARCHAR2)
RETURN SYS.ODCINUMBERLIST
IS
    TYPE lista_ids IS VARRAY(100) OF NUMBER;
    ids_juegos lista_ids := lista_ids();
    resultado SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
    
    CURSOR c_juegos IS
        SELECT id_juego
        FROM juegos
        WHERE categoria = p_categoria;
BEGIN
    FOR juego IN c_juegos LOOP
        resultado.EXTEND;
        resultado(resultado.COUNT) := juego.id_juego;
    END LOOP;
    
    RETURN resultado;
END;
```

### 3. Procedimiento con VARRAY como parámetro

```sql
CREATE OR REPLACE PROCEDURE procesar_compras_lote(p_ids_juegos SYS.ODCINUMBERLIST)
IS
    total_precio NUMBER := 0;
    nombre_juego VARCHAR2(100);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PROCESANDO LOTE DE JUEGOS ===');
    
    FOR i IN 1..p_ids_juegos.COUNT LOOP
        SELECT nombre, precio INTO nombre_juego, total_precio
        FROM juegos
        WHERE id_juego = p_ids_juegos(i);
        
        DBMS_OUTPUT.PUT_LINE('Procesando: ' || nombre_juego || ' - $' || total_precio);
    END LOOP;
END;
```

---

## Ejercicios Progresivos

### Ejercicios Fáciles (1-3)

#### Ejercicio 1: Lista de precios básica
Crea un VARRAY que almacene los precios de todos los juegos y muestre:
- El precio más alto
- El precio más bajo  
- El precio promedio

```sql
-- Tu solución aquí
DECLARE
    -- Declara tu VARRAY aquí
BEGIN
    -- Implementa la solución
END;
```

#### Ejercicio 2: Nombres de usuarios
Crea un VARRAY con los nombres de todos los usuarios registrados y muestra cada nombre con su posición en el array.

```sql
-- Tu solución aquí
```

#### Ejercicio 3: Fechas de lanzamiento
Almacena todas las fechas de lanzamiento de juegos en un VARRAY y cuenta cuántos juegos se lanzaron en 2023.

```sql
-- Tu solución aquí
```

### Ejercicios Intermedios (4-5)

#### Ejercicio 4: Análisis de compras por usuario
Crea un procedimiento que reciba un ID de usuario y use un VARRAY para:
- Almacenar todos los precios de sus compras
- Calcular el total gastado
- Mostrar el juego más caro que compró

```sql
-- Tu solución aquí
```

#### Ejercicio 5: Top 3 juegos más caros
Usa un VARRAY de records para almacenar información de juegos (nombre, precio, categoría) y muestra los 3 juegos más caros ordenados por precio.

```sql
-- Tu solución aquí
```

### Ejercicio Complejo (6)

#### Ejercicio 6: Sistema de recomendaciones
Desarrolla un sistema que:
1. Use un VARRAY para almacenar las categorías de juegos que ha comprado un usuario
2. Encuentre otros usuarios con gustos similares (que hayan comprado juegos de las mismas categorías)
3. Recomiende juegos que esos usuarios similares hayan comprado pero el usuario actual no
4. Use múltiples VARRAY para manejar toda esta información

```sql
-- Tu solución aquí
-- Pista: Necesitarás múltiples VARRAY y cursores anidados
```

---

## Manual de Referencia Rápida

### Declaración y Inicialización
```sql
-- Declaración de tipo
TYPE nombre_tipo IS VARRAY(tamaño) OF tipo_dato;

-- Variable
variable_name nombre_tipo;

-- Inicialización
variable_name := nombre_tipo();                    -- Vacío
variable_name := nombre_tipo(val1, val2, val3);   -- Con valores
```

### Métodos Principales
| Método | Descripción | Ejemplo |
|--------|-------------|---------|
| `COUNT` | Número actual de elementos | `array.COUNT` |
| `LIMIT` | Tamaño máximo | `array.LIMIT` |
| `FIRST` | Primer índice (siempre 1) | `array.FIRST` |
| `LAST` | Último índice usado | `array.LAST` |
| `EXISTS(n)` | Verifica si existe índice n | `array.EXISTS(5)` |
| `EXTEND` | Agregar elementos | `array.EXTEND(3)` |
| `EXTEND(n,i)` | Agregar n elementos copiando índice i | `array.EXTEND(2,1)` |
| `TRIM` | Eliminar del final | `array.TRIM(2)` |
| `DELETE` | Eliminar todos | `array.DELETE` |

### Operaciones Comunes
```sql
-- Acceso a elementos
valor := mi_array(indice);
mi_array(indice) := nuevo_valor;

-- Recorrer array
FOR i IN 1..mi_array.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(mi_array(i));
END LOOP;

-- Verificar si está inicializado
IF mi_array IS NOT NULL THEN
    -- Procesar array
END IF;

-- Agregar elemento al final
mi_array.EXTEND;
mi_array(mi_array.COUNT) := nuevo_valor;
```

### Límites y Restricciones
- Tamaño máximo: Definido en la declaración del tipo
- Índices: Secuenciales desde 1 hasta COUNT
- Tipos: Todos los elementos deben ser del mismo tipo
- Inicialización: Debe inicializarse antes de usar
- Performance: Mejor para arrays pequeños a medianos

### Manejo de Errores Comunes
```sql
-- Error: Índice fuera de rango
-- Solución: Verificar con EXISTS o COUNT
IF mi_array.EXISTS(indice) THEN
    valor := mi_array(indice);
END IF;

-- Error: Array no inicializado
-- Solución: Siempre inicializar
mi_array := tipo_array();

-- Error: Exceder límite máximo
-- Solución: Verificar antes de EXTEND
IF mi_array.COUNT < mi_array.LIMIT THEN
    mi_array.EXTEND;
END IF;
```

### Comparación Rápida de Colecciones

| Característica | VARRAY | NESTED TABLE | ASSOCIATIVE ARRAY |
|---------------|---------|--------------|-------------------|
| Tamaño máximo | Fijo | Ilimitado | Ilimitado |
| Índices | 1,2,3... | 1,2,3... (con huecos) | Cualquier número/string |
| Almacenamiento BD | Sí | Sí | No |
| Mejor para | Listas pequeñas fijas | Listas variables | Mapas/diccionarios |

---

## Consejos Finales

1. **Siempre inicializa** los VARRAY antes de usarlos
2. **Verifica límites** antes de agregar elementos
3. **Usa EXISTS** para verificar índices válidos
4. **Considera el tamaño máximo** al diseñar tu tipo
5. **Para arrays grandes**, considera NESTED TABLE
6. **Para mapas clave-valor**, usa ASSOCIATIVE ARRAY
7. **Combina con cursores** para procesar datos de BD eficientemente