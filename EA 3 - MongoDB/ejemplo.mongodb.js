// 🌱 Script de Población - Base de Datos Heroes
// Copia y ejecuta esto en tu MongoDB Playground

// Selecciona la base de datos
use('rpg_db');

// Elimina la colección anterior si existe
db.heroes.drop();

// Inserta héroes de ejemplo
db.heroes.insertMany([
  // Guerreros
  { name: "Aragorn", class: "Guerrero", level: 87, weapon: "Espada", hp: 950, skills: ["Ataque Pesado", "Defensa"] },
  { name: "Gimli", class: "Guerrero", level: 80, weapon: "Hacha", hp: 900, skills: ["Golpe Crítico"] },
  { name: "Boromir", class: "Guerrero", level: 75, weapon: "Espada y Escudo", hp: 850, skills: ["Bloqueo"] },
  { name: "Thor", class: "Guerrero", level: 95, weapon: "Martillo", hp: 1000, skills: ["Relámpago", "Fuerza Divina"] },
  { name: "Conan", class: "Guerrero", level: 70, weapon: "Espada Ancha", hp: 800, skills: ["Berserker"] },
  
  // Magos
  { name: "Gandalf", class: "Mago", level: 99, weapon: "Báculo", mana: 1500, skills: ["Fireball", "Lightning", "Teleport"] },
  { name: "Saruman", class: "Mago", level: 95, weapon: "Báculo Negro", mana: 1400, skills: ["Dark Magic", "Mind Control"] },
  { name: "Merlin", class: "Mago", level: 98, weapon: "Báculo Antiguo", mana: 1600, skills: ["Time Stop", "Prophecy"] },
  { name: "Dumbledore", class: "Mago", level: 92, weapon: "Varita", mana: 1300, skills: ["Patronus", "Fireball"] },
  { name: "Elsa", class: "Mago", level: 85, weapon: "Ninguna", mana: 1200, skills: ["Ice Blast", "Freeze"] },
  
  // Arqueros
  { name: "Legolas", class: "Arquero", level: 88, weapon: "Arco Élfico", arrows: 100, skills: ["Disparo Preciso", "Lluvia de Flechas"] },
  { name: "Katniss", class: "Arquero", level: 65, weapon: "Arco Compuesto", arrows: 50, skills: ["Disparo Explosivo"] },
  { name: "Robin Hood", class: "Arquero", level: 78, weapon: "Arco Largo", arrows: 80, skills: ["Flecha Dividida"] },
  { name: "Hawkeye", class: "Arquero", level: 82, weapon: "Arco Táctico", arrows: 60, skills: ["Flechas Especiales"] },
  
  // Asesinos
  { name: "Ezio", class: "Asesino", level: 85, weapon: "Cuchillas Ocultas", stealth: 95, skills: ["Sigilo", "Asesinato Aéreo"] },
  { name: "Altair", class: "Asesino", level: 80, weapon: "Hoja Oculta", stealth: 90, skills: ["Eagle Vision"] },
  
  // Principiantes
  { name: "Frodo", class: "Guerrero", level: 12, weapon: "Daga", hp: 200, skills: ["Esquivar"] },
  { name: "Sam", class: "Guerrero", level: 10, weapon: "Sartén", hp: 180, skills: ["Cocinar"] },
  { name: "Luna", class: "Mago", level: 15, weapon: "Varita Rota", mana: 150, skills: ["Luz"] },
  { name: "Link", class: "Guerrero", level: 1, weapon: "Espada de Madera", hp: 100, skills: [] }
]);

// Verifica la inserción
print("✅ Insertados:", db.heroes.countDocuments(), "héroes");