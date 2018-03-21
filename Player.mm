//
//  Player.mm
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-13.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "Player.h"

@interface Player ()

// Cannon joint properties
@property (nonatomic) b2DistanceJointDef cannonDistanceJointDefinition;
@property (nonatomic) b2RevoluteJointDef cannonRevoluteJointDefinition;
@property (nonatomic) b2PrismaticJointDef cannonPrismaticJointDefinition;

// Cannon loader properties
@property (nonatomic) b2BodyDef cannonLoaderBodyDefinition;
@property (nonatomic) b2PolygonShape cannonLoaderShapeDefinition;
@property (nonatomic) b2FixtureDef cannonLoaderFixtureDefinition;

// Cannon turret properties
@property (nonatomic) b2BodyDef cannonTurretBodyDefinition;
@property (nonatomic) b2PolygonShape cannonTurretShapeDefinition;
@property (nonatomic) b2FixtureDef cannonTurretFixtureDefinition;

// Cannon base properties
@property (nonatomic) b2BodyDef cannonBaseBodyDefinition;
@property (nonatomic) b2PolygonShape cannonBaseShapeDefinition;
@property (nonatomic) b2FixtureDef cannonBaseFixtureDefinition;

@end

@implementation Player

-(id) initAtPosition:(b2Vec2)position withAngle:(float)degrees
{
	if( (self=[super init])) {
        [self defineCannonBaseAtPosition:position];
        [self defineCannonTurretAtPosition:position];
        [self defineCannonLoaderAtPosition:position];
        
        [self defineCannonRevoluteJoint];
        [self defineCannonPrismaticJoint];
        [self defineCannonDistanceJoint];
    } // end if
    
    return self;
} // end init

-(void)defineCannonDistanceJoint
{
    _cannonDistanceJointDefinition.length = 50/2/PTM_RATIO + 15/2/PTM_RATIO;
}

-(void)defineCannonPrismaticJoint
{
    // Local x-axis of cannon turret
    _cannonPrismaticJointDefinition.localAxisA.Set(1, 0);
    _cannonPrismaticJointDefinition.localAxisA.Normalize();
    
    // Local anchor of cannon turret
    _cannonPrismaticJointDefinition.localAnchorA.Set(0, 0);
    // Local anchor of cannon loader
    _cannonPrismaticJointDefinition.localAnchorB.Set(0, 0);
    
    _cannonPrismaticJointDefinition.enableLimit = true;
    _cannonPrismaticJointDefinition.lowerTranslation = -2;
    _cannonPrismaticJointDefinition.upperTranslation = -(50/2/PTM_RATIO + 15/2/PTM_RATIO);
}

-(void)defineCannonRevoluteJoint
{
    // Cannon base anchor
    _cannonRevoluteJointDefinition.localAnchorA = b2Vec2(0, 50/2/PTM_RATIO);
    // Cannon turret anchor
    _cannonRevoluteJointDefinition.localAnchorB = b2Vec2(0, 0) ;
    
    // Limit angle
    _cannonRevoluteJointDefinition.enableLimit = true;
    _cannonRevoluteJointDefinition.lowerAngle = CC_DEGREES_TO_RADIANS(35);
    _cannonRevoluteJointDefinition.upperAngle = CC_DEGREES_TO_RADIANS(35);
}

// Define cannon loader
-(void)defineCannonLoaderAtPosition:(b2Vec2)position
{
    // Sprite, cannonLoader.png - 142x22 px
    self.cannonLoaderSprite = [CCSprite spriteWithFile:@"cannonLoader.png" rect:CGRectMake(-120, 0, 142+120, 22)];
    self.cannonLoaderSprite.scale = 0.8;
    
    // For testing, sprite size same as physics body
    // self.cannonLoaderSprite = [CCSprite spriteWithFile:@"square.png" rect:CGRectMake(0, 0, 15, 15)];
    
    // Body definition
    _cannonLoaderBodyDefinition.type = b2_dynamicBody;
    _cannonLoaderBodyDefinition.position.Set(position.x, position.y + 20/PTM_RATIO);
    _cannonLoaderBodyDefinition.userData = self.cannonLoaderSprite;
    
    // Shape definition, 15x15 box shape
    _cannonLoaderShapeDefinition.SetAsBox( 15/2/PTM_RATIO, 15/2/PTM_RATIO);
    
    // Fixture definition
    _cannonLoaderFixtureDefinition.shape = &_cannonLoaderShapeDefinition;
    _cannonLoaderFixtureDefinition.density = 1.0f;
    _cannonLoaderFixtureDefinition.friction = 0.2f;
    _cannonLoaderFixtureDefinition.restitution = 0.8f;
    _cannonLoaderFixtureDefinition.filter.categoryBits = -2;
}

