' @BeforeAll
sub MainTestSuite__SetUp()
    ' Target testing object. To avoid the object creation in each test
    ' we create instance of target object here and use it in tests as m.targetTestObject.
    m.mParticleTask = createObject("roSGNode", "mParticleTask")
    m.mp = mParticleSGBridge(m.mParticleTask)
end sub

' @Test
function TestCase__ProductAction() as string
    sampleProduct = {}
    sampleProduct.id = "foo-product-sku"
    sampleProduct.nm = "foo-product-name"
    sampleProduct.pr = 123.45
    sampleProductAction = {
        an: actionApi.ACTION_TYPE.PURCHASE,
        tr: 123.45,
        pl: [sampleProduct]
    }

    mpConstants = mparticleConstants()
    product = mpConstants.Product.build("foo-product-sku", "foo-product-name", 123.45)
    productAction = mpConstants.ProductAction.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
    return m.AssertEqual(productAction, sampleProductAction)
end function

' @Test
function Test_SimpleCustom() as string
    m.mp.logEvent("example")
    return true
end function

' @Test
function Test_CustomNavigation() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.NAVIGATION, customAttributes)
    return true
end function

' @Test
function Test_CustomLocation() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.LOCATION, customAttributes)
    return true
end function

' @Test
function Test_CustomSearch() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.SEARCH, customAttributes)
    return true
end function

' @Test
function Test_CustomTransaction() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.TRANSACTION, customAttributes)
    return true
end function

' @Test
function Test_UserContent() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.USER_CONTENT, customAttributes)
    return true
end function

' @Test
function Test_CustomUserPreference() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.USER_PREFERENCE, customAttributes)
    return true
end function

' @Test
function Test_CustomSocial() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.SOCIAL, customAttributes)
    return true
end function

' @Test
function Test_CustomOther() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes)
    return true
end function

' @Test
function Test_CustomMedia() as string
    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
    return true
end function

