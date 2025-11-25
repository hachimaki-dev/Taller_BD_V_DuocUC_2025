const mongoose = require('mongoose');
require('dotenv').config({ path: './benchmark/.env' });

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

async function checkData() {
    try {
        console.log('Connecting to:', mongoUri);
        await mongoose.connect(mongoUri);
        console.log('Connected.');

        const totalCount = await CommentModel.countDocuments({});
        console.log('Total documents:', totalCount);

        const rootCount = await CommentModel.countDocuments({ parent_id: null });
        console.log('Root documents (parent_id: null):', rootCount);

        const sample = await CommentModel.findOne({});
        console.log('Sample document:', sample);

    } catch (err) {
        console.error('Error:', err);
    } finally {
        await mongoose.disconnect();
    }
}

checkData();
