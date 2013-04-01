//
//  MenuLayer.m
//  RocketMouse
//
//  Created by Oguzhan Gungor on 28/03/13.
//  Copyright 2013 Bogdan Vladu. All rights reserved.
//

#import "MenuLayer.h"
#import "HelloWorldLayer.h"
#import "HelloWorldLayerWithGCD.h"

@implementation MenuLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	MenuLayer *layer = [MenuLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
    
	if( (self=[super init])) {

        CGSize screenSize = [CCDirector sharedDirector].winSize;


        CCMenuItemLabel *hw = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Play Game" fontName:@"Arial" fontSize:32] block:^(id sender) {
            //struct timeval before;
            //gettimeofday(&before, NULL);
            NSDate *methodStart = [NSDate date];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer scene]]];
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            //struct timeval after;
            //gettimeofday(&after, NULL);
            NSLog(@"Loading time of your level without gcd took:  %f seconds", executionTime );
            //NSLog(@"before: %d after: %d and result  %d", before.tv_usec,  after.tv_usec,  (after.tv_usec - before.tv_usec) );
        }];
        
        CCMenuItemLabel *hwgcd = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Play Game with GCD" fontName:@"Arial" fontSize:32] block:^(id sender) {
            //struct timeval before;
            //gettimeofday(&before, NULL);
            NSDate *methodStart = [NSDate date];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayerWithGCD scene]]];
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            //struct timeval after;
            //gettimeofday(&after, NULL);
            NSLog(@"Loading time of your level with gcd took:  %f seconds", executionTime);
            //NSLog(@"before: %d after: %d and result  %d", before.tv_usec,  after.tv_usec,  (after.tv_usec - before.tv_usec) );
        }];
        
        CCMenu *menu = [CCMenu menuWithItems: hw, hwgcd, nil];
        [menu alignItemsVerticallyWithPadding:20];
        menu.position =  ccp(screenSize.width/2, screenSize.height/2);
        menu.anchorPoint = ccp(0, 1);
        [self addChild: menu z: 1];

        
        
    }
    return self;
}


@end
