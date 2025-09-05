-- ========================================
-- EVALUACIÓN BDY1103: BASE DE DATOS CLÍNICA MÉDICA
-- SISTEMA DE GESTIÓN DE CITAS MÉDICAS
-- ========================================

-- Eliminar tablas si existen (orden inverso por FK)
DROP TABLE consultas CASCADE CONSTRAINTS;
DROP TABLE citas CASCADE CONSTRAINTS;
DROP TABLE consultorios CASCADE CONSTRAINTS;
DROP TABLE pacientes CASCADE CONSTRAINTS;
DROP TABLE medicos CASCADE CONSTRAINTS;
DROP TABLE especialidades CASCADE CONSTRAINTS;

-- Eliminar secuencias si existen
DROP SEQUENCE seq_especialidades;
DROP SEQUENCE seq_medicos;
DROP SEQUENCE seq_pacientes;
DROP SEQUENCE seq_consultorios;
DROP SEQUENCE seq_citas;
DROP SEQUENCE seq_consultas;

-- ========================================
-- CREACIÓN DE SECUENCIAS
-- ========================================
CREATE SEQUENCE seq_especialidades START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_medicos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pacientes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_consultorios START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_citas START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_consultas START WITH 1 INCREMENT BY 1;

-- ========================================
-- CREACIÓN DE TABLAS
-- ========================================

-- Tabla ESPECIALIDADES
CREATE TABLE especialidades (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    duracion_consulta NUMBER NOT NULL, -- minutos
    costo_consulta NUMBER(8,2) NOT NULL
);

-- Tabla MEDICOS
CREATE TABLE medicos (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    especialidad_id NUMBER NOT NULL,
    horario_inicio VARCHAR2(5) NOT NULL, -- formato HH:MM
    horario_fin VARCHAR2(5) NOT NULL,
    telefono VARCHAR2(15),
    email VARCHAR2(100),
    activo CHAR(1) DEFAULT 'S' CHECK (activo IN ('S', 'N')),
    CONSTRAINT fk_medico_especialidad FOREIGN KEY (especialidad_id) 
        REFERENCES especialidades(id)
);

-- Tabla PACIENTES
CREATE TABLE pacientes (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15) NOT NULL,
    email VARCHAR2(100),
    fecha_nacimiento DATE NOT NULL,
    direccion VARCHAR2(200),
    activo CHAR(1) DEFAULT 'S' CHECK (activo IN ('S', 'N'))
);

-- Tabla CONSULTORIOS
CREATE TABLE consultorios (
    id NUMBER PRIMARY KEY,
    numero VARCHAR2(10) NOT NULL UNIQUE,
    capacidad NUMBER DEFAULT 2,
    equipamiento VARCHAR2(500),
    activo CHAR(1) DEFAULT 'S' CHECK (activo IN ('S', 'N'))
);

-- Tabla CITAS
CREATE TABLE citas (
    id NUMBER PRIMARY KEY,
    fecha DATE NOT NULL,
    hora VARCHAR2(5) NOT NULL, -- formato HH:MM
    paciente_id NUMBER NOT NULL,
    medico_id NUMBER NOT NULL,
    consultorio_id NUMBER NOT NULL,
    estado VARCHAR2(20) DEFAULT 'AGENDADA' 
        CHECK (estado IN ('AGENDADA', 'CONFIRMADA', 'EN_CURSO', 'COMPLETADA', 'CANCELADA', 'NO_ASISTIO')),
    observaciones VARCHAR2(500),
    fecha_creacion DATE DEFAULT SYSDATE,
    CONSTRAINT fk_cita_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    CONSTRAINT fk_cita_medico FOREIGN KEY (medico_id) REFERENCES medicos(id),
    CONSTRAINT fk_cita_consultorio FOREIGN KEY (consultorio_id) REFERENCES consultorios(id),
    CONSTRAINT uk_cita_unica UNIQUE (fecha, hora, medico_id)
);

-- Tabla CONSULTAS (detalle de la atención médica)
CREATE TABLE consultas (
    id NUMBER PRIMARY KEY,
    cita_id NUMBER NOT NULL,
    diagnostico VARCHAR2(1000),
    tratamiento VARCHAR2(1000),
    observaciones VARCHAR2(1000),
    proxima_cita DATE,
    CONSTRAINT fk_consulta_cita FOREIGN KEY (cita_id) REFERENCES citas(id)
);

-- ========================================
-- POBLACIÓN DE DATOS DE PRUEBA
-- ========================================

