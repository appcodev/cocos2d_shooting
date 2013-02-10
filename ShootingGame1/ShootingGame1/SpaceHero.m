//
//  SpaceHero.m
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SpaceHero.h"
#import "SpaceNPC.h"
#import "SoundManager.h"

@interface SpaceHero(){
    
    float speedY;
    float targetY;
    NSMutableArray *listPow;
}

@end

@implementation SpaceHero

-(id)init{
    if(self = [super initWithFile:@"space1.png"]){
        
        _attackPow = 15;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        speedY = 700;// pixels/sec
        targetY = winSize.height/2;
        
        listPow = [[NSMutableArray alloc] init];
        
        //add hero
        [self setPosition:ccp(40+self.boundingBox.size.width/2,winSize.height/2)];
        [self setRotation:90];
        [self setScale:0.5];
        
        
        [self schedule:@selector(update:)];
    }
    
    return self;
}


-(void)update:(ccTime)stime{
    
    if(self.position.y != targetY){
        if(self.position.y < targetY){
            
            float yy = self.position.y+speedY*stime;
            if(yy > targetY) yy=targetY;
            [self setPosition:ccp(self.position.x, yy)];
            
        }else if(self.position.y > targetY){
            float yy = self.position.y-speedY*stime;
            if(yy < targetY) yy=targetY;
            [self setPosition:ccp(self.position.x, yy)];
        }
    }
    
    [self autoNormalAttack];
    
}

-(void)autoNormalAttack{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *pow = [CCSprite spriteWithFile:@"pow2.png"];
    [pow setRotation:90];
    [pow setScale:0.4];
    [pow setPosition:self.position];
    
    [self.parent addChild:pow z:self.zOrder-1];
    
    CCMoveTo *autoAtt = [CCMoveTo actionWithDuration:0.5 position:ccp(winSize.width+pow.boundingBox.size.width, pow.position.y)];
    CCCallFuncN *autoAttEnd = [CCCallFuncN actionWithTarget:self selector:@selector(attackEnd:)];
    CCSequence *seq = [CCSequence actions:autoAtt,autoAttEnd, nil];
    [pow runAction:seq];
    
    //add pow to list
    [listPow addObject:pow];
    
    //play sound
    if(arc4random()%100 > 90){
        [SoundManager playSound:SOUND_HERO_GUN];
    }
    
}

-(void)attackEnd:(CCSprite*)sender{
    [listPow removeObject:sender];
    [sender removeFromParentAndCleanup:YES];
}

-(void)move:(CGPoint)location{
    
    targetY = location.y;
    
}

-(BOOL)checkCollisionWithNPC:(SpaceNPC*)npc{
    BOOL collision = NO;
    
    NSMutableArray *deletePow = [[NSMutableArray alloc] init];
    for (CCSprite *p in listPow) {
        if(p!=nil){
            CGRect pr = CGRectMake(p.position.x-p.boundingBox.size.width/2,
                                   p.position.y-p.boundingBox.size.height/2,
                                   p.boundingBox.size.width,
                                   p.boundingBox.size.height);
            
            if(CGRectIntersectsRect(pr, [npc getCollisionRect])){
                collision = YES;
                [deletePow addObject:p];
            }
        }
    }
    
    for(CCSprite *ds in deletePow){
        [listPow removeObject:ds];
        [ds removeFromParentAndCleanup:YES];
    }
    
    [deletePow release];
    
    return collision;
}

-(BOOL)attackNPC:(SpaceNPC*)npc{
    return [npc damaged:_attackPow]<=0;
}


@end
