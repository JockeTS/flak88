//
//  IntroLayer.m
//  Flak44Test
//
//  Created by Jocke Sjolin on 2013-01-31.
//  Copyright Jocke Sjolin 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameWorldScene.h"
#import "MainMenuScene.h"


#pragma mark - IntroLayer
#pragma mark - MainMenuScene

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
//-(id) init
//{
//	if( (self=[super init])) {
//		
//		// ask director for the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//		
//		CCSprite *background;
//		
//		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
//			background = [CCSprite spriteWithFile:@"Default.png"];
//			background.rotation = 90;
//		} else {
//			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
//		}
//		background.position = ccp(size.width/2, size.height/2);
//		
//		// add the label as a child to this Layer
//		[self addChild: background];
//	}
//	
//	return self;
//}
//
//-(void) onEnter
//{
//	[super onEnter];
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
//}


-(void) onEnter
{
	[super onEnter];
    
	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];
    
	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"flak_titlescreen1.png"];
		background.rotation = 0;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);
    
	// add the label as a child to this Layer
	[self addChild: background];
	
	// In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:5];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:1.0 scene:[MainMenuScene scene] ]];
}

@end
