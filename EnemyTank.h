//
//  EnemyTank.h
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-15.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GameWorldScene.h"

@interface EnemyTank : NSObject

// Sprite properties
@property (strong, nonatomic) CCSprite* enemyTankSprite;

@property (nonatomic) float speed;

-(id)initAtPosition:(b2Vec2)position withSpeed:(float)speed;

-(b2BodyDef*)getEnemyTankBodyDefinition;

-(b2FixtureDef*)getEnemyTankFixtureDefinition;

@end
