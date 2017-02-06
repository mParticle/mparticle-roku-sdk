'*************************************************************
' mParticle Roku SDK - Core APIs
' Copyright 2017 mParticle, Inc. 
'*************************************************************

'
' mParticleConstants() surface various fields for interacting with the mParticle APIs
'
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
    'You may pass in any of these options to the mParticle SDK, via mParticleStart
    'or via the Global mParticle options field
    DEFAULT_OPTIONS = {
        apiKey:                 "",
        apiSecret:              "",
        environment:            ENVIRONMENT.AUTO_DETECT,
        logLevel:               LOG_LEVEL.ERROR,
        enablePinning:          true,
        certificateDir:         "pkg:/source/mparticle/mParticleBundle.crt",
        sessionTimeoutMillis:   60 * 1000,
        batchUploads:           false,
    }
    USER_ATTRIBUTES = {
        FIRSTNAME:      "$FirstName",
        LASTNAME:       "$LastName",
        ADDRESS:        "$Address",
        STATE:          "$State",
        CITY:           "$City",
        ZIPCODE:        "$Zip",
        COUNTRY:        "$Country",
        AGE:            "$Age",
        GENDER:         "$Gender",
        MOBILE_NUMBER:  "$Mobile"
    }
    MESSAGE_TYPE = {
        SESSION_START:          "ss",
        SESSION_END:            "se",
        CUSTOM:                 "e",
        SCREEN:                 "v",
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
    
    '
    ' eCommerce APIs
    '
    PromotionAction = {
        ACTION_TYPE : {
            VIEW:   "view",
            CLICK:  "click"
        },
        build : function(actionType as string, promotionList as object)
            return {
                an : actionType,
                pl : promotionList
            }
        end function,
    }
    
    Promotion = {
        build : function(promotionId as string, name as string, creative as string, position as string)
            return {
                id: promotionId,
                nm: name,
                cr: creative,
                ps: position
            }
        end function
    }
    
    Impression = {
        build : function(impressionList as string, productList as object)
            return {
                pil:    impressionList,
                pl:     productList
            }
        end function
    }
   
    ProductAction = {
        ACTION_TYPE : {
            ADD_TO_CART:          "add_to_cart",
            REMOVE_FROM_CART:     "remove_from_cart",
            CHECKOUT:             "checkout",
            CLICK:                "click",
            VIEW:                 "view",
            VIEW_DETAIL:          "view_detail",
            PURCHASE:             "purchase",
            REFUND:               "refund",
            ADD_TO_WISHLIST:      "add_to_wishlist",
            REMOVE_FROM_WISHLIST: "remove_from_wishlist"
        },
        build : function(actionType as string, totalAmount as double, productList as object)
            return {
                an  : actionType,
                tr  : totalAmount,
                pl  : productList
            }
        end function,
        setCheckoutStep : function(productAction as object, checkoutStep as integer)
            productAction.cs = checkoutStep
        end function,
        setCheckoutOptions : function(productAction as object, checkoutOptions as string)
            productAction.co = checkoutOptions
        end function,
        setProductActionList : function(productAction as object, productActionList as string)
            productAction.pal = productActionList
        end function,
        setProductListSource : function(productAction as object, productListSource as string)
            productAction.pls = productListSource
        end function,
        setTransactionId : function(productAction as object, transactionId as string)
            productAction.ti = transactionId
        end function,
        setAffiliation : function(productAction as object, affiliation as string)
            productAction.ta = affiliation
        end function,
        setTaxAmount : function(productAction as object, taxAmount as double)
            productAction.tt = taxAmount
        end function,
        setShippingAmount : function(productAction as object, shippingAmout as double)
            productAction.ts = shippingAmout
        end function,
        setCouponCode : function(productAction as object, couponCode as string)
            productAction.cc = couponCode
        end function
    }
    
    Product = {
        build : function(sku as string, name as string, price=0 as double, quantity=1 as integer, customAttributes={} as object)
            product = {}
            product.id = sku
            product.nm = name
            product.pr = price
            product.qt = quantity
            product.tpa = price * quantity
            product.attrs = customAttributes
            return product
        end function,
        setBrand : function(product as object, brand as string)
            product.cs = brand
        end function,
        setCategory : function(product as object, category as string)
            product.ca = category
        end function,
        setVariant : function(product as object, variant as string)
            product.va = variant
        end function,
        setPosition : function(product as object, position as integer)
            product.ps = position
        end function,
        setCouponCode : function(product as object, couponCode as string)
            product.cc = couponCode
        end function
    }
    return {
        SDK_VERSION:            SDK_VERSION,
        LOG_LEVEL:              LOG_LEVEL,
        DEFAULT_OPTIONS:        DEFAULT_OPTIONS,
        MESSAGE_TYPE:           MESSAGE_TYPE,
        CUSTOM_EVENT_TYPE:      CUSTOM_EVENT_TYPE,
        IDENTITY_TYPE:          IDENTITY_TYPE,
        ENVIRONMENT:            ENVIRONMENT,
        ProductAction:          ProductAction,
        Product:                Product,
        PromotionAction:        PromotionAction
        Promotion:              Promotion,
        Impression:             Impression
    }
    
end function

'
' Retrieve a reference to the global mParticle object.
' Note: this only applies to legacy SDK channels. For Scene Graph, you must use the mParticleSGBridge (below)
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
' Note: this only applies to legacy SDK channels. For Scene Graph, the mParticleTask will call this
'
function mParticleStart(options as object, messagePort as object)
    if (getGlobalAA().mparticleInstance <> invalid) then
        mplogger = mparticle()._internal.logger
        mplogger.info("mParticleStart called twice.")
        return mParticle()
    end if
    
    mpLogger = {
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
    
    mpUtils = {
        currentChannelVersion : function() as string
             info = CreateObject("roAppInfo")
             return info.getversion()
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
        
        isEmpty : function(input as dynamic) as boolean
            return input = invalid OR len(input) = 0
        end function,
        
        generateMpid : function() as string
            return m.fnv1aHash(m.randomGuid())
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
    
    mpCreateStorage = function()
        storage = {}
        'channels can share registry when packaged by the same developer token
        'token, so include the channel ID
        appInfo = CreateObject("roAppInfo")
        storage.mpkeys = {
            SECTION_NAME : "mparticle_storage_"+appInfo.getid(),
            USER_IDENTITIES : "user_identities",
            USER_ATTRIBUTES : "user_attributes",
            MPID : "mpid",
            COOKIES : "cookies",
            SESSION : "saved_session",
            CHANNEL_VERSION : "channel_version",
            LTV : "ltv",
            OPT_OUT : "opt_out"
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
                    validCookie = {}
                    validCookie[cookieKey] = cookies[cookieKey]
                    validCookies.append(validCookie)
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
                identities[str(identityType)] = mparticle()._internal.internalModel.UserIdentity(identityType, identityValue)
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
        
        storage.getMpid = function() as object
            mpid = m.get(m.mpkeys.MPID)
            if (mparticle()._internal.utils.isEmpty(mpid)) then
                mpid = mparticle()._internal.utils.generateMpid()
                m.setMpid(mpid)
            end if
            return mpid
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
        
        storage.setLtv = function(ltv as double)
            m.set(m.mpkeys.LTV, ltv.tostr())
            m.flush()
        end function
        
        storage.getLtv = function() as double
            ltv = m.get(m.mpkeys.LTV)
            if (not mparticle()._internal.utils.isEmpty(ltv)) then
                return ParseJson(ltv)
            else
                return 0
            end if
        end function
        
        storage.setOptOut = function(optOut as boolean)
            m.set(m.mpkeys.OPT_OUT, optOut.tostr())
            m.flush()
        end function
        
        storage.getOptOut = function() as boolean
            mpOptOut = m.get(m.mpkeys.OPT_OUT)
            return "true" = mpOptOut
        end function
        
        return storage
    end function
    
    mpInternalModel = {
    
       Batch : function(messages as object) as object
            batch = {}
            batch.dbg = mparticle()._internal.configuration.development
            batch.dt = "h"
            batch.mpid = mparticle()._internal.storage.getMpid()
            batch.ltv = mparticle()._internal.storage.getLtv()
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
            batch.ai = m.ApplicationInformation()
            batch.di = m.DeviceInformation()
            batch.ck = mparticle()._internal.storage.getCookies()
            return batch
        end function,
    
        UserIdentity : function(identityType as integer, identityValue as String) as object
            return {
                n : identityType,
                i : identityValue,
                dfs : mparticle()._internal.utils.unixTimeMillis(),
                f : true
            }
       
        end function,
        
        ApplicationInformation : function() as object
            if (m.collectedApplicationInfo = invalid) then
                appInfo = CreateObject("roAppInfo")
                deviceInfo = CreateObject("roDeviceInfo")
                env = 2
                if (mparticle()._internal.configuration.development) then 
                    env = 1
                end if
                m.collectedApplicationInfo = {
                    an:     appInfo.GetTitle(),
                    av:     appInfo.GetVersion(),
                    apn:    appInfo.GetID(),
                    abn:    appInfo.GetValue("build_version"),
                    env:    env
                }
            end if
            return m.collectedApplicationInfo
        end function,
        
        DeviceInformation : function() as object
            if (m.collectedDeviceInfo = invalid) then
                info = CreateObject("roDeviceInfo")
                m.collectedDeviceInfo = {
                    dp:     "Roku",
                    dn:     info.GetModelDisplayName(),
                    p:      info.GetModel(),
                    duid:   info.GetDeviceUniqueId(),
                    vr:     info.GetVersion(),
                    rida:   info.GetAdvertisingId(),
                    lat:    info.IsAdIdTrackingDisabled(),
                    rpb:    info.GetPublisherId(),
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
                    

                buildIdArray = CreateObject("roByteArray")
                buildIdArray.FromAsciiString(mparticle()._internal.utils.currentChannelVersion())
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
        end function
    }
    
    mpNetworking = {
        messagePort : messagePort,
        backoff : {
            nextAllowedUploadTime : 0,
            currentBackoffDuration : 0,
            reset : function()
                m.currentBackoffDuration = 0
                m.nextAllowedUploadTime = 0
            end function,
            increase : function()
                maxDuration = 2*60*60*1000
                base = 1000
                intervalMillis = 5000
                if (m.currentBackoffDuration = 0) then
                    m.currentBackoffDuration = base
                else
                    m.currentBackoffDuration = m.currentBackoffDuration * 2
                    if (m.currentBackoffDuration > maxDuration) then
                        m.currentBackoffDuration = maxDuration
                    end if
                end if
            
                m.nextAllowedUploadTime = mparticle()._internal.utils.unixTimeMillis() + m.currentBackoffAttempt
            end function,
            canUpload : function() as boolean
                if (m.nextAllowedUploadTime = 0)
                    return true
                else 
                    currentTime = mparticle()._internal.utils.unixTimeMillis()
                    return currentTime >= m.nextAllowedUploadTime
                end if
            end function
        },
        pendingTransfers : {},
        messageQueue : [],
        uploadQueue : [],
        queueMessage : function(message as object)
            storage = mparticle()._internal.storage
            if (message.dt = mParticleConstants().MESSAGE_TYPE.OPT_OUT) then
                storage.setOptOut(message.lookup("s"))
            else if (storage.getOptOut()) then 
                return 0
            end if
            m.messageQueue.push(message)
            if (not mparticle()._internal.configuration.batchUploads) then
                m.queueUpload()
                m.processUploads()
            end if
        end function,
        queueUpload : function()
            if (m.messageQueue.count() > 0) then
                upload = mparticle()._internal.internalModel.Batch(m.messageQueue)
                m.uploadQueue.push(upload)
                m.messageQueue = []
            end if
        end function,
        processUploads : function()
            if (m.backoff.canUpload()) then
                m.backoff.reset()
            else
                return -1
            end if
            mplogger = mparticle()._internal.logger
            mplinkStatus = CreateObject("roDeviceInfo").GetLinkStatus()
            if (not mplinkStatus) then
                mplogger.error("No active network connection - deferring upload.")
                return -1
            end if
            while (m.uploadQueue.count() > 0) 
                nextUpload = m.uploadQueue.shift()
                m.uploadBatch(nextUpload)
            end while
        end function,
      
        uploadBatch : function (batch as object)
            urlTransfer = CreateObject("roUrlTransfer")
            if (mparticle()._internal.configuration.enablePinning) then
                urlTransfer.SetCertificatesFile(mparticle()._internal.configuration.certificateDir)
            end if
            urlTransfer.SetUrl("https://nativesdks.mparticle.com/v1/" + mparticle()._internal.configuration.apikey + "/events")
            urlTransfer.EnableEncodings(true)
            requestId = urlTransfer.GetIdentity().ToStr()
            m.pendingTransfers[requestId] = {"transfer": urlTransfer, "batch":batch}
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
            urlTransfer.RetainBodyOnError(true)
            mplogger = mparticle()._internal.logger
            mplogger.debug("Uploading batch: " + jsonBatch)
            urlTransfer.setPort(m.messagePort)
            urlTransfer.AsyncPostFromString(jsonBatch)
        end function,
        
        handleUrlEvent : function(urlEvent as object)
            if (urlEvent <> invalid)
                requestId = urlEvent.GetSourceIdentity().ToStr()
                transfer = m.pendingTransfers[requestId]
                mplogger = mparticle()._internal.logger
                if (transfer = invalid)
                    mplogger.debug("Unknown URL event passed to mParticle, ignoring...")
                else
                    m.pendingTransfers.delete(requestId)
                    responseCode = urlEvent.GetResponseCode()
                    responseBody = urlEvent.GetString()
                    mplogger.debug("Batch response: code" + str(responseCode) + " body: " + responseBody)
                    
                    if (responseCode = -77) then
                        mplogger.error("SSL error - please make sure " + mparticle()._internal.configuration.certificateDir + " is present.")
                    else if (responseCode = 400) then
                        mplogger.error("HTTP 400 - please check that your mParticle key and secret are valid.")
                    else if (responseCode = 429 or responseCode = 503) then
                        m.uploadQueue.unshift(transfer.batch)
                        m.backoff.increase()
                    else if (responseCode = 202 and responseBody <> invalid) then
                        responseObject = parsejson(responseBody)
                        if (responseObject <> invalid) then
                            storage = mparticle()._internal.storage
                            if (responseObject.DoesExist("ci") and responseObject.ci.DoesExist("mpid")) then
                                storage.setMpid(responseObject.ci.mpid.tostr())
                            end if
                            if (responseObject.DoesExist("ci") and responseObject.ci.DoesExist("ck")) then
                                storage.setCookies(responseObject.ci.ck)
                            end if
                            if (responseObject.DoesExist("iltv")) then
                                storage.setLtv(responseObject.iltv)
                            end if
                        end if
                    else
                        m.uploadQueue.unshift(transfer.batch)
                        mplogger.error("Unknown error while performing upload.")
                    end if
                end if
            end if
        end function
        
    }
    
    mpCreateSessionManager = function(startupArgs as object) as object
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
                mplogger = mparticle()._internal.logger
                if (m.currentSession = invalid) then      
                    mplogger.debug("Restoring previous session.")
                    m.currentSession = mparticle()._internal.storage.getSession()
                    if (m.currentSession = invalid) then
                        mplogger.debug("No previous session found, creating new session.")
                        m.onSessionStart()
                        logAst = true
                    else
                        isFirstRun = false
                        currentTime = mparticle()._internal.utils.unixTimeMillis()
                        sessionTimeoutMillis = mparticle()._internal.configuration.sessionTimeoutMillis
                        lastEventTime = m.currentSession.lastEventTime
                        if ((currentTime - lastEventTime) >= sessionTimeoutMillis) then
                            mplogger.debug("Previous session timed out - creating new session.")
                            m.onSessionEnd(m.currentSession)
                            m.onSessionStart(m.currentSession)
                            logAst = true
                        else
                            mplogger.debug("Previous session still valid - it will be reused.")
                            m.onForeground(currentTime)
                        end if
                    end if
                end if
                if (logAst) then
                    mparticle().logMessage(mparticle().model.AppStateTransition("app_init", isFirstRun, isUpgrade, m.startupArgs))
                end if
            end function,
            getCurrentSession : function()
                return m.currentSession
            end function,
            updateLastEventTime : function(time as longinteger)
                mplogger = mparticle()._internal.logger
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
            setSessionAttribute: function(attributekey as string, attributevalue as string)
                attributes = m.currentSession.attributes
                if (attributes = invalid) then
                    attributes = {}
                end if
                attributes[attributekey] = attributevalue
                m.saveSession()
            end function,
            createSession : function(previousSession = invalid as object)
                deviceInfo = CreateObject("roDeviceInfo")
                currentTime = mparticle()._internal.utils.unixTimeMillis()
                launchReferrer = invalid
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
    
    mpPublicModels = {
        Message : function(messageType as string, attributes={}) as object
            currentSession = mparticle()._internal.sessionManager.getCurrentSession()
             if (attributes <> invalid and attributes.count() = 0) then
                attributes = invalid
            end if
            return {
                dt : messageType,
                id : mparticle()._internal.utils.randomGuid(),
                ct : mparticle()._internal.utils.unixTimeMillis(),
                attrs : attributes,
                sid : currentSession.sessionId,
                sct : currentSession.startTime
            }
        end function,
        
        CustomEvent: function(eventName as string, eventType, customAttributes = {}) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.CUSTOM, customAttributes)
            message.n = eventName
            message.et = eventType
            message.est = message.ct
            return message
        end function,
        
        ScreenEvent: function(screenName as string, customAttributes = {}) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.SCREEN, customAttributes)
            message.n = screenName
            message.est = message.ct
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
            message.dct = session.dataConnection
            message.slx = mparticle()._internal.sessionManager.sessionLength(session)
            message.sl = message.slx
            message.attrs = session.attributes
            return message
        end function,
        
        OptOut: function(optOut as boolean) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.OPT_OUT)
            message.s = optOut
            return message
        end function,
        
        CommerceEvent: function(productAction={} as object, promotionAction={} as object, impressions=[] as object, customAttributes={} as object, screenName=invalid as string) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.COMMERCE, customAttributes)
            if (productAction <> invalid and productAction.count() > 0) then
                message.pd = productAction
            end if
            if (promotionAction <> invalid and promotionAction.count() > 0) then
                message.pm = promotionAction
            end if
            if (impressions <> invalid and impressions.count() > 0) then
                message.pi = impressions
            end if
            if (not mparticle()._internal.utils.isEmpty(screenName)) then
                message.sn = screenName
            end if
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
       
    }
    
    if (mpUtils.isEmpty(options.apiKey) or mpUtils.isEmpty(options.apiSecret)) then
        print "mParticleStart() called with empty API key or secret!"
    end if

    mpCreateConfiguration = function(options as object) as object
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
    mpPerformStartupTasks = sub()
        storage = mparticle()._internal.storage
        storage.cleanCookies()
        sessionManager = mparticle()._internal.sessionManager
        sessionManager.onSdkStart()
    end sub

    
    '
    ' Public API implementations
    '
    mpPublicApi = {
        logEvent:           function(eventName as string, eventType = mParticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes = {}) as void
                                m.logMessage(m.model.CustomEvent(eventName, eventType, customAttributes))
                            end function,
        logScreenEvent:     function(screenName as string, customAttributes = {}) as void
                                m.logMessage(m.model.ScreenEvent(screenName, customAttributes))
                            end function,
        logCommerceEvent:   function(productAction={} as object, promotionAction={} as object, impressions=[] as object, customAttributes={} as object, screenName=invalid as string)
                                m.logMessage(m.model.CommerceEvent(productAction, promotionAction, impressions, customAttributes, screenName))
                            end function,
        logMessage:         function(message as object) as void
                                mplogger = mparticle()._internal.logger
                                mplogger.debug("Logging message: " + formatjson(message))
                                m._internal.networking.queueMessage(message)
                            end function,
        setUserIdentity:    function(identityType as integer, identityValue as String) as void
                                m._internal.storage.setUserIdentity(identityType, identityValue)
                            end function,
        setUserAttribute:   function(attributeKey as string, attributeValue as object) as void
                                m._internal.storage.setUserAttribute(attributeKey, attributeValue)
                            end function,
        setSessionAttribute:function(attributeKey as string, attributeValue as object) as void
                                m._internal.sessionManager.setSessionAttribute(attributeKey, attributeValue)
                            end function,
        setOptOut:          function(optOut as boolean) as void
                               m.logMessage(m.model.OptOut(optOut))
                            end function,
        onUrlEvent:         function(urlEvent as object) as void
                                m._internal.networking.handleUrlEvent(urlEvent)
                            end function,     
        isMparticleEvent:   function(sourceIdentity as integer) as boolean
                                return m._internal.networking.pendingTransfers.DoesExist(sourceIdentity.tostr())
                            end function,               
        model:              mpPublicModels
    }
        
    internalApi =  {
        utils:          mpUtils,
        logger:         mpLogger,
        configuration:  mpCreateConfiguration(options),
        networking:     mpNetworking,
        storage:        mpCreateStorage(),
        sessionManager: mpCreateSessionManager(options.startupArgs)
        internalModel:  mpInternalModel
    }
    
    mpPublicApi.append({_internal:internalApi})
    getGlobalAA().mparticleInstance = mpPublicApi
    mpPerformStartupTasks()
end function

' mParticle Scene Graph Bridge
' Use an instance of this class to make calls to mParticle over Scene Graph
function mParticleSGBridge(task as object) as object
    return {
        mParticleTask:      task
        logEvent:           function(eventName as string, eventType = mParticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes = {}) as void
                                m.invokeFunction("logEvent", [eventName, eventType, customAttributes])
                            end function,
        logScreenEvent:     function(screenName as string, customAttributes = {}) as void
                                m.invokeFunction("logScreenEvent", [screenName, customAttributes])
                            end function,
        logCommerceEvent:   function(productAction={} as object, promotionAction={} as object, impressions=[] as object, customAttributes={} as object, screenName="" as string)
                                m.invokeFunction("logCommerceEvent", [productAction, promotionAction, impressions, customAttributes, screenName])
                            end function,
        logMessage:         function(message as object) as void
                                m.invokeFunction("logMessage", [message])
                            end function,
        setUserIdentity:    function(identityType as integer, identityValue as String) as void
                                m.invokeFunction("setUserIdentity", [identityType, identityValue])
                            end function,
        setUserAttribute:   function(attributeKey as string, attributeValue as object) as void
                                m.invokeFunction("setUserAttribute", [attributeKey, attributeValue])
                            end function,
        setSessionAttribute:   function(attributeKey as string, attributeValue as object) as void
                                m.invokeFunction("setSessionAttribute", [attributeKey, attributeValue])
                            end function,
        invokeFunction:     function(name as string, args)
                                invocation = {}
                                invocation.methodName = name
                                invocation.args = args
                                m.mParticleTask.apiCall = invocation
                            end function
     }
    
end function