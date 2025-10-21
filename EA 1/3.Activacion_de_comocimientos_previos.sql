DECLARE
    v_uno VARCHAR2(59) := 'Hola';
    v_saldo USUARIOS.saldo%TYPE; 
    v_id_usuario NUMBER(6) := 1;
BEGIN
    SELECT saldo INTO v_saldo FROM USUARIOS WHERE ID_USUARIO = v_id_usuario;

    DBMS_OUTPUT.PUT_LINE('El saldo del usuario es: '|| v_id_usuario || ' ' || v_saldo || ' c;.');
END;
/
