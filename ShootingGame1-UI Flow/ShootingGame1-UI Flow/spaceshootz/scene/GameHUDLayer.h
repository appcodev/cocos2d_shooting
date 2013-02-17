//
//  GameHUDLayer.h
//  ShootingGame1-HUD Layer
//
//  Created by Chalermchon Samana on 2/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SpaceHero;

@protocol GameHUDLayerDelegate <NSObject>

-(void)resetGame;
-(void)backToHome;

@end

@interface GameHUDLayer : CCLayer {
    
}

@property (nonatomic,strong) id<GameHUDLayerDelegate> delegate;

-(void)updateUIHeroStat:(SpaceHero*)hero;

-(void)showEndGamePanelWithScore:(int)score kill:(int)kill;

@end
