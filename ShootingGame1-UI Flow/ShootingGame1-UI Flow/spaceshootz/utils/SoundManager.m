//
//  SoundManager.m
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/11/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"



@implementation SoundManager

+(void)loadSounds{
    
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:SOUND_BG];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SOUND_HERO_GUN];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SOUND_NPC_FLY];
    [[SimpleAudioEngine sharedEngine] preloadEffect:SOUND_NPC_EXPLODE];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:SOUND_BEEP];
    
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:SOUND_BG_VOLUME_DEFAULT/2];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:SOUND_BG_VOLUME_DEFAULT];
}

+(void)playSound:(NSString *)sound volume:(float)v{
    if([sound isEqualToString:SOUND_BG] || [sound isEqualToString:SOUND_END]){
        if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]){
            
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:v];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:sound];
    }else{
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:v/2];
        [[SimpleAudioEngine sharedEngine] playEffect:sound];
        
    }
}

+(void)playSound:(NSString*)sound{
    
    [self playSound:sound volume:SOUND_BG_VOLUME_DEFAULT];
    
}

+(void)stopSoundBG{
    if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]){
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
}

@end
