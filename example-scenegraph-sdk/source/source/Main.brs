'*************************************************************
'** Hello World example
'** Copyright (c) 2015 Roku, Inc.  All rights reserved.
'** Use of the Roku Platform is subject to the Roku SDK License Agreement:
'** https://docs.roku.com/doc/developersdk/en-us
'*************************************************************

sub Main(args as dynamic)
    print "in showChannelSGScreen"
    'Indicate this is a Roku SceneGraph application'
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    'Create a scene and load /components/helloworld.xml'
    scene = screen.CreateScene("HelloWorld")

    options = {}
    options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
    options.apiKey = "REPLACE WITH API KEY"
    options.apiSecret = "REPLACE WITH API SECRET"
    'OPTIONAL: For use with our data master feature
    options.dataPlanId = "REPLACE WITH DATA PLAN ID"
    options.dataPlanVersion = 1 'REPLACE WITH DATA PLAN VERSION

    'If you know the users credentials, supply them here
    'otherwise the SDK will use the last known identities
    identityApiRequest = { userIdentities: {} }
    identityApiRequest.userIdentities[mparticleConstants().IDENTITY_TYPE.EMAIL] = "user@example.com"
    options.identifyRequest = identityApiRequest

    options.environment = mparticleConstants().ENVIRONMENT.FORCE_DEVELOPMENT
    options.startupArgs = args

    'REQUIRED: mParticle will look for mParticleOptions in the global node
    screen.getGlobalNode().addFields({ mparticleOptions: options })
    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub