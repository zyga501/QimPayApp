//
//  tiXianJiluViewController.h
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/22.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface tiXianJiluViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

{
    
    MJRefreshHeaderView *_header;
    
    MJRefreshFooterView *_footer;
    
    
    
}

@end
