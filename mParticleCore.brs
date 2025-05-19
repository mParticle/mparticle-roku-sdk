'*************************************************************
' mParticle Roku SDK - Core APIs
' Copyright 2019 mParticle, Inc.
'*************************************************************

'
' mParticleConstants() surface various fields for interacting with the mParticle APIs
'
function mParticleConstants() as object
    SDK_VERSION = "2.1.18"
    LOG_LEVEL = {
        NONE: 0,
        ERROR: 1,
        INFO: 2,
        DEBUG: 3
    }
    ENVIRONMENT = {
        AUTO_DETECT: 0,
        FORCE_DEVELOPMENT: 1,
        FORCE_PRODUCTION: 2
    }
    'You may pass in any of these options to the mParticle SDK, via mParticleStart
    'or via the Global mParticle options field
    DEFAULT_OPTIONS = {
        apiKey: "",
        apiSecret: "",
        environment: ENVIRONMENT.AUTO_DETECT,
        logLevel: LOG_LEVEL.ERROR,
        enablePinning: true,
        certificateDir: "pkg:/source/mparticle/mParticleBundle.crt",
        sessionTimeoutMillis: 60 * 1000,
        batchUploads: false,
    }
    SCENEGRAPH_NODES = {
        API_CALL_NODE: "mParticleApiCall",
        CURRENT_USER_NODE: "mParticleCurrentUser",
        IDENTITY_RESULT_NODE: "mParticleIdentityResult",
        CURRENT_SESSION_NODE: "mParticleCurrentSession"
    }
    USER_ATTRIBUTES = {
        FIRSTNAME: "$FirstName",
        LASTNAME: "$LastName",
        ADDRESS: "$Address",
        STATE: "$State",
        CITY: "$City",
        ZIPCODE: "$Zip",
        COUNTRY: "$Country",
        AGE: "$Age",
        GENDER: "$Gender",
        MOBILE_NUMBER: "$Mobile"
    }
    MESSAGE_TYPE = {
        SESSION_START: "ss",
        SESSION_END: "se",
        CUSTOM: "e",
        SCREEN: "v",
        OPT_OUT: "o",
        ERROR: "x",
        BREADCRUMB: "b",
        APP_STATE_TRANSITION: "ast",
        COMMERCE: "cm",
        USER_ATTRIBUTE_CHANGE: "uac",
        USER_IDENTITY_CHANGE: "uic"
    }
    CUSTOM_EVENT_TYPE = {
        NAVIGATION: "navigation",
        LOCATION: "location",
        SEARCH: "search",
        TRANSACTION: "transaction",
        USER_CONTENT: "usercontent",
        USER_PREFERENCE: "userpreference",
        SOCIAL: "social",
        OTHER: "other",
        MEDIA: "media"
    }
    MEDIA_EVENT_NAME = {
        PLAY: "Play",
        PAUSE: "Pause",
        CONTENT_END: "Media Content End",
        SESSION_START: "Media Session Start",
        SESSION_END: "Media Session End",
        SEEK_START: "Seek Start",
        SEEK_END: "Seek End",
        BUFFER_START: "Buffer Start",
        BUFFER_END: "Buffer End",
        UPDATE_PLAYHEAD_POSITION: "Update Playhead Position",
        AD_CLICK: "Ad Click",
        AD_BREAK_START: "Ad Break Start",
        AD_BREAK_END: "Ad Break End",
        AD_START: "Ad Start",
        AD_END: "Ad End",
        AD_SKIP: "Ad Skip",
        SEGMENT_START: "Segment Start",
        SEGMENT_SKIP: "Segment Skip",
        SEGMENT_END: "Segment End",
        UPDATE_QOS: "Update QoS",
        MILESTONE: "Milestone",
        SESSION_SUMMARY: "Media Session Summary",
        AD_SUMMARY: "Ad Session Summary",
        SEGMENT_SUMMARY: "Segment Session Summary"
    }
    MEDIA_CONTENT_TYPE = {
        VIDEO: "Video",
        AUDIO: "Audio"
    }
    MEDIA_STREAM_TYPE = {
        LIVE_STREAM: "LiveStream",
        ON_DEMAND: "OnDemand",
        LINEAR: "Linear",
        PODCAST: "Podcast",
        AUDIOBOOK: "Audiobook"
    }
    IDENTITY_TYPE_INT = {
        OTHER: 0,
        CUSTOMER_ID: 1,
        FACEBOOK: 2,
        TWITTER: 3,
        GOOGLE: 4,
        MICROSOFT: 5,
        YAHOO: 6,
        EMAIL: 7,
        FACEBOOK_AUDIENCE_ID: 9,
        OTHER2: 10,
        OTHER3: 11,
        OTHER4: 12,
        OTHER5: 13,
        OTHER6: 14,
        OTHER7: 15,
        OTHER8: 16,
        OTHER9: 17,
        OTHER10: 18,
        MOBILE_NUMBER: 19,
        PHONE_NUMBER2: 20,
        PHONE_NUMBER3: 21,
        parseString: function(identityTypeString as string) as integer
            IDENTITY_TYPE = mparticleconstants().IDENTITY_TYPE
            if (identityTypeString = IDENTITY_TYPE.OTHER) then
                return m.OTHER
            else if (identityTypeString = IDENTITY_TYPE.CUSTOMER_ID) then
                return m.CUSTOMER_ID
            else if (identityTypeString = IDENTITY_TYPE.FACEBOOK) then
                return m.FACEBOOK
            else if (identityTypeString = IDENTITY_TYPE.TWITTER) then
                return m.TWITTER
            else if (identityTypeString = IDENTITY_TYPE.GOOGLE) then
                return m.GOOGLE
            else if (identityTypeString = IDENTITY_TYPE.MICROSOFT) then
                return m.MICROSOFT
            else if (identityTypeString = IDENTITY_TYPE.YAHOO) then
                return m.YAHOO
            else if (identityTypeString = IDENTITY_TYPE.EMAIL) then
                return m.EMAIL
            else if (identityTypeString = IDENTITY_TYPE.FACEBOOK_AUDIENCE_ID) then
                return m.FACEBOOK_AUDIENCE_ID
            else if (identityTypeString = IDENTITY_TYPE.OTHER2) then
                return m.OTHER2
            else if (identityTypeString = IDENTITY_TYPE.OTHER3) then
                return m.OTHER3
            else if (identityTypeString = IDENTITY_TYPE.OTHER4) then
                return m.OTHER4
            else if (identityTypeString = IDENTITY_TYPE.OTHER5) then
                return m.OTHER5
            else if (identityTypeString = IDENTITY_TYPE.OTHER6) then
                return m.OTHER6
            else if (identityTypeString = IDENTITY_TYPE.OTHER7) then
                return m.OTHER7
            else if (identityTypeString = IDENTITY_TYPE.OTHER8) then
                return m.OTHER8
            else if (identityTypeString = IDENTITY_TYPE.OTHER9) then
                return m.OTHER9
            else if (identityTypeString = IDENTITY_TYPE.OTHER10) then
                return m.OTHER10
            else if (identityTypeString = IDENTITY_TYPE.MOBILE_NUMBER) then
                return m.MOBILE_NUMBER
            else if (identityTypeString = IDENTITY_TYPE.PHONE_NUMBER2) then
                return m.PHONE_NUMBER2
            else if (identityTypeString = IDENTITY_TYPE.PHONE_NUMBER3) then
                return m.PHONE_NUMBER3
            end if
            return 0
        end function
    }

    IDENTITY_TYPE = {
        OTHER: "other",
        CUSTOMER_ID: "customerid",
        FACEBOOK: "facebook",
        TWITTER: "twitter",
        GOOGLE: "google",
        MICROSOFT: "microsoft",
        YAHOO: "yahoo",
        EMAIL: "email",
        FACEBOOK_AUDIENCE_ID: "facebookcustomaudienceid",
        OTHER2: "other2",
        OTHER3: "other3",
        OTHER4: "other4",
        OTHER5: "other5",
        OTHER6: "other6",
        OTHER7: "other7",
        OTHER8: "other8",
        OTHER9: "other9",
        OTHER10: "other10",
        MOBILE_NUMBER: "mobile_number",
        PHONE_NUMBER2: "phone_number_2",
        PHONE_NUMBER3: "phone_number_3",
        isValidIdentityType: function(identityType as string) as boolean
            allTypes = m.Keys()
            mputils = mparticle()._internal.utils
            for each idType in allTypes
                if (mputils.isString(m[idType]) and m[idType] = identityType) then
                    return true
                end if
            end for
            return false
        end function

    }
    '
    ' Consent Management
    '
    ConsentState = {
        build: function()
            consentState = {}
            consentState.gdpr = {}
            consentState.ccpa = {}
            return consentState
        end function,

        ' GDPR
        addGDPRConsentState: function(consentState as object, purpose as string, gdprConsent as object)
            consentState.gdpr.AddReplace(purpose, gdprConsent)
        end function,
        getCCPAConsentState: function(consentState as object)
            return consentState.ccpa
        end function,
        getGDPRConsentState: function(consentState as object)
            return consentState.gdpr
        end function,
        removeGDPRConsentState: function(consentState as object, purpose as string)
            if (consentState.gdpr.DoesExist(purpose)) then
                consentState.gdpr.Delete(purpose)
            end if
        end function,

        ' CCPA
        setCCPAConsentState: function(consentState as object, ccpaConsent as object)
            consentState.ccpa.AddReplace("data_sale_opt_out", ccpaConsent)
        end function,
        removeCCPAConsentState: function(consentState as object)
            consentState.ccpa.Delete("data_sale_opt_out")
        end function
    }
    CCPAConsentState = {
        build: function(consented as boolean, timestamp as longinteger)
            ccpaConsentState = {}
            ccpaConsentState.c = consented
            ccpaConsentState.ts = timestamp
            return ccpaConsentState
        end function
        setDocument: function(ccpaConsentState as object, document as string)
            ccpaConsentState.d = document
        end function,
        setConsented: function(ccpaConsentState as object, consented as boolean)
            ccpaConsentState.c = consented
        end function,
        setLocation: function(ccpaConsentState as object, location as string)
            ccpaConsentState.l = location
        end function,
        setTimestamp: function(ccpaConsentState as object, timestamp as longinteger)
            ccpaConsentState.ts = timestamp
        end function,
        setHardwareId: function(ccpaConsentState as object, hardwareId as string)
            ccpaConsentState.h = hardwareId
        end function,
    }
    GDPRConsentState = {
        build: function(consented as boolean, timestamp as longinteger)
            gdprConsentState = {}
            gdprConsentState.c = consented
            gdprConsentState.ts = timestamp
            return gdprConsentState
        end function,
        setDocument: function(gdprConsentState as object, document as string)
            gdprConsentState.d = document
        end function,
        setConsented: function(gdprConsentState as object, consented as boolean)
            gdprConsentState.c = consented
        end function,
        setLocation: function(gdprConsentState as object, location as string)
            gdprConsentState.l = location
        end function,
        setTimestamp: function(gdprConsentState as object, timestamp as longinteger)
            gdprConsentState.ts = timestamp
        end function,
        setHardwareId: function(gdprConsentState as object, hardwareId as string)
            gdprConsentState.h = hardwareId
        end function,
    }


    '
    ' eCommerce APIs
    '
    PromotionAction = {
        ACTION_TYPE: {
            VIEW: "view",
            CLICK: "click"
        },
        build: function(actionType as string, promotionList as object)
            return {
                an: actionType,
                pl: promotionList
            }
        end function,
    }

    Promotion = {
        build: function(promotionId as string, name as string, creative as string, position as string)
            return {
                id: promotionId,
                nm: name,
                cr: creative,
                ps: position
            }
        end function
    }

    Impression = {
        build: function(impressionList as string, productList as object)
            return {
                pil: impressionList,
                pl: productList
            }
        end function
    }

    ProductAction = {
        ACTION_TYPE: {
            ADD_TO_CART: "add_to_cart",
            REMOVE_FROM_CART: "remove_from_cart",
            CHECKOUT: "checkout",
            CLICK: "click",
            VIEW: "view",
            VIEW_DETAIL: "view_detail",
            PURCHASE: "purchase",
            REFUND: "refund",
            ADD_TO_WISHLIST: "add_to_wishlist",
            REMOVE_FROM_WISHLIST: "remove_from_wishlist"
        },
        build: function(actionType as string, totalAmount as double, productList as object)
            return {
                an: actionType,
                tr: totalAmount,
                pl: productList
            }
        end function,
        setCheckoutStep: function(productAction as object, checkoutStep as integer)
            productAction.cs = checkoutStep
        end function,
        setCheckoutOptions: function(productAction as object, checkoutOptions as string)
            productAction.co = checkoutOptions
        end function,
        setProductActionList: function(productAction as object, productActionList as string)
            productAction.pal = productActionList
        end function,
        setProductListSource: function(productAction as object, productListSource as string)
            productAction.pls = productListSource
        end function,
        setTransactionId: function(productAction as object, transactionId as string)
            productAction.ti = transactionId
        end function,
        setAffiliation: function(productAction as object, affiliation as string)
            productAction.ta = affiliation
        end function,
        setTaxAmount: function(productAction as object, taxAmount as double)
            productAction.tt = taxAmount
        end function,
        setShippingAmount: function(productAction as object, shippingAmout as double)
            productAction.ts = shippingAmout
        end function,
        setCouponCode: function(productAction as object, couponCode as string)
            productAction.cc = couponCode
        end function
    }

    Product = {
        build: function(sku as string, name as string, price = 0 as double, quantity = 1 as integer, customAttributes = {} as object)
            product = {}
            product.id = sku
            product.nm = name
            product.pr = price
            product.qt = quantity
            product.tpa = price * quantity
            product.attrs = customAttributes
            return product
        end function,
        setBrand: function(product as object, brand as string)
            product.cs = brand
        end function,
        setCategory: function(product as object, category as string)
            product.ca = category
        end function,
        setVariant: function(product as object, variant as string)
            product.va = variant
        end function,
        setPosition: function(product as object, position as integer)
            product.ps = position
        end function,
        setCouponCode: function(product as object, couponCode as string)
            product.cc = couponCode
        end function
    }

    '
    ' Media APIs
    '

    MediaSession = {
        build: function(contentId as string, title as string, contentType as string, streamType as string, duration = 0 as integer, mediaSessionAttributes = {} as object)
            session = {}
            session.contentId = contentId
            session.title = title
            session.duration = duration
            session.contentType = contentType
            session.streamType = streamType
            session.mediaSessionAttributes = mediaSessionAttributes
            session.mediaSessionId = CreateObject("roDeviceInfo").GetRandomUUID()
            session.currentPlayheadPosition = 0
            session.mediaContentComplete = false
            session.mediaContentTimeSpent = 0
            session.mediaSessionSegmentTotal = 0
            session.mediaSessionAdTotal = 0
            session.mediaTotalAdTimeSpent = 0
            session.mediaAdTimeSpentRate = 0.0
            session.mediaSessionAdObjects = CreateObject("roArray", 0, true)
            return session
        end function,
        setDuration: function(session as object, duration as integer)
            session.duration = duration
        end function,
        setMediaSessionAttributes: function(session as object, mediaSessionAttributes as object)
            session.mediaSessionAttributes = mediaSessionAttributes
        end function,
        setCurrentPlayheadPosition: function(session as object, playheadPosition as integer)
            session.currentPlayheadPosition = playheadPosition
        end function,
        setAdContent: function(session as object, adContent as object)
            session.adContent = adContent
        end function,
        setAdBreak: function(session as object, adBreak as object)
            session.adBreak = adBreak
        end function,
        setSegment: function(session as object, segment as object)
            session.segment = segment
        end function,
        setMediaSessionStartTime: function(session as object, mediaSessionStartTime as longinteger)
            session.mediaSessionStartTime = mediaSessionStartTime
        end function,
        setMediaSessionEndTime: function(session as object, mediaSessionEndTime as longinteger)
            session.mediaSessionEndTime = mediaSessionEndTime
        end function,
        setMediaContentComplete: function(session as object, mediaContentComplete as boolean)
            session.mediaContentComplete = mediaContentComplete
        end function,
        setMediaContentTimeSpent: function(session as object, mediaContentTimeSpent as longinteger)
            session.mediaContentTimeSpent = mediaContentTimeSpent
        end function,
        setMediaSessionSegmentTotal: function(session as object, mediaSessionSegmentTotal as integer)
            session.mediaSessionSegmentTotal = mediaSessionSegmentTotal
        end function,
        setMediaSessionAdTotal: function(session as object, mediaSessionAdTotal as integer)
            session.mediaSessionAdTotal = mediaSessionAdTotal
        end function,
        setMediaTotalAdTimeSpent: function(session as object, mediaTotalAdTimeSpent as longinteger)
            session.mediaTotalAdTimeSpent = mediaTotalAdTimeSpent
        end function,
        setMediaAdTimeSpentRate: function(session as object, mediaAdTimeSpentRate as double)
            session.mediaAdTimeSpentRate = mediaAdTimeSpentRate
        end function,
        setMediaSessionAdObjects: function(session as object, mediaSessionAdObjects as object)
            session.mediaSessionAdObjects = mediaSessionAdObjects
        end function
    }

    AdContent = {
        build: function(id as string, title as string)
            ad = {}
            ad.id = id
            ad.title = title
            ad.adCompleted = false
            ad.adSkipped = false
            return ad
        end function,
        setDuration: function(ad as object, duration as integer)
            ad.duration = duration
        end function,
        setAdvertiser: function(ad as object, advertiser as string)
            ad.advertiser = advertiser
        end function,
        setCampaign: function(ad as object, campaign as string)
            ad.campaign = campaign
        end function,
        setCreative: function(ad as object, creative as string)
            ad.creative = creative
        end function,
        setPlacement: function(ad as object, placement as string)
            ad.placement = placement
        end function,
        setPosition: function(ad as object, position as integer)
            ad.position = position
        end function,
        setSiteId: function(ad as object, siteId as string)
            ad.siteId = siteId
        end function,
        setAdStartTime: function(ad as object, adStartTime as longinteger)
            ad.adStartTime = adStartTime
        end function,
        setAdEndTime: function(ad as object, adEndTime as longinteger)
            ad.adEndTime = adEndTime
        end function,
        setAdCompleted: function(ad as object, adCompleted as boolean)
            ad.adCompleted = adCompleted
        end function,
        setAdSkipped: function(ad as object, adSkipped as boolean)
            ad.adSkipped = adSkipped
        end function
    }

    AdBreak = {
        build: function(id as string, title as string)
            adBreak = {}
            adBreak.id = id
            adBreak.title = title
            return adBreak
        end function,
        setDuration: function(adBreak as object, duration as integer)
            adBreak.duration = duration
        end function
    }

    Segment = {
        build: function(title as string, index as integer, duration as integer)
            segment = {}
            segment.title = title
            segment.index = index
            segment.duration = duration
            segment.segmentCompleted = false
            segment.segmentSkipped = false
            return segment
        end function,
        setDuration: function(segment as object, duration as integer)
            segment.duration = duration
        end function,
        setSegmentStartTime: function(segment as object, segmentStartTime as longinteger)
            segment.segmentStartTime = segmentStartTime
        end function,
        setSegmentEndTime: function(segment as object, segmentEndTime as longinteger)
            segment.segmentEndTime = segmentEndTime
        end function,
        setSegmentCompleted: function(segment as object, segmentCompleted as boolean)
            segment.segmentCompleted = segmentCompleted
        end function,
        setSegmentSkipped: function(segment as object, segmentSkipped as boolean)
            segment.segmentSkipped = segmentSkipped
        end function
    }

    return {
        SDK_VERSION: SDK_VERSION,
        LOG_LEVEL: LOG_LEVEL,
        DEFAULT_OPTIONS: DEFAULT_OPTIONS,
        SCENEGRAPH_NODES: SCENEGRAPH_NODES,
        MESSAGE_TYPE: MESSAGE_TYPE,
        CUSTOM_EVENT_TYPE: CUSTOM_EVENT_TYPE,
        IDENTITY_TYPE: IDENTITY_TYPE,
        IDENTITY_TYPE_INT: IDENTITY_TYPE_INT,
        ENVIRONMENT: ENVIRONMENT,
        MEDIA_EVENT_NAME: MEDIA_EVENT_NAME,
        MEDIA_CONTENT_TYPE: MEDIA_CONTENT_TYPE,
        MEDIA_STREAM_TYPE: MEDIA_STREAM_TYPE,
        ProductAction: ProductAction,
        Product: Product,
        PromotionAction: PromotionAction
        Promotion: Promotion,
        Impression: Impression,
        ConsentState: ConsentState,
        CCPAConsentState: CCPAConsentState,
        GDPRConsentState: GDPRConsentState,
        MediaSession: MediaSession,
        AdContent: AdContent,
        AdBreak: AdBreak,
        Segment: Segment
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
        PREFIX: "mParticle SDK",

        debug: function(message as string) as void
            m.printlog(mParticleConstants().LOG_LEVEL.DEBUG, message)
        end function,

        info: function(message as string) as void
            m.printlog(mParticleConstants().LOG_LEVEL.INFO, message)
        end function,

        error: function(message as string) as void
            m.printlog(mParticleConstants().LOG_LEVEL.ERROR, message)
        end function,

        printlog: function(level as integer, message as string) as void
            if (mparticle()._internal.configuration.logLevel >= level) then
                print "============== " + m.PREFIX + " ====================="
                print message
                print "=================================================="
            end if
        end function
    }

    mpUtils = {
        currentChannelVersion: function() as string
            info = CreateObject("roDeviceInfo")
            osVersion = info.GetOSVersion()
            return osVersion["major"] + "." + osVersion["minor"]
        end function,
        randomGuid: function() as string
            return CreateObject("roDeviceInfo").GetRandomUUID()
        end function,

        unixTimeMillis: function() as longinteger
            date = CreateObject("roDateTime")
            currentTime = CreateObject("roLongInteger")
            currentTime.SetLongInt(date.asSeconds())
            return (currentTime * 1000) + date.getMilliseconds()
        end function,

        isEmpty: function(input as dynamic) as boolean
            if input = invalid
                return true
            else
                if (LCase(type(input)) = "roarray" or LCase(type(input)) = "array")
                    return input.Count() = 0
                end if
                if (LCase(type(input)) = "rostring" or LCase(type(input)) = "string")
                    return Len(input) = 0
                end if
            end if
            return false
        end function,

        isString: function(input as object) as boolean
            return input <> invalid and (LCase(type(input)) = "rostring" or LCase(type(input)) = "string")
        end function,

        isArray: function(input as object) as boolean
            return input <> invalid and (LCase(type(input)) = "roarray" or LCase(type(input)) = "array")
        end function
    }

    mpCreateStorage = function()
        storage = {}
        'channels can share registry when packaged by the same developer token
        'token, so include the channel ID
        appInfo = CreateObject("roAppInfo")
        storage.mpkeys = {
            SECTION_NAME: "mparticle_storage_" + appInfo.getid(),
            USER_IDENTITIES: "user_identities",
            USER_ATTRIBUTES: "user_attributes",
            CONSENT_STATE: "consent_state",
            CURRENT_MPID: "current_mpid",
            COOKIES: "cookies",
            SESSION: "saved_session",
            CHANNEL_VERSION: "channel_version",
            LTV: "ltv",
            OPT_OUT: "opt_out",
            DAS: "das",
            INTEGRATION_ATTRIBUTES: "integration_attributes"
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

        storage.setUserIdentity = function(mpid as string, identityType as string, identityValue as string) as void
            if (not mparticleConstants().IDENTITY_TYPE.isValidIdentityType(identityType)) then
                return
            end if
            identities = m.getUserIdentities(mpid)
            identity = identities.Lookup(identityType)
            oldIdentity = identities["i"]
            if (identity = invalid and identityValue.len() > 0) then
                identities[identityType] = mparticle()._internal.internalModel.UserIdentity(identityType, identityValue)
            else
                if (identityValue.len() = 0) then
                    identities.Delete(identityType)
                else
                    identities[identityType].i = identityValue
                    identities[identityType].f = false
                end if
            end if
            m.set(m.mpkeys.USER_IDENTITIES + mpid, FormatJson(identities))
            m.flush()

            if (oldIdentity <> identityValue) then
                mparticle().logMessage(mparticle().model.UserIdentityChange(identityValue, oldIdentity))
            end if
        end function

        storage.getUserIdentities = function(mpid as string) as object
            identityJson = m.get(m.mpkeys.USER_IDENTITIES + mpid)
            userIdentities = {}
            if (not mparticle()._internal.utils.isEmpty(identityJson)) then
                userIdentities = ParseJson(identityJson)
            end if
            return userIdentities
        end function

        storage.setUserAttribute = function(mpid as string, attributeKey as string, attributeValue as object) as void
            attributes = m.getUserAttributes(mpid)
            oldValue = attributes[attributeKey]
            attributes[attributeKey] = attributeValue
            m.set(m.mpkeys.USER_ATTRIBUTES + mpid, FormatJson(attributes))
            m.flush()

            if (FormatJSON(attributeValue) <> FormatJSON(oldValue)) then
                deleted = false
                if (mparticle()._internal.utils.isEmpty(attributeValue) or FormatJSON(attributeValue).len() = 0) then
                    deleted = true
                end if
                isNewAttribute = false
                if (mparticle()._internal.utils.isEmpty(oldValue) or FormatJSON(oldValue).len() = 0) then
                    isNewAttribute = true
                end if
                mparticle().logMessage(mparticle().model.UserAttributeChange(attributeKey, attributeValue, oldValue, deleted, isNewAttribute))
            end if
        end function

        storage.removeUserAttribute = function(mpid as string, attributeKey as string) as void
            attributes = m.getUserAttributes(mpid)
            oldValue = attributes[attributeKey]
            attributes.delete(attributeKey)
            m.set(m.mpkeys.USER_ATTRIBUTES + mpid, FormatJson(attributes))
            m.flush()
            mparticle().logMessage(mparticle().model.UserAttributeChange(attributeKey, invalid, oldValue, true, false))
        end function

        storage.getUserAttributes = function(mpid as string) as object
            attributeJson = m.get(m.mpkeys.USER_ATTRIBUTES + mpid)
            userAttributes = {}
            if (not mparticle()._internal.utils.isEmpty(attributeJson)) then
                userAttributes = ParseJson(attributeJson)
            end if
            return userAttributes
        end function

        storage.setIntegrationAttribute = function(mpid as string, integrationId as string, attributeKey as string, attributeValue as object) as void
            attributes = m.getIntegrationAttributes(mpid)
            if (mparticle()._internal.utils.isEmpty(attributes[integrationId])) then
                integrationAttributes = {}
            else
                interationAttributes = attributes[integrationId]
            end if
            interationAttributes[attributeKey] = attributeValue
            attributes[integrationId] = interationAttributes
            m.set(m.mpkeys.USER_ATTRIBUTES + mpid, FormatJson(attributes))
            m.flush()
        end function

        storage.getIntegrationAttributes = function(mpid as string) as object
            attributeJson = m.get(m.mpkeys.INTEGRATION_ATTRIBUTES + mpid)
            integrationAttributes = {}
            if (not mparticle()._internal.utils.isEmpty(attributeJson)) then
                integrationAttributes = ParseJson(attributeJson)
            end if
            return integrationAttributes
        end function

        storage.setConsentState = function(mpid as string, consentState as object) as void
            m.set(m.mpkeys.CONSENT_STATE + mpid, FormatJson(consentState))
            m.flush()
        end function

        storage.getConsentState = function(mpid as string) as object
            consentJson = m.get(m.mpkeys.CONSENT_STATE + mpid)
            consentState = {}
            if (not mparticle()._internal.utils.isEmpty(consentJson)) then
                consentState = ParseJson(consentJson)
            end if
            return consentState
        end function

        storage.setCurrentMpid = function(mpid as string) as void
            m.set(m.mpkeys.CURRENT_MPID, mpid)
            m.flush()
        end function

        storage.getCurrentMpid = function() as string
            mpid = m.get(m.mpkeys.CURRENT_MPID)
            if (mparticle()._internal.utils.isEmpty(mpid)) then
                return "0"
            end if
            return mpid
        end function

        storage.getDas = function() as string
            das = m.get(m.mpkeys.DAS)
            if (mparticle()._internal.utils.isEmpty(das)) then
                das = mparticle()._internal.utils.randomGuid()
                m.setDas(das)
            end if
            return das
        end function

        storage.setDas = function(das as string)
            m.set(m.mpkeys.DAS, das)
            m.flush()
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

        Batch: function(messages as object) as object
            currentMpid = mparticle()._internal.storage.getCurrentMpid()
            mpBatch = {}
            mpBatch.dbg = mparticle()._internal.configuration.development
            mpBatch.dt = "h"
            mpBatch.mpid = mparticle()._internal.storage.getCurrentMpid()
            mpBatch.ltv = mparticle()._internal.storage.getLtv()
            mpBatch.id = mParticle()._internal.utils.randomGuid()
            mpBatch.ct = mParticle()._internal.utils.unixTimeMillis()
            mpBatch.sdk = mParticleConstants().SDK_VERSION
            mpBatch.ui = []
            identities = mparticle()._internal.storage.getUserIdentities(currentMpid)
            for each identity in identities
                mpBatch.ui.push(identities[identity])
            end for
            mpBatch.ua = mparticle()._internal.storage.getUserAttributes(currentMpid)
            mpBatch.msgs = messages
            mpBatch.ai = m.ApplicationInformation()
            mpBatch.di = m.DeviceInformation()
            mpBatch.ck = mparticle()._internal.storage.getCookies()
            mpBatch.das = mparticle()._internal.storage.getDas()
            mpBatch.con = mparticle()._internal.storage.getConsentState(currentMpid)
            mpBatch.ia = mparticle()._internal.storage.getIntegrationAttributes(currentMpid)
            mplogger = mparticle()._internal.logger
            if (mparticle()._internal.configuration.dataPlanId <> invalid) then
                if ((LCase(type(mparticle()._internal.configuration.dataPlanId))) = "rostring") then
                    mpBatch.ctx = {}
                    mpBatch.ctx.dpln = {}
                    mpBatch.ctx.dpln.id = mparticle()._internal.configuration.dataPlanId
                    if (mparticle()._internal.configuration.dataPlanVersion <> invalid) then
                        if ((LCase(type(mparticle()._internal.configuration.dataPlanVersion))) = "roint") then
                            mpBatch.ctx.dpln.v = mparticle()._internal.configuration.dataPlanVersion
                        else
                            mplogger.error("Your data plan version must be a integer.")
                        end if
                    end if
                else
                    mplogger.error("Your data plan id must be a string.")
                end if
            end if
            return mpBatch
        end function,

        UserIdentity: function(identityType as string, identityValue as string) as object
            return {
                n: mParticleConstants().IDENTITY_TYPE_INT.parseString(identityType),
                i: identityValue,
                dfs: mparticle()._internal.utils.unixTimeMillis(),
                f: true
            }
        end function,

        ApplicationInformation: function() as object
            if (m.collectedApplicationInfo = invalid) then
                appInfo = CreateObject("roAppInfo")
                deviceInfo = CreateObject("roDeviceInfo")
                env = 2
                osVersion = deviceInfo.GetOSVersion()
                if (mparticle()._internal.configuration.development) then
                    env = 1
                end if
                m.collectedApplicationInfo = {
                    an: appInfo.GetTitle(),
                    av: appInfo.getVersion(),
                    apn: appInfo.GetID(),
                    abn: appInfo.GetValue("build_version"),
                    env: env
                }
            end if
            return m.collectedApplicationInfo
        end function,

        DeviceInformation: function() as object
            if (m.collectedDeviceInfo = invalid) then
                info = CreateObject("roDeviceInfo")

                tempDatetime = CreateObject ("roDateTime")
                utcSeconds = tempDatetime.AsSeconds ()
                tempDatetime.ToLocalTime ()
                localSeconds = tempDatetime.AsSeconds ()
                utcSecondsOffset = localSeconds - utcSeconds
                utcHoursOffset = utcSecondsOffset / 3600
                versionArray = info.GetOsVersion()
                versionString = versionArray["major"] + "." + versionArray["minor"]

                m.collectedDeviceInfo = {
                    dp: "Roku",
                    dn: info.GetModelDisplayName(),
                    p: info.GetModel(),
                    vr: versionString,
                    rida: info.GetRIDA(),
                    lat: info.IsRIDADisabled(),
                    rpb: info.GetChannelClientId(),
                    dmdl: info.GetModel(),
                    dc: info.GetCountryCode(),
                    dll: info.GetCurrentLocale(),
                    dlc: info.GetUserCountryCode(),
                    tzn: info.GetTimeZone(),
                    dr: info.GetConnectionType(),
                    tz: utcHoursOffset
                }

                modelDetails = info.GetModelDetails()
                if (modelDetails <> invalid) then
                    m.collectedDeviceInfo.b = modelDetails["VendorName"]
                    m.collectedDeviceInfo.dma = modelDetails["VendorName"]
                end if

                displaySize = info.GetDisplaySize()
                if (displaySize <> invalid) then
                    m.collectedDeviceInfo.dsh = displaySize["h"]
                    m.collectedDeviceInfo.dsw = displaySize["w"]
                end if


                buildIdArray = CreateObject("roByteArray")
                buildIdArray.FromAsciiString(mparticle()._internal.utils.currentChannelVersion())
                digest = CreateObject("roEVPDigest")
                digest.Setup("md5")
                digest.update(buildIdArray)
                m.collectedDeviceInfo.bid = digest.final()
                m.collectedDeviceInfo.dosv = versionString

            end if
            return m.collectedDeviceInfo
        end function
    }

    mpNetworking = {
        messagePort: messagePort,
        mpBackoff: {
            nextAllowedUploadTime: 0,
            currentBackoffDuration: 0,
            reset: function()
                m.currentBackoffDuration = 0
                m.nextAllowedUploadTime = 0
            end function,
            increase: function()
                maxDuration = 2 * 60 * 60 * 1000
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

                m.nextAllowedUploadTime = mparticle()._internal.utils.unixTimeMillis() + m.currentBackoffDuration
            end function,
            setBackoff: function(backoffDuration as longinteger)
                m.nextAllowedUploadTime = mparticle()._internal.utils.unixTimeMillis() + backoffDuration
            end function,
            canUpload: function() as boolean
                if (m.nextAllowedUploadTime = 0)
                    return true
                else
                    currentTime = mparticle()._internal.utils.unixTimeMillis()
                    return currentTime >= m.nextAllowedUploadTime
                end if
            end function
        },
        pendingTransfers: {},
        messageQueue: [],
        uploadQueue: [],
        queueMessage: function(message as object)
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
        queueUpload: function()
            if (m.messageQueue.count() > 0 and mparticle()._internal.storage.getCurrentMpid() <> "0") then
                upload = mparticle()._internal.internalModel.Batch(m.messageQueue)
                m.uploadQueue.push(upload)
                m.messageQueue = []
            end if
        end function,
        processUploads: function()
            if (m.mpBackoff.canUpload()) then
                m.mpBackoff.reset()
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
                m.mpUploadBatch(nextUpload)
            end while
        end function,

        mpUploadBatch: function(mpBatch as object)
            urlTransfer = CreateObject("roUrlTransfer")
            if (mparticle()._internal.configuration.enablePinning) then
                urlTransfer.SetCertificatesFile(mparticle()._internal.configuration.certificateDir)
            end if
            urlTransfer.SetUrl("https://nativesdks.mparticle.com/v2/" + mparticle()._internal.configuration.apikey + "/events")
            urlTransfer.EnableEncodings(true)
            requestId = urlTransfer.GetIdentity().ToStr()
            m.pendingTransfers[requestId] = { "transfer": urlTransfer, "batch": mpBatch }
            dateString = CreateObject("roDateTime").ToISOString()
            jsonBatch = FormatJson(mpBatch)
            hashString = "POST" + Chr(10) + dateString + Chr(10) + "/v2/" + mparticle()._internal.configuration.apikey + "/events" + jsonBatch

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
            urlTransfer.AddHeader("Content-Type", "application/json")
            urlTransfer.AddHeader("User-Agent", "mParticle Roku SDK/" + mpBatch.sdk)
            urlTransfer.RetainBodyOnError(true)
            mplogger = mparticle()._internal.logger
            mplogger.debug("Uploading batch: " + jsonBatch)
            urlTransfer.setPort(m.messagePort)
            urlTransfer.AsyncPostFromString(jsonBatch)
        end function,

        mpHandleUrlEvent: function(urlEvent as object)
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
                        headers = urlEvent.GetResponseHeadersArray()
                        m.uploadQueue.unshift(transfer.batch)
                        for each header in headers
                            if (header["Retry-After"] <> invalid) then
                                backoff = parsejson(header["Retry-After"])
                            end if
                        end for
                        if (backoff <> invalid and backoff > 0) then
                            m.mpBackoff.setBackoff(backoff)
                        else
                            m.mpBackoff.increase()
                        end if
                    else if (responseCode = 202 and responseBody <> invalid) then
                        responseObject = parsejson(responseBody)
                        if (responseObject <> invalid) then
                            storage = mparticle()._internal.storage
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
            onSdkStart: function()
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
            getCurrentSession: function()
                return m.currentSession
            end function,
            updateLastEventTime: function(time as longinteger)
                m.currentSession.lastEventTime = time
                m.saveSession()
            end function,
            onForeground: function(time as longinteger)
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
            addSessionMpid: function(mpid as string) as void
                m.currentSession.sessionMpids.push(mpid)
                m.saveSession()
            end function,
            createSession: function(previousSession = invalid as object)
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
                    sessionId: mparticle()._internal.utils.randomGuid(),
                    startTime: currentTime,
                    dataConnection: deviceInfo.GetConnectionType(),
                    launchReferrer: launchReferrer
                    lastEventTime: currentTime,
                    previousSessionLength: previousSessionLength,
                    previousSessionId: previousSessionId,
                    previousSessionStartTime: previousSessionStartTime,
                    attributes: {},
                    sessionMpids: [mparticle()._internal.storage.getCurrentMpid()]
                }
            end function,
            sessionLength: function(session as object) as integer
                return (session.lastEventTime - session.startTime)
            end function,
        }
        sessionManager.append(sessionManagerApi)
        return sessionManager
    end function

    mpPublicModels = {
        Message: function(messageType as string, attributes = {}) as object
            currentSession = mparticle()._internal.sessionManager.getCurrentSession()
            if (attributes <> invalid)
                if (attributes.count() = 0) then
                    attributes = invalid
                else
                    mputils = mparticle()._internal.utils
                    attributeKeys = attributes.Keys()
                    validAttributes = {}
                    for each attributeKey in attributeKeys
                        if (mputils.isString(attributes[attributeKey])) then
                            validAttributes[attributeKey] = attributes[attributeKey]
                        end if
                    end for
                    attributes = validAttributes
                end if
            end if
            return {
                dt: messageType,
                id: mparticle()._internal.utils.randomGuid(),
                ct: mparticle()._internal.utils.unixTimeMillis(),
                attrs: attributes,
                sid: currentSession.sessionId,
                sct: currentSession.startTime
            }
        end function,

        CustomEvent: function(eventName as string, eventType as string, customAttributes = {}) as object
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

        SessionStart: function(session as object) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.SESSION_START)
            message.ct = session.startTime
            message.id = session.sessionId
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
            message.smpids = session.sessionMpids
            return message
        end function,

        OptOut: function(optOut as boolean) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.OPT_OUT)
            message.s = optOut
            return message
        end function,

        CommerceEvent: function(productAction = {} as object, promotionAction = {} as object, impressions = [] as object, customAttributes = {} as object, screenName = invalid as string) as object
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

        UserAttributeChange: function(userAttributeKey as string, newValue as object, oldValue as object, deleted as boolean, isNewAttribute as boolean) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.USER_ATTRIBUTE_CHANGE)
            message.n = userAttributeKey
            message.nv = newValue
            message.ov = oldValue
            message.d = deleted
            message.na = isNewAttribute

            return message
        end function,

        UserIdentityChange: function(newIdentity as object, oldIdentity as object) as object
            message = m.Message(mParticleConstants().MESSAGE_TYPE.USER_IDENTITY_CHANGE)
            message.ni = newIdentity
            message.oi = oldIdentity

            return message
        end function,

    }

    mpInternalIdentityApi = {
        context: "",
        IDENTITY_API_PATHS: {
            IDENTIFY: "identify",
            LOGIN: "login",
            LOGOUT: "logout",
            MODIFY: "modify"
        },
        pendingApiRequests: {},
        messagePort: messagePort,
        identify: function(identityApiRequest as object) as void
            m.performIdentityHttpRequest(m.IDENTITY_API_PATHS.IDENTIFY, identityApiRequest)
        end function,
        login: function(identityApiRequest as object) as void
            m.performIdentityHttpRequest(m.IDENTITY_API_PATHS.LOGIN, identityApiRequest)
        end function,
        logout: function(identityApiRequest as object) as void
            m.performIdentityHttpRequest(m.IDENTITY_API_PATHS.LOGOUT, identityApiRequest)
        end function,
        modify: function(identityApiRequest as object) as void
            modifyPath = mparticle()._internal.storage.getCurrentMpid() + "/" + m.IDENTITY_API_PATHS.MODIFY
            m.performIdentityHttpRequest(modifyPath, identityApiRequest)
        end function,
        generateIdentityHttpBody: function(path as string, identityApiRequest as object) as object
            environmentString = "production"
            if (mparticle()._internal.configuration.development) then
                environmentString = "development"
            end if
            identityHttpRequest = {
                client_sdk: {
                    platform: "roku",
                    sdk_vendor: "mparticle",
                    sdk_version: mParticleConstants().SDK_VERSION
                },
                environment: environmentString,
                requestId: mparticle()._internal.utils.randomGuid(),
                request_timestamp_ms: mparticle()._internal.utils.unixTimeMillis(),
                context: m.context
            }
            mplogger = mparticle()._internal.logger
            if (identityApiRequest <> invalid) then
                if (not identityApiRequest.DoesExist("userIdentities")) then
                    identityApiRequest.userIdentities = {}
                end if
                identityKeys = identityApiRequest.userIdentities.Keys()
                if (path.Instr(m.IDENTITY_API_PATHS.MODIFY) = -1) then
                    identityHttpRequest.known_identities = {}
                    for each identityType in identityKeys
                        if (mparticleConstants().IDENTITY_TYPE.isValidIdentityType(identityType)) then
                            identityHttpRequest.known_identities[identityType] = identityApiRequest.userIdentities[identityType]
                        else
                            mplogger.error("Invalid identity passed to identity API: " + path)
                        end if
                    end for
                    identityHttpRequest.known_identities.device_application_stamp = mparticle()._internal.storage.getDas()
                    deviceInfo = CreateObject("roDeviceInfo")
                    if (not deviceInfo.IsRIDADisabled()) then
                        identityHttpRequest.known_identities.roku_aid = deviceInfo.GetRIDA()
                    end if
                    identityHttpRequest.known_identities.roku_publisher_id = deviceInfo.GetChannelClientId()
                else
                    identityHttpRequest.identity_changes = []
                    currentUserIdentities = m.getCurrentUser().userIdentities
                    for each identityType in identityKeys
                        if (mparticleConstants().IDENTITY_TYPE.isValidIdentityType(identityType))
                            identityChange = { identity_type: identityType }
                            if (identityApiRequest.userIdentities[identityType].len() > 0) then
                                identityChange.new_value = identityApiRequest.userIdentities[identityType]
                            end if
                            if (currentUserIdentities.DoesExist(identityType))
                                identityChange.old_value = currentUserIdentities[identityType]
                            end if
                            identityHttpRequest.identity_changes.Push(identityChange)
                        end if
                    end for
                end if
            end if
            return identityHttpRequest
        end function,
        performIdentityHttpRequest: function(path as string, identityApiRequest as object) as object
            mplogger = mparticle()._internal.logger
            mplogger.debug("Starting Identity API request: " + path)
            identityHttpBody = m.generateIdentityHttpBody(path, identityApiRequest)
            mplogger.debug("Identity API request:" + Chr(10) + "Path:" + path + Chr(10) + "Body:" + formatjson(identityHttpBody))
            urlTransfer = CreateObject("roUrlTransfer")
            if (mparticle()._internal.configuration.enablePinning) then
                urlTransfer.SetCertificatesFile(mparticle()._internal.configuration.certificateDir)
            end if
            urlTransfer.SetUrl("https://identity.mparticle.com/v1/" + path)
            urlTransfer.EnableEncodings(true)
            requestId = urlTransfer.GetIdentity().ToStr()
            m.pendingApiRequests[requestId] = { "transfer": urlTransfer, "originalPublicRequest": identityApiRequest, "path": path }
            dateString = CreateObject("roDateTime").ToISOString()
            jsonRequest = FormatJson(identityHttpBody)
            hashString = "POST" + Chr(10) + dateString + Chr(10) + "/v1/" + path + jsonRequest

            signature_key = CreateObject("roByteArray")
            signature_key.fromAsciiString(mparticle()._internal.configuration.apisecret)

            hmac = CreateObject("roHMAC")
            hmac.Setup("sha256", signature_key)
            message = CreateObject("roByteArray")
            message.FromAsciiString(hashString)
            result = hmac.process(message)
            hashResult = LCase(result.ToHexString())

            urlTransfer.AddHeader("Date", dateString)
            urlTransfer.AddHeader("x-mp-key", mparticle()._internal.configuration.apikey)
            urlTransfer.AddHeader("x-mp-signature", hashResult)
            urlTransfer.AddHeader("Content-Type", "application/json")
            urlTransfer.AddHeader("User-Agent", "mParticle Roku SDK/" + mParticleConstants().SDK_VERSION)
            urlTransfer.RetainBodyOnError(true)
            urlTransfer.setPort(m.messagePort)
            urlTransfer.AsyncPostFromString(jsonRequest)
        end function,
        mpHandleUrlEvent: function(urlEvent as object) as object
            mplogger = mparticle()._internal.logger
            requestId = urlEvent.GetSourceIdentity().ToStr()
            requestWrapper = m.pendingApiRequests[requestId]
            if (requestWrapper = invalid)
                mplogger.debug("Unknown URL event passed to mParticle, ignoring...")
            else
                m.pendingApiRequests.delete(requestId)
                responseCode = urlEvent.GetResponseCode()
                responseBody = urlEvent.GetString()
                mplogger.debug("Identity response: code" + str(responseCode) + " body: " + responseBody)
                responseObject = {}
                if (responseBody <> invalid and responseBody.Len() > 0) then
                    responseObject = parsejson(responseBody)
                end if

                if (responseCode = -77) then
                    mplogger.error("SSL error - please make sure " + mparticle()._internal.configuration.certificateDir + " is present.")
                else if (responseCode = 400) then
                    mplogger.error("HTTP 400 - bad request.")
                else if (responseCode = 401) then
                    mplogger.error("HTTP 401 - please check that your mParticle key and secret are valid.")
                else if (responseCode = 429 or responseCode = 503) then
                    mplogger.error("Identity request is being throttled - please try again later.")
                else if (responseCode = 200) then
                    storage = mparticle()._internal.storage
                    updateMpid = storage.getCurrentMpid()
                    if (requestWrapper.path.Instr(m.IDENTITY_API_PATHS.MODIFY) = -1) then
                        if (responseObject <> invalid and responseObject.DoesExist("mpid")) then
                            if (responseObject.DoesExist("context")) then
                                m.context = responseObject.context
                            end if
                            if (responseObject.DoesExist("mpid")) then
                                m.onMpidChanged(responseObject.mpid)
                            end if
                            updateMpid = responseObject.mpid
                        else
                            mplogger.error("Identity API returned 200, but there was no MPID present in response.")
                        end if
                    end if
                    m.onIdentitySuccess(updateMpid, requestWrapper.originalPublicRequest)
                else
                    mplogger.error("Unknown error while performing identity request.")
                end if
                return {
                    httpCode: responseCode,
                    body: responseObject
                }
            end if
        end function,
        isIdentityRequest: function(requestId as string) as boolean
            return m.pendingApiRequests.DoesExist(requestId)
        end function,
        onIdentitySuccess: function(mpid as string, originalRequest as object)
            storage = mparticle()._internal.storage
            if (originalRequest <> invalid and originalRequest.userIdentities <> invalid) then
                for each identityType in originalRequest.userIdentities.keys()
                    storage.setUserIdentity(mpid, identityType, originalRequest.userIdentities[identityType])
                end for
            end if
        end function,
        onMpidChanged: function(mpid as string) as void
            storage = mparticle()._internal.storage
            if (mpid <> storage.getCurrentMpid()) then
                networking = mparticle()._internal.networking
                networking.queueUpload()
                storage.setCurrentMpid(mpid)
                sessionManager = mparticle()._internal.sessionManager
                sessionManager.addSessionMpid(mpid)
            end if
        end function,
        getCurrentUser: function() as object
            storage = mparticle()._internal.storage
            currentMpid = storage.getCurrentMpid()
            internalIdentities = storage.getUserIdentities(currentMpid)
            publicIdentities = {}
            if (internalIdentities <> invalid) then
                keys = internalIdentities.Keys()
                for each identity in keys
                    publicIdentities[identity] = internalIdentities[identity].i
                end for
            end if
            return {
                mpid: currentMpid,
                userIdentities: publicIdentities,
                userAttributes: storage.getUserAttributes(currentMpid)
            }
        end function
    }

    mpIdentityApi = {
        identify: function(identityApiRequest as object) as void
            identity = mparticle()._internal.identity
            identity.identify(identityApiRequest)
        end function,
        login: function(identityApiRequest as object) as void
            identity = mparticle()._internal.identity
            identity.login(identityApiRequest)
        end function,
        logout: function(identityApiRequest as object) as void
            identity = mparticle()._internal.identity
            identity.logout(identityApiRequest)
        end function,
        modify: function(identityApiRequest as object) as void
            identity = mparticle()._internal.identity
            identity.modify(identityApiRequest)
        end function,
        setUserAttribute: function(attributeKey as string, attributeValue as object) as void
            mputils = mparticle()._internal.utils
            mplogger = mparticle()._internal.logger
            mpGenericMessage = "User attribute values must be strings or arrays of strings. Discarding value passed to setUserAttribute(): "
            if (attributeValue = invalid) then
                mplogger.error(mpGenericMessage + "<invalid>")
                return
            end if
            if (not mputils.isString(attributeValue)) then
                if (not mputils.isArray(attributeValue)) then
                    mplogger.error(mpGenericMessage + type(attributeValue))
                    return
                end if
                for each value in attributeValue
                    if (not mputils.isString(value)) then
                        mplogger.error(mpGenericMessage + type(value))
                        return
                    end if
                end for
            end if
            storage = mparticle()._internal.storage
            storage.setUserAttribute(storage.getCurrentMpid(), attributeKey, attributeValue)
        end function,
        removeUserAttribute: function(attributeKey as string) as void
            mputils = mparticle()._internal.utils
            mplogger = mparticle()._internal.logger
            mpGenericMessage = "User attribute must exist. Discarding user attribue passed to removeUserAttribute(): "
            currentMpid = mparticle()._internal.storage.getCurrentMpid()
            attributes = mparticle()._internal.storage.getUserAttributes(currentMpid)
            if (not attributes.DoesExist(attributeKey)) then
                mplogger.error(mpGenericMessage + attributeKey)
                return
            end if
            storage = mparticle()._internal.storage
            storage.removeUserAttribute(currentMpid, attributeKey)
        end function,
        setIntegrationAttribute: function(integrationId as string, attributeKey as string, attributeValue as object) as void
            mputils = mparticle()._internal.utils
            mplogger = mparticle()._internal.logger
            mpGenericMessage = "Integration Attribute values must be strings or arrays of strings. Discarding value passed to setIntegrationAttribute(): "
            if (attributeValue = invalid) then
                mplogger.error(mpGenericMessage + "<invalid>")
                return
            end if
            if (not mputils.isString(attributeValue)) then
                if (not mputils.isArray(attributeValue)) then
                    mplogger.error(mpGenericMessage + type(attributeValue))
                    return
                end if
                for each value in attributeValue
                    if (not mputils.isString(value)) then
                        mplogger.error(mpGenericMessage + type(value))
                        return
                    end if
                end for
            end if
            storage = mparticle()._internal.storage
            storage.setIntegrationAttribute(storage.getCurrentMpid(), integrationId, attributeKey, attributeValue)
        end function,
        setConsentState: function(consentState as object) as void
            storage = mparticle()._internal.storage
            storage.setConsentState(storage.getCurrentMpid(), consentState)
        end function,
        IdentityApiRequest: function(userIdentities as object, copyUserAttributes as boolean) as object
            return {
                "userIdentities": userIdentities,
                "copyUserAttributes": copyUserAttributes
            }

        end function,
        getCurrentUser: function() as object
            identity = mparticle()._internal.identity
            return identity.getCurrentUser()
        end function
    }

    mpMediaApi = {
        getEventAttributes: function(mediaSession as object, customAttributes = {} as object) as object
            eventAttributes = customAttributes
            if (mediaSession <> invalid) then
                eventAttributes.media_session_id = mediaSession.mediaSessionId
                if (mediaSession.currentPlayheadPosition <> invalid) then
                    eventAttributes.playhead_position = mediaSession.currentPlayheadPosition.ToStr()
                end if
                eventAttributes.content_title = mediaSession.title
                eventAttributes.content_id = mediaSession.contentId
                if (mediaSession.duration <> invalid) then
                    eventAttributes.content_duration = mediaSession.duration.ToStr()
                end if
                eventAttributes.stream_type = mediaSession.streamType
                eventAttributes.content_type = mediaSession.contentType

                if (mediaSession.adContent <> invalid) then
                    eventAttributes.ad_content_title = mediaSession.adContent.title
                    if (mediaSession.adContent.duration <> invalid) then
                        eventAttributes.ad_content_duration = mediaSession.adContent.duration.ToStr()
                    end if
                    eventAttributes.ad_content_id = mediaSession.adContent.id
                    eventAttributes.ad_content_advertiser = mediaSession.adContent.advertiser
                    eventAttributes.ad_content_campaign = mediaSession.adContent.campaign
                    eventAttributes.ad_content_creative = mediaSession.adContent.creative
                    eventAttributes.ad_content_placement = mediaSession.adContent.placement
                    if (mediaSession.adContent.position <> invalid) then
                        eventAttributes.ad_content_position = mediaSession.adContent.position.ToStr()
                    end if
                    eventAttributes.ad_content_site_id = mediaSession.adContent.siteId
                end if

                if (mediaSession.adBreak <> invalid) then
                    eventAttributes.ad_break_title = mediaSession.adBreak.title
                    if (mediaSession.adBreak.duration <> invalid) then
                        eventAttributes.ad_break_duration = mediaSession.adBreak.duration.ToStr()
                    end if
                    if (mediaSession.currentPlayheadPosition <> invalid) then
                        eventAttributes.ad_break_playback_time = mediaSession.currentPlayheadPosition.ToStr()
                    end if
                    eventAttributes.ad_break_id = mediaSession.adBreak.id
                end if

                if (mediaSession.segment <> invalid) then
                    eventAttributes.segment_title = mediaSession.segment.title
                    if (mediaSession.segment.index <> invalid) then
                        eventAttributes.segment_index = mediaSession.segment.index.ToStr()
                    end if
                    if (mediaSession.segment.duration <> invalid) then
                        eventAttributes.segment_duration = mediaSession.segment.duration.ToStr()
                    end if
                end if

                if (mediaSession.mediaSessionAttributes.count() > 0) then
                    mputils = mparticle()._internal.utils
                    mediaSessionAttributes = mediaSession.mediaSessionAttributes
                    attributeKeys = mediaSessionAttributes.Keys()
                    for each attributeKey in attributeKeys
                        if (mputils.isString(mediaSessionAttributes[attributeKey])) then
                            eventAttributes[attributeKey] = mediaSessionAttributes[attributeKey]
                        end if
                    end for
                endif
            end if

            return eventAttributes
        end function
        getSummaryAttributes: function(mediaSession as object, customAttributes = {} as object) as object
            eventAttributes = m.getEventAttributes(mediaSession, customAttributes)
            if (mediaSession <> invalid) then
                if (mediaSession.mediaSessionStartTime <> invalid) then
                    eventAttributes.media_session_start_time = mediaSession.mediaSessionStartTime.ToStr()
                    if (mediaSession.mediaSessionEndTime <> invalid) then
                        eventAttributes.media_session_end_time = mediaSession.mediaSessionEndTime.ToStr()

                        timeSpent = mediaSession.mediaSessionEndTime - mediaSession.mediaSessionStartTime
                        eventAttributes.media_time_spent = timeSpent.ToStr()
                    end if
                end if
                if (mediaSession.mediaContentComplete)
                    eventAttributes.media_content_complete = "true"
                else
                    eventAttributes.media_content_complete = "false"
                end if
                if (mediaSession.mediaContentTimeSpent <> invalid) then
                    eventAttributes.media_content_time_spent = mediaSession.mediaContentTimeSpent.ToStr()
                end if
                eventAttributes.media_session_segment_total = mediaSession.mediaSessionSegmentTotal.ToStr()
                eventAttributes.media_session_ad_total = mediaSession.mediaSessionAdTotal.ToStr()
                eventAttributes.media_total_ad_time_spent = mediaSession.mediaTotalAdTimeSpent.ToStr()
                eventAttributes.media_ad_time_spent_rate = mediaSession.mediaAdTimeSpentRate.ToStr()
                eventAttributes.media_session_ad_objects = formatjson(mediaSession.mediaSessionAdObjects)

                if (mediaSession.adContent <> invalid) then
                    if (mediaSession.adContent.adStartTime <> invalid) then
                        eventAttributes.ad_content_start_time = mediaSession.adContent.adStartTime.ToStr()
                    end if
                    if (mediaSession.adContent.adEndTime <> invalid) then
                        eventAttributes.ad_content_end_time = mediaSession.adContent.adEndTime.ToStr()
                    end if
                    eventAttributes.ad_completed = mediaSession.adContent.adCompleted
                    eventAttributes.ad_skipped = mediaSession.adContent.adSkipped
                end if

                if (mediaSession.segment <> invalid) then
                    if (mediaSession.segment.segmentStartTime <> invalid) then
                        eventAttributes.segment_start_time = mediaSession.segment.segmentStartTime.ToStr()
                        if (mediaSession.segment.segmentEndTime <> invalid) then
                            eventAttributes.segment_end_time = mediaSession.segment.segmentEndTime.ToStr()
                            timeSpent = mediaSession.segment.segmentEndTime - mediaSession.segment.segmentStartTime
                            eventAttributes.media_segment_time_spent = timeSpent.ToStr()
                        end if
                    end if
                    if (mediaSession.segment.segmentCompleted)
                        eventAttributes.segment_completed = "true"
                    else
                        eventAttributes.segment_completed = "false"
                    end if
                    if (mediaSession.segment.segmentSkipped)
                        eventAttributes.segment_skipped = "true"
                    else
                        eventAttributes.segment_skipped = "false"
                    end if
                end if
            end if

            return eventAttributes
        end function
        sendMediaMessage: function(eventName as string, eventType as string, attributes = {}) as void
            messageType = mParticleConstants().MESSAGE_TYPE.CUSTOM
            currentSession = mparticle()._internal.sessionManager.getCurrentSession()
            if (attributes <> invalid)
                if (attributes.count() = 0) then
                    attributes = invalid
                else
                    mputils = mparticle()._internal.utils
                    attributeKeys = attributes.Keys()
                    validAttributes = {}
                    for each attributeKey in attributeKeys
                        if (mputils.isString(attributes[attributeKey])) then
                            validAttributes[attributeKey] = attributes[attributeKey]
                        end if
                    end for
                    attributes = validAttributes
                end if
            end if
            message = {
                dt: messageType,
                id: mparticle()._internal.utils.randomGuid(),
                ct: mparticle()._internal.utils.unixTimeMillis(),
                attrs: attributes,
                sid: currentSession.sessionId,
                sct: currentSession.startTime
            }
            message.n = eventName
            message.et = eventType
            message.est = message.ct
            mparticle().logMessage(message)
        end function,
        logMediaSessionStart: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SESSION_START, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logMediaSessionEnd: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SESSION_END, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logMediaSessionSummary: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getSummaryAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SESSION_SUMMARY, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logMediaContentEnd: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.CONTENT_END, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logPlay: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.PLAY, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logPause: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.PAUSE, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logSeekStart: function(mediaSession as object, position as double, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            customAttributes.seek_position = position
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SEEK_START, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logSeekEnd: function(mediaSession as object, position as double, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            customAttributes.seek_position = position
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SEEK_END, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logBufferStart: function(mediaSession as object, duration as double, bufferPercent as double, position as double, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            customAttributes.buffer_duration = duration.ToStr()
            customAttributes.buffer_percent = bufferPercent.ToStr()
            customAttributes.buffer_position = position.ToStr()
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.BUFFER_START, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logBufferEnd: function(mediaSession as object, duration as double, bufferPercent as double, position as double, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            customAttributes.buffer_duration = duration.ToStr()
            customAttributes.buffer_percent = bufferPercent.ToStr()
            customAttributes.buffer_position = position.ToStr()
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.BUFFER_END, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logAdBreakStart: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.AD_BREAK_START, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logAdBreakEnd: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.AD_BREAK_END, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
            mediaSession.adBreak = invalid
        end function
        logAdStart: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.AD_START, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logAdClick: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.AD_CLICK, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logAdSkip: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.AD_SKIP, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
            mediaSession.adContent = invalid
        end function
        logAdEnd: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.AD_END, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
            mediaSession.adContent = invalid
        end function
        logAdSummary: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getSummaryAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.AD_SUMMARY, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logSegmentStart: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SEGMENT_START, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logSegmentSkip: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SEGMENT_SKIP, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
            mediaSession.segment = invalid
        end function
        logSegmentEnd: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SEGMENT_END, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
            mediaSession.segment = invalid
        end function
        logSegmentSummary: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getSummaryAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.SEGMENT_SUMMARY, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logPlayheadPosition: function(mediaSession as object, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.UPDATE_PLAYHEAD_POSITION, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
        logQoS: function(mediaSession as object, startupTime as integer, droppedFrames as integer, bitRate as integer, fps as integer, options = {} as object) as void
            customAttributes = m.getEventAttributes(mediaSession, options)
            customAttributes.qos_bitrate = bitRate.ToStr()
            customAttributes.qos_fps = fps.ToStr()
            customAttributes.qos_startup_time = startupTime.ToStr()
            customAttributes.qos_dropped_frames = droppedFrames.ToStr()
            m.sendMediaMessage(mparticleConstants().MEDIA_EVENT_NAME.UPDATE_QOS, mparticleConstants().CUSTOM_EVENT_TYPE.MEDIA, customAttributes)
        end function
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
    mpPerformStartupTasks = function(options as object)
        storage = mparticle()._internal.storage
        storage.cleanCookies()
        sessionManager = mparticle()._internal.sessionManager
        sessionManager.onSdkStart()

        identityApi = mparticle().identity
        identifyRequest = options.identifyRequest
        if (identifyRequest = invalid) then
            identifyRequest = { userIdentities: identityApi.getCurrentUser().userIdentities }
        end if

        identityApi.identify(identifyRequest)
    end function


    '
    ' Public API implementations
    '
    mpPublicApi = {
        logEvent: function(eventName as string, eventType = mParticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes = {}) as void
            m.logMessage(m.model.CustomEvent(eventName, eventType, customAttributes))
        end function,
        logScreenEvent: function(screenName as string, customAttributes = {}) as void
            m.logMessage(m.model.ScreenEvent(screenName, customAttributes))
        end function,
        logCommerceEvent: function(productAction = {} as object, promotionAction = {} as object, impressions = [] as object, customAttributes = {} as object, screenName = invalid as string)
            m.logMessage(m.model.CommerceEvent(productAction, promotionAction, impressions, customAttributes, screenName))
        end function,
        logMessage: function(message as object) as void
            mplogger = mparticle()._internal.logger
            mplogger.debug("Logging message: " + formatjson(message))
            m._internal.networking.queueMessage(message)
        end function,
        setSessionAttribute: function(attributeKey as string, attributeValue as string) as void
            m._internal.sessionManager.setSessionAttribute(attributeKey, attributeValue)
        end function,
        setOptOut: function(optOut as boolean) as void
            m.logMessage(m.model.OptOut(optOut))
        end function,
        onUrlEvent: function(urlEvent as object)
            if (m._internal.identity.isIdentityRequest(urlEvent.getSourceIdentity().tostr())) then
                return m._internal.identity.mpHandleUrlEvent(urlEvent)
            else
                m._internal.networking.mpHandleUrlEvent(urlEvent)
            end if
        end function,
        isMparticleEvent: function(sourceIdentity as integer) as boolean
            isBatchUpload = m._internal.networking.pendingTransfers.DoesExist(sourceIdentity.tostr())
            isIdentityRequest = m._internal.identity.isIdentityRequest(sourceIdentity.tostr())
            return isBatchUpload or isIdentityRequest
        end function,
        upload: function() as void
            m._internal.networking.queueUpload()
            m._internal.networking.processUploads()
        end function,
        identity: mpIdentityApi,
        media: mpMediaApi,
        model: mpPublicModels
    }

    internalApi = {
        utils: mpUtils,
        logger: mpLogger,
        configuration: mpCreateConfiguration(options),
        networking: mpNetworking,
        storage: mpCreateStorage(),
        sessionManager: mpCreateSessionManager(options.startupArgs)
        internalModel: mpInternalModel,
        identity: mpInternalIdentityApi
    }

    mpPublicApi.append({ _internal: internalApi })
    getGlobalAA().mparticleInstance = mpPublicApi
    mpPerformStartupTasks(options)
end function


' mParticle Scene Graph Bridge
' Use an instance of this class to make calls to mParticle over Scene Graph
function mParticleSGBridge(task as object) as object
    mpCreateSGBridgeIdentityApi = function(task as object) as object
        return {
            mParticleTask: task
            identify: function(identityApiRequest) as void
                m.invokeFunction("identity/identify", [identityApiRequest])
            end function,
            login: function(identityApiRequest) as void
                m.invokeFunction("identity/login", [identityApiRequest])
            end function,
            logout: function(identityApiRequest) as void
                m.invokeFunction("identity/logout", [identityApiRequest])
            end function,
            modify: function(identityApiRequest) as void
                m.invokeFunction("identity/modify", [identityApiRequest])
            end function,
            setUserAttribute: function(attributeKey as string, attributeValue as object) as void
                m.invokeFunction("identity/setUserAttribute", [attributeKey, attributeValue])
            end function,
            removeUserAttribute: function(attributeKey as string) as void
                m.invokeFunction("identity/removeUserAttribute", [attributeKey])
            end function
            setIntegrationAttribute: function(integrationId as string, attributeKey as string, attributeValue as object) as void
                m.invokeFunction("identity/setIntegrationAttribute", [integrationId, attributeKey, attributeValue])
            end function,
            setConsentState: function(consentState as object) as void
                m.invokeFunction("identity/setConsentState", [consentState])
            end function
            invokeFunction: function(name as string, args)
                invocation = {}
                invocation.methodName = name
                invocation.args = args
                m.mParticleTask[mParticleConstants().SCENEGRAPH_NODES.API_CALL_NODE] = invocation
            end function
        }
    end function
    mpCreateSGBridgeMediaApi = function(task as object) as object
        return {
            mParticleTask: task
            logMediaSessionStart: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logMediaSessionStart", [mediaSession, options])
            end function,
            logMediaSessionEnd: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logMediaSessionEnd", [mediaSession, options])
            end function,
            logMediaSessionSummary: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logMediaSessionSummary", [mediaSession, options])
            end function,
            logMediaContentEnd: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logMediaContentEnd", [mediaSession, options])
            end function,
            logPlay: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logPlay", [mediaSession, options])
            end function,
            logPause: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logPause", [mediaSession, options])
            end function,
            logSeekStart: function(mediaSession as object, position as double, options = {} as object) as void
                m.invokeFunction("media/logSeekStart", [mediaSession, position, options])
            end function,
            logSeekEnd: function(mediaSession as object, position as double, options = {} as object) as void
                m.invokeFunction("media/logSeekEnd", [mediaSession, position, options])
            end function,
            logBufferStart: function(mediaSession as object, duration as double, bufferPercent as double, position as double, options = {} as object) as void
                m.invokeFunction("media/logBufferStart", [mediaSession, duration, bufferPercent, position, options])
            end function,
            logBufferEnd: function(mediaSession as object, duration as double, bufferPercent as double, position as double, options = {} as object) as void
                m.invokeFunction("media/logBufferEnd", [mediaSession, duration, bufferPercent, position, options])
            end function,
            logAdBreakStart: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logAdBreakStart", [mediaSession, options])
            end function,
            logAdBreakEnd: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logAdBreakEnd", [mediaSession, options])
            end function,
            logAdStart: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logAdStart", [mediaSession, options])
            end function,
            logAdClick: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logAdClick", [mediaSession, options])
            end function,
            logAdSkip: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logAdSkip", [mediaSession, options])
            end function,
            logAdEnd: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logAdEnd", [mediaSession, options])
            end function,
            logAdSummary: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logAdSummary", [mediaSession, options])
            end function,
            logSegmentStart: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logSegmentStart", [mediaSession, options])
            end function,
            logSegmentSkip: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logSegmentSkip", [mediaSession, options])
            end function,
            logSegmentEnd: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logSegmentEnd", [mediaSession, options])
            end function,
            logSegmentSummary: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logSegmentSummary", [mediaSession, options])
            end function,
            logPlayheadPosition: function(mediaSession as object, options = {} as object) as void
                m.invokeFunction("media/logPlayheadPosition", [mediaSession, options])
            end function,
            logQoS: function(mediaSession as object, startupTime as integer, droppedFrames as integer, bitRate as integer, fps as integer, options = {} as object) as void
                m.invokeFunction("media/logQoS", [mediaSession, startupTime, droppedFrames, bitRate, fps, options])
            end function,
            invokeFunction: function(name as string, args)
                invocation = {}
                invocation.methodName = name
                invocation.args = args
                m.mParticleTask[mParticleConstants().SCENEGRAPH_NODES.API_CALL_NODE] = invocation
            end function
        }
    end function
    return {
        mParticleTask: task
        logEvent: function(eventName as string, eventType = mParticleConstants().CUSTOM_EVENT_TYPE.OTHER, customAttributes = {}) as void
            m.invokeFunction("logEvent", [eventName, eventType, customAttributes])
        end function,
        logScreenEvent: function(screenName as string, customAttributes = {}) as void
            m.invokeFunction("logScreenEvent", [screenName, customAttributes])
        end function,
        logCommerceEvent: function(productAction = {} as object, promotionAction = {} as object, impressions = [] as object, customAttributes = {} as object, screenName = "" as string)
            m.invokeFunction("logCommerceEvent", [productAction, promotionAction, impressions, customAttributes, screenName])
        end function,
        logMessage: function(message as object) as void
            m.invokeFunction("logMessage", [message])
        end function,
        setUserAttribute: function(attributeKey as string, attributeValue as object) as void
            m.invokeFunction("setUserAttribute", [attributeKey, attributeValue])
        end function,
        removeUserAttribute: function(attributeKey as string) as void
            m.invokeFunction("removeUserAttribute", [attributeKey])
        end function,
        setIntegrationAttribute: function(integrationId as string, attributeKey as string, attributeValue as object) as void
            m.invokeFunction("setIntegrationAttribute", [integrationId, attributeKey, attributeValue])
        end function,
        setConsentState: function(consentState as object) as void
            m.invokeFunction("setConsentState", [consentState])
        end function,
        setSessionAttribute: function(attributeKey as string, attributeValue as object) as void
            m.invokeFunction("setSessionAttribute", [attributeKey, attributeValue])
        end function,
        upload: function() as void
            m.invokeFunction("upload", [])
        end function,
        identity: mpCreateSGBridgeIdentityApi(task),
        media: mpCreateSGBridgeMediaApi(task),
        invokeFunction: function(name as string, args)
            invocation = {}
            invocation.methodName = name
            invocation.args = args
            m.mParticleTask[mParticleConstants().SCENEGRAPH_NODES.API_CALL_NODE] = invocation
        end function
    }

end function
