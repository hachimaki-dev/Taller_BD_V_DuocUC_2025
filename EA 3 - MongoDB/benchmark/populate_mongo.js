const mongoose = require('mongoose');
require('dotenv').config();

const mongoUri = process.env.MONGO_URI;

const CommentSchema = new mongoose.Schema({
    _id: Number,
    post_id: Number,
    user_id: Number,
    parent_id: Number,
    contenido: String,
    fecha: Date
}, { collection: 'comments' });

const CommentModel = mongoose.model('Comment', CommentSchema);

async function populate() {
    try {
        console.log('Connecting to:', mongoUri);
        await mongoose.connect(mongoUri);
        console.log('Connected.');

        // 1. LIMPIEZA
        console.log('Dropping collection...');
        try {
            await CommentModel.collection.drop();
        } catch (err) {
            if (err.code === 26) {
                console.log('Collection not found, skipping drop.');
            } else {
                throw err;
            }
        }

        // 2. GENERACIÓN DE DATOS
        const totalLevels = 12;
        const maxChildren = 2;
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
            if (parents.length === 0) break;
        }

        console.log(`Inserting ${comments.length} comments...`);
        await CommentModel.insertMany(comments);
        console.log('Done!');

    } catch (err) {
        console.error('Error:', err);
    } finally {
        await mongoose.disconnect();
    }
}

populate();
