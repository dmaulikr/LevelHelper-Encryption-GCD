LevelHelper-Encryption-GCD
==========================

Simple example of how to use GCD with Asset Encryption in LevelHelper 

Decryption is a very heavy process that can speed down your applications significantly.
For me it wasn't too bad since I didn't really have too many big images to decrypt. 
However, I have seen some applications that took up to 6 seconds to decrypt all assets. 
Imagine that someone downloads your game, taps on the play button and waits 6 seconds while 
your game decrypts your assets and goes irresponsive. I think this is not acceptable. So, what's the possible solution?
Would that be nice to decrypt assets on a background thread? The simple solution we could try is GCD.


What Is It?
==========================

GCD, stands for Grand Central Dispatch, is a low level API which introduces a new way to perform 
concurrent programming. For basic functionality it's like NSOperationQueue, in that it allows 
a program's work to be divided up into individual tasks which are then submitted to work queues to 
run concurrently or serially. It's lower level and higher performance than NSOperationQueue, and is 
not part of the Cocoa frameworks.


How to use it along with LevelHelper API
=======================================
Loading levels takes too much time. So let's go ahead and run it in the background.

```
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, NULL), ^{
            
        loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"level04"
                                                     imgSubfolder:@"Images"
                                                    decryptionKey:@"YourOwnPrivateKeyThatMustHave32C"];
	
	});
```

That's pretty much it. Now you are loading your levels on a background thread with a high priority(Items dispatched 
to the queue run at high priority; the queue is scheduled for execution before any default priority or low 
priority queue.). However, that's not all we have to do. This (as is) is not going to work because your 
LevelHelperLoader object will be executed on different threads. Let's put them all together.

```
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, NULL), ^{

        loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"level04"
                                                     imgSubfolder:@"Images"
                                                    decryptionKey:@"YourOwnPrivateKeyThatMustHave32C"];
        
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [loader addObjectsToWorld:world cocos2dLayer:self];
            });
                if([loader hasPhysicBoundaries])
                    [loader createPhysicBoundaries:world];
            
                if(![loader isGravityZero])
                    [loader createGravity:world];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self retrieveRequiredObjects]; 
                [self setupCollisionHandling];
                [self startDebugDrawing];
            });

        });
```

That's all we have to do. Just keep in mind that all objects that are related to GUI need to be executed 
in the main queue.

One more think you should always remember is that if you have different GUI elements like a label that 
you have created in your -init method, it is much likely that you won't be able to see it. It is because
your level will be on top of it since execution time of adding objects to your scene will be much shorter 
than adding levels to your scene, so your GUI elements will be added to your scene first, then your level
will go on top. The simplest solution is to add a z-index value greater than 0 to your GUI elements.
So instead of `[self addChild: yourGUIElement]`, just use `[self addChild: yourGUIElement z:1]`.

Results
=======================================

Results for this game are not really considerable I think since the images are not big enough however 
the level with GCD runs slightly faster. Go ahead and try and let me know how it goes with you


I hope this helps some people.
Thanks.


  

