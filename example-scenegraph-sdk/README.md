# mParticle SceneGraph Example Channel

This is a complete example of integrating the mParticle SDK into a modern Roku SceneGraph application. It demonstrates best practices for initialization, API usage, and automated testing.

## Project Structure

```
example-scenegraph-sdk/
├── components/
│   ├── helloworld.brs         # Sample component showing mParticle usage
│   ├── helloworld.xml
│   ├── mParticleTask.brs      # Symlink to root SDK file
│   └── mParticleTask.xml      # Symlink to root SDK file
├── source/
│   ├── Main.brs               # Entry point with test runner
│   ├── mparticle/
│   │   └── mParticleCore.brs  # Core mParticle SDK
│   └── tests/
│       └── Test__Basics.brs   # Comprehensive test suite
└── manifest                   # Channel configuration
```

> [!NOTE]
> The deployment script (`deploy-and-test.sh`) automatically injects the unit testing framework (`UnitTestFramework.brs`) into `source/testFramework/` during packaging. This ensures the test infrastructure is available at runtime without requiring it to be permanently committed to the example app.


### Key Files

| File | Purpose |
|------|---------|
| `mParticleCore.brs` | Core SDK implementation containing all mParticle functionality including event tracking, identity management, media analytics, and networking. |
| `mParticleTask.brs` | Scene Graph Task wrapper that manages the background thread for mParticle operations. |
| `mParticleTask.xml` | Scene Graph component interface defining fields for communication between threads. |
| `deploy-and-test.sh` | Automated script for packaging, deploying, and testing on physical Roku devices. Supports both Scene Graph and Legacy examples. |

## Quick Start

### Deploy and Run Tests

From the repository root:

```bash
# Deploy Scene Graph example
./deploy-and-test.sh YOUR_ROKU_IP
```

This will:
1. Package the channel
2. Deploy to your Roku device
3. Automatically run all unit tests
4. Display results in your terminal

## How This Example Works

### Initialization Pattern

The `Main.brs` file shows the proper initialization sequence:

```brightscript
sub Main(args as dynamic)
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    ' Configure mParticle
    options = {}
    options.apiKey = "YOUR_API_KEY"
    options.apiSecret = "YOUR_API_SECRET"
    options.logLevel = mParticleConstants().LOG_LEVEL.DEBUG
    
    ' Set options on global node BEFORE creating scene
    screen.getGlobalNode().addFields({ mparticleOptions: options })
    
    ' Now create your scene
    scene = screen.CreateScene("HelloWorld")
    screen.show()
end sub
```

### Component Usage Pattern

The `helloworld.brs` component demonstrates how to use mParticle in your components:

```brightscript
sub init()
    ' Create Task node and bridge
    m.mParticleTask = createObject("roSGNode", "mParticleTask")
    m.mp = mParticleSGBridge(m.mParticleTask)
    
    ' Use mParticle APIs
    m.mp.logEvent("Component Initialized")
    m.mp.setUserAttribute("favorite_genre", "Comedy")
    
    ' Setup button handlers
    m.top.button.observeField("buttonSelected", "onButtonSelected")
end sub

sub onButtonSelected()
    ' Log events in response to user actions
    m.mp.logEvent("Button Clicked", mParticleConstants().CUSTOM_EVENT_TYPE.NAVIGATION)
end sub
```

## Testing

This example includes comprehensive automated testing to validate SDK functionality on physical Roku devices.

### Prerequisites

Before testing, ensure you have:

1. **Roku device** - Any modern Roku player, stick, or TV
2. **Roku account** - Sign up at [roku.com](https://my.roku.com/signup)
3. **Developer account** - Register at [developer.roku.com](https://developer.roku.com/enrollment/standard)
4. **Developer mode enabled** on your device:
   - Press: **Home 3x, Up 2x, Right, Left, Right, Left, Right**
   - Set a developer password
   - Note your device's IP address (Settings → Network → About)

### Running Tests

From the repository root:

```bash
./deploy-and-test.sh YOUR_ROKU_IP
```

### What the Test Script Does

The `deploy-and-test.sh` script automates the entire testing workflow:

1. **Packages** the example channel with the test framework into `example-scenegraph-sdk.zip`
2. **Cleans** any existing dev channel from the device
3. **Deploys** the package to your Roku device via HTTP
4. **Launches** the channel with test parameters
5. **Captures** debug console output during test execution
6. **Displays** test results in your terminal
7. **Saves** full output to `last_test_output.log`

## Additional Resources

- [mParticle Roku SDK Documentation](https://docs.mparticle.com/developers/sdk/roku/getting-started/)
- [Roku SceneGraph Documentation](https://developer.roku.com/docs/developer-program/core-concepts/scenegraph.md)
- [mParticle Events API](https://docs.mparticle.com/developers/server/json-reference/)
