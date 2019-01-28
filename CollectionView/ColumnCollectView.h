//
//  ColumnCollectView.h
//  CollectionView
//
//  Created by Chinalife on 2018/3/22.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "FilterView.h"


@interface ColumnCollectView : UIView </*CollectionViewCellDelegate,*/ UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate> {
    UIButton *filterBtn;
    FilterView *filterView;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSMutableArray *tableData;
//Data be selected
@property (strong, nonatomic) NSMutableArray *tableShowData;
//collectView enabled drag collectViewCell
@property (nonatomic) BOOL isDragInteractionEnabled;
//Scroll enabled
@property (nonatomic) BOOL isScrollEnabled;
//isShowFilterBtn
@property (nonatomic) BOOL isFilterBtnEnabled;

@property (nonatomic) BOOL isFirst;

@end
