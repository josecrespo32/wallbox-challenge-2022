const express = require("express")
const app = express()
const bodyParser = require("body-parser")
const cors = require("cors")
const createError = require("http-errors")
const dotenv = require('dotenv')
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger-output.json');

// get config vars
dotenv.config()

// access config var
process.env.TOKEN_SECRET


//Middlewares
app.use(cors())
app.use(bodyParser.json())

//Import Routes
const api = require("./routes/api")
const chargers = require("./routes/chargers")
const users = require("./routes/users")

app.use("/", api)
app.use("/chargers", chargers)
app.use("/users", users)

// Swagger cofiguration
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

//Error handling
app.use((req, res, next) => {
  next(createError(404))
})

app.use((error, req, res, next) => {
  const status = error.status || 500
  console.error('Status:', status, 'Message:', error.message)
  res.status(status)
  res.json({
    status: error.status,
    message: error.message,
    stack: error.stack
  })
})

//App port setup
app.listen(3000)
