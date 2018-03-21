//
//  GameInstructionsScene.m
//  Flak44Test
//
//  Created by Acks on 2013-02-20.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "GameInstructionsScene.h"
#import "MainMenuScene.h"

@implementation GameInstructionsScene

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    GameInstructionsScene *layer = [GameInstructionsScene node];
    
    [scene addChild:layer];
    
    return scene;
}

-(id) init
{
    if ((self=[super init])) {
        
        //Hitta (i minnet) och visa den scrollande bakgrunden från klassen BackgroundLayer.
        
        BackgroundLayer *backgroundLayer = [[BackgroundLayer alloc] init];
        
        [self addChild:backgroundLayer];
        
        //Meny-element
        
        CCSprite* instructBackground = [CCSprite spriteWithFile:@"fieldmanual.png"];
        instructBackground.anchorPoint = CGPointMake(0, 0);
        
        [self addChild:instructBackground];
        
        //Skapa menyn
        CCLayer *backMenuLayer = [[CCLayer alloc] init];
        
        [self addChild:backMenuLayer];
        
        //Skapa knappar
        
        CCMenuItemImage *mainMenuButton = [CCMenuItemImage
                                           itemWithNormalImage:@"backbtn.png"
                                           selectedImage:@"backbtn_s.png"
                                           target:self
                                           selector:@selector(mainMenu:)];
        
        mainMenuButton.position = ccp(160, -123);
        
        
        //Ladda in och visa menyn med tillhörande knappar
        CCMenu *backMenu = [CCMenu menuWithItems: mainMenuButton, nil];
        [backMenuLayer addChild: backMenu];
        
        
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
}

-(void) mainMenu: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}


@end
