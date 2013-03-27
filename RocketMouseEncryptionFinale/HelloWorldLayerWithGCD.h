//
//  HelloWorldLayerWithGCD.h
//  RocketMouse
//
//  Created by Oguzhan Gungor on 28/03/13.
//  Copyright 2013 Bogdan Vladu. All rights reserved.
//

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "LevelHelperLoader.h"

@interface HelloWorldLayerWithGCD : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate> {
    b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    LevelHelperLoader* loader;
    
    
    LHParallaxNode* paralaxNode;
    LHSprite*   player;
    LHSprite*   rocketFlame;
    
    float  playerVelocity;
    bool   playerWasFlying;
    bool   playerShouldFly;
    
    bool playerIsDead;
    
    int score;
    
    NSArray* rotatingLasers;
    
    CCLabelTTF *scoreText;

}

-(void) retrieveRequiredObjects;

+(CCScene *) scene;

@end
