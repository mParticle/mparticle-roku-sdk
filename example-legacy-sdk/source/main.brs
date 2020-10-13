function main(args as dynamic)

    if args.RunIntegrationTests = "true" then
        screen = CreateObject("roPosterScreen")
        port = CreateObject("roMessagePort")
        screen.SetMessagePort(port)

        screen.ShowMessage("Hello mParticle!")
        screen.Show()

        options = {}
        options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
        options.apiKey = "REPLACE WITH API KEY"
        options.apiSecret = "REPLACE WITH API SECRET"
        options.startupArgs = args
        mParticleStart(options, port)
        mparticle().setUserIdentity(mparticleConstants().IDENTITY_TYPE.EMAIL, "user@example.com")
        mparticle().setUserAttribute("hair color", "brown")
        mparticle().logEvent("hello world")

        while true
            msg = Wait(0, port)
            if type(msg) = "roUrlEvent"
                if mparticle().isMparticleEvent(msg.getSourceIdentity())
                    mparticle().onUrlEvent(msg)
                end if
            else if type(msg) = "roPosterScreenEvent"
                if msg.isScreenClosed()
                    exit while
                end if
            end if
        end while

        screen.Close()

    else if args.RunUnitTests = "true" and type(TestRunner) = "Function" then
        Runner = TestRunner()
        Runner.testsDirectory = "pkg:/source/testing/tests"
        Runner.logger.SetVerbosity(2)
        Runner.logger.SetEcho(true)
        Runner.SetFailFast(true)
        Runner.Run()
    end if

end function