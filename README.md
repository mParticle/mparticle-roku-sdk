<img src="https://static.mparticle.com/sdk/mp_logo_black.svg" width="280">

# Roku SDK

The mParticle Roku SDK allows you to track user activity in your Roku app and forward data to hundreds of integrations through a single API.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

## Download

1. Navigate to the [releases section](https://github.com/mParticle/mparticle-roku-sdk/releases) and download the latest tagged source, or clone this repository:
   ```bash
   git clone https://github.com/mParticle/mparticle-roku-sdk.git
   ```

2. Create an `mparticle/` directory inside the `pkg:/source/` directory.

3. Copy `mParticleBundle.crt` and `mParticleCore.brs` into the newly created `pkg:/source/mparticle` directory.

4. **For Scene Graph support**, copy `mParticleTask.brs` and `mParticleTask.xml` into your `pkg:/components/` directory.

## Initialize

The mParticle Roku SDK uses Scene Graph architecture, allowing mParticle to run entirely in a separate thread for better performance, upload batching, and more accurate session management. You should include a single mParticle Task in every scene in your channel.

#### 1. Configure mParticle

When creating a new scene, include the mParticle credentials and options as the `mparticleOptions` field of the scene's Global Node. `mParticleTask.brs` will look for this and automatically initialize mParticle for you.

```brightscript
sub main(args as dynamic)
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("HelloWorld")
    
    options = {}
    options.apiKey = "REPLACE WITH API KEY"
    options.apiSecret = "REPLACE WITH API SECRET"
    
    'For deeplinking analytics, pass in your startup args
    options.startupArgs = args

    'You can force the SDK into development or production mode, 
    'otherwise the SDK will use roAppInfo's IsDev() API
    options.environment = mParticleConstants().ENVIRONMENT.FORCE_PRODUCTION

    'If you know the users credentials, supply them here
    'otherwise the SDK will use the last known identities
    identityApiRequest = {userIdentities:{}}
    'Note that you must specifically use the 'userIdentities' key
    identityApiRequest.userIdentities[mparticleConstants().IDENTITY_TYPE.EMAIL] = "user@example.com"
    identityApiRequest.userIdentities[mparticleConstants().IDENTITY_TYPE.CUSTOMER_ID] = "123456"
    'Note that you must specifically use the 'identifyRequest' key
    options.identifyRequest = identityApiRequest

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

See [Identity](#identity) for more information on the `identityApiRequest`.

If you plan to use proxy tools such as Charles Proxy for testing in your development build, you may wish to disable SSL pinning. To do so, insert the following line at the end of the options section:

```brightscript
options.enablePinning = false
```

#### 2. Include mParticleCore.brs in your Scene

```xml
<?xml version="1.0" encoding="utf-8" ?>
<component name="HelloWorld" extends="Scene"> 
  ...
  <!-- Replace with correct path if necessary -->
  <script type="text/brightscript" uri="pkg:/source/mparticle/mParticleCore.brs"/>
</component>
```

#### 3. Create the mParticle Task Node

Once you've added the mParticle Task to your scene, you can use the `mParticleSGBridge()` helper to make all calls to mParticle.

```brightscript
sub init()
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode", "mParticleTask")
    
    'Use the mParticle task node to create an instance of mParticleSGBridge
    mp = mParticleSGBridge(m.mParticleTask)
    
    'Now you can log events
    mp.logEvent("Component Initialized")
end sub
```

## Usage

### Getting the mParticle Instance

Use the `mParticleSGBridge` to communicate with the mParticle Task thread. The bridge provides a clean API for all mParticle functionality:

```brightscript
'Create the bridge
mp = mParticleSGBridge(m.mParticleTask)

'Log events
mp.logEvent("hello world!")
```

### Development vs. Production Environment

All integrations in mParticle can be configured either for development data, production data, or both. The mParticle Roku SDK will automatically detect at runtime whether a channel is a debug channel, and if so will mark data as development data. You may also override this via the options associative array:

```brightscript
'Generally unnecessary to set either of these, as the SDK will detect automatically
options.environment = mparticleConstants().ENVIRONMENT.FORCE_PRODUCTION
options.environment = mparticleConstants().ENVIRONMENT.FORCE_DEVELOPMENT
```

### Custom Events

Custom Events represent specific actions that a user has taken in your channel. At minimum they require a name, but can also be associated with a type and a free-form dictionary of key/value pairs:

```brightscript
' Defaults to CUSTOM_EVENT_TYPE.OTHER and no custom attributes
mp.logEvent("example") 

' Or you can specify the custom event type and any custom attributes
customAttributes = {"example custom attribute": "example custom attribute value"}
mp.logEvent("hello world!", mparticleConstants().CUSTOM_EVENT_TYPE.NAVIGATION, customAttributes)
```

### Screen Events

Screen events are a special case of event specifically designed to represent the viewing of a screen. Several mParticle integrations support special functionality (e.g. funnel analysis) based on screen events.

```brightscript
mp.logScreenEvent("hello screen!")
```

### eCommerce Events

The `CommerceEvent` is central to mParticle's eCommerce measurement. CommerceEvents can contain many data points but it's important to understand that there are 3 core variations:

- **Product-based**: Used to measure datapoints associated with one or more products, such as a purchase
- **Promotion-based**: Used to measure datapoints associated with internal promotions or campaigns
- **Impression-based**: Used to measure interactions with impressions of products and product-listings

The SDK provides a series of helpers and builders to create CommerceEvents. One of the simplest and most common scenarios would be to log a PURCHASE product action event:

```brightscript
mpConstants = mparticleConstants()
actionApi = mpConstants.ProductAction

product = mpConstants.Product.build("foo-product-sku", "foo-product-name", 123.45)
productAction = mpConstants.ProductAction.build(actionApi.ACTION_TYPE.PURCHASE, 123.45, [product])
mp.logCommerceEvent(productAction)
```

### Setting Integration Attributes

Occasionally certain integrations will require data that can only be provided client side. The `setIntegrationAttribute` method allows clients to provide this data.

```brightscript
' This code would set the "app_instance_id" for integration 160 (Google Analytics 4)
mp.setIntegrationAttribute("160", "app_instance_id", "your_app_instance_id")
```

## Development & Testing

This repository uses [BrighterScript](https://github.com/rokucommunity/brighterscript) for development and [Rooibos](https://github.com/rokucommunity/rooibos) for automated testing.

### Building

Build the production version:
```bash
npm run build-production
# Output: build/
```

Build the test version with Rooibos:
```bash
npm run build-tests
# Output: build-test/
```

### Running Tests

#### Option 1: VSCode Debugger (Recommended)

1. Open the project in VSCode
2. Press `F5` or click the Debug icon
3. Select **"Launch and Run Tests"** from the dropdown
4. Enter your Roku IP and password when prompted
5. View test results in the Debug Console

#### Option 2: Command Line

```bash
# Run tests via shell script
./run-tests.sh YOUR_ROKU_IP YOUR_PASSWORD
```

The test runner will:
- Build the test package
- Deploy to your Roku device
- Execute all Rooibos tests
- Display results in the terminal
- Save full output to `last_test_output.log`

## Sample Channel

This repository includes a complete example implementation:

- **[Scene Graph Example](example-scenegraph-sdk/README.md)** - Complete Scene Graph implementation with comprehensive Rooibos tests

## Repository Structure

```
mparticle-roku-sdk/
├── mParticleCore.brs              # Core SDK implementation
├── mParticleTask.brs              # Scene Graph Task node
├── mParticleTask.xml              # Scene Graph Task interface
├── example-scenegraph-sdk/        # Example app with tests
│   ├── source/
│   │   ├── Main.bs                # Entry point with test detection
│   │   ├── mparticle/             # SDK files
│   │   └── tests/                 # Rooibos test suites
│   └── components/
├── build/                         # Production build output
├── build-test/                    # Test build output (with Rooibos)
├── bsconfig.json                  # BrighterScript production config
├── bsconfig-test.json             # BrighterScript test config
├── run-tests.sh                   # Automated test runner
├── package.json                   # Node.js dependencies
└── README.md
```

### Scene Graph Support

The mParticle Roku SDK is built for [Roku's Scene Graph architecture](https://developer.roku.com/docs/developer-program/core-concepts/core-concepts.md).

Scene Graph enables mParticle to run on a dedicated background Task thread, ensuring your UI remains responsive during network operations while providing automatic batching and accurate session management.

## Support

Questions? Have an issue? Read the [docs](https://docs.mparticle.com/developers/client-sdks/roku/) or contact our **Customer Success** team at <support@mparticle.com>.

## License

[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)
