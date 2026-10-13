<img src="https://static.mparticle.com/sdk/mp_logo_black.svg" width="280">

# Roku SDK

The mParticle Roku SDK allows you to track user activity in your Roku app and forward data to hundreds of integrations through a single API.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

## Installation

These instructions are for version 3.0.0 and later. For 2.x, follow the README of the release you are using.

### With ropm (recommended)

[ropm](https://github.com/rokucommunity/ropm) installs Roku packages from npm. From your channel's root folder (the one with the `manifest` file):

```bash
npx ropm install mparticle@npm:mparticle-roku-sdk
```

This adds the SDK to `dependencies` in your `package.json` under the alias `mparticle` and copies it into `source/roku_modules/mparticle/` and `components/roku_modules/mparticle/`. Add `roku_modules` to your `.gitignore`. If your channel is in a subfolder, first set `"ropm": { "rootDir": "<subfolder>" }` in `package.json`.

ropm prefixes everything the SDK declares with the alias, so names used in the rest of this README change:

| Manual install | ropm install |
| --- | --- |
| `mParticleSGBridge(task)` | `mparticle_mParticleSGBridge(task)` |
| `mParticleConstants()` | `mparticle_mParticleConstants()` |
| `createObject("roSGNode", "mParticleTask")` | `createObject("roSGNode", "mparticle_mParticleTask")` |
| `pkg:/source/mparticle/mParticleCore.brs` | `pkg:/source/roku_modules/mparticle/mparticle/mParticleCore.brs` |

To keep the unprefixed names, add `"ropm": { "noprefix": ["mparticle"] }` to your `package.json` before installing. File paths still move under `roku_modules`.

### Manually

1. Download the latest release from the [releases section](https://github.com/mParticle/mparticle-roku-sdk/releases), or clone this repository.
2. Copy the `source/mparticle/` folder into your channel's `source/` folder, so `mParticleCore.brs` and `mParticleBundle.crt` are in `pkg:/source/mparticle/`.
3. For Scene Graph support, copy `components/mParticleTask.brs` and `components/mParticleTask.xml` into your channel's `components/` folder.

Upgrading from 2.x: the SDK files moved from the repository root into `source/mparticle/` and `components/`. Where they go in your channel is unchanged.

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
    'options.environment = mParticleConstants().ENVIRONMENT.FORCE_PRODUCTION

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

Custom attribute values may be strings, numbers or booleans, matching the Android and iOS SDKs, which also send attribute values as strings. Numbers and booleans are converted to their string form (`42` becomes `"42"`, `true` becomes `"true"`). Values of any other type (arrays, associative arrays, `invalid`) are discarded; enable debug logging to see the key and type of any discarded value (unset values are not logged). The same applies to custom attributes on products in commerce events.

Floating point values can lose precision when converted to strings, and a number literal too large for a 32-bit integer is a single-precision `Float` in BrightScript. If exact values matter, pass a `LongInteger` (e.g. `1593007533602&`) or format the value as a string yourself.

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

The tests run on a real Roku in developer mode. To only build: `npm run build-production` (output in `build/`) or `npm run build-tests` (output in `build-test/`).

CI also runs them on every pull request without a Roku, in the [brs-node](https://www.npmjs.com/package/brs-node) simulator. To do the same locally: `npm install`, then `npm run test:headless`. The simulator is not a Roku, so still run the tests on a device before a release.

### Run the tests on a Roku

1. **Set up the Roku once.** On the remote press Home 3 times, Up 2 times, then Right, Left, Right, Left, Right. Choose *Enable installer and restart* and set a developer password. Note the Roku's IP address (Settings > Network > About).
2. **Allow control from your computer.** Set Settings > System > Advanced system settings > Control by mobile apps > Network access to **Permissive**. Your computer and the Roku must be on the same network; guest Wi-Fi usually blocks it.
3. **Install dependencies:** `npm install`
4. **Run:** `./run-tests.sh <ROKU_IP>` and type the developer password when asked. (In VS Code, use Run and Debug > *Launch and Run Tests* and enter the IP and password when prompted.)
5. **Read the result:**
   - `ALL TESTS PASSED` (exit code 0).
   - `TESTS FAILED`, or `THE APP DID NOT COMPILE ON THE DEVICE` with the error lines (exit code 1).
   - Anything that stopped the run before there was a result: a failed build or install, a rejected password, an unreachable Roku, or `No test report arrived` (exit code 2).

   The output of the run is saved to `last_test_output.log`.

| If you see | Do this |
| --- | --- |
| `Could not reach the device` | Check the IP, that developer mode is on, and that both are on the same network. |
| `Home=403` | Set Network access to Permissive (step 2). |
| `The app was already running` | Press Home on the remote and run again. |
| `No test report arrived` | Only one program can read the Roku's debug console at a time (the script stops any other `nc` session to it), so stop any other debug session or telnet window and run again. |
| `The device rejected the developer password` | Run again and type the password you set in step 1. |
| `Install did not succeed` | Read the message the script prints under it. |

### Run the sample app against your own workspace

1. Put your own API key and secret in the `YOUR_API_KEY` and `YOUR_API_SECRET` lines of `example-scenegraph-sdk/source/Main.bs`, and set `options.logLevel = 3` (1 = error, 2 = info, 3 = debug). **Never commit them.** To remove them again, run `git checkout -- example-scenegraph-sdk/source/Main.bs` (this discards all uncommitted changes to that file).
2. In VS Code run *Launch Production App* and enter the Roku's IP and developer password.
3. In the console, look for `Identity response: code 200` and then `Batch response: code 202`. Wrong credentials fail quietly, so if you see neither, check the key and secret.
4. In your workspace's Live Stream, filter on the **Development** environment (apps installed this way are marked as development automatically) and look for your events. Uploads go out after about 15 seconds without activity.

### Release a new version

1. In GitHub Actions, run **Release Draft** on `master` and choose `patch`, `minor` or `major`. It opens a pull request that sets the new version in `source/mparticle/mParticleCore.brs`, `package.json` and `package-lock.json`, and adds the merged pull requests to `CHANGELOG.md`.
2. Run the tests on a Roku from that branch (see above), then review and merge the pull request.
3. **Release Publish** then tags the merge commit `vX.Y.Z` and publishes the GitHub release with the notes from `CHANGELOG.md`.

## Sample Channel

This repository includes a complete example implementation:

- **[Scene Graph Example](example-scenegraph-sdk/README.md)** - Complete Scene Graph implementation with comprehensive Rooibos tests

## Repository Structure

```
mparticle-roku-sdk/
├── source/mparticle/
│   ├── mParticleCore.brs          # Core SDK implementation
│   └── mParticleBundle.crt        # Pinned certificate bundle
├── components/
│   ├── mParticleTask.brs          # Scene Graph Task node
│   └── mParticleTask.xml          # Scene Graph Task interface
├── example-scenegraph-sdk/        # Example app with tests (links to the SDK files above)
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
├── scripts/test-package.sh        # Checks the npm package installs and compiles with ropm
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
