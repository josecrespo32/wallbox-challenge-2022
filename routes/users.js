const express = require("express")
const router = express.Router()
const { param, body } = require('express-validator')
const { checkErrors, checkConfirmPassword, checkConfirmEmail } = require("../utils/validators")
const ash = require("express-async-handler")
const db = require("../db")
const { projectUser } = require("../utils/proyections")
const { ulid } = require("ulid")
const { shouldBeAdmin, authenticateToken, userOverUser } = require("../middlewares/mwAuth")
const { uidUserExists, userEmailDoesntExist } = require("../middlewares/mwParams")

router.get('/', authenticateToken, ash(async (req, res) => {
  if (req.tokenPayload.role === 'admin') {
    res.status(200).send({users: db.Users.map(user => projectUser(user))})
  } else {
    res.status(200).send({users: db.Users.filter(user => user.uid === req.tokenPayload.uid)})
  }
}))

router.post('/', authenticateToken, shouldBeAdmin, 
  body('emailConfirmation').notEmpty().isString().isEmail().normalizeEmail(),
  body('email').notEmpty().isString().isEmail().normalizeEmail().custom(checkConfirmEmail),
  body('passwordConfirmation').notEmpty().isString().isAlphanumeric().isLength({min:8}),
  body('password').notEmpty().isString().isAlphanumeric().isLength({min:8}).custom(checkConfirmPassword),
  body('role').notEmpty().isString().isIn(['user', 'admin']),
  checkErrors, userEmailDoesntExist, 
  ash(async (req, res) => {
    const user = {
      uid: ulid(),
      email: req.body.email,
      password: req.body.password,
      role: req.body.role,
    }
    db.Users.push(user)
    res.status(200).send({message: 'User registered', user: projectUser(user)})
  })
)

router.put('/:uiduser', authenticateToken, 
  param('uiduser').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  body('email').optional().notEmpty().isString().isEmail().normalizeEmail(),
  body('password').optional().notEmpty().isString().isAlphanumeric().isLength({min:8}),
  body('role').optional().notEmpty().isString().isIn(['user', 'admin']),
  checkErrors, uidUserExists, userEmailDoesntExist, userOverUser, 
  ash(async (req, res) => {
    const user = db.findUser(req.params.uiduser)
    user.email = req.body.email || user.email
    user.password = req.body.password || user.password
    user.role = req.body.role || user.role
    res.status(200).send({message: 'User updated', user: projectUser(user)})
  })
)

router.delete('/:uiduser', authenticateToken, shouldBeAdmin, 
  param('uiduser').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  checkErrors, uidUserExists, userOverUser, 
  ash(async (req, res) => {
    db.Users = db.Users.filter(user => user.uid !== req.params.uiduser)
    res.status(204).send()
  })
)

router.get('/:uiduser', authenticateToken, 
  param('uiduser').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  checkErrors, uidUserExists, userOverUser, 
  ash(async (req, res) => {
    res.status(200).send(projectUser(db.findUser(req.params.uiduser)))
  })
)

module.exports = router
