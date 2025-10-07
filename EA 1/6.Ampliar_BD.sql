SET SERVEROUTPUT ON;

-- Insertar más usuarios (27 adicionales para llegar a 30 total)
INSERT INTO usuarios VALUES (4, 'María Streamer', 'maria@email.com', DATE '2023-01-25', 320.75);
INSERT INTO usuarios VALUES (5, 'Pedro Speedrun', 'pedro@email.com', DATE '2023-02-05', 180.20);
INSERT INTO usuarios VALUES (6, 'Sofia Casual', 'sofia@email.com', DATE '2023-02-12', 95.40);
INSERT INTO usuarios VALUES (7, 'Diego Hardcore', 'diego@email.com', DATE '2023-02-28', 450.00);
INSERT INTO usuarios VALUES (8, 'Laura Indie', 'laura@email.com', DATE '2023-03-05', 125.60);
INSERT INTO usuarios VALUES (9, 'Roberto Retro', 'roberto@email.com', DATE '2023-03-15', 275.30);
INSERT INTO usuarios VALUES (10, 'Carmen Puzzle', 'carmen@email.com', DATE '2023-03-20', 67.80);
INSERT INTO usuarios VALUES (11, 'Alberto Sport', 'alberto@email.com', DATE '2023-04-02', 198.50);
INSERT INTO usuarios VALUES (12, 'Elena Adventure', 'elena@email.com', DATE '2023-04-10', 156.90);
INSERT INTO usuarios VALUES (13, 'Fernando FPS', 'fernando@email.com', DATE '2023-04-18', 389.25);
INSERT INTO usuarios VALUES (14, 'Isabella Sim', 'isabella@email.com', DATE '2023-04-25', 234.15);
INSERT INTO usuarios VALUES (15, 'Gabriel MMO', 'gabriel@email.com', DATE '2023-05-03', 412.80);
INSERT INTO usuarios VALUES (16, 'Natalia RPG', 'natalia@email.com', DATE '2023-05-12', 167.45);
INSERT INTO usuarios VALUES (17, 'Andrés Racing', 'andres@email.com', DATE '2023-05-20', 298.70);
INSERT INTO usuarios VALUES (18, 'Valentina Mobile', 'valentina@email.com', DATE '2023-05-28', 89.35);
INSERT INTO usuarios VALUES (19, 'Sebastián Pro', 'sebastian@email.com', DATE '2023-06-05', 356.90);
INSERT INTO usuarios VALUES (20, 'Camila Cozy', 'camila@email.com', DATE '2023-06-15', 143.25);
INSERT INTO usuarios VALUES (21, 'Mateo Esports', 'mateo@email.com', DATE '2023-06-22', 478.60);
INSERT INTO usuarios VALUES (22, 'Lucía Story', 'lucia@email.com', DATE '2023-07-01', 201.40);
INSERT INTO usuarios VALUES (23, 'Joaquín Survival', 'joaquin@email.com', DATE '2023-07-10', 267.85);
INSERT INTO usuarios VALUES (24, 'Antonella VR', 'antonella@email.com', DATE '2023-07-18', 512.30);
INSERT INTO usuarios VALUES (25, 'Nicolás Arcade', 'nicolas@email.com', DATE '2023-07-25', 134.70);
INSERT INTO usuarios VALUES (26, 'Renata Builder', 'renata@email.com', DATE '2023-08-02', 187.95);
INSERT INTO usuarios VALUES (27, 'Emilio Collector', 'emilio@email.com', DATE '2023-08-12', 345.80);
INSERT INTO usuarios VALUES (28, 'Valeria Explorer', 'valeria@email.com', DATE '2023-08-20', 176.25);
INSERT INTO usuarios VALUES (29, 'Tomás Fighter', 'tomas@email.com', DATE '2023-08-28', 289.15);
INSERT INTO usuarios VALUES (30, 'Olivia Creator', 'olivia@email.com', DATE '2023-09-05', 223.55);

