sub Main(args as dynamic)
    ' For test builds, Rooibos tests are always run automatically
    ' Check if RooibosScene component exists (only in test builds)
    screen = CreateObject("roSGScreen")
    testScene = screen.CreateScene("RooibosScene")
    
    if testScene <> invalid then
        ' Test build detected - initialize Rooibos
        ' Use GetGlobalAA() to access rooibos_init without compile-time dependency
        globalAA = GetGlobalAA()
        if globalAA.rooibos_init <> invalid then
            globalAA.rooibos_init("RooibosScene")
        end if
        return
    end if
    
    ' Normal app execution (production build)
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    
    ' Configure mParticle options BEFORE creating scene
    options = {}
    options.apiKey = "YOUR_API_KEY"
    options.apiSecret = "YOUR_API_SECRET"
    options.logLevel = 2 ' DEBUG level
    
    ' Set options on global node BEFORE creating scene
    screen.getGlobalNode().addFields({ mparticleOptions: options })
    
    screen.CreateScene("HelloWorld")
    screen.Show()

    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent" and msg.isScreenClosed() then return
    end while
end sub
