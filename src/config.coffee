exports.token =
    expiresIn: 3600
    calculateExpirationDate: ->
        new Date((new Date).getTime() + @expiresIn * 1000)
    authorizationCodeLength: 16
    accessTokenLength: 256
    refreshTokenLength: 256

exports.session =
    type: 'MemoryStore'
    maxAge: 3600000 * 24 * 7 * 52
    secret: 'dskuyvbeycqh84h864rwufgg347fg1h3duihiwg13784dhpwdguy4190ehd'
    dbName: 'Session'