-- Insertar más juegos (26 adicionales para llegar a 30 total)
INSERT INTO juegos VALUES (105, 'Medieval Warriors', 45.99, 'Action', DATE '2023-01-10');
INSERT INTO juegos VALUES (106, 'Farm Paradise', 29.99, 'Simulation', DATE '2023-01-25');
INSERT INTO juegos VALUES (107, 'Neon Shooter', 24.99, 'Shooter', DATE '2023-02-08');
INSERT INTO juegos VALUES (108, 'Ocean Explorer', 34.99, 'Adventure', DATE '2023-02-18');
INSERT INTO juegos VALUES (109, 'Chess Grandmaster', 14.99, 'Puzzle', DATE '2023-02-25');
INSERT INTO juegos VALUES (110, 'Zombie Apocalypse', 39.99, 'Horror', DATE '2023-03-05');
INSERT INTO juegos VALUES (111, 'City Builder Pro', 54.99, 'Strategy', DATE '2023-03-12');
INSERT INTO juegos VALUES (112, 'Football Manager 24', 49.99, 'Sports', DATE '2023-03-20');
INSERT INTO juegos VALUES (113, 'Magic Realms', 59.99, 'RPG', DATE '2023-03-28');
INSERT INTO juegos VALUES (114, 'Drift King', 35.99, 'Racing', DATE '2023-04-05');
INSERT INTO juegos VALUES (115, 'Space Colony', 42.99, 'Simulation', DATE '2023-04-12');
INSERT INTO juegos VALUES (116, 'Ninja Shadow', 27.99, 'Action', DATE '2023-04-20');
INSERT INTO juegos VALUES (117, 'Cooking Master', 19.99, 'Casual', DATE '2023-04-28');
INSERT INTO juegos VALUES (118, 'Battle Royale X', 0.00, 'Shooter', DATE '2023-05-05');
INSERT INTO juegos VALUES (119, 'Detective Stories', 32.99, 'Adventure', DATE '2023-05-15');
INSERT INTO juegos VALUES (120, 'Sudoku Infinity', 9.99, 'Puzzle', DATE '2023-05-22');
INSERT INTO juegos VALUES (121, 'Mech Warrior', 64.99, 'Action', DATE '2023-05-30');
INSERT INTO juegos VALUES (122, 'Animal Crossing Life', 44.99, 'Simulation', DATE '2023-06-08');
INSERT INTO juegos VALUES (123, 'Vampire Hunter', 37.99, 'Horror', DATE '2023-06-18');
INSERT INTO juegos VALUES (124, 'Empire Builder', 52.99, 'Strategy', DATE '2023-06-25');
INSERT INTO juegos VALUES (125, 'Tennis Championship', 29.99, 'Sports', DATE '2023-07-03');
INSERT INTO juegos VALUES (126, 'Dragon Quest Legends', 69.99, 'RPG', DATE '2023-07-12');
INSERT INTO juegos VALUES (127, 'Rally Master', 41.99, 'Racing', DATE '2023-07-20');
INSERT INTO juegos VALUES (128, 'Alien Invasion', 33.99, 'Shooter', DATE '2023-07-28');
INSERT INTO juegos VALUES (129, 'Puzzle Adventure', 22.99, 'Puzzle', DATE '2023-08-05');
INSERT INTO juegos VALUES (130, 'Samurai Honor', 48.99, 'Action', DATE '2023-08-15');

