# mParticle SceneGraph Example Channel

This is a complete example of integrating the mParticle SDK into a modern Roku SceneGraph application using BrighterScript and automated testing with Rooibos.

## Project Structure

```
example-scenegraph-sdk/
├── components/
│   ├── helloworld.brs         # Sample component showing mParticle usage
│   ├── helloworld.xml
│   ├── mParticleTask.brs      # Scene Graph Task for mParticle
│   └── mParticleTask.xml
├── source/
│   ├── Main.bs                # Entry point
│   ├── mparticle/
│   │   └── mParticleCore.brs  # Core mParticle SDK implementation
│   └── tests/
│       ├── BasicsTests.spec.bs      # Basic functionality tests
│       └── mParticleTests.spec.bs   # mParticle SDK tests
├── manifest                   # Channel configuration
└── README.md
```

### Build Output Directories

When you build, BrighterScript creates:

- **`build/`** - Production build (no tests)
- **`build-test/`** - Test build (includes Rooibos framework and test files)
- **`out/`** - Deployment packages (`.zip` files)

## Running the tests and the sample app

See [Development & Testing](../README.md#development--testing) in the main README for the step-by-step instructions: setting up the Roku, running the tests (`./run-tests.sh <ROKU_IP>` or VS Code), and running this app against your own workspace. The VS Code launch configurations need the [BrightScript Language extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript).

## How It Works

### Test vs Production Builds

The example automatically detects whether to run tests or the normal app:

- **Test Build** (`build-test/`): Includes Rooibos framework. `Main.bs` detects `RooibosScene` and runs tests.
- **Production Build** (`build/`): No test files. `Main.bs` runs the normal HelloWorld app.

### Using mParticle

Configure mParticle in `Main.bs` before creating your scene:

```brightscript
options = {}
options.apiKey = "YOUR_API_KEY"
options.apiSecret = "YOUR_API_SECRET"
screen.getGlobalNode().addFields({ mparticleOptions: options })
```

## Additional Resources

- [mParticle Roku SDK Documentation](https://docs.mparticle.com/developers/sdk/roku/getting-started/)
- [BrighterScript Documentation](https://github.com/rokucommunity/brighterscript)
- [Rooibos Testing Framework](https://github.com/georgejecook/rooibos)
- [Roku SceneGraph Documentation](https://developer.roku.com/docs/developer-program/core-concepts/scenegraph.md)
- [mParticle Events API](https://docs.mparticle.com/developers/server/json-reference/)
