//
//  Helper.h
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-23.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameWorldScene.h"

@interface Helper : NSObject

// Sprites
@property (strong, nonatomic) CCSprite* gameWorldBack;
@property (strong, nonatomic) CCSprite* briefingLabel;
@property (strong, nonatomic) CCSprite* dummySprite;
@property (strong, nonatomic) CCSprite* baseFlag;

@property (strong, nonatomic) CCLabelTTF* killCountLabel;

-(void)createBackgroundImage;
-(void)createMissionBriefing;
-(void)createDummySprite;
-(void)createBaseFlag;
-(void)createKillCountLabelWithKillCount:(int)killCount;

@end
