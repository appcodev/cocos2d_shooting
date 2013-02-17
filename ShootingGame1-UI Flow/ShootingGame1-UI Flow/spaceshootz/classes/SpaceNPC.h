//
//  SpaceNPC.h
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define NPC_STATE_INIT  0
#define NPC_STATE_MOVE  1
#define NPC_STATE_DIE   2

@class SpaceNPC,SpaceItem;
@protocol SpaceNPCDelegate <NSObject>

-(void)npcMoveOutBound:(SpaceNPC*)npc;
-(void)npcDeath:(SpaceNPC*)npc;

@end

@interface SpaceNPC : CCSprite {
    
}
@property (nonatomic,readonly)  int hp,maxHp,attackPow;
@property (nonatomic,readonly,getter = isAlive) BOOL alive;
@property (nonatomic,strong)    id<SpaceNPCDelegate> delegate;

-(void)moveForward;
-(void)deathAct;

-(SpaceItem*)dropItem;

-(CGRect)getCollisionRect;
-(int)damaged:(int)dmg;

@end
