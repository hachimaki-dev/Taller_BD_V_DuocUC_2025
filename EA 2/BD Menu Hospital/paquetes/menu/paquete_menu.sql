-- ESPECIFICACIÓN: Define QUÉ se puede usar desde afuera
CREATE OR REPLACE PACKAGE pkg_gestion_menu IS
     
    -- Procedimiento: Crear un menú completo con sus platillos
    PROCEDURE crear_menu_completo(
        p_nombre_menu IN  MENUS.nombre%TYPE ,
        p_id_menu     IN NUMBER
    );
 

END pkg_gestion_menu;
/

COMMIT;


CREATE OR REPLACE PACKAGE BODY pkg_gestion_menu IS

    PROCEDURE crear_menu_completo(
        p_nombre_menu IN MENUS.nombre%TYPE,
        p_id_menu IN NUMBER
    ) IS
    BEGIN
        INSERT INTO MENUS(id, nombre)
        VALUES (p_id_menu, p_nombre_menu);

        DBMS_OUTPUT.PUT_LINE('Se creó el menú con id ' || p_id_menu);
        DBMS_OUTPUT.PUT_LINE('y su nombre es ' || p_nombre_menu);
    END crear_menu_completo;

END pkg_gestion_menu;
/
COMMIT;


BEGIN 

    PKG_GESTION_MENU.CREAR_MENU_COMPLETO('Fideos ricos', 1);

END;
/