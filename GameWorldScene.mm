#import "GameWorldScene.h"

b2World* world;
b2Body* body;
CCSprite* ball;

// CCSprite* testSprite;
CCSprite* dummySprite;

bool cannonReady = true;
bool followingCannonBall = false;

int spawnTime = (arc4random() % (20)) + 10;

b2Body* cannonBallBody;

b2MouseJoint* mouseJoint;
b2MouseJoint* mouseJointMad;

int i = 0;
float enemyTankTimer = 0;
float cannonBallTimer = 0;

@interface GameWorldScene ()

@property (nonatomic) int killCount;

// Classes
@property (strong, nonatomic) Helper* helper;

@property (nonatomic) CGSize winSize;
@property (nonatomic) float worldWidth;
@property (nonatomic) float screenWidth;

@property (strong, nonatomic) Player* player;
@property (strong, nonatomic) Ground* ground;

// Timers
@property (nonatomic) float delayTimer;

// Camera translation
@property (nonatomic) float cameraTranslationX;

// Bodies
@property (nonatomic) b2Body* enemyTankBody;
@property (nonatomic) b2Body* groundBody;
@property (nonatomic) b2Body* cannonLoaderBody;
@property (nonatomic) b2Body* cannonTurretBody;
@property (nonatomic) b2Body* cannonBaseBody;

// Fixtures
@property (nonatomic) b2Fixture* cannonLoaderFixture;
@property (nonatomic) b2Fixture* cannonBallFixture;
@property (nonatomic) b2Fixture* enemyTankFixture;

// Joints
@property (nonatomic) b2DistanceJoint* cannonDistanceJoint;
@property (nonatomic) b2PrismaticJoint* cannonPrismaticJoint;
@property (nonatomic) b2RevoluteJoint* cannonRevoluteJoint;

// Sprites
@property (strong, nonatomic) CCSprite* cameraSlider;
@property (strong, nonatomic) CCSprite* cameraRuler;
@property (strong, nonatomic) CCSprite* cannonBallSprite;

@property (strong, nonatomic) HUDLayer* hudLayer;

@end

@implementation GameWorldScene

@synthesize explosion = _explosion;
@synthesize explosionAction = _explosionAction;

+ (id)scene {
    CCScene *scene = [CCScene node];
    GameWorldScene *layer = [GameWorldScene node];
    [scene addChild:layer];
    return scene;
}

- (id)init {
    if ((self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        [[CCDirector sharedDirector] setDisplayStats:NO];
        
        [self setTouchEnabled:YES];
        
        self.winSize = [CCDirector sharedDirector].winSize;
        
        self.helper = [[Helper alloc] init];
        
        // Bakgrund
        [self addChild:self.helper.gameWorldBack];
        
        [self createWorld];
        
        self.screenWidth = self.winSize.width;
        self.worldWidth = self.screenWidth * 3;
        [self createGroundWithSize:self.winSize];
        
        [self createPlayerAtPosition:b2Vec2(100/PTM_RATIO,63/PTM_RATIO) withAngle:0];
        
        // Create 2-4 tanks with a for loop
        for (int k = (arc4random() % 2) + 2; k >= 0; k--) {
            b2Vec2 spawnPoint = [self getEnemyTankSpawnPosition];
            [self createEnemyTankAtPosition:spawnPoint withSpeed:0];
        } // end for
        
        self.cameraTranslationX = 0;
        [self createCameraSlider];
        
        // Mission briefing
        [self addChild:self.helper.briefingLabel];
        
        // Dummy sprite
        [self addChild:self.helper.dummySprite];
        
        // Base flag
        [self addChild:self.helper.baseFlag];


        
        self.hudLayer = [[HUDLayer alloc] init];
        
        [self addChild:self.hudLayer];
        
        // Killcount label
        [self.hudLayer addChild:self.helper.killCountLabel];
        
        [self schedule:@selector(tick:)];
        [self scheduleUpdate];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"background1.aiff" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.4];
    }
    return self;
}

-(void)createExplosionAtPosition:(CGPoint)position
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"explo_default.plist"];
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"explo_default.png"];
    [self addChild:spriteSheet];
    
    NSMutableArray *explosionAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 16; i++) {
        [explosionAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%02d.png", i]]];
    }
    CCAnimation *explosionAnim = [CCAnimation animationWithSpriteFrames:explosionAnimFrames delay:0.1f];
    
    // CGSize winSize = [CCDirector sharedDirector].winSize;
    self.explosion = [CCSprite spriteWithSpriteFrameName:@"01.png"];
    self.explosion.scale = 0.7;
    self.explosion.position = position;
    self.explosionAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:explosionAnim] times:1];
    [_explosion runAction:_explosionAction];
    [self addChild:_explosion];
    [explosionAnim retain];
}

