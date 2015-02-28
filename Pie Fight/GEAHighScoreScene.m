//
//  GEAHighScoreScene.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/15/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAHighScoreScene.h"
#import "GEAButton.h"
#import "GEAStartMenuScene.h"

@implementation GEAHighScoreScene {
    bool wasBackPressed;
    GEAButton *backButton;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        [self initBackButton];
        [self initHighScoreTitleLabel];
        [self initHighScores];
    }
    return self;
}

-(void) initBackButton {
    
    backButton = [[GEAButton alloc] initWithButtonImageNamed: @"backButton.png"];
    backButton.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.1);
    backButton.name = @"backButton";
    [self addChild:backButton];
}

-(void)initHighScoreTitleLabel {
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    titleLabel.position = CGPointMake(self.frame.size.width*0.5,self.frame.size.height*0.8);
    titleLabel.fontSize = 50;
    titleLabel.fontColor = [UIColor whiteColor];
    titleLabel.text = @"High Scores";
    titleLabel.name = @"Title";
    [self addChild: titleLabel];
}

-(void) initHighScores {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray* highScores = [defaults arrayForKey:@"highScores"];
    int i = 0;
    
    for(NSDictionary* highScoreDict in highScores) {
        NSDate* scoreDate = [highScoreDict objectForKey: @"date"];
        NSString* scoreDateString = [NSDateFormatter localizedStringFromDate:scoreDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        NSNumber* highScore =[highScoreDict objectForKey: @"score"];
        
        SKLabelNode* highScoreLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
        highScoreLabel.fontSize = 25;
        highScoreLabel.fontColor = [UIColor whiteColor];
        highScoreLabel.text = [NSString stringWithFormat: @"%@: %i",scoreDateString, [highScore intValue]];
        
        double yPosition = 0.6 - (((double)(i % 5)) / 10.0);
        double xPosition = ((double)((int)(i/5)))/2.0 + 0.25;
        highScoreLabel.position = CGPointMake(self.frame.size.width*xPosition,self.frame.size.height*yPosition);
        
        [self addChild:highScoreLabel];
        i++;
    }
}


-(void)update:(CFTimeInterval)currentTime {
    if (!backButton.isPressed && wasBackPressed) {
        GEAStartMenuScene* startScene = [GEAStartMenuScene sceneWithSize:self.view.bounds.size];
        startScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene: startScene];
    }
    wasBackPressed = backButton.isPressed;
    
    
}

@end
