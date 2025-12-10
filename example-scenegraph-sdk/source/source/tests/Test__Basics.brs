'----------------------------------------------------------------
' Main test suite
'----------------------------------------------------------------
function TestSuite__main() as object
    ' Inherit from BaseTestSuite
    this = BaseTestSuite()
    this.Name = "MainTestSuite"

    ' Set up function - runs once before all tests
    this.SetUp = MainTestSuite__SetUp

    ' Add tests to this suite
    this.addTest("TestCase__ProductAction", TestCase__ProductAction)
    this.addTest("Test_SimpleCustom", Test_SimpleCustom)
    this.addTest("Test_CustomNavigation", Test_CustomNavigation)
    this.addTest("Test_CustomLocation", Test_CustomLocation)
    this.addTest("Test_CustomSearch", Test_CustomSearch)
    this.addTest("Test_CustomTransaction", Test_CustomTransaction)
    this.addTest("Test_UserContent", Test_UserContent)
    this.addTest("Test_CustomUserPreference", Test_CustomUserPreference)
    this.addTest("Test_CustomSocial", Test_CustomSocial)
    this.addTest("Test_CustomOther", Test_CustomOther)
    this.addTest("Test_CustomMedia", Test_CustomMedia)
    this.addTest("Test_Consent", Test_Consent)
    this.addTest("Test_Media", Test_Media)
    this.addTest("Test_MediaContentTimeTracking_WithAdBreakExclusion", Test_MediaContentTimeTracking_WithAdBreakExclusion)
    this.addTest("Test_MediaContentTimeTracking_WithoutAdBreakExclusion", Test_MediaContentTimeTracking_WithoutAdBreakExclusion)
    this.addTest("Test_MediaContentTimeTracking_PausedDuringAdBreak", Test_MediaContentTimeTracking_PausedDuringAdBreak)

    return this
end function

'----------------------------------------------------------------
' Test suite setup - runs once before all tests
'----------------------------------------------------------------
' @BeforeAll
sub MainTestSuite__SetUp()
    ' Initialize mParticle for tests
    print "Setting up mParticle for tests..."

    ' Target testing object. To avoid the object creation in each test
    ' we create instance of target object here and use it in tests as m.mp
    m.mParticleTask = createObject("roSGNode", "mParticleTask")
    m.mp = mParticleSGBridge(m.mParticleTask)

    print "Test suite setup complete - mParticle initialized"
end sub

' @Test
function TestCase__ProductAction() as string
    mpConstants = mparticleConstants()
    actionApi = mpConstants.ProductAction

    sampleProduct = {}
    sampleProduct.id = "foo-product-sku"
    sampleProduct.nm = "foo-product-name"
    sampleProduct.pr = 123.45
    sampleProductAction = {
        an: actionApi.ACTION_TYPE.PURCHASE,
        tr: 123.45,
        pl: [sampleProduct]
    }

    product = mpConstants.Product.build("foo-product-sku", "foo-product-name", 123.45)
    productAction = mpConstants.ProductAction.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
    return m.AssertEqual(productAction, sampleProductAction)
end function

' @Test
function Test_SimpleCustom() as string
    m.mp.logEvent("example")
    return ""
end function

' @Test
function Test_CustomNavigation() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.NAVIGATION, customAttributes)
    return ""
end function

' @Test
function Test_CustomLocation() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.LOCATION, customAttributes)
    return ""
end function

' @Test
function Test_CustomSearch() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.SEARCH, customAttributes)
    return ""
end function

' @Test
function Test_CustomTransaction() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.TRANSACTION, customAttributes)
    return ""
end function

' @Test
function Test_UserContent() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.USER_CONTENT, customAttributes)
    return ""
end function

' @Test
function Test_CustomUserPreference() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.USER_PREFERENCE, customAttributes)
    return ""
end function

' @Test
function Test_CustomSocial() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.SOCIAL, customAttributes)
    return ""
end function

' @Test
function Test_CustomOther() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes)
    return ""
end function

' @Test
function Test_CustomMedia() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
    return ""
end function

