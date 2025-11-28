// 🔄 Script de Población - Tutorial UPDATE & DELETE
// Copia y ejecuta esto en tu MongoDB Playground

// Selecciona la base de datos
use('rpg_db');

// Elimina la colección anterior si existe
db.heroes.drop();

// Inserta héroes con campos adicionales para UPDATE/DELETE
db.heroes.insertMany([
    // Guerreros
    {
        name: "Aragorn",
        class: "Guerrero",
        level: 87,
        weapon: "Espada",
        hp: 950,
        xp: 0,
        gold: 500,
        status: "active",
        lastBattle: new Date("2025-11-20"),
        skills: ["Ataque Pesado", "Defensa"]
    },
    {
        name: "Gimli",
        class: "Guerrero",
        level: 80,
        weapon: "Hacha",
        hp: 900,
        xp: 0,
        gold: 450,
        status: "active",
        lastBattle: new Date("2025-11-22"),
        skills: ["Golpe Crítico"]
    },
    {
        name: "Boromir",
        class: "Guerrero",
        level: 75,
        weapon: "Espada y Escudo",
        hp: 850,
        xp: 0,
        gold: 400,
        status: "active",
        lastBattle: new Date("2025-11-18"),
        skills: ["Bloqueo"]
    },
    {
        name: "Thor",
        class: "Guerrero",
        level: 95,
        weapon: "Martillo",
        hp: 1000,
        xp: 0,
        gold: 800,
        status: "active",
        lastBattle: new Date("2025-11-25"),
        skills: ["Relámpago", "Fuerza Divina"]
    },
    {
        name: "Conan",
        class: "Guerrero",
        level: 70,
        weapon: "Espada Ancha",
        hp: 800,
        xp: 0,
        gold: 350,
        status: "active",
        lastBattle: new Date("2025-11-15"),
        skills: ["Berserker"]
    },

    // Magos
    {
        name: "Gandalf",
        class: "Mago",
        level: 99,
        weapon: "Báculo",
        mana: 1500,
        xp: 0,
        gold: 1000,
        status: "active",
        lastBattle: new Date("2025-11-27"),
        skills: ["Fireball", "Lightning", "Teleport"]
    },
    {
        name: "Saruman",
        class: "Mago",
        level: 95,
        weapon: "Báculo Negro",
        mana: 1400,
        xp: 0,
        gold: 900,
        status: "active",
        lastBattle: new Date("2025-11-24"),
        skills: ["Dark Magic", "Mind Control"]
    },
    {
        name: "Merlin",
        class: "Mago",
        level: 98,
        weapon: "Báculo Antiguo",
        mana: 1600,
        xp: 0,
        gold: 950,
        status: "active",
        lastBattle: new Date("2025-11-26"),
        skills: ["Time Stop", "Prophecy"]
    },
    {
        name: "Dumbledore",
        class: "Mago",
        level: 92,
        weapon: "Varita",
        mana: 1300,
        xp: 0,
        gold: 850,
        status: "active",
        lastBattle: new Date("2025-11-23"),
        skills: ["Patronus", "Fireball"]
    },
    {
        name: "Elsa",
        class: "Mago",
        level: 85,
        weapon: "Ninguna",
        mana: 1200,
        xp: 0,
        gold: 700,
        status: "active",
        lastBattle: new Date("2025-11-21"),
        skills: ["Ice Blast", "Freeze"]
    },

    // Arqueros
    {
        name: "Legolas",
        class: "Arquero",
        level: 88,
        weapon: "Arco Élfico",
        arrows: 100,
        xp: 0,
        gold: 600,
        status: "active",
        lastBattle: new Date("2025-11-25"),
        skills: ["Disparo Preciso", "Lluvia de Flechas"]
    },
    {
        name: "Katniss",
        class: "Arquero",
        level: 65,
        weapon: "Arco Compuesto",
        arrows: 50,
        xp: 0,
        gold: 300,
        status: "active",
        lastBattle: new Date("2025-11-20"),
        skills: ["Disparo Explosivo"]
    },
    {
        name: "Robin Hood",
        class: "Arquero",
        level: 78,
        weapon: "Arco Largo",
        arrows: 80,
        xp: 0,
        gold: 450,
        status: "active",
        lastBattle: new Date("2025-11-22"),
        skills: ["Flecha Dividida"]
    },
    {
        name: "Hawkeye",
        class: "Arquero",
        level: 82,
        weapon: "Arco Táctico",
        arrows: 60,
        xp: 0,
        gold: 500,
        status: "active",
        lastBattle: new Date("2025-11-24"),
        skills: ["Flechas Especiales"]
    },

    // Asesinos
    {
        name: "Ezio",
        class: "Asesino",
        level: 85,
        weapon: "Cuchillas Ocultas",
        stealth: 95,
        xp: 0,
        gold: 550,
        status: "active",
        lastBattle: new Date("2025-11-23"),
        skills: ["Sigilo", "Asesinato Aéreo"]
    },
    {
        name: "Altair",
        class: "Asesino",
        level: 80,
        weapon: "Hoja Oculta",
        stealth: 90,
        xp: 0,
        gold: 500,
        status: "active",
        lastBattle: new Date("2025-11-21"),
        skills: ["Eagle Vision"]
    },

    // Principiantes (para ejercicios de DELETE)
    {
        name: "Frodo",
        class: "Guerrero",
        level: 12,
        weapon: "Daga",
        hp: 200,
        xp: 0,
        gold: 50,
        status: "active",
        lastBattle: new Date("2025-11-10"),
        skills: ["Esquivar"]
    },
    {
        name: "Sam",
        class: "Guerrero",
        level: 10,
        weapon: "Sartén",
        hp: 180,
        xp: 0,
        gold: 40,
        status: "active",
        lastBattle: new Date("2025-11-08"),
        skills: ["Cocinar"]
    },
    {
        name: "Luna",
        class: "Mago",
        level: 15,
        weapon: "Varita Rota",
        mana: 150,
        xp: 0,
        gold: 60,
        status: "active",
        lastBattle: new Date("2025-11-12"),
        skills: ["Luz"]
    },
    {
        name: "Link",
        class: "Guerrero",
        level: 1,
        weapon: "Espada de Madera",
        hp: 100,
        xp: 0,
        gold: 10,
        status: "active",
        lastBattle: new Date("2025-11-05"),
        skills: []
    }
]);

