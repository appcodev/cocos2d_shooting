//
//  SpaceItem.h
//  ShootingGame1-Parallax Background
//
//  Created by Chalermchon Samana on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum SpaceItemType {
    SpaceItemNone       = -1,
    SpaceItemCoin       = 0,//coin +
    SpaceItemPower2    = 1,//power up type 2
    SpaceItemPower3     = 2,//power up type 3
    SpaceItemDefence    = 3,//hp +
    SpaceItemCrystal    = 4//magnet item
};

typedef int SpaceItemType;

@class SpaceItem,SpaceHero;

@protocol SpaceItemDelegate <NSObject>

-(void)itemJumpFinished:(SpaceItem*)item;

@end

@interface SpaceItem : CCSprite {
    
}

@property (nonatomic,strong) id<SpaceItemDelegate> delegate;
@property (nonatomic,readonly) SpaceItemType itemType;
@property (nonatomic,readonly) int effectAmount;
@property (nonatomic,readonly,getter = isConsumed)BOOL consumed;
@property (nonatomic,readonly,getter = isSpecialConsumed)BOOL specialConsumed;

-(id)initItemAtPosition:(CGPoint)location type:(SpaceItemType)type;

//action
-(void)consumedAct;

@end
