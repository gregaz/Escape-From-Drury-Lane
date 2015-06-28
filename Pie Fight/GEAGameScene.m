//
//  GEAGameScene.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 10/20/14.
//  Copyright (c) 2014 Gregory Azuolas. All rights reserved.
//
// TODO:
//v1
// Sounds/Music
// Icons/itunes connect

//v2
// Rate Me
// Show unlocked medals
// Story Screen

//v3
// Level progression screen
// Clean up code

#import "GEAGameScene.h"
#import "GEAJoyStick.h"
#import "GEAButton.h"
#import "GEAGingerBreadMan.h"
#import "GEARandomizablePositionNode.h"
#import "GEAHoleNode.h"
#import "GEAMuffinStackNode.h"
#import "GEADoorNode.h"
#import "GEAMuffinMan.h"
#import "GEAConstants.h"
#import "GEAStartMenuScene.h"
#include <stdlib.h>
@import AVFoundation;

static const int incAmount = 30;
static const int controlsHeight = 100;

@implementation GEAGameScene{
    GEAGingerBreadMan *player;
    GEADoorNode *door;
    int levelNumber;
    int score;
    bool didFlipHolesOnce;
    bool shouldGoToNextLevel;
    bool shouldEndGame;
    bool hasGameEnded;
    bool wasAdShown;
    NSMutableArray *holes;
    NSMutableArray *muffinStacks;
    NSMutableArray *muffinMen;
    GEAJoyStick *joystick;
    GEAButton *retryButton;
    GEAButton *nextLevelButton;
    GEAButton *shareToFBButton;
    GEAButton *shareToTheBirdButton;
    SKSpriteNode *nextLevelBackground;
    SKPhysicsBody *muffinManPhysicsBody;
    NSMutableArray *muffinManAnimationArray;
    SKTextureAtlas *muffinManTextureAtlas;
    GEAMuffinMan *murderMan;
    SKTextureAtlas *holeSpawnAtlas;
    SKTexture *closedHoleTexture;
    
    NSMutableArray *holeOpeningArray;
    NSMutableArray *holeClosingArray;
    
    CFTimeInterval lastUpdateTime;
    SKAction *impactSound;
    
    AVAudioPlayer *gameMusicPlayer;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        levelNumber = -1;
        score = -1;
        holes = [NSMutableArray array];
        muffinStacks = [NSMutableArray array];
        muffinMen = [NSMutableArray array];
        didFlipHolesOnce = false;
        shouldGoToNextLevel = false;
        shouldEndGame = false;
        hasGameEnded = false;
        lastUpdateTime = 0;
        retryButton = nil;
        wasAdShown = false;
        impactSound = [SKAction playSoundFileNamed:@"muffinImpact.wav" waitForCompletion:NO];
        [self startMusicIfRequired];
        [self initAnimationAtlasAndArrays];
        [self initMuffinManPhysicsBody];
        [self addScoreBoard];
        [self addControls];
        [self initializePlayer];
        [self initializeDoor];
        [self nextLevel];
        
    }
    return self;
}

- (void)nextLevel {
    levelNumber = levelNumber + 1;
    [self incrementScore];
    [self clearHoles];
    [self clearMuffinStacks];
    [self clearMuffinMen];
    [self resetPlayer];
    [self spawnHoles];
    [self spawnMuffinStacks];
    [self resetDoorPosition];
}

-(void)startMusicIfRequired {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* shouldPlayMusic = [defaults stringForKey:@"music"];
    if([shouldPlayMusic isEqualToString:@"true"]) {
        if (gameMusicPlayer == nil || !([gameMusicPlayer isPlaying]) ){
            NSError *error;
            NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"gameMusic" withExtension:@"wav"];
            gameMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
            gameMusicPlayer.numberOfLoops = -1;
            [gameMusicPlayer prepareToPlay];
            [gameMusicPlayer play];
        }}
}

