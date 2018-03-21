//
//  Helper.mm
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-23.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

#import "Helper.h"

@interface Helper ()

@property (nonatomic) CGSize winSize;

@end

@implementation Helper

- (id)init {
    if ((self=[super init])) {
        // Win size
        self.winSize = [CCDirector sharedDirector].winSize;

        // Background image
        [self createBackgroundImage];
        
        // Mission briefing
        [self createMissionBriefing];

        // Dummy sprite
        [self createDummySprite];
        
        // Base flag
        [self createBaseFlag];
        
        // Kill count
        [self createKillCountLabelWithKillCount:0];
    } // end if init
    
    return self;
} // end init

-(void)createKillCountLabelWithKillCount:(int)killCount
{
    self.killCountLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Kills: %d", killCount] fontName:@"Marker Felt" fontSize:28 ];
    self.killCountLabel.position = ccp(50, 300);
}

-(void)createBaseFlag
{
    self.baseFlag = [CCSprite spriteWithFile:@"baseFlag.png"];
    self.baseFlag.position = ccp(300, 75);
    self.baseFlag.tag = 4;
}

-(void)createBackgroundImage;
{
    // 1440 × 1120 pixels
    self.gameWorldBack = [CCSprite spriteWithFile:@"GameWorldBackNew.png"];
    self.gameWorldBack.anchorPoint = ccp(0, 0);
    self.gameWorldBack.position = ccp(0, 0);
}

-(void)createMissionBriefing;
{
    self.briefingLabel = [CCSprite spriteWithFile:@"missionBriefing.png"];
    self.briefingLabel.position = ccp(240, 240);
    [self.briefingLabel runAction:[CCFadeTo actionWithDuration:10 opacity:1.0f]];
}

-(void)createDummySprite;
{
    self.dummySprite = [CCSprite spriteWithFile:@"square.png" rect:CGRectMake(0, 0, 0, 0)];
    self.dummySprite.position = ccp(self.winSize.width/2, self.winSize.height/2);
}

@end
