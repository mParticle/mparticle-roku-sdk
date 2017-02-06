'*************************************************************
' mParticle Roku SDK - mParticle Task Node for Scene Graph
' Copyright 2017 mParticle, Inc. 
'*************************************************************

sub init()
    m.port = createObject("roMessagePort")
    m.top.observeField("apiCall", m.port)
    m.top.functionName = "setupRunLoop"
    m.top.control = "RUN"
end sub

sub setupRunLoop()
    options = m.global.mparticleOptions
    options.addReplace("batchUploads", true)
    mParticleStart(options, m.port)
    m.mparticle = mparticle()
    while true
        msg = wait(15*1000, m.port)
        if (msg = invalid) then
            m.mparticle._internal.sessionManager.updateLastEventTime(m.mparticle._internal.utils.unixTimeMillis())
            m.mparticle._internal.networking.queueUpload()
            m.mparticle._internal.networking.processUploads()
        else 
            mt = type(msg)
    
            if mt = "roSGNodeEvent"
                if msg.getField()="apiCall"
                    executeApiCall(msg.getData())
                end if
            else if (mt = "roUrlEvent")
                 if m.mparticle.isMparticleEvent(msg.getSourceIdentity())
                    m.mparticle.onUrlEvent(msg)
                end if
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
    else if (length = 5) then
        m.mparticle[apiCall.methodName](args[0], args[1], args[2], args[3], args[4])
    else if (length = 6) then
        m.mparticle[apiCall.methodName](args[0], args[1], args[2], args[3], args[4], args[5])
    end if
end function