// Define cannon turret
-(void)defineCannonTurretAtPosition:(b2Vec2)position
{
    // Sprite
    self.cannonTurretSprite = [CCSprite spriteWithFile:@"cannonTurret.png"];
    self.cannonTurretSprite.scale = 0.8;
    
    // For testing, sprite size same as physics body
    // self.cannonTurretSprite = [CCSprite spriteWithFile:@"square.png"rect:CGRectMake(0, 0, 50, 7.5)];
    
    // Body definition
    _cannonTurretBodyDefinition.type = b2_dynamicBody;
    _cannonTurretBodyDefinition.position.Set(position.x, position.y + 10/PTM_RATIO);
    _cannonTurretBodyDefinition.userData = self.cannonTurretSprite;
    
    // Shape definition, 50x7.5 box shape
    _cannonTurretShapeDefinition.SetAsBox(50/2/PTM_RATIO, 7.5/2/PTM_RATIO);
    
    // Fixture definition
    _cannonTurretFixtureDefinition.shape = &_cannonTurretShapeDefinition;
    _cannonTurretFixtureDefinition.density = 1.0f;
    _cannonTurretFixtureDefinition.friction = 0.2f;
    _cannonTurretFixtureDefinition.restitution = 0.8f;
    _cannonTurretFixtureDefinition.filter.categoryBits = -2;
}

// Method defines cannon base
-(void)defineCannonBaseAtPosition:(b2Vec2)position
{
    // Sprite
    _cannonBaseSprite = [CCSprite spriteWithFile:@"cannonBase.png"];
    _cannonBaseSprite.scale = 0.8;
    
    // For testing, sprite size same as physics body
    // _cannonBaseSprite = [CCSprite spriteWithFile:@"square.png" rect:CGRectMake(0, 0, 15, 50)];
    
    // Body definition
    _cannonBaseBodyDefinition.type = b2_staticBody;
    _cannonBaseBodyDefinition.position.Set(position.x, position.y);
    _cannonBaseBodyDefinition.userData = self.cannonBaseSprite;
    
    // Shape definition, 15x50 box shape
    // _cannonBaseShapeDefinition.SetAsBox(15/2/PTM_RATIO, 50/2/PTM_RATIO);
    _cannonBaseShapeDefinition.SetAsBox(15/2/PTM_RATIO, 0/2/PTM_RATIO);
    
    // Fixture definition
    _cannonBaseFixtureDefinition.shape = &_cannonBaseShapeDefinition;
    _cannonBaseFixtureDefinition.density = 1.0f;
    _cannonBaseFixtureDefinition.friction = 0.2f;
    _cannonBaseFixtureDefinition.restitution = 0.8f;
    _cannonBaseFixtureDefinition.filter.categoryBits = -2;
} // end 

-(b2DistanceJointDef*)getCannonDistanceJointDefinition
{
    return &_cannonDistanceJointDefinition;
}

-(b2PrismaticJointDef*)getCannonPrismaticJointDefinition
{
    return &_cannonPrismaticJointDefinition;
}

-(b2RevoluteJointDef*)getCannonRevoluteJointDefinition
{
    return &_cannonRevoluteJointDefinition;
}

-(b2BodyDef*)getCannonLoaderBodyDefinition
{
    return &_cannonLoaderBodyDefinition;
} // end

-(b2FixtureDef*)getCannonLoaderFixtureDefinition
{
    return &_cannonLoaderFixtureDefinition;
} // end

-(b2BodyDef*)getCannonTurretBodyDefinition
{
    return &_cannonTurretBodyDefinition;
} // end

-(b2FixtureDef*)getCannonTurretFixtureDefinition
{
    return &_cannonTurretFixtureDefinition;
} // end

-(b2BodyDef*)getCannonBaseBodyDefinition
{
    return &_cannonBaseBodyDefinition;
} // end

-(b2FixtureDef*)getCannonBaseFixtureDefinition
{
    return &_cannonBaseFixtureDefinition;
} // end

@end