const express = require("express")
const router = express.Router()
const ash = require('express-async-handler')
const { body } = require("express-validator")
const createError = require("http-errors")
const db = require('../db')
const { authenticateToken, shouldBeAdmin } = require("../middlewares/mwAuth")
const { generateAccessToken } = require("../utils/auth")
const { checkErrors } = require("../utils/validators")

router.get('/', ash(async (req, res) => {
  res.status(200).send({message: 'Wallbox Challenge API REST is up and running!'})
}))

router.post('/signin',
  body("email").notEmpty().isString().isEmail().normalizeEmail(),
  body("password").notEmpty().isString(),
  checkErrors,
  ash(async (req, res) => {
  const user = db.findUserByEmail(req.body.email)
  if (!user || user.password !== req.body.password) {
    throw createError(401, "Wrong email or password")
  }
  const jwt = generateAccessToken({
    uid: user.uid,
    email: user.email,
    role: user.role
  })
  res.status(200).send({uid: user.uid, email: user.email, jwt: jwt})
}))

module.exports = router
