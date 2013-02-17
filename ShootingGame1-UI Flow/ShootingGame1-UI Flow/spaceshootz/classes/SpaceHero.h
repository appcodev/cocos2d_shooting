//
//  SpaceHero.h
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define MAX_COIN_POINT  999999
#define DEFAULT_MAX_HP  100

#define ATTACK_STYLE_NORMAL 0
#define ATTACK_STYLE_TWO    1
#define ATTACK_STYLE_THREE  2

#define MOVE_LIMIT_X    450

@class SpaceNPC,SpaceItem;

@interface SpaceHero : CCSprite {
    
}

@property (nonatomic,readonly) int attackPow,hp,maxHp,cointPoint,attackStyle;
@property (nonatomic,readonly,getter = isAlive) BOOL alive;

//new hero
-(void)newHeroStat;

-(BOOL)checkPowerCollisionWithNPC:(SpaceNPC*)npc;
-(BOOL)checkConsumeItem:(SpaceItem*)spItem;
-(BOOL)checkAttackedFromNPC:(SpaceNPC*)npc;

-(void)consumeItem:(SpaceItem*)item;

-(void)move:(CGPoint)location;
-(BOOL)attackNPC:(SpaceNPC*)npc;
-(BOOL)effectAttackedFromNPC:(SpaceNPC*)npc;


-(CGRect)getCollisionRect;
-(float)getHpPercent;

@end
