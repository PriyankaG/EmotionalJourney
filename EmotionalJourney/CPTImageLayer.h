//
//  CPTImageLayer.h
//  EmotionalJourney
//
//  Created by Administrator on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPTLayer.h"


@interface CPTImageLayer : CPTLayer {
    
    UIImage *_image;
    
}

-(id)initWithImage:(UIImage *)image;

@end
