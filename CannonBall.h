//
//  CannonBall.h
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-12.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GameWorldScene.h"

@interface CannonBall : NSObject

@property (strong, nonatomic) CCSprite* cannonBallSprite;

-(id) initAtPosition: (b2Vec2)position withAngle:(float)radians andVelocity:(float)velocity;

-(b2BodyDef*)getCannonBallBodyDefinition;

-(b2FixtureDef*)getCannonBallFixtureDefinition;

@end
