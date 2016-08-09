//
//  paihangViewController.m
//  Theterritoryofpayment
//
//  Created by 铂金数据 on 15/11/9.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#define kCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#import "paihangViewController.h"
#import "UIView+Ex.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "paihangTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "xiangqingViewController.h"


@interface paihangViewController ()<UITableViewDelegate>
{
    MyNavigationBar *mnb;
    UITableView *_table;
    
    //loadData
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
    NSArray *_data;
    
    BOOL _stelect;
    int _pageNum;
    
    NSMutableArray *_dataArr;
    
    UIView *view1;
    UIView *view2;
    UISegmentedControl *segmentedControl;
    
    //NSDictionary *dicc;

    NSInteger Index;
    
    CGRect cgrect;
    
    NSDictionary *_dic3;

    


}

@end

@implementation paihangViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];

    
    
    self.view.backgroundColor =[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    _pageNum = 1;
    
    [self makeNav];
    
    [self table];
    
    [self loadData];
    [self view1];
    
    [_header free];
    [_footer free];

}

-(void)table
{
    if (Index == 0) {
        
        cgrect = CGRectMake(0, 40*screenWidth/320, self.view.frame.size.width,screenHeight-220*screenWidth/320);
        _table.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        cgrect = CGRectMake(0, 0.6, self.view.frame.size.width,screenHeight-0.6);
      _table.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    }
    
    _table = [[UITableView alloc]initWithFrame: cgrect style:UITableViewStylePlain] ;
    
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView=[[UIView alloc]init];
    _table.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    //
    //    //实例化header和footer
    //
    _header = [MJRefreshHeaderView header];
    //
    _header.scrollView = _table;
    //
    //    //设置header和footer的滚动视图位table
    //
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    //
    //    //设置header footer的代理
    //
    _header.delegate = self;
    _footer.delegate = self;

}


