//
//  SoundManager.h
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/11/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#define SOUND_BG            @"space_bg_sound.mp3"
#define SOUND_NPC_FLY       @"fly.caf"
#define SOUND_NPC_EXPLODE   @"explode.caf"
#define SOUND_HERO_GUN      @"gun.caf"
#define SOUND_BEEP          @"beep4.caf"

@interface SoundManager : NSObject {
    
}

+(void)loadSounds;
+(void)playSound:(NSString*)sound;
+(void)stopSoundBG;

@end
