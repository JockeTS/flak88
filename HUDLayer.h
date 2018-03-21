//
//  HUDLayer.h
//  Flak44Test
//
//  Created by Acks on 2013-02-20.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "cocos2d.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
@interface HUDLayer : CCLayer
{
    bool _pauseScreenUp;
    CCLayer *pauseLayer;
    CCSprite *_pauseScreen;
    CCMenu *_pauseScreenMenu;
}


@end
