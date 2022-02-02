const createError = require("http-errors");
const jsonwebtoken = require("jsonwebtoken");

module.exports.generateAccessToken = (userInfo) => {
  return jsonwebtoken.sign(userInfo, process.env.TOKEN_SECRET, { expiresIn: '3600s' });
}

module.exports.extractToken = (authHeader) => {
  const token = authHeader && authHeader.split(' ')[1]
  if (token == null) throw createError(401, 'Invalid token')
  return token
}
