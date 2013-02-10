//
//  GameScene.m
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "SoundManager.h"


@interface GameScene(){
    SpaceHero *hero;
    NSMutableArray *listNPCs;
}

@end

@implementation GameScene

+(CCScene*)scene{
    CCScene *scene = [CCScene node];
    GameScene *game = [GameScene node];
    [scene addChild:game];
    
    return scene;
}

-(id)init{
    
    if(self = [super init]){
        
        self.isTouchEnabled = YES;
        
        //load sound
        [SoundManager loadSounds];
        
        //add hero
        hero = [SpaceHero node];
        [self addChild:hero];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"space2_default.plist"];
        
        listNPCs = [[NSMutableArray alloc] init];
        
        //add npc
        [self schedule:@selector(addNPC:) interval:0.2];
        
        //game loop
        [self schedule:@selector(gameLoop:)];
        
        //play bg sound
        [SoundManager playSound:SOUND_BG];
    }
    
    
    return self;
}



-(void)dealloc{
    [SoundManager stopSoundBG];
    
    [super dealloc];
}

-(void)gameLoop:(ccTime)time{
    
    NSMutableArray *deleteNPC = [[NSMutableArray alloc] init];
    //check collision
    for (SpaceNPC *npc in listNPCs) {
        if(npc!=nil && [npc isAlive]){
            if([hero checkCollisionWithNPC:npc]){
                
                if([hero attackNPC:npc]){
                    [deleteNPC addObject:npc];
                }
            }
        }
    }
    
    //remove death npc
    for (SpaceNPC *dNpc in deleteNPC) {
        [dNpc deathAct];
    }
    
    [deleteNPC release];
    
}

-(void)addNPC:(ccTime)time{
    
    SpaceNPC *npc = [SpaceNPC node];
    [self addChild:npc];
    [listNPCs addObject:npc];
    [npc moveForward];
    
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    [hero move:location];
}

/////////////////////////////// space npc delegate //////////////////////////
-(void)npcMoveOutBound:(SpaceNPC *)npc{
    [listNPCs removeObject:npc];
}

-(void)npcDeath:(SpaceNPC *)npc{
    [listNPCs removeObject:npc];
    [npc removeFromParentAndCleanup:YES];

}

@end
