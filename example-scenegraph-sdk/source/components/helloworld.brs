sub init()
    m.top.setFocus(true)
    
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode","mParticleTask")
    mp = mParticleSGBridge(m.mParticleTask)
    mp.setUserIdentity(mparticleConstants().IDENTITY_TYPE.EMAIL, "user2@example.com")
    mp.logEvent("hello world!")
    mp.setUserAttribute("example attribute key", "example attribute value")
    mp.logScreenEvent("hello screen!")
    mpConstants = mparticleconstants()
    product = mpConstants.ProductBuilder.create("foo-sku", "foo-name", 123.45)
    productAction = mpConstants.ProductActionBuilder.create(mpConstants.PRODUCT_ACTION_TYPE.PURCHASE, 123.45, [product])
    mp.logCommerceEvent(productAction)
    'Set the font size
    m.myLabel = m.top.findNode("myLabel")
    m.myLabel.font.size=92

    'Set the color to light blue
    m.myLabel.color="0x72D7EEFF"
end sub