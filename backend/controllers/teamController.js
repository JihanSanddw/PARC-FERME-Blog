const db = require('../config/database');

// GET semua teams
const getAllTeams = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT
                id_team,
                name,
                short_name,
                country,
                logo
            FROM teams
            ORDER BY id_team ASC
        `);

        res.status(200).json(rows);
    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: 'Failed to get teams'
        });
    }
};


// GET team berdasarkan ID
const getTeamById = async (req, res) => {
    try {
        const { id } = req.params;

        const [rows] = await db.query(`
            SELECT
                id_team,
                name,
                short_name,
                country,
                logo
            FROM teams
            WHERE id_team = ?
        `, [id]);

        if (rows.length === 0) {
            return res.status(404).json({
                message: 'Team not found'
            });
        }

        res.status(200).json(rows[0]);
    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: 'Failed to get team'
        });
    }
};


// GET drivers berdasarkan team
const getDriversByTeam = async (req, res) => {
    try {
        const { id } = req.params;

        // Cek apakah team ada
        const [team] = await db.query(`
            SELECT id_team
            FROM teams
            WHERE id_team = ?
        `, [id]);

        if (team.length === 0) {
            return res.status(404).json({
                message: 'Team not found'
            });
        }

        // Ambil drivers
        const [drivers] = await db.query(`
            SELECT
                id_driver,
                name,
                abbreviation,
                nationality,
                number,
                id_team,
                image
            FROM drivers
            WHERE id_team = ?
            ORDER BY number ASC
        `, [id]);

        res.status(200).json(drivers);
    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: 'Failed to get drivers'
        });
    }
};


module.exports = {
    getAllTeams,
    getTeamById,
    getDriversByTeam
};