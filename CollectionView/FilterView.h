//
//  FilterView.h
//  CollectionView
//
//  Created by Chinalife on 2018/3/28.
//

#import <UIKit/UIKit.h>
#import "YJMoveCellTableview.h"

@class YJMoveCellTableview;

@interface FilterView : UIView <yjMoveCellTableViewDelegate, yjMoveCellTableViewDataSource> {
    YJMoveCellTableview *filterTableView;
    UIButton *saveBtn;
}

@property (strong, nonatomic) NSMutableArray *originalTableData;
@property (strong, nonatomic) NSMutableArray *cellCheckmarkArray;//被選中的顯示 欄位資料
@property (strong, nonatomic) NSMutableArray *selectedDataArray;//被選中的資料
@property (strong, nonatomic) NSMutableArray *unselectedDataArray;//沒被選中的顯示


-(void)reFilterViewData:(NSMutableArray *)showDataArray;
@end
