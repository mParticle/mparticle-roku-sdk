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
    this.addTest("TestCase__AdBreakExclusionDisabledDoesNotPauseContentTime", TestCase__AdBreakExclusionDisabledDoesNotPauseContentTime)
    this.addTest("TestCase__AdBreakExclusionEnabledExcludesAdTime", TestCase__AdBreakExclusionEnabledExcludesAdTime)
    this.addTest("TestCase__AdBreakExclusionEnabledDoesNotResumeIfContentAlreadyPaused", TestCase__AdBreakExclusionEnabledDoesNotResumeIfContentAlreadyPaused)

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

' Helper function to simulate milliseconds difference for time-based tests
function assertApproximately(actual as dynamic, expected as dynamic, tolerance as dynamic, message = "" as string) as string
    actualNum = val(str(actual).trim())
    expectedNum = val(str(expected).trim())
    toleranceNum = val(str(tolerance).trim())
    diff = abs(actualNum - expectedNum)
    if diff <= toleranceNum then return ""
    errorMsg = str(actual) + " is not approximately " + str(expected) + " (tolerance: " + str(tolerance) + ")"
    if len(message) > 0 then
        errorMsg = message + " - " + errorMsg
    end if
    return errorMsg
end function

' Test: Ad break exclusion disabled does not pause content time
' When excludeAdBreaksFromContentTime = false, ad break time IS included in content time
function TestCase__AdBreakExclusionDisabledDoesNotPauseContentTime() as string
    reset()
    options = {}
    options.apiKey = "test-key"
    options.apiSecret = "test-secret"
    port = CreateObject("roMessagePort")
    mparticlestart(options, port)
    
    mpConstants = mparticleConstants()
    ' Create media session with excludeAdBreaksFromContentTime = false
    mediaSession = mpConstants.MediaSession.build("test-content-id", "Test Title", mpConstants.MEDIA_CONTENT_TYPE.VIDEO, mpConstants.MEDIA_STREAM_TYPE.ON_DEMAND, 180000, {}, false)
    
    msgs = []
    
    ' Initial content time should be 0
    msgs.push(assertEqualValue(mediaSession.storedPlaybackTime, 0))
    
    ' Start content playback (simulate 0.2s = 200ms before ad break)
    mediaSession.currentPlaybackStartTimestamp = 1000
    mediaSession.playbackState = "playing"
    msgs.push(m.assertNotInvalid(mediaSession.currentPlaybackStartTimestamp, "currentPlaybackStartTimestamp should be set"))
    
    ' Simulate 200ms passing - calculate content time
    currentTime = 1200
    contentTimeSpent = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    msgs.push(assertApproximately(contentTimeSpent, 200, 10, "Content time should be ~200ms after 0.2s"))
    
    ' Start ad break - with flag disabled, playback should continue
    ' (no pause of content time tracking)
    msgs.push(m.assertEqual(mediaSession.playbackState, "playing", "Playback state should remain playing"))
    msgs.push(m.assertTrue(mediaSession.currentPlaybackStartTimestamp > 0, "currentPlaybackStartTimestamp should still be set"))
    
    ' Simulate another 200ms during ad break
    currentTime = 1400
    contentTimeSpent = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    msgs.push(assertApproximately(contentTimeSpent, 400, 10, "Content time should include ad break time (~400ms)"))
    
    ' End ad break
    mediaSession.adBreak = invalid
    
    ' Pause playback
    mediaSession.storedPlaybackTime = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    mediaSession.currentPlaybackStartTimestamp = 0
    mediaSession.playbackState = "pausedByUser"
    
    msgs.push(assertApproximately(mediaSession.storedPlaybackTime, 400, 10, "Stored playback time should be ~400ms"))
    msgs.push(assertEqualValue(mediaSession.currentPlaybackStartTimestamp, 0))
    
    return testResult(msgs)
end function