-- Insertar ESPECIALIDADES
INSERT INTO especialidades VALUES (seq_especialidades.NEXTVAL, 'Medicina General', 30, 25000);
INSERT INTO especialidades VALUES (seq_especialidades.NEXTVAL, 'Cardiología', 45, 45000);
INSERT INTO especialidades VALUES (seq_especialidades.NEXTVAL, 'Dermatología', 30, 35000);
INSERT INTO especialidades VALUES (seq_especialidades.NEXTVAL, 'Pediatría', 30, 30000);
INSERT INTO especialidades VALUES (seq_especialidades.NEXTVAL, 'Ginecología', 40, 40000);
INSERT INTO especialidades VALUES (seq_especialidades.NEXTVAL, 'Traumatología', 35, 38000);

-- Insertar MEDICOS
INSERT INTO medicos VALUES (seq_medicos.NEXTVAL, 'Dr. Carlos Mendoza', 1, '08:00', '17:00', '912345678', 'cmendoza@clinica.com', 'S');
INSERT INTO medicos VALUES (seq_medicos.NEXTVAL, 'Dra. Ana Rodríguez', 2, '09:00', '16:00', '987654321', 'arodriguez@clinica.com', 'S');
INSERT INTO medicos VALUES (seq_medicos.NEXTVAL, 'Dr. Luis García', 3, '10:00', '18:00', '956789123', 'lgarcia@clinica.com', 'S');
INSERT INTO medicos VALUES (seq_medicos.NEXTVAL, 'Dra. María López', 4, '08:30', '15:30', '923456789', 'mlopez@clinica.com', 'S');
INSERT INTO medicos VALUES (seq_medicos.NEXTVAL, 'Dr. Pedro Silva', 5, '14:00', '20:00', '934567890', 'psilva@clinica.com', 'S');
INSERT INTO medicos VALUES (seq_medicos.NEXTVAL, 'Dra. Carmen Torres', 6, '08:00', '16:00', '945678901', 'ctorres@clinica.com', 'S');
INSERT INTO medicos VALUES (seq_medicos.NEXTVAL, 'Dr. Roberto Vega', 1, '13:00', '20:00', '967890123', 'rvega@clinica.com', 'S');

-- Insertar PACIENTES
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Juan Pérez González', '912111111', 'juan.perez@email.com', DATE '1985-03-15', 'Av. Principal 123, Santiago', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'María Fernández Castro', '912222222', 'maria.fernandez@email.com', DATE '1990-07-22', 'Los Pinos 456, Providencia', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Carlos Sánchez Ruiz', '912333333', 'carlos.sanchez@email.com', DATE '1978-11-08', 'Las Flores 789, Las Condes', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Ana Martínez López', '912444444', 'ana.martinez@email.com', DATE '1995-02-14', 'El Bosque 321, Ñuñoa', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Pedro Gómez Silva', '912555555', 'pedro.gomez@email.com', DATE '1982-09-30', 'Libertad 654, San Miguel', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Laura Herrera Díaz', '912666666', 'laura.herrera@email.com', DATE '1988-05-18', 'Esperanza 987, Maipú', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Diego Morales Vega', '912777777', 'diego.morales@email.com', DATE '1992-12-03', 'Aurora 147, La Florida', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Carmen Jiménez Torres', '912888888', 'carmen.jimenez@email.com', DATE '1975-06-25', 'Sol Naciente 258, Peñalolén', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Roberto Castro Muñoz', '912999999', 'roberto.castro@email.com', DATE '1987-01-12', 'Monte Verde 369, Vitacura', 'S');
INSERT INTO pacientes VALUES (seq_pacientes.NEXTVAL, 'Sofía Vargas Rojas', '912000000', 'sofia.vargas@email.com', DATE '1993-08-07', 'Primavera 741, Macul', 'S');

-- Insertar CONSULTORIOS
INSERT INTO consultorios VALUES (seq_consultorios.NEXTVAL, '101', 3, 'Computador, Camilla, Tensiómetro, Estetoscopio', 'S');
INSERT INTO consultorios VALUES (seq_consultorios.NEXTVAL, '102', 2, 'Computador, Camilla, ECG, Monitor Cardiaco', 'S');
INSERT INTO consultorios VALUES (seq_consultorios.NEXTVAL, '103', 2, 'Computador, Camilla, Dermatoscopio, Lámpara UV', 'S');
INSERT INTO consultorios VALUES (seq_consultorios.NEXTVAL, '104', 4, 'Computador, Camilla Pediátrica, Báscula, Tallímetro', 'S');
INSERT INTO consultorios VALUES (seq_consultorios.NEXTVAL, '105', 2, 'Computador, Camilla Ginecológica, Ecógrafo', 'S');
INSERT INTO consultorios VALUES (seq_consultorios.NEXTVAL, '106', 3, 'Computador, Camilla, Rayos X portátil, Férulas', 'S');

