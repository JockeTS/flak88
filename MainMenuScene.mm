//
//  MainMenuScene.m
//  Flak44Test
//
//  Created by Acks on 2013-02-20.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameWorldScene.h"
#import "GameInstructionsScene.h"

@implementation MainMenuScene

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenuScene *layer = [MainMenuScene node];
    
    [scene addChild:layer];
    
    return scene;
}

-(id) init
{
    if ((self=[super init])) {
        
        //Lägg i (minnet) och visa den scrollande bakgrunden från klassen BackgroundLayer.
        
        BackgroundLayer *backgroundLayer = [[BackgroundLayer alloc] init];
        
        [self addChild:backgroundLayer];
        
        //Meny-element i en sprite.
        
        CCSprite* menuBackground = [CCSprite spriteWithFile:@"menuElements.png"];
        menuBackground.anchorPoint = CGPointMake(0, 0);
        
        [self addChild:menuBackground];
        
        
        //Skapa menyn
        CCLayer *menuLayer = [[CCLayer alloc] init];
        [self addChild:menuLayer];
        
        menuLayer.position = ccp(0, -50);
        
        //Skapa knappar
        
        CCMenuItemImage *startButton = [CCMenuItemImage
                                        itemWithNormalImage:@"startbtn.png"
                                        selectedImage:@"startbtn_s.png"
                                        target:self
                                        selector:@selector(startGame:)];
        
        startButton.position = ccp(0, -10);
        
        CCMenuItemImage *instructButton = [CCMenuItemImage
                                           itemWithNormalImage:@"instructbtn.png"
                                           selectedImage:@"instructbtn_s.png"
                                           target:self
                                           selector:@selector(GameInstructions:)];
        
        instructButton.position = ccp(0, -75);
        
        
        
        //Ladda in och visa menyn med tillhörande knappar.
        
        CCMenu *menu = [CCMenu menuWithItems: startButton, instructButton, nil];
        [menuLayer addChild: menu];
        
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
}

//Tala om vad knapparna ska göra och vart dom ska navigeras till.

-(void) startGame: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[GameWorldScene scene]];
}

-(void) GameInstructions: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[GameInstructionsScene scene]];
}

@end