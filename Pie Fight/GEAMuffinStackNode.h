//
//  GEAMuffinStackNode.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEARandomizablePositionNode.h"

@interface GEAMuffinStackNode : GEARandomizablePositionNode

-(id)initWithRandomNumberOfMuffins;
-(void)setNumberOfMuffins: (int)numberOfMuffins;
-(void)loseOneMuffin;
@property int numberOfMuffins;

@end