-(void)drawGameOverOverlay {
    
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed: @"finalScoreBackGround.png"];
    background.position = CGPointMake(0, self.frame.size.height*0.55);
    background.size = CGSizeMake(self.frame.size.width*2.0, self.frame.size.height*0.5);
    [background setZPosition: 50];
    [self addChild:background];
    
    SKSpriteNode *medalNode = [[SKSpriteNode alloc] initWithImageNamed: [GEAConstants medalImageNameForScore: score]];
    medalNode.position = CGPointMake(self.frame.size.width*0.2, self.frame.size.height * 0.55);
    [medalNode setZPosition:100];
    [medalNode setScale: 0.2];
    [self addChild:medalNode];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed: @"AmericanTypewriter"];
    gameOverLabel.position = CGPointMake(self.frame.size.width*0.65, self.frame.size.height*0.65);
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontColor = [UIColor whiteColor];
    gameOverLabel.fontSize = 50;
    [gameOverLabel setZPosition:100];
    
    [self addChild: gameOverLabel];

    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"AmericanTypewriter"];
    scoreLabel.position = CGPointMake(self.frame.size.width*0.65, self.frame.size.height*0.5);
    scoreLabel.text = [NSString stringWithFormat: @"Final Score: %i", score];
    scoreLabel.fontColor = [UIColor whiteColor];
    scoreLabel.fontSize = 50;
    [scoreLabel setZPosition:100];
    
    [self addChild:scoreLabel];
    
    retryButton = [[GEAButton alloc] initWithButtonImageNamed: @"retryButton.png"];
    retryButton.position = CGPointMake(self.frame.size.width*0.45, self.frame.size.height*0.4);
    [retryButton setZPosition: 100];
    
    [self addChild: retryButton];
    
    shareToFBButton = [[GEAButton alloc] initWithButtonImageNamed: @"shareToFb.png"];
    shareToFBButton.position = CGPointMake(self.frame.size.width*0.65, self.frame.size.height*0.4);
    [shareToFBButton setZPosition: 100];
    
    [self addChild: shareToFBButton];
    
    shareToTheBirdButton = [[GEAButton alloc] initWithButtonImageNamed: @"shareToTwitter.png"];
    shareToTheBirdButton.position = CGPointMake(self.frame.size.width*0.85, self.frame.size.height*0.4);
    [shareToTheBirdButton setZPosition: 100];
    
    if (self.frame.size.width == 480) {
        [shareToFBButton setScale: 0.4];
        [shareToTheBirdButton setScale:0.4];
        [retryButton setScale:0.4];
        scoreLabel.fontSize = 40;
    }
    
    [self addChild: shareToTheBirdButton];
    
    [[self childNodeWithName: @"scoreLabel"] removeFromParent];
    
    NSDictionary* highScoreEntry = [[NSDictionary alloc]
                                    initWithObjects: [NSArray arrayWithObjects: [NSNumber numberWithInt:score], [NSDate date], nil]
                                    forKeys: [NSArray arrayWithObjects: @"score", @"date", nil]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray* highScores = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"highScores"]];
    [highScores addObject: highScoreEntry];
    NSSortDescriptor* scoreSorter = [[NSSortDescriptor alloc] initWithKey: @"score" ascending:false];
    NSArray* sortedHighScores = [highScores sortedArrayUsingDescriptors:[NSArray arrayWithObject:scoreSorter]];
    

    sortedHighScores = [sortedHighScores subarrayWithRange: NSMakeRange(0, MIN(3, sortedHighScores.count))];
    [defaults setObject:sortedHighScores forKey:@"highScores"];
    [defaults synchronize];
    
}



-(void)addScoreBoard {
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    scoreLabel.position = CGPointMake(self.frame.size.width*0.05,self.frame.size.height*0.9);
    scoreLabel.fontSize = 25;
    scoreLabel.fontColor = [UIColor whiteColor];
    scoreLabel.text = [NSString stringWithFormat: @"%d", score ];
    scoreLabel.name = @"scoreLabel";
    [self addChild:scoreLabel];
}

