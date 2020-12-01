db = db.getSiblingDB('sats')
db.createUser({
  user: "sushi",
  pwd: "supersecretsauce",
  roles: [{
    role: "readWrite",
    db: "sats"
  }]
})

db = db.getSiblingDB('admin')
db.shutdownServer()
