sub init()
    
   
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode","mParticleTask")
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
    m.mparticle.logEvent("hello world!")
    m.mparticle.identity.setUserAttribute("example attribute key", "example attribute value")
    m.mparticle.identity.setUserAttribute("example attribute array", ["foo", "bar"])

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

    m.mparticle.identity.setConsentState(consentState)
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
    m.mparticle.logCommerceEvent(productAction, promotionAction, impressions, {"foo-attribute":"bar-attribute-value"})
    
    if APPInfo.IsDev() and args.RunTests = "true" and TF_Utils__IsFunction(TestRunner)
        Runner = TestRunner()
        Runner.SetFunctions([
            TestCase__ProductAction
            Test_SimpleCustom
            Test_Consent
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
