//
//  SpaceItem.m
//  ShootingGame1-Parallax Background
//
//  Created by Chalermchon Samana on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SpaceItem.h"
#import "SoundManager.h"
#import "SpaceHero.h"

@interface SpaceItem(){
    SpaceHero *player1;
}

@end

@implementation SpaceItem

-(id)initCoinItemAtPosition:(CGPoint)location{
    
    if(self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"coin_01.png"]]){
        [self setPosition:location];
        
        //coin
        _itemType = SpaceItemCoin;
        _effectAmount = 10+arc4random()%10;//fix
        
        //consume state
        _consumed = NO;
        _specialConsumed = NO;
        
        NSMutableArray *listCoinFrames = [[NSMutableArray alloc] init];
        for (int i=1; i<=8; i++) {
            CCSpriteFrame *sp = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"coin_%02d.png",i]];
            [listCoinFrames addObject:sp];
        }
        CCAnimation *coinAnimation = [CCAnimation animationWithSpriteFrames:listCoinFrames delay:0.05];
        CCAnimate *coinAnimate = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:coinAnimation]];
        
        //run animation sprite frame
        [self runAction:coinAnimate];
        
        //move
        float dr = self.position.x/200;
        CCMoveTo *move = [CCMoveTo actionWithDuration:dr position:ccp(-self.boundingBox.size.width,self.position.y)];
        CCSequence *moveSeq = [CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(itemMoveOutBound:)], nil];
        [moveSeq setTag:55];
        
        //run move
        [self runAction:moveSeq];
        
    }
    
    return self;
    
}

-(id)initItemAtPosition:(CGPoint)location type:(SpaceItemType)type{
    if(type==SpaceItemNone){
        return nil;
    }
    else if(type==SpaceItemCoin){
        return [self initCoinItemAtPosition:location];
    }else{
        
        NSString *sName = @"item7.png";//crystal
        if(type==SpaceItemPower2){
            sName = @"item10.png";
            _effectAmount = 30;
        }else if(type==SpaceItemPower3){
            sName = @"item11.png";
            _effectAmount = 100;
        }
        else if(type==SpaceItemDefence){
            sName = @"item13.png";
            _effectAmount = 50;
        }

        
        if(self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sName]]){
            [self setPosition:location];
            
            _itemType = type;
            
                      
            //consume state
            _consumed = NO;
            _specialConsumed = NO;
            
            //move
            float dr = self.position.x/200;
            CCMoveTo *move = [CCMoveTo actionWithDuration:dr position:ccp(-self.boundingBox.size.width,self.position.y)];
            CCSequence *moveSeq = [CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(itemMoveOutBound:)], nil];
            [moveSeq setTag:55];
            //run move
            [self runAction:moveSeq];
        }
        
    }
    
    
    return self;
}

-(void)itemMoveOutBound:(CCSprite*)sender{
    [sender stopAllActions];
    [sender removeFromParentAndCleanup:YES];
}

-(void)consumedAct{
    //[SoundManager playSound:SOUND_BEEP];
    
    //state
    _consumed = YES;
    
    CCJumpTo *jump = [CCJumpTo actionWithDuration:0.5 position:ccp(self.position.x, self.position.y) height:25 jumps:1];
    CCSequence *sq = [CCSequence actions:jump,[CCCallFuncN actionWithTarget:self selector:@selector(jumpFinished:)], nil];
    
    [self runAction:sq];
}

-(void)jumpFinished:(SpaceItem*)item{
    [_delegate itemJumpFinished:self];
    
    [item removeFromParentAndCleanup:YES];
}


@end
