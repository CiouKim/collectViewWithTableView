//
//  CollectionViewCell.m
//  CollectionView
//
//  Created by ad on 12/12/2017.
//

#import "CollectionViewCell.h"
#import "CustomScrollView.h"
#import "ItemData.h"

@implementation CollectionViewCell
//@synthesize delegate;
#define labelHeight 100
#define TABLE_HEIGHT 549

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    if (self) {
        int gap = 30;
        int titleHeight = 100;
        
        scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, gap, self.frame.size.width, self.frame.size.height)];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , gap, self.frame.size.width, titleHeight)];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor colorWithRed:115.0/255 green:171.0/255 blue:255.0/255 alpha:1.0];
        [self addSubview:titleLabel];

        isFirst = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableScrollToTop:) name:@"TableScrollToTop" object:nil];
    }
    return self;
}

- (void)setTbDataArray:(NSMutableArray *)tbDataArray {
    _tbDataArray = tbDataArray;
    [self viewFrameSetting];

    scrollView.data = tbDataArray;
    ItemData *data = [tbDataArray objectAtIndex:0];
    
    [titleLabel setText:data.itemValue];
    
    if (isFirst) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointMake(0, 50)] forKey:@"CGPoint"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];
        userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointZero] forKey:@"CGPoint"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];
        isFirst = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint location = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:scrollView.contentOffset.x forKey:@"Xpoint"];
    [defaults setFloat:scrollView.contentOffset.y forKey:@"Ypoint"];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:location] forKey:@"CGPoint"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];
}

- (void)tableScrollToTop:(NSNotification *)notification {
    if ([notification.userInfo valueForKey:@"CGPoint"] != nil) {
        NSValue *v = [notification.userInfo valueForKey:@"CGPoint"];
        scrollView.contentOffset = CGPointMake(v.CGPointValue.x ,v.CGPointValue.y);
    }
}

- (CGFloat)widthOfString:(NSString *)string {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width +65;
}

- (void)viewFrameSetting {
    int gap = 30;
    int titleHeight = 100;
    ItemData *data = [_tbDataArray objectAtIndex:0];
    scrollView.frame = CGRectMake(0, gap, [self widthOfString:data.itemValue], self.frame.size.height);
    titleLabel.frame = CGRectMake(0, gap, [self widthOfString:data.itemValue], titleHeight);
}

@end

