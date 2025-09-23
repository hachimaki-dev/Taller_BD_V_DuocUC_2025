# PL/SQL
## Aprende Procedimientos y Funciones

---

## Tabla de Contenidos
1. [¿Qué es PL/SQL y por qué aprenderlo?](#qué-es-plsql-y-por-qué-aprenderlo)
2. [Preparando nuestro entorno: La Base de Datos](#preparando-nuestro-entorno-la-base-de-datos)
3. [Primeros pasos: Bloques PL/SQL básicos](#primeros-pasos-bloques-plsql-básicos)
4. [Variables: Guardando información](#variables-guardando-información)
5. [Mi primer procedimiento](#mi-primer-procedimiento)
6. [Mi primera función](#mi-primera-función)
7. [Parámetros: Enviando información](#parámetros-enviando-información)
8. [Trabajando con la base de datos](#trabajando-con-la-base-de-datos)
9. [Casos prácticos paso a paso](#casos-prácticos-paso-a-paso)
10. [Conceptos avanzados](#conceptos-avanzados)

---

## ¿Qué es PL/SQL y por qué aprenderlo?

Imagina que SQL es como saber sumar y restar números, pero PL/SQL es como aprender matemáticas completas: puedes hacer cálculos complejos, tomar decisiones y repetir operaciones.

**SQL te permite**:
```sql
SELECT titulo FROM libros WHERE genero = 'Fantasía';
```

**PL/SQL te permite**:
- Hacer múltiples consultas en secuencia
- Tomar decisiones basadas en los resultados
- Repetir operaciones automáticamente
- Crear "recetas" reutilizables para tareas complejas

### ¿Por qué es útil?
- **Automatización**: En lugar de escribir 10 consultas, escribes una "receta" que las ejecute todas
- **Lógica de negocio**: Puedes implementar reglas como "si un libro se retrasa más de 15 días, calcular multa"
- **Reutilización**: Una vez creada la "receta", cualquiera puede usarla

---

## Preparando nuestro entorno: La Base de Datos

Antes de cocinar, necesitamos ingredientes. Nuestra "cocina" será una base de datos simple de una biblioteca con libros de fantasía, ciencia ficción y otros géneros.

### Nuestras 3 "cajas" de información:

```sql
-- Caja 1: GENEROS (tipos de libros)
CREATE TABLE GENEROS (
    id_genero NUMBER PRIMARY KEY,
    nombre_genero VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(200)
);

-- Caja 2: LIBROS (información de cada libro)
CREATE TABLE LIBROS (
    id_libro NUMBER PRIMARY KEY,
    titulo VARCHAR2(100) NOT NULL,
    autor VARCHAR2(100) NOT NULL,
    id_genero NUMBER NOT NULL,
    año_publicacion NUMBER(4),
    disponible CHAR(1) DEFAULT 'S',
    CONSTRAINT fk_libro_genero FOREIGN KEY (id_genero) REFERENCES GENEROS(id_genero)
);

-- Caja 3: PRESTAMOS (registro de quién tiene qué libro)
CREATE TABLE PRESTAMOS (
    id_prestamo NUMBER PRIMARY KEY,
    id_libro NUMBER NOT NULL,
    nombre_usuario VARCHAR2(100) NOT NULL,
    fecha_prestamo DATE DEFAULT SYSDATE,
    devuelto CHAR(1) DEFAULT 'N',
    CONSTRAINT fk_prestamo_libro FOREIGN KEY (id_libro) REFERENCES LIBROS(id_libro)
);
```

### Llenamos nuestras cajas con información:

```sql
-- Géneros de libros
INSERT INTO GENEROS VALUES (1, 'Fantasía', 'Mundos mágicos y criaturas extraordinarias');
INSERT INTO GENEROS VALUES (2, 'Ciencia Ficción', 'Tecnología y futuros posibles');
INSERT INTO GENEROS VALUES (3, 'Terror', 'Historias que dan miedo');

-- Algunos libros famosos
INSERT INTO LIBROS VALUES (1, 'El Hobbit', 'J.R.R. Tolkien', 1, 1937, 'S');
INSERT INTO LIBROS VALUES (2, 'Dune', 'Frank Herbert', 2, 1965, 'S');
INSERT INTO LIBROS VALUES (3, 'El Resplandor', 'Stephen King', 3, 1977, 'S');
INSERT INTO LIBROS VALUES (4, 'Fundación', 'Isaac Asimov', 2, 1951, 'N');

-- Algunos préstamos
INSERT INTO PRESTAMOS VALUES (1, 4, 'Ana García', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'N');
INSERT INTO PRESTAMOS VALUES (2, 1, 'Carlos López', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'N');
```

---

## Primeros pasos: Bloques PL/SQL básicos

Antes de crear procedimientos, necesitas entender qué es un "bloque PL/SQL". Es como una receta básica.

### El bloque más simple del mundo:

```sql
BEGIN
    DBMS_OUTPUT.PUT_LINE('¡Hola mundo desde PL/SQL!');
END;
```

**¿Qué hace esto?**
- `BEGIN`: "Aquí empieza mi receta"
- `DBMS_OUTPUT.PUT_LINE`: "Muestra este mensaje en pantalla"
- `END;`: "Aquí termina mi receta"

### Ejecutemos nuestro primer bloque:

```sql
-- Primero activamos la salida en pantalla
SET SERVEROUTPUT ON;

-- Ahora ejecutamos nuestro bloque
BEGIN
    DBMS_OUTPUT.PUT_LINE('¡Hola mundo desde PL/SQL!');
    DBMS_OUTPUT.PUT_LINE('Este es mi primer programa');
    DBMS_OUTPUT.PUT_LINE('Ya estoy programando en PL/SQL');
END;
```

**Resultado:**
```
¡Hola mundo desde PL/SQL!
Este es mi primer programa
Ya estoy programando en PL/SQL
```

### ¿Por qué usamos DBMS_OUTPUT.PUT_LINE?
Es la forma que tiene PL/SQL de "hablar" contigo. Como cuando imprimes algo en otros lenguajes de programación.

---

## Variables: Guardando información

Las variables son como "cajitas" donde guardas información temporalmente.

### Mi primera variable:

```sql
DECLARE
    mi_nombre VARCHAR2(50);
BEGIN
    mi_nombre := 'Juan Pérez';
    DBMS_OUTPUT.PUT_LINE('Mi nombre es: ' || mi_nombre);
END;
```

**Explicación paso a paso:**
1. `DECLARE`: "Voy a crear cajitas para guardar cosas"
2. `mi_nombre VARCHAR2(50)`: "Crea una cajita llamada 'mi_nombre' que puede guardar hasta 50 letras"
3. `mi_nombre := 'Juan Pérez'`: "Guarda 'Juan Pérez' en la cajita"
4. `||`: "Pega dos textos juntos"

### Tipos de "cajitas" más comunes:

```sql
DECLARE
    -- Para números enteros
    edad NUMBER := 25;
    
    -- Para texto
    nombre VARCHAR2(100) := 'María González';
    
    -- Para fechas
    fecha_hoy DATE := SYSDATE;
    
    -- Para números con decimales
    precio NUMBER(10,2) := 15.99;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || nombre);
    DBMS_OUTPUT.PUT_LINE('Edad: ' || edad);
    DBMS_OUTPUT.PUT_LINE('Fecha: ' || TO_CHAR(fecha_hoy, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Precio: $' || precio);
END;
```

### ¿Por qué necesitamos especificar el tipo?
Oracle necesita saber qué tipo de información vas a guardar para reservar el espacio correcto en memoria. Es como elegir el tamaño correcto de caja para guardar diferentes objetos.

---

## Mi primer procedimiento

Un procedimiento es como una "receta" que puedes guardar y usar después.

### El procedimiento más simple:

```sql
CREATE OR REPLACE PROCEDURE saludar AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('¡Hola desde mi primer procedimiento!');
    DBMS_OUTPUT.PUT_LINE('Los procedimientos son geniales');
END saludar;
```

**¿Qué significa cada parte?**
- `CREATE OR REPLACE PROCEDURE`: "Crea una receta nueva (o reemplaza una existente)"
- `saludar`: "El nombre de mi receta"
- `AS`: "Aquí empieza la definición de mi receta"
- `BEGIN...END`: "Los pasos de mi receta"

### ¿Cómo uso mi procedimiento?

```sql
-- Forma 1: Llamada simple
BEGIN
    saludar;
END;

-- Forma 2: Llamada directa (en algunos sistemas)
EXECUTE saludar;
```

### Un procedimiento más útil:

```sql
CREATE OR REPLACE PROCEDURE mostrar_estadisticas_simples AS
    cantidad_libros NUMBER;
BEGIN
    -- Contar cuántos libros hay
    SELECT COUNT(*) INTO cantidad_libros FROM LIBROS;
    
    DBMS_OUTPUT.PUT_LINE('=== ESTADÍSTICAS DE LA BIBLIOTECA ===');
    DBMS_OUTPUT.PUT_LINE('Total de libros: ' || cantidad_libros);
    DBMS_OUTPUT.PUT_LINE('===================================');
END mostrar_estadisticas_simples;
```

**Conceptos nuevos:**
- `SELECT COUNT(*) INTO cantidad_libros`: "Cuenta todos los libros y guarda el resultado en mi cajita"
- La variable se declara automáticamente en la sección entre `AS` y `BEGIN`

### Ejecutemos nuestro procedimiento:

```sql
BEGIN
    mostrar_estadisticas_simples;
END;
```

---

## Mi primera función

Una función es similar a un procedimiento, pero **siempre devuelve un resultado**.

### La función más simple:

```sql
CREATE OR REPLACE FUNCTION obtener_saludo 
RETURN VARCHAR2 AS
BEGIN
    RETURN '¡Hola desde mi primera función!';
END obtener_saludo;
```

**Diferencias con el procedimiento:**
- `RETURN VARCHAR2`: "Esta función va a devolver texto"
- `RETURN '...'`: "Devuelve este valor"

### ¿Cómo uso mi función?

```sql
-- Dentro de un bloque PL/SQL
DECLARE
    mensaje VARCHAR2(100);
BEGIN
    mensaje := obtener_saludo;
    DBMS_OUTPUT.PUT_LINE(mensaje);
END;

-- O directamente en una consulta
SELECT obtener_saludo FROM DUAL;
```

### Una función más útil:

```sql
CREATE OR REPLACE FUNCTION contar_libros_disponibles 
RETURN NUMBER AS
    cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO cantidad 
    FROM LIBROS 
    WHERE disponible = 'S';
    
    RETURN cantidad;
END contar_libros_disponibles;
```

### Usando la función:

```sql
-- En una consulta
SELECT 'Libros disponibles: ' || contar_libros_disponibles() as info FROM DUAL;

-- En un bloque PL/SQL
BEGIN
    DBMS_OUTPUT.PUT_LINE('Tenemos ' || contar_libros_disponibles() || ' libros disponibles');
END;
```

### ¿Cuándo usar procedimiento vs función?

- **Procedimiento**: Cuando quieres "hacer algo" (insertar, actualizar, mostrar información)
- **Función**: Cuando quieres "calcular algo" y obtener un resultado

---

## Parámetros: Enviando información

Los parámetros son como "ingredientes" que le pasas a tu receta.

### Función con un parámetro:

```sql
CREATE OR REPLACE FUNCTION saludar_persona(nombre VARCHAR2) 
RETURN VARCHAR2 AS
BEGIN
    RETURN 'Hola ' || nombre || ', ¡bienvenido a la biblioteca!';
END saludar_persona;
```

**¿Cómo funciona?**
- `nombre VARCHAR2`: "Esta función necesita un ingrediente llamado 'nombre' que sea texto"
- El parámetro se usa como cualquier variable dentro de la función

### Usando la función con parámetros:

```sql
SELECT saludar_persona('Carlos') FROM DUAL;
SELECT saludar_persona('María') FROM DUAL;

-- En un bloque
BEGIN
    DBMS_OUTPUT.PUT_LINE(saludar_persona('Ana'));
    DBMS_OUTPUT.PUT_LINE(saludar_persona('Pedro'));
END;
```

### Procedimiento con parámetros:

```sql
CREATE OR REPLACE PROCEDURE mostrar_info_libro(libro_id NUMBER) AS
    titulo_libro VARCHAR2(100);
    autor_libro VARCHAR2(100);
BEGIN
    -- Buscar la información del libro
    SELECT titulo, autor 
    INTO titulo_libro, autor_libro
    FROM LIBROS 
    WHERE id_libro = libro_id;
    
    DBMS_OUTPUT.PUT_LINE('=== INFORMACIÓN DEL LIBRO ===');
    DBMS_OUTPUT.PUT_LINE('ID: ' || libro_id);
    DBMS_OUTPUT.PUT_LINE('Título: ' || titulo_libro);
    DBMS_OUTPUT.PUT_LINE('Autor: ' || autor_libro);
    DBMS_OUTPUT.PUT_LINE('============================');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se encontró un libro con ID ' || libro_id);
END mostrar_info_libro;
```

**Conceptos nuevos:**
- `EXCEPTION`: "Si algo sale mal, haz esto"
- `NO_DATA_FOUND`: "Si no encuentra ningún registro"

### Usando el procedimiento:

```sql
BEGIN
    mostrar_info_libro(1);  -- Mostrará "El Hobbit"
    mostrar_info_libro(2);  -- Mostrará "Dune"
    mostrar_info_libro(99); -- Mostrará error
END;
```

### ¿Qué son IN, OUT y IN OUT?

Hasta ahora hemos usado parámetros "IN" sin darnos cuenta. Hay tres tipos:

#### IN (Entrada) - El más común:
```sql
CREATE OR REPLACE FUNCTION calcular_cuadrado(numero IN NUMBER) 
RETURN NUMBER AS
BEGIN
    RETURN numero * numero;
END calcular_cuadrado;
```
- **IN**: "Este parámetro trae información HACIA la función"
- Es como darle ingredientes a una receta

#### OUT (Salida):
```sql
CREATE OR REPLACE PROCEDURE obtener_info_libro(
    libro_id IN NUMBER,
    titulo OUT VARCHAR2,
    autor OUT VARCHAR2
) AS
BEGIN
    SELECT titulo, autor 
    INTO titulo, autor
    FROM LIBROS 
    WHERE id_libro = libro_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        titulo := 'No encontrado';
        autor := 'No encontrado';
END obtener_info_libro;
```

**¿Cómo usar un parámetro OUT?**
```sql
DECLARE
    mi_titulo VARCHAR2(100);
    mi_autor VARCHAR2(100);
BEGIN
    obtener_info_libro(1, mi_titulo, mi_autor);
    DBMS_OUTPUT.PUT_LINE('Título: ' || mi_titulo);
    DBMS_OUTPUT.PUT_LINE('Autor: ' || mi_autor);
END;
```

- **OUT**: "Este parámetro lleva información DESDE el procedimiento hacia afuera"

#### IN OUT (Entrada y Salida):
```sql
CREATE OR REPLACE PROCEDURE procesar_texto(texto IN OUT VARCHAR2) AS
BEGIN
    texto := UPPER(texto) || ' - PROCESADO';
END procesar_texto;
```

**¿Cómo usar IN OUT?**
```sql
DECLARE
    mi_texto VARCHAR2(100) := 'hola mundo';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Antes: ' || mi_texto);
    procesar_texto(mi_texto);
    DBMS_OUTPUT.PUT_LINE('Después: ' || mi_texto);
END;
```

- **IN OUT**: "Este parámetro trae información Y también lleva información modificada"

---

## Trabajando con la base de datos

Ahora que sabemos lo básico, aprendamos a interactuar con nuestra biblioteca.

### SELECT dentro de funciones y procedimientos:

#### Función para obtener el nombre de un género:
```sql
CREATE OR REPLACE FUNCTION obtener_nombre_genero(genero_id NUMBER) 
RETURN VARCHAR2 AS
    nombre VARCHAR2(50);
BEGIN
    SELECT nombre_genero 
    INTO nombre 
    FROM GENEROS 
    WHERE id_genero = genero_id;
    
    RETURN nombre;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Género no encontrado';
END obtener_nombre_genero;
```

**¿Por qué usamos INTO?**
- En PL/SQL, cuando haces un SELECT, necesitas decirle dónde guardar el resultado
- `INTO nombre`: "Guarda el resultado en la variable 'nombre'"

### INSERT dentro de procedimientos:

```sql
CREATE OR REPLACE PROCEDURE agregar_genero_simple(
    nuevo_id NUMBER,
    nuevo_nombre VARCHAR2
) AS
BEGIN
    INSERT INTO GENEROS (id_genero, nombre_genero) 
    VALUES (nuevo_id, nuevo_nombre);
    
    DBMS_OUTPUT.PUT_LINE('Género "' || nuevo_nombre || '" agregado exitosamente');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se pudo agregar el género');
END agregar_genero_simple;
```

**Probemos nuestro procedimiento:**
```sql
BEGIN
    agregar_genero_simple(4, 'Aventura');
    agregar_genero_simple(5, 'Romance');
END;
```

### UPDATE dentro de procedimientos:

```sql
CREATE OR REPLACE PROCEDURE marcar_libro_no_disponible(libro_id NUMBER) AS
    titulo_libro VARCHAR2(100);
BEGIN
    -- Primero obtener el título para el mensaje
    SELECT titulo INTO titulo_libro 
    FROM LIBROS 
    WHERE id_libro = libro_id;
    
    -- Actualizar disponibilidad
    UPDATE LIBROS 
    SET disponible = 'N' 
    WHERE id_libro = libro_id;
    
    DBMS_OUTPUT.PUT_LINE('El libro "' || titulo_libro || '" ahora está marcado como no disponible');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No existe un libro con ID ' || libro_id);
END marcar_libro_no_disponible;
```

---

## Casos prácticos paso a paso

Ahora aplicemos todo lo aprendido en casos reales de nuestra biblioteca.

### Caso 1: Procedimiento para registrar un préstamo simple

```sql
CREATE OR REPLACE PROCEDURE prestar_libro_simple(
    libro_id NUMBER,
    usuario VARCHAR2
) AS
    titulo_libro VARCHAR2(100);
    esta_disponible CHAR(1);
BEGIN
    -- Verificar si el libro existe y está disponible
    SELECT titulo, disponible 
    INTO titulo_libro, esta_disponible
    FROM LIBROS 
    WHERE id_libro = libro_id;
    
    -- ¿Está disponible?
    IF esta_disponible = 'N' THEN
        DBMS_OUTPUT.PUT_LINE('Error: El libro "' || titulo_libro || '" no está disponible');
        RETURN;  -- Salir del procedimiento
    END IF;
    
    -- Registrar el préstamo (usamos un ID simple)
    INSERT INTO PRESTAMOS (id_prestamo, id_libro, nombre_usuario) 
    VALUES (
        (SELECT NVL(MAX(id_prestamo), 0) + 1 FROM PRESTAMOS),
        libro_id, 
        usuario
    );
    
    -- Marcar libro como no disponible
    UPDATE LIBROS 
    SET disponible = 'N' 
    WHERE id_libro = libro_id;
    
    DBMS_OUTPUT.PUT_LINE('¡Préstamo exitoso!');
    DBMS_OUTPUT.PUT_LINE('Libro: "' || titulo_libro || '"');
    DBMS_OUTPUT.PUT_LINE('Usuario: ' || usuario);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No existe un libro con ID ' || libro_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END prestar_libro_simple;
```

**Conceptos nuevos:**
- `IF...THEN...END IF`: "Si se cumple una condición, haz esto"
- `RETURN`: "Sal del procedimiento inmediatamente"
- `NVL(MAX(id_prestamo), 0) + 1`: "Obtén el siguiente ID secuencial"
- `SQLERRM`: "Mensaje de error del sistema"

**Probemos el procedimiento:**
```sql
BEGIN
    prestar_libro_simple(1, 'Pedro Martínez');
    prestar_libro_simple(2, 'Ana López');
    prestar_libro_simple(1, 'Carlos Ruiz'); -- Este dará error porque ya está prestado
END;
```

### Caso 2: Función para calcular información de préstamos

```sql
CREATE OR REPLACE FUNCTION contar_prestamos_usuario(nombre_usuario VARCHAR2) 
RETURN NUMBER AS
    total_prestamos NUMBER;
BEGIN
    SELECT COUNT(*) 
    INTO total_prestamos
    FROM PRESTAMOS 
    WHERE UPPER(nombre_usuario) = UPPER(nombre_usuario)  -- Comparación sin importar mayúsculas
      AND devuelto = 'N';  -- Solo préstamos activos
    
    RETURN total_prestamos;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;  -- Si hay error, devolver 0
END contar_prestamos_usuario;
```

**Usando la función:**
```sql
-- En una consulta
SELECT 
    'El usuario Pedro Martínez tiene ' || 
    contar_prestamos_usuario('Pedro Martínez') || 
    ' préstamos activos' as info 
FROM DUAL;

-- En un bloque
BEGIN
    IF contar_prestamos_usuario('Pedro Martínez') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pedro tiene préstamos activos');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Pedro no tiene préstamos activos');
    END IF;
END;
```

### Caso 3: Combinando procedimientos y funciones

```sql
CREATE OR REPLACE PROCEDURE reporte_biblioteca_simple AS
    total_libros NUMBER;
    libros_disponibles NUMBER;
    libros_prestados NUMBER;
    total_generos NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== REPORTE SIMPLE DE BIBLIOTECA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Usar nuestras funciones existentes
    total_libros := (SELECT COUNT(*) FROM LIBROS);
    libros_disponibles := contar_libros_disponibles();
    libros_prestados := total_libros - libros_disponibles;
    total_generos := (SELECT COUNT(*) FROM GENEROS);
    
    DBMS_OUTPUT.PUT_LINE('Total de libros: ' || total_libros);
    DBMS_OUTPUT.PUT_LINE('Libros disponibles: ' || libros_disponibles);
    DBMS_OUTPUT.PUT_LINE('Libros prestados: ' || libros_prestados);
    DBMS_OUTPUT.PUT_LINE('Géneros en catálogo: ' || total_generos);
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== FIN DEL REPORTE ===');
END reporte_biblioteca_simple;
```

**Ejecutar el reporte:**
```sql
BEGIN
    reporte_biblioteca_simple;
END;
```

### Caso 4: Consulta combinada con nuestras funciones

```sql
-- Consulta que usa nuestras funciones personalizadas
SELECT 
    l.id_libro,
    l.titulo,
    l.autor,
    obtener_nombre_genero(l.id_genero) as genero,
    CASE l.disponible 
        WHEN 'S' THEN 'Disponible' 
        ELSE 'Prestado' 
    END as estado
FROM LIBROS l
ORDER BY l.titulo;
```

Esta consulta demuestra cómo usar nuestras funciones dentro de SELECT normales, combinando lo mejor de SQL y PL/SQL.

---

## Conceptos avanzados

### Manejo de errores más detallado

```sql
CREATE OR REPLACE PROCEDURE ejemplo_manejo_errores(libro_id NUMBER) AS
    titulo VARCHAR2(100);
BEGIN
    SELECT titulo INTO titulo 
    FROM LIBROS 
    WHERE id_libro = libro_id;
    
    DBMS_OUTPUT.PUT_LINE('Libro encontrado: ' || titulo);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Específico: No se encontró el libro con ID ' || libro_id);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Específico: Se encontraron múltiples libros (error de datos)');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('General: Error inesperado - ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Código de error: ' || SQLCODE);
END ejemplo_manejo_errores;
```

### Cursores para procesar múltiples registros

```sql
CREATE OR REPLACE PROCEDURE listar_libros_por_genero(genero_id NUMBER) AS
    CURSOR c_libros IS
        SELECT titulo, autor, año_publicacion
        FROM LIBROS
        WHERE id_genero = genero_id
        ORDER BY titulo;
        
    nombre_genero VARCHAR2(50);
BEGIN
    -- Obtener nombre del género
    nombre_genero := obtener_nombre_genero(genero_id);
    
    DBMS_OUTPUT.PUT_LINE('=== LIBROS DE ' || UPPER(nombre_genero) || ' ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Procesar cada libro
    FOR libro IN c_libros LOOP
        DBMS_OUTPUT.PUT_LINE('• ' || libro.titulo);
        DBMS_OUTPUT.PUT_LINE('  Autor: ' || libro.autor);
        DBMS_OUTPUT.PUT_LINE('  Año: ' || NVL(TO_CHAR(libro.año_publicacion), 'No especificado'));
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('=== FIN DE LA LISTA ===');
END listar_libros_por_genero;
```

### Parámetros opcionales con valores por defecto

```sql
CREATE OR REPLACE FUNCTION buscar_libros_autor(
    nombre_autor VARCHAR2,
    incluir_no_disponibles BOOLEAN DEFAULT FALSE
) RETURN NUMBER AS
    cantidad NUMBER;
BEGIN
    IF incluir_no_disponibles THEN
        SELECT COUNT(*) INTO cantidad
        FROM LIBROS
        WHERE UPPER(autor) LIKE UPPER('%' || nombre_autor || '%');
    ELSE
        SELECT COUNT(*) INTO cantidad
        FROM LIBROS
        WHERE UPPER(autor) LIKE UPPER('%' || nombre_autor || '%')
          AND disponible = 'S';
    END IF;
    
    RETURN cantidad;
END buscar_libros_autor;
```

**Usando parámetros opcionales:**
```sql
BEGIN
    DBMS_OUTPUT.PUT_LINE('Tolkien disponibles: ' || buscar_libros_autor('Tolkien'));
    DBMS_OUTPUT.PUT_LINE('Tolkien todos: ' || buscar_libros_autor('Tolkien', TRUE));
END;
```

---

## Resumen y buenas prácticas

### Lo que aprendimos:

1. **Bloques básicos**: La estructura fundamental BEGIN-END
2. **Variables**: Cómo declarar y usar "cajitas" para información
3. **Procedimientos**: "Recetas" que hacen tareas
4. **Funciones**: "Calculadoras" que devuelven resultados
5. **Parámetros**: Cómo enviar información a procedimientos y funciones
6. **Interacción con BD**: SELECT INTO, INSERT, UPDATE
7. **Manejo de errores**: Qué hacer cuando algo sale mal
