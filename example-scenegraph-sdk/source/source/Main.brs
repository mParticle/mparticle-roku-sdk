'*************************************************************
'** Hello World example
'** Copyright (c) 2015 Roku, Inc.  All rights reserved.
'** Use of the Roku Platform is subject to the Roku SDK License Agreement:
'** https://docs.roku.com/doc/developersdk/en-us
'*************************************************************

sub Main(args as dynamic)
    print "in showChannelSGScreen"
    
    ' Check if RunUnitTests is passed via contentId (ECP parameter passing)
    if args.contentId <> invalid and args.contentId = "RunUnitTests=true" then
        args.RunUnitTests = "true"
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

    ' Run unit tests if in dev mode
    appInfo = CreateObject("roAppInfo")
    print "DEBUG: appInfo.IsDev() = " + appInfo.IsDev().ToStr()
    print "DEBUG: args.RunUnitTests = " + Box(args.RunUnitTests).ToStr()
    print "DEBUG: Type(TestRunner) = " + Type(TestRunner)
    
    if appInfo.IsDev() and args.RunUnitTests = "true" and Type(TestRunner) = "Function" then
        print "**********************************************************************"
        print "Starting Unit Tests..."
        print "**********************************************************************"
        
        Runner = TestRunner()
        Runner.SetTestsDirectory("pkg:/source/tests")
        Runner.SetTestSuitePrefix("TestSuite__")
        Runner.SetFailFast(false)
        
        print "DEBUG: Test directory: "; Runner.testsDirectory
        print "DEBUG: Test file prefix: "; Runner.testFilePrefix
        print "DEBUG: Suite prefix: "; Runner.testSuitePrefix
        
        ' Get list of test files
        testFiles = Runner.GetTestFilesList()
        print "DEBUG: Found"; testFiles.Count(); "test files"
        if testFiles.Count() > 0 then
            for each file in testFiles
                print "DEBUG:   - "; file
            end for
        else
            print "DEBUG: No test files found!"
        end if
        
        ' Get list of test suites
        testSuites = Runner.GetTestSuitesList()
        print "DEBUG: Found"; testSuites.Count(); "test suites"
        if testSuites.Count() > 0 then
            for each suite in testSuites
                print "DEBUG:   - "; suite.Name
            end for
        else
            print "DEBUG: No test suites found!"
        end if
        
        Runner.logger.SetVerbosity(3)
        Runner.logger.SetEcho(true)

        Runner.Run()
        
        print "**********************************************************************"
        print "Unit Tests Complete"
        print "**********************************************************************"
        
        ' Wait a moment to ensure all output is flushed before app exits
        sleep(2000)
    else
        print "DEBUG: Tests NOT running. Conditions not met."
    end if

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub