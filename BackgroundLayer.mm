//
//  BackgroundLayer.m
//  Flak44Test
//
//  Created by Acks on 2013-02-20.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(id)init
{
    if((self=[super init])){
        
        //Skapa två sprites (en stor bakgrundsbild som är uppdelad i två filer) som ska omfamna varandra.
        
        bg1 = [CCSprite spriteWithFile:@"bg1_bl.png"];
        bg1.anchorPoint = ccp(0, 0);
        bg1.position = ccp(0, 0);
        [self addChild:bg1];
        
        bg2 = [CCSprite spriteWithFile:@"bg2_bl.png"];
        bg2.anchorPoint = ccp(0, 0);
        bg2.position = ccp([bg1 boundingBox].size.width-1, 0);
        [self addChild:bg2];
        
        //Hastighet på scrollen, ju högre intervalvärde desto långsammare scroll.
        
        [self schedule:@selector(scroll:) interval: 0.11];
    }
    return self;
}

//En metod för scroll som bestämmer hur bakgrundbilden ska bete sig.

- (void)scroll:(ccTime)dt {
    bg1.position = ccp(bg1.position.x-1, bg1.position.y);
    bg2.position = ccp(bg2.position.x-1, bg2.position.y);
    
    if (bg1.position.x <-[bg1 boundingBox].size.width)
        bg1.position = ccp(bg2.position.x+[bg2 boundingBox].size.width, bg1.position.y);{
        }
    if (bg2.position.x <-[bg2 boundingBox].size.width) {
        bg2.position = ccp(bg1.position.x+[bg1 boundingBox].size.width, bg2.position.y);
    }
}

+(BackgroundLayer*)backgroundLayer
{
    BackgroundLayer * backgroundLayer = [BackgroundLayer node];
    
    return backgroundLayer;
}

@end
