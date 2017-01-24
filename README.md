<img src="http://static.mparticle.com/sdk/logo.svg" width="280">

## Roku SDK

This is the public repo of the mParticle Roku SDK. mParticle's mission is straightforward: make it really easy to use all of the great services in the app ecosystem. Our SDKs and platform are designed to be your abstraction layer and data hub, and we do the work of integrating with each individual app service so you don't have to.

The platform has grown to support 100+ partners in the ecosystem, including developer tools, analytics, attribution, marketing automation, and advertising services. We also have a powerful audience engine that sits atop our platform to let you action on all of your data - [learn more here](https://www.mparticle.com)!

## Download

1. Navigate to the [releases section](https://github.com/mParticle/mparticle-roku-sdk/releases) and download the lastest tagged source, or clone this repository.
2. Create an `mparticle/` directory inside the `pkg:/source/` directory.
3. Copy `mParticleBundle.crt` and `mParticleCore.brs` into the newly created `pkg:/source/mparticle` directory.
4. For Scene Graph support, copy `mParticleTask.brs` and `mParticleTask.xml` into your `pkg:/components/` directory.

## Initialize

The mParticle Roku SDK is compatible with both legacy and Scene Graph Roku channels.

### Legacy Channels

Initialize the SDK within your main method, or as soon as possible during the startup of your channel:

```brightscript
sub main(args as dynamic)
    options = {}
    options.apiKey = "REPLACE WITH API KEY"
    options.apiSecret = "REPLACE WITH API SECRET"
    'for deeplinking analytics, pass in your startup args
    options.startupArgs = args
    mParticleStart(options)
end sub
```
The above will initialize the SDK, creating an mParticle install and user session.

### Scene Graph Channels

The Scene Graph SDK allows for running mParticle in a separate thread for better performance and more advanced measurement behavior. You should include the mParticle Task in every scene in your channel.

#### 1. Configure mParticle

When creating a new scene, include the mParticle credentials and options as the `mparticleOptions` field of the scene's the Global Node. The mParticle Task will look for this and automatically initialize mParticle for you.

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
#### 2. Include mParticleCore.brs in your Scene

```xml
<?xml version="1.0" encoding="utf-8" ?>
<component name="HelloWorld" extends="Scene"> 
	<children>
      <Label id="myLabel" 
      	text="Hello World!"
      	width="1280" 
      	height="720" 
      	horizAlign="center"
      	vertAlign="center"
      	/>
    </children>

  <script type="text/brightscript" uri="pkg:/components/helloworld.brs"/>
  <!-- Replace with correct path if necessary -->
  <script type="text/brightscript" uri="pkg:/source/mparticle/mParticleCore.brs"/>
</component>
```

#### 3. Create the mParticle Task Node:

Once you've added the mParticle Task to your scene, you can use the mParticleSGBridge() helper to make calls to mParticleCore.

```brightscript
sub init()
    m.top.setFocus(true)
    
    'Create the mParticle Task Node
    m.mParticleTask = createObject("roSGNode","mParticleTask")
    'Use the mParticle task node to create an instance an mParticleSGBridge
    mpApi = mParticleSGBridge(m.mParticleTask)
end sub
```

## Using the SDK

If using the legacy Roku SDK, you can reference mParticle directly via `mParticle()` anytime after you've called `mParticleStart()` as shown above. With Scene Graph, you must send messages to the mParticle Task thread. mParticleSGBridge provides an API that matches the direct mParticle API, and will generate messages for you:

```brightscript
'Legacy SDK channels
mparticle().logEvent("hello world!")
'Scene Graph channels
mpApi = mParticleSGBridge(m.mParticleTask)
mpApi.logEvent("hello world!")
```

## Sample Channels

- [Hello World Legacy](https://github.com/mParticle/mparticle-roku-sdk-private/tree/master/example-legacy-sdk)
- [Hello World Scene Graph](https://github.com/mParticle/mparticle-roku-sdk-private/tree/master/example-legacy-sdk)

## License

[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)
