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

## Getting Started

### 1. Install Dependencies

```bash
# From repository root
npm install
```

## Running from VSCode

**Prerequisites:** VSCode with [BrighterScript extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript) installed

### Run Tests (Recommended for Development)

1. Open Debug panel (press `F5`)
2. Select **"Launch and Run Tests"** from dropdown
3. Press `F5` (or click green play button)
4. Enter Roku IP and developer password when prompted
5. View test results in Debug Console

The debugger automatically:
- Builds the test package with Rooibos
- Deploys to your Roku
- Runs all test suites
- Displays results in real-time

### Run Production App

1. Open Debug panel (press `F5`)
2. Select **"Launch Production App"** from dropdown
3. Press `F5`
4. Enter Roku IP and developer password

### Command Line Alternative

```bash
# Build and run tests
./run-tests.sh YOUR_ROKU_IP YOUR_PASSWORD

# Results are displayed in terminal and saved to last_test_output.log
```

**What to expect:** Tests take ~10-30 seconds to run. You'll see output in the Debug Console showing each test suite and results.

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
