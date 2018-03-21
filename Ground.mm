//
//  Ground.mm
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-14.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "Ground.h"

@interface Ground ()

@property (nonatomic) b2BodyDef groundBodyDefinition;

@property (nonatomic) b2EdgeShape groundShapeDefinition;

@property (nonatomic) b2FixtureDef groundFixtureDefinition;

@property (nonatomic) float groundWidth;

@end

@implementation Ground

-(id)initWithSize:(CGSize)size
{
    if( (self=[super init])) {
        // Width
        self.groundWidth = size.width*3;
        
        // Sprite
        self.groundSprite = [CCSprite spriteWithFile:@"square.png" rect:CGRectMake(0, 0, 0, 0)];
        self.groundSprite.tag = 3;

        // Body definition
        _groundBodyDefinition.position.Set(150/PTM_RATIO, 50/PTM_RATIO);
        _groundBodyDefinition.userData = self.groundSprite;
        
        // Shape definition
        _groundShapeDefinition.Set(b2Vec2(0,0), b2Vec2(self.groundWidth/PTM_RATIO, 0));
        
        // Fixture definition
        _groundFixtureDefinition.shape = &_groundShapeDefinition;
        _groundFixtureDefinition.filter.groupIndex = -2;
    } // end if
    
    return self;
}

-(b2BodyDef*)getGroundBodyDefinition
{
    return &_groundBodyDefinition;
}

-(b2FixtureDef*)getGroundFixtureDefinition
{
    return &_groundFixtureDefinition;
}

@end
