//
//  HUDLayer.m
//  Flak44Test
//
//  Created by Acks on 2013-02-20.
//  Copyright (c) 2013 Jocke Sjolin. All rights reserved.
//

// HUD = Heads Up Display, för den som aldrig spelat ett spel förut...

#import "HUDLayer.h"

@implementation HUDLayer

-(id)init
{
    if((self=[super init])){
        
        //Börja med att inte visa Pause-menyn till en början
        
        _pauseScreenUp=FALSE;
        
        //Skapa pauseknappen
        
        CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                     itemWithNormalImage:@"pauseBtn.png"
                                     selectedImage:@"pauseBtn_s.png"
                                     target:self
                                     selector:@selector(PauseButtonTapped:)];
        pauseMenuItem.position = ccp(460, 300);
        
        //Lägg in den i våran HUD som en item.
        
        CCMenu *hudMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        hudMenu.position = CGPointZero;
        
        //Visa huden.
        
        [self addChild:hudMenu z:2];
        
        
        
        
    }
    return self;
}

//Dessa tre metoder talar om vad som ska hända när knapparna är nedtryckta.

-(void)PauseButtonTapped:(id)sender
{
    if(_pauseScreenUp == FALSE){
        _pauseScreenUp=TRUE;
        
        //Existerar bakgrundsmusik, så avkommentera denna:
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        
        [[CCDirector sharedDirector] pause];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //Skapa bakgrundselement
        
        _pauseScreen = [[CCSprite spriteWithFile:@"pause_elements.png"] retain];
        _pauseScreen.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_pauseScreen z:8];
        
        //Skapa en "Resume"-knapp och en "Quit"-knapp.
        
        CCMenuItem *ResumeMenuItem = [CCMenuItemImage
                                      itemWithNormalImage:@"resumeBtn.png"
                                      selectedImage:@"resumeBtn_s.png"
                                      target:self
                                      selector:@selector(ResumeButtonTapped:)];
        
        ResumeMenuItem.position = ccp(240, 147);
        
        CCMenuItem *QuitMenuItem = [CCMenuItemImage
                                    itemWithNormalImage:@"quitBtn.png"
                                    selectedImage:@"quitBtn_s.png"
                                    target:self
                                    selector:@selector(QuitButtonTapped:)];
        
        QuitMenuItem.position = ccp(240, 97);
        
        //Ladda in och visa menyn med tillhörande knappar.
        
        _pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem, QuitMenuItem, nil];
        _pauseScreenMenu.position = ccp(0, 0);
        
        [self addChild:_pauseScreenMenu z:10];
    }
}

-(void)ResumeButtonTapped:(id) sender
{
    [self removeChild:_pauseScreen cleanup:YES];
    
    [self removeChild:_pauseScreenMenu cleanup:YES];
    
    [self removeChild:pauseLayer cleanup:YES];
    
    [[CCDirector sharedDirector] resume];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"background1.aiff" loop:YES];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.4];
    
    _pauseScreenUp=FALSE;
}

-(void)QuitButtonTapped:(id)sender
{
    [self removeChild:_pauseScreen cleanup:YES];
    
    [self removeChild:_pauseScreenMenu cleanup:YES];
    
    [self removeChild:pauseLayer cleanup:YES];
    
    [[CCDirector sharedDirector] resume];
    
    //Gå till main menu efter att scenen återupptagits
    
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
    
    _pauseScreenUp=FALSE;
    
    // I fall man vill att appen ska stängas av helt i stället för att gå tillbaka till menyn kan man avkommentera och använda denna.
    
    // [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
}

+(HUDLayer*)hudLayer
{
    HUDLayer * hudLayer = [HUDLayer node];
    
    return hudLayer;
}

@end