-(void)view1
{
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, screenWidth, screenHeight)];
    view1.backgroundColor   = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self.view addSubview:view1];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0 , screenWidth, 40*screenWidth/320)];
    
    view.backgroundColor = [UIColor blackColor];
    
    [view1 addSubview:view];
    
    UIView *lastView=[[UIView alloc] initWithFrame:CGRectMake(0,screenHeight-184*screenWidth/320, screenWidth, 80*screenWidth/320)];
    lastView.backgroundColor=[UIColor yellowColor];
    [view1 addSubview:lastView];
    
    if (_dataArr.count>0&&Index == 0) {
        
        UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 80*screenWidth/320)];
        view11.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
        
        [lastView addSubview:view11];
        
       // vieww =view11;
        
        
        //名次
        UILabel *rankNo = [[UILabel alloc] initWithFrame:CGRectMake(5*screenWidth/320, 30*screenWidth/320, 45*screenWidth/320, 20*screenWidth/320)];
        rankNo.textColor=[UIColor blackColor];
        rankNo.font=[UIFont systemFontOfSize:14*screenWidth/320];
        rankNo.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *dict = [_dataArr lastObject];
        NSLog(@"%%%%%%%%%%%%%%%%111111%@",dict);
        rankNo.text = [dict objectForKey:@"rankNo"];
        
        [view11 addSubview:rankNo];
        
        //头像
        User *user=[User currentUser];
        UIImageView *imageurl = [[UIImageView alloc]initWithFrame:CGRectMake(60*screenWidth/320, 10*screenWidth/320, 60*screenWidth/320, 60*screenWidth/320)];
        NSString *url =[NSString stringWithFormat:@"%@",user.headImage];
        
        if(url.length==0)
        {
            
            imageurl.image=[UIImage imageNamed:@"touxiang@2x.png"];
        }
        else
        {
            
            [imageurl  setImageWithURL:[NSURL URLWithString:url]];
        }
        
        NSLog(@"@@@@@@@@@@@@@@@@@@^^^^^^^^^^%@",url);
        
        
        [view11 addSubview:imageurl];
        
        //姓名
        UILabel * merName = [[UILabel alloc]initWithFrame:CGRectMake(130*screenWidth/320, 20*screenWidth/320, 180*screenWidth/320, 20*screenWidth/320)];
        
        merName.textColor = [UIColor blackColor];
        merName.font = [UIFont systemFontOfSize:14*screenWidth/320];
        
        merName.text = [dict objectForKey:@"merName"];
        [view11 addSubview:merName];
        
        //手机号
        
        UILabel *merMp = [[UILabel alloc]initWithFrame:CGRectMake(130*screenWidth/320, 45*screenWidth/320, 120*screenWidth/320, 20*screenWidth/320)];
        merMp.text = [dict objectForKey:@"merMp"];
        merMp.font = [UIFont systemFontOfSize:14*screenWidth/320];
        [view11 addSubview:merMp];
        
        //积分
        
        UILabel *transAmt = [[UILabel alloc]initWithFrame:CGRectMake(250*screenWidth/320, 30*screenWidth/320, 60*screenWidth/320, 20*screenWidth/320)];
        transAmt.textColor=[UIColor blackColor];
        transAmt.textAlignment=NSTextAlignmentRight;
        transAmt.text = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"transAmt"] intValue]];
        transAmt.font=[UIFont systemFontOfSize:14*screenWidth/320];
        [view11 addSubview:transAmt];
        
        
    }
    
    else
    {
        
        lastView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }

    
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0,screenHeight-104*screenWidth/320.0, screenWidth, 40*screenWidth/320.0)];
    
    footview.backgroundColor = [UIColor grayColor];
    
    [view1 addSubview:footview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*screenWidth/320.0, screenWidth, 15*screenWidth/320.0)];
    label.text = @"每月前10名将获得神秘礼品!";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    //    label.backgroundColor = [UIColor yellowColor];
    label.font = [UIFont systemFontOfSize:16*screenWidth/320.0];
    
    [footview addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20*screenWidth/320, screenWidth, 15*screenWidth/320)];
    
    btn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [btn addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:btn];
    for (int i = 0; i < 3; ++i) {
        NSArray *array = @[@"排名",@"姓名/电话",@"当月积分"];
        UILabel *pai = [[UILabel alloc]initWithFrame:CGRectMake((10+i*108)*screenWidth/320, 10*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
        
        pai.textColor = [UIColor whiteColor];
        //        pai.backgroundColor = [UIColor   redColor];
        pai.text = array[i];
        
        if (i == 2) {
            
            pai.textAlignment = NSTextAlignmentRight;
        }
        [view1 addSubview:pai];
    }
    
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引

    //设置代理
    for (int i = 0; i < 3; ++i) {
        
        NSArray *array = @[@"diyi",@"dier",@"disan"];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10*screenWidth/320, (3+35*i)*screenWidth/320, 30*screenWidth/320,30*screenWidth/320)];
        image.image = [UIImage imageNamed:array[i]];
        [_table addSubview:image];
        
    }
    
    //禁止table滑动
    
    
    //    _table.scrollEnabled =NO;
    
    [view1 addSubview:_table];

    
}


-(void)touch

{
    xiangqingViewController *xiang = [[xiangqingViewController alloc]init];
    [self.navigationController pushViewController:xiang animated:YES];
}


-(void)view2
{
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, screenWidth, screenHeight)];
    
    view2.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
    [self.view addSubview:view2];
    
    segmentedControl.selectedSegmentIndex = 1;//设置默认选择项索引
    
    [view2 addSubview:_table];
    
}


-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:nil andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
    //  UIView *
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"排行榜",@"积分详情",nil];
    //
    //    //初始化UISegmentedControl
    //
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    //
    segmentedControl.frame = CGRectMake(screenWidth/4, 25*screenWidth/320, 165*screenWidth/320, 30*screenWidth/320);
    //
    
    
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    //
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    
    
   // segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    //设置样式
    
    [self.view addSubview:segmentedControl];
    
    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(180, 50, 120, 200)];
//    
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    [_table reloadData];
 
    Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li", (long)Index);
    
    switch (Index) {
            
        case 0:
            
            [_dataArr removeAllObjects];

            
            [self loadData];


            [self table];
          
            [self view1];
            
            [_header free];
            [_footer free];
            
            
            if (_dataArr.count<1) {
                
                [_table removeFromSuperview];
                
            }

            
            break;
            
        case 1:
            [_dataArr removeAllObjects];
            
            [self loadData];

            [self table];
        
            [self view2];

            [_header free];
            [_footer free];
            
            break;
            }
}



-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)loadData

