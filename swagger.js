const swaggerAutogen = require('swagger-autogen')()

const doc = {
  info: {
    version: '1.0.0',
    title: 'Wallbox Challenge',
    description: 'Wallbox Challenge API Rest demo',
  },
  host: 'localhost:3000',
  basePath: '/',
  schemes: ['http'],
}

const outputFile = './swagger-output.json'
const endpointsFiles = ['./app.js']

/* NOTE: if you use the express Router, you must pass in the 
   'endpointsFiles' only the root file where the route starts,
   such as: index.js, app.js, routes.js, ... */

swaggerAutogen(outputFile, endpointsFiles, doc).then(() => {
  require('./app.js') // Your project's root file
})
