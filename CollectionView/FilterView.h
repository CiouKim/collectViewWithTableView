//
//  FilterView.h
//  CollectionView
//
//  Created by Chinalife on 2018/3/28.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *filterTableView;
    UIButton *saveBtn;
}

@property (strong, nonatomic) NSMutableArray *originalTableData;
@property (strong, nonatomic) NSMutableArray *cellCheckmarkArray;//被選中的顯示 欄位資料

@end
