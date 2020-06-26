' @BeforeAll
sub MainTestSuite__SetUp()
    ' Target testing object. To avoid the object creation in each test
    ' we create instance of target object here and use it in tests as m.targetTestObject.
    m.mParticleTask = createObject("roSGNode","mParticleTask")
    m.mp = mParticleSGBridge(m.mParticleTask)
end sub

' @Test
function TestCase__ProductAction() as String
    sampleProduct = {}
    sampleProduct.id = "foo-product-sku"
    sampleProduct.nm = "foo-product-name"
    sampleProduct.pr = 123.45
    sampleProductAction = {
        an  : actionApi.ACTION_TYPE.PURCHASE,
        tr  : 123.45,
        pl  : [sampleProduct]
    }
            
    mpConstants = mparticleConstants()
    product = mpConstants.Product.build("foo-product-sku", "foo-product-name", 123.45)
    productAction = mpConstants.ProductAction.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
    return m.AssertEqual(productAction, sampleProductAction)
end function

' @Test
function Test_SimpleCustom() as String
    m.mp.logEvent("example")
    return true
end function

' @Test
function Test_Consent() as String
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