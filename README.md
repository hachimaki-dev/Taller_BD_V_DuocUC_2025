#Proyecto PL/SQL - Gestión de Colecciones de Autos HotWheels

**Descripción**
Este proyecto muestra el uso de PL/SQL para manejar usuarios, colecciones de autos, ofertas de venta/trueque y tiendas favoritas. Incluye ejemplos de:

-Tipos compuestos (RECORD, VARRAY)
-Cursores explícitos
-Excepciones predefinidas y personalizadas
-Paquetes con funciones y procedimientos
-Triggers

**Objetivo**

Automatizar la gestión de colecciones y transacciones entre usuarios, mostrando cómo PL/SQL permite manejar datos de forma segura y eficiente.

**Estructura de la Base de Datos**

-USUARIOS: información de usuarios
-TIENDAS: información de tiendas
-COLECCION_USUARIOS: modelos de autos de cada usuario
-OFERTAS: ofertas de venta o trueque
-MODELOS_AUTOS, CATEGORIAS, MODELOS_CATEGORIAS: catálogo de autos y categorías
-TIENDAS_FAVORITAS: tiendas favoritas de cada usuario

**Pruebas (sin ejecutar)**
*Funciones y procedimientos*
-- Crear oferta de venta
EXEC pkg_inicial.pr_crear_oferta(1, 'VENTA', 100);

-- Crear oferta de trueque
EXEC pkg_inicial.pr_crear_oferta(2, 'TRUEQUE', NULL);

-- Validar si usuario tiene auto
SELECT pkg_inicial.fn_tiene_auto(1, 2) FROM DUAL;

-- Contar ofertas activas
SELECT pkg_inicial.fn_contar_ofertas('VENTA') FROM DUAL;

*triggers*

-- Insertar usuario de prueba
INSERT INTO USUARIOS (ID_USUARIO, NOMBRE_USUARIO, EMAIL, PASSWORD_HASH, CIUDAD, PAIS, FECHA_REGISTRO)
VALUES (99, 'PRUEBA_USUARIO', 'prueba@email.com', 'hash999', 'MADRID', 'ESPANA', SYSDATE);




