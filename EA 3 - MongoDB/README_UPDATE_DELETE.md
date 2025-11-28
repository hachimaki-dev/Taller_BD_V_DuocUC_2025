# 🔄 Tutorial MongoDB: UPDATE & DELETE - Modificando el Mundo

## 📖 Descripción

Tutorial interactivo completo sobre operaciones de modificación y eliminación en MongoDB. Diseñado con estética Web 2.0/1.0 híbrida, colores vibrantes, y tema claro/oscuro.

## 🎯 Objetivos de Aprendizaje

Al completar este tutorial, los estudiantes podrán:

1. ✅ Actualizar campos individuales con `$set`
2. ✅ Modificar números con `$inc`
3. ✅ Manipular arrays con `$push`, `$pull`, y `$addToSet`
4. ✅ Eliminar documentos de forma segura
5. ✅ Entender cuándo usar `One` vs `Many`
6. ✅ Aplicar mejores prácticas de seguridad

## 📂 Archivos Incluidos

- **03 - UPDATE y DELETE.html** - Tutorial interactivo principal
- **03 - datos_update_delete.mongodb.js** - Script con datos de ejemplo y demostraciones

## 🚀 Cómo Usar

### Paso 1: Preparar la Base de Datos

1. Abre MongoDB Compass o VS Code con la extensión MongoDB
2. Conecta a tu servidor MongoDB local
3. Abre el archivo `03 - datos_update_delete.mongodb.js`
4. Ejecuta el script completo para:
   - Crear la base de datos `rpg_db`
   - Poblar la colección `heroes` con 20 héroes
   - Ver ejemplos de todas las operaciones

### Paso 2: Abrir el Tutorial Interactivo

1. Abre el archivo `03 - UPDATE y DELETE.html` en tu navegador
2. Navega por las 6 pestañas:
   - 🏠 **Inicio**: Introducción y conceptos
   - 🔄 **UPDATE Básico**: `updateOne()`, `$set`, `$inc`
   - 🔄 **UPDATE Múltiple**: `updateMany()`, buffs masivos
   - 📦 **Arrays**: `$push`, `$pull`, `$addToSet`
   - 💀 **DELETE**: `deleteOne()`, `deleteMany()`, seguridad
   - 📋 **Cheat Sheet**: Referencia rápida

### Paso 3: Practicar con los Ejercicios

Cada sección incluye ejercicios interactivos:

1. Lee la documentación del operador
2. Escribe tu código en el editor
3. Haz clic en "Ejecutar 🚀"
4. Recibe feedback inmediato

## 📋 Estructura del Tutorial

### Bloque 1: UPDATE (Tabs 1-3, ~35 min)

#### UPDATE Básico (Tab 1)
- **Operador `$set`**: Establecer valores de campos
  - Ejercicio: Cambiar arma de Link
- **Operador `$inc`**: Incrementar/decrementar números
  - Ejercicio: Frodo sube de nivel

#### UPDATE Múltiple (Tab 2)
- **`updateMany()`**: Actualizar múltiples documentos
  - Ejercicio: Buff a todos los Guerreros (+5 niveles)
  - Ejercicio: Ayuda a novatos (nivel < 20 reciben +50 HP)

#### Manipulación de Arrays (Tab 3)
- **Operador `$push`**: Añadir elementos al array
  - Ejercicio: Gandalf aprende "Ice Blast"
- **Operador `$pull`**: Remover elementos del array
  - Ejercicio: Sam olvida "Cocinar"
- **Operador `$addToSet`**: Añadir sin duplicar

### Bloque 2: DELETE (Tab 4, ~20 min)

- **`deleteOne()`**: Eliminar un documento
  - Ejercicio: Eliminar a Link
- **`deleteMany()`**: Eliminar múltiples documentos
  - Ejercicio: Limpiar héroes nivel < 15
  - Desafío: Eliminar Guerreros con HP < 300

### Bloque 3: Consolidación (Tab 5, ~5 min)

- Cheat Sheet completo
- Ejemplos del mundo real
- Mejores prácticas
- Sistema de experiencia integrador

## 🎨 Características del Tutorial

### Diseño
- ✨ Estética Web 2.0/1.0 híbrida
- 🌈 Gradientes animados de fondo
- 🌓 Tema claro/oscuro (toggle en header)
- 💎 Efectos glossy en botones y cards
- 🎯 Colores vibrantes y contrastantes

### Interactividad
- ✍️ Editores de código en vivo
- ✅ Validación automática de ejercicios
- 💬 Feedback inmediato
- 📊 Barra de progreso visual
- 🎭 Animaciones suaves

