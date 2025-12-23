sub Main(args as dynamic)
    ' For test builds, Rooibos tests are always run automatically
    ' Check if rooibos_init function exists (only in test builds)
    testFunc = rooibos_init
    if testFunc <> invalid then
        rooibos_init("RooibosScene")
        return
    end if
    
    ' Normal app execution (production build)
    screen = CreateObject("roSGScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    
    screen.CreateScene("HelloWorld")
    screen.Show()

    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent" and msg.isScreenClosed() then return
    end while
end sub
