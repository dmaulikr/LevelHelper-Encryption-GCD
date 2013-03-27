//
//  HelloWorldLayerWithGCD.m
//  RocketMouse
//
//  Created by Oguzhan Gungor on 28/03/13.
//  Copyright 2013 Bogdan Vladu. All rights reserved.
//

#import "HelloWorldLayerWithGCD.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@interface HelloWorldLayerWithGCD()
-(void) initPhysics;
@end

@implementation HelloWorldLayerWithGCD

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayerWithGCD *layer = [HelloWorldLayerWithGCD node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(void)removeScoreText:(CCLabelTTF*)scoreLabel
{
    [scoreLabel removeFromParentAndCleanup:YES];
}

-(void)scoreHitAtPosition:(CGPoint)position withPoints:(int)points
{
    score += points;
    [scoreText setString:[NSString stringWithFormat:@"Score: %d", score]];
    
    NSString* curScoreTxt = [NSString stringWithFormat:@"+ %d", points];
    CCLabelTTF *curScore = [CCLabelTTF labelWithString:curScoreTxt fontName:@"Marker Felt" fontSize:24];
    curScore.color = ccWHITE;
    curScore.position = position;
    [self addChild:curScore z:20];
    
    id opacityAct1 = [CCActionTween actionWithDuration:1 key:@"opacity" from:255 to:0];
    id actionCallFunc = [CCCallFuncN actionWithTarget:self selector:@selector(removeScoreText:)];
    id seq = [CCSequence actionOne:opacityAct1 two:actionCallFunc];
    [curScore runAction:seq];
}


-(void)mouseCoinCollision:(LHContactInfo*)contact
{
    LHSprite* coin = [contact spriteB];
    
    if(nil != coin)
    {
        if([coin visible])
        {
            [self scoreHitAtPosition:[coin position] withPoints:100];
            [[SimpleAudioEngine sharedEngine] playEffect:@"coin.wav"];
        }
        
        [coin setVisible:NO];
    }
}

-(void)restartGame
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayerWithGCD scene]];
}

-(void)killPlayer
{
    playerVelocity = 0.0;
    playerShouldFly = false;
    playerIsDead = true;
    playerWasFlying = false;
    [rocketFlame setVisible:NO];
    [player prepareAnimationNamed:@"mouseDie" fromSHScene:@"Animations"];
    [player playAnimation];
    
    [paralaxNode setSpeed:0];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Over"
                                           fontName:@"Marker Felt"
                                           fontSize:64];
    label.color = ccRED;
    label.position = ccp(winSize.width*0.5, winSize.height*0.75);
    [self addChild:label];
    
    
    CCMenuItem *item = [CCMenuItemFont itemWithString:@"Restart"
                                               target:self
                                             selector:@selector(restartGame)];
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    [menu alignItemsVertically];
    
    [self addChild:menu];
}

-(void)mouseLaserCollision:(LHContactInfo*)contact
{
    LHSprite* laser = [contact spriteB];
    
    int frame  = [laser currentFrame];
    
    // If we make the laser a sensor, the callback will be called only once - at first collision.
    // This is not good as we want to kill the player when the laser changes to active.
    // So we disable the contact so that the player and laser don't collide, but trigger a collision.
    // Disabling the contact is only active for one frame,
    // so on the next frame the contact will be active again, triggering the collision.
    
    b2Contact* box2dContact = [contact contact];
    box2dContact->SetEnabled(false);
    
    if(playerIsDead)
        return;
    
    if(frame != 0)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"laser.wav"];
        [self killPlayer];
    }
}

-(void)mouseDogCatCollision:(LHContactInfo*)contact
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"hitObject.wav"];
    [loader cancelPreCollisionCallbackBetweenTagA:PLAYER andTagB:DOG];
    [loader cancelPreCollisionCallbackBetweenTagA:PLAYER andTagB:CAT];
    [self killPlayer];
}

