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
#import "SpaceItem.h"

enum{
    PARTICLE_EFFECT_TAG_DEATH
};

@interface SpaceHero(){
    
    float speedMove;
    float targetY,targetX;
    NSMutableArray *listPow;
    
    //attack
    int attackDefualt;
    int specialAttackDuration;
    
}

@end

@implementation SpaceHero

-(id)init{
    if(self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"space1.png"]]){
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        speedMove = 700;// pixels/sec
        targetY = winSize.height/2;
        targetX = 40+self.boundingBox.size.width/2;
        
        listPow = [[NSMutableArray alloc] init];
        
        //add hero
        [self setPosition:ccp(40+self.boundingBox.size.width/2,winSize.height/2)];
        [self setRotation:90];
        [self setScale:0.5];
        
    }
    
    return self;
}

-(void)newHeroStat{
    _maxHp = DEFAULT_MAX_HP;
    _hp = _maxHp;
    _attackPow = 45;
    attackDefualt = _attackPow;
    _alive = YES;
    _attackStyle = ATTACK_STYLE_NORMAL;
    _cointPoint = 0;
    
    //remove effect
    if([self getChildByTag:PARTICLE_EFFECT_TAG_DEATH]){
        [self removeChildByTag:PARTICLE_EFFECT_TAG_DEATH cleanup:YES];
    }
    
    [self schedule:@selector(update:)];
}


-(void)update:(ccTime)stime{
    
    if(_alive){
        
        //X
        if(targetX <= MOVE_LIMIT_X){
            if(self.position.x != targetX){
                if(self.position.x < targetX){
                    
                    float xx = self.position.x+speedMove*stime;
                    if(xx > targetX) xx=targetX;
                    [self setPosition:ccp(xx, self.position.y)];
                    
                }else if(self.position.x > targetX){
                    float xx = self.position.x-speedMove*stime;
                    if(xx < targetX) xx=targetX;
                    [self setPosition:ccp(xx, self.position.y)];
                }
            }
        }
        
        
        
        //Y
        if(self.position.y != targetY){
            if(self.position.y < targetY){
                
                float yy = self.position.y+speedMove*stime;
                if(yy > targetY) yy=targetY;
                [self setPosition:ccp(self.position.x, yy)];
                
            }else if(self.position.y > targetY){
                float yy = self.position.y-speedMove*stime;
                if(yy < targetY) yy=targetY;
                [self setPosition:ccp(self.position.x, yy)];
            }
        }
        
        [self autoAttack];
    }
}



-(void)autoAttack{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSArray *l = @[@"p1-0.png",@"p1-1.png",@"p2-0.png",@"p2-1.png",@"p3-0.png",@"p3-1.png"];
    
    
    CCSprite *pow = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:l[_attackStyle*2]]];
    
    [pow setRotation:90];
    [pow setScale:0.4];
    [pow setPosition:ccp(self.position.x+pow.boundingBox.size.width*2, self.position.y)];
    
    [self.parent addChild:pow z:self.zOrder-1];
    
    //animte
    NSMutableArray *listFrm = [[NSMutableArray alloc] init];
    
    for (int i=0; i<2; i++) {
        CCSpriteFrame *spf = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:l[(_attackStyle*2)+i]];
        [listFrm addObject:spf];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:listFrm delay:0.1];
    CCAnimate *animate = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [pow runAction:animate];
    
    CCMoveTo *autoAtt = [CCMoveTo actionWithDuration:1.5 position:ccp(winSize.width+pow.boundingBox.size.width, pow.position.y)];
    CCCallFuncN *autoAttEnd = [CCCallFuncN actionWithTarget:self selector:@selector(attackEnd:)];
    CCSequence *seq = [CCSequence actions:autoAtt,autoAttEnd, nil];
    [pow runAction:seq];
    
    //add pow to list
    [listPow addObject:pow];
    
    if(_attackStyle==ATTACK_STYLE_TWO || _attackStyle==ATTACK_STYLE_THREE){
        specialAttackDuration--;
        if(specialAttackDuration<=0){
            specialAttackDuration = 0;
            [self setToNormalAttack];
        }
    }
    
}

-(void)attackEnd:(CCSprite*)sender{
    [listPow removeObject:sender];
    [sender removeFromParentAndCleanup:YES];
}

-(void)move:(CGPoint)location{
    
    targetY = location.y;
    if(location.x<=MOVE_LIMIT_X){
        targetX = location.x;
    }else{
        targetX = MOVE_LIMIT_X;
    }
}

