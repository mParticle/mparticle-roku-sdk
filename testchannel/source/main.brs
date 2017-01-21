function main(args as dynamic)
    options = {}
    options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
    mParticleStart(args, "REPLACE WITH API KEY", "REPLACE WITH API SECRET", options)
    mparticle().setUserIdentity(mparticleConstants().IDENTITY_TYPE.EMAIL, "user@example.com")
    mparticle().setUserAttribute("hair color", "brown")
    mparticle().logEvent("hello world")
end function