-(void) fallAnimHasEnded:(NSNotification*)notif
{
    LHSprite* sprite = [notif object]; //get the sprite on which the animation has ended
    
    if(sprite == player){
        [player prepareAnimationNamed:@"mouseRun" fromSHScene:@"Animations"];
        [player playAnimation];
        [player removeAnimationHasEndedObserver];
    }
}

-(void)mouseGroundCollision:(LHContactInfo*)contact
{
    
    if(playerIsDead)
        return;
    
    if(playerWasFlying)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"ground.wav"];
        
        [player prepareAnimationNamed:@"mouseFall" fromSHScene:@"Animations"];
        [player playAnimation];
        [player setAnimationHasEndedObserver:self selector:@selector(fallAnimHasEnded:)];
    }
    playerWasFlying = false;
}

-(void)mouseBunnyCollision:(LHContactInfo*)contact
{
    if(playerIsDead)
        return;
    
    LHSprite* bunny = [contact spriteB];
    
    if(nil != bunny)
    {
        if([[bunny animationName] isEqualToString:@"BunnyRun"])
        {
            [self scoreHitAtPosition:[bunny position] withPoints:500];
            [[SimpleAudioEngine sharedEngine] playEffect:@"bunnyHit.wav"];
        }
        
        [bunny prepareAnimationNamed:@"BunnyDie" fromSHScene:@"Animations"];
        [bunny playAnimation];
        
        [bunny pausePathMovement];
    }
}


-(void) setupCollisionHandling
{
    [loader useLevelHelperCollisionHandling];
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:PLAYER
                                                   andTagB:COIN
                                                idListener:self
                                               selListener:@selector(mouseCoinCollision:)];
    
    [loader registerPreCollisionCallbackBetweenTagA:PLAYER
                                            andTagB:LASER
                                         idListener:self
                                        selListener:@selector(mouseLaserCollision:)];
    
    [loader registerPreCollisionCallbackBetweenTagA:PLAYER
                                            andTagB:DOG
                                         idListener:self
                                        selListener:@selector(mouseDogCatCollision:)];
    [loader registerPreCollisionCallbackBetweenTagA:PLAYER
                                            andTagB:CAT
                                         idListener:self
                                        selListener:@selector(mouseDogCatCollision:)];
    
    [loader registerPreCollisionCallbackBetweenTagA:PLAYER
                                            andTagB:GROUND
                                         idListener:self
                                        selListener:@selector(mouseGroundCollision:)];
    
    [loader registerPreCollisionCallbackBetweenTagA:PLAYER
                                            andTagB:ROTATING_LASERS
                                         idListener:self
                                        selListener:@selector(mouseLaserCollision:)];
    
    [loader registerBeginOrEndCollisionCallbackBetweenTagA:PLAYER
                                                   andTagB:BUNNY
                                                idListener:self
                                               selListener:@selector(mouseBunnyCollision:)];
    
}

-(void) setupAudio
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.m4a"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"coin.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"fly.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"ground.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"hitObject.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"lose.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bunnyHit.wav"];
}

-(void) setupScore
{
    score = 0;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    scoreText = [CCLabelTTF labelWithString:@"Score: 0"
                                   fontName:@"Arial"
                                   fontSize:22
                                 dimensions:CGSizeMake(200, 50)
                                 hAlignment:kCCTextAlignmentLeft
                                 vAlignment:kCCVerticalTextAlignmentCenter];
    
    scoreText.color = ccWHITE;
    scoreText.position = ccp(100, winSize.height-25);
    [self addChild:scoreText z:20];
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		
		// init physics
		[self initPhysics];
        
        //        loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"level04"];
        //        loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"level04" imgSubfolder:@"Images"];
        loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"level04"
                                                     imgSubfolder:@"Images"
                                                    decryptionKey:@"YourOwnPrivateKeyThatMustHave32C"];
        
        
        [loader addObjectsToWorld:world cocos2dLayer:self];
        
        if([loader hasPhysicBoundaries])
            [loader createPhysicBoundaries:world];
        
        if(![loader isGravityZero])
            [loader createGravity:world];
        
        [self retrieveRequiredObjects]; // Retrieve all objects after we’ve loaded the level.
        [self setupCollisionHandling];
        [self setupAudio];
        [self setupScore];
        
        [self startDebugDrawing];
		[self scheduleUpdate];
	}
	return self;
}

