//
//  GameHUDLayer.m
//  ShootingGame1-HUD Layer
//
//  Created by Chalermchon Samana on 2/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameHUDLayer.h"

@interface GameHUDLayer(){
    CCSprite *hpBar;
    CCLabelTTF *scoreText;
    
}

@end

@implementation GameHUDLayer

-(id)init{
    if(self = [super init]){
        
        self.isTouchEnabled = YES;        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //bar
        CCSprite *topBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hud-score-top-bg.png"]];
        
        [topBar setPosition:ccp(winSize.width/2,winSize.height-topBar.boundingBox.size.height/2)];
        [self addChild:topBar];
        
        
        //hp bar :  440.000000 729.000000
        CCSprite *hpMaxBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hud-score-top-hp-max.png"]];
        [hpMaxBar setPosition:ccp(440,729)];
        [self addChild:hpMaxBar];
        
        hpBar = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hud-score-top-hp.png"]];
        
        [hpBar setAnchorPoint:CGPointMake(0, 0)];
        [hpBar setPosition:ccp(440-hpBar.boundingBox.size.width/2,729-hpBar.boundingBox.size.height/2)];
        
        [self addChild:hpBar];
        
        //score text : 696.000000 726.000000
        scoreText = [CCLabelTTF labelWithString:@"000000" fontName:@"Helvetica" fontSize:40];
        [scoreText setAnchorPoint:CGPointMake(0, 0)];
        [scoreText setPosition:ccp(696-scoreText.boundingBox.size.width/2, 726-scoreText.boundingBox.size.height/2)];
        [self addChild:scoreText];
        
    }
    
    return self;
}

-(void)setHeroHpPercent:(float)pHp{
    if(pHp >=0 && pHp <= 1.0){
        [hpBar setScaleX:pHp];
        
    }
}


-(void)setHeroCoinPoint:(int)coin{
    [scoreText setString:[NSString stringWithFormat:@"%d",coin]];
}


@end
