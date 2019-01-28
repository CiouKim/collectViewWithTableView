//
//  CustomScrollView.m
//  CollectionView
//
//  Created by Chinalife on 2018/4/12.
//

#import "CustomScrollView.h"
#import "CLInterestItem.h"
#import "ItemData.h"

@implementation CustomScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        
    }
    return self;
}

- (void)setData:(NSMutableArray *)data {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    _data = data;
    int titleHeight = 100;
    int itemHeight = 40;

    NSUInteger index = 0;
    for (ItemData *item in data) {
        if (index  == 0) {
//            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,  30, self.frame.size.width, titleHeight)];
//            titleLab.font = [UIFont systemFontOfSize:15.0];
//            titleLab.numberOfLines = 0;
//            itemData *item = [data objectAtIndex:0];
//            titleLab.text = item.itemValue;
//            titleLab.textAlignment = NSTextAlignmentCenter;
//            titleLab.backgroundColor = [UIColor colorWithRed:115.0/255 green:171.0/255 blue:255.0/255 alpha:1.0];
//            [self addSubview:titleLab];
        } else {
            CLInterestItem* itemBtn = [[CLInterestItem alloc]initWithFrame:CGRectMake(0, itemHeight*index + titleHeight - 35, self.frame.size.width, itemHeight)];
            [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [itemBtn setTag:index];
            [itemBtn addTarget:self action:@selector(onclickItem:)forControlEvents:UIControlEventTouchUpInside];
            [itemBtn setTitle:item.itemValue forState:UIControlStateNormal];
            [itemBtn setSelected:item.isSelected];
            [self addSubview:itemBtn];
        }
        index ++;
    }
    self.contentSize = CGSizeMake(self.frame.size.width, (data.count )*itemHeight + titleHeight + 20);
}

- (void)onclickItem:(CLInterestItem*)sender {
    sender.selected = !sender.selected;
    ItemData *iDta = [_data objectAtIndex:sender.tag];
    iDta.isSelected = sender.selected;
    [_data replaceObjectAtIndex:sender.tag withObject:iDta];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOriginalTableData" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_data, @"NewData", nil]];
}

@end
