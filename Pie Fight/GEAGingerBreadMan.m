//
//  GEAGingerBreadMan.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/19/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAGingerBreadMan.h"
#import "GEAConstants.h"

static const NSString* withoutMuffinImageName = @"standingGingerBreadMan";
static const NSString* withMuffinImageName = @"standingGingerBreadManWithMuffin";
static const double speedModifier = 2.5;

@implementation GEAGingerBreadMan {
    SKTextureAtlas *gingerBreadManAtlas;
    NSMutableArray *gingerBreadManSideRunArray;
    NSMutableArray *gingerBreadManSideRunWithMuffinArray;
    NSMutableArray *gingerBreadManDownRunArray;
    NSMutableArray *gingerBreadManDownRunArrayWithMuffin;
    NSMutableArray *gingerBreadManUpRunArray;
    NSMutableArray *gingerBreadManUpRunArrayWithMuffin;
    
    SKAction *throwMuffinSound;

    bool isRunningRight;
    bool isRunningLeft;
    bool isRunningUp;
    bool isRunningDown;
    
}

-(id) initGingerManWithMuffinOrNil: (GEAMuffinNode*) muffin andAtlasImageNamed: (NSString*) imageName {
    self = [super init];
    self.muffin = muffin;
    [self initAtlasAndAnimationArray];
    SKTexture *firstTexture = [gingerBreadManAtlas textureNamed: imageName];
    [self setTexture: firstTexture];
    [self setSize: [firstTexture size]];
    [self resetRunningDirectionBools];
    [self initCollisionConfiguration];
    [self initSounds];
    return self;
}

-(void) initSounds {
    throwMuffinSound = [SKAction playSoundFileNamed:@"muffinThrow.wav" waitForCompletion:NO];
}

-(id) initGingerBreadManWithDefaultImage {
    return [self initGingerManWithMuffinOrNil: nil andAtlasImageNamed: withoutMuffinImageName];
}

-(id) initGingerBreadManWithDefaultSideRunImage {
    return [self initGingerManWithMuffinOrNil: nil andAtlasImageNamed: @"frame10"];
}

-(void) initCollisionConfiguration {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = playerCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = muffinStackCategory + holeCategory + doorCategory + enemyCategory;
    self.physicsBody.collisionBitMask = 0;
    [self setZPosition:-40.0];
}

-(void) resetRunningDirectionBools {
    isRunningDown = false;
    isRunningUp = false;
    isRunningRight = false;
    isRunningLeft = false;
}

-(void) initAtlasAndAnimationArray {
    gingerBreadManAtlas = [SKTextureAtlas atlasNamed: @"gingerBreadMen"];
    gingerBreadManSideRunArray = [NSMutableArray array];
    gingerBreadManSideRunWithMuffinArray = [NSMutableArray array];
    gingerBreadManDownRunArray = [NSMutableArray array];
    gingerBreadManDownRunArrayWithMuffin = [NSMutableArray array];
    gingerBreadManUpRunArray = [NSMutableArray array];
    gingerBreadManUpRunArrayWithMuffin = [NSMutableArray array];
    
    for(int i = 10; i <= 16; i++) {
        NSString* fileName = [NSString stringWithFormat: @"frame%i", i];
        SKTexture *temp = [gingerBreadManAtlas textureNamed:fileName];
        [gingerBreadManSideRunArray addObject:temp];
    }
    
    for (int i =10; i <= 16; i++) {
        NSString *fileName = [NSString stringWithFormat: [NSString stringWithFormat: @"withMuffin%i", i]];
        SKTexture *temp = [gingerBreadManAtlas textureNamed:fileName];
        [gingerBreadManSideRunWithMuffinArray addObject: temp];
    }
    
    for (int i = 1; i <=12; i++) {
        NSString *fileName = [NSString stringWithFormat: [NSString stringWithFormat: @"runningDown%i", i]];
        SKTexture *temp = [gingerBreadManAtlas textureNamed:fileName];
        [gingerBreadManDownRunArray addObject: temp];

    }
    
    for (int i = 1; i <=12; i++) {
        NSString *fileName = [NSString stringWithFormat: [NSString stringWithFormat: @"runningDownWithMuffin%i", i]];
        SKTexture *temp = [gingerBreadManAtlas textureNamed:fileName];
        [gingerBreadManDownRunArrayWithMuffin addObject: temp];
        
    }
    
    for (int i = 1; i <=12; i++) {
        NSString *fileName = [NSString stringWithFormat: [NSString stringWithFormat: @"runningUp%i", i]];
        SKTexture *temp = [gingerBreadManAtlas textureNamed:fileName];
        [gingerBreadManUpRunArray addObject: temp];
        
    }
    
    for (int i = 1; i <=12; i++) {
        NSString *fileName = [NSString stringWithFormat: [NSString stringWithFormat: @"runningUpWithMuffin%i", i]];
        SKTexture *temp = [gingerBreadManAtlas textureNamed:fileName];
        [gingerBreadManUpRunArrayWithMuffin addObject: temp];
        
    }
    
}

-(void) standStill {
    [self removeAllActions];
    [self runAction:[SKAction setTexture:[gingerBreadManAtlas textureNamed: [self standStillImageName]] resize:true]];
}

-(NSString *) standStillImageName {
    if ( [self hasMuffin]) {
        return withMuffinImageName;
    } else {
        return withoutMuffinImageName;
    }
}

