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
    
    
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.2];
}

+(void)playSound:(NSString*)sound{
    
    if([sound isEqualToString:SOUND_BG]){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:sound];
    }else{
        [[SimpleAudioEngine sharedEngine] playEffect:sound];
    }
    
}

+(void)stopSoundBG{
    if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]){
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
}

@end
