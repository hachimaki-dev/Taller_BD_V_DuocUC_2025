# EVALUACIÓN N°1 - BDY1103: TIPOS DE DATOS COMPUESTOS Y CURSORES
**Fecha de entrega:** TENTATIVA SEMANA POST 18 | **Modalidad:** Informe escrito + Presentación oral



## 🎯 ¿QUÉ DEBES ENTREGAR?

### ENTREGA 1: INFORME ESCRITO (40% de tu nota final)
- **Formato:** PDF, máximo 6 páginas + anexos
- **Estructura:** Sigue exactamente las 6 secciones de esta guía
- **Código:** Incluye todo en los anexos, comentado línea por línea

### ENTREGA 2: PRESENTACIÓN ORAL (60% de tu nota final)
- **Duración:** 10-15 minutos + 5 minutos de preguntas
- **Apoyo visual:** PowerPoint o similar
- **Demo en vivo:** Ejecuta tu código durante la presentación


## 📝 INSTRUCCIONES PASO A PASO

### PASO 1: ELIGE TU CASO DE NEGOCIO
**Selecciona UNO de estos casos (o propón uno similar):**
- 🏪 Gestión de inventario de tienda retail
- 🏥 Sistema de citas médicas
- 📚 Biblioteca universitaria
- 🚚 Empresa de logística y envíos
- 🏦 Gestión de préstamos bancarios

**⚠️ IMPORTANTE:** Todo tu informe debe basarse en este caso específico.

### PASO 2: DESARROLLA EL CÓDIGO PL/SQL
**Debes implementar OBLIGATORIAMENTE:**

#### ✅ 1. Tipos de Datos Compuestos (AMBOS)
```sql
-- RECORD (ejemplo para completar)
TYPE empleado_record IS RECORD (
    nombre VARCHAR2(50),
    -- COMPLETA CON AL MENOS 4 CAMPOS MÁS
);

-- VARRAY (ejemplo para completar)  
TYPE departamentos_array IS VARRAY(10) OF VARCHAR2(30);
-- COMPLETA CON TU CASO ESPECÍFICO
```

#### ✅ 2. Cursores Explícitos Complejos (AL MENOS 2)
```sql
-- Cursor con parámetros
CURSOR c_ejemplo(parametro1 datatype) IS
    -- TU SELECT AQUÍ

-- Cursor con loops anidados
FOR registro IN cursor_name LOOP
    -- TU LÓGICA AQUÍ
END LOOP;
```

#### ✅ 3. Manejo de Excepciones (AMBOS TIPOS)
```sql
-- Excepciones predefinidas (elige 3 mínimo)
-- Excepciones personalizadas (crea 2 mínimo)
```

#### ✅ 4. Procedimientos y Funciones (MÍNIMO 2 DE CADA UNO)
```sql
-- 2 Procedimientos mínimo
-- 2 Funciones mínimo
-- 1 Paquete que los contenga
-- 2 Triggers mínimo
```


## 📋 ESTRUCTURA EXACTA DEL INFORME

### PÁGINA 1: INTRODUCCIÓN
**Escribe exactamente:**

**1.1 Descripción del Proyecto** (1 párrafo)
- "El problema de negocio identificado es: [DESCRIBE TU CASO ESPECÍFICO]"
- "Este proyecto resuelve específicamente: [LISTA 3 PROBLEMAS CONCRETOS]"

**1.2 Objetivo del Proyecto** (1 párrafo)  
- "Al finalizar la implementación, el sistema permitirá: [LISTA 4 BENEFICIOS ESPECÍFICOS]"

**1.3 Alcance** (1 párrafo)
- "Los procesos afectados son: [LISTA PROCESOS]"
- "Las limitaciones del proyecto son: [LISTA LIMITACIONES]"

**1.4 Tecnologías** (Lista simple)
- Oracle Database, PL/SQL, RECORD, VARRAY, Cursores explícitos, Excepciones, Procedimientos, Funciones, Paquetes, Triggers



### PÁGINA 2: TIPOS DE DATOS COMPUESTOS

**2.1 Definiciones** (2 párrafos máximo)
```
RECORD es: [EXPLICA EN TUS PALABRAS + EJEMPLO DE TU CASO]
VARRAY es: [EXPLICA EN TUS PALABRAS + EJEMPLO DE TU CASO]
```

**2.2 Implementación en tu Proyecto** (Código + explicación)
```sql
-- Pega aquí tu código RECORD real
-- Pega aquí tu código VARRAY real
```

**2.3 Justificación** (1 párrafo)
"En mi caso de [TU CASO], los RECORD son útiles porque: [RAZÓN ESPECÍFICA]"
"Los VARRAY resuelven específicamente: [PROBLEMA ESPECÍFICO DE TU CASO]"



### PÁGINA 3: CURSORES EXPLÍCITOS COMPLEJOS

**3.1 ¿Qué problema resuelven en tu caso?** (1 párrafo)

**3.2 Implementación** (Código + explicación línea por línea)
```sql
-- Tu primer cursor completo aquí
-- Tu segundo cursor completo aquí
```

**3.3 Comparación con alternativas** (1 párrafo)
"Sin cursores, tendría que: [DESCRIBE LA ALTERNATIVA INEFICIENTE]"
"Con cursores logro: [DESCRIBE LOS BENEFICIOS ESPECÍFICOS]"



### PÁGINA 4: MANEJO DE EXCEPCIONES

**4.1 Excepciones Predefinidas Implementadas**
```sql
-- Código de tus 3 excepciones predefinidas
-- Con comentarios explicando CUÁNDO ocurren en tu caso
```

