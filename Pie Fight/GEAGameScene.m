//
//  GEAGameScene.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 10/20/14.
//  Copyright (c) 2014 Gregory Azuolas. All rights reserved.
//
// TODO:
// Fix hole/muffinstack placement bug
// Add background/controls border
// Improve Enemy AI
// Ads between screens
// Level progression screen
// Story Screen
// Enemy Animations - spawn, death
// Sounds/Music
// Medals for score thresholds (unlockable characters?)

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

static const int incAmount = 30;
static const int controlsHeight = 45;
static const int speedModifier = 2;

@implementation GEAGameScene{
    GEAGingerBreadMan *player;
    GEADoorNode *door;
    int levelNumber;
    int score;
    bool didFlipHolesOnce;
    bool didUpdateTrajectories;
    bool shouldGoToNextLevel;
    bool shouldEndGame;
    bool hasGameEnded;
    NSMutableArray *holes;
    NSMutableArray *muffinStacks;
    NSMutableArray *muffinMen;
    GEAJoyStick *joystick;
    GEAButton *throwButton;
    GEAButton *retryButton;
    GEAButton *nextLevelButton;
    SKPhysicsBody *muffinManPhysicsBody;
    NSMutableArray *muffinManAnimationArray;
    SKTextureAtlas *muffinManTextureAtlas;
    GEAMuffinMan *murderMan;
    SKTextureAtlas *holeSpawnAtlas;
    
    NSMutableArray *holeOpeningArray;
    NSMutableArray *holeClosingArray;
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
        didUpdateTrajectories = false;
        shouldGoToNextLevel = false;
        shouldEndGame = false;
        hasGameEnded = false;
        [self initAnimationAtlasAndArrays];
        [self initMuffinManPhysicsBody];
        [self addScoreBoard];
        [self addControls];
        [self initializePlayer];
        [self initializeDoor];
        [self nextLevel];
       // [self addDebugLabels];
        
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
    [self spawnMuffinMen];
    [self spawnMuffinStacks];
    [self resetDoorPosition];
}

