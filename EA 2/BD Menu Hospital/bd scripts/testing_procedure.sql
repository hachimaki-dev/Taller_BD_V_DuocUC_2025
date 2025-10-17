--Tabla para testear priocedimientos
CREATE TABLE PRODUCTOS(
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    precio NUMBER(8)
);

-- Inserts de productos de supermercado (Líder / Walmart)
INSERT INTO PRODUCTOS VALUES (1, 'Leche Entera Soprole 1L', 1290);
INSERT INTO PRODUCTOS VALUES (2, 'Pan de Molde Ideal Blanco 700g', 1990);
INSERT INTO PRODUCTOS VALUES (3, 'Arroz Tucapel Grano Largo 1kg', 1690);
INSERT INTO PRODUCTOS VALUES (4, 'Aceite Maravilla Chef 1L', 2890);
INSERT INTO PRODUCTOS VALUES (5, 'Azúcar Iansa 1kg', 1390);
INSERT INTO PRODUCTOS VALUES (6, 'Harina Selecta sin Polvos 1kg', 1590);
INSERT INTO PRODUCTOS VALUES (7, 'Café Nescafé Tradición 170g', 5990);
INSERT INTO PRODUCTOS VALUES (8, 'Té Supremo 100 bolsas', 2990);
INSERT INTO PRODUCTOS VALUES (9, 'Mantequilla Soprole 250g', 3290);
INSERT INTO PRODUCTOS VALUES (10, 'Yoghurt Batido Colún 125g', 490);
INSERT INTO PRODUCTOS VALUES (11, 'Queso Gauda Colún 1kg', 10990);
INSERT INTO PRODUCTOS VALUES (12, 'Atún Lomitos San José 170g', 2490);
INSERT INTO PRODUCTOS VALUES (13, 'Papel Higiénico Elite 18x30m', 8990);
INSERT INTO PRODUCTOS VALUES (14, 'Detergente Ariel 3L', 9490);
INSERT INTO PRODUCTOS VALUES (15, 'Lavaloza Quix Limón 750ml', 2590);
INSERT INTO PRODUCTOS VALUES (16, 'Shampoo Pantene Hidratación 400ml', 5690);
INSERT INTO PRODUCTOS VALUES (17, 'Desodorante Dove Spray 150ml', 4290);
INSERT INTO PRODUCTOS VALUES (18, 'Cepillo de Dientes Colgate', 1990);
INSERT INTO PRODUCTOS VALUES (19, 'Pasta Dental Colgate Triple Acción 90g', 2590);
INSERT INTO PRODUCTOS VALUES (20, 'Galletas Tritón 126g', 1290);
INSERT INTO PRODUCTOS VALUES (21, 'Cereal Chocapic Nestlé 500g', 4790);
INSERT INTO PRODUCTOS VALUES (22, 'Mermelada Watts Frutilla 500g', 2890);
INSERT INTO PRODUCTOS VALUES (23, 'Jugo Watts Durazno 1L', 1690);
INSERT INTO PRODUCTOS VALUES (24, 'Coca-Cola Original 1.5L', 2190);
INSERT INTO PRODUCTOS VALUES (25, 'Agua Mineral Benedictino 1.6L', 1290);
INSERT INTO PRODUCTOS VALUES (26, 'Cerveza Cristal 1L', 1990);
INSERT INTO PRODUCTOS VALUES (27, 'Vino Gato Negro Cabernet 750ml', 4490);
INSERT INTO PRODUCTOS VALUES (28, 'Papas Fritas Lays Clásicas 145g', 2890);
INSERT INTO PRODUCTOS VALUES (29, 'Helado Savory 1L Vainilla', 4990);
INSERT INTO PRODUCTOS VALUES (30, 'Huevos de Gallina 12u', 3890);

COMMIT;