-(void)createCameraSlider
{
    // Sprite, 20x40 box shape and markings for the ruler background
    
    self.cameraRuler = [CCSprite spriteWithFile:@"cameraRuler.png"];
    self.cameraRuler.position = ccp(630, 20);
    
    [self addChild:self.cameraRuler];
    
    
    self.cameraSlider = [CCSprite spriteWithFile:@"cameraSlider.png" rect:CGRectMake(0, 0, 20, 40)];
    self.cameraSlider.position = ccp(self.winSize.width/2, self.cameraSlider.contentSize.height/2);
    [self addChild:self.cameraSlider];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (mouseJoint != NULL) return;
    
    UITouch* myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (location.y <=40 ) {
        float newCamPosX;
        
        // minCamLoc
        if (location.x <= self.screenWidth/4 ) {
            newCamPosX = 0;
            
            self.cameraSlider.position = ccp(self.screenWidth/4, self.cameraSlider.contentSize.height/2);
            
            self.cameraTranslationX += newCamPosX - self.cameraTranslationX;
        } else // maxCamLoc
            if (location.x >= self.screenWidth - self.screenWidth/4) {
                newCamPosX = self.worldWidth-self.screenWidth;
                
                self.cameraSlider.position = ccp(self.worldWidth - self.screenWidth/4, self.cameraSlider.contentSize.height/2);
                
                self.cameraTranslationX += newCamPosX - self.cameraTranslationX;
            } else {
                newCamPosX = location.x * 3 -self.screenWidth/2;
                
                self.cameraTranslationX += newCamPosX - self.cameraTranslationX;
                
                // self.hudLayer.position = ccp(location.x + self.cameraTranslationX, 0);
                
                self.cameraSlider.position = ccp(location.x + self.cameraTranslationX, self.cameraSlider.contentSize.height/2);
            }
        
        [self.camera setCenterX:newCamPosX centerY:0 centerZ:0];
        [self.camera setEyeX:newCamPosX eyeY:0 eyeZ:1];
        
    }
    
    location.x = location.x + self.cameraTranslationX;
    
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    if (_cannonLoaderFixture->TestPoint(locationWorld) && cannonReady == true)
    {
        b2MouseJointDef md;
        md.bodyA = _cannonBaseBody;
        md.bodyB = _cannonLoaderBody;
        md.target = locationWorld;
        md.collideConnected = false;
        md.maxForce = 1000.0f * _cannonLoaderBody->GetMass();
        
        mouseJoint = (b2MouseJoint*)world->CreateJoint(&md);
        _cannonTurretBody->SetAwake(true);
        
        _cannonRevoluteJoint->SetLimits(CC_DEGREES_TO_RADIANS(-10), CC_DEGREES_TO_RADIANS(80));
        
        world->DestroyJoint(_cannonDistanceJoint);
        _cannonDistanceJoint = NULL;
        
        cannonReady = false;
    } // end if
} // end ccTouchesBegan

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (location.y <=40 && location.x > 150 - self.cameraTranslationX ) {
        float newCamPosX;
        
        // minCamLoc
        if (location.x <= self.screenWidth/4 ) {
            newCamPosX = 0;
            
            self.cameraSlider.position = ccp(self.screenWidth/4, self.cameraSlider.contentSize.height/2);
            
            self.cameraTranslationX += newCamPosX - self.cameraTranslationX;
        } else // maxCamLoc
            if (location.x >= self.screenWidth - self.screenWidth/4) {
                newCamPosX = self.worldWidth-self.screenWidth;
                
                self.cameraSlider.position = ccp(self.worldWidth - self.screenWidth/4, self.cameraSlider.contentSize.height/2);
                
                self.cameraTranslationX += newCamPosX - self.cameraTranslationX;
            } else {
                newCamPosX = location.x * 3 -self.screenWidth/2;
                
                self.cameraTranslationX += newCamPosX - self.cameraTranslationX;
                
                self.cameraSlider.position = ccp(location.x + self.cameraTranslationX, self.cameraSlider.contentSize.height/2);
            }
        
        [self.camera setCenterX:newCamPosX centerY:0 centerZ:0];
        [self.camera setEyeX:newCamPosX eyeY:0 eyeZ:1];
        
    }
    
    location.x = location.x + self.cameraTranslationX;
    
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    if (mouseJoint == NULL) return;
    mouseJoint->SetTarget(locationWorld);
} // end ccTouchesMoved


