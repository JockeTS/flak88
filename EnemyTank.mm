//
//  EnemyTank.mm
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-15.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "EnemyTank.h"

@interface EnemyTank ()

@property (nonatomic) b2BodyDef enemyTankBodyDefinition;

@property (nonatomic) b2PolygonShape enemyTankShapeDefinition;

@property (nonatomic) b2FixtureDef enemyTankFixtureDefinition;

@end

@implementation EnemyTank

-(id)initAtPosition:(b2Vec2)position withSpeed:(float)speed
{
    if( (self=[super init])) {
        // Speed
        self.speed = speed;
        
        // Sprite, 126 × 61 (original size)
        self.enemyTankSprite = [CCSprite spriteWithFile:@"enemyTank.png"];
        self.enemyTankSprite.scale = 0.8;
        //float scale = self.enemyTankSprite.scale;
        self.enemyTankSprite.tag = 2;
        
        // For testing, sprite size same as physics body
        // self.enemyTankSprite = [CCSprite spriteWithFile:@"square.png"rect:CGRectMake(0, 0, 70, 40)];
        
        _enemyTankBodyDefinition.type = b2_dynamicBody;
        _enemyTankBodyDefinition.position.Set(position.x, position.y);
        _enemyTankBodyDefinition.userData = self.enemyTankSprite;
        
        // Shape definition, 60x40 box shape
        _enemyTankShapeDefinition.SetAsBox(126/2/PTM_RATIO * 0.8, 61/2/PTM_RATIO * 0.8);
        
        /*
        b2Vec2 vertices[8];
        vertices[0].Set(0, 0);
        vertices[1].Set(110/PTM_RATIO*scale, 0);
        vertices[2].Set(106/PTM_RATIO*scale, 36/PTM_RATIO*scale);
        vertices[3].Set(66/PTM_RATIO*scale, 41/PTM_RATIO*scale);
        
        vertices[4].Set(65/PTM_RATIO*scale, 54/PTM_RATIO*scale);
        vertices[5].Set(34/PTM_RATIO*scale, 56/PTM_RATIO*scale);
        vertices[6].Set(21/PTM_RATIO*scale, 40/PTM_RATIO*scale);
        vertices[7].Set(-13/PTM_RATIO*scale, 25/PTM_RATIO*scale);

        int32 count = 8;
        
        _enemyTankShapeDefinition.Set(vertices, count);
        */
         
        // Fixture definition
        _enemyTankFixtureDefinition.shape = &_enemyTankShapeDefinition;
        _enemyTankFixtureDefinition.density = 1.0f;
        _enemyTankFixtureDefinition.friction = 0.2f;
        _enemyTankFixtureDefinition.restitution = 0.8f;
        _enemyTankFixtureDefinition.filter.groupIndex = -1;
    } // end if
    
    return self;
}

-(b2BodyDef*)getEnemyTankBodyDefinition
{
    return &_enemyTankBodyDefinition;
}

-(b2FixtureDef*)getEnemyTankFixtureDefinition
{
    return &_enemyTankFixtureDefinition;
}

@end