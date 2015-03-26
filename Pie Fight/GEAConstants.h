//
//  GEAConstants.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/10/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GEAConstants : NSObject

extern const uint32_t playerCategory;
extern const uint32_t holeCategory;
extern const uint32_t muffinCategory;
extern const uint32_t muffinStackCategory;
extern const uint32_t enemyCategory;
extern const uint32_t doorCategory;

extern const double muffinVelocity;

+(NSString*) medalImageNameForScore: (int) aScore;

@end