-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mouseJoint) {
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    } // end if
} // end ccTouchesCancelled

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Destroy mouse joint if existing on touchesEnded
    if (mouseJoint) {
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    } // end if
    
    // Get cannon turret angle
    float cannonTurretBodyAngle = _cannonTurretBody->GetAngle();
    
    // // Get joint translation to set velocity of cannonball
    float cannonPrismaticJointTranslation = _cannonPrismaticJoint->GetJointTranslation();
    
    // Get world coordinates of front center of cannonTurretBody (x:1, y:0)
    b2Vec2 cannonTurretSpriteFrontCenter = _cannonLoaderBody->GetWorldPoint(b2Vec2(3.5,0));
    
    if (_cannonDistanceJoint==NULL) {
        [self createCannonBallAtPosition:cannonTurretSpriteFrontCenter withAngle:cannonTurretBodyAngle andVelocity:(cannonPrismaticJointTranslation * -8)];
        [self followCannonBall];

        // Re-create distance joint
        [self createCannonDistanceJoint];
        
        // Set revolute joint limits
        _cannonRevoluteJoint->SetLimits(cannonTurretBodyAngle, cannonTurretBodyAngle);
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"shot2.aiff"];
    }
}

// Create World
-(void)createWorld
{
    b2Vec2 gravity = b2Vec2(0.0f, -8.0f);
    world = new b2World(gravity);
    
    _contactListener = new MyContactListener();
    world->SetContactListener(_contactListener);
}

// Create ground
-(void)createGroundWithSize:(CGSize)size
{
    self.ground = [[Ground alloc]initWithSize:size];
    
    [self addChild:self.ground.groundSprite];
    
    b2BodyDef* groundBodyDefinition = [self.ground getGroundBodyDefinition];
    
    b2FixtureDef* groundFixtureDefinition = [self.ground getGroundFixtureDefinition];
    
    self.groundBody = world->CreateBody(groundBodyDefinition);
    
    self.groundBody->CreateFixture(groundFixtureDefinition);
}

// Create enemy tank
-(void)createEnemyTankAtPosition:(b2Vec2)position withSpeed:(float)speed
{
    EnemyTank* enemyTank = [[EnemyTank alloc] initAtPosition:position withSpeed:speed];
    
    [self addChild:enemyTank.enemyTankSprite];
    
    b2BodyDef* enemyTankBodyDefinition = [enemyTank getEnemyTankBodyDefinition];
    
    b2FixtureDef* enemyTankFixtureDefinition = [enemyTank getEnemyTankFixtureDefinition];
    
    _enemyTankBody = world->CreateBody(enemyTankBodyDefinition);
    
    _enemyTankFixture = _enemyTankBody->CreateFixture(enemyTankFixtureDefinition);
}

// Create player
-(void)createPlayerAtPosition:(b2Vec2)position withAngle:(float)degrees
{
    _player = [[Player alloc] initAtPosition:position withAngle:degrees];
    [self createCannonBase];
    [self createCannonTurret];
    [self createCannonLoader];
    
    [self createCannonRevoluteJoint];
    [self createCannonPrismaticJoint];
    [self createCannonDistanceJoint];
}

-(void)createCannonDistanceJoint
{
    b2DistanceJointDef cannonDistanceJointDefinition = *[_player getCannonDistanceJointDefinition];
    
    cannonDistanceJointDefinition.bodyA = _cannonTurretBody;
    cannonDistanceJointDefinition.bodyB = _cannonLoaderBody;
    
    _cannonDistanceJoint = (b2DistanceJoint*)world->CreateJoint(&cannonDistanceJointDefinition);
}

-(void)createCannonPrismaticJoint
{
    b2PrismaticJointDef cannonPrismaticJointDefinition = *[_player getCannonPrismaticJointDefinition];
    
    cannonPrismaticJointDefinition.bodyA = _cannonTurretBody;
    cannonPrismaticJointDefinition.bodyB = _cannonLoaderBody;
    
    _cannonPrismaticJoint = (b2PrismaticJoint*)world->CreateJoint(&cannonPrismaticJointDefinition);
}

-(void)createCannonRevoluteJoint
{
    b2RevoluteJointDef cannonRevoluteJointDefinition = *[_player getCannonRevoluteJointDefinition];
    
    cannonRevoluteJointDefinition.bodyA = _cannonBaseBody;
    cannonRevoluteJointDefinition.bodyB = _cannonTurretBody;
    
    _cannonRevoluteJoint = (b2RevoluteJoint*)world->CreateJoint(&cannonRevoluteJointDefinition);
}