-(void)incrementScore {
    score = score + 1;
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"scoreLabel"];
    scoreLabel.text = [NSString stringWithFormat: @"%d", score ];
}

-(void)addDebugLabels{
    SKLabelNode *joystickLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    joystickLabel.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    joystickLabel.fontSize = 25;
    joystickLabel.fontColor = [UIColor whiteColor];
    joystickLabel.text = @"";
    joystickLabel.name = @"joystickLabel";
    [self addChild:joystickLabel];
}

-(void)addControls {
    float joystickX;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* handedness = [defaults stringForKey:@"handedness"];
    
    if([handedness isEqualToString: @"right" ]) {
        joystickX = 0.8;
    } else {
        joystickX = 0.2;
    }
    
    joystick = [[GEAJoyStick alloc] initWithJoystickImage: @"centerJoystick.png" baseImage: @"baseCenter.png"];
    [joystick setPosition:CGPointMake(self.frame.size.width*joystickX,self.frame.size.height*0.1)];
    [joystick setZPosition: -100.0];
    [self addChild: joystick];
}

-(void)initializePlayer {
    player = [[GEAGingerBreadMan alloc] initGingerBreadManWithDefaultImage];
    [player setScale:0.1];
    player.name = @"player";
    [self resetPlayer];
    
    [self addChild:player];
    
}

-(void)resetPlayer {
    [player setPosition: CGPointMake(self.frame.size.width * 0.9, 0.0)];
    [player randomizeYPositionForIncrements:incAmount andControlsHeight:controlsHeight andSceneHeight: self.frame.size.height];
    player.hidden = false;
}

-(void)clearMuffinMen {
    for (GEAMuffinMan *muffinMan in muffinMen) {
        [muffinMan runAction: [SKAction removeFromParent]];
    }
    [muffinMen removeAllObjects];
}

-(void)initMuffinManPhysicsBody {
    SKTexture* tempTexture = [SKTexture textureWithImageNamed: @"muffinMan1"];
    muffinManPhysicsBody = [SKPhysicsBody bodyWithTexture:tempTexture size:tempTexture.size];
}

-(void)initAnimationAtlasAndArrays {
    holeSpawnAtlas = [SKTextureAtlas atlasNamed: @"holeSpawn"];
    holeOpeningArray = [NSMutableArray array];
    holeClosingArray = [NSMutableArray array];
    muffinManAnimationArray = [NSMutableArray array];
    muffinManTextureAtlas = [SKTextureAtlas atlasNamed: @"muffinMen"];
    
    for(int i = 1; i <= 11; i++) {
        NSString* fileName = [NSString stringWithFormat: @"holeSpawn%i", i];
        SKTexture *temp = [holeSpawnAtlas textureNamed:fileName];
        [holeOpeningArray addObject:temp];
    }
    
    for(int i = 1; i <= muffinManTextureAtlas.textureNames.count; i++) {
        NSString* fileName = [NSString stringWithFormat: @"muffinMan%i", i];
        SKTexture *temp = [muffinManTextureAtlas textureNamed:fileName];
        [muffinManAnimationArray addObject:temp];
    }
    
    closedHoleTexture = [holeSpawnAtlas textureNamed: @"holeClosed"];
    
}

-(void)spawnMuffinManFromHole: (GEAHoleNode*) aHole {
    GEAMuffinMan* muffinMan = [[GEAMuffinMan alloc] initMuffinManWithPhysicsBody: [muffinManPhysicsBody copy] andAnimationArray: muffinManAnimationArray andImpactSound:impactSound];
    [muffinMan setPosition: aHole.position];
    [muffinMan setScale: 0.3];
    [self addChild:muffinMan];
    [muffinMen addObject: muffinMan];
    
}

