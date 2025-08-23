DECLARE
v_nombre usuarios.nombre%TYPE;
v_saldo usuarios.saldo%TYPE;

BEGIN
    SELECT nombre, saldo
    INTO v_nombre, v_saldo
    FROM usuarios
    WHERE id_usuario=1;

    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Saldo: ' || v_saldo);

END;
/

DECLARE
v_nombre usuarios.nombre%TYPE;
v_saldo usuarios.saldo%TYPE;
v_email usuarios.email%TYPE;
v_fecha_registro usuarios.fecha_registro%TYPE;


BEGIN
    SELECT nombre, saldo, email, fecha_registro
    INTO v_nombre, v_saldo, v_email,v_fecha_registro
    FROM usuarios
    WHERE id_usuario=2;

    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Saldo: ' || v_saldo);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Fecha registro: ' || v_fecha_registro);

END;
/