// Create cannon loader
-(void)createCannonLoader
{
    // Sprite
    [self addChild:_player.cannonLoaderSprite];
    
    // Get body definition
    b2BodyDef* cannonLoaderBodyDefinition = [_player getCannonLoaderBodyDefinition];
    
    // Get fixture definition
    b2FixtureDef* cannonLoaderFixtureDefinition = [_player getCannonLoaderFixtureDefinition];
    // Create body
    _cannonLoaderBody = world->CreateBody(cannonLoaderBodyDefinition);
    
    // Create fixture
    _cannonLoaderFixture = _cannonLoaderBody->CreateFixture(cannonLoaderFixtureDefinition);
} // end createCannonTurret

// Create cannon turret
-(void)createCannonTurret
{
    // Sprite
    [self addChild:_player.cannonTurretSprite];
    
    // Get body definition
    b2BodyDef* cannonTurretBodyDefinition = [_player getCannonTurretBodyDefinition];
    
    // Get fixture definition
    b2FixtureDef *cannonTurretFixtureDefinition = [_player getCannonTurretFixtureDefinition];
    
    // Create body
    _cannonTurretBody = world->CreateBody(cannonTurretBodyDefinition);
    
    // Create fixture
    _cannonTurretBody->CreateFixture(cannonTurretFixtureDefinition);
} // end createCannonTurret

// Create cannon base
-(void)createCannonBase
{
    // Sprite
    [self addChild:_player.cannonBaseSprite];
    
    // Get body definition
    b2BodyDef* cannonBaseBodyDefinition = [_player getCannonBaseBodyDefinition];
    
    // Get fixture definition
    b2FixtureDef *cannonBaseFixtureDefinition = [_player getCannonBaseFixtureDefinition];
    
    // Create body
    _cannonBaseBody = world->CreateBody(cannonBaseBodyDefinition);
    
    // Create fixture
    _cannonBaseBody->CreateFixture(cannonBaseFixtureDefinition);
} // end createCannonBase

-(void)createCannonBallAtPosition:(b2Vec2)position withAngle:(float)radians andVelocity:(float)velocity
{
    // Init cannonBall
    CannonBall* cannonBall = [[CannonBall alloc] initAtPosition:position withAngle:(float)radians andVelocity:(float)velocity];
    
    // Add sprite to layer
    // [self addChild:cannonBall.cannonBallSprite];
    
    self.cannonBallSprite = cannonBall.cannonBallSprite;
    [self addChild:self.cannonBallSprite];
    
    // Get body definition
    b2BodyDef* cannonBallBodyDefinition = [cannonBall getCannonBallBodyDefinition];
    
    // Get fixture definition
    b2FixtureDef *cannonBallFixtureDefinition = [cannonBall getCannonBallFixtureDefinition];
    
    // Create body
    cannonBallBody = world->CreateBody(cannonBallBodyDefinition);
    
    // Create fixture
    _cannonBallFixture = cannonBallBody->CreateFixture(cannonBallFixtureDefinition);
}

// Timer for the enemy tanks
-(void)updateEnemyTankTimer
{
    
    if (enemyTankTimer == 0) {
        spawnTime = (arc4random() % (20)) + 10;
    }
    
    enemyTankTimer += 0.017;
    
    if (enemyTankTimer >= spawnTime) {
        b2Vec2 spawnPoint = [self getEnemyTankSpawnPosition];
        [self createEnemyTankAtPosition:spawnPoint withSpeed:0];
        enemyTankTimer = 0;
    }
    [self getEnemyTankSpawnPosition];
}

// Get spawn location for the enemy tanks
-(b2Vec2)getEnemyTankSpawnPosition
{
    int tankSpawnMin = self.screenWidth; // + contentsize
    int tankSpawnMax = self.worldWidth; // - contentsize
    int spawnPointX = (arc4random() % (tankSpawnMax - tankSpawnMin)) + tankSpawnMin;
    b2Vec2 spawnPoint = b2Vec2(spawnPointX/PTM_RATIO, 60/PTM_RATIO);
    return spawnPoint;
}

