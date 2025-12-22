sub Main(args as dynamic)
    appInfo = CreateObject("roAppInfo")
    isDev = appInfo.IsDev()
    runTests = false

    ' Check for explicit RunUnitTests flag
    if args <> invalid and args.RunUnitTests <> invalid then
        if args.RunUnitTests = true or LCase(Box(args.RunUnitTests).ToStr()) = "true" then
            runTests = true
        end if
    end if

    ' Check contentId for test flag (deep linking)
    if not runTests and args <> invalid and args.contentId <> invalid then
        cid = LCase(Box(args.contentId).ToStr())
        if Instr(1, cid, "rununittests=true") > 0 then
            runTests = true
        else if Instr(1, cid, "rununittests=false") > 0 then
            runTests = false
        end if
    end if

    ' Default: run tests in dev mode
    if not runTests and isDev then
        runTests = true
    end if

    if runTests then
        rooibos_init("RooibosScene")
    else
        screen = CreateObject("roSGScreen")
        port = CreateObject("roMessagePort")
        screen.SetMessagePort(port)
        
        screen.CreateScene("HelloWorld")
        screen.Show()

        while true
            msg = wait(0, port)
            if type(msg) = "roSGScreenEvent" and msg.isScreenClosed() then return
        end while
    end if
end sub
