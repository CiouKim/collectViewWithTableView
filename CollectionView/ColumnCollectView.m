    //
//  ColumnCollectView.m
//  CollectionView
//
//  Created by Chinalife on 2018/3/22.
//

#import "ColumnCollectView.h"
#import "CollectionViewCell.h"

#define cellWidthSize 200
#define filterViewSize 250
#define minColumnCount 2

@implementation ColumnCollectView

static NSString * const cellIdentifier = @"cellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];

    if (self) {
        [self viewInit];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectView:) name:@"refreshCollectView" object:nil];
    return self;
}

- (void)viewInit {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 75, self.frame.size.width, self.frame.size.height - 70) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
    }
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.tableData = [[NSMutableArray alloc] init];
    self.collectionView.dragDelegate = self;
    self.collectionView.dropDelegate = self;//set drap drop delegate
    
    filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.layer.opacity = .70;
    filterBtn.layer.cornerRadius = 25.0;
    filterBtn.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:205.0/255.0 blue:176.0/255.0 alpha:1.0];
    [filterBtn addTarget:self action:@selector(showfilterView) forControlEvents:UIControlEventTouchUpInside];
    [filterBtn setTitle:@"+" forState:UIControlStateNormal];
    filterBtn.frame = CGRectMake(self.frame.size.width - 50, 25, 50, 50);
    [self addSubview:filterBtn];

    filterView = [[FilterView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - filterViewSize/2, self.frame.size.height/2 -filterViewSize/2, filterViewSize, filterViewSize)];
    filterView.hidden = YES;
    [self addSubview:filterView];
}

- (void)setIsDragInteractionEnabled:(BOOL)isDragInteractionEnabled {
    _collectionView.dragInteractionEnabled = isDragInteractionEnabled;
}

- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    [_collectionView setScrollEnabled:isScrollEnabled];
}

- (void)setTableData:(NSMutableArray *)tableData {
    filterView.originalTableData = tableData;
    _tableData = tableData;
    [_collectionView reloadData];
}

#pragma mark - Setters & Getters
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        // 初始化UICollectionViewFlowLayout，设置集合视图滑动方向。
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_tableShowData.count == 0 || _tableShowData == nil) {
        _tableShowData = [_tableData mutableCopy];
    }
    return self.tableShowData.count;
}

- (CollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tbDataArray = self.tableShowData[indexPath.row];
    cell.label.text = self.tableShowData[indexPath.row][0];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(cellWidthSize, 450); //set item size
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;//size of between item size
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 3;//set each collectView Cell gap
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);// Set edge for cell
}

#pragma mark - UICollectionViewDragDelegate
- (NSArray <UIDragItem *>*)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    NSArray *arryData = [self.tableShowData objectAtIndex:indexPath.row];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:arryData[0]];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    dragItem.localObject = arryData;
    return @[dragItem];
}

- (nullable UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIDragPreviewParameters *previewParameters = [[UIDragPreviewParameters alloc] init];
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    previewParameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:10];
    previewParameters.backgroundColor = [UIColor clearColor];
    return previewParameters;
}

#pragma mark - UICollectionViewDropDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[NSString class]];
}

- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    UICollectionViewDropProposal *dropProposal;
    if (session.localDragSession) {
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    } else {
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    return dropProposal;
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    // 如果coordinator.destinationIndexPath存在直接回 如果不存在回（0，0)
    NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath ? coordinator.destinationIndexPath : [NSIndexPath indexPathForItem:0 inSection:0];
    // refresh
    if (coordinator.items.count == 1 && coordinator.items.firstObject.sourceIndexPath) {
        NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;
        [collectionView performBatchUpdates:^{
            // updataData
            NSArray *arr = coordinator.items.firstObject.dragItem.localObject;
            [self.tableShowData removeObjectAtIndex:sourceIndexPath.item];
            [self.tableShowData insertObject:arr atIndex:destinationIndexPath.item];
            // 更新collectionView
            [collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
            [collectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)] forKey:@"CGPoint"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];//notifity TableScrollToTop
        } completion:nil];
    }
}

- (void)showfilterView {
    [UIView transitionWithView:filterView duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
        [filterView setHidden:!filterView.hidden];
//        [filterView setHidden:NO];
    } completion:nil];
}

- (void) refreshCollectView:(NSNotification *)notification {
    float cellLWidthSize = cellWidthSize;

    NSArray *originArray = [notification.userInfo valueForKey:@"OriginalData"];
    NSArray *filterArray = [notification.userInfo valueForKey:@"FilterData"];
    cellLWidthSize = cellLWidthSize *filterArray.count;
    
    if (originArray.count == self.tableData.count) {//判斷是否執行refresh 是否需要需要更新的collectView
        if (filterArray.count > minColumnCount) {
            if (self.frame.size.width < cellLWidthSize) {
                filterBtn.frame = CGRectMake(self.frame.size.width - 50, 25, 50, 50);
            } else {
                filterBtn.frame = CGRectMake(cellLWidthSize -50, 25, 50, 50);
            }
            filterView.frame = CGRectMake(self.frame.size.width/2 - filterViewSize/2, self.frame.size.height/2 -filterViewSize/2, filterViewSize, filterViewSize);
        } else {
            filterBtn.frame = CGRectMake(cellWidthSize*minColumnCount - 50, 25, 50, 50);
            filterView.frame = CGRectMake(self.frame.size.width/2 - filterViewSize/2, self.frame.size.height/2 -filterViewSize/2, filterViewSize, filterViewSize);
        }
        
        [_tableShowData removeAllObjects];//tableShowData 需要顯示的資料
        for (int i = 1 ; i<= filterArray.count; i++ ) {
            int filterIndex = [filterArray[filterArray.count - i] intValue];
            [_tableShowData addObject:_tableData[filterIndex]];
        }
        [_collectionView reloadData];
        //scroll to point 0.0
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)] forKey:@"CGPoint"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];//notifity TableScrollToTop
    }
}

@end

