//
//  GEAConstants.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/10/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAConstants.h"

@implementation GEAConstants

const uint32_t playerCategory =  0x1 << 0;
const uint32_t holeCategory =  0x1 << 1;
const uint32_t muffinCategory =  0x1 << 2;
const uint32_t muffinStackCategory =  0x1 << 3;
const uint32_t enemyCategory =  0x1 << 4;
const uint32_t doorCategory =  0x1 << 5;

const double muffinVelocity = 300;

+(NSString*) medalImageNameForScore: (int) aScore {
    if (aScore >= 1000) {
        return @"rainbowMedal.png";
    } else if ( aScore >= 500) {
        return @"emeraldMedal.png";
    } else if( aScore >= 100) {
        return @"rubyMedal.png";
    } else if( aScore >= 50) {
        return @"sapphireMedal.png";
    } else if( aScore >= 25) {
        return @"platinumMedal.png";
    } else if( aScore >= 15) {
        return @"goldMedal.png";
    } else if (aScore >= 10) {
        return @"silverMedal.png";
    } else if(aScore >= 5) {
        return @"copperMedal.png";
    }
    return @"noMedal.png";
}

@end
