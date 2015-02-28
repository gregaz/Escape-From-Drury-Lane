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
    bool wasStartPressed;
    bool wasSettingsPressed;
    bool wasHighScoresPressed;
    GEAButton *startButton;
    GEAButton *settingsButton;
    GEAButton *highScoresButton;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        wasStartPressed = false;
        wasSettingsPressed = false;
        wasHighScoresPressed = false;
        [self initMenuButtons];
        [self initMenuLabels];
    }
    return self;
}

-(void)initMenuButtons {
    [self initStartButton];
    [self initSettingsButton];
    [self highScoresButton];
}

-(void)initStartButton {
    startButton = [[GEAButton alloc] initWithButtonImageNamed: @"startButton.png"];
    startButton.position = CGPointMake(self.frame.size.width*0.2, self.frame.size.height*0.4);
    startButton.name = @"startButton";
    [self addChild:startButton];
    
}

-(void)initSettingsButton {
    settingsButton = [[GEAButton alloc] initWithButtonImageNamed: @"settingsButton.png"];
    settingsButton.position = CGPointMake(self.frame.size.width*0.8, self.frame.size.height*0.4);
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
    titleLabel.position = CGPointMake(self.frame.size.width*0.5,self.frame.size.height*0.75);
    titleLabel.fontSize = 50;
    titleLabel.fontColor = [UIColor whiteColor];
    titleLabel.text = @"Escape from Drury Lane";
    titleLabel.name = @"Title";
    [self addChild: titleLabel];
}

-(void)update:(CFTimeInterval)currentTime {
    if (!startButton.isPressed && wasStartPressed) {
        GEAGameScene* gameScene = [GEAGameScene sceneWithSize:self.view.bounds.size];
        gameScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene: gameScene];
    }
    wasStartPressed = startButton.isPressed;
    
    
    if (!settingsButton.isPressed && wasSettingsPressed) {
        //todo
    }
    wasSettingsPressed = settingsButton.isPressed;
    
    
    if (!highScoresButton.isPressed && wasHighScoresPressed) {
        GEAHighScoreScene* highScoreScene = [GEAHighScoreScene sceneWithSize:self.view.bounds.size];
        highScoreScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene: highScoreScene];
    }
    wasHighScoresPressed = highScoresButton.isPressed;
    

}

@end