-- Insertar más compras (30+ adicionales)
INSERT INTO compras VALUES (1004, 3, 105, DATE '2023-03-11', 45.99);
INSERT INTO compras VALUES (1005, 4, 106, DATE '2023-01-26', 29.99);
INSERT INTO compras VALUES (1006, 4, 107, DATE '2023-02-09', 24.99);
INSERT INTO compras VALUES (1007, 5, 108, DATE '2023-02-19', 34.99);
INSERT INTO compras VALUES (1008, 6, 109, DATE '2023-02-26', 14.99);
INSERT INTO compras VALUES (1009, 7, 110, DATE '2023-03-06', 39.99);
INSERT INTO compras VALUES (1010, 7, 111, DATE '2023-03-13', 54.99);
INSERT INTO compras VALUES (1011, 8, 112, DATE '2023-03-21', 49.99);
INSERT INTO compras VALUES (1012, 9, 113, DATE '2023-03-29', 59.99);
INSERT INTO compras VALUES (1013, 10, 114, DATE '2023-04-06', 35.99);
INSERT INTO compras VALUES (1014, 11, 115, DATE '2023-04-13', 42.99);
INSERT INTO compras VALUES (1015, 12, 116, DATE '2023-04-21', 27.99);
INSERT INTO compras VALUES (1016, 13, 117, DATE '2023-04-29', 19.99);
INSERT INTO compras VALUES (1017, 14, 118, DATE '2023-05-06', 0.00);
INSERT INTO compras VALUES (1018, 15, 119, DATE '2023-05-16', 32.99);
INSERT INTO compras VALUES (1019, 16, 120, DATE '2023-05-23', 9.99);
INSERT INTO compras VALUES (1020, 17, 121, DATE '2023-05-31', 64.99);
INSERT INTO compras VALUES (1021, 18, 122, DATE '2023-06-09', 44.99);
INSERT INTO compras VALUES (1022, 19, 123, DATE '2023-06-19', 37.99);
INSERT INTO compras VALUES (1023, 20, 124, DATE '2023-06-26', 52.99);
INSERT INTO compras VALUES (1024, 21, 125, DATE '2023-07-04', 29.99);
INSERT INTO compras VALUES (1025, 22, 126, DATE '2023-07-13', 69.99);
INSERT INTO compras VALUES (1026, 23, 127, DATE '2023-07-21', 41.99);
INSERT INTO compras VALUES (1027, 24, 128, DATE '2023-07-29', 33.99);
INSERT INTO compras VALUES (1028, 25, 129, DATE '2023-08-06', 22.99);
INSERT INTO compras VALUES (1029, 26, 130, DATE '2023-08-16', 48.99);
-- Compras múltiples para algunos usuarios activos
INSERT INTO compras VALUES (1030, 1, 105, DATE '2023-03-25', 45.99);
INSERT INTO compras VALUES (1031, 2, 106, DATE '2023-04-15', 29.99);
INSERT INTO compras VALUES (1032, 3, 107, DATE '2023-05-20', 24.99);
INSERT INTO compras VALUES (1033, 7, 113, DATE '2023-06-10', 59.99);
INSERT INTO compras VALUES (1034, 15, 126, DATE '2023-08-22', 69.99);
INSERT INTO compras VALUES (1035, 21, 121, DATE '2023-07-30', 64.99);
INSERT INTO compras VALUES (1036, 4, 118, DATE '2023-05-10', 0.00);
INSERT INTO compras VALUES (1037, 13, 110, DATE '2023-06-05', 39.99);