{
    
    User *user=[User currentUser];

    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-90*24*60*60];
    _formatter=[[NSDateFormatter alloc]init];
    _formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [_formatter setTimeZone:nowZone];
    _timeStr=[_formatter stringFromDate:date];
    NSLog(@"========================%@",_timeStr);
    
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone1=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:nowZone1];
    _timeStr1=[formatter stringFromDate:nowDate];
    NSLog(@"------------------------%@",_timeStr1);
//    
    NSString *a=[NSString stringWithFormat:@"%d",_pageNum];
//
    NSLog(@"------------------------+++++++++%@",a);
    NSMutableURLRequest *rever;

    
    if (Index == 0 ) {
        
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url39 andKeyArr:nil andValueArr:nil];
        
    }
    else
    {
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url12 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
        
    }
   
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
     NSLog(@"------------------------%@",dic);
    //
    if(![[dic objectForKey:@"respCode"] isEqual:@"000"])
    {
        [self toastResult:[dic objectForKey:@"respDesc"]];
        return;
    }
    else
    {
        _data=[dic objectForKey:@"ordersInfo"];
        for(NSDictionary *dicc in _data)
        {
            [_dataArr addObject:dicc];
            NSLog(@"ddddddddd%@",dicc );
            NSLog(@"Eeeeeeee%@",_dataArr);
        }
    }
   
    
    NSLog(@"777eygeyfgggihdihdhh5%@",_dataArr);
    [_table reloadData];
    
    
    if (_dataArr.count <1&&Index == 1) {
        
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有积分记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alat show];
        
    }
}

//table  从头开始
#pragma mark tableview从头开始

-(void)viewDidLayoutSubviews {
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_table respondsToSelector:@selector(setLayoutMargins:)])  {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (Index == 0) {
        
        if (indexPath.row %2 == 1) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];

        }
        
        
    }
    
}



#pragma mark tableview 的代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger i;
    
    if (Index == 0) {
        
       i =  _dataArr.count-1;
        

    }
    else
    {
        i = _dataArr.count;
        
    }
    return i;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
//    
    int  i ;
    
    if (Index == 0) {
       i = 35;
    }
    else
    {
        i = 55 ;
    }
//
    return  i*screenWidth/320;
}

//展现cell内容

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str=@"iden";
    
    paihangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[paihangTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    
    NSLog(@"$$$$$$$$$$$$$%ld",(long)Index);
    
    
    if (Index == 0) {
        
        cell.merId.text=_dataArr[indexPath.row][@"merId"];
        
        cell.merName.text=_dataArr[indexPath.row][@"merName"];
        NSString *ming = [cell.merName.text substringToIndex:1];
        
        
        cell.merMp.text=_dataArr[indexPath.row][@"merMp"];
        NSString*before=[cell.merMp.text substringToIndex:3];
        
        NSString*after=[cell.merMp.text substringFromIndex:7];
        
        cell.merMp.text = [[NSString alloc] initWithFormat:@"%@****%@", before, after];
        
        cell.merName.text = [[NSString alloc]initWithFormat:@"%@*",ming];
        
        cell.rankNo.text = _dataArr[indexPath.row][@"rankNo"];
        
        NSString *trans = _dataArr[indexPath.row][@"transAmt"];
        
        int i = [trans intValue];
        
        cell.transAmt.text = [NSString stringWithFormat:@"%d",i];
        
        
    }
    else
    {
            cell.transDate.text=_dataArr[indexPath.row][@"transDate"];
            
            NSRange range1=NSMakeRange(0, 4);
            NSRange range2=NSMakeRange(4, 2);
            NSRange range3=NSMakeRange(6, 2);
            NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[cell.transDate.text substringWithRange:range1],[cell.transDate.text substringWithRange:range2],[cell.transDate.text substringWithRange:range3]];
            //cell.transDate.text=string1;
            
            cell.transTime.text=_dataArr[indexPath.row][@"transTime"];
            NSRange ran1=NSMakeRange(0, 2);
            NSRange ran2=NSMakeRange(2, 2);
            NSRange ran3=NSMakeRange(4, 2);
            NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[cell.transTime.text substringWithRange:ran1],[cell.transTime.text substringWithRange:ran2],[cell.transTime.text substringWithRange:ran3]];
            //cell.transTime.text=string2;
        cell.transDate.text=[NSString stringWithFormat:@"%@ %@",string1,string2];
        
            cell.scoreOrdId.text=_dataArr[indexPath.row][@"scoreOrdId"];
            cell.scoreSrc.text=_dataArr[indexPath.row][@"scoreSrc"];
            //cell.transAmt.text=_dataArr[indexPath.row][@"transAmt"];
            //去掉小数点的办法
            int a = [_dataArr[indexPath.row][@"transAmt"] intValue];
            cell.transAmt.text=[NSString stringWithFormat:@"%d",a];
            
            NSLog(@"hahahahhaaaaaaaaaaaa");
        }

