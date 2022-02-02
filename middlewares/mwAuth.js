const createError = require("http-errors")
const jsonwebtoken = require("jsonwebtoken")
const { extractToken } = require("../utils/auth")
const ash = require('express-async-handler')
const db = require('../db')

module.exports.authenticateToken = ash((req, res, next) => {
  const token = extractToken(req.headers['authorization'])
  jsonwebtoken.verify(token, process.env.TOKEN_SECRET, (err, tokenPayload) => {
    if (err) throw createError(401, 'Could not verify token')
    req.tokenPayload = tokenPayload
    next()
  })
})

module.exports.shouldBeAdmin = ash((req, res, next) => {
  if (req.tokenPayload.role !== 'admin') {
    throw createError(401, 'Insufficient permissions')
  }
  next()
})

module.exports.userOverUser = ash((req, res, next) => {
  const actor = req.tokenPayload
  const target = db.findUser(req.params.uiduser)
  if (actor.role === 'admin' && target.role === 'admin' && actor.uid !== target.uid) {
    throw createError(403, 'Cannot access that resource')
  }
  if (actor.role === 'user' && target.uid !== actor.uid) {
    throw createError(403, 'Cannot access that resource')
  }
  next()
})

module.exports.userOverCharger = ash((req, res, next) => {
  const actor = req.tokenPayload
  const target = db.findCharger(req.params.uidcharger)
  if (actor.role === 'user' && !target.users) {
    throw createError(403, 'Cannot access that resource')
  }
  if (actor.role === 'user' && !target.users.find(user => user.uid === actor.uid)) {
    throw createError(403, 'Cannot access that resource')
  }
  next()
})
