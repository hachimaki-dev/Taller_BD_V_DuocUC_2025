-- Ejemplo básico: RECORD declarado manualmente
declare
-- Definimos un tipo de RECORD personalizado
   type tipo_usuario is record (
         nombre varchar2(100),
         email  varchar2(100),
         saldo  number(
            10,
            2
         ),
         activo boolean
   );
-- Declaramos una variable de ese tipo
   mi_usuario tipo_usuario;
   
begin
-- Asignamos valores a cada campo del RECORD
   mi_usuario.nombre := 'Juan Pérez';
   mi_usuario.email := 'juan@email.com';
   mi_usuario.saldo := 150.75;
   mi_usuario.activo := true;
-- Mostramos los datos
   dbms_output.put_line('=== DATOS DEL USUARIO ===');
   dbms_output.put_line('Nombre: ' || mi_usuario.nombre);
   dbms_output.put_line('Email: ' || mi_usuario.email);
   dbms_output.put_line('Saldo: $' || mi_usuario.saldo);
   dbms_output.put_line('Activo: '
                        || case
      when mi_usuario.activo then
         'Sí'
      else 'No'
   end);
end;
/