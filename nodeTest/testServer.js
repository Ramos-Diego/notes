const express = require('express')
const app = express() // initialize express
const { join } = require('path')

// Set a static folder
app.use(express.static(join(__dirname, 'public')))

// Render test page
app.get('/', (req, res) => res.render('index.html'))

// Start listening on port 8080
app.listen(8080)
