// =============================================================================
// ENTREGABLE 2: SCRIPT MONGODB (COMENTARIOS ANIDADOS)
// =============================================================================

// 1. LIMPIEZA DE LA COLECCIÓN
db.comments.drop();

// 2. INSERCIÓN DE DATOS (DOCUMENTOS)
// Usamos referencias al padre (parent_id) igual que en SQL, pero almacenado como ObjectId o String.
// Para simplicidad visual y coincidencia con el ejemplo Oracle, usaremos IDs numéricos simples,
// aunque en producción serían ObjectId().

// 2. INSERCIÓN DE DATOS MASIVOS (GENERACIÓN DINÁMICA)
// Generamos una jerarquía de aprox. 12 niveles.
const totalLevels = 12;
const maxChildren = 2; // Máximo de respuestas por comentario (0-2)
let commentId = 1;
const comments = [];

// Nivel 1: 5 Comentarios Raíz
let parents = [];
for (let i = 1; i <= 5; i++) {
    const id = commentId++;
    comments.push({
        _id: id,
        post_id: 101,
        user_id: 100 + i,
        parent_id: null,
        contenido: `Comentario Raíz ${i}`,
        fecha: new Date()
    });
    parents.push(id);
}

// Niveles 2 al 12
for (let level = 2; level <= totalLevels; level++) {
    let nextParents = [];

    parents.forEach(parentId => {
        // Random children 0 to maxChildren
        const numChildren = Math.floor(Math.random() * (maxChildren + 1));

        for (let c = 0; c < numChildren; c++) {
            const id = commentId++;
            comments.push({
                _id: id,
                post_id: 101,
                user_id: 200 + level,
                parent_id: parentId,
                contenido: `Nivel ${level} - Respuesta ${c + 1}`,
                fecha: new Date()
            });
            nextParents.push(id);
        }
    });

    parents = nextParents;
    if (parents.length === 0) break; // Si no hay padres, se corta el árbol
}

print(`Insertando ${comments.length} comentarios...`);
db.comments.insertMany(comments);

// 3. CONSULTAS CON AGGREGATION PIPELINE

// A) OBTENER TODO EL ÁRBOL DE COMENTARIOS (RECONSTRUCCIÓN JERÁRQUICA)
// Usamos $graphLookup para buscar recursivamente todos los descendientes.
db.comments.aggregate([
    {
        $match: {
            parent_id: null // Empezamos buscando solo los comentarios raíz
        }
    },
    {
        $graphLookup: {
            from: "comments",             // Colección donde buscar
            startWith: "$_id",            // Valor inicial (ID del padre actual)
            connectFromField: "_id",      // Campo del documento actual para conectar
            connectToField: "parent_id",  // Campo en el documento destino que debe coincidir
            as: "hilo_respuestas",        // Nombre del array resultante
            depthField: "nivel_profundidad" // Campo opcional para saber qué tan profundo está
        }
    },
    // Opcional: Ordenar por fecha
    {
        $sort: { fecha: 1 }
    }
]).pretty();

// B) OBTENER SOLO LAS RESPUESTAS DIRECTAS DE UN COMENTARIO (SIN RECURSIVIDAD PROFUNDA)
// Equivalente a un simple FIND
db.comments.find({ parent_id: 2 });

// C) EJEMPLO DE ORDENAMIENTO POR PROFUNDIDAD (Usando el resultado de graphLookup)
// Nota: graphLookup pone todos los hijos en un array plano dentro del padre.
// Si queremos "aplanar" todo para mostrarlo en lista ordenada por jerarquía, haríamos:
db.comments.aggregate([
    { $match: { parent_id: null } },
    {
        $graphLookup: {
            from: "comments",
            startWith: "$_id",
            connectFromField: "_id",
            connectToField: "parent_id",
            as: "respuestas",
            depthField: "profundidad"
        }
    },
    { $unwind: "$respuestas" },
    {
        $project: {
            _id: "$respuestas._id",
            contenido: "$respuestas.contenido",
            padre: "$respuestas.parent_id",
            profundidad: { $add: ["$respuestas.profundidad", 1] } // Ajuste base 0
        }
    },
    { $sort: { profundidad: 1 } }
]);