-(void)tick:(ccTime)dt {
    world->Step(dt, 10, 10);

    [self updateEnemyTankTimer];
    
    // Loop through all bodies in the world
    for(b2Body* b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            // CCSprite* ballData = (CCSprite*)b->GetUserData();
            CCSprite* ballData = (CCSprite*)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            
            /*
            if (ballData.tag == 1 && (ballData.position.x > self.winSize.width/2 || ballData.position.y > self.winSize.height/2) && followCannonBall == false) {
                followingCannonBall = true;
                [self runAction:[CCFollow actionWithTarget:ballData]];
            }
            */
             
            // [self updateEnemyTankTimer];
            
            // cannonBallTimer += 0.1;
            // NSLog(@"timer: %f", cannonBallTimer);
            
            if (ballData.tag == 2) {
                // Add sum speed
                if (b->GetLinearVelocity().x > -0.2) {
                    b->ApplyLinearImpulse(b2Vec2(-0.2, 0), b->GetWorldCenter());
                } // end if
                
                // Check if the tank is at or has passed the flag
                if (ballData.position.x - ballData.contentSize.width/2 <= self.helper.baseFlag.position.x + self.helper.baseFlag.contentSize.width/2 ) {
                    [self makeTransition:3];
                    // NSLog(@"Feind im Reichsgebiet!");
                }
            } // end if
            
            // _enemyTankBody->ApplyLinearImpulse(b2Vec2(-0.03, 0), _enemyTankBody->GetWorldCenter());
        } // end if
    } // end for
    
    //check contacts
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for (pos=_contactListener->_contacts.begin();
         pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        /*
        if ((contact.fixtureA == _cannonBallFixture && contact.fixtureB == _enemyTankFixture) ||
            (contact.fixtureA == _enemyTankFixture && contact.fixtureB == _cannonBallFixture)) {
            // NSLog(@"Feind ausgeschaltet!");
        }
        */
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            /*
            //Sprite A = cannonBall, Sprite B = enemyTank
            if (spriteA.tag == 1 && spriteB.tag == 2) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    toDestroy.push_back(bodyA);
                } // end inner if
            } // end outer if
            //Sprite A = enemyTank, Sprite B = cannonBall
            else */
            
            // Collision between cannonBall and enemyTank
            if (spriteA.tag == 2 && spriteB.tag == 1) {
                // Create explosion at enemyTank's position
                [self createExplosionAtPosition:spriteA.position];
                [[SimpleAudioEngine sharedEngine] playEffect:@"hit1.aiff"];
                // Create some delay
                [self schedule:@selector(followDummy) interval:0 repeat:0 delay:3];
                // self.delayTimer = 150;
                
                // Increment killcount
                [self incrementKillCount];
                
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end()) {
                    toDestroy.push_back(bodyA);
                    toDestroy.push_back(bodyB);
                } // end if
            } // end if
            
            // Collision between cannonBall and ground
            else if (spriteA.tag == 3 && spriteB.tag == 1) {
                // Delay
                [self schedule:@selector(followDummy) interval:0 repeat:0 delay:1.5];
                // self.delayTimer = 100;
                
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA) == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                } // end if
            } // end else if
        } // end if
    } // end for
    
    // Destroy stuff
    std::vector<b2Body *>::iterator pos2;
    for (pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        if (body->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *) body->GetUserData();

            [self removeChild:sprite cleanup:YES];
        } // end if
        
        world->DestroyBody(body);
        cannonReady = true;
    }
    
    if( [_explosionAction isDone] == YES) {
        [self removeChild:_explosion];
    }
    
    // Delay-timer
    if (self.delayTimer > 0) {
        self.delayTimer--;
        
        if (self.delayTimer == 0) {
            [self followDummy];
            self.delayTimer = -1;
        } // end if
    } // end if
} // end tick

-(void)incrementKillCount
{
    self.killCount++;
    [self.hudLayer removeChild:self.helper.killCountLabel];
    [self.helper createKillCountLabelWithKillCount:self.killCount];
    [self.hudLayer addChild:self.helper.killCountLabel];
}

-(void)followCannonBall
{
    [self stopAllActions];
    [self runAction:[CCFollow actionWithTarget:self.cannonBallSprite worldBoundary:CGRectMake(0, 0, self.worldWidth, 640)]];
    // [self runAction:[CCFollow actionWithTarget:self.cannonBallSprite]];
    
    self.hudLayer.visible = false;
}

-(void)followDummy
{
    [self stopAllActions];
    [self runAction:[CCFollow actionWithTarget:self.helper.dummySprite]];
    self.hudLayer.visible = true;
}

-(void)makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:
      [CCTransitionFadeDown transitionWithDuration:2.0 scene:[GameOverScene scene] ]];
}

-(void)dealloc {
    self.explosion = nil;
    self.explosionAction = nil;
    delete world;
    delete _contactListener;
    body = NULL;
    world = NULL;
    [super dealloc];
}

@end