### Pedagogía
- 📖 Documentación exhaustiva de cada operador
- 💡 Tips y advertencias contextuales
- ⚠️ Énfasis en seguridad y mejores prácticas
- 🎯 Ejercicios progresivos (de básico a avanzado)
- 🏆 Desafíos finales

## ⚠️ Reglas de Seguridad (Énfasis del Tutorial)

El tutorial enfatiza constantemente:

1. **SIEMPRE** ejecutar `find()` con el mismo filtro antes de `update/delete`
2. **NUNCA** usar `{}` vacío en `deleteMany()` en producción
3. **HACER** backups antes de operaciones masivas
4. **PROBAR** en desarrollo primero
5. **VERIFICAR** los resultados después de cada operación

## 🔧 Operadores Cubiertos

### UPDATE
- `$set` - Establecer valor de campo
- `$inc` - Incrementar/decrementar número
- `$push` - Añadir a array
- `$pull` - Remover de array
- `$addToSet` - Añadir sin duplicar

### DELETE
- `deleteOne()` - Eliminar un documento
- `deleteMany()` - Eliminar múltiples documentos

## 📊 Distribución del Tiempo (60 min)

```
UPDATE Básico:     15 min ████████
UPDATE Avanzado:   20 min ████████████
DELETE:            20 min ████████████
Consolidación:      5 min ███
```

## 🎓 Ejercicios Incluidos

1. **Cambiar arma de Link** (`$set`)
2. **Frodo sube de nivel** (`$inc`)
3. **Buff a todos los Guerreros** (`updateMany` + `$inc`)
4. **Ayuda a novatos** (`updateMany` + filtro + `$inc`)
5. **Gandalf aprende Ice Blast** (`$push`)
6. **Sam olvida Cocinar** (`$pull`)
7. **Eliminar a Link** (`deleteOne`)
8. **Limpiar héroes débiles** (`deleteMany`)
9. **Desafío: Eliminar guerreros débiles** (filtros múltiples)

## 💡 Ejemplo Integrador: Sistema de Experiencia

El tutorial incluye un ejemplo completo que combina todos los conceptos:

```javascript
// 1. Todos los héroes ganan +10 XP
db.heroes.updateMany({}, { $inc: { xp: 10 } })

// 2. Los que lleguen a XP >= 100 suben de nivel
db.heroes.updateMany(
  { xp: { $gte: 100 } },
  { $inc: { level: 1 }, $set: { xp: 0 } }
)

// 3. Eliminar héroes muertos (hp <= 0)
db.heroes.deleteMany({ hp: { $lte: 0 } })
```

## 🌟 Mejores Prácticas Enseñadas

### ✅ HACER
- Verificar con `find()` primero
- Usar filtros específicos
- Hacer backups regulares
- Probar en desarrollo
- Documentar cambios masivos

### ❌ NO HACER
- Ejecutar delete sin verificar
- Usar `{}` vacío en producción
- Modificar sin backup
- Ignorar los resultados
- Asumir que funcionó

## 🔄 Progresión del Aprendizaje

```
Básico → Intermedio → Avanzado → Integrador
  ↓          ↓            ↓           ↓
$set     updateMany    Arrays    Sistema XP
$inc     Filtros       $push     Múltiples
         Condicionales $pull     operaciones
                       $addToSet combinadas
```

## 📱 Compatibilidad

- ✅ Responsive (móvil, tablet, desktop)
- ✅ Navegadores modernos (Chrome, Firefox, Safari, Edge)
- ✅ Tema claro/oscuro automático según preferencias del sistema

## 🎯 Público Objetivo

- Estudiantes de bases de datos
- Desarrolladores aprendiendo MongoDB
- Profesores buscando material interactivo
- Cualquiera que quiera dominar UPDATE y DELETE en MongoDB

## 📝 Notas para Profesores

- El tutorial es **autoguiado** - los estudiantes pueden avanzar a su ritmo
- Los ejercicios tienen **validación automática** - no requiere supervisión constante
- El **Cheat Sheet** final es ideal para imprimir como referencia
- El script `.mongodb.js` puede ejecutarse en clase para demostración en vivo

## 🚀 Próximos Pasos

Después de completar este tutorial, los estudiantes estarán listos para:

1. Trabajar con operaciones CRUD completas
2. Implementar sistemas de actualización en aplicaciones reales
3. Manejar datos de forma segura y eficiente
4. Avanzar a temas como agregación y pipelines

## 📞 Soporte

Para dudas o sugerencias sobre el tutorial, contacta al profesor o revisa la documentación oficial de MongoDB.

---

**Creado para DuocUC 2025** • MongoDB Tutorial Series • UPDATE & DELETE
