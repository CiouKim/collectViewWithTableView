//
//  CollectionViewCell.h
//  CollectionView
//
//  Created by ad on 12/12/2017.
//

#import <UIKit/UIKit.h>

@class ViewController;

//@protocol CollectionViewCellDelegate
////- (void)tableScroll:(UIScrollView *)scrollView;
//- (void)tableScroll:(CGPoint)point;
//@end

@interface CollectionViewCell : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource/*, CollectionViewCellDelegate*/> {
        UITableView *tTableView;
}

@property (strong, nonatomic) UILabel *label;
@property (nonatomic, weak) NSMutableArray *tbDataArray;//ＣollectViewCell 的所有資料

@end