' Test: Ad break exclusion enabled excludes ad time from content time
' When excludeAdBreaksFromContentTime = true, ad break time is NOT included
function TestCase__AdBreakExclusionEnabledExcludesAdTime() as string
    reset()
    options = {}
    options.apiKey = "test-key"
    options.apiSecret = "test-secret"
    port = CreateObject("roMessagePort")
    mparticlestart(options, port)
    
    mpConstants = mparticleConstants()
    ' Create media session with excludeAdBreaksFromContentTime = true
    mediaSession = mpConstants.MediaSession.build("test-content-id", "Test Title", mpConstants.MEDIA_CONTENT_TYPE.VIDEO, mpConstants.MEDIA_STREAM_TYPE.ON_DEMAND, 180000, {}, true)
    
    msgs = []
    
    ' Initial state
    msgs.push(assertEqualValue(mediaSession.storedPlaybackTime, 0))
    msgs.push(m.assertTrue(mediaSession.excludeAdBreaksFromContentTime, "excludeAdBreaksFromContentTime should be true"))
    
    ' Start content playback
    mediaSession.currentPlaybackStartTimestamp = 1000
    mediaSession.playbackState = "playing"
    msgs.push(m.assertNotInvalid(mediaSession.currentPlaybackStartTimestamp, "currentPlaybackStartTimestamp should be set"))
    
    ' Simulate 200ms of content playback
    currentTime = 1200
    contentTimeSpent = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    msgs.push(assertApproximately(contentTimeSpent, 200, 10, "Content time should be ~200ms"))
    
    ' Start ad break - content time should pause and be stored
    mediaSession.storedPlaybackTime = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    mediaSession.currentPlaybackStartTimestamp = 0
    mediaSession.playbackState = "pausedByAdBreak"
    
    msgs.push(assertApproximately(mediaSession.storedPlaybackTime, 200, 10, "Stored time should capture 200ms"))
    msgs.push(assertEqualValue(mediaSession.currentPlaybackStartTimestamp, 0))
    msgs.push(m.assertEqual(mediaSession.playbackState, "pausedByAdBreak", "Playback state should be pausedByAdBreak"))
    
    ' Simulate 200ms during ad break - content time should NOT increase
    currentTime = 1400
    contentTimeSpent = mediaSession.storedPlaybackTime ' No active tracking during ad
    msgs.push(assertApproximately(contentTimeSpent, 200, 10, "Content time should still be ~200ms (not increased during ad)"))
    
    ' End ad break - auto-resume content tracking
    mediaSession.currentPlaybackStartTimestamp = currentTime
    mediaSession.playbackState = "playing"
    
    msgs.push(m.assertNotInvalid(mediaSession.currentPlaybackStartTimestamp, "currentPlaybackStartTimestamp should be set after ad break"))
    msgs.push(m.assertEqual(mediaSession.playbackState, "playing", "Playback state should be playing"))
    msgs.push(m.assertInvalid(mediaSession.adBreak, "adBreak should be cleared"))
    
    ' Simulate 200ms more content after ad
    currentTime = 1600
    contentTimeSpent = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    msgs.push(assertApproximately(contentTimeSpent, 400, 10, "Content time should be ~400ms (200ms before + 200ms after ad)"))
    
    ' Watch another 200ms
    currentTime = 1800
    ' Pause
    mediaSession.storedPlaybackTime = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    mediaSession.currentPlaybackStartTimestamp = 0
    mediaSession.playbackState = "pausedByUser"
    
    msgs.push(assertApproximately(mediaSession.storedPlaybackTime, 600, 10, "Final content time should be ~600ms (excluding 200ms ad break)"))
    msgs.push(assertEqualValue(mediaSession.currentPlaybackStartTimestamp, 0))
    
    return testResult(msgs)
end function

' Test: Ad break exclusion enabled does not resume if content already paused
' If user pauses before ad break, ad break end should NOT auto-resume
function TestCase__AdBreakExclusionEnabledDoesNotResumeIfContentAlreadyPaused() as string
    reset()
    options = {}
    options.apiKey = "test-key"
    options.apiSecret = "test-secret"
    port = CreateObject("roMessagePort")
    mparticlestart(options, port)
    
    mpConstants = mparticleConstants()
    ' Create media session with excludeAdBreaksFromContentTime = true
    mediaSession = mpConstants.MediaSession.build("test-content-id", "Test Title", mpConstants.MEDIA_CONTENT_TYPE.VIDEO, mpConstants.MEDIA_STREAM_TYPE.ON_DEMAND, 180000, {}, true)
    
    msgs = []
    
    ' Start content playback
    msgs.push(assertEqualValue(mediaSession.storedPlaybackTime, 0))
    mediaSession.currentPlaybackStartTimestamp = 1000
    mediaSession.playbackState = "playing"
    msgs.push(m.assertNotInvalid(mediaSession.currentPlaybackStartTimestamp, "currentPlaybackStartTimestamp should be set"))
    
    ' Simulate 200ms of content playback
    currentTime = 1200
    contentTimeSpent = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    msgs.push(assertApproximately(contentTimeSpent, 200, 10, "Content time should be ~200ms"))
    
    ' User manually pauses BEFORE ad break starts
    mediaSession.storedPlaybackTime = mediaSession.storedPlaybackTime + (currentTime - mediaSession.currentPlaybackStartTimestamp)
    mediaSession.currentPlaybackStartTimestamp = 0
    mediaSession.playbackState = "pausedByUser"
    
    msgs.push(assertApproximately(mediaSession.storedPlaybackTime, 200, 10, "Stored time should be ~200ms"))
    msgs.push(assertEqualValue(mediaSession.currentPlaybackStartTimestamp, 0))
    msgs.push(m.assertEqual(mediaSession.playbackState, "pausedByUser", "Playback state should be pausedByUser"))
    
    ' Simulate 200ms passing (still paused)
    currentTime = 1400
    
    ' Start ad break (should NOT affect playback state when already paused by user)
    ' The logic should detect playbackState != "playing", so no state change
    msgs.push(m.assertEqual(mediaSession.playbackState, "pausedByUser", "Playback state should remain pausedByUser"))
    msgs.push(assertEqualValue(mediaSession.currentPlaybackStartTimestamp, 0))
    
    ' Simulate 200ms during ad break
    currentTime = 1600
    contentTimeSpent = mediaSession.storedPlaybackTime
    msgs.push(assertApproximately(contentTimeSpent, 200, 10, "Content time should still be ~200ms (paused)"))
    
    ' End ad break - should NOT resume because user had paused
    ' (playbackState should still be pausedByUser, not pausedByAdBreak)
    mediaSession.adBreak = invalid
    
    msgs.push(m.assertInvalid(mediaSession.adBreak, "adBreak should be cleared"))
    msgs.push(assertEqualValue(mediaSession.currentPlaybackStartTimestamp, 0))
    msgs.push(m.assertEqual(mediaSession.playbackState, "pausedByUser", "Playback state should still be pausedByUser (no auto-resume)"))
    
    ' Simulate 200ms after ad break
    currentTime = 1800
    contentTimeSpent = mediaSession.storedPlaybackTime
    msgs.push(assertApproximately(contentTimeSpent, 200, 10, "Content time should still be ~200ms (no additional time accumulated)"))
    
    return testResult(msgs)
end function
