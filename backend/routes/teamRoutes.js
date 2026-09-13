const express = require('express');

const {
    getAllTeams,
    getTeamById,
    getDriversByTeam
} = require('../controllers/teamController');

const router = express.Router();


// IMPORTANT:
// route /:id/drivers harus ditulis sebelum /:id

router.get('/:id/drivers', getDriversByTeam);

router.get('/', getAllTeams);

router.get('/:id', getTeamById);


module.exports = router;