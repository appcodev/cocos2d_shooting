//
//  GameHUDLayer.m
//  ShootingGame1-HUD Layer
//
//  Created by Chalermchon Samana on 2/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameHUDLayer.h"
#import "SpaceHero.h"
#import "SoundManager.h"

#define MENU_SHARE  0
#define MENU_RESET  1
#define MENU_HOME   2

@interface GameHUDLayer(){
    CCSprite *topBar,*hpBar,*gameOverPanel;
    CCLabelTTF *scoreText,*hpText,*govCoinText,*govKillText;
    
}

@end

@implementation GameHUDLayer

-(id)init{
    if(self = [super init]){
        
        //self.isTouchEnabled = YES;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //bar
        topBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hud-score-top-bg.png"]];
        
        [topBar setPosition:ccp(winSize.width/2,winSize.height-topBar.boundingBox.size.height/2)];
        [self addChild:topBar];
        
        
        //hp bar
        CCSprite *hpMaxBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hud-score-top-hp-max.png"]];
        [hpMaxBar setAnchorPoint:CGPointZero];
        [hpMaxBar setPosition:CGPointMake(110, 20)];
        [topBar addChild:hpMaxBar];
        
        hpBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hud-score-top-hp.png"]];
        [hpBar setAnchorPoint:CGPointZero];
        [hpBar setPosition:CGPointMake(110, 20)];
        [topBar addChild:hpBar];
        
        hpText = [CCLabelTTF labelWithString:@"0000/0000" fontName:@"Helvetica" fontSize:20];
        [hpText setPosition:ccp(220, 32)];
        [topBar addChild:hpText];
        
        //score text
        scoreText = [CCLabelTTF labelWithString:@"000000" fontName:@"Helvetica" fontSize:40];
        [scoreText setAnchorPoint:CGPointZero];
        [scoreText setPosition:CGPointMake(410, 10)];
        [topBar addChild:scoreText];
        
        
        ////////////////////////////////////// Game Over ///////////////////////////////////////
        gameOverPanel = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"game-over-bg.png"]];
        [gameOverPanel setPosition:ccp(winSize.width/2,-gameOverPanel.boundingBox.size.height*1.2)];
        [self addChild:gameOverPanel];
        
        govCoinText = [CCLabelTTF labelWithString:@"000000" fontName:@"Helvetica" fontSize:40];
        [govCoinText setAnchorPoint:CGPointZero];
        [govCoinText setPosition:CGPointMake(170, 315)];
        [gameOverPanel addChild:govCoinText];
        
        govKillText = [CCLabelTTF labelWithString:@"000000" fontName:@"Helvetica" fontSize:40];
        [govKillText setAnchorPoint:CGPointZero];
        [govKillText setPosition:CGPointMake(480, 315)];
        [gameOverPanel addChild:govKillText];
        
        CCMenu *menuGOV = [CCMenu node];
        NSArray *listName = @[@"btn-share-1.png",@"btn-share-1.png",@"btn-reset-1.png",@"btn-reset-1.png",@"btn-home-1.png",@"btn-home-1.png"];
        for(int i=0;i<listName.count/2;i++){
            CCSprite *m1 = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:listName[i*2]]];
            CCSprite *m2 = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:listName[i*2+1]]];
            CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalSprite:m1
                                                               selectedSprite:m2
                                                                       target:self selector:@selector(onMenuItemClick:)];
            [menuItem setTag:i];
            [menuItem setScale:0.5];
            [menuGOV addChild:menuItem];
        }
        
        [menuGOV alignItemsHorizontallyWithPadding:30];
        [menuGOV setPosition:ccp(gameOverPanel.boundingBox.size.width/2,200)];
        [gameOverPanel addChild:menuGOV];
        
    }
    
    return self;
}



-(void)updateUIHeroStat:(SpaceHero*)hero{
    if (hero) {
        //hp rate
        float pHp = [hero getHpPercent];
        if(pHp >=0 && pHp <= 1.0){
            [hpBar setScaleX:pHp];
        }
        
        //hp show
        [hpText setString:[NSString stringWithFormat:@"%d/%d",hero.hp,hero.maxHp]];
        
        //coin
        [scoreText setString:[NSString stringWithFormat:@"%d",hero.cointPoint]];
    }else{
        [hpBar setScaleX:1];
        [hpText setString:@"0/0"];
        [scoreText setString:@"0"];
    }
}

-(void)onMenuItemClick:(CCMenuItemImage*)menu{
    [SoundManager playSound:SOUND_BEEP];
    switch (menu.tag) {
        case MENU_SHARE:{
            break;
        }
        case MENU_RESET:{
            //reset panel
            [self resetEndGamePanel];
            
            [_delegate resetGame];
            break;
        }
        case MENU_HOME:{
            [_delegate backToHome];
            break;
        }
    }
}

-(void)resetEndGamePanel{
    
    [self updateUIHeroStat:nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //move
    CCMoveTo *moveShow = [CCMoveTo actionWithDuration:1.5 position:ccp(winSize.width/2,winSize.height-topBar.boundingBox.size.height/2)];
    [topBar runAction:moveShow];
    
    CCMoveTo *moveHide = [CCMoveTo actionWithDuration:1.5 position:ccp(winSize.width/2,-gameOverPanel.boundingBox.size.height*1.2)];
    [gameOverPanel runAction:moveHide];
}

-(void)showEndGamePanelWithScore:(int)score kill:(int)kill{
    
    //setting value
    [govCoinText setString:[NSString stringWithFormat:@"%d",score]];
    [govKillText setString:[NSString stringWithFormat:@"%d",kill]];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //move
    CCMoveTo *moveTop = [CCMoveTo actionWithDuration:1.5 position:ccp(topBar.position.x,winSize.height+topBar.boundingBox.size.height)];
    [topBar runAction:moveTop];
    
    CCMoveTo *moveShow = [CCMoveTo actionWithDuration:1.5 position:ccp(gameOverPanel.position.x,winSize.height/2)];
    [gameOverPanel runAction:moveShow];
    
}

@end
