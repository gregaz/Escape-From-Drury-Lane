//
//  GEAStartMenuScene.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/15/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAStartMenuScene.h"
#import "GEAButton.h"
#import "GEAGameScene.h"
#import "GEAHighScoreScene.h"
#import "GEASettingsScene.h"

@implementation GEAStartMenuScene {
    GEAButton *startButton;
    GEAButton *settingsButton;
    GEAButton *highScoresButton;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        [self initUserDefaults];
        [self initMenuButtons];
        [self initMenuLabels];
        [self initGingerBreadMan];
    }
    return self;
}

-(void) initGingerBreadMan {
    SKTextureAtlas *gingerBreadManAtlas = [SKTextureAtlas atlasNamed: @"gingerBreadMen"];
    NSMutableArray *gingerBreadManRunArray = [NSMutableArray array];

    for(int i = 10; i <= 16; i++) {
        NSString* fileName = [NSString stringWithFormat: @"frame%i", i];
        SKTexture *temp = [gingerBreadManAtlas textureNamed:fileName];
        [gingerBreadManRunArray addObject:temp];
    }
    
    SKSpriteNode* gingerBreadMan = [SKSpriteNode spriteNodeWithTexture: gingerBreadManRunArray[0]];
    gingerBreadMan.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    [gingerBreadMan setScale: 0.2];
    [self addChild:gingerBreadMan];
    
    [gingerBreadMan runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:gingerBreadManRunArray
                                       timePerFrame:0.1f
                                             resize:YES
                                            restore:YES]] withKey:@"gingerBreadManRunning"];
}

-(void) initUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults stringForKey:@"handedness"] == nil) {
        [defaults setObject: @"right" forKey: @"handedness"];
        [defaults synchronize];
    }
}

-(void)initMenuButtons {
    [self initStartButton];
    [self initSettingsButton];
    [self highScoresButton];
}

-(void)initStartButton {
    startButton = [[GEAButton alloc] initWithButtonImageNamed: @"startButton.png"];
    startButton.position = CGPointMake(self.frame.size.width*0.2, self.frame.size.height*0.2);
    startButton.name = @"startButton";
    [self addChild:startButton];
    
}

-(void)initSettingsButton {
    settingsButton = [[GEAButton alloc] initWithButtonImageNamed: @"settingsButton.png"];
    settingsButton.position = CGPointMake(self.frame.size.width*0.8, self.frame.size.height*0.2);
    settingsButton.name = @"settingsButton";
    [self addChild:settingsButton];
}

-(void)highScoresButton {
    highScoresButton = [[GEAButton alloc] initWithButtonImageNamed: @"highScoresButton.png"];
    highScoresButton.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.2);
    highScoresButton.name = @"highScoresButton";
    [self addChild:highScoresButton];
}

-(void) initMenuLabels {
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    titleLabel.position = CGPointMake(self.frame.size.width*0.5,self.frame.size.height*0.85);
    titleLabel.fontSize = 50;
    titleLabel.fontColor = [UIColor whiteColor];
    titleLabel.text = @"Escape from Drury Lane";
    titleLabel.name = @"Title";
    [self addChild: titleLabel];
}

-(void)update:(CFTimeInterval)currentTime {
    if ( [startButton shouldActionPress]) {
        GEAGameScene* gameScene = [GEAGameScene sceneWithSize:self.view.bounds.size];
        gameScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene: gameScene];
    }
    
    if ([settingsButton shouldActionPress]) {
        GEASettingsScene* settingsScene = [GEASettingsScene sceneWithSize:self.view.bounds.size];
        settingsScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene: settingsScene];
    }
    
    if ([highScoresButton shouldActionPress]) {
        GEAHighScoreScene* highScoreScene = [GEAHighScoreScene sceneWithSize:self.view.bounds.size];
        highScoreScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene: highScoreScene];
    }
    
    [super update:currentTime];
    

}

@end
