function TestSuite__mParticle() as object
    this = BaseTestSuite()
    this.Name = "mParticleTestSuite"
    this.addTest("TestCase__mParticle_CheckConfiguration", TestCase__mParticle_CheckConfiguration)
    this.addTest("TestCase__mParticle_CheckDefaultEnvironment", TestCase__mParticle_CheckDefaultEnvironment)
    this.addTest("TestCase__mParticle_CheckSetEnvironment", TestCase__mParticle_CheckSetEnvironment)
    this.addTest("TestCase__mParticle_TestSetUserIdentity", TestCase__mParticle_TestSetUserIdentity)

    this.SetUp = mParticleTestSuite__SetUp
    this.TearDown = mParticleTestSuite__TearDown
    return this
end function

sub mParticleTestSuite__SetUp()
end sub

sub mParticleTestSuite__TearDown()
end sub

function reset()
    getGlobalAA().mparticleInstance = invalid
end function

function TestCase__mParticle_CheckConfiguration() as string
    reset()
    options = {}
    options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
    options.apiKey = "fookey"
    options.apiSecret = "foosecret"
    options.isscenegraph = true
    mparticlestart(options)
    msgs = []
    msgs.push(m.assertEqual(mparticle()._internal.configuration.apiKey, "fookey"))
    msgs.push(m.assertEqual(mparticle()._internal.configuration.apiSecret, "foosecret"))
    msgs.push(m.assertEqual(mparticle()._internal.configuration.logLevel, mparticleConstants().LOG_LEVEL.DEBUG))
    msgs.push(m.assertTrue(mparticle()._internal.configuration.isscenegraph))
    return testResult(msgs)
end function

function TestCase__mParticle_CheckDefaultEnvironment() as string
    reset()
    options = {}
    mparticlestart(options)
    msgs = []
    msgs.push(m.assertTrue(mparticle()._internal.configuration.development))
    return testResult(msgs)
end function

function TestCase__mParticle_CheckSetEnvironment() as string
    reset()
    options = {}
    options.environment = mParticleConstants().ENVIRONMENT.FORCE_DEVELOPMENT
    mparticlestart(options)
    msgs = []
    msgs.push(m.assertTrue(mparticle()._internal.configuration.development))
    return testResult(msgs)
end function

function TestCase__mParticle_TestSetUserIdentity() as string 
    reset()
    options = {}
    mparticlestart({})
    mp =  mparticle()
    mp._internal.storage.clear()
    mp.setuseridentity(mparticleConstants().IDENTITY_TYPE.CUSTOMER_ID, "foo-customer-id")
    identity = mparticle()._internal.storage.getUserIdentities().lookup(mparticleConstants().IDENTITY_TYPE.CUSTOMER_ID)
    msgs = []
    msgs.push(m.assertEqual(identity.n, mparticleConstants().IDENTITY_TYPE.CUSTOMER_ID))
    msgs.push(m.assertEqual(identity.i, "foo-customer-id"))
    return testResult(msgs)
end function

function testResult(msgs as object) as string
    endMessage = []
    for each msg in msgs
        if (len(msg) > 0)
            endMessage.push(msg)
        end if
    end for
    if (endMessage.count() > 0)
        return formatjson(endmessage)
    end if
    return ""
end function
