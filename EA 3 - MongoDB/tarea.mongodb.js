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