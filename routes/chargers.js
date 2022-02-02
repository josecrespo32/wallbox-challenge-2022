const express = require("express")
const router = express.Router()
const { param, body } = require('express-validator')
const { checkErrors } = require("../utils/validators")
const ash = require("express-async-handler")
const db = require("../db")
const { ulid } = require("ulid")
const { authenticateToken, shouldBeAdmin, userOverCharger } = require("../middlewares/mwAuth")
const createError = require("http-errors")
const { uidChargerExists, uidUserExists, serialNumberDoesntExist } = require("../middlewares/mwParams")

router.get('/', authenticateToken, ash(async (req, res) => {
  if (req.tokenPayload.role === 'admin') {
    res.status(200).send({chargers: db.Chargers})
  } else {
    const uid = req.tokenPayload.uid
    res.status(200).send({
      chargers: db.Chargers.filter(
        charger => charger.users && charger.users.find(user => user.uid === uid)
      )
    })
  }
}))

router.post('/', authenticateToken, shouldBeAdmin, 
  body('serialNumber').notEmpty().isNumeric().toInt(),
  body('model').notEmpty().isString().isIn(['Pulsar Plus', 'Commander', 'Quasar']),
  checkErrors, serialNumberDoesntExist, 
  ash(async (req, res) => {
    const charger = {
      uid: ulid(),
      serialNumber: req.body.serialNumber,
      model: req.body.model,
    }
    db.Chargers.push(charger)
    res.status(200).send({message: 'Charger registered', charger: charger})
  })
)

router.put('/:uidcharger', authenticateToken, shouldBeAdmin, 
  param('uidcharger').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  body('serialNumber').optional().notEmpty().isNumeric().toInt(),
  body('model').optional().notEmpty().isString().isIn(['Pulsar Plus', 'Commander', 'Quasar']),
  checkErrors, uidChargerExists, serialNumberDoesntExist, 
  ash(async (req, res) => {
    const charger = db.findCharger(req.params.uidcharger)
    charger.serialNumber = req.body.serialNumber || charger.serialNumber
    charger.model = req.body.model || charger.model
    res.status(200).send({message: 'Charger updated', charger: charger})
  })
)

router.delete('/:uidcharger', authenticateToken, shouldBeAdmin, 
  param('uidcharger').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  checkErrors, uidChargerExists, 
  ash(async (req, res) => {
    db.Chargers = db.Chargers.filter(charger => charger.uid !== req.params.uidcharger)
    res.status(204).send()
  })
)

router.get('/:uidcharger', authenticateToken, 
  param('uidcharger').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  checkErrors, uidChargerExists, userOverCharger, 
  ash(async (req, res) => {
    res.status(200).send(db.findCharger(req.params.uidcharger))
  })
)

router.post('/:uidcharger/users/:uiduser', authenticateToken, shouldBeAdmin,
  param('uidcharger').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  param('uiduser').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  checkErrors, uidChargerExists, uidUserExists, 
  ash(async (req, res) => {
    const uidCharger = req.params.uidcharger
    const uidUser = req.params.uiduser
    const charger = db.findCharger(uidCharger)
    charger.users = charger.users || []
    if (charger.users.find(user => user.uid === uidUser)) {
      throw createError(403, 'User already has access to charger')
    }
    const user = db.findUser(uidUser)
    charger.users.push(user)
    res.status(200).send({message: 'Allowed user to access charger', charger: charger})
  }) 
)

router.delete('/:uidcharger/users/:uiduser', authenticateToken, shouldBeAdmin,
  param('uidcharger').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  param('uiduser').isString().isLength({min:26, max:26}).isAlphanumeric().isUppercase(),
  checkErrors, uidChargerExists, uidUserExists, 
  ash(async (req, res) => {
    const uidCharger = req.params.uidcharger
    const uidUser = req.params.uiduser
    const charger = db.findCharger(uidCharger)
    charger.users = charger.users || []
    if (charger.users.find(user => user.uid !== uidUser)) {
      throw createError(403, 'User has not access to charger yet')
    }
    charger.users = charger.users.filter(user => user.uid !== uidUser)
    res.status(200).send({message: 'Removed charger access from user', charger: charger})
  })
)

module.exports = router
