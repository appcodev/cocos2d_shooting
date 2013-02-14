//
//  GameScene.m
//  ShootingGame1
//
//  Created by Chalermchon Samana on 2/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "SoundManager.h"
#import "SpaceParallaxBackground.h"


@interface GameScene(){
    SpaceHero *hero;
    NSMutableArray *listNPCs,*listItems;
    SpaceParallaxBackground *plxBg;
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
        //sprite sheet
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"space2_default.plist"];
        
        //parallax bg
        plxBg = [SpaceParallaxBackground node];
        [self addChild:plxBg z:-2];
        
        //add hero
        hero = [SpaceHero node];
        [self addChild:hero];
        
        
        
        listNPCs = [[NSMutableArray alloc] init];//list NPC
        listItems = [[NSMutableArray alloc] init];//list item
        
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
    
    ////////////// check power collision NPC ////////////////
    NSMutableArray *deleteNPC = [[NSMutableArray alloc] init];
    for (SpaceNPC *npc in listNPCs) {
        if(npc!=nil && [npc isAlive]){
            
            //power -> npc
            if([hero checkPowerCollisionWithNPC:npc]){
                
                if([hero attackNPC:npc]){
                    [deleteNPC addObject:npc];
                }
            }
            
            //npc -> player
            if([hero checkAttackedFromNPC:npc]){
                //npc death when collision player
                if(![deleteNPC containsObject:npc]){
                    [deleteNPC addObject:npc];
                }
                
                //play has effect ...
                [hero effectAttackedFromNPC:npc];
            }
            
        }
    }
    
    //remove death npc
    for (SpaceNPC *dNpc in deleteNPC) {
        [dNpc deathAct];
    }
    
    [deleteNPC release];
    
    
    /////////////// check consume item /////////////
    NSMutableArray *comsumedItem = [[NSMutableArray alloc] init];
    for(SpaceItem *item in listItems){
        if([hero checkConsumeItem:item]){
            [comsumedItem addObject:item];
        }
    }

    for(SpaceItem *item in comsumedItem){
        [item consumedAct];
    }
    
    
}

-(void)addNPC:(ccTime)time{
    
    SpaceNPC *npc = [SpaceNPC node];
    [npc setDelegate:self];
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
    //drop item
    SpaceItem *item = [npc dropItem];
    
    //remove npc
    [listNPCs removeObject:npc];
    [npc removeFromParentAndCleanup:YES];

    if(item!=nil){
        [listItems addObject:item];
        [self addChild:item];
    }
}

////////////////////////////// space item delegate ///////////////////////////
-(void)itemJumpFinished:(SpaceItem *)item{
    [listItems removeObject:item];
}


@end
