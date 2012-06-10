//
//  CPTImageLayer.m
//  EmotionalJourney
//
//  Created by Administrator on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CPTImageLayer.h"
#import "CPTLayer.h"

@implementation CPTImageLayer



-(id)initWithImage:(UIImage *)image{
    
    CGRect f = CGRectMake(0, 0, image.size.width, image.size.height);
    
    if (self = [super initWithFrame:f]) {
        
        _image = [image copy];
    }
    
    return self;
    
}


-(void)drawInContext:(CGContextRef)ctx{
    
    CGContextDrawImage(ctx, self.bounds, _image.CGImage);
    
}


@end
