
module.exports.projectUser = (user) => {
  return {
    uid: user?.uid,
    email: user?.email,
    role: user?.role
  }
}
