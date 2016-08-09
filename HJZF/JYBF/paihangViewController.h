//
//  paihangViewController.h
//  Theterritoryofpayment
//
//  Created by 铂金数据 on 15/11/9.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"

@interface paihangViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIImagePickerControllerDelegate>





{
    MJRefreshHeaderView *_header;
    
    MJRefreshFooterView *_footer;
}

@property (nonatomic,retain) UITableView *table;

@end
