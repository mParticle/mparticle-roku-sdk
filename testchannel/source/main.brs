function main(args as dynamic)
    options = {}
    options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
    options.apiKey = "REPLACE WITH API KEY"
    options.apiSecret = "REPLACE WITH API SECRET"
    options.startupArgs = args
  
    mParticleStart(options)
    mparticle().setUserIdentity(mparticleConstants().IDENTITY_TYPE.EMAIL, "user@example.com")
    mparticle().setUserAttribute("hair color", "brown")
    mparticle().logEvent("hello world")
end function