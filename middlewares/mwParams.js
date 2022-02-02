const createError = require('http-errors')
const ash = require('express-async-handler')
const db = require('../db')

module.exports.uidChargerExists = ash((req, res, next) => {
  if (!db.existsChargerUid(req.params.uidcharger)) {
    throw createError(404, 'Charger not found')
  }
  next()
})

module.exports.uidUserExists = ash((req, res, next) => {
  if (!db.existsUserUid(req.params.uiduser)) {
    throw createError(404, 'User not found')
  }
  next()
})

module.exports.serialNumberDoesntExist = ash((req, res, next) => {
  if (db.existsChargerSerialNumber(req.body.serialNumber)) {
      throw createError(409, 'Serial number already in use')
  }
  next()
})

module.exports.userEmailDoesntExist = ash((req, res, next) => {
  if (db.existsUserEmail(req.body.email)) {
      throw createError(409, 'Email already in use')
  }
  next()
})
