//
//  FilterView.m
//  CollectionView
//
//  Created by Chinalife on 2018/3/28.
//

#import "FilterView.h"
#import "YJMoveCellTableview.h"
#import "ItemData.h"

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:180.0f/255.0f green:218.0f/255.0f blue:247.0f/255.0f alpha:1];
    self.layer.cornerRadius = 15;
    if (self) {
        filterTableView = [[YJMoveCellTableview alloc]init];
        filterTableView.backgroundColor = [UIColor colorWithRed:180.0f/255.0f green:218.0f/255.0f blue:247.0f/255.0f alpha:1];
        filterTableView.showsVerticalScrollIndicator = NO;
        filterTableView.delegate = self;
        filterTableView.dataSource = self;
        filterTableView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 70);
        filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        filterTableView.layer.cornerRadius = 18;
        [self addSubview:filterTableView];
        
        saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.layer.opacity = .70;
        saveBtn.layer.cornerRadius = 25.0;
        saveBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:6.0/255.0 blue:40.0/255.0 alpha:1.0];
        [saveBtn addTarget:self action:@selector(filterSelectData) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        saveBtn.frame = CGRectMake(self.frame.size.width - 120, self.frame.size.height - 50, 100, 50);
        [self addSubview:saveBtn];
        
        _cellCheckmarkArray = [[NSMutableArray alloc] init];
        _selectedDataArray = [[NSMutableArray alloc] init];
        _unselectedDataArray = [[NSMutableArray alloc] init];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOriginalTableData:) name:@"updateOriginalTableData" object:nil];
    return self;
}

- (NSArray *)dataSourceArrayInTableView:(YJMoveCellTableview *)tableView {
    return _originalTableData.copy;
}

- (void)tableView:(YJMoveCellTableview *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray {
    _originalTableData = newDataSourceArray.mutableCopy;
    [filterTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _originalTableData.count;
}

#pragma -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.tag = indexPath.row;
    
    
    ItemData *item = _originalTableData[indexPath.row][0];
    cell.textLabel.text = item.itemValue;
  
    if ([_selectedDataArray containsObject:[_originalTableData objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    ItemData *item = [_originalTableData objectAtIndex:indexPath.row][0];
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if ([_selectedDataArray containsObject:[_originalTableData objectAtIndex:indexPath.row]] == NO) {
            [_selectedDataArray addObject:[_originalTableData objectAtIndex:indexPath.row]];
        }
        if ([_unselectedDataArray containsObject:[_originalTableData objectAtIndex:indexPath.row]] == YES) {
            [_unselectedDataArray removeObject:[_originalTableData objectAtIndex:indexPath.row]];
        }
        item.isSelected = NO;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([_selectedDataArray containsObject:[_originalTableData objectAtIndex:indexPath.row]] == YES) {
            [_selectedDataArray removeObject:[_originalTableData objectAtIndex:indexPath.row]];
        }
        if ([_unselectedDataArray containsObject:[_originalTableData objectAtIndex:indexPath.row]] == NO) {
            [_unselectedDataArray addObject:[_originalTableData objectAtIndex:indexPath.row]];
        }
        item.isSelected = YES;
    }
    [[_originalTableData objectAtIndex:indexPath.row] replaceObjectAtIndex:0 withObject:item];
}

- (void)setOriginalTableData:(NSMutableArray *)originalTableData {
    for (int i = 0; i< originalTableData.count; i++) {
        [_selectedDataArray addObject:originalTableData[i]];
        if (_originalTableData == nil) {
            _originalTableData = [[NSMutableArray alloc] init];
        }
        [_originalTableData addObject:originalTableData[i]];
    }

    [filterTableView reloadData];
}

- (void)filterSelectData {
    if (_selectedDataArray.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please selected atleast one cell." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];

        [[self topMostController] presentViewController:alertController animated:YES completion:nil];
        return;
    }
    self.hidden = YES;
//    NSArray *sortCellCheckmarkArray =  [_cellCheckmarkArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//        int first = [a intValue];
//        int second = [b intValue];
//        if ( first > second ) {
//            return (NSComparisonResult)NSOrderedAscending;
//        } else if ( first < second ) {
//            return (NSComparisonResult)NSOrderedDescending;
//        } else {
//            return (NSComparisonResult)NSOrderedSame;
//        }
//    }];//orderby sort by value
    
    [_selectedDataArray removeAllObjects];
    [_unselectedDataArray removeAllObjects];
    for (NSArray *arr in _originalTableData) {
        ItemData *item = [arr objectAtIndex:0];
        if (item.isSelected == YES) {
            [_unselectedDataArray addObject:arr];
        } else {
            [_selectedDataArray addObject:arr];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCollectView" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_selectedDataArray, @"FilterData", _originalTableData, @"OriginalData", nil]];
}

- (UIViewController*) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

- (void)reFilterViewData:(NSMutableArray *)showDataArray {
    [_originalTableData removeAllObjects];
    [_selectedDataArray removeAllObjects];
    [_selectedDataArray addObjectsFromArray:showDataArray];
    [_originalTableData addObjectsFromArray:[_selectedDataArray mutableCopy]];
    [_originalTableData addObjectsFromArray:[_unselectedDataArray mutableCopy]];
    
    [filterTableView reloadData];
}

- (void)updateOriginalTableData:(NSNotification *)notification {
    if ([_originalTableData containsObject:[notification.userInfo valueForKey:@"NewData"]]) {
        [_originalTableData replaceObjectAtIndex:[_originalTableData indexOfObject:[notification.userInfo valueForKey:@"NewData"]] withObject:[notification.userInfo valueForKey:@"NewData"]];
    }
}

@end

