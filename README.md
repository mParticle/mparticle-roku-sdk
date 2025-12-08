<img src="https://static.mparticle.com/sdk/mp_logo_black.svg" width="280">

## Roku SDK

This is the public repo of the mParticle Roku SDK. mParticle's mission is straightforward: make it really easy to use all of the great services in the app ecosystem. Our SDKs and platform are designed to be your abstraction layer and data hub, and we do the work of integrating with each individual app service so you don't have to.

The mParticle platform supports 150+ partners in the ecosystem, including developer tools, analytics, attribution, marketing automation, and advertising services. We also have a powerful audience engine that sits atop our platform to let you action on all of your data - [learn more here](https://www.mparticle.com)!

## Docs and Download

1. [Check out the docs here](http://docs.mparticle.com/developers/sdk/roku/getting-started/)
2. Navigate to the [releases section](https://github.com/mParticle/mparticle-roku-sdk/releases) and download the latest tagged source, or clone this repository.
3. Create an `mparticle/` directory inside the `pkg:/source/` directory.
4. Copy `mParticleBundle.crt` and `mParticleCore.brs` into the newly created `pkg:/source/mparticle` directory.
5. *For Scene Graph support*, copy `mParticleTask.brs` and `mParticleTask.xml` into your `pkg:/components/` directory.

## Sample Channels

- [Hello World Legacy](https://github.com/mParticle/mparticle-roku-sdk/tree/master/example-legacy-sdk)
- [Hello World Scene Graph](https://github.com/mParticle/mparticle-roku-sdk/tree/master/example-legacy-sdk)

## Testing

### First-Time Setup

Enable development on your Roku device (one-time setup):

1. **Get a Roku device** - Any modern Roku works (player, stick, or TV)
2. **Create a Roku account** - Sign up at [roku.com](https://my.roku.com/signup)
3. **Enroll as a developer** - Register at [developer.roku.com](https://developer.roku.com/enrollment/standard)
4. **Enable Developer Mode** - Follow the [setup guide](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md):
   - On your Roku remote, press: Home 3x, Up 2x, Right, Left, Right, Left, Right
   - Create your developer password
   - Note your device's IP address (Settings → Network → About)

### Running Tests

The test script automatically packages and deploys the channel to your Roku device:

```bash
./deploy-and-test.sh YOUR_ROKU_IP
```

When prompted, enter your developer password. The script will package the channel, upload it to your Roku, run all tests, and display results in your terminal.

## License

[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)
