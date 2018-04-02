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
//被選中的顯示欄位的資料
@property (strong, nonatomic) NSMutableArray *tableShowData;
//collectView是否能使用拖動
@property (nonatomic) BOOL isDragInteractionEnabled;

@property (nonatomic) BOOL isScrollEnabled;

@end
