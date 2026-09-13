const express = require('express');

const {
    getUpcomingRaces,
    getCompletedRaces
} = require('../controllers/raceController');

const router = express.Router();

router.get('/upcoming', getUpcomingRaces);

router.get('/completed', getCompletedRaces);

module.exports = router;