-(BOOL)checkPowerCollisionWithNPC:(SpaceNPC*)npc{
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

-(BOOL)checkConsumeItem:(SpaceItem*)spItem{
    BOOL coll = NO;
    
    CGRect spRect = CGRectMake(spItem.position.x-spItem.boundingBox.size.width/2,
                               spItem.position.y-spItem.boundingBox.size.height/2,
                               spItem.boundingBox.size.width,
                               spItem.boundingBox.size.height);
    
    if(CGRectIntersectsRect([self getCollisionRect], spRect)){
        coll = YES;
    }
    
    return coll;
}

-(void)consumeItem:(SpaceItem*)item{
    //check item type add done effect ...
    switch (item.itemType) {
        case SpaceItemCoin:{
            _cointPoint += item.effectAmount;
            if(_cointPoint>MAX_COIN_POINT)  _cointPoint = MAX_COIN_POINT;
            break;
        }
        case SpaceItemCrystal:{
            _maxHp += 5;
            //effect ...
            
            break;
        }
        case SpaceItemDefence:{
            _hp+=item.effectAmount;
            if(_hp >= _maxHp) _hp=_maxHp;
            break;
        }
        case SpaceItemPower2:{
            _attackPow = attackDefualt+item.effectAmount;
            specialAttackDuration = 300;
            [self setTo2ndAttack];
            break;
        }
        case SpaceItemPower3:{
            _attackPow = attackDefualt+item.effectAmount;
            specialAttackDuration = 150;
            [self setTo3rdAttack];
            break;
        }
    }
}

-(BOOL)checkAttackedFromNPC:(SpaceNPC*)npc{
    BOOL coll = NO;
    
    CGRect npcRect = CGRectMake(npc.position.x-npc.boundingBox.size.width/2,
                               npc.position.y-npc.boundingBox.size.height/2,
                               npc.boundingBox.size.width,
                               npc.boundingBox.size.height);
    
    if(CGRectIntersectsRect([self getCollisionRect], npcRect)){
        coll = YES;
    }

    
    return coll;
}

-(BOOL)attackNPC:(SpaceNPC*)npc{
    return [npc damaged:_attackPow]<=0;
}

-(CGRect)getCollisionRect{
    return CGRectMake(self.position.x-self.boundingBox.size.width/2,
                      self.position.y-self.boundingBox.size.height/2,
                      self.boundingBox.size.width, self.boundingBox.size.height);
}


-(BOOL)effectAttackedFromNPC:(SpaceNPC*)npc{
    
    //check death hero
    if(!_alive) return !_alive;
    
    //damaged
    _hp -= npc.attackPow;
    if(_hp<0)   _hp=0;
    
    //self blink
    CCBlink *blink = [CCBlink actionWithDuration:1 blinks:4];
    [self runAction:blink];
    
    
    //effect
    CCSprite *explode = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"explo2_01.png"]];
    [explode setPosition:self.position];
    [self.parent addChild:explode z:500];
    
    NSMutableArray *listFrames = [[NSMutableArray alloc] init];
    for(int i=1;i<=4;i++){
        CCSpriteFrame *sf = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"explo2_0%d.png",i]];
        [listFrames addObject:sf];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:listFrames delay:0.1];
    CCAnimate *animate = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1];
    CCSequence *sq = [CCSequence actions:animate,[CCCallFuncN actionWithTarget:self selector:@selector(endActAttackFromNPC:)], nil];
    
    [explode stopAllActions];
    [explode runAction:sq];
    
    //check hero death
    if (_hp<=0) {
        _alive = NO;
        
        //stop schedule
        [self unschedule:@selector(update:)];
        
        //paticle run
        CCParticleSystemQuad *em1 = [CCParticleSystemQuad particleWithFile:@"OMG.plist"];
        [em1 setPosition:ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2)];
        [em1 setTag:PARTICLE_EFFECT_TAG_DEATH];
        [em1 setAutoRemoveOnFinish:YES];
        [em1 resetSystem];
        [self addChild:em1 z:1000];
    }
    
    
    return _hp<=0;//return player hp
}

-(void)endActAttackFromNPC:(CCSprite*)explode{
    //NSLog(@"remove ... ");
    [explode removeFromParentAndCleanup:YES];
}

-(float)getHpPercent{
    return _hp/(_maxHp*1.0f);
}

-(void)setToNormalAttack{
    _attackStyle = ATTACK_STYLE_NORMAL;
}

-(void)setTo2ndAttack{
    _attackStyle = ATTACK_STYLE_TWO;
}

-(void)setTo3rdAttack{
    _attackStyle = ATTACK_STYLE_THREE;
}

@end