' @Test
function Test_Consent() as string
    time = CreateObject("roDateTime")
    mpConstants = mparticleConstants()

    gdprConsentState = {}
    gdprConsentState.c = False
    gdprConsentState.ts = time.asSeconds()
    gdprConsentState.d = "document_agreement.v2"
    gdprConsentState.l = "dtmgbank.com/signup"
    gdprConsentState.h = "IDFA:a5d934n0-232f-4afc-2e9a-3832d95zc702"

    consentStateAPI = mpConstants.ConsentState
    consentState = consentStateAPI.build()

    ' GDPR
    gdprConsentStateApi = mpConstants.GDPRConsentState
    gdprConsentState = gdprConsentStateApi.build(False, time.asSeconds())

    gdprConsentStateApi.setDocument(gdprConsentState, "document_agreement.v2")
    gdprConsentStateApi.setLocation(gdprConsentState, "dtmgbank.com/signup")
    gdprConsentStateApi.setHardwareId(gdprConsentState, "IDFA:a5d934n0-232f-4afc-2e9a-3832d95zc702")

    consentStateAPI.addGDPRConsentState(consentState, "functional", gdprConsentState)

    return m.AssertEqual(consentStateAPI.gdpr, gdprConsentState)
end function

' @Test
function Test_Media() as string
    ' This test exercises the media API methods to ensure they don't crash
    mpConstants = mparticleConstants()
    customAttributes = { "example custom attribute": "example custom attribute value" }
    mediaSession = mpConstants.MediaSession.build("ABC123", "Space Pilot 3000", mparticleConstants().MEDIA_CONTENT_TYPE.VIDEO, mparticleConstants().MEDIA_STREAM_TYPE.LIVE_STREAM, 1800000)
    m.mp.media.logMediaSessionStart(mediaSession, customAttributes)

    segment = mpConstants.Segment.build("Chapter 1", 0, 183400)
    mediaSession.segment = segment
    m.mp.media.logSegmentStart(mediaSession, customAttributes)


    customAttributes = { "Source": "Auto Playback" }
    m.mp.media.logPlay(mediaSession, customAttributes)


    mediaSession.currentPlayheadPosition = 1000
    m.mp.media.logPlayheadPosition(mediaSession)


    mediaSession.currentPlayheadPosition = 1900
    customAttributes = { "Source": "Player Controls" }
    m.mp.media.logPause(mediaSession, customAttributes)


    adBreak = mpConstants.adBreak.build("XYZ123", "Gamer Ad Collection")
    adBreak.duration = 32000
    mediaSession.adBreak = adBreak
    m.mp.media.logAdBreakStart(mediaSession, {})


    adContent = mpConstants.adContent.build("ABC890", "CP 2077 - Be Cool, Be Anything")
    adContent.duration = 16000
    adContent.position = 0
    adContent.campaign = "CP 2077 Preorder Push"
    mediaSession.adContent = adContent
    m.mp.media.logAdStart(mediaSession, {})


    customAttributes = { "click_timestamp_ms": 1593007533602 }
    m.mp.media.logAdClick(mediaSession, customAttributes)


    m.mp.media.logAdEnd(mediaSession, {})
    mediaSession.adContent = invalid


    adContent2 = mpConstants.adContent.build("ABC543", "VtM: B2 - Own the night")
    adContent2.duration = 16000
    adContent2.position = 0
    adContent2.campaign = "VtM: Revival"
    mediaSession.adContent = adContent2
    m.mp.media.logAdStart(mediaSession, {})


    m.mp.media.logAdSkip(mediaSession, {})
    mediaSession.adContent = invalid


    m.mp.media.logAdBreakEnd(mediaSession, {})
    mediaSession.adBreak = invalid


    m.mp.media.logQoS(mediaSession, 120, 3, 1232133, 46, {})


    m.mp.media.logSegmentEnd(mediaSession, customAttributes)
    mediaSession.segment = invalid


    segment2 = mpConstants.Segment.build("Chapter 2", 1, 17500)
    mediaSession.segment = segment2
    m.mp.media.logSegmentStart(mediaSession, customAttributes)


    m.mp.media.logSeekStart(mediaSession, 1900, customAttributes)


    m.mp.media.logSeekEnd(mediaSession, 45600, {})


    m.mp.media.logSegmentSkip(mediaSession, customAttributes)
    mediaSession.segment = invalid


    m.mp.media.logBufferStart(mediaSession, 1200, 0.12, 45600, customAttributes)


    m.mp.media.logBufferEnd(mediaSession, 563300, 1.0, 45600, {})


    m.mp.media.logMediaContentEnd(mediaSession, customAttributes)


    m.mp.media.logMediaSessionEnd(mediaSession, customAttributes)


    return ""
end function

