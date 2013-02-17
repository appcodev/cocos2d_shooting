//
//  GameWelcome.m
//  ShootingGame1-UI Flow
//
//  Created by Chalermchon Samana on 2/17/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameWelcome.h"
#import "SoundManager.h"
#import "SpaceParallaxBackground.h"
#import "GameScene.h"

@interface GameWelcome(){
    SpaceParallaxBackground *plxBg;
    CCSprite *logo,*about;
    BOOL action;
}

@end

@implementation GameWelcome

+(CCScene*)scene{
    
    CCScene *scene = [CCScene node];
    GameWelcome *game = [GameWelcome node];
    [scene addChild:game];
    
    return scene;
}

-(id)init{
    if(self=[super init]){
        
        //BG
        plxBg = [SpaceParallaxBackground node];
        [plxBg backgroundStart];
        [self addChild:plxBg];
        
        //sound
        [SoundManager playSound:SOUND_BG volume:SOUND_BG_VOLUME_MIN];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //label Logo
        logo = [CCSprite spriteWithSpriteFrameName:@"sp-logo.png"];
        [logo setPosition:ccp(winSize.width/2,winSize.height/2+50)];
        [self addChild:logo];
        
        CCMenu *menu = [CCMenu node];
        
        
        NSArray *listName = @[@"btn-play-1.png",@"btn-play-2.png",@"btn-about-1.png",@"btn-about-2.png"];
        for(int i=0;i<listName.count/2;i++){
            CCSprite *m1 = [CCSprite spriteWithSpriteFrameName:listName[i*2]];
            CCSprite *m2 = [CCSprite spriteWithSpriteFrameName:listName[i*2+1]];;
            CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalSprite:m1
                                                               selectedSprite:m2
                                                                       target:self
                                                                     selector:@selector(onMenuClick:)];
            if(i>0) [menuItem setScale:0.6];
            
            [menuItem setTag:i];
            [menu addChild:menuItem];
        }
        
        [menu alignItemsInColumns:@2,nil];
        [menu alignItemsVerticallyWithPadding:45];
        [menu setPosition:ccp(logo.boundingBox.size.width/2, -50)];
        [logo addChild:menu];
        
        //label about
        about = [CCSprite spriteWithSpriteFrameName:@"sp-page-about.png"];
        [about setPosition:ccp(winSize.width/2,-about.boundingBox.size.height/2)];
        [self addChild:about];
        
        CCMenuItemImage *aMenuItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn-close-1.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn-close-2.png"]
                                                                    target:self
                                                                  selector:@selector(onMenuClick:)];
        [aMenuItem setScale:0.6];
        [aMenuItem setTag:2];
        
        CCMenu *aMenu = [CCMenu menuWithItems:aMenuItem, nil];
        [aMenu setPosition:ccp(about.boundingBox.size.width/2,125)];
        [about addChild:aMenu];
        
        
    }
    
    return self;
}

-(void)onMenuClick:(CCMenuItemImage*)menu{
    if(!action){
        [SoundManager playSound:SOUND_BEEP];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        switch (menu.tag) {
            case 0:{//play
                //stop
                [SoundManager stopSoundBG];
                [plxBg backgroundStop];
                
                //trans page
                CCTransitionSplitCols *transition = [CCTransitionSplitCols transitionWithDuration:0.5 scene:[GameScene scene]];
                [[CCDirector sharedDirector] replaceScene:transition];
                
                break;
            }
            case 1:{//about
                action = YES;
                
                CCMoveTo *moveUp = [CCMoveTo actionWithDuration:1 position:ccp(logo.position.x,winSize.height+logo.boundingBox.size.height)];
                [logo runAction:moveUp];
                
                CCMoveTo *moveUp2 = [CCMoveTo actionWithDuration:1 position:ccp(about.position.x,winSize.height/2)];
                CCSequence *seq2 = [CCSequence actions:moveUp2,[CCCallFuncN actionWithTarget:self selector:@selector(endMove)], nil];
                [about runAction:seq2];
                
                break;
            }
            case 2:{//close about
                action = YES;
                
                CCMoveTo *moveDown = [CCMoveTo actionWithDuration:1 position:ccp(logo.position.x,winSize.height/2+50)];
                [logo runAction:moveDown];
                
                CCMoveTo *moveDown2 = [CCMoveTo actionWithDuration:1 position:ccp(about.position.x,-about.boundingBox.size.height/2)];
                CCSequence *seq2 = [CCSequence actions:moveDown2,[CCCallFuncN actionWithTarget:self selector:@selector(endMove)], nil];
                [about runAction:seq2];
                
                break;
            }
        }
    }
    
}

-(void)endMove{
    action = NO;
}

@end
