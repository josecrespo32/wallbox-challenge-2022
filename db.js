/**
 * Volatile database
 */

const { ulid } = require("ulid")

module.exports.Users = [
  {
    uid: ulid(),
    email: 'admin@wallbox.com',
    password: 'admin1234',
    role: 'admin'
  },
  {
    uid: ulid(),
    email: 'user@wallbox.com',
    password: 'user1234',
    role: 'user'
  }
]

module.exports.Chargers = []

module.exports.clear = () => {
  this.Users = []
  this.Chargers = []
}

module.exports.findCharger = (uidCharger) => {
  return this.Chargers.find(charger => charger.uid === uidCharger)
}

module.exports.findUser = (uid) => {
  return this.Users.find(user => user.uid === uid)
}

module.exports.findUserByEmail = (email) => {
  return this.Users.find(user => user.email === email)
}

module.exports.existsChargerUid = (uid) => {
  return this.Chargers.findIndex(charger => charger.uid === uid) > -1
}

module.exports.existsChargerSerialNumber = (serialNumber) => {
  return this.Chargers.findIndex(charger => charger.serialNumber === serialNumber) > -1
}

module.exports.existsUserUid = (uid) => {
  return this.Users.findIndex(user => user.uid === uid) > -1
}

module.exports.existsUserEmail = (email) => {
  return this.Users.findIndex(user => user.email === email) > -1
}