-- Insertar CITAS (últimos 15 días y próximos 15 días)
-- Citas pasadas completadas
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-10, '09:00', 1, 1, 1, 'COMPLETADA', 'Control rutinario', SYSDATE-10);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-10, '10:00', 2, 2, 2, 'COMPLETADA', 'Dolor en el pecho', SYSDATE-10);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-9, '14:30', 3, 3, 3, 'COMPLETADA', 'Revisión de lunares', SYSDATE-9);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-8, '11:00', 4, 4, 4, 'COMPLETADA', 'Control niño sano', SYSDATE-8);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-7, '15:00', 5, 5, 5, 'NO_ASISTIO', 'Control ginecológico', SYSDATE-7);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-6, '09:30', 6, 6, 6, 'COMPLETADA', 'Dolor de rodilla', SYSDATE-6);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-5, '16:00', 7, 1, 1, 'COMPLETADA', 'Fiebre y malestar', SYSDATE-5);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-4, '10:30', 8, 2, 2, 'CANCELADA', 'Revisión cardiaca', SYSDATE-4);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-3, '11:30', 9, 3, 3, 'COMPLETADA', 'Acné severo', SYSDATE-3);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE-2, '14:00', 10, 4, 4, 'COMPLETADA', 'Vacunas', SYSDATE-2);

-- Citas futuras agendadas
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+1, '09:00', 1, 1, 1, 'CONFIRMADA', 'Control post-tratamiento', SYSDATE-3);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+1, '10:00', 3, 2, 2, 'AGENDADA', 'Primera consulta cardiológica', SYSDATE-2);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+2, '15:00', 5, 5, 5, 'AGENDADA', 'Control ginecológico reprogramado', SYSDATE-1);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+3, '11:00', 2, 4, 4, 'AGENDADA', 'Consulta pediátrica', SYSDATE);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+3, '14:30', 4, 3, 3, 'AGENDADA', 'Seguimiento dermatológico', SYSDATE);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+5, '08:30', 6, 6, 6, 'AGENDADA', 'Terapia física rodilla', SYSDATE);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+7, '16:30', 7, 7, 1, 'AGENDADA', 'Control medicina general', SYSDATE);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+10, '09:30', 8, 1, 1, 'AGENDADA', 'Exámenes preventivos', SYSDATE);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+12, '13:00', 9, 2, 2, 'AGENDADA', 'Control presión arterial', SYSDATE);
INSERT INTO citas VALUES (seq_citas.NEXTVAL, SYSDATE+15, '10:30', 10, 3, 3, 'AGENDADA', 'Revisión general piel', SYSDATE);

-- Insertar CONSULTAS (solo para citas completadas)
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 1, 'Paciente en buen estado general', 'Continuar con vitaminas', 'Control en 6 meses', SYSDATE+180);
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 2, 'Arritmia leve detectada', 'Holter 24 horas, betabloqueadores', 'Reducir cafeína y estrés', SYSDATE+30);
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 3, 'Lunares benignos', 'Protector solar factor 50+', 'Control anual dermatológico', SYSDATE+365);
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 4, 'Desarrollo normal para la edad', 'Continuar con alimentación actual', 'Próximo control en 3 meses', SYSDATE+90);
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 6, 'Desgaste leve cartílago rodilla', 'Antiinflamatorios, fisioterapia', 'Evitar deportes de alto impacto', SYSDATE+21);
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 7, 'Infección viral leve', 'Paracetamol, reposo, hidratación', 'Consultar si empeora', NULL);
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 9, 'Acné grado III', 'Isotretinoína, limpieza facial', 'Control mensual obligatorio', SYSDATE+30);
INSERT INTO consultas VALUES (seq_consultas.NEXTVAL, 10, 'Esquema de vacunación al día', 'Ningún tratamiento necesario', 'Próximas vacunas en 1 año', SYSDATE+365);

-- Confirmar transacciones
COMMIT;

-- ========================================
-- VERIFICACIONES Y ESTADÍSTICAS
-- ========================================

-- Mostrar resumen de datos insertados
SELECT 'ESPECIALIDADES' as tabla, COUNT(*) as total FROM especialidades
UNION ALL
SELECT 'MEDICOS', COUNT(*) FROM medicos
UNION ALL
SELECT 'PACIENTES', COUNT(*) FROM pacientes
UNION ALL
SELECT 'CONSULTORIOS', COUNT(*) FROM consultorios
UNION ALL
SELECT 'CITAS', COUNT(*) FROM citas
UNION ALL
SELECT 'CONSULTAS', COUNT(*) FROM consultas;

-- Verificar relaciones
SELECT 
    'CITAS POR ESTADO' as descripcion,
    estado,
    COUNT(*) as cantidad
FROM citas 
GROUP BY estado
ORDER BY COUNT(*) DESC;