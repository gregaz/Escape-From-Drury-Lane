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
    GEAButton *postToLeaderBoardButton;
    GEAButton *dontPostToLeaderBoardButton;
    GEAButton *musicOnButton;
    GEAButton *musicOffButton;
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
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed: @"AmericanTypewriter"];
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
    [self initPostScoreToGameCenterLeaderBoardButtons];
    [self initMusicSettingsButtons];
}

-(void) initMusicSettingsButtons {
    
    NSString* musicOnImageName;
    NSString* musicOffImageName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* musicSettingString = [defaults stringForKey:@"music"];
    
    if ([musicSettingString isEqualToString: @"true"]) {
        musicOnImageName = @"musicOnSelectedButton.png";
        musicOffImageName = @"musicOffButton.png";
    } else {
        musicOnImageName = @"musicOnButton.png";
        musicOffImageName = @"musicOffSelectedButton.png";
    }
    
    musicOnButton = [[GEAButton alloc] initWithButtonImageNamed: musicOnImageName];
    musicOnButton.position = CGPointMake(self.frame.size.width*0.4, self.frame.size.height*0.3);
    musicOnButton.name = @"musicOnButton";
    [self addChild:musicOnButton];
    
    musicOffButton = [[GEAButton alloc] initWithButtonImageNamed: musicOffImageName];
    musicOffButton.position = CGPointMake(self.frame.size.width*0.6, self.frame.size.height*0.3);
    musicOffButton.name = @"dontPostToLeaderBoardButton";
    [self addChild:musicOffButton];
}

-(void)initPostScoreToGameCenterLeaderBoardButtons {
    NSString* postToLeaderBoardImageName;
    NSString* dontPostToLeaderBoardImageName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* postToLeaderBoardString = [defaults stringForKey:@"postToLeaderBoard"];
    
    if ([postToLeaderBoardString isEqualToString: @"true"]) {
        postToLeaderBoardImageName = @"postToLeaderboardSelected.png";
        dontPostToLeaderBoardImageName = @"dontPostToLeaderboard.png";
    } else {
        postToLeaderBoardImageName = @"postToLeaderboard.png";
        dontPostToLeaderBoardImageName = @"dontPostToLeaderboardSelected.png";
    }
    
    postToLeaderBoardButton = [[GEAButton alloc] initWithButtonImageNamed: postToLeaderBoardImageName];
    postToLeaderBoardButton.position = CGPointMake(self.frame.size.width*0.3, self.frame.size.height*0.5);
    postToLeaderBoardButton.name = @"postToLeaderBoardButton";
    [self addChild:postToLeaderBoardButton];
    
    dontPostToLeaderBoardButton = [[GEAButton alloc] initWithButtonImageNamed: dontPostToLeaderBoardImageName];
    dontPostToLeaderBoardButton.position = CGPointMake(self.frame.size.width*0.7, self.frame.size.height*0.5);
    dontPostToLeaderBoardButton.name = @"dontPostToLeaderBoardButton";
    [self addChild:dontPostToLeaderBoardButton];
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
    
//    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed: @"AmericanTypewriter"];
//    titleLabel.position = CGPointMake(self.frame.size.width*0.2,self.frame.size.height*0.5);
//    titleLabel.fontSize = 30;
//    titleLabel.fontColor = [UIColor whiteColor];
//    titleLabel.text = @"Are you ";
//    [self addChild: titleLabel];
    
    leftHandButton = [[GEAButton alloc] initWithButtonImageNamed: leftButtonImageName];
    leftHandButton.position = CGPointMake(self.frame.size.width*0.35, self.frame.size.height*0.7);
    leftHandButton.name = @"leftHandedButton";
    [self addChild:leftHandButton];

    rightHandButton = [[GEAButton alloc] initWithButtonImageNamed: rightButtonImageName];
    rightHandButton.position = CGPointMake(self.frame.size.width*0.65, self.frame.size.height*0.7);
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

    if ([postToLeaderBoardButton shouldActionPress]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* shouldPostToLeaderBoard = [defaults stringForKey:@"postToLeaderBoard"];
        if([shouldPostToLeaderBoard isEqualToString:@"false"]) {
            [defaults setObject: @"true" forKey: @"postToLeaderBoard"];
            [defaults synchronize];
            [dontPostToLeaderBoardButton setTexture: [SKTexture textureWithImageNamed: @"dontPostToLeaderboard.png"]];
            [postToLeaderBoardButton setTexture: [SKTexture textureWithImageNamed: @"postToLeaderboardSelected.png"]];
        }
    }
    
    if ([dontPostToLeaderBoardButton shouldActionPress]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* shouldPostToLeaderBoard = [defaults stringForKey:@"postToLeaderBoard"];
        if([shouldPostToLeaderBoard isEqualToString:@"true"]) {
            [defaults setObject: @"false" forKey: @"postToLeaderBoard"];
            [defaults synchronize];
            [dontPostToLeaderBoardButton setTexture: [SKTexture textureWithImageNamed: @"dontPostToLeaderboardSelected.png"]];
            [postToLeaderBoardButton setTexture: [SKTexture textureWithImageNamed: @"postToLeaderboard.png"]];
        }
    }
    
    if ([musicOnButton shouldActionPress]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* shouldPlayMusic = [defaults stringForKey:@"music"];
        if([shouldPlayMusic isEqualToString:@"false"]) {
            [defaults setObject: @"true" forKey: @"music"];
            [defaults synchronize];
            [musicOffButton setTexture: [SKTexture textureWithImageNamed: @"musicOffButton.png"]];
            [musicOnButton setTexture: [SKTexture textureWithImageNamed: @"musicOnSelectedButton.png"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startTitleMusic" object:nil];
        }
    }
    
    if ([musicOffButton shouldActionPress]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* shouldPlayMusic = [defaults stringForKey:@"music"];
        if([shouldPlayMusic isEqualToString:@"true"]) {
            [defaults setObject: @"false" forKey: @"music"];
            [defaults synchronize];
            [musicOffButton setTexture: [SKTexture textureWithImageNamed: @"musicOffSelectedButton.png"]];
            [musicOnButton setTexture: [SKTexture textureWithImageNamed: @"musicOnButton.png"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTitleMusic" object:nil];
        }
    }
    
    [super update:currentTime];
}

@end
