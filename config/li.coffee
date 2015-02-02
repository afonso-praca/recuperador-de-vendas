throw new Error "'CHAVE_API' required" if not process.env.CHAVE_API
throw new Error "'CHAVE_APLICACAO' required" if not process.env.CHAVE_APLICACAO

liConfig =
  chave_api: process.env.CHAVE_API
  chave_aplicacao: process.env.CHAVE_APLICACAO

module.exports = liConfig