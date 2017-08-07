<img src="http://static.mparticle.com/sdk/logo.svg" width="280">

## Roku SDK

This is the public repo of the mParticle Roku SDK. mParticle's mission is straightforward: make it really easy to use all of the great services in the app ecosystem. Our SDKs and platform are designed to be your abstraction layer and data hub, and we do the work of integrating with each individual app service so you don't have to.

The platform has grown to support 100+ partners in the ecosystem, including developer tools, analytics, attribution, marketing automation, and advertising services. We also have a powerful audience engine that sits atop our platform to let you action on all of your data - [learn more here](https://www.mparticle.com)!

## Download

1. Navigate to the [releases section](https://github.com/mParticle/mparticle-roku-sdk/releases) and download the latest tagged source, or clone this repository.
2. Create an `mparticle/` directory inside the `pkg:/source/` directory.
3. Copy `mParticleBundle.crt` and `mParticleCore.brs` into the newly created `pkg:/source/mparticle` directory.
4. For Scene Graph support, copy `mParticleTask.brs` and `mParticleTask.xml` into your `pkg:/components/` directory.

## Initialize

The mParticle Roku SDK is compatible with both legacy and Scene Graph Roku channels - please reference the section below that applies to your environment.

### Legacy Channels

Initialize the SDK within your `main` method, or as soon as possible during the startup of your channel. In addition to your mParticle credentials, you must pass a reference to the message port of your main run loop, such that mParticle can make asynchronous network requests.

Within your main run loop, inspect the source identity and pass `roUrlEvent` objects to mParticle per the example below.

```brightscript
sub main(args as dynamic)
    screen = CreateObject("roPosterScreen") 
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)

    screen.ShowMessage("Hello mParticle!")
    screen.Show()
    
    options = {}
    options.logLevel = mparticleConstants().LOG_LEVEL.DEBUG
    options.apiKey = "REPLACE WITH API KEY"
    options.apiSecret = "REPLACE WITH API SECRET"
    options.startupArgs = args
    mParticleStart(options, port)

    while true
        msg = Wait(0, port)
        if type(msg) = "roUrlEvent"
            if mparticle().isMparticleEvent(msg.getSourceIdentity())
                mparticle().onUrlEvent(msg)
            end if
        else if type(msg) = "roPosterScreenEvent"
            if msg.isScreenClosed()
                exit while
            end if
        end if
    end while

    screen.Close()
end sub
```
The above will initialize the SDK, creating an mParticle install and user session.

### Scene Graph Channels

The Scene Graph SDK allows for running mParticle entirely in a separate thread for better performance, upload batching, and more accurate session management. You should include a single mParticle Task in every scene in your channel.

#### 1. Configure mParticle

When creating a new scene, include the mParticle credentials and options as the `mparticleOptions` field of the scene's Global Node. The mParticle Task will look for this and automatically initialize mParticle for you.

```brightscript
sub main(args as dynamic)
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("HelloWorld")
    
    options = {}
    options.apiKey = "REPLACE WITH API KEY"
    options.apiSecret =  "REPLACE WITH API SECRET"
    'for deeplinking analytics, pass in your startup args
    options.startupArgs = args
  
    'REQUIRED: mParticle will look for mParticleOptions in the global node
    screen.getGlobalNode().addFields({mparticleOptions: options})
    screen.show()
    
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub
```
#### 2. Include `mParticleCore.brs` in your Scene

```xml
<?xml version="1.0" encoding="utf-8" ?>
<component name="HelloWorld" extends="Scene"> 
  ...
  <!-- Replace with correct path if necessary -->
  <script type="text/brightscript" uri="pkg:/source/mparticle/mParticleCore.brs"/>
</component>
```

#### 3. Create the mParticle Task Node:

Once you've added the mParticle Task to your scene, you can use the `mParticleSGBridge()` helper to make calls to mParticleCore.

```brightscript
sub init()
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode","mParticleTask")
    'Use the mParticle task node to create an instance an mParticleSGBridge
    mp = mParticleSGBridge(m.mParticleTask)
end sub
```

## Using the SDK

If using the legacy Roku SDK, you can reference mParticle directly via `mParticle()` anytime after you've called `mParticleStart()` as shown above. With Scene Graph, you must send messages to the mParticle Task thread over the `mParticleSGBridge`. `mParticleSGBridge` provides an API that mirrors the direct mParticle API, and will generate messages for you:

```brightscript
'For legacy SDK channels
mp = mparticle()

'For Scene Graph channels
mp = mParticleSGBridge(m.mParticleTask)

'The event APIs are the same for both Legacy and Scene Graph
mp.logEvent("hello world!")
```

#### Development vs. Production Environment

All integrations in mParticle can be configured either for development data, production data, or both. The mParticle Roku SDK will automatically detect at runtime whether a channel is a debug channel, and if so will mark data as development data. You may also override this (as well as other settings) via the options associative array referenced in the snippets above. See the `DEFAULT_OPTIONS` object within `mParticleCore.brs` for the complete list of customizable settings.

### User Identities and Attributes

Use the identity and attribute APIs to associate a user with a set of identities and custom attributes.

```brightscript
' See mparticleConstants().IDENTITY_TYPE for the full list of valid identity types
mp.setUserIdentity(mparticleConstants().IDENTITY_TYPE.CUSTOMER_ID, "12345678")

' Set a single-value attribute
mp.setUserAttribute("hair color", "brown")
' You can also set an array as a value
mp.setUserAttribute("favorite foods", ["italian", "indian"])
```

### Custom Events

Custom Events represent specific actions that a user has taken in your channel. At minimum they require a name, but can also be associated a type, and a free-form dictionary of key/value pairs:

```brightscript
' defaults to CUSTOM_EVENT_TYPE.OTHER and no custom attributes
mp.logEvent("example") 

' or you can specify the custom event type and any custom attributes
customAttributes = {"example custom attribute" : "example custom attribute value"}
mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.NAVIGATION, customAttributes)
```

### Screen Events

Screen events are a special case of event specifically designed to represent the viewing of a screen. Several mParticle integrations support special functionality (e.g. funnel analysis) based on screen events.

```brightscript
mp.logScreenEvent("hello screen!")
```

### eCommerce Events

The `CommerceEvent` is central to mParticle's eCommerce measurement. `CommerceEvents` can contain many data points but it's important to understand that there are 3 core variations:

- Product-based: Used to measure measured datapoints associated with one or more products, such as a purchase.
- Promotion-based: Used to measure datapoints associated with internal promotions or campaigns
- Impression-based: Used to measure interactions with impressions of products and product-listings

The SDK provides a series of helpers and builders to create `CommerceEvents`. One of the simplest and most common scenarios would be to log a `PURCHASE` product action event:

```brightscript
mpConstants = mparticleConstants()
product = mpConstants.Product.build("foo-product-sku", "foo-product-name", 123.45)
productAction = mpConstants.ProductAction.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
mp.logCommerceEvent(productAction)
```

## Sample Channels

- [Hello World Legacy](https://github.com/mParticle/mparticle-roku-sdk/tree/master/example-legacy-sdk)
- [Hello World Scene Graph](https://github.com/mParticle/mparticle-roku-sdk/tree/master/example-legacy-sdk)

## License

[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)
