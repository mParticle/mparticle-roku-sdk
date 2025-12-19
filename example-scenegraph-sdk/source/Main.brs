sub Main(args as dynamic)
    print "in showChannelSGScreen"
    print "DEBUG: Main() full args dump:"
    print args

    ' Initialize RunUnitTests flag
    runTests = false

    ' Check if RunUnitTests is passed via contentId (ECP parameter passing)
    if args.contentId <> invalid then
        print "DEBUG: args.contentId = "; args.contentId
        if args.contentId = "RunUnitTests=true" then
            print "DEBUG: Setting RunUnitTests to true (from contentId)"
            runTests = true
        end if
    else
        print "DEBUG: args.contentId is invalid"
    end if

    ' Check if it's passed directly as a parameter (alternate ECP format)
    if args.RunUnitTests <> invalid then
        print "DEBUG: args.RunUnitTests was already set to: "; args.RunUnitTests
        if args.RunUnitTests = "true" or args.RunUnitTests = true then
            runTests = true
        end if
    end if

    ' DEPLOYMENT TEST MODE: Check if this is a fresh deployment auto-run
    ' We detect this by checking if the last run crashed (common after fresh deploy)
    ' AND we haven't run tests yet (tracked via registry)
    if not runTests and args.source <> invalid and args.source = "auto-run-dev" then
        registry = CreateObject("roRegistrySection", "mparticle-testing")
        lastTestRun = registry.Read("last_test_run")
        appInfo = CreateObject("roAppInfo")
        currentVersion = appInfo.GetVersion()

        print "DEBUG: Checking deployment test mode..."
        print "DEBUG: lastTestRun = "; lastTestRun
        print "DEBUG: currentVersion = "; currentVersion

        ' If we haven't run tests for this version yet, run them now
        if lastTestRun <> currentVersion then
            print "DEBUG: ✅ Fresh deployment detected - enabling tests"
            runTests = true
            ' Mark that we've run tests for this version
            registry.Write("last_test_run", currentVersion)
            registry.Flush()
        else
            print "DEBUG: Tests already run for this version"
        end if
    end if

    ' Set the final flag
    if runTests then
        args.RunUnitTests = "true"
        print "DEBUG: ✅ TESTS WILL RUN!"
    else
        args.RunUnitTests = invalid
        print "DEBUG: ❌ Tests will NOT run"
    end if

    'Indicate this is a Roku SceneGraph application'
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    if args.RunUnitTests = "true" then
        ' Set up mParticle options for tests BEFORE creating scene
        options = {}
        options.logLevel = mparticleConstants().LOG_LEVEL.NONE
        options.apiKey = "YOUR_API_KEY"
        options.apiSecret = "YOUR_API_SECRET"
        options.environment = mparticleConstants().ENVIRONMENT.FORCE_DEVELOPMENT
        options.startupArgs = args
        screen.getGlobalNode().addFields({ mparticleOptions: options })

        ' Create a minimal scene for tests so SceneGraph nodes are available
        scene = screen.CreateScene("Scene")
        screen.show()
    else
        'Create a scene and load /components/helloworld.xml'
        scene = screen.CreateScene("HelloWorld")

        options = {}
        options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
        options.apiKey = "YOUR_API_KEY"
        options.apiSecret = "YOUR_API_SECRET"
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
    end if

    ' Rooibos 4+ automatically handles test execution
    ' Tests will run automatically when the app is loaded in dev mode with RunUnitTests=true
    ' The framework discovers and runs tests based on the @suite, @describe, and @it annotations
    appInfo = CreateObject("roAppInfo")
    print "DEBUG: appInfo.IsDev() = " + appInfo.IsDev().ToStr()
    print "DEBUG: args.RunUnitTests = " + Box(args.RunUnitTests).ToStr()
    
    if appInfo.IsDev() and args.RunUnitTests = "true" then
        print "**********************************************************************"
        print "Rooibos 4+ Test Framework - Tests will run automatically"
        print "**********************************************************************"
    end if

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub