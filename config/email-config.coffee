throw new Error "'EMAIL_PASSWORD' required" if not process.env.EMAIL_PASSWORD

config = {
  "user": "loja@pilateslovers.com.br"
  "password": process.env.EMAIL_PASSWORD
  "host": "smtp.gmail.com"
  "ssl": true
}

module.exports = config