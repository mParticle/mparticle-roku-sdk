sub init()
    m.port = createObject("roMessagePort")
    m.top.observeField("apiCall", m.port)
    m.top.functionName = "setupRunLoop"
    m.top.control = "RUN"
end sub

sub setupRunLoop()
    mParticleStart(m.global.mparticleOptions)
    m.mparticle = mparticle()
    while true
        msg = wait(15*1000, m.port)
        if (msg = invalid) then
            m.mparticle._internal.sessionManager.updateLastEventTime(m.mparticle._internal.utils.unixTimeMillis())
        else 
            mt = type(msg)
    
            if mt = "roSGNodeEvent"
                if msg.getField()="apiCall"
                    executeApiCall(msg.getData())
                end if
            else if mt="roUrlEvent"
    
            else
        	   print "Error: unrecognized event type '"; mt ; "'"
            end if
        end if
    end while
end sub

function executeApiCall(apiCall as Object)
    args = apiCall.args
    length = args.count()
    if (length = 0) then
        m.mparticle[apiCall.methodName]()
    else if (length = 1) then
        m.mparticle[apiCall.methodName](args[0])
    else if (length = 2) then
        m.mparticle[apiCall.methodName](args[0], args[1])
    else if (length = 3) then
        m.mparticle[apiCall.methodName](args[0], args[1], args[2])
    else if (length = 4) then
        m.mparticle[apiCall.methodName](args[0], args[1], args[2], args[3])
    end if
end function