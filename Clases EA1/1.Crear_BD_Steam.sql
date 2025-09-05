
SET SERVEROUTPUT ON;
-- Crear tablas del mini STEAM
CREATE TABLE usuarios (
id_usuario NUMBER PRIMARY KEY,
nombre VARCHAR2(50),
email VARCHAR2(100),
fecha_registro DATE,
saldo NUMBER(10,2)
);
CREATE TABLE juegos (
id_juego NUMBER PRIMARY KEY,
nombre VARCHAR2(100),
precio NUMBER(8,2),
categoria VARCHAR2(30),
fecha_lanzamiento DATE
);
CREATE TABLE compras (
id_compra NUMBER PRIMARY KEY,
id_usuario NUMBER,
id_juego NUMBER,
fecha_compra DATE,
precio_pagado NUMBER(8,2),
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego)
);
CREATE TABLE biblioteca (
id_usuario NUMBER,
id_juego NUMBER,
horas_jugadas NUMBER DEFAULT 0,
fecha_agregado DATE,
PRIMARY KEY (id_usuario, id_juego),
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
FOREIGN KEY (id_juego) REFERENCES juegos(id_juego)
);
-- Datos de ejemplo
INSERT INTO usuarios VALUES (1, 'Juan Gamer', 'juan@email.com', DATE '2023-01-15',
150.00);
INSERT INTO usuarios VALUES (2, 'Ana Player', 'ana@email.com', DATE '2023-02-20',
75.50);
INSERT INTO usuarios VALUES (3, 'Carlos Pro', 'carlos@email.com', DATE '2023-03-10',
200.00);
INSERT INTO juegos VALUES (101, 'Cyber Quest 2077', 59.99, 'RPG', DATE '2023-01-01');
INSERT INTO juegos VALUES (102, 'Racing Legends', 39.99, 'Racing', DATE '2023-02-15');
INSERT INTO juegos VALUES (103, 'Space Strategy', 49.99, 'Strategy', DATE '2023-03-
01');
INSERT INTO juegos VALUES (104, 'Puzzle Master', 19.99, 'Puzzle', DATE '2023-01-20');
INSERT INTO compras VALUES (1001, 1, 101, DATE '2023-01-16', 59.99);
INSERT INTO compras VALUES (1002, 1, 104, DATE '2023-01-17', 19.99);
INSERT INTO compras VALUES (1003, 2, 102, DATE '2023-02-21', 39.99);
INSERT INTO biblioteca VALUES (1, 101, 25, DATE '2023-01-16');
INSERT INTO biblioteca VALUES (1, 104, 8, DATE '2023-01-17');
INSERT INTO biblioteca VALUES (2, 102, 15, DATE '2023-02-21');
COMMIT;