' @Test
function Test_Consent() as string
    time = CreateObject("roDateTime")

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
    customAttributes = { "example custom attribute": "example custom attribute value" }
    mediaSession = mpConstants.MediaSession.build("ABC123", "Space Pilot 3000", mparticleConstants().MEDIA_CONTENT_TYPE.VIDEO, mparticleConstants().MEDIA_STREAM_TYPE.LIVE_STREAM, 1800000)
    m.mp.media.logMediaSessionStart(mediaSession, customAttributes)

    test1 = m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.contenttype, "Video") and m.AssertEqual(mediaSession.currentplayheadposition, 0) and m.AssertEqual(mediaSession.title, "Space Pilot 3000")

    print ("Logging session after " + formatjson(test1) + " start: " + formatjson(mediaSession))

    segment = mpConstants.Segment.build("Chapter 1", 0, 183400)
    mediaSession.segment = segment
    m.mp.media.logSegmentStart(mediaSession, customAttributes)

    test2 = m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test2) + " segment start: " + formatjson(mediaSession))

    customAttributes = { "Source": "Auto Playback" }
    m.mp.media.logPlay(mediaSession, customAttributes)

    test3 = m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test3) + " play: " + formatjson(mediaSession))

    mediaSession.currentPlayheadPosition = 1000
    m.mp.media.logPlayheadPosition(mediaSession)

    test4 = m.AssertEqual(mediaSession.currentplayheadposition, 1000) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test4) + " playhead: " + formatjson(mediaSession))

    mediaSession.currentPlayheadPosition = 1900
    customAttributes = { "Source": "Player Controls" }
    m.mp.media.logPause(mediaSession, customAttributes)

    test5 = m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test5) + " pause: " + formatjson(mediaSession))

    adBreak = mpConstants.adBreak.build("XYZ123", "Gamer Ad Collection")
    adBreak.duration = 32000
    mediaSession.adBreak = adBreak
    m.mp.media.logAdBreakStart(mediaSession, {})

    test6 = m.AssertEqual(mediaSession.adBreak.id, "XYZ123") and m.AssertEqual(mediaSession.adBreak.title, "Gamer Ad Collection") and m.AssertEqual(mediaSession.adBreak.duration, 32000) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test6) + " adBreak start: " + formatjson(mediaSession))

    adContent = mpConstants.adContent.build("ABC890", "CP 2077 - Be Cool, Be Anything")
    adContent.duration = 16000
    adContent.position = 0
    adContent.campaign = "CP 2077 Preorder Push"
    mediaSession.adContent = adContent
    m.mp.media.logAdStart(mediaSession, {})

    test7 = m.AssertEqual(mediaSession.adContent.id, "ABC890") and m.AssertEqual(mediaSession.adContent.title, "CP 2077 - Be Cool, Be Anything") and m.AssertEqual(mediaSession.adContent.duration, 16000) and m.AssertEqual(mediaSession.adBreak.id, "XYZ123") and m.AssertEqual(mediaSession.adBreak.title, "Gamer Ad Collection") and m.AssertEqual(mediaSession.adBreak.duration, 32000) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test7) + " ad start: " + formatjson(mediaSession))

    customAttributes = { "click_timestamp_ms": 1593007533602 }
    m.mp.media.logAdClick(mediaSession, customAttributes)

    test8 = m.AssertEqual(mediaSession.adContent.id, "ABC890") and m.AssertEqual(mediaSession.adContent.title, "CP 2077 - Be Cool, Be Anything") and m.AssertEqual(mediaSession.adContent.duration, 16000) and m.AssertEqual(mediaSession.adBreak.id, "XYZ123") and m.AssertEqual(mediaSession.adBreak.title, "Gamer Ad Collection") and m.AssertEqual(mediaSession.adBreak.duration, 32000) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test8) + " ad click: " + formatjson(mediaSession))

    m.mp.media.logAdEnd(mediaSession, {})
    mediaSession.adContent = invalid

    test9 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak.id, "XYZ123") and m.AssertEqual(mediaSession.adBreak.title, "Gamer Ad Collection") and m.AssertEqual(mediaSession.adBreak.duration, 32000) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test9) + " ad end: " + formatjson(mediaSession))

    adContent2 = mpConstants.adContent.build("ABC543", "VtM: B2 - Own the night")
    adContent2.duration = 16000
    adContent2.position = 0
    adContent2.campaign = "VtM: Revival"
    mediaSession.adContent = adContent2
    m.mp.media.logAdStart(mediaSession, {})

    test10 = m.AssertEqual(mediaSession.adContent.id, "ABC543") and m.AssertEqual(mediaSession.adContent.title, "VtM: B2 - Own the night") and m.AssertEqual(mediaSession.adContent.duration, 16000) and m.AssertEqual(mediaSession.adBreak.id, "XYZ123") and m.AssertEqual(mediaSession.adBreak.title, "Gamer Ad Collection") and m.AssertEqual(mediaSession.adBreak.duration, 32000) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test10) + " ad start 2: " + formatjson(mediaSession))

    m.mp.media.logAdSkip(mediaSession, {})
    mediaSession.adContent = invalid

    test11 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak.id, "XYZ123") and m.AssertEqual(mediaSession.adBreak.title, "Gamer Ad Collection") and m.AssertEqual(mediaSession.adBreak.duration, 32000) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test11) + " ad skip: " + formatjson(mediaSession))

    m.mp.media.logAdBreakEnd(mediaSession, {})
    mediaSession.adBreak = invalid

    test12 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test12) + " adBreak end: " + formatjson(mediaSession))

    m.mp.media.logQoS(mediaSession, 120, 3, 1232133, 46, {})

    test13 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 1") and m.AssertEqual(mediaSession.segment.index, 0) and m.AssertEqual(mediaSession.segment.duration, 183400)
    print ("Logging session after " + formatjson(test13) + " QOS: " + formatjson(mediaSession))

    m.mp.media.logSegmentEnd(mediaSession, customAttributes)
    mediaSession.segment = invalid

    test14 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment, invalid)
    print ("Logging session after " + formatjson(test14) + " segment end: " + formatjson(mediaSession))

    segment2 = mpConstants.Segment.build("Chapter 2", 1, 17500)
    mediaSession.segment = segment2
    m.mp.media.logSegmentStart(mediaSession, customAttributes)

    test15 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 2") and m.AssertEqual(mediaSession.segment.index, 1) and m.AssertEqual(mediaSession.segment.duration, 17500)
    print ("Logging session after " + formatjson(test15) + " segment start 2: " + formatjson(mediaSession))

    m.mp.media.logSeekStart(mediaSession, 1900, customAttributes)

    test16 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 2") and m.AssertEqual(mediaSession.segment.index, 1) and m.AssertEqual(mediaSession.segment.duration, 17500)
    print ("Logging session after " + formatjson(test16) + " seek start: " + formatjson(mediaSession))

    m.mp.media.logSeekEnd(mediaSession, 45600, {})

    test17 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment.title, "Chapter 2") and m.AssertEqual(mediaSession.segment.index, 1) and m.AssertEqual(mediaSession.segment.duration, 17500)
    print ("Logging session after " + formatjson(test17) + " seek end: " + formatjson(mediaSession))

    m.mp.media.logSegmentSkip(mediaSession, customAttributes)
    mediaSession.segment = invalid

    test18 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment, invalid)
    print ("Logging session after " + formatjson(test18) + " segment skip: " + formatjson(mediaSession))

    m.mp.media.logBufferStart(mediaSession, 1200, 0.12, 45600, customAttributes)

    test19 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment, invalid)
    print ("Logging session after " + formatjson(test19) + " buffer start: " + formatjson(mediaSession))

    m.mp.media.logBufferEnd(mediaSession, 563300, 1.0, 45600, {})

    test20 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment, invalid)
    print ("Logging session after " + formatjson(test20) + " buffer end: " + formatjson(mediaSession))

    m.mp.media.logMediaContentEnd(mediaSession, customAttributes)

    test21 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment, invalid)
    print ("Logging session after " + formatjson(test21) + " media content End: " + formatjson(mediaSession))

    m.mp.media.logMediaSessionEnd(mediaSession, customAttributes)

    test22 = m.AssertEqual(mediaSession.adContent, invalid) and m.AssertEqual(mediaSession.adBreak, invalid) and m.AssertEqual(mediaSession.currentplayheadposition, 1900) and m.AssertEqual(mediaSession.contentid, "ABC123") and m.AssertEqual(mediaSession.title, "Space Pilot 3000") and m.AssertEqual(mediaSession.segment, invalid)
    print ("Logging session after " + formatjson(test22) + " End: " + formatjson(mediaSession))

    return test1 and test2 and test3 and test4 and test5 and test6 and test7 and test8 and test9 and test10 and test11 and test12 and test13 and test14 and test15 and test16 and test71 and test18 and test19 and test20 and test21 and test22
end function