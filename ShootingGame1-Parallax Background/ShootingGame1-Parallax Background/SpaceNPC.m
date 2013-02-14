//
//  SpaceNPC.m
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SpaceNPC.h"
#import "SoundManager.h"
#import "SpaceItem.h"

@interface SpaceNPC(){
    CCSequence *seqMove,*seqDeath;
    int state;
}

@end

@implementation SpaceNPC

-(id)init{
    
    if(self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space2-1.png"]]){
        _maxHp = 100+arc4random()%100;
        _hp = _maxHp;
        state = NPC_STATE_INIT;
        _alive = YES;
        
        [self setRotation:270];
        [self setScale:0.5];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        //random position
        int randPosX=arc4random()%200,
        randPosY=(arc4random()%(int)(winSize.height-self.boundingBox.size.height*2))+self.boundingBox.size.height;
        [self setPosition:ccp(winSize.width+self.boundingBox.size.width+50+randPosX,randPosY)];
        
        //random speed
        float moveDuration = arc4random()%2+1.5;
        CCMoveTo *move = [CCMoveTo actionWithDuration:moveDuration position:ccp(-self.boundingBox.size.width, randPosY)];
        seqMove = [CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(endNPCMove)], nil];
        
        
        //death action
        NSMutableArray *listDActionFrames = [[NSMutableArray alloc] init];
        for(int i=1;i<=10;i++){
            CCSpriteFrame *sp = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"space2-d%d.png",i]];
            [listDActionFrames addObject:sp];
        }
        CCAnimation *dAnimation = [CCAnimation animationWithSpriteFrames:listDActionFrames delay:0.05];
        CCAnimate *dAnimate = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:dAnimation] times:1];
        seqDeath = [[CCSequence actions:dAnimate,[CCCallFuncN actionWithTarget:self selector:@selector(endNPCDeath)], nil] retain];
        
    }
    
    return self;
}

-(void)endNPCMove{
    [_delegate npcMoveOutBound:self];
    [self removeFromParentAndCleanup:YES];
}

-(void)endNPCDeath{
    [_delegate npcDeath:self];
    [self removeFromParentAndCleanup:YES];
}

-(void)moveForward{
    state = NPC_STATE_MOVE;
    [self runAction:seqMove];
    
    //play sound
    //[SoundManager playSound:SOUND_NPC_FLY];
}

-(void)deathAct{
    if(state==NPC_STATE_MOVE){
        [self stopAllActions];
    }
    _alive = NO;
    state = NPC_STATE_DIE;
    [self setRotation:0];
    [self runAction:seqDeath];
    
    //play sound
    [SoundManager playSound:SOUND_NPC_EXPLODE];
}

-(CGRect)getCollisionRect{
    return CGRectMake(self.position.x-self.boundingBox.size.width/2,
                      self.position.y-self.boundingBox.size.height/2,
                      self.boundingBox.size.width, self.boundingBox.size.height);
}

-(int)damaged:(int)dmg{
    _hp -= dmg;
    //check hp
    if(_hp > _maxHp*0.75){
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space2-2.png"]];
    }else if(_hp > _maxHp*0.55){
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space2-3.png"]];
    }else if(_hp > _maxHp*0.35){
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space2-4.png"]];
    }else if(_hp > _maxHp*0.15){
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space2-5.png"]];
    }
    
    return _hp;
}

-(SpaceItem*)dropItem{
    int change = arc4random()%100;
    SpaceItemType itemType = SpaceItemNone;//15%
    if(change>=15 && change<60){//coin 45%
        itemType = SpaceItemCoin;
    }else if(change>=80 && change<85){//pow 5%
        itemType = SpaceItemPower;
    }else if(change>=90 && change<92){//defence 2%
        itemType = SpaceItemDefence;
    }else if(change>=97 && change<98){//crystal 1%
        itemType = SpaceItemCrystal;
    }
    
    return [[[SpaceItem alloc] initItemAtPosition:self.position type:itemType] autorelease];
}

-(void)dealloc{
    [super dealloc];
}

@end