// Verifica la inserción
print("✅ Insertados:", db.heroes.countDocuments(), "héroes");

// 📋 EJEMPLOS DE UPDATE Y DELETE

print("\n=== EJEMPLOS DE UPDATE ===\n");

// 1. UPDATE BÁSICO - $set
print("1. Cambiar arma de Link:");
db.heroes.updateOne(
    { name: "Link" },
    { $set: { weapon: "Master Sword" } }
);
print("✅ Link ahora tiene Master Sword");

// 2. UPDATE BÁSICO - $inc
print("\n2. Frodo sube de nivel:");
db.heroes.updateOne(
    { name: "Frodo" },
    { $inc: { level: 1 } }
);
print("✅ Frodo ahora es nivel 13");

// 3. UPDATE MÚLTIPLE - Buff masivo
print("\n3. Buff a todos los Guerreros (+5 niveles):");
db.heroes.updateMany(
    { class: "Guerrero" },
    { $inc: { level: 5 } }
);
print("✅ Todos los guerreros subieron 5 niveles");

// 4. UPDATE MÚLTIPLE - Buff condicional
print("\n4. Ayuda a novatos (nivel < 20 reciben +50 HP):");
db.heroes.updateMany(
    { level: { $lt: 20 } },
    { $inc: { hp: 50 } }
);
print("✅ Novatos recibieron +50 HP");

// 5. ARRAYS - $push
print("\n5. Gandalf aprende Ice Blast:");
db.heroes.updateOne(
    { name: "Gandalf" },
    { $push: { skills: "Ice Blast" } }
);
print("✅ Gandalf aprendió Ice Blast");

// 6. ARRAYS - $pull
print("\n6. Sam olvida Cocinar:");
db.heroes.updateOne(
    { name: "Sam" },
    { $pull: { skills: "Cocinar" } }
);
print("✅ Sam olvidó Cocinar");

// 7. ARRAYS - $addToSet (sin duplicados)
print("\n7. Añadir skill sin duplicar:");
db.heroes.updateOne(
    { name: "Aragorn" },
    { $addToSet: { skills: "Liderazgo" } }
);
print("✅ Aragorn aprendió Liderazgo (sin duplicar)");

print("\n=== EJEMPLOS DE DELETE ===\n");

// 8. DELETE ONE
print("8. Eliminar a Link:");
// SIEMPRE verificar primero
db.heroes.find({ name: "Link" }).count();
// Luego eliminar
db.heroes.deleteOne({ name: "Link" });
print("✅ Link eliminado");

// 9. DELETE MANY
print("\n9. Eliminar héroes nivel < 15:");
// SIEMPRE verificar primero
print("Héroes a eliminar:", db.heroes.find({ level: { $lt: 15 } }).count());
// Luego eliminar
db.heroes.deleteMany({ level: { $lt: 15 } });
print("✅ Héroes débiles eliminados");

// 10. DELETE CONDICIONAL
print("\n10. Eliminar Guerreros con HP < 300:");
// Verificar
print("Guerreros a eliminar:", db.heroes.find({ class: "Guerrero", hp: { $lt: 300 } }).count());
// Eliminar
db.heroes.deleteMany({ class: "Guerrero", hp: { $lt: 300 } });
print("✅ Guerreros débiles eliminados");

print("\n=== SISTEMA DE EXPERIENCIA (EJEMPLO INTEGRADOR) ===\n");

// Resetear para el ejemplo
db.heroes.updateMany({}, { $set: { xp: 0 } });

print("11. Sistema de XP completo:");

// Paso 1: Todos ganan +10 XP
db.heroes.updateMany({}, { $inc: { xp: 10 } });
print("✅ Todos ganaron +10 XP");

// Paso 2: Simular algunos con más XP
db.heroes.updateMany(
    { level: { $gte: 80 } },
    { $inc: { xp: 95 } }  // Ahora tienen 105 XP
);

// Paso 3: Los que lleguen a 100 XP suben de nivel
db.heroes.updateMany(
    { xp: { $gte: 100 } },
    { $inc: { level: 1 }, $set: { xp: 0 } }
);
print("✅ Héroes con 100+ XP subieron de nivel");

// Paso 4: Simular daño
db.heroes.updateMany(
    { level: { $lt: 20 } },
    { $set: { hp: -10 } }  // Simulación de muerte
);

// Paso 5: Eliminar héroes muertos
db.heroes.deleteMany({ hp: { $lte: 0 } });
print("✅ Héroes muertos eliminados");

print("\n=== ESTADO FINAL ===\n");
print("Total de héroes:", db.heroes.countDocuments());

// Mostrar algunos héroes
print("\nEjemplos de héroes actualizados:");
db.heroes.find().limit(3).forEach(hero => {
    print(`- ${hero.name} (${hero.class}) - Nivel ${hero.level} - ${hero.gold} oro`);
});

print("\n✅ Script completado. ¡Practica con el tutorial interactivo!");
