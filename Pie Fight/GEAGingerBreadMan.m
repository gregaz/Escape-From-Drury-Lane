//
//  GEAGingerBreadMan.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/19/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAGingerBreadMan.h"

@implementation GEAGingerBreadMan


-(id) initGingerManWithMuffinOrNil: (SKSpriteNode*) muffin andImageNamed: (NSString*) imageName {
    self = [super initWithImageNamed: imageName];
    self.muffin = muffin;
    return self;
}

-(id) initGingerManWithoutMuffinWithImageNamed: (NSString*) imageName {
    return [self initGingerManWithMuffinOrNil:nil andImageNamed: imageName];
}

-(void) throwMuffinWithDirectionVectorX:(double)x andY: (double)y {
    if([self hasMuffin]) {
    //TODO: throw muffin here
    
    self.muffin = nil;
    }
}

-(bool) hasMuffin {
    return self.muffin != nil;
}

@end
