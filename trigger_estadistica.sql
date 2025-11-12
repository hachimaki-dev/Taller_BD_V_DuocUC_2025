CREATE OR REPLACE TRIGGER trg_historial_resumenes_bi
BEFORE INSERT ON HISTORIAL_RESUMENES
FOR EACH ROW
BEGIN
    IF :NEW.fecha_generacion IS NULL THEN
        :NEW.fecha_generacion := SYSDATE;
    END IF;
END;
/
