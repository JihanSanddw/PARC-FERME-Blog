require('dotenv').config();

const app = require('./app');

const PORT = process.env.PORT || 3026;

app.listen(PORT, () => {
    console.log(`PARC FERMÉ API running on http://localhost:${PORT}`);
});