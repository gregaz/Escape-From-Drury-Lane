//
//  GEAMyScene.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 10/20/14.
//  Copyright (c) 2014 Gregory Azuolas. All rights reserved.
//
// TODO:
// Add muffins - implement throw muffin - done
// Add enemies
// Add animations - player, enemies, door, holes
// Add collisions - door, enemies, muffins
// Start screen
// Death screen
// Add background/controls border
// Ads between screens
// Level progression screen
// Improve drawings - dany?
// Instant replay/closing door?
// Settings R/L handed


#import "GEAMyScene.h"
#import "GEAJoyStick.h"
#import "GEAButton.h"
#import "GEAGingerBreadMan.h"
#import "GEARandomizablePositionNode.h"
#import "GEAHoleNode.h"
#import "GEAMuffinStackNode.h"
#import "GEADoorNode.h"
#include <stdlib.h>

static const uint32_t playerCategory =  0x1 << 0;
static const uint32_t holeCategory =  0x1 << 1;
static const uint32_t muffinCategory =  0x1 << 2;
static const uint32_t muffinStackCategory =  0x1 << 3;
static const uint32_t enemyCategory =  0x1 << 4;
static const uint32_t doorCategory =  0x1 << 5;
static const int incAmount = 20;
static const int controlsHeight = 45;
static const int speedModifier = 2;


@implementation GEAMyScene{
    GEAGingerBreadMan *player;
    GEADoorNode *door;
    int levelNumber;
    int score;
    bool didFlipHolesOnce;
    bool wasThrowPressed;
    NSMutableArray *holes;
    NSMutableArray *muffinStacks;
    NSMutableArray *muffinMen;
    GEAJoyStick *joystick;
    GEAButton *throwButton;
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
        wasThrowPressed = false;
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
    [self resetPlayer];
    [self spawnHoles];
    [self spawnMuffinStacks];
    [self resetDoorPosition];
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
    joystick = [[GEAJoyStick alloc] initWithJoystickImage: @"centerJoystick.png" baseImage: @"baseCenter.png"];
    [joystick setPosition:CGPointMake(self.frame.size.width*0.2,self.frame.size.height*0.1)];
    [self addChild: joystick];
    
    throwButton = [[GEAButton alloc] initWithButtonImageNamed:@"throwButton.png"];
    [throwButton setName: @"throwButton"];
    [throwButton setScale: .6];
    [throwButton setPosition: CGPointMake(self.frame.size.width*0.8,self.frame.size.height*0.1)];
    [self addChild:throwButton];
}

-(void)initializePlayer {
    player = [[GEAGingerBreadMan alloc] initGingerManWithoutMuffinWithImageNamed: @"gingerBreadMan.png"];
    [player setScale:0.1];
    
    //Adding SpriteKit physicsBody for collision detection TODO put this in gingerbreadman class
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.dynamic = YES;
    player.physicsBody.contactTestBitMask = muffinStackCategory;
    player.physicsBody.collisionBitMask = 0;
    player.name = @"player";
    [self resetPlayer];
    
    [self addChild:player];
    
}

-(void)resetPlayer {
    player.position = CGPointMake(self.frame.size.width * 0.9, 0.0);
    [player randomizeYPositionForIncrements:incAmount andControlsHeight:controlsHeight andSceneHeight: self.frame.size.height];
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
        [muffinStack removeFromParent];
    }
    [muffinStacks removeAllObjects];
}

-(void)addMuffinStack {
    GEAMuffinStackNode *muffinStack = [[GEAMuffinStackNode alloc] initWithRandomNumberOfMuffins];
    
    //TODO put this in muffinstack class
    muffinStack.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:muffinStack.size];
    muffinStack.physicsBody.categoryBitMask = muffinStackCategory;
    muffinStack.physicsBody.contactTestBitMask = playerCategory;
    muffinStack.physicsBody.dynamic = YES;
    muffinStack.physicsBody.collisionBitMask = 0;
    
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
        [hole removeFromParent];
    }
    [holes removeAllObjects];
}

-(void)initializeDoor {
    door = [GEADoorNode spriteNodeWithImageNamed: @"door.png"];
    [self resetDoorPosition];
    [door setScale: 0.1];
    [self addChild: door];
}

-(void)resetDoorPosition {
    door.position = CGPointMake(self.frame.size.width * 0.05, 0.0);
    [door randomizeYPositionForIncrements:incAmount andControlsHeight:controlsHeight andSceneHeight:self.frame.size.height];
}

-(void)addHole {
    GEAHoleNode *hole = [[GEAHoleNode alloc] initWithRandomState];
    
    do {
        [hole randomizePositionForIncrements: incAmount andControlsHeight:controlsHeight andSceneHeight:self.frame.size.height andSceneWidth:self.frame.size.width];
    } while ( [self anyHolesOrMuffinStacksLieOnSprite: hole] );
    
    [hole setScale: 0.1];
    [self addChild: hole];
    [holes addObject: hole];
}

-(bool)anyHolesOrMuffinStacksLieOnSprite:(SKSpriteNode *)aPotentialSprite {
    NSMutableArray *holesAndMuffins;
    [holesAndMuffins addObjectsFromArray: holes ];
    [holesAndMuffins addObjectsFromArray: muffinStacks];
    
    for (SKSpriteNode *existingHoleOrMuffin in holesAndMuffins) {
        if ( CGPointEqualToPoint(existingHoleOrMuffin.position, aPotentialSprite.position )) {
            return true;
        }
    }
    return false;
}

-(int)generateRandomYValueForPosition {
    int yInc = (self.frame.size.height - controlsHeight) / incAmount;
    return (int) ((arc4random_uniform(((int)yInc * 0.8)) + yInc*0.1 ) * incAmount) + controlsHeight;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
   // SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"joystickLabel"];
    
    if(((int)currentTime % 10) == 1 && !didFlipHolesOnce) {
        for (GEAHoleNode *hole in holes) {
            [hole flipFlopHole];
            didFlipHolesOnce = true;
        }
    }
    if(((int)currentTime % 10) == 2){
        didFlipHolesOnce = false;
    }
    
    float newPlayerX = (float) player.position.x + joystick.x*speedModifier;
    float newPlayerY = (float) player.position.y + joystick.y*speedModifier;
    
    if((newPlayerX > self.frame.size.width) || (newPlayerX < 0)) {
        newPlayerX = player.position.x;
    }
    if((newPlayerY > self.frame.size.height) || (newPlayerY < 0)) {
        newPlayerY = player.position.y;
    }
   // label.text = [NSString stringWithFormat: @"X: %i, X: %i J: %f", (int)currentTime, ((int)currentTime) % 10, joystick.x*speedModifier];
    player.position = CGPointMake( newPlayerX, newPlayerY);
    
    if (!throwButton.isPressed && wasThrowPressed) {
        //To do once i can test on phone
        //[player throwMuffinWithDirectionVectorX: joystick.x andY: joystick.y];
        [player throwMuffinWithDirectionVectorX: -0.2 andY: 0.3];
    }
    wasThrowPressed = throwButton.isPressed;
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if( contact.bodyA.categoryBitMask == playerCategory && contact.bodyB.categoryBitMask == muffinStackCategory) {
        [(GEAGingerBreadMan*) contact.bodyA.node pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) contact.bodyB.node ];
    }
    
    if(contact.bodyB.categoryBitMask == playerCategory && contact.bodyA.categoryBitMask == muffinStackCategory) {
        [(GEAGingerBreadMan*) contact.bodyB.node pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) contact.bodyA.node ];

    }
    
}

@end
