sub init()
    m.top.setFocus(true)
    
  
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode","mParticleTask")
    mp = mParticleSGBridge(m.mParticleTask)
    mp.setUserIdentity(mparticleConstants().IDENTITY_TYPE.EMAIL, "user@example.com")
    mp.logEvent("hello world!")
    mp.setUserAttribute("example attribute key", "example attribute value")
    mp.logScreenEvent("hello screen!")
    mpConstants = mparticleconstants()
    product = mpConstants.Product.build("foo-sku", "foo-name", 123.45)
    actionApi = mpConstants.ProductAction
    productAction = actionApi.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
    actionApi.setCheckoutStep(productAction, 5)
    actionApi.setCouponCode(productAction, "foo-coupon-code")
    actionApi.setShippingAmount(productAction, 33.42)
    
    promotionList = [mpConstants.Promotion.build("foo-id", "foo-name", "foo-creative", "foo-position")]
    promotionAction = mpConstants.PromotionAction.build(mpConstants.PromotionAction.ACTION_TYPE.VIEW, promotionList)
    
    impressions = [mpConstants.Impression.build("foo-list", [product])]
    mp.setSessionAttribute("foo attribute key", "bar attribute value")
    mp.logCommerceEvent(productAction, promotionAction, impressions, {"foo-attribute":"bar-attribute-value"})
    'Set the font size
    m.myLabel = m.top.findNode("myLabel")
    m.myLabel.font.size=92

    'Set the color to light blue
    m.myLabel.color="0x72D7EEFF"
end sub