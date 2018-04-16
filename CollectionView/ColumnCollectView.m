//
//  ColumnCollectView.m
//  CollectionView
//
//  Created by Chinalife on 2018/3/22.
//

#import "ColumnCollectView.h"
#import "CollectionViewCell.h"
#import "ItemData.h"

#define cellWidthSize 200
#define filterViewSize 250
#define minColumnCount 2
#define bottomHeightSize 0
#define fileBtnSize 50
#define TABLE_HEIGHT 549

@implementation ColumnCollectView

static NSString * const cellIdentifier = @"cellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self viewInit];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0f) {

    } else {
        [self setUpMovement];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectView:) name:@"refreshCollectView" object:nil];
    
    return self;
}

- (void)viewInit {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - bottomHeightSize) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [self addSubview:_collectionView];
    }
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.tableData = [[NSMutableArray alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0f) {
        self.collectionView.dragDelegate = self;
        self.collectionView.dropDelegate = self;//set drap drop delegate
    }

    filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.layer.opacity = .70;
    filterBtn.layer.cornerRadius = 25.0;
    filterBtn.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:205.0/255.0 blue:176.0/255.0 alpha:1.0];
    [filterBtn addTarget:self action:@selector(showfilterView) forControlEvents:UIControlEventTouchUpInside];
    [filterBtn setTitle:@"+" forState:UIControlStateNormal];
    filterBtn.frame = CGRectMake(self.frame.size.width - fileBtnSize - 10, fileBtnSize + 5, fileBtnSize, fileBtnSize);
    [self addSubview:filterBtn];

    filterView = [[FilterView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - filterViewSize/2, self.frame.size.height/2 -filterViewSize/2, filterViewSize, filterViewSize)];
    filterView.hidden = YES;
    [self addSubview:filterView];
}

- (void)setIsFilterBtnEnabled:(BOOL)isFilterBtnEnabled {
    _isScrollEnabled = isFilterBtnEnabled;
    filterBtn.hidden = !isFilterBtnEnabled;
}

- (void)setIsDragInteractionEnabled:(BOOL)isDragInteractionEnabled {
    _isDragInteractionEnabled = isDragInteractionEnabled;
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
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//Horizontal direct
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
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemData *data = _tableShowData[indexPath.row][0];
    return CGSizeMake([self widthOfString:data.itemValue], TABLE_HEIGHT);//autosizeSetting
//    return CGSizeMake(cellWidthSize, 550); //set item size
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;//size of between item size
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;//set each collectView Cell gap
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 10, 0);// Set edge for cell
}

#pragma mark - UICollectionViewDragDelegate
- (NSArray <UIDragItem *>*)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    NSArray *arryData = [self.tableShowData objectAtIndex:indexPath.row];
    
    ItemData *data = arryData[0];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:data.itemValue];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:nil];//notifity TableScrollToTop
}

- (void)showfilterView {
    [UIView transitionWithView:filterView duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
        [filterView setHidden:!filterView.hidden];
        if (filterView.hidden == NO) {
            [filterView reFilterViewData:_tableShowData];
        }
    } completion:nil];
}

- (void)refreshCollectView:(NSNotification *)notification {
    float cellLWidthSize = cellWidthSize;

    NSArray *originArray = [notification.userInfo valueForKey:@"OriginalData"];
    NSArray *filterArray = [notification.userInfo valueForKey:@"FilterData"];
    cellLWidthSize = cellLWidthSize *filterArray.count;
    
    if (originArray.count == self.tableData.count) {//判斷是否執行refresh 是否需要需要更新的collectView
        if (filterArray.count > minColumnCount) {
            if (self.frame.size.width < cellLWidthSize) {
                filterBtn.frame = CGRectMake(self.frame.size.width - fileBtnSize - 10, fileBtnSize/2, fileBtnSize, fileBtnSize);
            } else {
                filterBtn.frame = CGRectMake(cellLWidthSize - fileBtnSize - 10, fileBtnSize/2, fileBtnSize, fileBtnSize);
            }
            filterView.frame = CGRectMake(self.frame.size.width/2 - filterViewSize/2, self.frame.size.height/2 -filterViewSize/2, filterViewSize, filterViewSize);
        } else {
            filterBtn.frame = CGRectMake(cellWidthSize*minColumnCount - fileBtnSize -10, fileBtnSize/2, fileBtnSize, fileBtnSize);
            filterView.frame = CGRectMake(self.frame.size.width/2 - filterViewSize/2, self.frame.size.height/2 -filterViewSize/2, filterViewSize, filterViewSize);
        }
        
        [_tableShowData removeAllObjects];//tableShowData 需要顯示的資料
        for (int i = 0 ; i< filterArray.count; i++ ) {
            [_tableShowData addObject:filterArray[i]];
        }
        
        [_collectionView reloadData];
        //scroll to point 0.0
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)] forKey:@"CGPoint"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];//notifity TableScrollToTop
    }
}

- (CGFloat)widthOfString:(NSString *)string {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 65;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *temp = [self.tableShowData objectAtIndex:sourceIndexPath.row];
    [self.tableShowData removeObjectAtIndex:sourceIndexPath.row];
    [self.tableShowData insertObject:temp atIndex:destinationIndexPath.row];
}

- (void)setUpMovement {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)longPressAction:(UIGestureRecognizer *)gesture {
    if (_isDragInteractionEnabled == NO) {
        return;
    }
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.collectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            [self.collectionView reloadData];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)] forKey:@"CGPoint"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];
            break;
        }
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}


@end