-(void) spriteInParallaxHasReset:(LHSprite*)sprite
{
    if(COIN == [sprite tag]){
        [sprite setVisible:YES];
    }
    else if(BUNNY == [sprite tag]){
        
        
        [sprite startPathMovement];
        [sprite prepareAnimationNamed:@"BunnyRun" fromSHScene:@"Animations"];
        [sprite playAnimation];
    }
}

-(void) retrieveRequiredObjects
{
    //Retrieve pointers to parallax node and player sprite.
    paralaxNode = [loader parallaxNodeWithUniqueName:@"Parallax_1"];
    NSAssert(paralaxNode!=nil, @"Couldn't find the parallax!");
    
    // add this new line
    [paralaxNode registerSpriteHasMovedToEndListener:self
                                            selector:@selector(spriteInParallaxHasReset:)];
    
    player = [loader spriteWithUniqueName:@"player"];
    NSAssert(player!=nil, @"Couldn't find the player!");
    
    rocketFlame = [loader spriteWithUniqueName:@"flame"];
    NSAssert(rocketFlame!=nil, @"Couldn't find flame sprite!");
    
    [rocketFlame setVisible:NO]; //You can do it in LH, but I do it here so you guys can see it in LH
    
    rotatingLasers = [loader spritesWithTag:ROTATING_LASERS];
    [rotatingLasers retain];
}


-(void)startDebugDrawing
{
    m_debugDraw = new GLESDebugDraw( [LevelHelperLoader pointsToMeterRatio] );
    world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2Draw::e_shapeBit;
    flags += b2Draw::e_jointBit;
    //		flags += b2Draw::e_aabbBit;
    //		flags += b2Draw::e_pairBit;
    //		flags += b2Draw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);
}

-(void) dealloc
{
    [rotatingLasers release];
    
    [loader release];
    loader = nil;
    
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}

-(void) initPhysics
{
	
	//CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
    //Iterate over the bodies in the physics world
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL)
        {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            LHSprite *myActor = (LHSprite*)b->GetUserData();
            
            if(myActor != 0)
            {
                //THIS IS VERY IMPORTANT - GETTING THE POSITION FROM BOX2D TO COCOS2D
                myActor.position = [LevelHelperLoader metersToPoints:b->GetPosition()];
                myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            }
            
        }
    }
    
    if(playerShouldFly)
    {
        [player body]->ApplyLinearImpulse(b2Vec2(0, playerVelocity),
                                          [player body]->GetWorldCenter());
        
        playerVelocity += 0.01f;
        [[SimpleAudioEngine sharedEngine] playEffect:@"fly.wav"];
        
        if(playerVelocity > 1.5f)
            playerVelocity = 1.5f;
    }
    
    for(LHSprite* laser in rotatingLasers)
    {
        [laser transformRotation:[laser rotation]+1];
    }
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(playerIsDead)
        return;
    
    playerVelocity = 0.5f;
    playerShouldFly = true;
    [rocketFlame setVisible:YES];
    [player prepareAnimationNamed:@"mouseFly" fromSHScene:@"Animations"];
    [player playAnimation];
}
////////////////////////////////////////////////////////////////////////////////
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
////////////////////////////////////////////////////////////////////////////////
-(void) cancelPlayerFly
{
    playerShouldFly = false;
    [rocketFlame setVisible:NO];
    playerWasFlying = true;
    playerVelocity = 0.0f;
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelPlayerFly];
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cancelPlayerFly];
}



@end
