const db = require('../config/database');

// GET upcoming races
const getUpcomingRaces = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT
                id_race,
                grand_prix,
                circuit,
                country,
                round,
                race_date,
                is_sprint
            FROM races
            WHERE race_date >= CURDATE()
            ORDER BY race_date ASC
        `);

        res.status(200).json(rows);
    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: 'Failed to fetch upcoming races'
        });
    }
};


// GET completed races
const getCompletedRaces = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT
                id_race,
                grand_prix,
                circuit,
                country,
                round,
                race_date,
                is_sprint
            FROM races
            WHERE race_date < CURDATE()
            ORDER BY race_date DESC
        `);

        res.status(200).json(rows);
    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: 'Failed to fetch completed races'
        });
    }
};


module.exports = {
    getUpcomingRaces,
    getCompletedRaces
};