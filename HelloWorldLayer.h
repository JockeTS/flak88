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

#define PTM_RATIO 32.0

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor {
    CCSprite *_explosion;
    CCAction *_explosionAction;
    MyContactListener* _contactListener;
}

@property (nonatomic, retain) CCSprite *explosion;
@property (nonatomic, retain) CCAction *explosionAction;

+ (id) scene;

@end
