sub init()
    m.top.setFocus(true)
   
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode","mParticleTask")
    m.mParticleTask.ObserveField("identityResult", "onIdentityResult")
    m.mParticleTask.ObserveField("currentUser", "onCurrentUserChanged")
    m.mparticle = mParticleSGBridge(m.mParticleTask)
    mpConstants = mparticleconstants()
    identityApiRequest = {}
    identityApiRequest.userIdentities = {}
    identityApiRequest.userIdentities[mpConstants.IDENTITY_TYPE.EMAIL] = "user-2@example.com"
    m.mparticle.identity.login(identityApiRequest)
    m.mparticle.logEvent("hello world!")
    m.mparticle.identity.setUserAttribute("example attribute key", "example attribute value")
    m.mparticle.logScreenEvent("hello screen!")
    
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
    'Set the font size
    m.myLabel = m.top.findNode("myLabel")
    m.myLabel.font.size=92

    'Set the color to light blue
    m.myLabel.color="0x72D7EEFF"
end sub

function onIdentityResult() as void
    print "IdentityResult: " + formatjson(m.mParticleTask.identityResult)
end function

function onCurrentUserChanged() as void
    print "Current user: " + formatjson(m.mParticleTask.currentUser)
    m.mparticle.logEvent("User Changed", mparticleconstants().CUSTOM_EVENT_TYPE.USER_CONTENT, m.mParticleTask.currentUser)
end function