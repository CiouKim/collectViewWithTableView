//
//  CLInterestItem.m
//  ChinaLifeiShare
//
//  Created by Systex on 2014/11/9.
//  Copyright (c) 2014年 Softmobile. All rights reserved.
//

#import "CLInterestItem.h"

@implementation CLInterestItem
@synthesize iSuperViewTag;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage* image = [UIImage imageNamed: @"Text_Field_1.png"];
    
    self.exclusiveTouch = YES;
    
    if (self.highlighted || self.selected)
    {
        UIGraphicsBeginImageContext(image.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
        
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -area.size.height);
        
        CGContextSaveGState(context);
        CGContextClipToMask(context, area, image.CGImage);
        
        [[UIColor colorWithRed:243.0/255 green:205.0/255 blue:205.0/255 alpha:1.0] set];
        CGContextFillRect(context, area);
        
        CGContextRestoreGState(context);
        
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        
        CGContextDrawImage(context, area, image.CGImage);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    UIImage* backgroundImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode: UIImageResizingModeStretch];
    [backgroundImage drawInRect:[self bounds]];
}
- (void) setSelected:(BOOL)selected
{
    [super setSelected: selected];
    [self setNeedsDisplay];
}


@end
