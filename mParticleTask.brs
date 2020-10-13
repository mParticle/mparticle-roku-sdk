'*************************************************************
' mParticle Roku SDK - mParticle Task Node for Scene Graph
' Copyright 2019 mParticle, Inc.
'*************************************************************

sub init()
    m.port = createObject("roMessagePort")
    m.top.observeField("mParticleApiCall", m.port)
    m.top.functionName = "setupRunLoop"
    m.top.control = "RUN"
end sub

sub setupRunLoop()
    options = m.global.mparticleOptions
    options.addReplace("batchUploads", true)
    mParticleStart(options, m.port)
    m.mparticle = mparticle()
    m.top[mParticleConstants().SCENEGRAPH_NODES.CURRENT_USER_NODE] = m.mparticle.identity.getCurrentUser()
    while true
        msg = wait(15 * 1000, m.port)
        if (msg = invalid) then
            m.mparticle._internal.sessionManager.updateLastEventTime(m.mparticle._internal.utils.unixTimeMillis())
            m.mparticle._internal.networking.queueUpload()
            m.mparticle._internal.networking.processUploads()
        else
            mt = type(msg)

            if mt = "roSGNodeEvent"
                if msg.getField() = mParticleConstants().SCENEGRAPH_NODES.API_CALL_NODE
                    executeApiCall(msg.getData())
                end if
            else if (mt = "roUrlEvent")
                if m.mparticle.isMparticleEvent(msg.getSourceIdentity())
                    identityResult = m.mparticle.onUrlEvent(msg)
                    if (identityResult <> invalid) then
                        m.top[mParticleConstants().SCENEGRAPH_NODES.IDENTITY_RESULT_NODE] = identityResult
                        if (identityResult.httpcode = 200) then
                            m.top[mParticleConstants().SCENEGRAPH_NODES.CURRENT_USER_NODE] = m.mparticle.identity.getCurrentUser()
                        end if
                    end if
                end if
            else
                print "Error: unrecognized event type '"; mt ; "'"
            end if
        end if
    end while
end sub

function executeApiCall(apiCall as object)
    args = apiCall.args
    length = args.count()
    if (apiCall.methodName.Instr("identity/") = 0) then
        target = m.mparticle.identity
        methodName = apiCall.methodName.Replace("identity/", "")
    else if (apiCall.methodName.Instr("media/") = 0) then
        target = m.mparticle.media
        methodName = apiCall.methodName.Replace("media/", "")
    else
        target = m.mparticle
        methodName = apiCall.methodName
    end if

    if (length = 0) then
        target[methodName]()
    else if (length = 1) then
        target[methodName](args[0])
    else if (length = 2) then
        target[methodName](args[0], args[1])
    else if (length = 3) then
        target[methodName](args[0], args[1], args[2])
    else if (length = 4) then
        target[methodName](args[0], args[1], args[2], args[3])
    else if (length = 5) then
        target[methodName](args[0], args[1], args[2], args[3], args[4])
    else if (length = 6) then
        target[methodName](args[0], args[1], args[2], args[3], args[4], args[5])
    end if
end function