' @Test
function Test_MediaContentTimeTracking_WithAdBreakExclusion() as string
    ' Test that content time tracking works correctly with ad break exclusion enabled
    mpConstants = mparticleConstants()

    ' Create media session with excludeAdBreaksFromContentTime = true
    mediaSession = mpConstants.MediaSession.build("test-id", "Test Content", mpConstants.MEDIA_CONTENT_TYPE.VIDEO, mpConstants.MEDIA_STREAM_TYPE.ON_DEMAND, 180000, {}, true)

    ' Verify initial state
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.AssertEqual(mediaSession.storedPlaybackTime, 0)
    m.AssertEqual(mediaSession.playbackState, "pausedByUser")

    ' Start playback - should set timestamp and playbackState
    m.mp.media.logPlay(mediaSession, {})
    m.assertTrue(mediaSession.currentPlaybackStartTimestamp > 0, "currentPlaybackStartTimestamp should be set after logPlay")
    m.AssertEqual(mediaSession.playbackState, "playing")

    ' Pause playback - should clear timestamp and store time
    m.mp.media.logPause(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.AssertEqual(mediaSession.playbackState, "pausedByUser")

    ' Resume playback
    m.mp.media.logPlay(mediaSession, {})
    m.assertTrue(mediaSession.currentPlaybackStartTimestamp > 0, "currentPlaybackStartTimestamp should be set after resume")
    m.AssertEqual(mediaSession.playbackState, "playing")

    ' Start ad break - should pause content time tracking
    adBreak = mpConstants.adBreak.build("ad-123", "Ad Break")
    mediaSession.adBreak = adBreak
    storedTimeBeforeAd = mediaSession.storedPlaybackTime
    m.mp.media.logAdBreakStart(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.AssertEqual(mediaSession.playbackState, "pausedByAdBreak")

    ' End ad break - should resume content time tracking
    m.mp.media.logAdBreakEnd(mediaSession, {})
    m.assertTrue(mediaSession.currentPlaybackStartTimestamp > 0, "currentPlaybackStartTimestamp should be set after ad break")
    m.AssertEqual(mediaSession.playbackState, "playing")

    ' End content - should finalize time tracking
    m.mp.media.logMediaContentEnd(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.assertTrue(mediaSession.mediaContentComplete)

    return ""
end function

' @Test
function Test_MediaContentTimeTracking_WithoutAdBreakExclusion() as string
    ' Test that content time tracking continues during ad breaks when exclusion is disabled
    mpConstants = mparticleConstants()

    ' Create media session with excludeAdBreaksFromContentTime = false
    mediaSession = mpConstants.MediaSession.build("test-id-2", "Test Content 2", mpConstants.MEDIA_CONTENT_TYPE.VIDEO, mpConstants.MEDIA_STREAM_TYPE.ON_DEMAND, 180000, {}, false)

    ' Verify initial state
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.AssertEqual(mediaSession.excludeAdBreaksFromContentTime, false)

    ' Start playback
    m.mp.media.logPlay(mediaSession, {})
    m.assertTrue(mediaSession.currentPlaybackStartTimestamp > 0)
    m.AssertEqual(mediaSession.playbackState, "playing")

    timestampBeforeAd = mediaSession.currentPlaybackStartTimestamp

    ' Start ad break - should NOT pause content time tracking (exclusion disabled)
    adBreak = mpConstants.adBreak.build("ad-456", "Ad Break 2")
    mediaSession.adBreak = adBreak
    m.mp.media.logAdBreakStart(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, timestampBeforeAd)
    m.AssertEqual(mediaSession.playbackState, "playing")

    ' End ad break - timestamp should remain unchanged
    m.mp.media.logAdBreakEnd(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, timestampBeforeAd)
    m.AssertEqual(mediaSession.playbackState, "playing")

    return ""
end function

' @Test
function Test_MediaContentTimeTracking_PausedDuringAdBreak() as string
    ' Test that ad break doesn't auto-resume if content was already paused
    mpConstants = mparticleConstants()

    ' Create media session with excludeAdBreaksFromContentTime = true
    mediaSession = mpConstants.MediaSession.build("test-id-3", "Test Content 3", mpConstants.MEDIA_CONTENT_TYPE.VIDEO, mpConstants.MEDIA_STREAM_TYPE.ON_DEMAND, 180000, {}, true)

    ' Start playback then pause
    m.mp.media.logPlay(mediaSession, {})
    m.mp.media.logPause(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.AssertEqual(mediaSession.playbackState, "pausedByUser")

    ' Start ad break while paused - should NOT change state
    adBreak = mpConstants.adBreak.build("ad-789", "Ad Break 3")
    mediaSession.adBreak = adBreak
    m.mp.media.logAdBreakStart(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.AssertEqual(mediaSession.playbackState, "pausedByUser")

    ' End ad break - should NOT auto-resume (user had paused)
    m.mp.media.logAdBreakEnd(mediaSession, {})
    m.AssertEqual(mediaSession.currentPlaybackStartTimestamp, 0)
    m.AssertEqual(mediaSession.playbackState, "pausedByUser")

    return ""
end function