//
//  CollectionViewCell.h
//  CollectionView
//
//  Created by ad on 12/12/2017.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"
#import "ColumnCollectView.h"

@class ViewController;

//@protocol CollectionViewCellDelegate
////- (void)tableScroll:(UIScrollView *)scrollView;
//- (void)tableScroll:(CGPoint)point;
//@end

@interface CollectionViewCell : UICollectionViewCell <UIScrollViewDelegate/*UITableViewDelegate, UITableViewDataSource, CollectionViewCellDelegate*/> {
    UILabel *titleLabel;
    CustomScrollView *scrollView;
    BOOL isFirst;
}
//ＣollectViewCell 的所有資料
@property (nonatomic, weak) NSMutableArray *tbDataArray;
@property (nonatomic, weak) NSMutableArray *itemDataArray;

@end
