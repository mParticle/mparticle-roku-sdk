function mParticleSGBridge(task as object) as object
    return {
        mParticleTask:      task
        logEvent:           function(eventName as string, eventType = mParticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes = {}) as void
                                m.invokeFunction("logEvent", [eventName, eventType, customAttributes])
                             end function,
        logMessage:         function(message as object) as void
                                m.invokeFunction("logMessage", [message])
                            end function,
        setUserIdentity:    function(identityType as integer, identityValue as String) as void
                                m.invokeFunction("setUserIdentity", [identityType, identityValue])
                            end function,
        setUserAttribute:   function(attributeKey as string, attributeValue as object) as void
                                m.invokeFunction("setUserAttribute", [attributeKey, attributeValue])
                                end function
        invokeFunction:     function(name as string, args)
                                invocation = {}
                                invocation.methodName = name
                                invocation.args = args
                                m.mParticleTask.apiCall = invocation
                            end function
     }
    
end function

function mParticleConstants() as object 
    SDK_VERSION = "1.0.0"
    LOG_LEVEL = {
        NONE:   0,
        ERROR:  1,
        INFO:   2,
        DEBUG:  3
    }
    ENVIRONMENT = {
        AUTO_DETECT:        0,
        FORCE_DEVELOPMENT:  1,
        FORCE_PRODUCTION:   2
    }
    DEFAULT_OPTIONS = {
        apiKey:                 invalid,
        apiSecret:              invalid,
        environment:            ENVIRONMENT.AUTO_DETECT,
        logLevel:               LOG_LEVEL.ERROR,
        enablePinning:          true,
        certificateDir:         "pkg:/source/mparticle/mParticleBundle.crt",
        sessionTimeoutMillis:   60 * 1000
    }
    MESSAGE_TYPE = {
        SESSION_START:          "ss",
        SESSION_END:            "se",
        CUSTOM:                 "e",
        SCREEN:                 "s",
        OPT_OUT:                "o",
        ERROR:                  "x",
        BREADCRUMB:             "b",
        APP_STATE_TRANSITION:   "ast",
        COMMERCE:               "cm"
    }
    CUSTOM_EVENT_TYPE = {
        NAVIGATION:         "navigation",
        LOCATION:           "location",
        SEARCH:             "search",
        TRANSACTION:        "transaction", 
        USER_CONTENT:       "usercontent",
        USER_PREFERENCE:    "userpreference",
        SOCIAL:             "social",
        OTHER:              "other"
    }
    IDENTITY_TYPE = {
        CUSTOMER_ID:           1,
        FACEBOOK:              2,
        TWITTER:               3,
        GOOGLE:                4,
        MICROSOFT:             5,
        YAHOO:                 6,
        EMAIL:                 7,
        ALIAS:                 8,
        FACEBOOK_AUDIENCE_ID:  9
    }
    return {
        SDK_VERSION:        SDK_VERSION,
        LOG_LEVEL:          LOG_LEVEL,
        DEFAULT_OPTIONS:    DEFAULT_OPTIONS,
        MESSAGE_TYPE:       MESSAGE_TYPE,
        CUSTOM_EVENT_TYPE:  CUSTOM_EVENT_TYPE,
        IDENTITY_TYPE:      IDENTITY_TYPE,
        ENVIRONMENT:        ENVIRONMENT
    }
    
end function

'
' Retrieve a reference to the global mParticle object
'
function mParticle() as object
    if (getGlobalAA().mParticleInstance = invalid) then
        print "mParticle SDK: mParticle() called prior to mParticleStart!"
    end if
    return getGlobalAA().mParticleInstance
end function