-(void)spawnMuffinStacks {
    
    int numberOfMuffinStacks = 5;
    for (int i = 0; i < numberOfMuffinStacks; i++)
    {
        [self addMuffinStack];
    }
    
}

-(void)clearMuffinStacks {
    for (GEAMuffinStackNode *muffinStack in muffinStacks) {
        [muffinStack runAction: [SKAction removeFromParent]];
    }
    [muffinStacks removeAllObjects];
}

-(void)addMuffinStack {
    GEAMuffinStackNode *muffinStack = [[GEAMuffinStackNode alloc] initWithRandomNumberOfMuffins];
    
    [muffinStack initializeCollisionConfig];
    do {
        [muffinStack randomizePositionForIncrements:incAmount andControlsHeight:controlsHeight andSceneHeight:self.frame.size.height andSceneWidth:self.frame.size.width];
    } while ( [self anyHolesOrMuffinStacksLieOnSprite: muffinStack] );
    [self addChild: muffinStack];
    [muffinStacks addObject: muffinStack];
}

-(void)spawnHoles {
    int numberOfHoles = 4 + levelNumber/5;
    
    for (int i = 0; i < numberOfHoles; i++) {
        [self addHole];
    }
    
}

-(void)clearHoles {
    for (GEAHoleNode *hole in holes) {
        [hole runAction: [SKAction removeFromParent] ];
    }
    [holes removeAllObjects];
}

-(void)initializeDoor {
    door = [[GEADoorNode alloc] initDoor];
    [self resetDoorPosition];
    [door setScale: 0.2];
    [self addChild: door];
}

-(void)resetDoorPosition {
    [door setPosition: CGPointMake(self.frame.size.width * 0.05, 0.0)];
    [door randomizeYPositionForIncrements:incAmount andControlsHeight:controlsHeight andSceneHeight:self.frame.size.height-20.0];
}


-(void)addHole {
    GEAHoleNode *hole = [[GEAHoleNode alloc] initHoleWithOpeningArray:holeOpeningArray andCloseTexture:closedHoleTexture];
    int numberOfTries = 0;
    do {
        [hole randomizePositionForIncrements: incAmount andControlsHeight:controlsHeight andSceneHeight:self.frame.size.height andSceneWidth:self.frame.size.width];
        numberOfTries++;
    } while ( [self anyHolesOrMuffinStacksLieOnSprite: hole] && numberOfTries != 11 );
    
    if (numberOfTries != 11) {
        [self addChild: hole];
        [holes addObject: hole];
        [hole spawnInitialMuffinManIfRequired];
        
    }
}

-(NSMutableArray*) holesAndMuffinStacks {
    NSMutableArray *holesAndMuffins = [NSMutableArray array];
    [holesAndMuffins addObjectsFromArray: holes ];
    [holesAndMuffins addObjectsFromArray: muffinStacks];
    return holesAndMuffins;
}

-(NSMutableArray*) holesAndMuffinMen {
    NSMutableArray *holesAndMuffinMen = [NSMutableArray array];
    [holesAndMuffinMen addObjectsFromArray: holes ];
    [holesAndMuffinMen addObjectsFromArray: muffinMen];
    return holesAndMuffinMen;
}


