/* =====================================================
   5) TRIGGERS (2 ejemplos sencillos)
   ===================================================== */
-- Trigger 1: antes de insertar un usuario
-- Si no se asigna fecha de registro, se completa automáticamente
CREATE OR REPLACE TRIGGER trg_usuarios_bi
BEFORE INSERT ON USUARIOS
FOR EACH ROW
BEGIN
    IF :NEW.fecha_registro IS NULL THEN
        :NEW.fecha_registro := SYSDATE;
    END IF;
END;
/

-- Trigger 2: antes de insertar en OFERTAS
-- Valida que las ofertas de tipo VENTA tengan precio
CREATE OR REPLACE TRIGGER trg_ofertas_bi
BEFORE INSERT ON OFERTAS
FOR EACH ROW
BEGIN
    IF :NEW.tipo_oferta = 'VENTA' AND :NEW.precio IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'Precio requerido para ventas');
    END IF;
END;
/