//
//  GameWorldScene.h
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-02-06.
//  Copyright 2013 Jocke Sjolin. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "SimpleAudioEngine.h"
#import "Player.h"
#import "CannonBall.h"
#import "Ground.h"
#import "EnemyTank.h"
#import "MyContactListener.h"
#import "GLES-Render.h"
#import "HUDLayer.h"
#import "Helper.h"
#import "GameOverScene.h"

#define PTM_RATIO 32.0

// HelloWorldLayer
@interface GameWorldScene : CCLayerColor {
    CCSprite *_explosion;
    CCAction *_explosionAction;
    MyContactListener* _contactListener;
    CCSprite *gameWorldBack;
}
@property (nonatomic, retain) CCSprite *explosion;
@property (nonatomic, retain) CCAction *explosionAction;

+ (id) scene;

@end
