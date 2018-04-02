//
//  ViewController.h
//  CollectionView
//
//  Created by ad on 08/12/2017.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "ColumnCollectView.h"


@interface ViewController : UIViewController {
    ColumnCollectView *lCView;
    ColumnCollectView *rCView;
}

//@property (nonatomic) id <CollectionViewCellDelegate> delegate;

@end

