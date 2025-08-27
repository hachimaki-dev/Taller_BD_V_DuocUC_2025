-- Ejemplo intermedio: RECORD basado en tabla con %ROWTYPE
declare
-- Esta línea crea automáticamente un RECORD con todos los campos de la tabla usuarios
   usuario_rec usuarios%rowtype;
begin
-- Simulamos cargar datos de un usuario específico (ID = 1)
-- En un caso real, esto vendría de un SELECT INTO
   select id_usuario,
          nombre,
          email,
          fecha_registro,
          saldo
     into
      usuario_rec.id_usuario,
      usuario_rec.nombre,
      usuario_rec.email,
      usuario_rec.fecha_registro,
      usuario_rec.saldo
     from usuarios
    where id_usuario = 1;
-- Mostramos los datos obtenidos
   dbms_output.put_line('=== USUARIO CARGADO DESDE BD ===');
   dbms_output.put_line('ID: ' || usuario_rec.id_usuario);
   dbms_output.put_line('Nombre: ' || usuario_rec.nombre);
   dbms_output.put_line('Email: ' || usuario_rec.email);
   dbms_output.put_line('Registro: '
                        || to_char(
      usuario_rec.fecha_registro,
      'YYYY/MM/DD'
   ));
   dbms_output.put_line('Saldo: $' || usuario_rec.saldo);
exception
   when no_data_found then
      dbms_output.put_line('No se encontró el usuario con ID = 1');
   when others then
      dbms_output.put_line('Error: ' || sqlerrm);
end;
/