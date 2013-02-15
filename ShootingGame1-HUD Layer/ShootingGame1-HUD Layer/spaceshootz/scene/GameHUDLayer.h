//
//  GameHUDLayer.h
//  ShootingGame1-HUD Layer
//
//  Created by Chalermchon Samana on 2/15/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameHUDLayer : CCLayer {
    
}

-(void)setHeroHpPercent:(float)pHp;
-(void)setHeroCoinPoint:(int)coin;

@end
