//
//  CannonBall.m
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-12.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "CannonBall.h"

@interface CannonBall ()

@property (nonatomic) b2BodyDef cannonBallBodyDefinition;

@property (nonatomic) b2CircleShape cannonBallShapeDefinition;

@property (nonatomic) b2FixtureDef cannonBallFixtureDefinition;

@end

@implementation CannonBall

-(id) initAtPosition: (b2Vec2)position withAngle:(float)radians andVelocity:(float)velocity
{
	if( (self=[super init])) {
        // Sprite
        self.cannonBallSprite = [CCSprite spriteWithFile:@"cannonBall.png" /*rect:CGRectMake(0, 0, 96, 96)*/];
        self.cannonBallSprite.scale = 0.08;
        self.cannonBallSprite.tag = 1;
        
        // Body definition
        _cannonBallBodyDefinition.type = b2_dynamicBody;
        _cannonBallBodyDefinition.userData = self.cannonBallSprite;
        _cannonBallBodyDefinition.position.Set(position.x, position.y);
        
        float velocityX = velocity * cos(radians);
        float velocityY = velocity * sin(radians);
        _cannonBallBodyDefinition.linearVelocity = b2Vec2(velocityX, velocityY);
        
        // Shape definition
        _cannonBallShapeDefinition.m_radius = 0.5 * 96/PTM_RATIO * _cannonBallSprite.scale;
        
        // Fixture definition
        _cannonBallFixtureDefinition.shape = &_cannonBallShapeDefinition;
        _cannonBallFixtureDefinition.density = 1.0f;
        _cannonBallFixtureDefinition.friction = 0.2f;
        _cannonBallFixtureDefinition.restitution = 0.8f;
    } // end if
	
	return self;
} // end init

-(b2BodyDef*)getCannonBallBodyDefinition
{
    return &_cannonBallBodyDefinition;
}

-(b2FixtureDef*)getCannonBallFixtureDefinition
{
    return &_cannonBallFixtureDefinition;
}

@end