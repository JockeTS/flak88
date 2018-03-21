//
//  Player.h
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-13.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GameWorldScene.h"

@interface Player : NSObject

// Sprite properties
@property (strong, nonatomic) CCSprite* cannonLoaderSprite;
@property (strong, nonatomic) CCSprite* cannonTurretSprite;
@property (strong, nonatomic) CCSprite* cannonBaseSprite;

-(id) initAtPosition:(b2Vec2)position withAngle:(float)degrees;

-(b2DistanceJointDef*)getCannonDistanceJointDefinition;
-(b2PrismaticJointDef*)getCannonPrismaticJointDefinition;
-(b2RevoluteJointDef*)getCannonRevoluteJointDefinition;

// Get cannon turret body and fixture definitions
-(b2BodyDef*)getCannonLoaderBodyDefinition;
-(b2FixtureDef*)getCannonLoaderFixtureDefinition;

// Get cannon turret body and fixture definitions
-(b2BodyDef*)getCannonTurretBodyDefinition;
-(b2FixtureDef*)getCannonTurretFixtureDefinition;

// Get cannon base body and fixture definitions
-(b2BodyDef*)getCannonBaseBodyDefinition;
-(b2FixtureDef*)getCannonBaseFixtureDefinition;

@end
