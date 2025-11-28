use('operadores');
db.heroes.find({});

use('operadores');
// clase guerrero
db.heroes.find({
    class : "Guerrero"
});

use('operadores');
db.heroes.find({
    level : {$gt: 80}
});

//Level menor o igual a 15
use('operadores');
db.heroes.find({
    level : {$lte: 15}
});

//magos o arqueros
use('operadores');
db.heroes.find({
    class: { $in: ['Guerrero', 'Mago']}
});


//niveles entre 70 y 90
use('operadores');
db.heroes.find({
    level: { $gte: 70, $lte: 90 }
});

// Guerreros experimentados mayores a 75
use('operadores');
db.heroes.find({
    level: {$gt : 90}
});

use('operadores');
db.heroes.find({
    skills : {$in : ['Fireball']}
});


// asesinos con stealth superior a
use('operadores');
db.heroes.find({
    class: "Asesino"
});


// Encuentra héroes que NO sean Guerreros Y tengan nivel 95 o superior
use('operadores');
db.heroes.find({
    class: { $ne : 'Guerrero'},
    level: {$gt: 95}
});




// TArea 2

// cambiar arma
use('operadores')
db.heroes.find({
    name : 'Link'
});


use('operadores')
db.heroes.update(
    { name : 'Link' },
    { $set : { weapon : 'Armita linda' }}
);

// frodo sube level:
use('operadores')
db.heroes.find({
    name : 'Frodo'
});

use('operadores')
db.heroes.update(
    {name:'Frodo'},
    {$inc: {level: 1}}
);

//  ¡Evento especial! Todos los class: "Guerrero" reciben +5 niveles. Usa updateMany() con $inc. 

use('operadores')
db.heroes.find({
    class : 'Guerrero'
});

use('operadores')
db.heroes.updateMany(
    { class : 'Guerrero' },
    {$inc : {level: 5}}
);


//  Todos los héroes con level menor a 20 reciben +50 HP. Combina updateMany(), filtro con $lt, y $inc. 

use('operadores')
db.heroes.find({
    level : {$lt: 20}
});

use('operadores')
db.heroes.updateMany(
    { level : {$lt : 20}},
    {$inc : {hp: 50}}
);

//  Gandalf descubrió un nuevo hechizo. Añade "Ice Blast" a su array skills. 
use('operadores')
db.heroes.find({
    name : 'Gandalf'
});


use('operadores')
db.heroes.update(
    {name : 'Gandalf'},
    {$push : { skills : 'ICe Blast'}}
);

