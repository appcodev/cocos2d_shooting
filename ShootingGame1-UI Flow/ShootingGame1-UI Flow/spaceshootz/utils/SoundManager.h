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
#define SOUND_END           @"end_game_sound.mp3"

#define SOUND_BG_VOLUME_MIN 0.01
#define SOUND_BG_VOLUME_DEFAULT 0.1

@interface SoundManager : NSObject {
    
}

+(void)loadSounds;
+(void)playSound:(NSString *)sound volume:(float)v;
+(void)playSound:(NSString*)sound;
+(void)stopSoundBG;

@end