-- Insertar registros en biblioteca (coherentes con las compras)
INSERT INTO biblioteca VALUES (3, 105, 42, DATE '2023-03-11');
INSERT INTO biblioteca VALUES (4, 106, 127, DATE '2023-01-26');
INSERT INTO biblioteca VALUES (4, 107, 89, DATE '2023-02-09');
INSERT INTO biblioteca VALUES (5, 108, 56, DATE '2023-02-19');
INSERT INTO biblioteca VALUES (6, 109, 23, DATE '2023-02-26');
INSERT INTO biblioteca VALUES (7, 110, 78, DATE '2023-03-06');
INSERT INTO biblioteca VALUES (7, 111, 156, DATE '2023-03-13');
INSERT INTO biblioteca VALUES (8, 112, 67, DATE '2023-03-21');
INSERT INTO biblioteca VALUES (9, 113, 234, DATE '2023-03-29');
INSERT INTO biblioteca VALUES (10, 114, 45, DATE '2023-04-06');
INSERT INTO biblioteca VALUES (11, 115, 189, DATE '2023-04-13');
INSERT INTO biblioteca VALUES (12, 116, 34, DATE '2023-04-21');
INSERT INTO biblioteca VALUES (13, 117, 12, DATE '2023-04-29');
INSERT INTO biblioteca VALUES (14, 118, 298, DATE '2023-05-06');
INSERT INTO biblioteca VALUES (15, 119, 87, DATE '2023-05-16');
INSERT INTO biblioteca VALUES (16, 120, 145, DATE '2023-05-23');
INSERT INTO biblioteca VALUES (17, 121, 267, DATE '2023-05-31');
INSERT INTO biblioteca VALUES (18, 122, 178, DATE '2023-06-09');
INSERT INTO biblioteca VALUES (19, 123, 95, DATE '2023-06-19');
INSERT INTO biblioteca VALUES (20, 124, 312, DATE '2023-06-26');
INSERT INTO biblioteca VALUES (21, 125, 76, DATE '2023-07-04');
INSERT INTO biblioteca VALUES (22, 126, 445, DATE '2023-07-13');
INSERT INTO biblioteca VALUES (23, 127, 123, DATE '2023-07-21');
INSERT INTO biblioteca VALUES (24, 128, 67, DATE '2023-07-29');
INSERT INTO biblioteca VALUES (25, 129, 38, DATE '2023-08-06');
INSERT INTO biblioteca VALUES (26, 130, 156, DATE '2023-08-16');
-- Biblioteca para compras múltiples
INSERT INTO biblioteca VALUES (1, 105, 89, DATE '2023-03-25');
INSERT INTO biblioteca VALUES (2, 106, 45, DATE '2023-04-15');
INSERT INTO biblioteca VALUES (3, 107, 67, DATE '2023-05-20');
INSERT INTO biblioteca VALUES (7, 113, 189, DATE '2023-06-10');
INSERT INTO biblioteca VALUES (15, 126, 234, DATE '2023-08-22');
INSERT INTO biblioteca VALUES (21, 121, 145, DATE '2023-07-30');
INSERT INTO biblioteca VALUES (4, 118, 267, DATE '2023-05-10');
INSERT INTO biblioteca VALUES (13, 110, 78, DATE '2023-06-05');

COMMIT;

-- Mostrar estadísticas de los datos insertados
DECLARE
    v_count NUMBER;
    v_usuario_nombre VARCHAR2(50);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ESTADÍSTICAS DE LA BASE DE DATOS ===');
    
    SELECT COUNT(*) INTO v_count FROM usuarios;
    DBMS_OUTPUT.PUT_LINE('Usuarios totales: ' || v_count);
    
    SELECT COUNT(*) INTO v_count FROM juegos;
    DBMS_OUTPUT.PUT_LINE('Juegos totales: ' || v_count);
    
    SELECT COUNT(*) INTO v_count FROM compras;
    DBMS_OUTPUT.PUT_LINE('Compras totales: ' || v_count);
    
    SELECT COUNT(*) INTO v_count FROM biblioteca;
    DBMS_OUTPUT.PUT_LINE('Registros en biblioteca: ' || v_count);
    
    SELECT COUNT(*) INTO v_count FROM juegos WHERE precio = 0;
    DBMS_OUTPUT.PUT_LINE('Juegos gratuitos: ' || v_count);
    
    -- Usuario con más juegos
    SELECT nombre INTO v_usuario_nombre
    FROM usuarios 
    WHERE id_usuario = (
        SELECT id_usuario 
        FROM (
            SELECT id_usuario, COUNT(*) as total_juegos
            FROM biblioteca 
            GROUP BY id_usuario 
            ORDER BY COUNT(*) DESC
        ) 
        WHERE ROWNUM = 1
    );
    DBMS_OUTPUT.PUT_LINE('Usuario con más juegos: ' || v_usuario_nombre);
    
    DBMS_OUTPUT.PUT_LINE('=== FIN ESTADÍSTICAS ===');
END;
/