**4.2 Excepciones Personalizadas Creadas**
```sql
-- Código de tus 2 excepciones personalizadas
-- Con comentarios explicando POR QUÉ las necesitas
```

**4.3 Impacto en la Robustez del Sistema** (1 párrafo)



### PÁGINA 5: PROCEDIMIENTOS, FUNCIONES, PAQUETES Y TRIGGERS

**5.1 Arquitectura de tu Solución**
```
PAQUETE: [NOMBRE_DE_TU_PAQUETE]
├── Procedimiento 1: [NOMBRE] - [QUÉ HACE]
├── Procedimiento 2: [NOMBRE] - [QUÉ HACE]  
├── Función 1: [NOMBRE] - [QUÉ DEVUELVE]
└── Función 2: [NOMBRE] - [QUÉ DEVUELVE]

TRIGGERS:
├── [NOMBRE_TRIGGER_1] - [CUÁNDO SE EJECUTA]
└── [NOMBRE_TRIGGER_2] - [CUÁNDO SE EJECUTA]
```

**5.2 Código Principal** (Encabezados + comentarios, código completo va en anexos)

**5.3 Justificación de Arquitectura** (1 párrafo)



### PÁGINA 6: CONCLUSIONES Y RECOMENDACIONES

**6.1 Logros del Proyecto**
- [LISTA 4 LOGROS ESPECÍFICOS CON NÚMEROS SI ES POSIBLE]

**6.2 Impacto en el Negocio**  
- [DESCRIBE 3 IMPACTOS MEDIBLES]

**6.3 Recomendaciones Futuras**
- [LISTA 3 MEJORAS ESPECÍFICAS PARA LA SIGUIENTE FASE]



## 📎 ANEXOS OBLIGATORIOS

### ANEXO A: CÓDIGO COMPLETO
```sql
-- TODO tu código PL/SQL aquí
-- CADA LÍNEA debe tener un comentario explicativo
-- Organizado por: TYPES, CURSORES, EXCEPCIONES, PROCEDIMIENTOS, FUNCIONES, PAQUETES, TRIGGERS
```

### ANEXO B: EVIDENCIAS DE EJECUCIÓN
- Screenshots de tu código ejecutándose en Oracle
- Resultados de pruebas con datos de ejemplo
- Mensajes de error manejados correctamente



## 🎤 GUIÓN PARA TU PRESENTACIÓN (15 minutos máximos)

### MINUTOS 1-2: HOOK + PROBLEMA
"¿Sabían que [DATO IMPACTANTE DE TU CASO]? Hoy les mostraré cómo PL/SQL resuelve este problema específico."

### MINUTOS 3-5: DEMO TIPOS COMPUESTOS
- Ejecuta tu RECORD en vivo
- Ejecuta tu VARRAY en vivo
- Explica POR QUÉ son útiles en tu caso

### MINUTOS 6-8: DEMO CURSORES
- Ejecuta tu cursor más complejo
- Muestra los datos que procesa
- Compara velocidad vs. alternativas

### MINUTOS 9-11: DEMO EXCEPCIONES
- Provoca un error a propósito
- Muestra cómo se maneja automáticamente
- Explica qué pasaría sin manejo de errores

### MINUTOS 12-14: DEMO PROCEDIMIENTOS/FUNCIONES
- Ejecuta tu paquete completo
- Muestra el resultado final
- Explica el impacto en el negocio

### MINUTO 15: CIERRE POTENTE
"En resumen, este sistema no solo automatiza [PROCESO], sino que [BENEFICIO PRINCIPAL MEDIBLE]"



## ✅ CHECKLIST ANTES DE ENTREGAR

### Informe:
- [ ] Máximo 6 páginas + anexos
- [ ] Cada sección responde exactamente lo solicitado
- [ ] Código funcional incluido en anexos
- [ ] Formato PDF profesional
- [ ] Sin errores ortográficos

### Presentación:
- [ ] PowerPoint preparado
- [ ] Código probado y funcionando
- [ ] Cronómetro: no más de 15 minutos
- [ ] Respuestas preparadas para 3 preguntas difíciles
- [ ] Demo lista para ejecutar en vivo

### Código:
- [ ] 1 RECORD implementado y usado
- [ ] 1 VARRAY implementado y usado
- [ ] 2+ cursores explícitos complejos
- [ ] 3+ excepciones predefinidas manejadas
- [ ] 2+ excepciones personalizadas creadas
- [ ] 2+ procedimientos funcionando
- [ ] 2+ funciones funcionando
- [ ] 1 paquete que los contenga
- [ ] 2+ triggers funcionando
- [ ] Todo comentado línea por línea
- [ ] Ejecutable en Oracle sin errores





## 📊 DISTRIBUCIÓN EXACTA DE PUNTOS

| Concepto | Puntos | ¿Dónde se evalúa? |
|----------|--------|-------------------|
| **INFORME (40 puntos total)** |
| Tipos de datos compuestos | 5 pts | Página 2 + código funcional |
| Cursores explícitos complejos | 10 pts | Página 3 + código funcional |
| Control de excepciones | 10 pts | Página 4 + código funcional |
| Proc./Func./Paquetes/Triggers | 15 pts | Página 5 + código funcional |
| **PRESENTACIÓN (60 puntos total)** |
| Explicación tipos compuestos | 15 pts | Demo en vivo funcionando |
| Justificación cursores | 15 pts | Demo en vivo funcionando |
| Explicación excepciones | 15 pts | Demo en vivo funcionando |
| Explicación implementación | 15 pts | Demo en vivo funcionando |

**TOTAL: 100 puntos**