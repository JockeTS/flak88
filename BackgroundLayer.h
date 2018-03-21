//
//  BackgroundLayer.h
//  Flak44Test
//
//  Created by Acks on 2013-02-20.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "cocos2d.h"

@interface BackgroundLayer : CCLayer
{
    CGPoint size;
    CCSprite *bg1;
    CCSprite *bg2;
}

+(BackgroundLayer*)backgroundLayer;

@end
