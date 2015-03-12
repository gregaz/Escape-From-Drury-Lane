//
//  GEAViewController.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 10/20/14.
//  Copyright (c) 2014 Gregory Azuolas. All rights reserved.
//

#import "GEAViewController.h"
#import "GEAGameScene.h"
#import "GEAStartMenuScene.h"

@implementation GEAViewController

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
       // skView.showsPhysics = YES;
        
        // Create and configure the scene.
        SKScene * scene = [GEAStartMenuScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
