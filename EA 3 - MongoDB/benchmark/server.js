const express = require('express');
require('dotenv').config();
const oracledb = require('oracledb');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.static(path.join(__dirname, 'public')));

// --- CONFIGURACIÓN ORACLE ---
// --- CONFIGURACIÓN ORACLE ---
const oracleConfig = {
    user: process.env.ORACLE_USER,
    password: process.env.ORACLE_PASSWORD,
    connectString: process.env.ORACLE_CONN_STR
};

// Activar modo Thin (no requiere binarios de Instant Client si la versión de Node/Driver lo soporta)
try {
    oracledb.initOracleClient({ libDir: process.env.ORACLE_CLIENT_LIB_DIR }); // Opcional si se usa Thin mode por defecto en v6+
} catch (err) {
    console.log('Usando modo Thin de Oracle (o falló initOracleClient, se intentará default)');
}

// --- CONFIGURACIÓN MONGO ---
// --- CONFIGURACIÓN MONGO ---
const mongoUri = process.env.MONGO_URI;

// Esquema Mongoose
const CommentSchema = new mongoose.Schema({
    _id: Number,
    post_id: Number,
    user_id: Number,
    parent_id: Number,
    contenido: String,
    fecha: Date
}, { collection: 'comments' });

const CommentModel = mongoose.model('Comment', CommentSchema);

// --- CONEXIÓN INICIAL ---
async function init() {
    try {
        await mongoose.connect(mongoUri);
        console.log('✅ Conectado a MongoDB');
    } catch (err) {
        console.error('❌ Error conectando a MongoDB:', err);
    }
}
init();

// --- ENDPOINTS ---

// 1. ORACLE BENCHMARK
app.get('/api/oracle', async (req, res) => {
    let connection;
    try {
        const start = performance.now();

        connection = await oracledb.getConnection(oracleConfig);

        // Consulta recursiva clásica de Oracle
        const sql = `
            SELECT 
                LEVEL,
                comentario_id,
                parent_id,
                contenido,
                usuario_id,
                fecha_creacion
            FROM 
                comentarios
            START WITH 
                parent_id IS NULL
            CONNECT BY 
                PRIOR comentario_id = parent_id
            ORDER SIBLINGS BY 
                fecha_creacion ASC
        `;

        const result = await connection.execute(sql, [], { outFormat: oracledb.OUT_FORMAT_OBJECT });

        const end = performance.now();

        res.json({
            source: 'Oracle Database 19c',
            timeMs: (end - start).toFixed(2),
            count: result.rows.length,
            data: result.rows // Estructura plana pero ordenada jerárquicamente
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    } finally {
        if (connection) {
            try { await connection.close(); } catch (err) { console.error(err); }
        }
    }
});

// 2. MONGO BENCHMARK
app.get('/api/mongo', async (req, res) => {
    try {
        const start = performance.now();

        // Pipeline de agregación con $graphLookup
        // Nota: Esto devuelve un array de raíces, cada una con su array de descendientes "hilo_respuestas"
        const pipeline = [
            {
                $match: {
                    parent_id: null // Solo raíces
                }
            },
            {
                $graphLookup: {
                    from: "comments",
                    startWith: "$_id",
                    connectFromField: "_id",
                    connectToField: "parent_id",
                    as: "hilo_respuestas",
                    depthField: "nivel_profundidad"
                }
            },
            {
                $sort: { fecha: 1 }
            }
        ];

        const result = await CommentModel.aggregate(pipeline);

        const end = performance.now();

        // Calcular total de nodos recuperados (Raíces + sus descendientes)
        let totalRecords = 0;
        result.forEach(root => {
            totalRecords++; // El nodo raíz
            totalRecords += root.hilo_respuestas ? root.hilo_respuestas.length : 0;
        });

        res.json({
            source: 'MongoDB Atlas',
            timeMs: (end - start).toFixed(2),
            count: totalRecords,
            data: result // Estructura: Objetos raíz con array anidado de hijos planos
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

app.listen(PORT, () => {
    console.log(`🚀 Servidor Benchmark corriendo en http://localhost:${PORT}`);
});
