//
//  SpaceParallaxBackground.m
//  ShootingGame1-Parallax Background
//
//  Created by Chalermchon Samana on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SpaceParallaxBackground.h"

#define SPEED_LEVEL_0   0.55f
#define SPEED_LEVEL_1   0.15f
#define SPEED_LEVEL_2   0.35f
#define SPEED_LEVEL_3   0.85f


@implementation SpaceParallaxBackground

-(id)init{
    
    if(self = [super init]){
        
        NSArray *bgLvName = @[@"map_l1_bg.png",@"map_l2_bg.png",@"map_l3_bg.png"];
        
        //background lv 0
        CCSprite *bg0_1 = [CCSprite spriteWithFile:@"map_bg.jpg"];
        [bg0_1 setAnchorPoint:CGPointZero];
        [bg0_1 setTag:0];
        CCSprite *bg0_2 = [CCSprite spriteWithFile:@"map_bg.jpg"];
        [bg0_2 setAnchorPoint:CGPointZero];
        [bg0_2 setTag:1];
        [self addChild:bg0_1 z:-1 parallaxRatio:ccp(0.5, 0.5) positionOffset:ccp(0, 0)];
        [self addChild:bg0_2 z:-1 parallaxRatio:ccp(0.5, 0.5) positionOffset:ccp(bg0_1.boundingBox.size.width, 0)];
        
        
        //add front layer
       for(int i=0;i<bgLvName.count;i++){
            CCSprite *bglv_1 = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:bgLvName[i]]];
            [bglv_1 setAnchorPoint:CGPointZero];
            [bglv_1 setTag:2*(i+1)];
            CCSprite *bglv_2 = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:bgLvName[i]]];
            [bglv_2 setAnchorPoint:CGPointZero];
            [bglv_2 setTag:(2*(i+1))+1];
            [self addChild:bglv_1 z:-1 parallaxRatio:ccp(0.5, 0.5) positionOffset:ccp(0, 0)];
            [self addChild:bglv_2 z:-1 parallaxRatio:ccp(0.5, 0.5) positionOffset:ccp(bglv_1.boundingBox.size.width, 0)];
        }

        
        
    }
    
    return self;
}

-(void)backgroundStart{
    [self schedule:@selector(update:)];
}

-(void)backgroundStop{
    [self unschedule:@selector(update:)];
}

-(void)update:(ccTime)time{
    //parallax background
    [self autoMoveParallaxWithSpeed:600*time];
}

-(void)autoMoveParallaxWithSpeed:(float)speed{
    for (CCSprite *layer in self.children) {
        if(layer.tag%2==0){
            [self moveLayer:layer withSpeed:speed];
        }
    }
}

-(void)moveLayer:(CCSprite*)layer withSpeed:(float)speed{
    int tag = layer.tag;
    
    //layer copy
    CCSprite *copyLayer = (CCSprite*)[self getChildByTag:tag+1];
    
    //speed
    float sp0 = -speed*SPEED_LEVEL_0;
    if(tag==2 || tag==3)        sp0 = -speed*SPEED_LEVEL_1;
    else if(tag==4 || tag==5)   sp0 = -speed*SPEED_LEVEL_2;
    else if(tag==6 || tag==7)   sp0 = -speed*SPEED_LEVEL_3;
    
    CGPoint newPos1 = ccp(layer.position.x+sp0, layer.position.y);
    CGPoint newPos2 = ccp(copyLayer.position.x+sp0, copyLayer.position.y);
    
    if(newPos1.x < -layer.boundingBox.size.width){
        newPos1 = ccp(-layer.boundingBox.size.width,layer.position.y);
    }
    [layer setPosition:newPos1];
    
    if (newPos2.x < 0) {
        newPos2 = ccp(0, copyLayer.position.y);
    }
    [copyLayer setPosition:newPos2];
    
//    if(layer.tag%2==0){
//        NSLog(@"*** %f",layer.position.x);
//    }
    
    if (layer.position.x <= -layer.boundingBox.size.width) {
        //reset position
        [layer setPosition:CGPointZero];
        [copyLayer setPosition:ccp(layer.boundingBox.size.width, 0)];
    }
    
}


@end
