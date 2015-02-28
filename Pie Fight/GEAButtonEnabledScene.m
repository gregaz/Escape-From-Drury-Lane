//
//  GEAButtonEnabledScene.m
//  Escape From Drury Lane
//
//  Created by Gregory Azuolas on 2/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAButtonEnabledScene.h"
#import "GEAButton.h"

@implementation GEAButtonEnabledScene

-(void)update:(CFTimeInterval)currentTime {
    for (SKNode* node in [self children]) {
        if ([node isKindOfClass: [GEAButton class]]) {
            [(GEAButton*)node updateButtonStatus];
        }
    }
}

@end
