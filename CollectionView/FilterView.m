//
//  FilterView.m
//  CollectionView
//
//  Created by Chinalife on 2018/3/28.
//

#import "FilterView.h"

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:180.0f/255.0f green:218.0f/255.0f blue:247.0f/255.0f alpha:1];
    self.layer.cornerRadius = 15;
    if (self) {
        filterTableView = [[UITableView alloc]init];
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
    }
    return self;
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _originalTableData[indexPath.row][0]];
  
    if ([_cellCheckmarkArray containsObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        [_cellCheckmarkArray addObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [_cellCheckmarkArray removeObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setOriginalTableData:(NSMutableArray *)originalTableData {
    for (int i = 0; i< originalTableData.count; i++) {
        [_cellCheckmarkArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    _originalTableData = originalTableData;
    [filterTableView reloadData];
}

- (void)filterSelectData {
    if (_cellCheckmarkArray.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please selected atleast one cell." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"again" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];

        [[self topMostController] presentViewController:alertController animated:YES completion:nil];
        return;
    }
    self.hidden = YES;
    NSArray *sortCellCheckmarkArray =  [_cellCheckmarkArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        int first = [a intValue];
        int second = [b intValue];
        if ( first > second ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( first < second ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCollectView" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:sortCellCheckmarkArray, @"FilterData", _originalTableData, @"OriginalData", nil]];
}

- (UIViewController*) topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end

