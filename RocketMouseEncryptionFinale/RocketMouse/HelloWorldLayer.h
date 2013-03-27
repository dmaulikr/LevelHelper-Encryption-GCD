//
//  HelloWorldLayer.h
//  RocketMouse
//
//  Created by Bogdan Vladu on 12/28/12.
//  Copyright Bogdan Vladu 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "LevelHelperLoader.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
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

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
