//
//  GEAMuffinStackNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAMuffinStackNode.h"

@implementation GEAMuffinStackNode {
    int _numberOfMuffins;
}

@synthesize numberOfMuffins = _numberOfMuffins;

-(id)initWithRandomNumberOfMuffins {
    self = [super initWithImageNamed:@"muffinStack8.png"];
    [self setMuffinCount: (int) arc4random_uniform(8)+1 ];
    return self;
}

-(void)setMuffinCount: (int)muffinCount {
    if(muffinCount == 0) {
        [self removeFromParent];
    } else {
        self.numberOfMuffins = muffinCount;
        NSString *imageName = [NSString stringWithFormat:@"muffinStack%i.png", muffinCount];
        self.texture = [SKTexture textureWithImageNamed: imageName];
        [self setScale:0.05];
    }
}

-(void)loseOneMuffin {
    [self setNumberOfMuffins: self.numberOfMuffins - 1];
}

@end