//    cell.backgroundColor = [UIColor redColor];
    return cell;
}


#pragma mark footerview
/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 80*screenWidth/320;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *vieww;
    
    if (_dataArr.count>0&&Index == 0) {
        
        UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 60*screenWidth/320)];
        view11.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
        
        [_table addSubview:view11];
        
        vieww =view11;
        
        
        //名次
        UILabel *rankNo = [[UILabel alloc] initWithFrame:CGRectMake(5*screenWidth/320, 30*screenWidth/320, 45*screenWidth/320, 20*screenWidth/320)];
        rankNo.textColor=[UIColor blackColor];
        rankNo.font=[UIFont systemFontOfSize:14*screenWidth/320];
        rankNo.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *dict = [_dataArr lastObject];
        NSLog(@"%%%%%%%%%%%%%%%%111111%@",dict);
        rankNo.text = [dict objectForKey:@"rankNo"];
        
        [view11 addSubview:rankNo];
        
        //头像
        
        UIImageView *imageurl = [[UIImageView alloc]initWithFrame:CGRectMake(60*screenWidth/320, 10*screenWidth/320, 60*screenWidth/320, 60*screenWidth/320)];
        
        NSString *url = [[NSUserDefaults standardUserDefaults]objectForKey:@"faceImageUrl"];
        
        if([url isEqualToString:@""])
        {
            
            imageurl.image=[UIImage imageNamed:@"bj_touxiang.png"];
        }
        else
        {

        [imageurl  setImageWithURL:[NSURL URLWithString:url]];
        }
        
        NSLog(@"@@@@@@@@@@@@@@@@@@^^^^^^^^^^%@",url);

        
        [view11 addSubview:imageurl];
        
        //姓名
        UILabel * merName = [[UILabel alloc]initWithFrame:CGRectMake(130*screenWidth/320, 20*screenWidth/320, 180*screenWidth/320, 20*screenWidth/320)];
        
        merName.textColor = [UIColor blackColor];
        merName.font = [UIFont systemFontOfSize:14*screenWidth/320];
        
        merName.text = [dict objectForKey:@"merName"];
        
//        merName.backgroundColor = [UIColor yellowColor];
        [view11 addSubview:merName];
        
        //手机号
        
        UILabel *merMp = [[UILabel alloc]initWithFrame:CGRectMake(130*screenWidth/320, 45*screenWidth/320, 120*screenWidth/320, 20*screenWidth/320)];
        merMp.text = [dict objectForKey:@"merMp"];
        merMp.font = [UIFont systemFontOfSize:14*screenWidth/320];
        [view11 addSubview:merMp];
        
        //积分
        
        UILabel *transAmt = [[UILabel alloc]initWithFrame:CGRectMake(250*screenWidth/320, 30*screenWidth/320, 60*screenWidth/320, 20*screenWidth/320)];
        transAmt.textColor=[UIColor blackColor];
        transAmt.textAlignment=NSTextAlignmentRight;
        transAmt.text = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"transAmt"] intValue]];
        transAmt.font=[UIFont systemFontOfSize:14*screenWidth/320];
        [view11 addSubview:transAmt];

        
    }
    
    else
    {
        
        UIView *view12 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_table addSubview:view12];
       
        vieww = view12;
        
    }
    return vieww;
}
*/
#pragma mark MJ 的代理

//开始的代理

//-refreshviewbegin

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if(refreshView == _header)
    {
        
        [_dataArr removeAllObjects];
        [self loadData];
    }
    else
    {
        
        [_dataArr removeAllObjects];
        [self loadData];
        
    }
    
    [refreshView endRefreshing];
    //结束刷新，归位
}
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
