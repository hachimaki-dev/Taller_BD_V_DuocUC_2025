CREATE TABLE MANGA(
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50)
);

CREATE TABLE AUDITORIA_MANGA(
    id NUMBER PRIMARY KEY,
    id_manga NUMBER,
    tipo_auditoria VARCHAR2(20),
    fecha DATE,
    usuario VARCHAR2(50),
    FOREIGN KEY (id_manga) REFERENCES MANGA(id)
);

CREATE OR REPLACE TRIGGER trg_auditoria_manga
    after INSERT on MANGA
    FOR EACH ROW
        BEGIN
            INSERT INTO AUDITORIA_MANGA(id, id_manga, tipo_auditoria, fecha, usuario)
            VALUES (1, :NEW.id, 'INSERT', SYSDATE, USER);
        END;
        /

INSERT INTO MANGA(id, nombre) VALUES(1, 'SLAM DUNK');

commit;

SELECT * from AUDITORIA_MANGA;
 