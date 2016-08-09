//
//  ZhuanZhangJLViewController.m
//  JYBF
//
//  Created by 王健超 on 15/10/23.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ZhuanZhangJLViewController.h"
#import "zzjlTableViewCell.h"
#import "UIButton+myButton.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"

@interface ZhuanZhangJLViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableview;
    NSMutableArray *_dataArray;
    int _pageNum;
    
    NSArray *_data;
    NSDictionary *dicc;

    UIButton *_button1;
    
    UIButton *_button2;
    
    BOOL _stelect;
    
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
}


@end

@implementation ZhuanZhangJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stelect = YES;
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    _pageNum=1;
    [self LoadData];
    [self makeNav];
    [self makeUI];
    [self makebutton];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20, 320*screenWidth/320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"转账记录" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    _tableview= [[UITableView alloc] initWithFrame:CGRectMake(0, 114, screenWidth, self.view.frame.size.height-114) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableview];
    
    //实例化header和footer
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableview;
    //设置header和footer的滚动视图为table
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableview;
    //设置header和footer的代理
    _header.delegate = self;
    _footer.delegate = self;
//
    
    
    //全部收款和成功交易之间的竖线
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-1, 64, 1, 50)];
    view.backgroundColor=[UIColor grayColor];
    [self.view addSubview:view];
    
    //全部收款和成功交易底部的竖线
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0,114, self.view.frame.size.width, 1)];
    view1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view1];
    

}
//网络请求
-(void)LoadData
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
    
    NSMutableURLRequest *rever;
    
    if (_stelect) {
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url36 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"trfType",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,@"I",[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
        
    }
    else
    {
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url36 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"trfType",@"pageNum",@"pageSize",@"transStat"]andValueArr:@[user.merid,_timeStr,_timeStr1,@"O",[NSString stringWithFormat:@"%d",_pageNum],@"12",@"S"]];
    }
    //
    
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    _data=[dic objectForKey:@"ordersInfo"];
    for(dicc in _data)
    {
        
        [_dataArray addObject:dicc];
        
    }
    
    NSLog(@"------------------------%@",dic);
    [_tableview reloadData];
    if(_dataArray.count<1)
    {
        if(_stelect==YES)
        {
            UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有转入记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alat show];
            
            return;

        }
        else
        {
            UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有转出记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alat show];
            
            return;

        }
    }
    
}

//每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50*screenWidth/320.0;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str=@"iden";
    
    zzjlTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil) {
        cell=[[zzjlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }

    NSRange range1=NSMakeRange(0, 4);
    NSRange range2=NSMakeRange(4, 2);
    NSRange range3=NSMakeRange(6, 2);
    NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[_dataArray[indexPath.row][@"createDate"] substringWithRange:range1],[_dataArray[indexPath.row][@"createDate"] substringWithRange:range2],[_dataArray[indexPath.row][@"createDate"] substringWithRange:range3]];
    //    //    cell.createDate.text=string1;
    //
    //
    //    cell.createTime.text=_dataArr[indexPath.row][@"createTime"];
    //
    NSRange ran1=NSMakeRange(0, 2);
    NSRange ran2=NSMakeRange(2, 2);
    NSRange ran3=NSMakeRange(4, 2);
    //    //    NSLog(@"%@",ran2);
    NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_dataArray[indexPath.row][@"createTime"] substringWithRange:ran1],[_dataArray[indexPath.row][@"createTime"] substringWithRange:ran2],[_dataArray[indexPath.row][@"createTime"] substringWithRange:ran3]];
    //    //cell.createTime.text=string2;
    NSString *timeStr=[NSString stringWithFormat:@"%@ %@",string1,string2];
    cell.timeString.text=timeStr;
    //    NSLog(@"输出时间为%@",timeString);
    //
    cell.numString.text=_dataArray[indexPath.row][@"transAmt"];
    cell.nameString.text=_dataArray[indexPath.row][@"MerName"];
    
    NSString*before=[_dataArray[indexPath.row][@"merMp"] substringToIndex:3];
    
    NSString*after=[_dataArray[indexPath.row][@"merMp"] substringFromIndex:7];
    
    cell.telString.text = [[NSString alloc] initWithFormat:@"(%@****%@)", before, after];
    
    return cell;
    
}
//两个按钮
-(void)makebutton
{
    _button1 =[UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame=CGRectMake(0, 64, screenWidth/2, 50);
    //   [_button1 setTitle:@"" forState:UIControlStateNormal];
    [_button1 makeUI:@"转入" :YES];
    
    [_button1  addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    
    
    _button2 =[UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame=CGRectMake(screenWidth/2, 64, screenWidth/2, 50);
    [_button2 makeUI:@"转出" :NO];
    
    [_button2  addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    
}
-(void)viewDidLayoutSubviews {
    
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark MJ的代理
//开始的代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //在这里开始网络请求
    if(refreshView == _header)
    {
        
        _pageNum=1;
        [_dataArray removeAllObjects];
        [self LoadData];
    }
    else
    {
        _pageNum+=1;
        
        [self LoadData];
        
    }
    [refreshView endRefreshing];//结束刷新，归位
    
    
}
- (void)dealloc
{
    [_header free];
    [_footer free];
}


//全部显示按钮
-(void)btn:(UIButton*)btndown
{
    
    
    [_dataArray removeAllObjects];
    
    if (btndown==_button1) {
        _stelect = YES;
        _pageNum =1;
        
        [_button1 makeUI:@"转入" :YES];
        [_button2 makeUI:@"转出" :NO];
        
    }
    else
    {
        
        _stelect = NO;
        _pageNum =1;
        
        [_button1 makeUI:@"转入" :NO];
        [_button2 makeUI:@"转出" :YES];
    
    }
    [self LoadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
