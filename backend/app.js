const express = require('express');
const cors = require('cors');

const db = require('./config/database');

const app = express();

const raceRoutes = require('./routes/raceRoutes');
const teamRoutes = require('./routes/teamRoutes');

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'PARC FERMÉ Blog API is running successfully'
    });
});

app.get('/api/test-db-connection', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT 1 AS connected');

        res.status(200).json({
            success: true,
            message: 'Database connection successful',
            data: rows
        });
        
    } catch (error) {
        console.error(error);
        
        res.status(500).json({
            success: false,
            message: 'Database connection failed',
            error: error.message
        })
    }
})

app.use('/api/posts', require('./routes/postRoutes'))
app.use('/api/races', raceRoutes);
app.use('/api/teams', teamRoutes);

module.exports = app;