-(void)endGame {
    for (SKSpriteNode* child in [self children]) {
        [child removeAllActions];
    }
    
    [player removeFromParent];
    [murderMan animateEatGingerBreadMan];
    
    hasGameEnded = true;
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed: @"AmericanTypewriter"];
    gameOverLabel.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.75);
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontColor = [UIColor whiteColor];
    gameOverLabel.fontSize = 50;
    
    [self addChild: gameOverLabel];

    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"AmericanTypewriter"];
    scoreLabel.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    scoreLabel.text = [NSString stringWithFormat: @"Final Score: %i", score];
    scoreLabel.fontColor = [UIColor whiteColor];
    scoreLabel.fontSize = 50;
    
    [self addChild:scoreLabel];
    
    retryButton = [[GEAButton alloc] initWithButtonImageNamed: @"retryButton.png"];
    retryButton.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.25);
    
    [self addChild: retryButton];
    
    [[self childNodeWithName: @"scoreLabel"] removeFromParent];
    
    NSDictionary* highScoreEntry = [[NSDictionary alloc]
                                    initWithObjects: [NSArray arrayWithObjects: [NSNumber numberWithInt:score], [NSDate date], nil]
                                    forKeys: [NSArray arrayWithObjects: @"score", @"date", nil]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray* highScores = [NSMutableArray arrayWithArray: [defaults arrayForKey:@"highScores"]];
    [highScores addObject: highScoreEntry];
    NSSortDescriptor* scoreSorter = [[NSSortDescriptor alloc] initWithKey: @"score" ascending:false];
    NSArray* sortedHighScores = [highScores sortedArrayUsingDescriptors:[NSArray arrayWithObject:scoreSorter]];
    

    sortedHighScores = [sortedHighScores subarrayWithRange: NSMakeRange(0, MIN(10, sortedHighScores.count))];
    [defaults setObject:sortedHighScores forKey:@"highScores"];
    [defaults synchronize];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
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
    float throwButtonX;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* handedness = [defaults stringForKey:@"handedness"];
    
    if([handedness isEqualToString: @"right" ]) {
        joystickX = 0.8;
        throwButtonX = 0.2;
    } else {
        joystickX = 0.2;
        throwButtonX = 0.8;
    }
    
    joystick = [[GEAJoyStick alloc] initWithJoystickImage: @"centerJoystick.png" baseImage: @"baseCenter.png"];
    [joystick setPosition:CGPointMake(self.frame.size.width*joystickX,self.frame.size.height*0.1)];
    [self addChild: joystick];
    
    throwButton = [[GEAButton alloc] initWithButtonImageNamed:@"throwButton.png"];
    [throwButton setName: @"throwButton"];
    [throwButton setScale: .6];
    [throwButton setPosition: CGPointMake(self.frame.size.width*throwButtonX,self.frame.size.height*0.1)];
    [self addChild:throwButton];
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

-(void)spawnMuffinMen {
    for (GEAHoleNode *hole in holes) {
        if([hole isHoleOpen]) {
            [self spawnMuffinManFromHole: hole];
        }
    }
}

-(void)initMuffinManPhysicsBody {
    SKTexture* tempTexture = [SKTexture textureWithImageNamed: @"muffinMan1"];
    muffinManPhysicsBody = [SKPhysicsBody bodyWithTexture:tempTexture size:tempTexture.size];
}

-(void)initAnimationAtlasAndArrays {
    holeSpawnAtlas = [SKTextureAtlas atlasNamed: @"holeOpening"];
    holeOpeningArray = [NSMutableArray array];
    holeClosingArray = [NSMutableArray array];
    muffinManAnimationArray = [NSMutableArray array];
    muffinManTextureAtlas = [SKTextureAtlas atlasNamed: @"muffinMen"];
    
    for(int i = 1; i <= 9; i++) {
        NSString* fileName = [NSString stringWithFormat: @"hole%i", i];
        SKTexture *temp = [holeSpawnAtlas textureNamed:fileName];
        [holeOpeningArray addObject:temp];
    }
    
    for(int i = 19; i <= 21; i++) {
        NSString* fileName = [NSString stringWithFormat: @"hole%i", i];
        SKTexture *temp = [holeSpawnAtlas textureNamed:fileName];
        [holeClosingArray addObject:temp];
    }
    
    for(int i = 1; i <= muffinManTextureAtlas.textureNames.count; i++) {
        NSString* fileName = [NSString stringWithFormat: @"muffinMan%i", i];
        SKTexture *temp = [muffinManTextureAtlas textureNamed:fileName];
        [muffinManAnimationArray addObject:temp];
    }
    
}

-(void)spawnMuffinManFromHole: (GEAHoleNode*) aHole {
    GEAMuffinMan* muffinMan = [[GEAMuffinMan alloc] initMuffinManWithPhysicsBody: [muffinManPhysicsBody copy] andAnimationArray: muffinManAnimationArray];
    [muffinMan setPosition: aHole.position];
    [muffinMan setScale: 0.3];
    [self addChild:muffinMan];
    [muffinMen addObject: muffinMan];
    
}

-(void)spawnMuffinManWithAnimationFromHole: (GEAHoleNode *) aHole {
    GEAMuffinMan* muffinMan = [[GEAMuffinMan alloc] initMuffinManWithPhysicsBody: [muffinManPhysicsBody copy] andAnimationArray: muffinManAnimationArray];
    [muffinMan setPosition: aHole.position];
    [muffinMan setAnchorPoint: CGPointMake(0.5, 0.0)];
    [muffinMan setXScale: 0.3];
    [muffinMan setYScale:0.01];
    [muffinMan runAction:[SKAction scaleYTo:0.3 duration:1]];
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
    
    //Test on phone and improve FPS?
    GEAHoleNode *hole = [[GEAHoleNode alloc] init];
    [hole initializeCollisionConfig];
    do {
        [hole randomizePositionForIncrements: incAmount andControlsHeight:controlsHeight andSceneHeight:self.frame.size.height andSceneWidth:self.frame.size.width];
    } while ( [self anyHolesOrMuffinStacksLieOnSprite: hole] );
    

    [self addChild: hole];
    [holes addObject: hole];
    
    [hole setTexture: (SKTexture *) holeOpeningArray[0]];
    [hole setSize: [(SKTexture*) holeOpeningArray[0] size]];
    [hole setScale: 0.6];
    
    int randomWaitTime = arc4random_uniform(7)+1;
    if(randomWaitTime > 4.5) {
        [self spawnMuffinManFromHole:hole];
    }
    SKAction *waitTimeBetweenSpawns = [SKAction waitForDuration: (NSTimeInterval) randomWaitTime];
    SKAction *holeOpening = [SKAction animateWithTextures: holeOpeningArray
                                             timePerFrame:0.1f
                                                   resize:YES
                                                  restore:NO];
    SKAction *waitForMuffinManToEmerge = [SKAction waitForDuration: (NSTimeInterval) 1];
    
    SKAction *holeClosing = [SKAction animateWithTextures: holeClosingArray
                                            timePerFrame:0.1f
                                                  resize:YES
                                                 restore:NO];
    SKAction *spawnMuffinManAction = [SKAction runBlock: ^{[self spawnMuffinManWithAnimationFromHole: hole ];}];
    

    
    [hole runAction: [SKAction repeatActionForever: [SKAction sequence: @[waitTimeBetweenSpawns, holeOpening, waitForMuffinManToEmerge, holeClosing, spawnMuffinManAction]]]];
    
}

-(bool)anyHolesOrMuffinStacksLieOnSprite:(SKSpriteNode *)aPotentialSprite {
    NSMutableArray *holesAndMuffins;
    [holesAndMuffins addObjectsFromArray: holes ];
    [holesAndMuffins addObjectsFromArray: muffinStacks];
    
    for (SKSpriteNode *existingHoleOrMuffin in holesAndMuffins) {
        if ( [existingHoleOrMuffin containsPoint: aPotentialSprite.position]) {
            return true;
        }
    }
    return false;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
   // SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"joystickLabel"];
    if (hasGameEnded) {
        if ([retryButton shouldActionPress]) {
            GEAStartMenuScene *startScene = [GEAStartMenuScene sceneWithSize:self.view.bounds.size];
            startScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene: startScene];
        }
    } else {
        if (shouldEndGame) {
            [self endGame];
        } else {
            if(shouldGoToNextLevel) {
                //this doesnt seem to work in didBeginContact: bad timing mayhaps?
                if( ![player isHidden] ){
                    [door animateDoorWalkThrough];
                    player.hidden = true;
                    for (GEAMuffinMan *muffinMan in muffinMen) {
                        [muffinMan removeAllActions];
                    }
                    
                }
                if( ![door hasActions]) {
                    if (nextLevelButton == nil) {
                        nextLevelButton = [[GEAButton alloc] initWithButtonImageNamed: @"nextLevelButton.png"];
                        [nextLevelButton setPosition: CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5)];
                        [nextLevelButton setZPosition: 10.0];
                        [self addChild:nextLevelButton];

                    } else if ([nextLevelButton isHidden]) {
                        [nextLevelButton setHidden:false];
                        [nextLevelButton setZPosition: 10.0];
                    }
                    
                    if ([nextLevelButton shouldActionPress]) {
                        [nextLevelButton setHidden:true];
                        shouldGoToNextLevel = false;
                        [self nextLevel];
                    }
                    
                }

            } else {
                
                if(((int)currentTime % 2) == 1 && !didUpdateTrajectories) {
                    for (GEAMuffinMan *muffinMan in muffinMen) {
                        if([muffinMan yScale] > 0.29) {
                        [muffinMan moveTowardsLocation:player.position];
                        }
                    }
                    didUpdateTrajectories = true;
                }
                if(((int)currentTime % 2) == 0){
                    didUpdateTrajectories = false;
                }
                
                [player moveUsingVectorWithX:joystick.x andY:joystick.y];
                
                if ([throwButton shouldActionPress]) {
                    [player throwMuffinWithDirectionVectorX: joystick.x andY: joystick.y];
                    //[player throwMuffinWithDirectionVectorX: 0.0 andY: 0.3];
                }
            }
        }
    }
    [super update:currentTime];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if( contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == muffinStackCategory) {
        [(GEAGingerBreadMan*) contact.bodyA.node pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) contact.bodyB.node ];
    }
    
    if(contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == muffinStackCategory) {
        [(GEAGingerBreadMan*) contact.bodyB.node pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) contact.bodyA.node ];

    }
    
    if((contact.bodyA.categoryBitMask == muffinCategory && contact.bodyB.categoryBitMask == enemyCategory)||
       (contact.bodyB.categoryBitMask == muffinCategory && contact.bodyA.categoryBitMask == enemyCategory))
    {
        //add enemy kill animation here
        [contact.bodyA.node removeFromParent];
        [contact.bodyB.node removeFromParent];
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

@end