-(bool)anyHolesOrMuffinStacksLieOnSprite:(SKSpriteNode *)aPotentialSprite {
    NSMutableArray *pointsToCheck = [NSMutableArray array];
    [pointsToCheck addObject: [NSValue valueWithCGPoint:CGPointMake(aPotentialSprite.position.x + aPotentialSprite.size.width/2.0, aPotentialSprite.position.y + aPotentialSprite.size.height/2.0+1)]];
    [pointsToCheck addObject: [NSValue valueWithCGPoint:CGPointMake(aPotentialSprite.position.x + aPotentialSprite.size.width/2.0, aPotentialSprite.position.y - aPotentialSprite.size.height/2.0+1)]];
    [pointsToCheck addObject: [NSValue valueWithCGPoint:CGPointMake(aPotentialSprite.position.x - aPotentialSprite.size.width/2.0, aPotentialSprite.position.y + aPotentialSprite.size.height/2.0+1)]];
    [pointsToCheck addObject: [NSValue valueWithCGPoint:CGPointMake(aPotentialSprite.position.x - aPotentialSprite.size.width/2.0, aPotentialSprite.position.y - aPotentialSprite.size.height/2.0+1)]];
    [pointsToCheck addObject: [NSValue valueWithCGPoint:aPotentialSprite.position]];
    
    for (SKSpriteNode *existingHoleOrMuffin in [self holesAndMuffinStacks]) {
        for (NSValue *valueToCheck in pointsToCheck) {
            CGPoint pointToCheck = valueToCheck.CGPointValue;
            if ( [existingHoleOrMuffin containsPoint: pointToCheck]) {
                return true;
            }
        }
    }
    return false;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (hasGameEnded) {
        if (![murderMan hasActions]) {
            if(retryButton == nil) {
                [self drawGameOverOverlay];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString* shouldPostToLeaderBoard = [defaults stringForKey:@"postToLeaderBoard"];
                if([shouldPostToLeaderBoard isEqualToString:@"true"]) {
                    NSString* scoreString = [NSString stringWithFormat: @"%i", score];
                    NSDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:
                                              scoreString forKey:@"score"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"authenticateLocalPlayerAndSendScore" object:self userInfo:userInfo];
                }
            }
        }
        if ([retryButton shouldActionPress]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
            GEAStartMenuScene *startScene = [GEAStartMenuScene sceneWithSize:self.view.bounds.size];
            startScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene: startScene];
        }
        
        if ([shareToFBButton shouldActionPress]) {
            NSString *postText = [NSString stringWithFormat: @"I just scored %i in Escape From Drury Lane!", score];
            NSDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:postText forKey:@"postText"];
            [userInfo setValue: @"facebook" forKey: @"service"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatePost" object:self userInfo:userInfo];
        }
        
        if ([shareToTheBirdButton shouldActionPress]) {
            NSString *postText = [NSString stringWithFormat: @"I just scored %i in Escape From Drury Lane!", score];
            NSDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:postText forKey:@"postText"];
            [userInfo setValue: @"twitter" forKey: @"service"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CreatePost" object:self userInfo:userInfo];
        }
        
    } else {
        if (shouldEndGame) {
            for (SKSpriteNode* child in [self children]) {
                [child removeAllActions];
            }
            
            [player removeFromParent];
            [murderMan animateEatGingerBreadMan];
            hasGameEnded = true;
            
        } else {
            if(shouldGoToNextLevel) {
                for (SKNode *holeOrMuffinMan in [self holesAndMuffinMen]) {
                    [holeOrMuffinMan removeAllActions];
                }
                //this doesnt seem to work in didBeginContact: bad timing mayhaps?
                if( ![player isHidden] ){
                    [door animateDoorWalkThrough];
                    player.hidden = true;
                }
                if( ![door hasActions]) {
                    if (nextLevelButton == nil) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
                        nextLevelButton = [[GEAButton alloc] initWithButtonImageNamed: @"nextLevelButton.png"];
                        [nextLevelButton setPosition: CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5)];
                        [nextLevelButton setZPosition: 10.0];
                        [self addChild:nextLevelButton];
                        
                        nextLevelBackground = [[SKSpriteNode alloc] initWithImageNamed:@"finalScoreBackGround.png"];
                        [nextLevelBackground setPosition: CGPointMake(0, self.frame.size.height*0.5)];
                        [nextLevelBackground setSize: CGSizeMake(self.frame.size.width*2.0, self.frame.size.height*0.2)];
                        [nextLevelBackground setZPosition: 9.0];
                        [self addChild: nextLevelBackground];

                    } else if ([nextLevelButton isHidden]) {
                        [nextLevelButton setHidden:false];
                        [nextLevelButton setZPosition: 10.0];
                        [nextLevelBackground setHidden:false];
                        [nextLevelBackground setZPosition:9.0];
                    }
                    
                    if ([nextLevelButton shouldActionPress]) {
                            wasAdShown = false;
                            [nextLevelButton setHidden:true];
                            [nextLevelBackground setHidden:true];
                            shouldGoToNextLevel = false;
                            [self nextLevel];
                    }
                    
                }

            } else {
                
                
                for (GEAMuffinMan *muffinMan in muffinMen) {
                    [muffinMan updateVeolictyIfNeededBasedOnTime:currentTime towardsPlayer:player];
                }
                
                [player moveUsingVectorWithX:joystick.x andY:joystick.y andTimeDelta: currentTime -lastUpdateTime];
            }
        }
    }
    lastUpdateTime = currentTime;
    [super update:currentTime];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    if (![joystick containsPoint:touchLocation]) {
        [player throwMuffinWithDirectionVectorX: joystick.x andY: joystick.y];
    }
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (!hasGameEnded) {
        if( contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == muffinStackCategory) {
            [(GEAGingerBreadMan*) contact.bodyA.node pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) contact.bodyB.node ];
        }
        
        if(contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == muffinStackCategory) {
            [(GEAGingerBreadMan*) contact.bodyB.node pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) contact.bodyA.node ];
            
        }
        
        if((contact.bodyA.categoryBitMask == muffinCategory && contact.bodyB.categoryBitMask == enemyCategory)||
           (contact.bodyB.categoryBitMask == muffinCategory && contact.bodyA.categoryBitMask == enemyCategory))
        {
            if( [contact.bodyA.node isKindOfClass: [GEAMuffinMan class]]) {
                [(GEAMuffinMan*) contact.bodyA.node wasHitByMuffin: (GEAMuffinNode*) contact.bodyB.node];
            } else if ([contact.bodyB.node isKindOfClass: [GEAMuffinMan class]]) {
                [(GEAMuffinMan*) contact.bodyB.node wasHitByMuffin: (GEAMuffinNode*) contact.bodyA.node];
            }
        }
        
        if((contact.bodyA.categoryBitMask == muffinCategory && contact.bodyB.categoryBitMask == holeCategory)||
           (contact.bodyB.categoryBitMask == muffinCategory && contact.bodyA.categoryBitMask == holeCategory))
        {
            if ([contact.bodyA.node isKindOfClass: [GEAHoleNode class]]) {
                if([(GEAHoleNode *) contact.bodyA.node isHoleKillable]) {
                    [(GEAHoleNode *) contact.bodyA.node resetSpawnSequenceFromStart];
                }
            } else if ([contact.bodyB.node isKindOfClass: [GEAHoleNode class]]) {
                if([(GEAHoleNode *) contact.bodyB.node isHoleKillable]) {
                    [(GEAHoleNode *) contact.bodyB.node resetSpawnSequenceFromStart];
                }
            }
        }
        
        if( (contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == doorCategory) || (contact.bodyA.categoryBitMask == doorCategory && contact.bodyB.categoryBitMask == playerCategory)) {
            shouldGoToNextLevel = true;
        }
        
        if ( (contact.bodyA.categoryBitMask == enemyCategory && contact.bodyB.categoryBitMask == playerCategory) || (contact.bodyB.categoryBitMask == enemyCategory && contact.bodyA.categoryBitMask == playerCategory)) {
            shouldEndGame = true;
            
            if( [contact.bodyA.node isKindOfClass: [GEAMuffinMan class]]) {
                murderMan = (GEAMuffinMan*) contact.bodyA.node;
            } else {
                murderMan = (GEAMuffinMan*) contact.bodyB.node;
            }
            
        }
    }
    
}

@end
