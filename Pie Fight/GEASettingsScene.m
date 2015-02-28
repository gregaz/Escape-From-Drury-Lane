//
//  GEASettingsScene.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/15/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEASettingsScene.h" 
#import "GEAButton.h"
#import "GEAStartMenuScene.h"

@implementation GEASettingsScene {
    GEAButton *backButton;
    GEAButton *leftHandButton;
    GEAButton *rightHandButton;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        [self initLabel];
        [self initButtons];
    }
    return self;
}

-(void) initLabel {
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    titleLabel.position = CGPointMake(self.frame.size.width*0.5,self.frame.size.height*0.8);
    titleLabel.fontSize = 50;
    titleLabel.fontColor = [UIColor whiteColor];
    titleLabel.text = @"Settings";
    titleLabel.name = @"Title";
    [self addChild: titleLabel];
}

-(void) initButtons {
    [self initBackButton];
    [self initHandedSettingsButtons];
}

//can refactor with high score scene and game scene
-(void) initBackButton {
        
    backButton = [[GEAButton alloc] initWithButtonImageNamed: @"backButton.png"];
    backButton.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.1);
    backButton.name = @"backButton";
    [self addChild:backButton];
}

-(void) initHandedSettingsButtons {
    NSString* rightButtonImageName;
    NSString* leftButtonImageName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* handedness = [defaults stringForKey:@"handedness"];
    
    if ([handedness isEqualToString: @"right"]) {
        rightButtonImageName = @"rightHandedSelectedButton.png";
        leftButtonImageName = @"leftHandedButton.png";
    } else {
        rightButtonImageName = @"rightHandedButton.png";
        leftButtonImageName = @"leftHandedSelectedButton.png";
    }
    
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    titleLabel.position = CGPointMake(self.frame.size.width*0.2,self.frame.size.height*0.5);
    titleLabel.fontSize = 30;
    titleLabel.fontColor = [UIColor whiteColor];
    titleLabel.text = @"Are you ";
    [self addChild: titleLabel];
    
    leftHandButton = [[GEAButton alloc] initWithButtonImageNamed: leftButtonImageName];
    leftHandButton.position = CGPointMake(self.frame.size.width*0.4, self.frame.size.height*0.5);
    leftHandButton.name = @"leftHandedButton";
    [self addChild:leftHandButton];

    rightHandButton = [[GEAButton alloc] initWithButtonImageNamed: rightButtonImageName];
    rightHandButton.position = CGPointMake(self.frame.size.width*0.6, self.frame.size.height*0.5);
    rightHandButton.name = @"rightHandedButton";
    [self addChild:rightHandButton];

}

-(void)update:(CFTimeInterval)currentTime {
    if ([backButton shouldActionPress]) {
        GEAStartMenuScene* startScene = [GEAStartMenuScene sceneWithSize:self.view.bounds.size];
        startScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene: startScene];
    }

    if ([rightHandButton shouldActionPress]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* handedness = [defaults stringForKey:@"handedness"];
        if([handedness isEqualToString:@"left"]) {
            [defaults setObject: @"right" forKey: @"handedness"];
            [defaults synchronize];
            [leftHandButton setTexture: [SKTexture textureWithImageNamed: @"leftHandedButton.png"]];
            [rightHandButton setTexture: [SKTexture textureWithImageNamed: @"rightHandedSelectedButton.png"]];
        }
    }
    
    if ([leftHandButton shouldActionPress]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* handedness = [defaults stringForKey:@"handedness"];
        if([handedness isEqualToString:@"right"]) {
            [defaults setObject: @"left" forKey: @"handedness"];
            [defaults synchronize];
            [leftHandButton setTexture: [SKTexture textureWithImageNamed: @"leftHandedSelectedButton.png"]];
            [rightHandButton setTexture: [SKTexture textureWithImageNamed: @"rightHandedButton.png"]];
        }
    }
    
    [super update:currentTime];
}

@end
