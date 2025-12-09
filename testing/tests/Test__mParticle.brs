function TestSuite__mParticle() as object
    print "========================================="
    print "Loading mParticle Test Suite with Ad Break Exclusion Tests"
    print "========================================="
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

' Helper to compare values that may have type boxing issues (roInteger vs Integer)
function assertEqualValue(actual as dynamic, expected as dynamic) as string
    if str(actual).trim() = str(expected).trim() then return ""
    return str(actual) + " != " + str(expected)
end function

function TestCase__mParticle_CheckConfiguration() as string
    reset()
    options = {}
    options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
    options.apiKey = "fookey"
    options.apiSecret = "foosecret"
    options.dataPlanId = "fooId"
    options.dataPlanVersion = 1
    options.isscenegraph = true
    port = CreateObject("roMessagePort")
    mparticlestart(options, port)
    msgs = []
    msgs.push(m.assertEqual(mparticle()._internal.configuration.apiKey, "fookey"))
    msgs.push(m.assertEqual(mparticle()._internal.configuration.apiSecret, "foosecret"))
    msgs.push(m.assertEqual(mparticle()._internal.configuration.dataPlanId, "fooId"))
    msgs.push(assertEqualValue(mparticle()._internal.configuration.dataPlanVersion, 1))
    msgs.push(m.assertEqual(mparticle()._internal.configuration.logLevel, mparticleConstants().LOG_LEVEL.DEBUG))
    msgs.push(m.assertTrue(mparticle()._internal.configuration.isscenegraph))
    return testResult(msgs)
end function

function TestCase__mParticle_CheckDefaultEnvironment() as string
    reset()
    options = {}
    options.apiKey = "test-key"
    options.apiSecret = "test-secret"
    port = CreateObject("roMessagePort")
    mparticlestart(options, port)
    msgs = []
    msgs.push(m.assertTrue(mparticle()._internal.configuration.development))
    return testResult(msgs)
end function

function TestCase__mParticle_CheckSetEnvironment() as string
    reset()
    options = {}
    options.apiKey = "test-key"
    options.apiSecret = "test-secret"
    options.environment = mParticleConstants().ENVIRONMENT.FORCE_DEVELOPMENT
    port = CreateObject("roMessagePort")
    mparticlestart(options, port)
    msgs = []
    msgs.push(m.assertTrue(mparticle()._internal.configuration.development))
    return testResult(msgs)
end function

function TestCase__mParticle_TestSetUserIdentity() as string
    reset()
    options = {}
    options.apiKey = "test-key"
    options.apiSecret = "test-secret"
    port = CreateObject("roMessagePort")
    mparticlestart(options, port)
    mp = mparticle()
    mp._internal.storage.clear()
    currentMpid = mp._internal.storage.getCurrentMpid()
    mp._internal.storage.setUserIdentity(currentMpid, mparticleConstants().IDENTITY_TYPE.CUSTOMER_ID, "foo-customer-id")
    identity = mp._internal.storage.getUserIdentities(currentMpid)[mparticleConstants().IDENTITY_TYPE.CUSTOMER_ID]
    msgs = []
    msgs.push(assertEqualValue(identity.n, mparticleConstants().IDENTITY_TYPE_INT.CUSTOMER_ID))
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
