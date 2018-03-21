//
//  Ground.h
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-14.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GameWorldScene.h"

@interface Ground : NSObject

// Sprite properties
@property (strong, nonatomic) CCSprite* groundSprite;

-(id)initWithSize:(CGSize)size;

-(b2BodyDef*)getGroundBodyDefinition;

-(b2FixtureDef*)getGroundFixtureDefinition;

@end
