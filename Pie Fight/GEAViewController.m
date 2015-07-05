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
#import "Appirater.h"
@import AVFoundation;

@implementation GEAViewController {
    //ADBannerView *theBanner;
    bool iadsBannerIsVisible;
    AVAudioPlayer * backgroundMusicPlayer;

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
   //[self showThinBanner];
    //[self requestInterstitialAdPresentation];
    //SKView * skView = (SKView *)self.view;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestInterstitialAdPresentation) name:@"showAd" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createPost:)
                                                 name:@"CreatePost"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticateLocalPlayerAndSendScore:)
                                                 name:@"authenticateLocalPlayerAndSendScore"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticateLocalPlayer)
                                                 name:@"authenticateLocalPlayer"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showGameCenter)
                                                 name:@"showGameCenter"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startBackgroundMusic)
                                                 name:@"startTitleMusic"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopBackgroundMusic)
                                                 name:@"stopTitleMusic"
                                               object:nil];
    
    SKView * skView = (SKView *)self.originalContentView;
    
    if (!skView.scene) {
        //skView.showsFPS = YES;
        //skView.showsNodeCount = YES;
        //skView.showsPhysics = YES;
        
        // Create and configure the scene.
        //SKScene *scene = [[GEAStartMenuScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        SKScene * scene = [GEAStartMenuScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
    
    [Appirater setAppId:@"970874247"];    // Change for your "Your APP ID"
    [Appirater setDaysUntilPrompt:5];     // Days from first entered the app until prompt
    [Appirater setUsesUntilPrompt:5];     // Number of uses until prompt
    [Appirater setTimeBeforeReminding:5];
    
    [Appirater appLaunched:true];
    
}

- (void)startBackgroundMusic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* shouldPlayMusic = [defaults stringForKey:@"music"];
    if([shouldPlayMusic isEqualToString:@"true"]) {
        if (backgroundMusicPlayer == nil || !([backgroundMusicPlayer isPlaying]) ){
            NSError *error;
            NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"titleMusic" withExtension:@"caf"];
            backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
            backgroundMusicPlayer.numberOfLoops = -1;
            [backgroundMusicPlayer prepareToPlay];
            [backgroundMusicPlayer play];
        }}
    
}

-(void)stopBackgroundMusic {
    if(backgroundMusicPlayer != nil) {
        [backgroundMusicPlayer stop];
    }
}

-(void)createPost:(NSNotification *)notification
{
    NSDictionary *postData = [notification userInfo];
    NSString *postText = (NSString *)[postData objectForKey:@"postText"];
    
    SLComposeViewController *mySLComposerSheet;
    
    if(  [(NSString *)[postData objectForKey: @"service"]  isEqual: @"facebook"]) {
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    } else if ( [(NSString *)[postData objectForKey: @"service"]  isEqual: @"twitter"] ) {
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    }
    [mySLComposerSheet setInitialText: postText];
    [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    
}

- (void)showGameCenter
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) authenticateLocalPlayerAndSendScore: (NSNotification *) notification
{
    GKLocalPlayer *localPlayer = [self authenticateLocalPlayer];
    if (localPlayer.isAuthenticated)
    {
        NSLog(@"Sending score");
        NSDictionary *postData = [notification userInfo];
        int score = [((NSString*)[postData objectForKey:@"score"]) intValue];
        [self reportScore: (int64_t)score forLeaderboardID:@"HighScores"];

    }
}

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        NSLog(@"Sent score with or without error: %@",error.userInfo);
    }];
}



- (GKLocalPlayer*) authenticateLocalPlayer
{
    NSLog(@"Authenticating player");
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *gcvc, NSError *error){
        NSLog(@"%@",error.userInfo);
        if (gcvc != nil)
        {
            NSLog(@"Presenting GC");
            [self presentViewController:gcvc animated:YES completion:nil];
        }
    };
    [self retrieveTopTenScores];
    return localPlayer;
}

- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
        gameCenterController.leaderboardCategory = leaderboardID;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void) retrieveTopTenScores
{
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeToday;
        leaderboardRequest.identifier = @"HighScores";
        leaderboardRequest.range = NSMakeRange(1,10);
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error == nil) {if (scores == nil) {
                NSLog(@" scores and error nil");
            }}
            if (error != nil)
            {
                // Handle the error.
                        NSLog(@" ERROORORRORRO %@",error.userInfo);
                
            }
            if (scores != nil)
            {
                                NSLog(@" scores retrieved");
                NSLog(@" %@",scores);
                // Process the score information.
            }

        }];
    }
}

//-(void) showThinBanner {
//    iadsBannerIsVisible = YES;
//    theBanner = [[ADBannerView alloc] initWithFrame:CGRectZero];
//    [theBanner setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//    theBanner.delegate = self;
//    theBanner.frame = CGRectMake(self.originalContentView.bounds.size
//                                 .width / 2 - theBanner.frame.size.width/2, self.originalContentView.bounds.size.height - theBanner.frame.size.height, theBanner.frame.size.width, theBanner.frame.size.height);
//    [self.view addSubview:theBanner];
//}
//
//- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
//{
//    NSLog(@"Banner was touched");
//    BOOL shouldExecuteAction = true; // your app implements this method
//    if (!willLeave && shouldExecuteAction)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"PauseScene" object:nil];
//    }
//    return shouldExecuteAction;
//}
//
//-(void) bannerViewActionDidFinish:(ADBannerView *)banner {
//    NSLog(@"banner is done being fullscreen");
//    //Unpause the game if you paused it previously.
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnPauseScene" object:nil]; //optional
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    NSLog(@"banner unavailable");
//    if (iadsBannerIsVisible == YES) {
//        
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        // Assumes the banner view is placed at the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
//        [UIView commitAnimations];
//        iadsBannerIsVisible = NO;
//        
//        NSLog(@"banner unavailable");
//    }
//}
//
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    NSLog(@"Banner has loaded");
//    iadsBannerIsVisible = YES;
//    if(banner.bannerLoaded) {
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        theBanner.frame = CGRectMake(self.originalContentView.bounds.size
//                                     .width / 2 - theBanner.frame.size.width/2, self.originalContentView.bounds.size.height - theBanner.frame.size.height, theBanner.frame.size.width, theBanner.frame.size.height);
//        [UIView commitAnimations];
//    }
//}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
