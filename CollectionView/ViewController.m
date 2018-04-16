

#import "ViewController.h"
#import "ColumnCollectView.h"
#import "ItemData.h"

//#define cellWidthSize 100
#define gap 5
#define TABLE_HEIGHT self.view.bounds.size.height

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //array[0] 為呈現的title 直接使用tableView headTitle處理
    
    NSMutableArray *sectiona = [NSMutableArray arrayWithObjects:@"累計增加保險金額對應\n之生存/滿期/祝壽\n保險金(預估值)", @"a", @"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *sectionb = [NSMutableArray arrayWithObjects:@"基本保險金額對應\n之一般身故", @"b", @"14", @"15", @"16", @"17", @"18", @"19", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *sectionc = [NSMutableArray arrayWithObjects:@"基本保險金額對應之\n生存/滿期/祝壽保險金", @"c", @"24", @"25", @"26", @"27", @"28", @"29", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects:@"累計增加保險金額對應\n之生存/滿期/祝壽\n保險金(預估值)", @"a", @"123,000,0000", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *section2 = [NSMutableArray arrayWithObjects:@"基本保險金額對應\n之一般身故", @"b", @"14", @"15", @"16", @"17", @"18", @"19", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *section3 = [NSMutableArray arrayWithObjects:@"基本保險金額對應之\n生存/滿期/祝壽保險金", @"c", @"24", @"25", @"26", @"27", @"28", @"29", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *section4 = [NSMutableArray arrayWithObjects:@"基本保險金額對應\n之現金價值", @"d", @"34", @"35", @"36", @"37", @"38", @"39", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *section5 = [NSMutableArray arrayWithObjects:@"一般身故(含累計增\n加保險金額)(預估值)", @"e", @"44", @"45", @"46", @"47", @"48", @"49", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *section6 = [NSMutableArray arrayWithObjects:@"FFFFFFF", @"f", @"54", @"55", @"56", @"57", @"58", @"59", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *section7 = [NSMutableArray arrayWithObjects:@"GG", @"g", @"55", @"55", @"56", @"57", @"58", @"59", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSMutableArray *section8 = [NSMutableArray arrayWithObjects:@"HHsss", @"h", @"54", @"55", @"56", @"57", @"58", @"59", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"123", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    
    NSMutableArray *aa = [NSMutableArray arrayWithObjects:@"一般身故(含累計增\n加保險金額)(預估值)", @"e", @"44", @"45", @"46", @"47", @"48", @"49", @"2", @"3", nil];
    NSMutableArray *bb = [NSMutableArray arrayWithObjects:@"一般(預估值)", @"e", @"44", @"45", @"46", @"47", @"48", @"49", @"2", @"3", nil];
    NSMutableArray *cc = [NSMutableArray arrayWithObjects:@"一般身故(含累計增\n加保險金額)(預估值)", @"e", @"44", @"45", @"46", @"47", @"48", @"49", @"2", @"3", nil];



    float cellLWidthSize = 200;
    float cellRWidthSize = 200;
    
//    NSMutableArray *tempLArr = [NSMutableArray arrayWithObjects: sectiona, sectionb, sectionc, nil];
        NSMutableArray *tempLArr = [NSMutableArray arrayWithObjects: sectiona,  nil];
//    NSMutableArray *tempLArr = [NSMutableArray arrayWithObjects: aa,  nil];

    NSMutableArray *tempRArr = [NSMutableArray arrayWithObjects:section1, section2,section3, section4, section5, section6, section7, section8, nil];
//        NSMutableArray *tempRArr = [NSMutableArray arrayWithObjects:cc, bb, nil];
    
    
    NSMutableArray *rdata = [[NSMutableArray alloc] init];
    NSMutableArray *ldata = [[NSMutableArray alloc] init];
    
    for (NSArray *arr in tempLArr) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (NSString *str in arr) {
            ItemData *ds = [[ItemData alloc] init];
            ds.itemValue = str;
            ds.isSelected  = NO;
            [tmp addObject:ds];
        }
        [ldata addObject:tmp];
    }
    
    for (NSArray *arr in tempRArr) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (NSString *str in arr) {
            ItemData *ds = [[ItemData alloc] init];
            ds.itemValue = str;
            ds.isSelected  = NO;
            [tmp addObject:ds];
        }
        [rdata addObject:tmp];
    }

    
    
    if (lCView == nil) {
//        cellLWidthSize = cellLWidthSize *tempLArr.count;
        cellLWidthSize = [self calculateWidth:ldata];//依據title 計算wideth autosizeSetting
        lCView = [[ColumnCollectView alloc] initWithFrame:CGRectMake(0, 0, cellLWidthSize + gap, TABLE_HEIGHT)];
    }
    
    if (rCView == nil) {
//        cellRWidthSize = cellRWidthSize *tempRArr.count;
        cellRWidthSize = [self calculateWidth:rdata];//依據title 計算wideth autosizeSetting
        if ((cellLWidthSize +  cellRWidthSize* tempLArr.count + gap + gap) > self.view.bounds.size.width) {
            rCView = [[ColumnCollectView alloc] initWithFrame:CGRectMake(cellLWidthSize + gap + gap, 0, self.view.bounds.size.width - cellLWidthSize - gap, TABLE_HEIGHT)];
        } else {
            rCView = [[ColumnCollectView alloc] initWithFrame:CGRectMake(cellLWidthSize + gap + gap, 0, cellRWidthSize , TABLE_HEIGHT)];
        }
    }
    
    lCView.tag = 1;
    rCView.tag = 2;
    
    //Set Scroll Enabled
    lCView.isScrollEnabled = NO;
    rCView.isScrollEnabled = YES;
    
    //Set Drag Enabled
    lCView.isDragInteractionEnabled = NO;
    rCView.isDragInteractionEnabled = YES;
    
    //Set fileterBtn Enabled
    lCView.isFilterBtnEnabled = NO;
    rCView.isFilterBtnEnabled = YES;

    //Set Data
    lCView.tableData = ldata;
    rCView.tableData = rdata;
    
    [self.view addSubview:lCView];
    [self.view addSubview:rCView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float) calculateWidth:(NSArray *) arr {
    float tWidth = 0;

    for (NSArray *a in arr) {
        ItemData *data = [a objectAtIndex:0];
       tWidth += [self widthOfString:data.itemValue];
    }
    return tWidth;
}

- (CGFloat)widthOfString:(NSString *)string {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 65;
}

@end

