const express = require('express')
const app = express()

// Render test page
app.get('/', (req, res) => res.send('<h1>Hello Jeff!</h1>'))

// Start listening on port 8080
app.listen(8080, 'localhost')
