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
#import "GameWelcome.h"

@interface GameScene(){
    SpaceHero *hero;
    NSMutableArray *listNPCs,*listItems;
    SpaceParallaxBackground *plxBg;
    GameHUDLayer *hudLayer;
    
    //player stat
    int kill;
}

@end

@implementation GameScene

+(CCScene*)scene{
    CCScene *scene = [CCScene node];
    GameHUDLayer *hud = [GameHUDLayer node];
    GameScene *game = [[[GameScene alloc] initWithScoreHUD:hud] autorelease];
    
    [scene addChild:game];
    [scene addChild:hud];
    
    return scene;
}

-(id)initWithScoreHUD:(GameHUDLayer*)hud{
    
    if(self = [super init]){
        
        self.isTouchEnabled = YES;
        
        hudLayer = hud;
        hudLayer.delegate = self;
        
        //parallax bg
        plxBg = [SpaceParallaxBackground node];
        [plxBg backgroundStart];
        [self addChild:plxBg z:-2];
        
        //add hero
        hero = [SpaceHero node];
        [self addChild:hero];
        
        listNPCs = [[NSMutableArray alloc] init];//list NPC
        listItems = [[NSMutableArray alloc] init];//list item
        
        //game loop
        [self schedule:@selector(gameLoop:)];
        
        //new game
        [self newGame];
    }
    
    
    return self;
}


-(void)dealloc{
    [SoundManager stopSoundBG];
    
    [super dealloc];
}

-(void)gameLoop:(ccTime)time{
    
    if([hero isAlive]){
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
                    if([hero effectAttackedFromNPC:npc]){
                        //hero die > game over ...
                        [self gameEnd];
                    }
                }
                
            }
        }
        
        //remove death npc
        for (SpaceNPC *dNpc in deleteNPC) {
            [dNpc deathAct];
            kill++;
        }
        
        [deleteNPC release];
        
        /////////////// check consume item /////////////
        NSMutableArray *comsumedItem = [[NSMutableArray alloc] init];
        for(SpaceItem *item in listItems){
            if(!item.isConsumed && [hero checkConsumeItem:item]){
                [comsumedItem addObject:item];
            }
        }

        for(SpaceItem *item in comsumedItem){
            [item consumedAct];
            [hero consumeItem:item];
        }
        
        [comsumedItem release];
    }
    
    ////////////// update HUD layer //////////////////
    [hudLayer updateUIHeroStat:hero];
    
    
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

-(void)newGame{
    //sound //play bg sound
    [SoundManager playSound:SOUND_BG];
    
    //npc spawn //add npc
    [self schedule:@selector(addNPC:) interval:0.2 repeat:kCCRepeatForever delay:3];
    
    //hero
    [hero newHeroStat];
    
    //
    
}

-(void)gameEnd{
    //sound
    [SoundManager playSound:SOUND_END];
    
    //npc spawn
    [self unschedule:@selector(addNPC:)];
    
    //hero
    
    
    //Game Over Panel show
    [hudLayer showEndGamePanelWithScore:hero.cointPoint kill:kill];
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


////////////////////////////// game HUD Layer delegate ///////////////////////
-(void)resetGame{
    [self newGame];
}


-(void)backToHome{
    //stop game
    //sound
    [SoundManager stopSoundBG];
    
    //npc spawn
    [self unschedule:@selector(addNPC:)];
    [self unschedule:@selector(gameLoop:)];
    
    //scene
    [[CCDirector sharedDirector] replaceScene:[GameWelcome scene]];
}


@end
