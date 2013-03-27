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

        CCLabelTTF *helloworld = [CCLabelTTF labelWithString:@"Play Game" fontName:@"Arial" fontSize:32];
        CCLabelTTF *helloworldgcd = [CCLabelTTF labelWithString:@"Play Game with GCD" fontName:@"Arial" fontSize:32];

        CCMenuItemLabel *hw = [CCMenuItemLabel itemWithLabel:helloworld block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer scene]]];
        }];
        CCMenuItemLabel *hwgcd = [CCMenuItemLabel itemWithLabel:helloworldgcd block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayerWithGCD scene]]];
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
