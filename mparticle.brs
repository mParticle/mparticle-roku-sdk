function mParticleConstants() as object 
    SDK_VERSION = "1.0.0"
    LOG_LEVEL = {
        NONE:   0,
        ERROR:  1,
        INFO:   2,
        DEBUG:  3
    }
    DEFAULT_OPTIONS = {
        development:    false,
        logLevel:       LOG_LEVEL.ERROR,
        enablePinning:  true,
        certificateDir: "pkg:/source/mparticle/mparticle.crt"
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
        IDENTITY_TYPE:      IDENTITY_TYPE
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
function mParticleStart(apiKey as string, apiSecret as string, options={} as object)
    if (getGlobalAA().mparticleInstance <> invalid) then
        logger = mparticle()._internal.logger
        logger.info("mParticleStart called twice.")
        return mParticle()
    end if
    
    logger = {
        PREFIX : "mParticle SDK: ",
        
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
                print m.PREFIX + message
            end if
        end function
    }
    
    utils = {
        randomGuid : function() as string
            return CreateObject("roDeviceInfo").GetRandomUUID() 
        end function,
        
        unixTimeMillis : function() as string
            date = CreateObject("roDateTime")
            return date.asSeconds().tostr() + date.getMilliseconds().tostr()
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
    
    createPersistence = function()
        persistence = {}
        persistence.mpkeys = {
            SECTION_NAME : "mparticle_persistence",
            USER_IDENTITIES : "user_identities",
            USER_ATTRIBUTES : "user_attributes",
            MPID : "mpid",
            COOKIES : "cookies"
        }
        persistence.section = CreateObject("roRegistrySection", persistence.mpkeys.SECTION_NAME)
        
        persistence.cleanCookies = sub()
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
        
        persistence.set = function(key as string, value as string) as boolean
             return m.section.Write(key, value)
        end function
        
        persistence.flush = function() as boolean
             return m.section.Flush()
        end function
        
        persistence.get = function(key as string) as string
             return m.section.Read(key)
        end function
        
        persistence.clear = function()
             for each key in m.mpkeys
                m.section.delete(key)
             end for
             m.flush()
        end function
        
        persistence.setUserIdentity = sub(identityType as integer, identityValue as string)
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
        
        persistence.getUserIdentities = function() as object
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
        
        persistence.setUserAttribute = sub(attributeKey as string, attributeValue as object)
            attributes = m.getUserAttributes()
            attributes[attributeKey] = attributeValue
            m.set(m.mpkeys.USER_ATTRIBUTES, FormatJson(attributes))
            m.flush()
        end sub
        
        persistence.getUserAttributes = function() as object
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
        
        persistence.setMpid = function(mpid as string) 
            m.set(m.mpkeys.MPID, mpid)
            m.flush()
        end function
        
        persistence.getMpid = function() as string
            return m.get(m.mpkeys.MPID)
        end function
        
        persistence.setCookies = function(cookies as object)
            currentCookies = m.getCookies()
            currentCookies.append(cookies)
            m.set(m.mpkeys.COOKIES, FormatJson(currentCookies))
            m.flush()
        end function
        
        persistence.getCookies = function() as object 
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
        
        return persistence
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
            persistence = mparticle()._internal.persistence
            mpid = persistence.getMpid()
            if (mparticle()._internal.utils.isEmpty(mpid)) then
                mpid = mparticle()._internal.utils.generateMpid()
                persistence.setMpid(mpid)
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
            identities = mparticle()._internal.persistence.getUserIdentities()
            for each identity in identities
                batch.ui.push(identities[identity])
            end for
            batch.ua = mparticle()._internal.persistence.getUserAttributes()
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
            urlTransfer.SetUrl("https://nativesdks.mparticle.com/v1/" + mparticle()._internal.configuration.key + "/events")
            urlTransfer.EnableEncodings(true)
            
            dateString = CreateObject("roDateTime").ToISOString()
            jsonBatch = FormatJson(batch)
            hashString = "POST" + Chr(10) + dateString + Chr(10) + "/v1/" + mparticle()._internal.configuration.key + "/events" + jsonBatch
            
            signature_key = CreateObject("roByteArray")
            signature_key.fromAsciiString(mparticle()._internal.configuration.secret)
            
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
            logger.debug("Uploading batch" + jsonBatch)
        
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
                persistence = mparticle()._internal.persistence
                if (responseObject.DoesExist("ci") and responseObject.ci.DoesExist("mpid")) then
                    persistence.setMpid(responseObject.ci.mpid.tostr())
                end if
                if (responseObject.DoesExist("ci") and responseObject.ci.DoesExist("ck")) then
                    persistence.setCookies(responseObject.ci.ck)
                end if
            end if
            
        end function
        
    }
    
    model = {
        Message : function(messageType as string, attributes={}) as object
            return {
                dt : messageType,
                id : mparticle()._internal.utils.randomGuid(),
                ct : mparticle()._internal.utils.unixTimeMillis(),
                attrs : attributes
            }
        end function,
        
        CustomEvent : function(eventName as string, eventType, customAttributes = {}) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.CUSTOM, customAttributes)
            message.n = eventName
            message.et = eventType
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
    
    'this is called after everything is initialized
    'perform whatever we need to on every startup
    performStartupTasks = sub()
        persistence = mparticle()._internal.persistence
        persistence.cleanCookies()
    end sub
    
    configuration = mParticleConstants().DEFAULT_OPTIONS
    for each key in options
        configuration.AddReplace(key, options[key])
    end for
        
    if (utils.isEmpty(apiKey) or utils.isEmpty(apiSecret)) then
        logger.error("mParticleStart() called with empty API key or secret!")
    end if
    configuration.key = apiKey
    configuration.secret = apiSecret

    
    '
    ' Public API implementations
    '
    publicApi = {
        logEvent:           function(eventName as string, eventType = mParticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes = {}) as void
                                m.logMessage(m.model.CustomEvent(eventName, eventType, customAttributes))
                            end function,
        logMessage:         function(message as object) as void
                                m._internal.networking.upload([message])
                            end function,
        setUserIdentity:    function(identityType as integer, identityValue as String) as void
                                m._internal.persistence.setUserIdentity(identityType, identityValue)
                            end function,
        setUserAttribute:   function(attributeKey as string, attributeValue as object) as void
                                m._internal.persistence.setUserAttribute(attributeKey, attributeValue)
                            end function,
        model:              model
    }
        
    internalApi =  {
        utils:          utils,
        logger:         logger,
        configuration:  configuration,
        networking:     networking,
        persistence:    createPersistence()
    }
    
    publicApi.append({_internal:internalApi})
    getGlobalAA().mparticleInstance = publicApi
    performStartupTasks()
end function