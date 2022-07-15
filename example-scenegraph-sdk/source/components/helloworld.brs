sub init()


    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode", "mParticleTask")
    m.mParticleTask.ObserveField(mParticleConstants().SCENEGRAPH_NODES.IDENTITY_RESULT_NODE, "onIdentityResult")
    m.mParticleTask.ObserveField(mParticleConstants().SCENEGRAPH_NODES.CURRENT_USER_NODE, "onCurrentUserChanged")
    m.mparticle = mParticleSGBridge(m.mParticleTask)
    mpConstants = mparticleconstants()
    m.mpidLabel = m.top.findNode("mpidLabel")
    m.userAttributesLabel = m.top.findNode("userAttributesLabel")
    m.userIdentitiesLabel = m.top.findNode("userIdentitiesLabel")
    m.emailTextEdit = m.top.findNode("emailTextEdit")
    m.emailTextEdit.setFocus(true)
    identityApiRequest = {}
    identityApiRequest.userIdentities = {}
    identityApiRequest.userIdentities[mpConstants.IDENTITY_TYPE.OTHER] = "foo"
    m.mparticle.identity.modify(identityApiRequest)
    identityApiRequest = {}
    identityApiRequest.userIdentities = {}
    identityApiRequest.userIdentities[mpConstants.IDENTITY_TYPE.OTHER] = "bar"
    m.mparticle.identity.modify(identityApiRequest)
    m.mparticle.logEvent("hello world!")
    m.mparticle.identity.setUserAttribute("example attribute key", "example attribute value 1")
    m.mparticle.identity.setUserAttribute("example attribute array", ["foo", "bar"])
    m.mparticle.identity.setUserAttribute("example attribute key", "example attribute value 2")
    m.mparticle.identity.setUserAttribute("example attribute array", ["noo", "mar"])

    m.mparticle.logScreenEvent("hello screen!")

    time = CreateObject("roDateTime")

    consentStateAPI = mpConstants.ConsentState
    consentState = consentStateAPI.build()

    ' GDPR
    ' This portion is commented out because a workspace has to be configured for specific GDPR purposes (in this case, 'functional' and 'performance').
    ' If the purpose is not configured, events will not be accepted and not show up in the Live Stream.
    ' To test your own implementation, make sure you have a GDPR consent purpose activated on your workspace and update the purpose below.
    ' Similarly, CCPA (which does not require a purpose) must be configured on your workspace for events with a CCPA attached to work.
    'gdprConsentStateApi = mpConstants.GDPRConsentState
    'gdprConsentState = gdprConsentStateApi.build(False, time.asSeconds())

    'gdprConsentStateApi.setDocument(gdprConsentState, "document_agreement.v2")
    'gdprConsentStateApi.setLocation(gdprConsentState, "dtmgbank.com/signup")
    'gdprConsentStateApi.setHardwareId(gdprConsentState, "IDFA:a5d934n0-232f-4afc-2e9a-3832d95zc702")

    'consentStateAPI.addGDPRConsentState(consentState, "functional", gdprConsentState)

    ' For testing delete
    'gdprToDelete = gdprConsentStateApi.build(False, time.asSeconds())
    'gdprConsentStateApi.setDocument(gdprToDelete, "deletion_agreement")
    'gdprConsentStateApi.setLocation(gdprToDelete, "mparticle.test")
    'gdprConsentStateApi.setHardwareId(gdprToDelete, "TEST_HARDWARE_ID")

    'consentStateAPI.addGDPRConsentState(consentState, "performance", gdprToDelete)

    'print " --- Consent State with GDPR --- "
    'print formatjson(consentState)

    'print " --- Test Removing a GDPR Consent State --- "
    consentStateAPI.removeGDPRConsentState(consentState, "performance")
    consentStateAPI.removeGDPRConsentState(consentState, "functional")
    'print formatjson(consentState)

    ' CCPA
    'ccpaConsentStateApi = mpConstants.CCPAConsentState
    'ccpaToDelete = ccpaConsentStateApi.build(False, time.asSeconds())
    'ccpaConsentStateApi.setDocument(ccpaToDelete, "deletion_agreement")
    'ccpaConsentStateApi.setLocation(ccpaToDelete, "mparticle.test")
    'ccpaConsentStateApi.setHardwareId(ccpaToDelete, "TEST_HARDWARE_ID")

    'print ccpaToDelete

    'consentStateAPI.setCCPAConsentState(consentState, ccpaToDelete)

    'print " --- Consent State with CCPA --- "
    'print formatjson(consentState)

    'print " --- Test Removing CCPA Consent State --- "
    consentStateAPI.removeCCPAConsentState(consentState)
    'print formatjson(consentState)

    'ccpaConsentState = ccpaConsentStateApi.build(True, time.asSeconds())
    'print formatjson(ccpaConsentState)

    'ccpaConsentStateApi.setDocument(ccpaConsentState, "document_agreement.v4")
    'ccpaConsentStateApi.setLocation(ccpaConsentState, "mpbank.com/signup")
    'ccpaConsentStateApi.setHardwareId(ccpaConsentState, "IDFA:a5d934n0-232f-4afc-2e9a-3832d95zc702")

    'consentStateAPI.setCCPAConsentState(consentState, ccpaConsentState)

    'print " --- Add new CCPA Consent State --- "
    'print formatjson(consentState)

    'm.mparticle.identity.setConsentState(consentState)
    'print "--- Consent Test End ---"

    ' Commerce

    product = mpConstants.Product.build("foo-sku", "foo-name", 123.45)
    actionApi = mpConstants.ProductAction
    productAction = actionApi.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
    actionApi.setCheckoutStep(productAction, 5)
    actionApi.setCouponCode(productAction, "foo-coupon-code")
    actionApi.setShippingAmount(productAction, 33.42)

    promotionList = [mpConstants.Promotion.build("foo-id", "foo-name", "foo-creative", "foo-position")]
    promotionAction = mpConstants.PromotionAction.build(mpConstants.PromotionAction.ACTION_TYPE.VIEW, promotionList)

    impressions = [mpConstants.Impression.build("foo-list", [product])]
    m.mparticle.setSessionAttribute("foo attribute key", "bar attribute value")
    m.mparticle.logCommerceEvent(productAction, promotionAction, impressions, { "foo-attribute": "bar-attribute-value" })

    ' Custom Media Event

    customAttributes = { "example custom attribute": "example custom attribute value" }
    m.mparticle.logEvent("Custom Media Event", mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)

    ' Media API
    customAttributes = { "example custom attribute": "example custom attribute value" }
    mediaSession = mpConstants.MediaSession.build("ABC123", "Space Pilot 3000", mparticleConstants().MEDIA_CONTENT_TYPE.VIDEO, mparticleConstants().MEDIA_STREAM_TYPE.LIVE_STREAM, 1800000)
    m.mparticle.media.logMediaSessionStart(mediaSession, customAttributes)

    print ("Logging session after start: " + formatjson(mediaSession))

    segment = mpConstants.Segment.build("Chapter 1", 0, 183400)
    mediaSession.segment = segment
    mediaSession.mediaSessionSegmentTotal = 1
    mediaSession.currentPlayheadPosition = 0
    mediaSession.mediaContentTimeSpent = 0
    m.mparticle.media.logSegmentStart(mediaSession, customAttributes)

    print ("Logging session after segment start: " + formatjson(mediaSession))

    customAttributes = { "Source": "Auto Playback" }
    m.mparticle.media.logPlay(mediaSession, customAttributes)

    print ("Logging session after play: " + formatjson(mediaSession))

    mediaSession.currentPlayheadPosition = 1000
    mediaSession.mediaContentTimeSpent = 1000
    m.mparticle.media.logPlayheadPosition(mediaSession)

    print ("Logging session after playhead: " + formatjson(mediaSession))

    mediaSession.currentPlayheadPosition = 1900
    mediaSession.mediaContentTimeSpent = 1900
    customAttributes = { "Source": "Player Controls" }
    m.mparticle.media.logPause(mediaSession, customAttributes)

    print ("Logging session after pause: " + formatjson(mediaSession))

    adBreak = mpConstants.adBreak.build("XYZ123", "Gamer Ad Collection")
    adBreak.duration = 32000
    mediaSession.adBreak = adBreak
    m.mparticle.media.logAdBreakStart(mediaSession, {})

    print ("Logging session after adBreak start: " + formatjson(mediaSession))

    adContent = mpConstants.adContent.build("ABC890", "CP 2077 - Be Cool, Be Anything")
    adContent.duration = 16000
    adContent.position = 0
    adContent.campaign = "CP 2077 Preorder Push"
    mediaSession.adContent = adContent
    mediaSession.mediaSessionAdTotal = 1
    mediaSession.mediaSessionAdObjects.push(adContent.id)
    mediaSession.mediaContentTimeSpent = 1950
    m.mparticle.media.logAdStart(mediaSession, {})

    print ("Logging session after ad start: " + formatjson(mediaSession))

    customAttributes = { "click_timestamp_ms": 1593007533602 }
    mediaSession.adContent.position = 800
    mediaSession.mediaContentTimeSpent = 2750
    m.mparticle.media.logAdClick(mediaSession, customAttributes)

    print ("Logging session after ad click: " + formatjson(mediaSession))

    m.mparticle.media.logAdEnd(mediaSession, {})
    m.mparticle.media.logAdSummary(mediaSession, {})
    mediaSession.adContent = invalid

    print ("Logging session after ad end: " + formatjson(mediaSession))

    adContent2 = mpConstants.adContent.build("ABC543", "VtM: B2 - Own the night")
    adContent2.duration = 16000
    adContent2.position = 0
    adContent2.campaign = "VtM: Revival"
    mediaSession.adContent = adContent2
    mediaSession.mediaSessionAdTotal = 2
    mediaSession.mediaSessionAdObjects.push(adContent2.id)
    mediaSession.mediaContentTimeSpent = 3000
    m.mparticle.media.logAdStart(mediaSession, {})

    print ("Logging session after ad start 2: " + formatjson(mediaSession))

    mediaSession.adContent.position = 3000
    mediaSession.mediaContentTimeSpent = 6000
    m.mparticle.media.logAdSkip(mediaSession, {})
    m.mparticle.media.logAdSummary(mediaSession, {})
    mediaSession.adContent = invalid

    print ("Logging session after ad skip: " + formatjson(mediaSession))

    m.mparticle.media.logAdBreakEnd(mediaSession, {})
    mediaSession.adBreak = invalid

    print ("Logging session after adBreak end: " + formatjson(mediaSession))

    m.mparticle.media.logQoS(mediaSession, 120, 3, 1232133, 46, {})

    print ("Logging session after QOS: " + formatjson(mediaSession))

    m.mparticle.media.logSegmentEnd(mediaSession, customAttributes)
    m.mparticle.media.logSegmentSummary(mediaSession, customAttributes)
    mediaSession.segment = invalid

    print ("Logging session after segment end: " + formatjson(mediaSession))

    segment2 = mpConstants.Segment.build("Chapter 2", 1, 17500)
    mediaSession.segment = segment2
    mediaSession.mediaSessionSegmentTotal = 2
    m.mparticle.media.logSegmentStart(mediaSession, customAttributes)

    print ("Logging session after segment start 2: " + formatjson(mediaSession))

    m.mparticle.media.logSeekStart(mediaSession, 1900, customAttributes)

    print ("Logging session after seek start: " + formatjson(mediaSession))

    m.mparticle.media.logSeekEnd(mediaSession, 45600, {})

    print ("Logging session after seek end: " + formatjson(mediaSession))

    m.mparticle.media.logSegmentSkip(mediaSession, customAttributes)
    m.mparticle.media.logSegmentSummary(mediaSession, customAttributes)
    mediaSession.segment = invalid

    print ("Logging session after segment skip: " + formatjson(mediaSession))

    m.mparticle.media.logBufferStart(mediaSession, 1200, 0.12, 45600, customAttributes)

    print ("Logging session after buffer start: " + formatjson(mediaSession))

    m.mparticle.media.logBufferEnd(mediaSession, 563300, 1.0, 45600, {})

    print ("Logging session after buffer end: " + formatjson(mediaSession))

    mediaSession.mediaContentComplete = true
    m.mparticle.media.logMediaContentEnd(mediaSession, customAttributes)

    print ("Logging session after media content End: " + formatjson(mediaSession))

    m.mparticle.media.logMediaSessionEnd(mediaSession, customAttributes)
    m.mparticle.media.logMediaSessionSummary(mediaSession, customAttributes)


    print ("Logging session after End: " + formatjson(mediaSession))

    appInfo = CreateObject("roAppInfo")
    if appInfo.IsDev() and Type(TestRunner) <> "<uninitialized>" and TestRunner <> invalid and GetInterface(TestRunner, "ifFunction") <> invalid then
        Runner = TestRunner()
        Runner.SetFunctions([
            TestCase__ProductAction
            Test_SimpleCustom
            Test_Consent
            Test_Media
        ])

        if args.IncludeFilter <> invalid
            Runner.SetIncludeFilter(args.IncludeFilter)
        end if

        if args.ExcludeFilter <> invalid
            Runner.SetExcludeFilter(args.ExcludeFilter)
        end if

        Runner.Logger.SetVerbosity(3)
        Runner.Logger.SetEcho(false)
        Runner.Logger.SetJUnit(false)
        Runner.SetFailFast(true)

        Runner.Run()
    end if
end sub

function onIdentityResult() as void
    print "IdentityResult: " + formatjson(m.mParticleTask[mParticleConstants().SCENEGRAPH_NODES.IDENTITY_RESULT_NODE])
end function

function onCurrentUserChanged() as void
    currentUser = m.mParticleTask[mParticleConstants().SCENEGRAPH_NODES.CURRENT_USER_NODE]
    print "Current user: " + formatjson(currentUser)
    m.mpidLabel.text = "MPID: " + currentUser.mpid
    m.userAttributesLabel.text = "User attributes: " + formatjson(currentUser.userAttributes)
    m.userIdentitiesLabel.text = "User identities: " + formatjson(currentUser.userIdentities)

    m.mparticle.logEvent("User Changed", mparticleconstants().CUSTOM_EVENT_TYPE.USER_CONTENT, currentUser)
end function
