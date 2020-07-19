const express = require('express')
const app = express()

// Render test page
app.get('/', (req, res) => res.send('<h1>Hello Jeff!</h1>'))

// Start listening on port 3000
app.listen(3000, 'localhost')
