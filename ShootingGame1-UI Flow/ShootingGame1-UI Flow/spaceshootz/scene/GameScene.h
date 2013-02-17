//
//  GameScene.h
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpaceHero.h"
#import "SpaceNPC.h"
#import "SpaceItem.h"
#import "GameHUDLayer.h"

@interface GameScene : CCLayer <SpaceNPCDelegate,SpaceItemDelegate,GameHUDLayerDelegate>{
    
}

+(CCScene*)scene;

@end
