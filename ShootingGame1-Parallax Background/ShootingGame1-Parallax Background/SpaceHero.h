//
//  SpaceHero.h
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SpaceNPC,SpaceItem;

@interface SpaceHero : CCSprite {
    
}

@property (nonatomic,readonly) int attackPow;

-(BOOL)checkPowerCollisionWithNPC:(SpaceNPC*)npc;
-(BOOL)checkConsumeItem:(SpaceItem*)spItem;
-(BOOL)checkAttackedFromNPC:(SpaceNPC*)npc;

-(void)move:(CGPoint)location;
-(BOOL)attackNPC:(SpaceNPC*)npc;
-(BOOL)effectAttackedFromNPC:(SpaceNPC*)npc;

-(CGRect)getCollisionRect;


@end
