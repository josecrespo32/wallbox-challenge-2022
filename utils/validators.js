const { validationResult } = require("express-validator")
const createError = require("http-errors")
const db = require('../db')

module.exports.checkErrors = function (req, res, next) {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() })
    } else {
        next()
    }
}

module.exports.checkConfirmEmail = (email, { req }) => {
    if (email !== req.body.emailConfirmation) {
      throw new Error("Email confirmation doesn't match");
    }
    return Promise.resolve()
}

module.exports.checkConfirmPassword = (password, { req }) => {
    if (password !== req.body.passwordConfirmation) {
      throw new Error("Password confirmation doesn't match");
    }
    return Promise.resolve()
}

module.exports.serialNumberShouldntExist = (serialNumber) => {
    if (db.existsChargerSerialNumber(serialNumber)) {
        throw createError(409, 'Serial number already in use')
    }
}

module.exports.chargerUidShouldExist = (uid) => {
    if (!db.existsChargerUid(uid)) {
        throw createError(404, 'Charger not found')
    }
}

module.exports.userUidShouldExist = (uid) => {
    if (!db.existsUserUid(uid)) {
        throw createError(404, 'User not found')
    }
}

module.exports.userEmailShouldntExist = (email) => {
    if (db.existsUserEmail(email)) {
        throw createError(409, 'Email already in use')
    }
}
