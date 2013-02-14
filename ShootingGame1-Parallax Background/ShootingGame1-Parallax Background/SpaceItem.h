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
    SpaceItemCoin       = 0,
    SpaceItemPower      = 1,
    SpaceItemDefence    = 2,
    SpaceItemCrystal    = 3
};

typedef int SpaceItemType;

@class SpaceItem;

@protocol SpaceItemDelegate <NSObject>

-(void)itemJumpFinished:(SpaceItem*)item;

@end

@interface SpaceItem : CCSprite {
    
}

@property (nonatomic,strong) id<SpaceItemDelegate> delegate;

-(id)initItemAtPosition:(CGPoint)location type:(SpaceItemType)type;

//action
-(void)consumedAct;

@end
