//
//  SpaceItem.m
//  ShootingGame1-Parallax Background
//
//  Created by Chalermchon Samana on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SpaceItem.h"



@implementation SpaceItem

-(id)initCoinItemAtPosition:(CGPoint)location{
    
    if(self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"coin_01.png"]]){
        [self setPosition:location];
        
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
        NSLog(@"type %d",type);
        NSString *sName = @"item7.png";
        if(type==SpaceItemPower){
            sName = @"item10.png";
        }else if(type==SpaceItemDefence){
            sName = @"item13.png";
        }
        
        
        if(self = [super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sName]]){
            [self setPosition:location];
            
            //move
            float dr = self.position.x/200;
            CCMoveTo *move = [CCMoveTo actionWithDuration:dr position:ccp(-self.boundingBox.size.width,self.position.y)];
            CCSequence *moveSeq = [CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(itemMoveOutBound:)], nil];
            
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


@end
