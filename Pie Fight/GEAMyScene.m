//
//  GEAMyScene.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 10/20/14.
//  Copyright (c) 2014 Gregory Azuolas. All rights reserved.
//
// TODO:
// Add muffins - implement throw muffin
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
#include <stdlib.h>

static const uint32_t playerCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;
static const int incAmount = 20;
static const int controlsHeight = 45;
static const int speedModifier = 2;


@implementation GEAMyScene{
    GEAGingerBreadMan *player;
    SKSpriteNode *door;
    int levelNumber;
    int score;
    NSMutableArray *holes;
    NSMutableArray *muffinStacks;
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
        [self addScoreBoard];
        [self addControls];
        [self initializePlayer];
        [self initializeDoor];
        [self nextLevel];
        //[self addDebugLabels];
        
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
    
    //Adding SpriteKit physicsBody for collision detection
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.dynamic = YES;
    player.physicsBody.contactTestBitMask = obstacleCategory;
    player.physicsBody.collisionBitMask = 0;
    player.name = @"player";
    [self resetPlayer];
    
    [self addChild:player];
    
}

-(void)resetPlayer {
    player.position = CGPointMake(self.frame.size.width * 0.9, [self generateRandomYValueForPosition]);
}

-(void)spawnMuffinStacks {
    
    int numberOfMuffinStacks = 5;
    for (int i = 0; i < numberOfMuffinStacks; i++)
    {
        [self addMuffinStack];
    }
    
}

-(void)clearMuffinStacks {
    for (SKSpriteNode *muffinStack in muffinStacks) {
        [muffinStack removeFromParent];
    }
    [muffinStacks removeAllObjects];
}

-(void)addMuffinStack {
    SKSpriteNode *muffinStack = [SKSpriteNode spriteNodeWithImageNamed:@"muffin.png"];
    do {
        muffinStack.position = CGPointMake([self generateRandomXValueForPosition], [self generateRandomYValueForPosition]);
    } while ( [self anyHolesOrMuffinStacksLieOnSprite: muffinStack] );
    [muffinStack setScale: 0.05];
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
    for (SKSpriteNode *hole in holes) {
        [hole removeFromParent];
    }
    [holes removeAllObjects];
}

-(void)initializeDoor {
    door = [SKSpriteNode spriteNodeWithImageNamed: @"door.png"];
    [self resetDoorPosition];
    [door setScale: 0.1];
    [self addChild: door];
}

-(void)resetDoorPosition {
    door.position = CGPointMake(self.frame.size.width * 0.05, [self generateRandomYValueForPosition]);
}

-(void)addHole {
    SKSpriteNode *hole = [SKSpriteNode spriteNodeWithImageNamed:@"openhole.png"];
    
    do {
        hole.position = CGPointMake([self generateRandomXValueForPosition], [self generateRandomYValueForPosition]);
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

-(int)generateRandomXValueForPosition {
    int xInc = self.frame.size.width / incAmount;
    return (int) ((arc4random_uniform((int) (xInc * 0.7)) + xInc*0.15 ) * incAmount);
}

-(int)generateRandomYValueForPosition {
    int yInc = (self.frame.size.height - controlsHeight) / incAmount;
    return (int) ((arc4random_uniform(((int)yInc * 0.8)) + yInc*0.1 ) * incAmount) + controlsHeight;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //SKLabelNode *label = (SKLabelNode *)[self childNodeWithName:@"joystickLabel"];
    
    
    float newPlayerX = (float) player.position.x + joystick.x*speedModifier;
    float newPlayerY = (float) player.position.y + joystick.y*speedModifier;
    
    if((newPlayerX > self.frame.size.width) || (newPlayerX < 0)) {
        newPlayerX = player.position.x;
    }
    if((newPlayerY > self.frame.size.height) || (newPlayerY < 0)) {
        newPlayerY = player.position.y;
    }
    //label.text = [NSString stringWithFormat: @"X: %d, oX: %f J: %f", newPlayerX, player.position.x, joystick.x*speedModifier];
    player.position = CGPointMake( newPlayerX, newPlayerY);
    
    if(throwButton.isPressed) {
        [player throwMuffinWithDirectionVectorX: joystick.x andY: joystick.y];
    }
    
    
}

@end
