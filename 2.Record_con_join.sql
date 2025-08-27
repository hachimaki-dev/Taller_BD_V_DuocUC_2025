-- Ejemplo avanzado: RECORD desde JOIN de múltiples tablas
declare
-- Definimos un tipo de RECORD personalizado para el resultado del JOIN
   type tipo_compra_detalle is record (
         nombre_usuario varchar2(100),
         email_usuario  varchar2(100),
         nombre_juego   varchar2(200),
         precio_juego   number(
            10,
            2
         ),
         precio_pagado  number(
            10,
            2
         ),
         fecha_compra   date,
         ahorro         number(
            10,
            2
         )
   );
-- Variable de nuestro tipo personalizado
   compra_detalle   tipo_compra_detalle;
-- ID de compra a consultar
   id_compra_buscar number := 1;
begin
-- Consulta con JOIN para obtener información completa
   select u.nombre,
          u.email,
          j.nombre,
          j.precio,
          c.precio_pagado,
          c.fecha_compra,
          ( j.precio - c.precio_pagado ) as ahorro
     into
      compra_detalle.nombre_usuario,
      compra_detalle.email_usuario,
      compra_detalle.nombre_juego,
      compra_detalle.precio_juego,
      compra_detalle.precio_pagado,
      compra_detalle.fecha_compra,
      compra_detalle.ahorro
     from compras c
     join usuarios u
   on c.id_usuario = u.id_usuario
     join juegos j
   on c.id_juego = j.id_juego
    where c.id_compra = id_compra_buscar;
-- Mostramos el recibo de compra detallado
   dbms_output.put_line('==========================================');
   dbms_output.put_line(' RECIBO DE COMPRA');
   dbms_output.put_line('==========================================');
   dbms_output.put_line('Cliente: ' || compra_detalle.nombre_usuario);
   dbms_output.put_line('Email: ' || compra_detalle.email_usuario);
   dbms_output.put_line('Juego: ' || compra_detalle.nombre_juego);
   dbms_output.put_line('Precio original: $' || compra_detalle.precio_juego);
   dbms_output.put_line('Precio pagado: $' || compra_detalle.precio_pagado);
   dbms_output.put_line('Fecha: '
                        || to_char(
      compra_detalle.fecha_compra,
      'DD/MM/YYYY
HH24:MI'
   ));
-- Mostramos si hubo descuento
   if compra_detalle.ahorro > 0 then
      dbms_output.put_line('Ahorro obtenido: $' || compra_detalle.ahorro);
      dbms_output.put_line('¡Felicidades por tu descuento!');
   elsif compra_detalle.ahorro = 0 then
      dbms_output.put_line('Compra realizada a precio completo');
   else
      dbms_output.put_line('Precio especial pagado');
   end if;
   dbms_output.put_line('==========================================');
exception
   when no_data_found then
      dbms_output.put_line('ERROR: No se encontró la compra con ID ' || id_compra_buscar);
   when others then
      dbms_output.put_line('ERROR: ' || sqlerrm);
end;
/