'
' Initialize mParticle with your API key and secret for a Roku Input Configuration
'
' Optionally pass in additional configuration options, see mParticleConstants().DEFAULT_OPTIONS
'
function mParticleStart(options={} as object)
    if (getGlobalAA().mparticleInstance <> invalid) then
        logger = mparticle()._internal.logger
        logger.info("mParticleStart called twice.")
        return mParticle()
    end if
    
    logger = {
        PREFIX : "mParticle SDK",
        
        debug : function(message as String) as void
            m.printlog(mParticleConstants().LOG_LEVEL.DEBUG, message)
        end function,
        
        info : function(message as String) as void
            m.printlog(mParticleConstants().LOG_LEVEL.INFO, message)
        end function,
        
        error : function(message as String) as void
            m.printlog(mParticleConstants().LOG_LEVEL.ERROR, message)
        end function,
        
        printlog : function(level as integer, message as String) as void
             if (mparticle()._internal.configuration.logLevel >= level) then
                print "============== "+m.PREFIX+" ====================="
                print message
                print "=================================================="
            end if
        end function
    }
    
    utils = {
        currentChannelVersion : function() as string
             manifest = mparticle()._internal.utils.readManifest()
             return manifest.major_version + "." + manifest.minor_version
        end function,
        randomGuid : function() as string
            return CreateObject("roDeviceInfo").GetRandomUUID() 
        end function,
        
        unixTimeMillis : function() as longinteger
            date = CreateObject("roDateTime")
            currentTime = CreateObject("roLongInteger")
            currentTime.SetLongInt(date.asSeconds())
            return (currentTime * 1000) + date.getMilliseconds()
        end function,
        
        isEmpty : function(input as string) as boolean
            return input = invalid OR len(input) = 0
        end function,
        
        generateMpid : function() as string
            return m.fnv1aHash(m.randomGuid())
        end function,
        
        readManifest : function() as object
            result = {}
              
            raw = ReadASCIIFile("pkg:/manifest")
            lines = raw.Tokenize(Chr(10))
            for each line in lines
                bits = line.Tokenize("=")
                if bits.Count() > 1
                    result.AddReplace(bits[0], bits[1])
                end if
            end for
  
            return result
        end function,
       
        ' will return the string representation of a signed 64-bit int
        fnv1aHash : function(data as string) as string
            'the Roku-Eclipse plugin incorrectly highlights
            'LongInteger literals as syntax errors
            offset = &hcbf29ce484222325&
            prime = &h100000001b3&

            hash = CreateObject("roLongInteger")
            hash.SetLongInt(offset)
            
            for i = 0 to len(data)-1 step 1
                bitwiseAnd = hash and asc(data.mid(i, 1))
                bitwiseOr = hash or asc(data.mid(i, 1))
                hash = bitwiseOr and not bitwiseAnd
                hash = hash * prime
            end for
            return hash.tostr()
        end function,
    }
    
    createStorage = function()
        storage = {}
        storage.mpkeys = {
            SECTION_NAME : "mparticle_storage",
            USER_IDENTITIES : "user_identities",
            USER_ATTRIBUTES : "user_attributes",
            MPID : "mpid",
            COOKIES : "cookies",
            SESSION : "saved_session",
            CHANNEL_VERSION : "channel_version"
        }
        storage.section = CreateObject("roRegistrySection", storage.mpkeys.SECTION_NAME)
        
        storage.cleanCookies = sub()
            cookies = m.getCookies()
            validCookies = {}
            nowSeconds = CreateObject("roDateTime").AsSeconds()
            for each cookieKey in cookies
                expiration = CreateObject("roDateTime")
                expiration.FromISO8601String(cookies[cookieKey].e)
                if (expiration.AsSeconds() > nowSeconds) then
                    validCookies.append({cookieKey:cookies[cookieKey]})
                end if
            end for
            if (validCookies.Count() <> cookies.Count()) then
                m.setCookies(validCookies)
            end if
        end sub
        
        storage.set = function(key as string, value as string) as boolean
             return m.section.Write(key, value)
        end function
        
        storage.flush = function() as boolean
             return m.section.Flush()
        end function
        
        storage.get = function(key as string) as string
             return m.section.Read(key)
        end function
        
        storage.clear = function()
             for each key in m.mpkeys
                m.section.delete(key)
             end for
             m.flush()
        end function
        
        storage.setUserIdentity = sub(identityType as integer, identityValue as string)
            identities = m.getUserIdentities()
            identity = identities.Lookup(str(identityType))
            if (identity = invalid) then
                identities[str(identityType)] = mparticle().model.UserIdentity(identityType, identityValue)
            else
                identities[str(identityType)].i = identityValue
            end if
            m.set(m.mpkeys.USER_IDENTITIES, FormatJson(identities))
            m.flush()
        end sub
        
        storage.getUserIdentities = function() as object
            if (m.userIdentities = invalid) then
                identityJson = m.get(m.mpkeys.USER_IDENTITIES)
                if (not mparticle()._internal.utils.isEmpty(identityJson)) then
                   m.userIdentities = ParseJson(identityJson)
                end if   
                if (m.userIdentities = invalid) then
                   m.userIdentities = {}
                end if
            end if
            return m.userIdentities
        end function
        
        storage.setUserAttribute = sub(attributeKey as string, attributeValue as object)
            attributes = m.getUserAttributes()
            attributes[attributeKey] = attributeValue
            m.set(m.mpkeys.USER_ATTRIBUTES, FormatJson(attributes))
            m.flush()
        end sub
        
        storage.getUserAttributes = function() as object
            if (m.userAttributes = invalid) then
                attributeJson = m.get(m.mpkeys.USER_ATTRIBUTES)
                if (not mparticle()._internal.utils.isEmpty(attributeJson)) then
                   m.userAttributes = ParseJson(attributeJson)
                end if   
                if (m.userAttributes = invalid) then
                   m.userAttributes = {}
                end if
            end if
            return m.userAttributes
        end function
        
        storage.setMpid = function(mpid as string) 
            m.set(m.mpkeys.MPID, mpid)
            m.flush()
        end function
        
        storage.getMpid = function() as string
            return m.get(m.mpkeys.MPID)
        end function
        
        storage.setCookies = function(cookies as object)
            currentCookies = m.getCookies()
            currentCookies.append(cookies)
            m.set(m.mpkeys.COOKIES, FormatJson(currentCookies))
            m.flush()
        end function
        
        storage.getCookies = function() as object 
            if (m.cookies = invalid) then
                cookieJson = m.get(m.mpkeys.COOKIES)
                if (not mparticle()._internal.utils.isEmpty(cookieJson)) then
                   m.cookies = ParseJson(cookieJson)
                end if   
                if (m.cookies = invalid) then
                   m.cookies = {}
                end if
            end if
            return m.cookies
        end function
        
        storage.setSession = function(session as object)
            if (session <> invalid) then
                m.set(m.mpkeys.SESSION, FormatJson(session))
                m.flush()
            end if
        end function
        
        storage.getSession = function() as object
            sessionJson = m.get(m.mpkeys.SESSION)
            if (not mparticle()._internal.utils.isEmpty(sessionJson)) then
                return ParseJson(sessionJson)
            else
                return invalid
            end if
        end function
        
        storage.getChannelVersion = function() as string
            return m.get(m.mpkeys.CHANNEL_VERSION)
        end function
        
        storage.setChannelVersion = function(version as string)
            m.set(m.mpkeys.CHANNEL_VERSION, version)
            m.flush()
        end function
        
        return storage
    end function
    
    networking = {
        applicationInfo : function() as object
            return {}
        end function,
        
        deviceInfo : function() as object
            if (m.collectedDeviceInfo = invalid) then
                info = CreateObject("roDeviceInfo")
                m.collectedDeviceInfo = {
                    dp:     "Roku",
                    dn:     info.GetModelDisplayName(),
                    p:      info.GetModel(),
                    udid:   info.GetDeviceUniqueId(),
                    vr:     info.GetVersion(),
                    ' TODO: this may not be the correct place to send the Ad ID
                    anid:   info.GetAdvertisingId(),
                    lat:    info.IsAdIdTrackingDisabled(),
                    dmdl:   info.GetModel(),
                    dc:     info.GetCountryCode(),
                    dll:    info.GetCurrentLocale(),
                    dlc:    -1 * CreateObject("roDateTime").GetTimeZoneOffset() / 60,
                    tzn:    info.GetTimeZone(),
                    dr:     info.GetConnectionType()
                }
              
                modelDetails = info.GetModelDetails()
                if (modelDetails <> invalid) then
                    m.collectedDeviceInfo.b = modelDetails["VendorName"]
                    m.collectedDeviceInfo.dma = modelDetails["VendorName"]
                end if

                displaySize = info.GetDisplaySize()
                if (displaySize <> invalid) then
                    m.collectedDeviceInfo.dsh  = displaySize["h"]
                    m.collectedDeviceInfo.dsw  = displaySize["w"]
                end if

                manifest = mparticle()._internal.utils.readManifest()
                buildIdArray = CreateObject("roByteArray")
                buildIdArray.FromAsciiString(manifest.major_version + "." + manifest.minor_version)
                digest = CreateObject("roEVPDigest")
                digest.Setup("md5")
                digest.update(buildIdArray)
                m.collectedDeviceInfo.bid = digest.final()

                versionString = info.GetVersion()
                if (len(versionString) > 5) then
                    versionString = versionString.mid(2, 4)
                end if
                m.collectedDeviceInfo.dosv = versionString
                
            end if
            return m.collectedDeviceInfo
        end function,
        
        mpid : function() as object
            storage = mparticle()._internal.storage
            mpid = storage.getMpid()
            if (mparticle()._internal.utils.isEmpty(mpid)) then
                mpid = mparticle()._internal.utils.generateMpid()
                storage.setMpid(mpid)
            end if
            return mpid
        end function,
        
        upload : function(messages as object) as void
            batch = {}
            batch.dbg = mparticle()._internal.configuration.development
            batch.dt = "h"
            batch.mpid = m.mpid()
            batch.id = mParticle()._internal.utils.randomGuid()
            batch.ct = mParticle()._internal.utils.unixTimeMillis()
            batch.sdk = mParticleConstants().SDK_VERSION
            batch.ui = []
            identities = mparticle()._internal.storage.getUserIdentities()
            for each identity in identities
                batch.ui.push(identities[identity])
            end for
            batch.ua = mparticle()._internal.storage.getUserAttributes()
            batch.msgs = messages
            batch.ai = m.applicationInfo()
            batch.di = m.deviceInfo()
            m.uploadBatch(batch)
        end function,
        
        uploadBatch : function (batch as object) as integer
            urlTransfer = CreateObject("roUrlTransfer")
            if (mparticle()._internal.configuration.enablePinning) then
                urlTransfer.SetCertificatesFile(mparticle()._internal.configuration.certificateDir)
            end if
            urlTransfer.SetUrl("https://nativesdks.mparticle.com/v1/" + mparticle()._internal.configuration.apikey + "/events")
            urlTransfer.EnableEncodings(true)
            
            dateString = CreateObject("roDateTime").ToISOString()
            jsonBatch = FormatJson(batch)
            hashString = "POST" + Chr(10) + dateString + Chr(10) + "/v1/" + mparticle()._internal.configuration.apikey + "/events" + jsonBatch
            
            signature_key = CreateObject("roByteArray")
            signature_key.fromAsciiString(mparticle()._internal.configuration.apisecret)
            
            hmac = CreateObject("roHMAC")
            hmac.Setup("sha256", signature_key)
            message = CreateObject("roByteArray")
            message.FromAsciiString(hashString)
            result = hmac.process(message)
            hashResult = LCase(result.ToHexString())
            
            urlTransfer.AddHeader("Date", dateString)
            urlTransfer.AddHeader("x-mp-signature", hashResult)
            urlTransfer.AddHeader("Content-Type","application/json")
            urlTransfer.AddHeader("User-Agent","mParticle Roku SDK/" + batch.sdk)
            
            port = CreateObject("roMessagePort")
            urlTransfer.SetMessagePort(port)
            urlTransfer.RetainBodyOnError(true)
            logger = mparticle()._internal.logger
            logger.debug("Uploading batch: " + jsonBatch)
        
            if (urlTransfer.AsyncPostFromString(jsonBatch)) then
                while (true)
                    msg = wait(0, port)
                    if (type(msg) = "roUrlEvent") then
                        code = msg.GetResponseCode()
                        logger.debug("Batch response: code" + str(code) + " body: " + msg.GetString())
                        m.parseApiResponse(msg.GetString())
                        return code 
                    else if (event = invalid) then
                        urlTransfer.AsyncCancel()
                    endif
                end while
            endif
            return -1
        end function,
        
        parseApiResponse : function(apiResponse as string)
            if mparticle()._internal.utils.isEmpty(apiResponse) then : return 0 : end if
            responseObject = parsejson(apiResponse)
            if (responseObject <> invalid) then
                storage = mparticle()._internal.storage
                if (responseObject.DoesExist("ci") and responseObject.ci.DoesExist("mpid")) then
                    storage.setMpid(responseObject.ci.mpid.tostr())
                end if
                if (responseObject.DoesExist("ci") and responseObject.ci.DoesExist("ck")) then
                    storage.setCookies(responseObject.ci.ck)
                end if
            end if
            
        end function
        
    }
    
    createSessionManager = function(startupArgs as object) as object
        sessionManager = {}
        sessionManager.startupArgs = startupArgs
        sessionManagerApi = {
            onSdkStart : function()
                isFirstRun = true
                isUpgrade = false
                logAst = false
                storedChannelVersion = mparticle()._internal.storage.getChannelVersion()
                currentChannelVersion = mparticle()._internal.utils.currentChannelVersion()
                if (not mparticle()._internal.utils.isEmpty(storedChannelVersion) and storedChannelVersion <> currentChannelVersion) then
                    isUpgrade = true
                end if
                if (isUpgrade or mparticle()._internal.utils.isEmpty(storedChannelVersion)) then
                    storage = mparticle()._internal.storage
                    storage.setChannelVersion(currentChannelVersion)
                end if
                logger = mparticle()._internal.logger
                if (m.currentSession = invalid) then      
                    logger.debug("Restoring previous session.")
                    m.currentSession = mparticle()._internal.storage.getSession()
                    if (m.currentSession = invalid) then
                        logger.debug("No previous session found, creating new session.")
                        m.onSessionStart()
                        logAst = true
                    else
                        isFirstRun = false
                        currentTime = mparticle()._internal.utils.unixTimeMillis()
                        sessionTimeoutMillis = mparticle()._internal.configuration.sessionTimeoutMillis
                        lastEventTime = m.currentSession.lastEventTime
                        if ((currentTime - lastEventTime) >= sessionTimeoutMillis) then
                            logger.debug("Previous session timed out - creating new session.")
                            m.onSessionEnd(m.currentSession)
                            m.onSessionStart(m.currentSession)
                            logAst = true
                        else
                            logger.debug("Previous session still valid - it will be reused.")
                            m.onForeground(currentTime)
                        end if
                    end if
                end if
                if (logAst) then
                    mparticle().logMessage(mparticle().model.AppStateTransition("app_init", isFirstRun, isUpgrade, m.startupArgs))
                end if
            end function,
            updateLastEventTime : function(time as longinteger)
                logger = mparticle()._internal.logger
                logger.debug("Updating session end time.")
                m.currentSession.lastEventTime = time
                m.saveSession()
            end function,
            onForeground : function(time as longinteger)
                m.updateLastEventTime(time)
                
            end function,
            setSessionAttribute: function(attributeKey as string, attributeValue as object)
                m.currentSession.attributes[attributeKey] = attributeValue
                m.updateLastEventTime(mparticle()._internal.utils.unixTimeMillis())
            end function,
            onSessionStart: function(previousSession = invalid as object)
                m.currentSession = m.createSession(previousSession)
                m.saveSession()
                mparticle().logMessage(mparticle().model.SessionStart(m.currentSession))
            end function,
            onSessionEnd: function(session as object)
                mparticle().logMessage(mparticle().model.SessionEnd(session))
            end function,
            saveSession: function()
                storage = mparticle()._internal.storage
                storage.setSession(m.currentSession)
            end function,
            createSession : function(previousSession = invalid as object)
                deviceInfo = CreateObject("roDeviceInfo")
                currentTime = mparticle()._internal.utils.unixTimeMillis()
                launchReferral = invalid
                if (m.startupArgs <> invalid) then
                    launchReferrer = m.startupArgs.contentId
                end if
                previousSessionLength = invalid
                previousSessionId = invalid
                previousSessionStartTime = invalid
                if (previousSession <> invalid) then
                    previousSessionLength = m.sessionLength(previousSession)
                    previousSessionId = previousSession.sessionId
                    previousSessionStartTime = previousSession.startTime
                end if
                
                return {
                    sessionId : mparticle()._internal.utils.randomGuid()
                    startTime : currentTime,
                    dataConnection : deviceInfo.GetConnectionType(),
                    launchReferrer: launchReferrer
                    lastEventTime : currentTime,
                    previousSessionLength : previousSessionLength,
                    previousSessionId: previousSessionId,
                    previousSessionStartTime: previousSessionStartTime,
                    attributes : {}
                }
            end function,
            sessionLength : function(session as object) as integer
                return (session.lastEventTime - session.startTime)
            end function, 
        }
        sessionManager.append(sessionManagerApi)
        return sessionManager
    end function
    
    model = {
        Message : function(messageType as string, attributes=invalid) as object
            return {
                dt : messageType,
                id : mparticle()._internal.utils.randomGuid(),
                ct : mparticle()._internal.utils.unixTimeMillis(),
                attrs : attributes
            }
        end function,
        
        CustomEvent: function(eventName as string, eventType, customAttributes = {}) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.CUSTOM, customAttributes)
            message.n = eventName
            message.et = eventType
            return message
        end function,
        
        SessionStart: function(session) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.SESSION_START)
            message.ct = session.startTime
            message.sid = session.sessionId
            message.dct = session.dataConnection
            message.lr = session.launchReferrer
            if (session.previousSessionLength <> invalid) then
                message.psl = session.previousSessionLength / 1000
            end if
            message.pid = session.previousSessionId
            message.pss = session.previousSessionStartTime
            return message
        end function,
        
        SessionEnd: function(session as object) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.SESSION_END)
            message.sid = session.sessionId
            message.sct = session.startTime
            message.dct = session.dataConnection
            message.slx = mparticle()._internal.sessionManager.sessionLength(session)
            message.sl = message.slx
            message.attrs = session.attributes
            return message
        end function,
        
        AppStateTransition: function(astType as string, firstRun as boolean, isUpgrade as boolean, startupArgs as object) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.APP_STATE_TRANSITION)
            message.t = astType
            message.ifr = firstRun
            message.iu = isUpgrade
            deviceInfo = CreateObject("roDeviceInfo")
            message.dct = deviceInfo.GetConnectionType()
            if (startupArgs <> invalid) then
                message.lr = startupArgs.contentId
                message.lpr = formatjson(startupArgs)
            end if
            
            return message
        end function,
        
        UserIdentity : function(identityType as integer, identityValue as String) as object
            return {
                n : identityType,
                i : identityValue,
                dfs : mparticle()._internal.utils.unixTimeMillis(),
                f : true
            }
       
        end function
    }
    
    if (utils.isEmpty(options.apiKey) or utils.isEmpty(options.apiSecret)) then
        logger.error("mParticleStart() called with empty API key or secret!")
    end if

    createConfiguration = function(options as object) as object
        configuration = mParticleConstants().DEFAULT_OPTIONS
        for each key in options
            configuration.AddReplace(key, options[key])
        end for

        if configuration.environment = mParticleConstants().ENVIRONMENT.FORCE_DEVELOPMENT then
            configuration.development = true
        else if configuration.environment = mParticleConstants().ENVIRONMENT.FORCE_PRODUCTION then
            configuration.development = false
        else 
            appInfo = CreateObject("roAppInfo")
            configuration.development = appInfo.IsDev()
        end if
        return configuration
    end function
    
    'this is called after everything is initialized
    'perform whatever we need to on every startup
    performStartupTasks = sub()
        storage = mparticle()._internal.storage
        storage.cleanCookies()
        sessionManager = mparticle()._internal.sessionManager
        sessionManager.onSdkStart()
    end sub

    
    '
    ' Public API implementations
    '
    publicApi = {
        logEvent:           function(eventName as string, eventType = mParticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes = {}) as void
                                m.logMessage(m.model.CustomEvent(eventName, eventType, customAttributes))
                            end function,
        logMessage:         function(message as object) as void
                                logger = mparticle()._internal.logger
                                logger.debug("Logging message: " + formatjson(message))
                                m._internal.networking.upload([message])
                            end function,
        setUserIdentity:    function(identityType as integer, identityValue as String) as void
                                m._internal.storage.setUserIdentity(identityType, identityValue)
                            end function,
        setUserAttribute:   function(attributeKey as string, attributeValue as object) as void
                                m._internal.storage.setUserAttribute(attributeKey, attributeValue)
                            end function,
        model:              model
    }
        
    internalApi =  {
        utils:          utils,
        logger:         logger,
        configuration:  createConfiguration(options),
        networking:     networking,
        storage:        createStorage(),
        sessionManager: createSessionManager(options.startupArgs)
    }
    
    publicApi.append({_internal:internalApi})
    getGlobalAA().mparticleInstance = publicApi
    performStartupTasks()
end function