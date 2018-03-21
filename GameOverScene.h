//
//  GameOverScene.h
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-25.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "cocos2d.h"
#import "BackgroundLayer.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
@interface GameOverScene : CCLayer
{
    CGPoint size;
    CCSprite *bg1;
    CCSprite *bg2;
}

+(id) scene;

@end
