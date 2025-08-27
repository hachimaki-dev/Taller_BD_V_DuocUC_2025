DECLARE
    v_uno VARCHAR2(59):= 'Hola'; --Varchar2 es un tipo de dato mas inteligente, utiliza los espacios que vaya a tener el dato (ej -> si el nombre es de 4 caracteres, varchar2 utilizara solo los 4 no la totalidad)
    v_saldo USUARIOS.saldo%TYPE;
    v_id_usuario NUMBER(6):= 2;
BEGIN
    SELECT saldo INTO v_saldo FROM USUARIOS where ID_USUARIO = v_id_usuario;
    DBMS_OUTPUT.PUT_LINE('El saldo del usuario ' || v_id_usuario || ' es ' || v_saldo || ' :v .');
END;
/

