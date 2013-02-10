//
//  SpaceHero.h
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SpaceNPC;

@interface SpaceHero : CCSprite {
    
}

@property (nonatomic,readonly) int attackPow;

-(BOOL)checkCollisionWithNPC:(SpaceNPC*)npc;
-(void)move:(CGPoint)location;
-(BOOL)attackNPC:(SpaceNPC*)npc;
@end