-(NSMutableArray *) sideRunAnimationArray {
    if ( [self hasMuffin]) {
        return gingerBreadManSideRunWithMuffinArray;
    } else {
        return gingerBreadManSideRunArray;
    }
}

-(NSMutableArray *) downRunAnimationArray {
    if ( [self hasMuffin]) {
        return gingerBreadManDownRunArrayWithMuffin;
    } else {
        return gingerBreadManDownRunArray;
    }
}

-(NSMutableArray *) upRunAnimationArray {
    if ( [self hasMuffin]) {
        return gingerBreadManUpRunArrayWithMuffin;
    } else {
        return gingerBreadManUpRunArray;
    }
}

-(void) animateSideRun {
    [self removeAllActions];
    [self runAction:[SKAction repeatActionForever:
                               [SKAction animateWithTextures: [self sideRunAnimationArray]
                                                timePerFrame:0.1f
                                                      resize:YES
                                                     restore:YES]] withKey:@"gingerBreadManRunning"];
}

-(void) animateDownRun {
    [self removeAllActions];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures: [self downRunAnimationArray]
                                      timePerFrame:0.1f
                                            resize:YES
                                           restore:YES]] withKey:@"gingerBreadManRunning"];
}

-(void) animateUpRun {
    [self removeAllActions];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures: [self upRunAnimationArray]
                                      timePerFrame:0.1f
                                            resize:YES
                                           restore:YES]] withKey:@"gingerBreadManRunning"];

}


-(void) animateSideRunRight {
    [self animateSideRun];
    self.xScale = ABS(self.xScale);
}

-(void) animateSideRunLeft {
    [self animateSideRun];
    self.xScale = ABS(self.xScale)*-1.0;
}


-(void) throwMuffinWithDirectionVectorX:(double)x andY: (double)y {
    if([self hasMuffin] && (x != 0.0 && y != 0.0)) {
        [self runAction:throwMuffinSound];
        CGPoint muffinPosition;
        if(self.xScale > 0) {
            muffinPosition = CGPointMake( self.position.x + self.size.width*0.5 + 1 , self.position.y + self.size.height * 0.35  );
        } else {
            muffinPosition = CGPointMake( self.position.x - self.size.width*0.5 - 1, self.position.y + self.size.height * 0.35  );
        }
        
        [self.muffin setPosition: muffinPosition];
        [self.muffin setScale: 0.05];
        [self.muffin initializeCollisionConfig];
        
        [[self parent] addChild: self.muffin];
        
        CGPoint destination = [GEAPointMath addPoint:self.muffin.position
                                            andPoint:([GEAPointMath scalePoint: CGPointMake(x, y) by:1000.0])];
        
        [self.muffin launchMuffinTowardsDestination: destination];
        [self resetRunningDirectionBools];
        
        self.muffin = nil;
        //Check if there is a new muffin to pickup (didBeginContact won't be called again unless you leave the stack first
        for (SKPhysicsBody* physicsBody in self.physicsBody.allContactedBodies) {
            if([physicsBody.node isMemberOfClass: [GEAMuffinStackNode class]]){
                [self pickupMuffinFromMuffinStack: (GEAMuffinStackNode*)physicsBody.node];
            }
        }
    }
}

-(void) pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) aMuffinStack {
    if(![self hasMuffin]) {
        self.muffin = [[GEAMuffinNode alloc] initWithImageNamed: @"muffin.png"];
        [aMuffinStack loseOneMuffin];
        //Reset running bools to reset animation (change to animation with muffin)
        [self resetRunningDirectionBools];
    }
}

-(bool) hasMuffin {
    return self.muffin != nil;
}

-(void) moveUsingVectorWithX: (double) x andY: (double) y andTimeDelta: (CFTimeInterval) timeDelta{
    if (ABS(x) < 0.00001 && ABS(y) < 0.00001) {
        [self standStill];
        [self resetRunningDirectionBools];
        return;
        
    } else {
    
        if (ABS(x) >= ABS(y)) {
            if ( x > 0) {
                if (!isRunningRight) {
                    [self resetRunningDirectionBools];
                    isRunningRight = true;
                    [self animateSideRunRight];
                }
                
            } else {
                if(!isRunningLeft) {
                    [self resetRunningDirectionBools];
                    isRunningLeft = true;
                    [self animateSideRunLeft];
                }
            }
        } else {
            if ( y > 0) {
                if(!isRunningUp) {
                    [self resetRunningDirectionBools];
                    isRunningUp = true;
                    [self animateUpRun];
                }
            } else {
                if(!isRunningDown)
                {
                    [self resetRunningDirectionBools];
                    isRunningDown = true;
                    [self animateDownRun];
                }
            }
            
        }
        float maxFps = 60.0 / self.parent.scene.view.frameInterval;
        float timeDeltaModifier = maxFps / (MIN(1/timeDelta, maxFps));
        
        float newPlayerX = (float) self.position.x + x*speedModifier*timeDeltaModifier;
        float newPlayerY = (float) self.position.y + y*speedModifier*timeDeltaModifier;
        

        
        if((newPlayerX > self.parent.frame.size.width) || (newPlayerX < 0)) {
            newPlayerX = self.position.x;
        }
        if((newPlayerY > self.parent.frame.size.height) || (newPlayerY < 0)) {
            newPlayerY = self.position.y;
        }
        
        self.position = CGPointMake( newPlayerX, newPlayerY);
    }
    
}

@end
