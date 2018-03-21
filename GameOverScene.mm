//
//  GameOverScene.mm
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-25.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    GameOverScene *layer = [GameOverScene node];
    
    [scene addChild:layer];
    
    return scene;
}

-(id) init
{
    if ((self=[super init])) {
        
        
        BackgroundLayer *backgroundLayer = [[BackgroundLayer alloc] init];
        
        [self addChild:backgroundLayer];
        
        //Meny-element
        
        CCSprite* gameOverBackground = [CCSprite spriteWithFile:@"gameOverBack.png"];
        gameOverBackground.anchorPoint = CGPointMake(0, 0);
        
        [self addChild:gameOverBackground];
        
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
        
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
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
