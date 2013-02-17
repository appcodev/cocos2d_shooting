//
//  SpaceParallaxBackground.h
//  ShootingGame1-Parallax Background
//
//  Created by Chalermchon Samana on 2/12/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SpaceParallaxBackground : CCParallaxNode {
    
}

-(void)backgroundStart;
-(void)backgroundStop;

-(void)autoMoveParallaxWithSpeed:(float)speed;

@end
