//
//  CollectionViewCell.m
//  CollectionView
//
//  Created by ad on 12/12/2017.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
//@synthesize delegate;
#define labelHeight 100
#define TABLE_HEIGHT 549

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    if (self) {
        tTableView = [[UITableView alloc] init];
        tTableView.showsVerticalScrollIndicator = NO;
        tTableView.delegate = self;
        tTableView.dataSource = self;
        tTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tTableView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:tTableView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableScrollToTop:) name:@"TableScrollToTop" object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat cellHeight = self.bounds.size.height;
//        tTableView.frame = CGRectMake(0, 0, self.frame.size.width , cellHeight - (labelHeight+5));
    tTableView.frame = CGRectMake(0, 0, [self widthOfString:_tbDataArray[0]], cellHeight - (labelHeight+5));
}

- (void)setTbDataArray:(NSMutableArray *)tbDataArray {
    _tbDataArray = tbDataArray;
    [tTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tbDataArray count] - 1;
}

//set section height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return labelHeight;
}

//set section titleLabel attribute
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] init];
    }
    
    titleLabel.text = _tbDataArray[0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.backgroundColor = [UIColor colorWithRed:115.0/255 green:171.0/255 blue:255.0/255 alpha:1.0];
    [titleLabel sizeToFit];
    
    return titleLabel;
}

#pragma -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10);
    cell.layer.cornerRadius = 15;
    cell.layer.borderWidth = 2;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    if ([_tbDataArray[indexPath.row + 1] componentsSeparatedByString:@"#"].count > 1) {
        cell.backgroundColor = [UIColor colorWithRed:243.0/255 green:205.0/255 blue:205.0/255 alpha:1.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [_tbDataArray[indexPath.row + 1] componentsSeparatedByString:@"#"][0]];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", _tbDataArray[indexPath.row + 1]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.backgroundColor  isEqual:[UIColor colorWithRed:243.0/255 green:205.0/255 blue:205.0/255 alpha:1.0]]) {
        cell.backgroundColor = [UIColor whiteColor];
        NSArray *spiltArray = [_tbDataArray[indexPath.row + 1] componentsSeparatedByString:@"#"];
        [_tbDataArray replaceObjectAtIndex:indexPath.row+1 withObject:spiltArray[0]];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:243.0/255 green:205.0/255 blue:205.0/255 alpha:1.0];
        NSString *str = [NSString stringWithFormat:@"%@#", _tbDataArray[indexPath.row + 1]];//有#代表 有選取過
        [_tbDataArray replaceObjectAtIndex:indexPath.row+1 withObject:str];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint location = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:location] forKey:@"CGPoint"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TableScrollToTop" object:self userInfo:userInfo];
}

- (void)tableScrollToTop:(NSNotification *)notification {
    if ([notification.userInfo valueForKey:@"CGPoint"] != nil) {
        NSValue *v = [notification.userInfo valueForKey:@"CGPoint"];
        tTableView.contentOffset = CGPointMake(v.CGPointValue.x ,v.CGPointValue.y);
    }
    [self setNeedsDisplay];//protect layout fail.
}

- (CGFloat)widthOfString:(NSString *)string {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width +65;
}

@end

